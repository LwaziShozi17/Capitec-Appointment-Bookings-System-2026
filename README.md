# Capitec Appointment Booking System

A full-stack appointment booking system that lets Capitec Bank customers schedule in-branch appointments online and allows staff admins to manage the full appointment lifecycle.

---

## Quick Start — Docker

> The fastest way to run the full stack (PostgreSQL + Spring Boot backend + React frontend) is with Docker Compose. No Java or Node.js install required.

### Step 1 — Clone and enter the project

```bash
git clone https://github.com/LwaziShozi17/Capitec-Appointment-Bookings-System-2026-2026.git
cd Capitec-Appointment-Bookings-System-2026-2026
```

### Step 2 — Build and start all containers

```bash
docker compose up --build
```

Docker will build the backend image (multi-stage, JRE runtime), the frontend image (Node build → Nginx), and pull the PostgreSQL image, then wire them all together.

### Step 3 — Open the app

| Service | URL |
|---|---|
| **Frontend** | http://localhost |
| **Backend API** | http://localhost:8080 |
| **Swagger UI** | http://localhost:8080/swagger-ui.html |
| **Health Check** | http://localhost:8080/actuator/health |

### Stop and remove containers

```bash
docker compose down
```

To also delete the PostgreSQL data volume:

```bash
docker compose down -v
```

---

### Build and run images individually (without Compose)

If you need to build or run a single image in isolation:

**Backend**

```bash
# Build
docker build -t capitec-booking-backend:local .

# Run (requires a running PostgreSQL instance)
docker run -p 8080:8080 \
  -e SPRING_PROFILES_ACTIVE=prod \
  -e SPRING_DATASOURCE_URL=jdbc:postgresql://host.docker.internal:5432/capitec_booking \
  -e SPRING_DATASOURCE_USERNAME=capitec \
  -e SPRING_DATASOURCE_PASSWORD=capitec123 \
  -e JWT_SECRET=change-me-minimum-32-characters-long \
  capitec-booking-backend:local
```

**Frontend**

```bash
# Build
docker build -t capitec-booking-frontend:local ./frontend

# Run (proxies /api requests to the backend)
docker run -p 80:80 capitec-booking-frontend:local
```

---

## Demo Login Credentials

Two accounts are seeded automatically on first startup:

| Role | Email | Password |
|---|---|---|
| **Admin** | `admin@capitec.co.za` | `Admin@123` |
| **Customer** | `user@capitec.co.za` | `User@123` |

- The **Admin** account has access to the `/admin` dashboard and all `PATCH /api/v1/admin/...` endpoints.
- The **Customer** account can browse branches, book appointments, and view their booking history.

---

## Architecture

```
┌─────────────────┐     ┌──────────────────┐     ┌────────────┐
│  React Frontend │────▶│  Spring Boot API  │────▶│ PostgreSQL │
│  (Vite + TS)    │     │  (REST + JWT)     │     │            │
└─────────────────┘     └──────────────────┘     └────────────┘
```

In development the backend uses an **H2 in-memory database** — no PostgreSQL install needed.

## Features

- **User Authentication** — JWT login/registration with BCrypt hashing and account lockout after 5 failed attempts
- **45 Real Branches** — All 9 South African provinces seeded with real branch names, addresses, and GPS coordinates
- **3-Step Booking Flow** — Select service → choose date/time slot → enter details
- **Admin Dashboard** — Confirm, start, complete, or cancel appointments; generate time slots for any branch
- **Slot Generation** — Auto-generates 30-minute slots from branch operating hours; respects SA public holidays
- **Rate Limiting** — 5 auth requests per minute per IP to block brute-force attacks
- **Audit Trail** — Every login, registration, and admin action is logged to a dedicated security audit logger
- **CI/CD Pipeline** — GitHub Actions: test → Docker build → staging deploy → manual gate → production deploy → auto-rollback

## Tech Stack

### Backend
| Technology | Version |
|---|---|
| Java | 17 |
| Spring Boot | 4.0.6 |
| Spring Security + JWT (jjwt) | 0.12.6 |
| Spring Data JPA + PostgreSQL | latest |
| H2 Database (dev/test) | latest |
| SpringDoc OpenAPI (Swagger UI) | 2.8.6 |
| Spring Boot Actuator | included |
| JaCoCo (minimum coverage gate) | **80%** |

### Frontend
| Technology | Version |
|---|---|
| React | 19 |
| TypeScript | 6 |
| Vite | 8 |
| Tailwind CSS | 4 |
| React Router | 7 |
| Axios | 1.x |
| Vitest + Testing Library | 4.x |

### Infrastructure
- Docker multi-stage builds (JRE-only runtime image, non-root user, ARM64 + amd64)
- Single Docker Compose file for local and CI/CD deployments
- GitHub Actions CI/CD with staging + production environments
- Nginx reverse proxy with SPA routing and API proxying

---

## Getting Started

### Prerequisites

- **Java 17** — [Download](https://adoptium.net/)
- **Node.js 20+** — [Download](https://nodejs.org/)
- **Docker Desktop or Rancher Desktop** *(only needed for the Docker option)* — [Docker Desktop](https://www.docker.com/products/docker-desktop/) / [Rancher Desktop](https://rancherdesktop.io/)

---

## Option 1 — Run with Docker Compose (Full Stack)

This starts PostgreSQL, the Spring Boot backend, and the React frontend all together.

**Step 1 — Copy the environment file:**
```bash
cp .env.example .env
```

**Step 2 — Open `.env` and set a real JWT secret (minimum 32 characters):**
```
JWT_SECRET=your-very-long-and-secret-key-minimum-32-chars
POSTGRES_USER=capitec
POSTGRES_PASSWORD=capitec123
```

**Step 3 — Build and start all services:**
```bash
docker compose up --build
```

**Step 4 — Open the app:**

| Service | URL |
|---|---|
| Frontend | http://localhost |
| Backend API | http://localhost:8080 |
| Swagger UI | http://localhost:8080/swagger-ui.html |
| Health Check | http://localhost:8080/actuator/health |

**Stop the stack:**
```bash
docker compose down
```

---

## Option 2 — Run Locally (Hot Reload)

This is the recommended way to develop. The backend uses an H2 in-memory database — no PostgreSQL or Docker needed.

### Step 1 — Start the Backend

```bash
./gradlew bootRun
```

> On Windows, use `gradlew.bat bootRun`

The backend starts on `http://localhost:8080`.  
The H2 database is seeded automatically on first run.

**Verify it's running:**
```bash
curl http://localhost:8080/actuator/health
# Expected: {"status":"UP"}
```

Swagger UI is available at: http://localhost:8080/swagger-ui.html  
H2 Console (browse the in-memory database): http://localhost:8080/h2-console

> H2 console settings: JDBC URL = `jdbc:h2:mem:capitec_booking`, username = `sa`, password = *(leave blank)*

### Step 2 — Start the Frontend

Open a second terminal:

```bash
cd frontend
npm install
npm run dev
```

The frontend starts on `http://localhost:5173`.  
The Vite dev server proxies all `/api/v1` requests to the backend on port 8080.

---

## Demo Accounts

Two accounts are seeded automatically when the app starts:

| Role | Email | Password |
|---|---|---|
| Admin | `admin@capitec.co.za` | `Admin@123` |
| Customer | `user@capitec.co.za` | `User@123` |

The admin account can access `/admin` in the UI and all `PATCH /api/v1/admin/...` endpoints.

---

## Running Tests

### Backend Tests

```bash
./gradlew test
```

This runs the full test suite and generates a JaCoCo coverage report. The build **fails** if coverage drops below 80%.

**View the HTML coverage report:**
```
open build/reports/jacoco/test/html/index.html
```

**Run tests + enforce the 80% coverage gate:**
```bash
./gradlew test jacocoTestReport jacocoTestCoverageVerification
```

### Frontend Tests

```bash
cd frontend
npm test
```

**With coverage report:**
```bash
npm run test:coverage
```

```
open frontend/coverage/index.html
```

---

## API Reference

Interactive docs are available at `/swagger-ui.html`. Below is a quick reference:

### Authentication (public)

| Method | Path | Description |
|---|---|---|
| `POST` | `/api/v1/auth/register` | Create a new user account, returns JWT |
| `POST` | `/api/v1/auth/login` | Authenticate, returns JWT |

### Branches & Services (public)

| Method | Path | Description |
|---|---|---|
| `GET` | `/api/v1/branches` | List all 45 branches with operating hours |
| `GET` | `/api/v1/branches/{id}` | Get a single branch |
| `GET` | `/api/v1/services` | List all 8 service types |

### Slots & Appointments (authenticated)

| Method | Path | Description |
|---|---|---|
| `GET` | `/api/v1/slots?branchId=&date=` | Available time slots for a branch on a date |
| `POST` | `/api/v1/appointments` | Book an appointment |
| `GET` | `/api/v1/appointments/my` | List the current user's appointments |
| `GET` | `/api/v1/appointments/{id}` | Get one appointment (owner only) |
| `DELETE` | `/api/v1/appointments/{id}` | Cancel an appointment (owner only) |

### Admin (ADMIN role required)

| Method | Path | Description |
|---|---|---|
| `GET` | `/api/v1/admin/appointments` | List all appointments (optional `?status=` filter) |
| `PATCH` | `/api/v1/admin/appointments/{id}/confirm` | Advance status: `PENDING → CONFIRMED` |
| `PATCH` | `/api/v1/admin/appointments/{id}/start` | Advance status: `CONFIRMED → IN_PROGRESS` |
| `PATCH` | `/api/v1/admin/appointments/{id}/complete` | Advance status: `IN_PROGRESS → COMPLETED` |
| `PATCH` | `/api/v1/admin/appointments/{id}/cancel` | Cancel any appointment |
| `POST` | `/api/v1/admin/slots/generate?branchId=&startDate=&endDate=` | Generate 30-min slots for a date range |

---

## Project Structure

```
├── src/main/java/com/capitec/booking/
│   ├── Application.java         # Spring Boot entry point
│   ├── config/                  # SecurityConfig, CorsConfig, OpenApiConfig, DataLoader
│   ├── controller/              # REST endpoints (Auth, Branch, Service, Slot, Appointment, Admin)
│   ├── domain/
│   │   ├── model/               # JPA entities: User, Branch, AppointmentSlot, Appointment, ...
│   │   └── enums/               # Role, AppointmentStatus, SlotStatus
│   ├── dto/
│   │   ├── request/             # BookingRequest, LoginRequest, RegisterRequest
│   │   └── response/            # AppointmentResponse, AuthResponse, BranchResponse, SlotResponse
│   ├── exception/               # GlobalExceptionHandler + custom exceptions
│   ├── mapper/                  # AppointmentMapper (entity → DTO)
│   ├── repository/              # Spring Data JPA interfaces
│   ├── security/                # JwtService, JwtAuthenticationFilter, RateLimitFilter, AuditLogger
│   └── service/                 # AppointmentService, AuthService, BranchService, SlotGenerationService, SlotService
│
├── src/main/resources/
│   ├── application.properties   # Activates 'dev' profile by default
│   ├── application-dev.yml      # H2 in-memory, H2 console enabled, data.sql seed enabled
│   ├── application-prod.yml     # PostgreSQL, reads credentials from environment variables
│   └── data.sql                 # Seed: 45 branches, 8 services, 12 SA holidays, demo slots & appointments
│
├── src/test/                    # JUnit 5 tests (controller, service, security, integration)
│
├── frontend/
│   ├── src/
│   │   ├── App.tsx              # Router root + context providers
│   │   ├── main.tsx             # React entry point
│   │   ├── index.css            # Tailwind import + design token variables
│   │   ├── pages/               # HomePage, LoginPage, RegisterPage, BranchesPage, BookingPage, AppointmentsPage, AdminPage
│   │   ├── components/          # Layout, ProtectedRoute, ErrorBoundary, ui/ (ConfirmModal, Skeleton, StatCard)
│   │   ├── context/             # AuthContext (JWT auth state), ToastContext (notifications)
│   │   ├── services/            # api.ts (Axios + interceptors), tokenStore.ts (in-memory JWT)
│   │   ├── types/               # TypeScript interfaces for all API shapes
│   │   └── test/                # Vitest + React Testing Library tests
│   ├── public/                  # favicon.svg, icons.svg
│   ├── Dockerfile               # Multi-stage: Node build → Nginx serve
│   └── nginx.conf               # SPA routing (try_files) + /api/ proxy to backend
│
├── .github/workflows/
│   ├── ci.yml                   # Main pipeline: quality → build/push Docker → staging → production
│   ├── gradle.yml               # Submits dependency graph to GitHub for security alerts
│   ├── rollback.yml             # Manual workflow to roll back to a previous image tag
│   └── security.yml             # Scheduled CodeQL + Trivy vulnerability scans
│
├── scripts/
│   └── smoke-test.sh            # Post-deploy health check (frontend, /health, /api/v1/branches, SPA routing)
│
├── Dockerfile                   # Backend: eclipse-temurin:17-jammy (amd64 + arm64), JDK build → JRE runtime, non-root user
├── docker-compose.yml           # Full stack: postgres + backend + frontend (local and CI/CD)
└── .env.example                 # Template of required environment variables
```

---

## Configuration Files

The backend ships with three layered config files under `src/main/resources/`.

### `application.properties` — base config (always loaded)

```properties
spring.application.name=Capitec Appointment Booking System

# Active profile — override to "prod" via env var or Docker Compose
spring.profiles.active=dev
```

The default profile is `dev`. Docker Compose overrides it to `prod` via `SPRING_PROFILES_ACTIVE=prod`.

---

### `application-dev.yml` — local development profile

Activated automatically when you run `./gradlew bootRun`. No PostgreSQL or Docker needed.

| Setting | Value |
|---|---|
| Database | H2 in-memory (`jdbc:h2:mem:capitec_booking`) |
| H2 Console | http://localhost:8080/h2-console |
| H2 JDBC URL | `jdbc:h2:mem:capitec_booking` |
| H2 Username | `sa` |
| H2 Password | *(leave blank)* |
| Schema management | `create-drop` — rebuilt on every restart |
| Seed data | Loaded from `data.sql` on startup |
| CORS origins | `http://localhost:5173` (Vite dev server) |
| JWT secret | Falls back to a safe hardcoded dev key if `JWT_SECRET` is not set |
| Log level | `DEBUG` for `com.capitec.booking` |

---

### `application-prod.yml` — Docker / production profile

Activated when `SPRING_PROFILES_ACTIVE=prod` is set (Docker Compose does this automatically).  
All sensitive values **must** be supplied as environment variables — there are no fallback defaults.

| Environment Variable | Required | Description |
|---|---|---|
| `SPRING_DATASOURCE_URL` | Yes | PostgreSQL JDBC URL, e.g. `jdbc:postgresql://postgres:5432/capitec_booking` |
| `SPRING_DATASOURCE_USERNAME` | Yes | PostgreSQL username (default in Compose: `capitec`) |
| `SPRING_DATASOURCE_PASSWORD` | Yes | PostgreSQL password (default in Compose: `capitec123`) |
| `JWT_SECRET` | Yes | HMAC signing key — minimum 32 characters |
| `CORS_ALLOWED_ORIGINS` | Yes | Comma-separated allowed frontend origins, e.g. `https://booking.capitec.co.za` |
| `PORT` | No | HTTP port (defaults to `8080`) |

Other prod-profile behaviour:
- Schema management is `validate` — Hibernate checks the schema matches entities but never changes it.
- SQL seed (`data.sql`) is **disabled** — data is not re-seeded on restart.
- H2 console is **disabled**.
- Actuator exposes only the `/health` endpoint.
- Log level is `INFO` for app code, `WARN` for Spring Security.

---

## Environment Variables

Copy `.env.example` to `.env` for Docker Compose. For local dev without Docker, the dev profile uses safe defaults.

| Variable | Required | Description |
|---|---|---|
| `JWT_SECRET` | Production | HMAC signing key — minimum 32 characters |
| `POSTGRES_USER` | Production | PostgreSQL username |
| `POSTGRES_PASSWORD` | Production | PostgreSQL password |
| `SPRING_DATASOURCE_URL` | Production | JDBC URL, e.g. `jdbc:postgresql://localhost:5432/capitec_booking` |
| `CORS_ALLOWED_ORIGINS` | Production | Comma-separated frontend origins, e.g. `https://booking.capitec.co.za` |
| `JWT_EXPIRATION` | Optional | Token TTL in milliseconds (default: `900000` = 15 minutes) |

---

## Security

| Control | Detail |
|---|---|
| Authentication | Stateless JWT (HMAC-SHA256), 15-minute expiry |
| Password storage | BCrypt cost factor 12 |
| Brute force | 5 failed logins locks account for 15 minutes |
| Rate limiting | 5 auth requests/minute/IP (HTTP 429 on excess) |
| Slot double-booking | JPA `@Version` optimistic locking |
| CORS | Allow-list — only configured origins accepted |
| Security headers | HSTS (1 year), CSP (`default-src 'self'`), Referrer-Policy |
| Token storage | JWT kept in memory on the frontend (not localStorage) |
| Container | Non-root `appuser` inside the Docker image |
| Audit trail | `SECURITY_AUDIT` logger for all auth and admin events |
