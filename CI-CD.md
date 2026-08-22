# CI/CD Pipeline — Capitec Appointment Booking System

## Overview

The pipeline follows a **Build Once, Promote Through Environments** pattern. A Docker image is built exactly once (tagged with the immutable Git commit SHA), validated, then promoted through staging → production. No rebuilds happen at the deployment stage.

```
PR / Push
   │
   ├─ quality-backend ─┐
   │  (JUnit + JaCoCo) │
   │                   ├─ build-and-push ──► deploy-staging ──► smoke-test ──► deploy-production
   ├─ quality-frontend ┘  (Docker → GHCR)    (SSH rolling)      (HTTP checks)   (manual approval)
   │  (Lint + TS + Vitest)
   │
   └─ security.yml (separate workflow — CodeQL + OWASP + Trivy)
```

---

## Workflow Files

| File | Trigger | Purpose |
|------|---------|---------|
| `.github/workflows/ci.yml` | Push to `main`/`develop`, all PRs | Main pipeline: quality → build → deploy |
| `.github/workflows/security.yml` | Push to `main`/`develop`, weekly Monday 02:00 UTC | SAST (CodeQL), OWASP dependency check, Trivy repo scan |
| `.github/workflows/rollback.yml` | Manual (`workflow_dispatch`) | Roll back staging or production to any prior image tag |
| `.github/workflows/gradle.yml` | Push to `main` | GitHub Dependency Graph submission (unchanged) |

---

## Stage Details

### Stage 1 — Quality Gates (parallel)

Both jobs must pass before any image is built.

**Backend (`quality-backend`)**
- Compiles and runs all JUnit tests with Spring profile `test` (H2 in-memory DB — no external dependencies)
- Generates JaCoCo HTML + XML coverage reports
- Enforces **80% minimum coverage** via `jacocoTestCoverageVerification` — the build fails below this threshold

**Frontend (`quality-frontend`)**
- `npm ci` with lockfile verification
- ESLint lint check
- `tsc --noEmit` TypeScript type check
- Vitest test suite with coverage report

### Stage 2 — Build & Push (branch pushes only, not PRs)

- Uses `docker/build-push-action` with **BuildKit** and **GHA layer cache** for fast rebuilds
- Produces **two immutable images** (backend + frontend), each tagged:
  - `sha-<full-git-sha>` — the primary promotion tag used in deployments
  - `<branch-name>` — for human-readable tracing
  - `latest` — only on `main` branch
  - `<semver>` — when a `v*.*.*` tag is pushed
- Attaches **SBOM** and **provenance attestation** to each image (OCI compliant)
- Runs **Trivy** on the backend image and uploads results to the GitHub Security tab (non-blocking)

### Stage 3 — Deploy to Staging

- Runs on pushes to both `main` and `develop`
- SSHs to the staging server and:
  1. Pre-pulls the new images (current containers keep running during pull)
  2. Updates `.deployed-tag` on the server for rollback reference
  3. Runs `docker compose up -d --no-build --remove-orphans` — Docker performs a rolling restart
  4. Polls `docker compose ps backend` until the container reports `(healthy)` (max 120s)
- Followed immediately by `smoke-test-staging`

### Stage 4 — Deploy to Production

- Runs only on pushes to `main`, after the staging smoke test passes
- **Requires manual approval**: configure the `production` GitHub Environment with required reviewers (see setup below)
- Identical rolling-update process to staging, with 180s health-check timeout
- Runs `scripts/smoke-test.sh` against the production URL post-deploy
- **Auto-rollback**: if the deploy step or post-deploy smoke test fails, the pipeline immediately re-deploys the previous image tag stored in `.previous-tag` on the server

---

## Secrets & Variables Setup

Go to **Repository → Settings → Secrets and variables → Actions** and configure:

### Secrets (encrypted, never logged)

| Secret name | Description |
|-------------|-------------|
| `STAGING_HOST` | Hostname or IP of the staging server |
| `STAGING_USER` | SSH username on the staging server |
| `STAGING_SSH_KEY` | Private SSH key for staging (Ed25519 recommended) |
| `STAGING_DB_USER` | PostgreSQL username for staging |
| `STAGING_DB_PASSWORD` | PostgreSQL password for staging |
| `STAGING_JWT_SECRET` | JWT signing secret for staging (≥256-bit / 32+ chars) |
| `PROD_HOST` | Hostname or IP of the production server |
| `PROD_USER` | SSH username on the production server |
| `PROD_SSH_KEY` | Private SSH key for production |
| `PROD_DB_USER` | PostgreSQL username for production |
| `PROD_DB_PASSWORD` | PostgreSQL password for production |
| `PROD_JWT_SECRET` | JWT signing secret for production (≥256-bit / 32+ chars) |
| `NVD_API_KEY` | *(Optional)* NVD API key to avoid rate limiting in OWASP dependency checks. Get one at https://nvd.nist.gov/developers/request-an-api-key |

### Variables (non-sensitive, visible in logs)

| Variable name | Example value | Description |
|---------------|--------------|-------------|
| `STAGING_URL` | `https://staging.capitec-booking.example.com` | Base URL used for smoke tests and environment link |
| `STAGING_CORS_ORIGINS` | `https://staging.capitec-booking.example.com` | CORS allowed origins injected into the Spring app |
| `PRODUCTION_URL` | `https://booking.capitec.co.za` | Base URL used for smoke tests and environment link |
| `PROD_CORS_ORIGINS` | `https://booking.capitec.co.za` | CORS allowed origins for production |

### GitHub Environments

Create two Environments under **Repository → Settings → Environments**:

1. **`staging`** — no protection rules needed; auto-deploys on every push to `main`/`develop`
2. **`production`** — add **Required reviewers** (e.g., yourself or your team lead); the deploy job pauses and waits for approval before running

---

## Server Setup

Each deployment server needs:

```bash
# Docker + Docker Compose plugin
curl -fsSL https://get.docker.com | sh
apt-get install docker-compose-plugin   # or equivalent

# GHCR login (run once; credentials cached in ~/.docker/config.json)
echo "<GITHUB_PAT>" | docker login ghcr.io -u <github-username> --password-stdin

# Project directory with compose files
mkdir -p /opt/capitec-booking
cd /opt/capitec-booking
# Copy docker-compose.yml, docker-compose.staging.yml (or docker-compose.prod.yml)
```

The SSH key added to GitHub secrets must correspond to an authorized public key in `~/.ssh/authorized_keys` on each server.

---

## Running Tests Locally

### Backend

```bash
# All tests + coverage report (opens in build/reports/jacoco/test/html/index.html)
./gradlew test jacocoTestReport

# Enforce the 80% threshold (same check the CI runs)
./gradlew jacocoTestCoverageVerification
```

### Frontend

```bash
cd frontend

npm ci
npm run lint          # ESLint
npx tsc --noEmit      # TypeScript type check
npm run test          # Vitest (single run)
npm run test:coverage # Vitest with coverage (opens coverage/index.html)
```

### Full stack locally

```bash
# Requires Docker; builds from source
docker compose up --build

# Or pull from GHCR (replace sha-... with any pushed tag)
IMAGE_TAG=sha-<commit-sha> \
BACKEND_IMAGE=ghcr.io/<owner>/capitec-booking-backend \
FRONTEND_IMAGE=ghcr.io/<owner>/capitec-booking-frontend \
POSTGRES_USER=capitec \
POSTGRES_PASSWORD=capitec123 \
JWT_SECRET=dev-only-secret-key-that-is-at-least-256-bits-long \
CORS_ALLOWED_ORIGINS=http://localhost:80 \
docker compose -f docker-compose.yml -f docker-compose.staging.yml up -d
```

---

## Manual Promotion / Rollback

### Promote a specific tag to production

Trigger a new deployment by pushing a tag:

```bash
git tag v1.2.3
git push origin v1.2.3
```

The pipeline will build an image tagged `v1.2.3` and go through the full quality → staging → (approval) → production flow.

### Roll back via GitHub UI

1. Go to **Actions → Manual Rollback**
2. Click **Run workflow**
3. Choose the environment (`production` or `staging`)
4. Enter the image tag to roll back to (e.g. `sha-abc1234...`), or leave blank to use the last known-good tag stored on the server
5. Click **Run**

The rollback workflow re-runs smoke tests after restoring the previous image.

---

## Security Analysis

The `security.yml` workflow runs:

- **CodeQL** (Java + JavaScript/TypeScript): finds injection flaws, insecure deserialization, XSS patterns, and other OWASP Top 10 issues. Results appear in the **Security → Code scanning** tab.
- **OWASP Dependency Check**: scans JAR and npm dependencies against the NVD CVE database. Fails the build on CVSS ≥ 9 (critical). HTML report uploaded as a workflow artifact.
- **Trivy (filesystem)**: scans for secrets committed to the repository, misconfigurations, and vulnerable packages. Results appear in the Security tab.

These run weekly and on every push to `main`/`develop` so newly disclosed CVEs are caught promptly without blocking every PR.
