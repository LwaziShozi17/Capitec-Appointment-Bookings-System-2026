# Capitec Appointment Booking System

A full-stack appointment booking system for scheduling and managing branch appointments. Built with Spring Boot 4 (Java 17) and React 19 (TypeScript).

## Architecture

```
┌─────────────────┐     ┌──────────────────┐     ┌────────────┐
│  React Frontend │────▶│  Spring Boot API  │────▶│ PostgreSQL │
│  (Vite + TS)    │     │  (REST + JWT)     │     │            │
└─────────────────┘     └──────────────────┘     └────────────┘
```

## Features

- **User Authentication** — JWT-based registration/login with BCrypt password hashing
- **Branch Management** — Browse branches by province with operating hours
- **Appointment Booking** — Select service, date, and available time slot
- **Admin Dashboard** — Manage appointments (confirm, start, complete, cancel)
- **Slot Generation** — Auto-generate slots based on operating hours and holidays
- **Rate Limiting** — Protect auth endpoints from brute-force attacks
- **Account Lockout** — Lock accounts after 5 failed login attempts (15 min cooldown)

## Tech Stack

### Backend
- Java 17, Spring Boot 4.0.6
- Spring Security with JWT (jjwt 0.12.6)
- Spring Data JPA + PostgreSQL (H2 for dev)
- Bean Validation (jakarta.validation)
- SpringDoc OpenAPI (Swagger UI)
- Spring Boot Actuator (health checks)
- JaCoCo (test coverage > 90%)

### Frontend
- React 19, TypeScript, Vite 8
- Tailwind CSS 4
- React Router 7
- Axios for HTTP
- Vitest + Testing Library (test coverage > 90%)

### Infrastructure
- Docker multi-stage builds
- docker-compose for local development
- GitHub Actions CI/CD pipeline
- Nginx reverse proxy for production

## Getting Started

### Prerequisites
- Java 17+
- Node.js 20+
- Docker & Docker Compose (optional)

### Quick Start with Docker

```bash
cp .env.example .env
# Edit .env with your secrets
docker compose up
```

The app will be available at http://localhost (frontend) and http://localhost:8080 (API).

### Local Development

**Backend:**
```bash
./gradlew bootRun
# API available at http://localhost:8080
# Swagger UI at http://localhost:8080/swagger-ui.html
# H2 Console at http://localhost:8080/h2-console
```

**Frontend:**
```bash
cd frontend
npm install
npm run dev
# Available at http://localhost:5173
```

## Testing

**Backend (JaCoCo coverage > 90%):**
```bash
./gradlew test jacocoTestReport
# Report: build/reports/jacoco/test/html/index.html
```

**Frontend (Vitest coverage > 90%):**
```bash
cd frontend
npx vitest run --coverage
# Report: frontend/coverage/index.html
```

## API Documentation

Interactive Swagger UI available at `/swagger-ui.html` when the backend is running.

### Endpoints Overview

| Method | Path | Description | Auth |
|--------|------|-------------|------|
| POST | /api/v1/auth/register | Register new user | Public |
| POST | /api/v1/auth/login | Authenticate user | Public |
| GET | /api/v1/branches | List all branches | Public |
| GET | /api/v1/branches/{id} | Get branch details | Public |
| GET | /api/v1/services | List service types | Public |
| GET | /api/v1/slots | Get available slots | Authenticated |
| POST | /api/v1/appointments | Book appointment | Authenticated |
| GET | /api/v1/appointments/my | Get my appointments | Authenticated |
| DELETE | /api/v1/appointments/{id} | Cancel appointment | Owner |
| GET | /api/v1/admin/appointments | List all appointments | Admin |
| PATCH | /api/v1/admin/appointments/{id}/confirm | Confirm appointment | Admin |
| PATCH | /api/v1/admin/appointments/{id}/start | Start appointment | Admin |
| PATCH | /api/v1/admin/appointments/{id}/complete | Complete appointment | Admin |
| PATCH | /api/v1/admin/appointments/{id}/cancel | Cancel appointment | Admin |

## Security

- JWT tokens with configurable expiration (15 min default)
- BCrypt password encoding (strength 12)
- Rate limiting on authentication endpoints
- Account lockout after repeated failed attempts
- CORS restricted to configured origins
- Security headers (HSTS, X-Content-Type-Options, Referrer-Policy)
- Method-level authorization with @PreAuthorize
- No hardcoded credentials — all secrets via environment variables

## Environment Variables

See `.env.example` for required configuration:

| Variable | Description | Required |
|----------|-------------|----------|
| SPRING_DATASOURCE_URL | PostgreSQL connection URL | Production |
| SPRING_DATASOURCE_USERNAME | Database username | Production |
| SPRING_DATASOURCE_PASSWORD | Database password | Production |
| JWT_SECRET | 256-bit secret for signing tokens | Production |
| CORS_ALLOWED_ORIGINS | Comma-separated allowed origins | Production |

## Project Structure

```
├── src/main/java/com/capitec/booking/
│   ├── config/          # Security, CORS, OpenAPI configuration
│   ├── controller/      # REST endpoints
│   ├── domain/          # JPA entities and enums
│   ├── dto/             # Request/Response DTOs with validation
│   ├── exception/       # Global exception handling
│   ├── mapper/          # Entity-to-DTO mappers
│   ├── repository/      # Spring Data JPA repositories
│   ├── security/        # JWT, rate limiting, audit logging
│   └── service/         # Business logic
├── src/test/            # Backend tests (90%+ coverage)
├── frontend/
│   ├── src/
│   │   ├── components/  # Reusable UI components
│   │   ├── context/     # React context (Auth)
│   │   ├── pages/       # Page components
│   │   ├── services/    # API client
│   │   └── test/        # Frontend tests (90%+ coverage)
│   ├── Dockerfile       # Multi-stage production build
│   └── nginx.conf       # Production reverse proxy
├── .github/workflows/   # CI/CD pipeline
├── Dockerfile           # Backend multi-stage build
├── docker-compose.yml   # Local development stack
└── .env.example         # Environment variable template
```
