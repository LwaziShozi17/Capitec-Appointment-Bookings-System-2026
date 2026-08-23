# Capitec Appointment Booking System — Complete Project Documentation

> **Author:** Lwazi Shozi · LwaziShozi@capitecbank.co.za  
> **Stack:** Java 17 · Spring Boot 4 · React 18 · TypeScript · PostgreSQL · Docker  
> **Last updated:** 2026-08-23

---

## Table of Contents

1. [Project Overview](#1-project-overview)
2. [Repository Structure](#2-repository-structure)
3. [Root-Level Files](#3-root-level-files)
4. [Backend — `src/`](#4-backend--src)
   - [Entry Point](#41-entry-point)
   - [Configuration — `config/`](#42-configuration--config)
   - [Controllers — `controller/`](#43-controllers--controller)
   - [Domain Models — `domain/model/`](#44-domain-models--domainmodel)
   - [Enums — `domain/enums/`](#45-enums--domainenums)
   - [DTOs — `dto/`](#46-dtos--dto)
   - [Services — `service/`](#47-services--service)
   - [Security — `security/`](#48-security--security)
   - [Repository — `repository/`](#49-repository--repository)
   - [Mapper — `mapper/`](#410-mapper--mapper)
   - [Exception Handling — `exception/`](#411-exception-handling--exception)
   - [Resources — `src/main/resources/`](#412-resources--srcmainresources)
   - [Tests — `src/test/`](#413-tests--srctest)
5. [Frontend — `frontend/`](#5-frontend--frontend)
   - [Entry & Config Files](#51-entry--config-files)
   - [App Router — `App.tsx`](#52-app-router--apptsx)
   - [Pages — `src/pages/`](#53-pages--srcpages)
   - [Components — `src/components/`](#54-components--srccomponents)
   - [Context — `src/context/`](#55-context--srccontext)
   - [Services — `src/services/`](#56-services--srcservices)
   - [Types — `src/types/index.ts`](#57-types--srctypesindexts)
   - [Frontend Tests — `src/test/`](#58-frontend-tests--srctest)
6. [Infrastructure & DevOps](#6-infrastructure--devops)
   - [Dockerfile (Backend)](#61-dockerfile-backend)
   - [frontend/Dockerfile](#62-frontenddockerfile)
   - [docker-compose.yml](#63-docker-composeyml)
   - [docker-compose.staging.yml & docker-compose.prod.yml](#64-docker-composestaginglyml--docker-composeprodlyml)
   - [.github/workflows/ci.yml](#65-githubworkflowsciyml)
   - [.github/workflows/security.yml](#66-githubworkflowssecurityyml)
   - [.github/workflows/rollback.yml](#67-githubworkflowsrollbackyml)
   - [scripts/smoke-test.sh](#68-scriptssmoke-testsh)
7. [Data Flow Walkthrough](#7-data-flow-walkthrough)
8. [Security Model](#8-security-model)
9. [Database Schema Summary](#9-database-schema-summary)
10. [Environment Variables Reference](#10-environment-variables-reference)
11. [Running the Project Locally](#11-running-the-project-locally)

---

## 1. Project Overview

The Capitec Appointment Booking System allows bank customers to book, view, and cancel in-branch appointments online. Staff admins can manage all appointments, generate time slots, and control the appointment lifecycle.

**Core capabilities:**
- Customer self-registration and JWT-authenticated login with brute-force lockout protection
- Browse 45 real Capitec branches across all 9 South African provinces
- 3-step guided booking flow: service → date/time → customer details
- 30-minute appointment slots generated from branch operating hours (respects holidays and closed days)
- Appointment lifecycle: `PENDING → CONFIRMED → IN_PROGRESS → COMPLETED` (or `CANCELLED`)
- Admin dashboard: view/filter all appointments, advance lifecycle, cancel on behalf of customers, generate slots
- Rate limiting on authentication endpoints, HSTS, CSP, and referrer-policy security headers
- Full audit trail logged to a dedicated `SECURITY_AUDIT` logger
- GitHub Actions CI/CD pipeline: test → build Docker images → deploy staging → manual gate → deploy production → auto-rollback on failure

---

## 2. Repository Structure

```
Capitec-Appointment-Bookings-System-2026-2026/
│
├── src/                        ← Java/Spring Boot backend source
│   ├── main/java/com/capitec/booking/
│   │   ├── Application.java
│   │   ├── config/             ← Spring configuration beans
│   │   ├── controller/         ← REST API endpoints
│   │   ├── domain/
│   │   │   ├── model/          ← JPA entity classes
│   │   │   └── enums/          ← Enum types
│   │   ├── dto/
│   │   │   ├── request/        ← Inbound request bodies
│   │   │   └── response/       ← Outbound response shapes
│   │   ├── exception/          ← Custom exceptions + global handler
│   │   ├── mapper/             ← Entity → DTO conversion
│   │   ├── repository/         ← Spring Data JPA interfaces
│   │   ├── security/           ← JWT, rate-limit, audit filters
│   │   └── service/            ← Business logic layer
│   ├── main/resources/         ← application.properties, SQL seed data
│   └── test/                   ← JUnit 5 unit + integration tests
│
├── frontend/                   ← React + TypeScript SPA
│   ├── src/
│   │   ├── App.tsx             ← Router root
│   │   ├── pages/              ← Full-page route components
│   │   ├── components/         ← Shared UI components
│   │   ├── context/            ← React context (Auth, Toast)
│   │   ├── services/           ← Axios API client & token store
│   │   ├── types/              ← TypeScript type definitions
│   │   └── test/               ← Vitest unit tests
│   ├── public/                 ← Static assets (favicon, SVG icons)
│   ├── Dockerfile              ← Nginx-based production image
│   └── nginx.conf              ← SPA routing + API proxy config
│
├── .github/workflows/          ← GitHub Actions CI/CD pipelines
├── scripts/                    ← Deployment helper scripts
├── Dockerfile                  ← Backend multi-stage Docker build
├── docker-compose.yml          ← Local / base compose definition
├── docker-compose.staging.yml  ← Staging overlay
├── docker-compose.prod.yml     ← Production overlay
├── build.gradle                ← Gradle build configuration
├── settings.gradle             ← Project name declaration
└── .env.example                ← Required environment variables template
```

---

## 3. Root-Level Files

### `build.gradle`
Gradle build script for the backend. Key sections:

| Section | Detail |
|---|---|
| `plugins` | `java`, `org.springframework.boot:4.0.6`, `io.spring.dependency-management`, `jacoco` |
| `java.toolchain` | Requires Java 17 (`JavaLanguageVersion.of(17)`) |
| `dependencies` | Spring Web, JPA, Validation, Actuator, Security; JWT (`jjwt 0.12.6`); Lombok; PostgreSQL + H2; SpringDoc OpenAPI |
| `tasks.test` | Runs JUnit 5 and triggers JaCoCo report after tests complete |
| `jacocoTestCoverageVerification` | Enforces **80% minimum code coverage**; CI gate fails below this threshold |

### `settings.gradle`
Single line: `rootProject.name = 'Capitec-Appointment-Bookings-System-2026-2026'`. Tells Gradle the project name.

### `.env.example`
Template listing every environment variable the application needs in production (JWT secret, database credentials, CORS origins). Copy to `.env` and fill in values before running Docker Compose.

### `.gitignore` / `.gitattributes`
Standard Java + Node ignores (build output, `.gradle`, `node_modules`, `.env`). `.gitattributes` sets line-ending normalisation for cross-platform consistency.

### `.dockerignore`
Lists files to exclude from the Docker build context (`.git`, `node_modules`, test outputs) to keep images lean and prevent secrets from being baked in.

### `README.md`
High-level project README.

### `CI-CD.md`
Documentation specifically covering the CI/CD pipeline design decisions, environment secrets, and rollback procedure.

---

## 4. Backend — `src/`

### 4.1 Entry Point

#### `Application.java`
```
src/main/java/com/capitec/booking/Application.java
```
The Spring Boot application entry point. The `@SpringBootApplication` annotation enables component scanning, auto-configuration, and the embedded Tomcat server. The `main` method delegates entirely to `SpringApplication.run`.

---

### 4.2 Configuration — `config/`

#### `SecurityConfig.java`
Defines the entire HTTP security policy for the application.

- **`@EnableMethodSecurity`** — enables `@PreAuthorize` annotations on controller methods (used on `AdminController`)
- **CSRF disabled** — the app is stateless (JWT), so CSRF protection is not needed
- **`SessionCreationPolicy.STATELESS`** — no session cookies; every request must carry a JWT
- **Route permissions:**
  - `/api/v1/auth/**` — public (login/register)
  - `/actuator/health`, Swagger UI, H2 console — public
  - `/actuator/**` — ADMIN only
  - `GET /api/v1/branches/**` and `GET /api/v1/services/**` — public (branch browsing works without login)
  - `/api/v1/admin/**` — ADMIN only
  - Everything else — any authenticated user
- **Security headers:** HSTS (1 year), Content-Type options, Referrer-Policy `strict-origin-when-cross-origin`, Content Security Policy (`default-src 'self'`)
- **Filter chain:** `RateLimitFilter` → `JwtAuthenticationFilter` → standard Spring Security filters
- **`BCryptPasswordEncoder(12)`** — cost factor 12 for password hashing

#### `CorsConfig.java`
Registers a `CorsFilter` bean that allows the frontend (running on `localhost:3000` or `localhost:5173` in dev) to call the backend API. Allowed methods: GET, POST, PUT, PATCH, DELETE, OPTIONS. The allowed origins are configurable via `app.cors.allowed-origins` in `application.yml`.

#### `DataLoader.java`
A `CommandLineRunner` that seeds the database with two demo users on startup **if they don't already exist**:

| User | Password | Role |
|---|---|---|
| `admin@capitec.co.za` | `Admin@123` | `ADMIN` |
| `user@capitec.co.za` | `User@123` | `USER` |

This is idempotent — it checks `existsByEmail` before inserting, so re-running the app does not create duplicates.

#### `OpenApiConfig.java`
Configures the Swagger UI (accessible at `/swagger-ui.html`) with:
- API title, description, version
- A `Bearer Authentication` security scheme so JWT tokens can be tested directly in the Swagger UI

---

### 4.3 Controllers — `controller/`

All controllers follow the same pattern: they accept HTTP requests, delegate to a service, and use `AppointmentMapper` (or inline mapping) to return DTOs. They never expose raw JPA entity objects.

#### `AuthController.java` — `POST /api/v1/auth/register`, `POST /api/v1/auth/login`
Handles user registration and login. Both endpoints are public (no JWT required). Delegates to `AuthService` and returns an `AuthResponse` containing the JWT token, user email, full name, and role.

#### `AppointmentController.java` — `/api/v1/appointments`
Authenticated users' appointment endpoints:

| Method | Path | Description |
|---|---|---|
| `POST` | `/` | Book an appointment. The `userId` is read from the JWT (`authentication.getName()`), never from the request body |
| `GET` | `/{id}` | Get a single appointment (only the owner may access it) |
| `DELETE` | `/{id}` | Cancel an appointment (only the owner may cancel) |
| `GET` | `/my` | List all appointments for the currently logged-in user |

#### `AdminController.java` — `/api/v1/admin` (ADMIN role required)
Class-level `@PreAuthorize("hasRole('ADMIN')")` means every endpoint in this controller rejects non-admins with 403 Forbidden.

| Method | Path | Description |
|---|---|---|
| `GET` | `/appointments` | List all appointments; optional `?status=` filter |
| `PATCH` | `/appointments/{id}/confirm` | Advance status: `PENDING → CONFIRMED` |
| `PATCH` | `/appointments/{id}/start` | Advance status: `CONFIRMED → IN_PROGRESS` |
| `PATCH` | `/appointments/{id}/complete` | Advance status: `IN_PROGRESS → COMPLETED` |
| `PATCH` | `/appointments/{id}/cancel` | Cancel any appointment regardless of owner |
| `POST` | `/slots/generate` | Generate 30-min slots for a branch over a date range |

#### `BranchController.java` — `GET /api/v1/branches`, `GET /api/v1/branches/{id}`
Public endpoints. Returns branch name, code, address, province, GPS coordinates, and operating hours for each day of the week. Mapping from `Branch` entity to `BranchResponse` is done inline (no mapper class needed for the simple flat structure).

#### `ServiceTypeController.java` — `GET /api/v1/services`
Public endpoint returning all available service types (name, description, duration in minutes, required documents as a semicolon-delimited string).

#### `SlotController.java` — `GET /api/v1/slots`
Returns available appointment slots for a given `?branchId=&date=` query. Used by the frontend booking page to populate the time slot grid.

---

### 4.4 Domain Models — `domain/model/`

These are JPA `@Entity` classes mapped to database tables. All getters/setters are written manually (no Lombok on entities to keep persistence behaviour transparent).

#### `User.java` — table `users`
| Field | Type | Notes |
|---|---|---|
| `id` | `Long` | Auto-generated primary key |
| `email` | `String` | Unique, not null — used as the JWT subject |
| `password` | `String` | BCrypt-hashed, never returned in responses |
| `firstName`, `lastName` | `String` | Not null |
| `phoneNumber` | `String` | Optional |
| `role` | `Role` enum | Defaults to `USER` |
| `failedLoginAttempts` | `int` | Incremented on each bad password; resets on successful login |
| `accountLockedUntil` | `LocalDateTime` | Set 15 minutes in the future after 5 failed attempts |
| `createdAt` | `LocalDateTime` | Set automatically by `@PrePersist` |

`isAccountLocked()` — returns `true` if `accountLockedUntil` is in the future.  
`getFullName()` — convenience method returning `firstName + " " + lastName`.

#### `Branch.java` — table `branches`
| Field | Type | Notes |
|---|---|---|
| `id` | `Long` | PK |
| `name` | `String` | e.g. "Capitec Sandton City" |
| `code` | `String` | Unique short code e.g. `CAP-GP-SDN` |
| `address` | `String` | Physical street address |
| `province` | `String` | South African province |
| `latitude`, `longitude` | `Double` | GPS coordinates for map display |
| `operatingHours` | `List<OperatingHours>` | One-to-many, cascade all, orphan removal |

#### `AppointmentSlot.java` — table `appointment_slots`
Represents one 30-minute bookable window at a branch on a specific date.

| Field | Type | Notes |
|---|---|---|
| `id` | `Long` | PK |
| `branch` | `Branch` | Many-to-one (lazy fetch) |
| `date` | `LocalDate` | The calendar date (`slot_date` column) |
| `startTime`, `endTime` | `LocalTime` | e.g. 08:00–08:30 |
| `status` | `SlotStatus` enum | `AVAILABLE`, `BOOKED`, or `BLOCKED` |
| `version` | `Long` | JPA `@Version` for optimistic locking — prevents two users from booking the same slot simultaneously |

Unique constraint on `(branch_id, slot_date, start_time)` prevents duplicate slots.

#### `Appointment.java` — table `appointments`
| Field | Type | Notes |
|---|---|---|
| `id` | `Long` | PK |
| `userId` | `String` | The email of the booking user (from JWT) |
| `slot` | `AppointmentSlot` | One-to-one, eager fetch |
| `serviceType` | `ServiceType` | Many-to-one, eager fetch |
| `status` | `AppointmentStatus` enum | Defaults to `CONFIRMED` at entity level (overridden to `PENDING` in service) |
| `createdAt` | `LocalDateTime` | Set by `@PrePersist` |
| `referenceNumber` | `String` | Generated as `"CAP-" + System.currentTimeMillis()` in `@PrePersist` |
| `customerName`, `customerPhone`, `customerEmail` | `String` | Captured at booking time |

#### `ServiceType.java` — table `service_types`
Describes what a customer can come to the branch for (e.g. Account Opening, Loan Consultation). Includes `name`, `description`, `durationMinutes`, and `requiredDocuments` (semicolon-delimited list displayed in the booking flow).

#### `OperatingHours.java` — table `operating_hours`
Maps a day of the week to open/close times for a specific branch. Has an `isClosed` boolean for days the branch doesn't operate (e.g. Sundays).

#### `Holiday.java` — table `holidays`
Records South African public holidays. The `open` field indicates whether the branch is open on that holiday (false = closed all day). If `open = true`, `specialOpenTime` and `specialCloseTime` override the normal operating hours for that day.

---

### 4.5 Enums — `domain/enums/`

#### `Role.java`
```java
USER, ADMIN
```
Controls access: ADMIN can reach `/api/v1/admin/**` and actuator endpoints.

#### `AppointmentStatus.java`
```java
PENDING, CONFIRMED, IN_PROGRESS, COMPLETED, CANCELLED
```
Lifecycle transitions are enforced in `AppointmentService.validateStatusTransition()`:
- `PENDING → CONFIRMED` (admin confirms)
- `CONFIRMED → IN_PROGRESS` (admin marks customer as being served)
- `IN_PROGRESS → COMPLETED` (admin marks service as done)
- Any non-CANCELLED, non-COMPLETED appointment can be cancelled

#### `SlotStatus.java`
```java
AVAILABLE, BOOKED, BLOCKED
```
When a user books a slot, it transitions `AVAILABLE → BOOKED`. If a booking is cancelled, the slot reverts to `AVAILABLE`.

---

### 4.6 DTOs — `dto/`

DTOs (Data Transfer Objects) decouple the HTTP API shape from the internal domain model.

#### Request DTOs (`dto/request/`)

**`RegisterRequest.java`** — fields: `firstName`, `lastName`, `email`, `password`, `phoneNumber`. Validated with Bean Validation annotations (`@NotBlank`, `@Email`, `@Size`).

**`LoginRequest.java`** — fields: `email`, `password`. Both required.

**`BookingRequest.java`** — fields: `slotId` (Long), `serviceTypeId` (Long), `customerName`, `customerPhone`, `customerEmail`. The `userId` field is not accepted from the client; it is set by the controller from the JWT principal after authentication.

#### Response DTOs (`dto/response/`)

**`AuthResponse.java`** — `token`, `email`, `name`, `role`. Returned on successful login or registration.

**`AppointmentResponse.java`** — flat view of an appointment including: `id`, `referenceNumber`, `userId`, `customerName/Email/Phone`, `branchName`, `branchAddress`, `serviceName`, `date`, `startTime`, `endTime`, `status`, `createdAt`.

**`BranchResponse.java`** — `id`, `name`, `code`, `address`, `province`, `latitude`, `longitude`, `operatingHours` (list of `OperatingHoursResponse` inner class with `dayOfWeek`, `openTime`, `closeTime`, `closed`).

**`SlotResponse.java`** — `id`, `branchId`, `date`, `startTime`, `endTime`, `status`.

---

### 4.7 Services — `service/`

Services contain all business logic. They are annotated `@Service` and injected into controllers via constructor injection. No `@Autowired` field injection is used anywhere.

#### `AuthService.java`
Handles registration and login.

**`register()`:**
1. Checks if the email already exists — throws `InvalidOperationException` if so
2. Encodes the password with BCrypt
3. Saves the new user
4. Logs the registration event via `AuditLogger`
5. Generates and returns a JWT token

**`login()`:**
1. Looks up the user by email
2. Checks if the account is locked (`user.isAccountLocked()`)
3. Verifies the password with BCrypt
4. On failure: increments `failedLoginAttempts`; if 5 attempts reached, sets `accountLockedUntil = now + 15 min`
5. On success: resets failed attempts, logs success, generates and returns a JWT

#### `AppointmentService.java`
Manages the full appointment lifecycle.

**`bookAppointment()`:**
1. Loads the `AppointmentSlot` — 404 if not found
2. Checks `slot.status == AVAILABLE` — throws `SlotNotAvailableException` if not
3. Loads the `ServiceType`
4. Sets slot status to `BOOKED` and saves
5. Creates and saves a new `Appointment` with status `PENDING`
6. Returns the saved appointment (the `referenceNumber` is set by `@PrePersist`)

**`cancelAppointment()`:** Validates that the requesting user owns the appointment, then calls `performCancellation()`.  
**`cancelAppointmentAsAdmin()`:** Skips ownership check.  
**`performCancellation()`:** Sets appointment to `CANCELLED` and frees the slot back to `AVAILABLE`.

**`validateStatusTransition()`:** A `switch` expression that only allows the defined lifecycle path. Any other transition throws `InvalidOperationException`.

**`validateOwnership()`:** Compares `appointment.getUserId()` (email) with `authenticatedUserId` (from JWT). Logs a warning and throws if they don't match.

#### `SlotGenerationService.java`
Generates 30-minute `AppointmentSlot` records for a branch on a given date.

**`generateSlotsForDate()`:**
1. Loads the branch — 404 if not found
2. Checks `HolidayRepository` for the date — if the holiday is marked `open=false`, returns empty list
3. If it is a special holiday with hours, uses those hours; otherwise looks up `OperatingHours` for the day of week
4. If the branch is closed that day, returns empty list
5. Loops from `openTime` to `closeTime` in 30-minute increments, creating a slot for each window (skipping slots that already exist in the database — idempotent)
6. Saves all new slots in bulk

**`generateSlotsForDateRange()`:** Iterates day by day and calls `generateSlotsForDate()`.

#### `BranchService.java`
Simple pass-through to `BranchRepository` for listing and fetching branches.

#### `SlotService.java`
Queries `AppointmentSlotRepository` for slots by `branchId` and `date` for the slot picker on the booking page.

---

### 4.8 Security — `security/`

#### `JwtService.java`
Wraps the JJWT library for token generation and validation.

- **`generateToken(User)`** — builds a JWT with claims: `sub` = email, `role`, `userId`, `name`; signed with HMAC-SHA using the secret from `${jwt.secret}`; expires in `${jwt.expiration}` ms (default 900,000 ms = 15 minutes)
- **`extractEmail(token)`** — reads the `sub` claim
- **`extractRole(token)`** — reads the `role` claim
- **`isTokenValid(token)`** — parses and verifies the signature; returns false if expired or malformed

#### `JwtAuthenticationFilter.java`
A `OncePerRequestFilter` that runs on every request before Spring's standard auth filters.

1. Reads the `Authorization: Bearer <token>` header
2. If absent, passes the request through unchanged (unauthenticated)
3. If present, validates the token via `JwtService`
4. On success, creates a `UsernamePasswordAuthenticationToken` with the email as principal and `ROLE_<role>` as authority, then stores it in `SecurityContextHolder`

This makes `authentication.getName()` return the user's email in controllers.

#### `RateLimitFilter.java`
A `OncePerRequestFilter` that limits auth endpoint abuse.

- Only applies to paths starting with `/api/v1/auth/`
- Allows **5 requests per minute per IP** per auth path
- Tracks request counts in a `ConcurrentHashMap<String, RateLimitEntry>` keyed on `ip:path`
- The sliding window resets when `now - windowStart > 60,000 ms`
- On exceeding the limit, returns HTTP 429 with a JSON error body
- Respects `X-Forwarded-For` headers for clients behind proxies

#### `AuditLogger.java`
A dedicated logger named `SECURITY_AUDIT`. Wraps SLF4J calls to emit structured audit log lines for:
- `LOGIN_SUCCESS` — user logged in
- `LOGIN_FAILED` — bad password
- `ACCOUNT_LOCKED` — too many failed attempts
- `REGISTRATION` — new user created
- `ADMIN_ACTION` — admin performed a lifecycle action on an appointment
- `UNAUTHORIZED_ACCESS` — user tried to access another user's appointment

These lines are prefixed `[AUDIT]` to make them easy to grep from log aggregators.

---

### 4.9 Repository — `repository/`

All repositories extend `JpaRepository<Entity, Long>`, giving standard CRUD and pagination for free. Custom query methods follow Spring Data's naming convention:

| Repository | Key Custom Methods |
|---|---|
| `UserRepository` | `findByEmail(String)`, `existsByEmail(String)` |
| `AppointmentRepository` | `findByUserId(String)`, `findByStatus(AppointmentStatus)` |
| `AppointmentSlotRepository` | `findByBranchIdAndDate(Long, LocalDate)`, `existsByBranchIdAndDateAndStartTime(...)` |
| `BranchRepository` | standard only |
| `OperatingHoursRepository` | `findByBranchIdAndDayOfWeek(Long, DayOfWeek)` |
| `HolidayRepository` | `findByDate(LocalDate)` |
| `ServiceTypeRepository` | standard only |

---

### 4.10 Mapper — `mapper/`

#### `AppointmentMapper.java`
A Spring `@Component` that converts `Appointment` entities to `AppointmentResponse` DTOs and `AppointmentSlot` entities to `SlotResponse` DTOs. Placed in its own class to keep controllers thin and to make the mapping logic testable in isolation.

---

### 4.11 Exception Handling — `exception/`

#### `ResourceNotFoundException.java`
Runtime exception thrown when a requested entity (slot, appointment, branch, etc.) does not exist in the database. Results in HTTP 404.

#### `SlotNotAvailableException.java`
Thrown when a user tries to book a slot that is `BOOKED` or `BLOCKED`. Results in HTTP 409 Conflict.

#### `InvalidOperationException.java`
General-purpose exception for business rule violations: invalid status transitions, wrong ownership, duplicate email registration, locked account, etc. Results in HTTP 400 Bad Request.

#### `GlobalExceptionHandler.java`
A `@RestControllerAdvice` that intercepts all exceptions thrown from controllers and maps them to structured JSON error responses with `timestamp`, `status`, `error`, and `message` fields. Also handles `MethodArgumentNotValidException` (Bean Validation failures) and returns the per-field validation errors under a `details` key.

---

### 4.12 Resources — `src/main/resources/`

#### `application.properties`
Sets the application name and activates the `dev` Spring profile by default:
```properties
spring.application.name=Capitec Appointment Booking System
spring.profiles.active=dev
```

#### `application-dev.yml`
Development profile using the **H2 in-memory database**. Enables the H2 console (`/h2-console`) for direct SQL inspection. Sets `spring.sql.init.mode=always` so `data.sql` is executed on startup.

#### `application-prod.yml`
Production profile for **PostgreSQL**. Database URL, username, and password are expected via environment variables. Sets `spring.sql.init.mode=never` (PostgreSQL schema is managed by JPA DDL auto, not the SQL seed script in production).

#### `data.sql`
The complete seed dataset. Runs automatically in dev/test against H2. Contents:

- **45 Capitec branches** across all 9 South African provinces (5 per province), with real names, addresses, and GPS coordinates
- **Operating hours** for all 45 branches: Mon–Fri 08:00–17:00, Saturday 08:00–13:00, Sunday closed
- **8 service types**: Account Opening, Loan Consultation, Card Collection, Account Query, Investment Consultation, Insurance Consultation, Foreign Exchange, Business Account Opening — each with `requiredDocuments`
- **12 South African public holidays for 2026**, all marked `open=false`
- **100 demo appointment slots** across branches 1 (Sandton City), 6 (V&A Waterfront), and 11 (Gateway) for Aug 5–7 and Aug 10 2026, plus 4 past slots for history
- **15 demo appointments** for the two demo users covering all statuses: CONFIRMED, PENDING, CANCELLED, COMPLETED

---

### 4.13 Tests — `src/test/`

The test suite uses JUnit 5 with Spring Boot Test and Mockito. JaCoCo enforces **80% line coverage** as a CI gate.

| Test Class | Type | What It Tests |
|---|---|---|
| `AuthControllerTest` | Controller (MockMvc) | Register + login endpoints, validation errors, account lock responses |
| `AppointmentControllerTest` | Controller | Book, get, cancel, list — including auth/ownership checks |
| `AdminControllerTest` | Controller | All admin endpoints; verifies 403 for non-admin users |
| `BranchControllerTest` | Controller | GET list and GET by ID |
| `ServiceTypeControllerTest` | Controller | GET all services |
| `SlotControllerTest` | Controller | GET slots by branch and date |
| `AuthServiceTest` | Service | Registration happy path, duplicate email, login, lockout logic |
| `AppointmentServiceTest` | Service | Booking, cancellation, status transitions, ownership validation |
| `BranchServiceTest` | Service | List and fetch branches |
| `SlotGenerationServiceTest` | Service | Slot generation with holidays, closed days, existing slots |
| `SlotServiceTest` | Service | Slot query by branch + date |
| `JwtServiceTest` | Security | Token generation, extraction, expiry, invalid tokens |
| `JwtAuthenticationFilterTest` | Security | Filter passes valid token to context; ignores missing/invalid tokens |
| `RateLimitFilterTest` | Security | Allows up to 5 requests; blocks on 6th; window resets |
| `AuditLoggerTest` | Security | Verifies log output format for each audit event |
| `DomainModelTest` | Domain | Entity constructors, field setters, `isAccountLocked()`, `getFullName()` |
| `DtoResponseTest` | DTO | DTO field accessors |
| `GlobalExceptionHandlerTest` | Exception | 404, 409, 400, validation failure response shapes |
| `AppointmentIntegrationTest` | Integration | Full booking flow end-to-end against H2 via `@SpringBootTest` |

---

## 5. Frontend — `frontend/`

A React 18 + TypeScript SPA built with Vite and styled with Tailwind CSS.

### 5.1 Entry & Config Files

#### `index.html`
The single HTML file. Contains `<div id="root">` where React mounts. Vite replaces the script tag at build time.

#### `frontend/src/main.tsx`
React entry point. Mounts `<App />` into `#root` with `StrictMode`.

#### `vite.config.ts`
Configures the Vite dev server. Sets up a proxy: any request to `/api/v1` is forwarded to `http://localhost:8080/api/v1`, so the frontend can call the backend API without CORS issues in development.

#### `vitest.config.ts`
Test configuration: uses `jsdom` as the test environment, includes `src/test/setup.ts` as a global setup file (which extends `@testing-library/jest-dom` matchers).

#### `tsconfig.json` / `tsconfig.app.json` / `tsconfig.node.json`
TypeScript configuration. `strict: true` is enabled. `tsconfig.app.json` covers `src/`, `tsconfig.node.json` covers Vite config files.

#### `eslint.config.js`
ESLint configuration using flat config format with `@typescript-eslint` and `react-refresh` plugins.

#### `package.json`
Dependencies include: React 18, React Router DOM 6, Axios, Tailwind CSS. Dev dependencies: Vitest, `@testing-library/react`, `@testing-library/jest-dom`, `@testing-library/user-event`, `msw` (Mock Service Worker for API mocking in tests).

#### `frontend/nginx.conf`
Nginx config for the production container:
- Serves the static Vite build from `/usr/share/nginx/html`
- `try_files $uri $uri/ /index.html` — ensures SPA deep routes (e.g. `/login`, `/appointments`) work on page refresh without 404s
- Proxies `/api/v1/` requests to the backend container

---

### 5.2 App Router — `App.tsx`

The root component. Wraps the entire application in:
- `<ErrorBoundary>` — catches unexpected React render errors
- `<BrowserRouter>` — enables React Router
- `<AuthProvider>` — provides auth state to all children
- `<ToastProvider>` — provides notification state to all children

**Route map:**

| Path | Component | Protection |
|---|---|---|
| `/` | `HomePage` | Public |
| `/login` | `LoginPage` | Public |
| `/register` | `RegisterPage` | Public |
| `/branches` | `BranchesPage` | Authenticated |
| `/book/:branchId` | `BookingPage` | Authenticated |
| `/appointments` | `AppointmentsPage` | Authenticated |
| `/admin` | `AdminPage` | Authenticated + Admin role |

All protected routes are wrapped in `<ProtectedRoute>`. The admin route additionally passes `adminOnly` prop.

---

### 5.3 Pages — `src/pages/`

#### `HomePage.tsx`
Landing page visible to all visitors. Presents the Capitec brand, a brief description of the system, and CTAs to login or register. Does not make any API calls.

#### `LoginPage.tsx`
Email + password form. On submit, calls `useAuth().login()`. Redirects to `/branches` on success. Displays API error messages (including account locked messages) inline.

#### `RegisterPage.tsx`
Registration form with firstName, lastName, email, password, optional phoneNumber. Calls `useAuth().register()`. Redirects to `/branches` on success.

#### `BranchesPage.tsx`
Fetches all branches from `GET /api/v1/branches`. Displays them in a responsive grid with branch name, address, province badge, and a "Book Appointment" button that navigates to `/book/:id`.

#### `BookingPage.tsx`
The most complex page. A 3-step wizard:

**Step 1 — Select Service:**  
Fetches service types from `GET /api/v1/services`. Renders each as a selectable radio card showing name, description, and duration. When a service is selected, a "Required Documents" panel expands below showing what the customer needs to bring.

**Step 2 — Date & Time:**  
A `<input type="date">` with a minimum of today. On date change, fetches slots from `GET /api/v1/slots?branchId=&date=`. The slot grid renders buttons colour-coded: green (available), red (booked), grey (blocked/past). A skeleton loading grid shows while slots are being fetched. Selecting a slot updates the `selectedSlot` state.

**Step 3 — Your Details:**  
Name, email (pre-filled from auth state), and phone number fields.

**Booking Summary** appears once service and slot are both selected. The confirm button is disabled until all three steps are complete. On submit, calls `POST /api/v1/appointments` and redirects to `/appointments` on success.

**`StepIndicator`** — inner component rendering the three-step progress bar with filled circles for completed steps and a connecting line.

#### `AppointmentsPage.tsx`
Fetches `GET /api/v1/appointments/my`. Displays each appointment as a card with: reference number, branch, service, date/time, status badge (colour-coded by status). Includes a "Cancel" button for non-terminal statuses. Shows a success toast message when navigated to from `BookingPage` with `location.state.message`.

#### `AdminPage.tsx`
Admin-only dashboard. Fetches all appointments from `GET /api/v1/admin/appointments`. Supports filtering by status via a dropdown. Each appointment card has action buttons: Confirm, Start, Complete, Cancel — each calling the corresponding `PATCH /api/v1/admin/appointments/{id}/...` endpoint. Includes a "Generate Slots" form to trigger slot generation for a specific branch and date range.

---

### 5.4 Components — `src/components/`

#### `Layout.tsx`
The persistent shell around all pages. Contains the navigation bar (Capitec logo, nav links, login/logout button) and a `<main>` content area with `<Outlet />` (React Router v6). The nav adapts based on auth state: shows "My Appointments" for authenticated users, "Admin" for admins.

#### `ProtectedRoute.tsx`
A wrapper component. If the user is not logged in, redirects to `/login`. If `adminOnly={true}` and the user is not an admin, redirects to `/` with a toast error. Otherwise renders `children`.

#### `ErrorBoundary.tsx`
A class component (required for React error boundaries). Catches render errors anywhere in its subtree and displays a friendly error message with a "Reload page" button instead of crashing the whole app.

#### `ui/ConfirmModal.tsx`
A reusable modal dialog used for cancellation confirmations. Accepts `title`, `message`, `onConfirm`, and `onCancel` props.

#### `ui/Skeleton.tsx`
Animated loading placeholder components used while API data is being fetched. `SkeletonSlotGrid` specifically mimics the time slot grid layout on `BookingPage`.

#### `ui/StatCard.tsx`
A small card component used on `AdminPage` to display aggregate statistics (total appointments, confirmed count, etc.).

---

### 5.5 Context — `src/context/`

#### `AuthContext.tsx`
Provides authentication state via React Context. The `AuthProvider` component:

- **State:** `user: User | null` — stores email, name, role, and the JWT token
- **Persistence strategy:** Only non-sensitive fields (email, name, role) are stored in `localStorage` under `user_profile`. The JWT token is kept in-memory in `tokenStore` (not localStorage) to reduce XSS exposure
- **On mount:** Reads the stored profile from localStorage to restore the logged-in UI state without an API call. The token is absent — any API call will redirect to `/login?reason=expired` if the token is missing
- **`login()`** — calls `POST /api/v1/auth/login`, stores the result
- **`register()`** — calls `POST /api/v1/auth/register`, stores the result
- **`logout()`** — clears user state, which causes the `useEffect` to clear token and localStorage
- **`isAdmin`** — derived boolean: `user?.role === 'ADMIN'`
- **`useAuth()`** — convenience hook exported from the same file; throws if called outside `AuthProvider`

#### `authContext.ts` / `useAuth.ts`
Re-export shims for backward compatibility.

#### `ToastContext.tsx`
Provides a notification system. `ToastProvider` maintains a list of active toasts and exposes `showToast(message, type)`. Toasts auto-dismiss after a configurable timeout.

#### `useToast.ts`
Convenience hook that calls `useContext(ToastContext)`.

---

### 5.6 Services — `src/services/`

#### `api.ts`
Configures and exports a pre-configured Axios instance.

- **`baseURL: '/api/v1'`** — all calls are relative to this base; Nginx or Vite proxy routes them to the backend
- **Request interceptor:** On every outgoing request:
  1. Reads the JWT from `tokenStore`
  2. If the token is present but expired (parsed from the JWT payload), clears auth state and redirects to `/login?reason=expired` before the request goes out
  3. If valid, attaches `Authorization: Bearer <token>`
- **Response interceptor:** On 401 responses (e.g. token expired server-side between requests), clears auth state and redirects to `/login`

This means every component that uses `api` gets auth, token expiry handling, and redirect behaviour for free.

#### `tokenStore.ts`
A tiny in-memory singleton for the JWT. Exposes `get()` and `set(token | null)`. By keeping the token in memory (not `localStorage`), it is not accessible to `document.cookie` or localStorage-reading XSS attacks. The trade-off is that the token is lost on page refresh — the user sees the logged-in UI (from the stored profile) but the next API call will redirect them to login if they lack a valid token.

---

### 5.7 Types — `src/types/index.ts`

TypeScript interface definitions shared across the frontend:

| Type | Purpose |
|---|---|
| `Branch` | Branch entity shape from API |
| `OperatingHours` | Nested hours shape inside `Branch` |
| `ServiceType` | Service type from API |
| `AppointmentSlot` | Slot shape — status is `'AVAILABLE' \| 'BOOKED' \| 'BLOCKED'` |
| `Appointment` | Full appointment response from API |
| `AppointmentStatus` | Union type of all five status strings |
| `AuthResponse` | Shape of login/register API response |
| `User` | Frontend user state shape |

---

### 5.8 Frontend Tests — `src/test/`

All tests use Vitest + React Testing Library. API calls are mocked with `msw` or `vi.mock`.

| Test File | What It Covers |
|---|---|
| `LoginPage.test.tsx` | Form rendering, submit, error display, redirect on success |
| `RegisterPage.test.tsx` | Registration form validation and success redirect |
| `HomePage.test.tsx` | Static content renders, CTAs visible |
| `BranchesPage.test.tsx` | Fetches and displays branches; loading skeleton state |
| `BookingPage.test.tsx` | 3-step flow: service selection, slot grid, form submit |
| `AppointmentsPage.test.tsx` | Lists appointments, cancel action, success message from state |
| `AdminPage.test.tsx` | Admin dashboard, lifecycle buttons, slot generation form |
| `AuthContext.test.tsx` | Login, register, logout, localStorage persistence |
| `ToastContext.test.tsx` | Toast show/dismiss behaviour |
| `Layout.test.tsx` | Nav renders correct links for user vs admin vs unauthenticated |
| `ProtectedRoute.test.tsx` | Redirects unauthenticated users; blocks non-admin on adminOnly |
| `ErrorBoundary.test.tsx` | Catches render errors and shows fallback UI |
| `api.test.ts` | Axios interceptors: token attachment, expiry redirect, 401 handling |
| `debug.test.ts` | Development utility tests |
| `setup.ts` | Global test setup — imports `@testing-library/jest-dom` matchers |

---

## 6. Infrastructure & DevOps

### 6.1 Dockerfile (Backend)
Multi-stage build:

**Stage 1 (`build`):** Uses `eclipse-temurin:17-jdk-alpine`. Copies Gradle wrapper + source, then runs `./gradlew bootJar` with a BuildKit cache mount for the Gradle dependency cache (speeds up CI — dependencies are not re-downloaded on every build).

**Stage 2 (runtime):** Uses the smaller `eclipse-temurin:17-jre-alpine` (no compiler or tools). Copies only the built JAR. Creates a non-root `appuser` and runs the JAR as that user (security best practice). Sets a Docker `HEALTHCHECK` that polls `/actuator/health` every 30 seconds. Sets OCI image labels with `GIT_COMMIT` and `APP_VERSION` build args for traceability.

### 6.2 `frontend/Dockerfile`
Two-stage build: Node 20 Alpine to build the Vite app, then Nginx Alpine to serve the static output. Uses the custom `nginx.conf` for SPA routing and backend proxy.

### 6.3 `docker-compose.yml`
Base compose file used locally and as the foundation for overlays:

| Service | Port | Notes |
|---|---|---|
| `postgres` | 5432 | Postgres 16 Alpine; volume-backed; health check with `pg_isready` |
| `backend` | 8080 | Built from root `Dockerfile`; depends on healthy postgres |
| `frontend` | 80 | Built from `./frontend`; depends on backend |

Credentials and JWT secret default to dev values but should be overridden via environment variables.

### 6.4 `docker-compose.staging.yml` & `docker-compose.prod.yml`
Overlays that override the base compose file with environment-specific values (stricter resource limits, different image tags, persistent volumes, etc.). Applied using Docker Compose's `-f` flag: `docker compose -f docker-compose.yml -f docker-compose.prod.yml up`.

### 6.5 `.github/workflows/ci.yml`
The main CI/CD pipeline. Triggers on pushes to `main`/`develop` and on pull requests.

**Stage 1 — Quality Gates (parallel):**
- `quality-backend` — runs `./gradlew test jacocoTestReport jacocoTestCoverageVerification`; uploads HTML coverage report as artifact; fails if coverage < 80%
- `quality-frontend` — runs `npm run lint`, TypeScript check (`tsc --noEmit`), and `npm run test:coverage`; uploads coverage as artifact

**Stage 2 — Build & Push Docker Images** (only on pushes, after both quality gates pass):
- Logs into GitHub Container Registry (GHCR)
- Builds backend and frontend images using `docker/build-push-action` with BuildKit caching (`type=gha`)
- Tags each image with the full commit SHA (`sha-<sha>`), the branch name, semver (on tags), and `latest` (on `main` only)
- Generates SBOM and provenance attestations
- Runs a Trivy vulnerability scan on the backend image; uploads SARIF results to the GitHub Security tab

**Stage 3 — Deploy to Staging:**
- SSHs into the staging server, pre-pulls the new images, writes the tag to `.deployed-tag`, and runs `docker compose up -d`
- Polls until the backend container reports `(healthy)`, max 120 seconds

**Stage 3b — Smoke Tests (Staging):**
- Runs `scripts/smoke-test.sh` against `$STAGING_URL`

**Stage 4 — Deploy to Production** (only from `main`, after staging smoke tests pass):
- Identical rolling-update procedure on the production server, max 180-second health wait
- Runs `scripts/smoke-test.sh` against `$PRODUCTION_URL`
- **Auto-rollback:** If the deploy step OR smoke test fails, a final step re-deploys the previous SHA tag from `.previous-tag`

### 6.6 `.github/workflows/security.yml`
A scheduled security scan workflow (runs weekly). Uses GitHub's CodeQL for static analysis and Trivy for dependency/container vulnerability scanning.

### 6.7 `.github/workflows/rollback.yml`
A manually-triggered workflow (`workflow_dispatch`) that allows rolling back to a specific image tag on either staging or production without going through the full CI pipeline. Takes `environment` and `image_tag` as inputs.

### 6.8 `scripts/smoke-test.sh`
A bash script run after every deployment to verify the deployment is healthy:

1. **Waits** for the URL to be reachable (up to `$SMOKE_TIMEOUT` seconds, default 60)
2. **Test 1:** `GET /` returns HTTP 200 and HTML contains `<div id="root">` (React mount point)
3. **Test 2:** `GET /health` returns 200 and JSON body contains `"status":"UP"`
4. **Test 3:** `GET /api/v1/branches` returns 200 (or 401/403 — the service is running)
5. **Test 4:** `GET /login` returns 200 — verifies Nginx `try_files` SPA routing is working

Exits with code 1 if any test fails, triggering the auto-rollback in CI.

---

## 7. Data Flow Walkthrough

**Booking an appointment — full round trip:**

```
Browser (BookingPage)
  │
  ├─ GET /api/v1/branches/:id          → BranchController → BranchService → BranchRepository
  ├─ GET /api/v1/services              → ServiceTypeController → ServiceTypeRepository
  ├─ GET /api/v1/slots?branchId=&date= → SlotController → SlotService → AppointmentSlotRepository
  │
  └─ POST /api/v1/appointments  {slotId, serviceTypeId, customerName, ...}
        │  Authorization: Bearer <JWT>
        ▼
     JwtAuthenticationFilter
        │  validates token, sets SecurityContext with email as principal
        ▼
     AppointmentController.bookAppointment()
        │  sets request.userId = authentication.getName() (email from JWT)
        ▼
     AppointmentService.bookAppointment()
        ├─ slotRepository.findById()       → 404 if missing
        ├─ check slot.status == AVAILABLE  → 409 if not
        ├─ serviceTypeRepository.findById() → 404 if missing
        ├─ slot.setStatus(BOOKED), save
        └─ new Appointment(...), save      ← @PrePersist sets createdAt + referenceNumber
        ▼
     AppointmentMapper.toResponse()       ← entity → DTO
        ▼
     HTTP 201 Created  { id, referenceNumber, date, time, status: "PENDING", ... }
        ▼
     Browser navigates to /appointments
```

---

## 8. Security Model

| Control | Implementation |
|---|---|
| Authentication | JWT (HMAC-SHA256), 15-minute expiry, stateless — no sessions |
| Authorisation | Spring Security method security (`@PreAuthorize`) + URL-level rules |
| Password storage | BCrypt cost factor 12 |
| Brute force protection | 5 failed logins → 15-minute account lock; rate limiter (5 req/min/IP on auth endpoints) |
| Optimistic locking | `@Version` on `AppointmentSlot` prevents double-booking under concurrent requests |
| CORS | Allow-list of known frontend origins; credentials allowed |
| Security headers | HSTS, X-Content-Type-Options, CSP (`default-src 'self'`), Referrer-Policy |
| Token in-memory | Frontend stores JWT in memory (not localStorage) to reduce XSS surface |
| Non-root container | Docker image runs as `appuser`, not root |
| Audit trail | Dedicated `SECURITY_AUDIT` logger for all auth and admin events |
| Vulnerability scanning | Trivy on Docker images in CI; CodeQL weekly static analysis |

---

## 9. Database Schema Summary

```
users
  id, email (unique), password, first_name, last_name, phone_number,
  role, failed_login_attempts, account_locked_until, created_at

branches
  id, name, code (unique), address, province, latitude, longitude

operating_hours
  id, branch_id (FK), day_of_week, open_time, close_time, closed

holidays
  id, date (unique), name, open, special_open_time, special_close_time

service_types
  id, name, description, duration_minutes, required_documents

appointment_slots
  id, branch_id (FK), slot_date, start_time, end_time, status, version
  UNIQUE (branch_id, slot_date, start_time)

appointments
  id, user_id, slot_id (FK, unique), service_type_id (FK), status,
  customer_name, customer_phone, customer_email,
  reference_number, created_at
```

---

## 10. Environment Variables Reference

| Variable | Used By | Description |
|---|---|---|
| `JWT_SECRET` | Backend | HMAC signing key — must be at least 256 bits (32 chars) |
| `JWT_EXPIRATION` | Backend | Token TTL in milliseconds (default: 900000 = 15 min) |
| `SPRING_DATASOURCE_URL` | Backend | JDBC connection URL for PostgreSQL |
| `SPRING_DATASOURCE_USERNAME` | Backend | Database username |
| `SPRING_DATASOURCE_PASSWORD` | Backend | Database password |
| `SPRING_PROFILES_ACTIVE` | Backend | `dev` (H2) or `prod` (PostgreSQL) |
| `APP_CORS_ALLOWED_ORIGINS` | Backend | Comma-separated list of allowed frontend origins |
| `POSTGRES_USER` | Docker Compose | PostgreSQL username (also used by backend) |
| `POSTGRES_PASSWORD` | Docker Compose | PostgreSQL password |
| `STAGING_HOST` / `PROD_HOST` | GitHub Actions | SSH target server hostname |
| `STAGING_USER` / `PROD_USER` | GitHub Actions | SSH username on the deploy server |
| `STAGING_SSH_KEY` / `PROD_SSH_KEY` | GitHub Actions | Private SSH key for deploy server |
| `STAGING_JWT_SECRET` / `PROD_JWT_SECRET` | GitHub Actions | Environment-specific JWT secrets |
| `STAGING_DB_USER/PASSWORD` | GitHub Actions | Staging database credentials |
| `PROD_DB_USER/PASSWORD` | GitHub Actions | Production database credentials |

---

## 11. Running the Project Locally

**Prerequisites:** Java 17, Node 20, Docker Desktop

### Option A — Docker Compose (recommended)

```bash
# 1. Copy environment variables
cp .env.example .env
# Edit .env to set a real JWT_SECRET (min 32 chars)

# 2. Start all services (Postgres + Backend + Frontend)
docker compose up --build

# App is available at:
#   Frontend:  http://localhost
#   Backend:   http://localhost:8080
#   Swagger:   http://localhost:8080/swagger-ui.html
#   H2 console: not available in prod mode — use application-dev profile for H2
```

### Option B — Local Development (hot reload)

```bash
# Terminal 1 — Backend (H2 in-memory, dev profile)
./gradlew bootRun

# Terminal 2 — Frontend (Vite dev server with hot reload)
cd frontend
npm install
npm run dev
# Opens at http://localhost:5173

# Demo credentials
# Admin: admin@capitec.co.za / Admin@123
# User:  user@capitec.co.za  / User@123
```

### Running Tests

```bash
# Backend tests with coverage report
./gradlew test jacocoTestReport
# Report: build/reports/jacoco/test/html/index.html

# Frontend tests
cd frontend
npm run test          # watch mode
npm run test:coverage # single run with coverage
```
