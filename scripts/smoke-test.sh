#!/usr/bin/env bash
# Post-deployment smoke test.
# Usage: BASE_URL=https://your-app.example.com bash scripts/smoke-test.sh
#
# Environment variables:
#   BASE_URL        – root URL of the deployed application (required)
#   SMOKE_TIMEOUT   – seconds to wait for the service to become ready (default: 60)

set -euo pipefail

BASE_URL="${BASE_URL:?BASE_URL environment variable is required}"
SMOKE_TIMEOUT="${SMOKE_TIMEOUT:-60}"

PASS=0
FAIL=0

log_pass() { echo "  [PASS] $1"; ((PASS++)) || true; }
log_fail() { echo "  [FAIL] $1"; ((FAIL++)) || true; }

# ── Wait for the service to accept connections ───────────────────────────────
echo "Waiting for ${BASE_URL} to be reachable (timeout: ${SMOKE_TIMEOUT}s)..."
deadline=$(( $(date +%s) + SMOKE_TIMEOUT ))
until curl -sf --max-time 5 "${BASE_URL}/" > /dev/null 2>&1; do
  if (( $(date +%s) > deadline )); then
    echo "ERROR: Timed out waiting for ${BASE_URL} to become available."
    exit 1
  fi
  sleep 3
  printf "."
done
echo ""

# ── Test 1: Frontend serves the React SPA ────────────────────────────────────
echo ""
echo "Running smoke tests against: ${BASE_URL}"
echo "─────────────────────────────────────────"

HTTP_STATUS=$(curl -s -o /dev/null -w "%{http_code}" --max-time 10 "${BASE_URL}/")
if [[ "$HTTP_STATUS" == "200" ]]; then
  log_pass "Frontend root / → HTTP ${HTTP_STATUS}"
else
  log_fail "Frontend root / → HTTP ${HTTP_STATUS} (expected 200)"
fi

# Verify the page contains the expected React app marker
BODY=$(curl -sf --max-time 10 "${BASE_URL}/" || true)
if echo "$BODY" | grep -q "<div id=\"root\""; then
  log_pass "Frontend HTML contains React mount point"
else
  log_fail "Frontend HTML missing React mount point (<div id=\"root\">)"
fi

# ── Test 2: Backend health via nginx proxy ────────────────────────────────────
HTTP_STATUS=$(curl -s -o /dev/null -w "%{http_code}" --max-time 10 "${BASE_URL}/health")
if [[ "$HTTP_STATUS" == "200" ]]; then
  log_pass "Backend health /health → HTTP ${HTTP_STATUS}"
else
  log_fail "Backend health /health → HTTP ${HTTP_STATUS} (expected 200)"
fi

HEALTH_BODY=$(curl -sf --max-time 10 "${BASE_URL}/health" || echo "{}")
if echo "$HEALTH_BODY" | grep -q '"status":"UP"'; then
  log_pass "Backend health status is UP"
else
  log_fail "Backend health status is not UP: ${HEALTH_BODY}"
fi

# ── Test 3: API is responding (branches endpoint is publicly accessible) ──────
HTTP_STATUS=$(curl -s -o /dev/null -w "%{http_code}" --max-time 10 "${BASE_URL}/api/v1/branches")
if [[ "$HTTP_STATUS" == "200" ]]; then
  log_pass "API /api/v1/branches → HTTP ${HTTP_STATUS}"
elif [[ "$HTTP_STATUS" == "401" || "$HTTP_STATUS" == "403" ]]; then
  # 401/403 means the app is running but the endpoint requires auth — acceptable for smoke test
  log_pass "API /api/v1/branches → HTTP ${HTTP_STATUS} (service is up, endpoint requires auth)"
else
  log_fail "API /api/v1/branches → HTTP ${HTTP_STATUS} (expected 200/401/403, got 5xx or connection error)"
fi

# ── Test 4: SPA routing — deep routes return the index (no 404 on refresh) ───
HTTP_STATUS=$(curl -s -o /dev/null -w "%{http_code}" --max-time 10 "${BASE_URL}/login")
if [[ "$HTTP_STATUS" == "200" ]]; then
  log_pass "SPA routing /login → HTTP ${HTTP_STATUS}"
else
  log_fail "SPA routing /login → HTTP ${HTTP_STATUS} (expected 200 — nginx try_files may be misconfigured)"
fi

# ── Summary ───────────────────────────────────────────────────────────────────
echo ""
echo "─────────────────────────────────────────"
echo "Results: ${PASS} passed, ${FAIL} failed"

if (( FAIL > 0 )); then
  echo "SMOKE TEST FAILED — deployment is unhealthy."
  exit 1
fi

echo "SMOKE TEST PASSED — deployment looks healthy."
