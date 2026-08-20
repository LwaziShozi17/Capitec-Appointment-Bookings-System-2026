# Capitec Appointment Booking System — Complete Technical Analysis

> **Purpose:** Full system deep-dive for study, interview preparation, and architectural understanding.
> Covers every file, every layer, every design decision, and every question you may be asked.

---

## Table of Contents

1. [System Architecture Overview](#1-system-architecture-overview)
2. [Request Lifecycle — End to End](#2-request-lifecycle--end-to-end)
3. [Backend — File by File](#3-backend--file-by-file)
   - [Entry Point](#entry-point)
   - [Domain Models](#domain-models)
   - [Enums](#enums)
   - [DTOs](#dtos)
   - [Repositories](#repositories)
   - [Services](#services)
   - [Controllers](#controllers)
   - [Security Layer](#security-layer)
   - [Config Layer](#config-layer)
   - [Exception Handling](#exception-handling)
   - [Mapper](#mapper)
   - [Test Layer](#test-layer)
   - [Configuration Files](#configuration-files)
   - [Docker & CI/CD](#docker--cicd)
4. [Frontend — File by File](#4-frontend--file-by-file)
5. [Authentication & Authorization Deep Dive](#5-authentication--authorization-deep-dive)
6. [Frontend ↔ Backend Communication](#6-frontend--backend-communication)
7. [The Booking Flow — Step by Step](#7-the-booking-flow--step-by-step)
8. [Concurrency & Double-Booking Prevention](#8-concurrency--double-booking-prevention)
9. [Challenges & Design Decisions](#9-challenges--design-decisions)
10. [Suggested Improvements](#10-suggested-improvements)
11. [Interview Preparation](#11-interview-preparation)
12. [How Everything Connects — Final Summary](#12-how-everything-connects--final-summary)

---

## 1. System Architecture Overview

### The Pattern: Layered REST Architecture

This system uses **Layered (N-Tier) Architecture** combined with the **REST API pattern**. Each layer has a single responsibility and communicates only with the layer directly below it. Think of it as a chain of specialists — no one skips the chain.

```
┌─────────────────────────────────────────────────────────────────────┐
│  CLIENT (React / Browser)                                           │
│  Sends HTTP requests with JSON bodies and JWT Bearer tokens         │
└───────────────────────────┬─────────────────────────────────────────┘
                            │ HTTPS / HTTP
┌───────────────────────────▼─────────────────────────────────────────┐
│  SPRING BOOT APPLICATION                                            │
│                                                                     │
│  ┌─────────────────────────────────────────────────────────────┐   │
│  │  FILTER CHAIN (runs before any controller)                  │   │
│  │  1. RateLimitFilter   — blocks brute force on /auth/**      │   │
│  │  2. JwtAuthFilter     — validates token, sets identity      │   │
│  └─────────────────────────────┬───────────────────────────────┘   │
│                                │                                    │
│  ┌─────────────────────────────▼───────────────────────────────┐   │
│  │  CONTROLLER LAYER  (@RestController)                        │   │
│  │  AuthController / AppointmentController / AdminController   │   │
│  │  BranchController / SlotController / ServiceTypeController  │   │
│  │  — Receives HTTP, validates input, returns HTTP responses   │   │
│  └─────────────────────────────┬───────────────────────────────┘   │
│                                │                                    │
│  ┌─────────────────────────────▼───────────────────────────────┐   │
│  │  SERVICE LAYER  (@Service)                                  │   │
│  │  AuthService / AppointmentService / SlotGenerationService   │   │
│  │  BranchService / SlotService                                │   │
│  │  — All business rules, validation logic, transactions       │   │
│  └─────────────────────────────┬───────────────────────────────┘   │
│                                │                                    │
│  ┌─────────────────────────────▼───────────────────────────────┐   │
│  │  REPOSITORY LAYER  (@Repository / JpaRepository)            │   │
│  │  UserRepository / AppointmentRepository                     │   │
│  │  AppointmentSlotRepository / BranchRepository               │   │
│  │  — Data access only, no business logic                      │   │
│  └─────────────────────────────┬───────────────────────────────┘   │
│                                │  Hibernate / JPA / SQL            │
└───────────────────────────────┬─────────────────────────────────────┘
                                │
            ┌───────────────────▼───────────────────┐
            │  DATABASE                             │
            │  H2 (dev/test) — in-memory            │
            │  PostgreSQL (prod) — persistent       │
            └───────────────────────────────────────┘
```

### Why These Layers Exist

| Layer | Responsibility | What happens if you skip it |
|-------|---------------|----------------------------|
| Controller | HTTP in/out, input validation | Business logic bleeds into HTTP layer, untestable |
| Service | Business rules, transactions | Controllers become fat and untestable |
| Repository | Database access | SQL scattered everywhere, impossible to mock |
| Domain | Data shape + DB mapping | No clear model of reality |

---

## 2. Request Lifecycle — End to End

### Example: User Books an Appointment

**The HTTP Request:**
```
POST /api/v1/appointments
Host: localhost:8080
Authorization: Bearer eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJ1c2VyQGNhcGl0ZWMuY28...
Content-Type: application/json

{
  "slotId": 5,
  "serviceTypeId": 2,
  "customerName": "Lwazi Shozi",
  "customerEmail": "lwazi@example.com",
  "customerPhone": "0821234567"
}
```

**Step-by-step through the system:**

```
1. TCP connection received by embedded Tomcat (Spring Boot's built-in server)

2. RateLimitFilter.doFilterInternal()
   → path = "/api/v1/appointments" — NOT /auth/** → passes through immediately

3. JwtAuthenticationFilter.doFilterInternal()
   → reads header: "Authorization: Bearer eyJhbG..."
   → strips "Bearer " → raw token = "eyJhbG..."
   → calls jwtService.isTokenValid(token)
     → parses JWT, verifies HMAC-SHA256 signature with secret key
     → checks expiration date > now
   → valid → extracts email="user@capitec.co.za", role="USER"
   → creates UsernamePasswordAuthenticationToken("user@capitec.co.za", null, [ROLE_USER])
   → SecurityContextHolder.getContext().setAuthentication(authToken)
   → calls filterChain.doFilter() → continues

4. SecurityConfig authorization rules evaluate
   → "/api/v1/appointments" POST → matches .anyRequest().authenticated()
   → SecurityContext has authenticated user → ALLOWED

5. AppointmentController.bookAppointment() called
   → Spring deserializes JSON body into BookingRequest object
   → @Valid annotation triggers Bean Validation:
     - @NotNull slotId → 5 ✓
     - @NotBlank customerName → "Lwazi Shozi" ✓
     - @Email customerEmail → "lwazi@example.com" ✓
   → request.setUserId(authentication.getName()) → sets "user@capitec.co.za"
   → calls appointmentService.bookAppointment(request)

6. AppointmentService.bookAppointment()
   → @Transactional → database transaction BEGINS
   → slotRepository.findById(5) → SQL: SELECT * FROM appointment_slots WHERE id=5
   → slot.getStatus() == AVAILABLE → OK
   → serviceTypeRepository.findById(2) → SQL: SELECT * FROM service_types WHERE id=2
   → slot.setStatus(BOOKED)
   → slotRepository.save(slot) → SQL: UPDATE appointment_slots SET status='BOOKED', version=1 WHERE id=5 AND version=0
   → creates Appointment entity
   → @PrePersist fires → referenceNumber = "CAP-1749869542831"
   → appointmentRepository.save(appointment) → SQL: INSERT INTO appointments(...)
   → @Transactional → transaction COMMITS (both changes persisted atomically)

7. AppointmentMapper.toResponse(appointment)
   → creates AppointmentResponse DTO
   → copies: id, referenceNumber, branchName (from slot.branch.name), date, etc.
   → does NOT expose internal entity fields the client doesn't need

8. ResponseEntity.status(201).body(response)
   → Spring serializes AppointmentResponse to JSON
   → HTTP 201 Created sent to client

9. Frontend receives response
   → navigates to /appointments with success toast message
```

---

## 3. Backend — File by File

---

### Entry Point

#### `Application.java`

```java
@SpringBootApplication
public class Application {
    public static void main(String[] args) {
        SpringApplication.run(Application.class, args);
    }
}
```

**Purpose:** The single ignition point of the entire application.

**What `@SpringBootApplication` does — it combines three annotations:**
- `@Configuration` — this class can define `@Bean` methods
- `@ComponentScan` — scan the `com.capitec.booking` package and all sub-packages for Spring-managed classes (`@Service`, `@Controller`, `@Repository`, `@Component`)
- `@EnableAutoConfiguration` — Spring Boot automatically configures JPA, Tomcat, Jackson (JSON), security defaults, etc. based on what's on the classpath

**Value:** Without this, you'd need hundreds of lines of XML or Java configuration that Spring Boot handles for you.

---

### Domain Models

The domain layer (`domain/model/`) contains **JPA entities** — classes that Hibernate maps directly to database tables. They are the truth about what your system stores.

#### `User.java` → `users` table

**Key fields and their purpose:**

| Field | Type | Why it exists |
|-------|------|---------------|
| `id` | Long | Primary key, auto-increment |
| `email` | String (unique) | Natural identifier; used as JWT subject |
| `password` | String | BCrypt hash — never stored as plaintext |
| `role` | Role enum | Determines access level (USER or ADMIN) |
| `failedLoginAttempts` | int | Counts consecutive wrong passwords |
| `accountLockedUntil` | LocalDateTime | Null = not locked; future time = locked |

**Critical method — `isAccountLocked()`:**
```java
public boolean isAccountLocked() {
    return accountLockedUntil != null && LocalDateTime.now().isBefore(accountLockedUntil);
}
```
This computes whether the user is currently locked. It's on the domain model — not in a service — because this is inherent to what a User *is*. A locked user is still a user.

**`@PrePersist onCreate()`:** Automatically sets `createdAt` the first time the entity is saved. No developer has to remember to call `setCreatedAt()`.

**`role = Role.USER` default:** Every new user starts as non-admin. Elevation to ADMIN must be done explicitly. Secure by default.

---

#### `AppointmentSlot.java` → `appointment_slots` table

This is the **most architecturally interesting** entity in the system.

**Key design decision — `@Version`:**
```java
@Version
private Long version;
```
This enables **optimistic locking**. Here is what happens when two users simultaneously try to book slot #5:

```
Thread A:  SELECT * FROM appointment_slots WHERE id=5  → version=0, status=AVAILABLE
Thread B:  SELECT * FROM appointment_slots WHERE id=5  → version=0, status=AVAILABLE

Thread A:  UPDATE appointment_slots SET status='BOOKED', version=1 WHERE id=5 AND version=0  → 1 row affected ✓
Thread B:  UPDATE appointment_slots SET status='BOOKED', version=1 WHERE id=5 AND version=0  → 0 rows affected ✗

Thread B gets OptimisticLockException → booking fails gracefully
```
The database's own atomicity (only one UPDATE can win the WHERE version=0 race) prevents double booking without holding a lock for the entire request.

**`@UniqueConstraint(columnNames = {"branch_id", "slot_date", "start_time"})`:**
Database-level guarantee. Even if Hibernate is bypassed, the DB refuses duplicate slots for the same branch/time combination.

**`FetchType.LAZY` on Branch:**
```java
@ManyToOne(fetch = FetchType.LAZY)
@JoinColumn(name = "branch_id", nullable = false)
private Branch branch;
```
The branch data is NOT loaded from the DB until you call `slot.getBranch()`. When you query 50 slots, you don't get 50 extra branch joins — you get branch data only when you need it.

---

#### `Appointment.java` → `appointments` table

The core booking record — links user, slot, and service type.

**`@OneToOne` with AppointmentSlot:**
```java
@OneToOne(fetch = FetchType.EAGER)
@JoinColumn(name = "slot_id", nullable = false)
private AppointmentSlot slot;
```
One appointment owns exactly one slot, and one slot belongs to at most one appointment. `EAGER` fetch here because you always need slot details when you load an appointment.

**`@PrePersist` — Auto-generated reference number:**
```java
if (this.referenceNumber == null) {
    this.referenceNumber = "CAP-" + System.currentTimeMillis();
}
```
Every booking gets a unique human-readable reference like `CAP-1749869542831`. Simple but effective.

**Status starts as `PENDING`:**
```java
private AppointmentStatus status = AppointmentStatus.PENDING;
```
Not `CONFIRMED`. This means every booking needs admin confirmation — a deliberate workflow decision that gives the bank operational control.

---

#### `Branch.java` → `branches` table

Represents a physical bank branch.

**`@OneToMany` with OperatingHours:**
```java
@OneToMany(mappedBy = "branch", cascade = CascadeType.ALL, orphanRemoval = true)
private List<OperatingHours> operatingHours = new ArrayList<>();
```
`cascade = CascadeType.ALL` — if you save/delete a branch, its operating hours go with it. `orphanRemoval = true` — if you remove an hour from the list and save, it's deleted from the DB automatically.

---

#### `OperatingHours.java` → `operating_hours` table

Per-branch schedule for each day of the week (Mon–Sun).

**Why this exists separately from Branch:** A branch has different hours on different days (e.g., closed Sunday, short hours Saturday). This is a separate entity because there are 7 rows per branch — not a single field.

---

#### `ServiceType.java` → `service_types` table

Represents what service the customer needs: Account Opening, Card Collection, Loan Application, etc.

`durationMinutes` — how long the service takes. This drives slot duration planning (though currently all slots are 30 min regardless).

`requiredDocuments` — a semicolon-separated string (`"SA ID;Proof of Address"`). Frontend splits this on `;` to render a list. Simple serialization of a one-to-many concept without a separate table.

---

#### `Holiday.java` → `holidays` table

Public holidays that affect branch operating hours.

**Smart design:** A holiday can be `open=false` (closed entirely) OR `open=true` with `specialOpenTime`/`specialCloseTime` (reduced hours). The `SlotGenerationService` checks this before generating slots, ensuring no slots are created for closed days.

---

### Enums

#### `AppointmentStatus`
```
PENDING → CONFIRMED → IN_PROGRESS → COMPLETED
                   ↘
                   CANCELLED (from any pre-COMPLETED state)
```
The `validateStatusTransition()` method in `AppointmentService` enforces this state machine. You cannot skip states (e.g., go from PENDING directly to COMPLETED). This prevents data corruption.

#### `SlotStatus`
- `AVAILABLE` — bookable
- `BOOKED` — taken by an appointment
- `UNAVAILABLE` — blocked by admin (not currently used in UI but reserved)

#### `Role`
- `USER` — can book, view, and cancel their own appointments
- `ADMIN` — can view all appointments, update status, generate slots

---

### DTOs

DTOs (Data Transfer Objects) are plain classes that define **what data crosses the HTTP boundary**. They are deliberately separate from entities.

**Why separate from entities?**
- Entities have JPA annotations and lazy-loaded relationships — bad to serialize directly
- DTOs expose only what clients need (no internal `version`, `failedLoginAttempts` etc.)
- You can change your DB schema without breaking your API contract

#### `RegisterRequest.java` — Inbound: user registration

```java
@NotBlank @Size(max = 100)               private String firstName;
@NotBlank @Email @Size(max = 255)        private String email;
@Size(min = 8) @Pattern(regexp = "...")  private String password;
```
The `@Pattern` on password enforces: at least one uppercase, one lowercase, one digit, one special character. This is validated by Spring before `AuthService` is even called.

#### `BookingRequest.java` — Inbound: booking an appointment

```java
@NotNull  private Long slotId;
@NotNull  private Long serviceTypeId;
          private String userId;  // set by controller from JWT, not client-supplied
```
**Security note:** `userId` is not in the client's JSON body — the controller sets it from `authentication.getName()`. The client cannot forge a booking on behalf of someone else.

#### `AuthResponse.java` — Outbound: after login/register

```java
{ token, email, name, role }
```
Returns the JWT plus profile data. The frontend stores `email`, `name`, `role` in `localStorage` (non-sensitive) and the `token` in memory only.

#### `AppointmentResponse.java` — Outbound: appointment details

Contains `branchName`, `branchAddress`, `serviceName` as flat strings — not nested objects. The mapper flattens the entity graph into this clean representation, so the frontend doesn't have to navigate nested objects.

---

### Repositories

Spring Data JPA repositories are interfaces. You declare method signatures; Spring generates the SQL at startup.

#### `UserRepository`
```java
Optional<User> findByEmail(String email);
boolean existsByEmail(String email);
```
`findByEmail` → `SELECT * FROM users WHERE email = ?`
`existsByEmail` → `SELECT COUNT(*) > 0 FROM users WHERE email = ?` (more efficient than loading the entity just to check existence)

#### `AppointmentRepository`
```java
List<Appointment> findByUserId(String userId);
List<Appointment> findByStatus(AppointmentStatus status);
```
`findByUserId` → `SELECT * FROM appointments WHERE user_id = ?`
Spring reads the method name, parses `findBy` + `UserId`, generates the query. No SQL written.

#### `AppointmentSlotRepository`
```java
List<AppointmentSlot> findByBranchIdAndDate(Long branchId, LocalDate date);
boolean existsByBranchIdAndDateAndStartTime(Long branchId, LocalDate date, LocalTime startTime);
```
`existsByBranchIdAndDateAndStartTime` — used by `SlotGenerationService` to skip slots that already exist. Without this, re-running slot generation would create duplicates.

---

### Services

Services contain all **business logic**. They are `@Transactional` — they control when database transactions begin and commit.

#### `AuthService.java`

**register():**
1. Checks `userRepository.existsByEmail()` — throws if duplicate (atomic, no race condition because `email` has a unique constraint in DB)
2. `passwordEncoder.encode(request.getPassword())` — BCrypt with cost factor 12. Never stored as plaintext. Cost 12 means ~300ms to hash, making brute-force impractical
3. Saves user with `Role.USER`
4. Logs to `AuditLogger`
5. Generates JWT and returns `AuthResponse`

**login():**
```
1. Load user by email (throw if not found — same error as wrong password, prevents email enumeration)
2. Check isAccountLocked() → throw if locked
3. passwordEncoder.matches(inputPassword, hashedPassword)
4. If wrong: increment failedLoginAttempts; if >= 5, lock account for 15 minutes
5. If correct: reset failedLoginAttempts to 0, generate JWT
```

**Why the generic error "Invalid email or password"?**
Never tell an attacker whether the email exists. A specific error like "Email not found" helps attackers enumerate valid accounts.

---

#### `AppointmentService.java`

**bookAppointment():** `@Transactional`

The entire booking — slot status update + appointment creation — happens in one transaction. If the appointment save fails (for any reason), the slot status rollback reverts to AVAILABLE automatically. No orphaned BOOKED slots.

**validateStatusTransition():**
```java
boolean valid = switch (newStatus) {
    case CONFIRMED    -> current == PENDING;
    case IN_PROGRESS  -> current == CONFIRMED;
    case COMPLETED    -> current == IN_PROGRESS;
    default           -> false;
};
```
A finite state machine enforced in code. You cannot complete an appointment that hasn't started. You cannot confirm an already-confirmed appointment. This prevents admin data entry errors.

**cancelAppointment() vs cancelAppointmentAsAdmin():**
- User cancellation: `validateOwnership()` first — you can only cancel your own appointments
- Admin cancellation: no ownership check — admins can cancel any appointment
- Both: re-set slot to `AVAILABLE` so the time window becomes bookable again

**`@Transactional(readOnly = true)` on query methods:**
Tells Hibernate to skip dirty-checking (no need to track changes on entities that won't be modified). Performance optimization + explicit intent declaration.

---

#### `SlotGenerationService.java`

**Why this service exists:** Slots don't appear magically. An admin must generate them for each branch/date range. This service creates 30-minute blocks from a branch's open time to close time.

**Algorithm:**
```java
LocalTime current = openTime;  // e.g., 08:00
while (current.plusMinutes(30).compareTo(closeTime) <= 0) {
    if (!slotRepository.existsByBranchIdAndDateAndStartTime(...)) {
        // create slot from current to current+30min
    }
    current = current.plusMinutes(30);
}
```
Holiday-aware: checks `holidayRepository.findByDate(date)` first:
- Holiday with `open=false` → return empty list (no slots)
- Holiday with `open=true` → use special hours instead of normal hours
- Not a holiday → use branch's regular operating hours for that day

---

#### `BranchService.java` and `SlotService.java`

Simple delegation services:

```java
// BranchService
@Transactional(readOnly = true)
public List<Branch> getAllBranches() { return branchRepository.findAll(); }

// SlotService
@Transactional(readOnly = true)
public List<AppointmentSlot> getSlotsByBranchAndDate(Long branchId, LocalDate date) {
    return slotRepository.findByBranchIdAndDate(branchId, date);
}
```

**Why have a service for such simple operations?** Consistency. All controllers go through services. If tomorrow you need to add caching or additional filtering to `getAllBranches()`, you have one place to do it.

---

### Controllers

Controllers are the HTTP boundary. They do three things only: accept input, call a service, return output.

#### `AuthController.java`

```
POST /api/v1/auth/register → authService.register() → 201 Created
POST /api/v1/auth/login    → authService.login()    → 200 OK
```

`@Valid @RequestBody` — triggers Bean Validation before the method body runs. If validation fails, Spring throws `MethodArgumentNotValidException` and `GlobalExceptionHandler` catches it — the controller method never even executes.

**Permitted without authentication** — in `SecurityConfig`: `.requestMatchers("/api/v1/auth/**").permitAll()`

---

#### `AppointmentController.java`

```
POST   /api/v1/appointments      → book (authenticated users only)
GET    /api/v1/appointments/{id} → get one (owner only, validated in service)
DELETE /api/v1/appointments/{id} → cancel (owner only)
GET    /api/v1/appointments/my   → list user's own appointments
```

`Authentication authentication` parameter — Spring injects the current user's `UsernamePasswordAuthenticationToken` from `SecurityContextHolder`. `authentication.getName()` returns the email set by `JwtAuthenticationFilter`.

---

#### `AdminController.java`

```
GET    /api/v1/admin/appointments          → list all (optional ?status= filter)
PATCH  /api/v1/admin/appointments/{id}/confirm
PATCH  /api/v1/admin/appointments/{id}/start
PATCH  /api/v1/admin/appointments/{id}/complete
PATCH  /api/v1/admin/appointments/{id}/cancel
POST   /api/v1/admin/slots/generate        → generate slots for date range
```

`@PreAuthorize("hasRole('ADMIN')")` at **class level** — every method in this controller requires ADMIN role. This is method-level security in addition to URL-pattern security. Two layers of access control.

PATCH is used for status updates (not PUT) because you're modifying a single aspect of the resource (status), not replacing the whole resource.

---

#### `BranchController.java`

```
GET /api/v1/branches      → list all branches with operating hours
GET /api/v1/branches/{id} → get one branch
```

Permitted without auth: `.requestMatchers(HttpMethod.GET, "/api/v1/branches/**").permitAll()`

Why public? Users need to browse branches before they log in (the home page shows branches).

Mapping to `BranchResponse` is done inline in the controller (not a separate mapper) — a minor inconsistency with `AppointmentController` which uses `AppointmentMapper`. In a larger system you'd extract this to a mapper class.

---

#### `SlotController.java`

```
GET /api/v1/slots?branchId=1&date=2026-06-15 → list slots for branch on date
```

`@DateTimeFormat(iso = DateTimeFormat.ISO.DATE)` — tells Spring how to parse the `date` query parameter from `"2026-06-15"` into `LocalDate`.

---

### Security Layer

#### `JwtService.java`

**Token generation:**
```java
Jwts.builder()
    .subject(user.getEmail())           // who this token is for
    .claim("role", user.getRole().name()) // their role
    .claim("userId", user.getId())
    .claim("name", user.getFullName())
    .issuedAt(new Date())
    .expiration(new Date(now + 900000))  // 15 minutes
    .signWith(getSigningKey())           // HMAC-SHA256
    .compact();
```

**A JWT has three parts (Base64 encoded, dot-separated):**
```
Header.Payload.Signature
eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJ1c2VyQGNhcGl0ZWMuY28uemEi....<signature>
```
Anyone can decode Header and Payload (they're just Base64). But the Signature can only be produced by someone who knows the secret key — so you can verify it was issued by your server.

**`getSigningKey()`:**
```java
return Keys.hmacShaKeyFor(secret.getBytes(StandardCharsets.UTF_8));
```
Converts the string secret (from environment variable `JWT_SECRET`) into a cryptographic key. Must be at least 256 bits (32 characters) for HMAC-SHA256.

**`isTokenValid()`:**
```java
Claims claims = extractClaims(token);
return !claims.getExpiration().before(new Date());
```
`extractClaims()` already throws an exception if the signature is invalid or the token is malformed. If it doesn't throw and expiry is in the future, token is valid.

---

#### `JwtAuthenticationFilter.java`

Extends `OncePerRequestFilter` — guaranteed to run exactly once per request (not once per servlet forward/include).

```java
String authHeader = request.getHeader("Authorization");

if (authHeader == null || !authHeader.startsWith("Bearer ")) {
    filterChain.doFilter(request, response);  // no token → move on (public endpoints allowed)
    return;
}

String token = authHeader.substring(7);  // strip "Bearer "

if (jwtService.isTokenValid(token)) {
    String email = jwtService.extractEmail(token);
    String role = jwtService.extractRole(token);

    UsernamePasswordAuthenticationToken authToken = new UsernamePasswordAuthenticationToken(
        email, null, List.of(new SimpleGrantedAuthority("ROLE_" + role))
    );

    SecurityContextHolder.getContext().setAuthentication(authToken);
}

filterChain.doFilter(request, response);  // always continues
```

**Key insight:** The filter does NOT reject invalid tokens — it just doesn't set an authentication context. The rejection happens downstream when Spring Security checks if the route requires authentication.

`"ROLE_" + role` — Spring Security expects roles prefixed with `ROLE_`. So `Role.ADMIN` becomes authority `"ROLE_ADMIN"` which matches `hasRole('ADMIN')`.

---

#### `RateLimitFilter.java`

In-memory rate limiter for `/api/v1/auth/**` endpoints only.

```java
private final ConcurrentHashMap<String, RateLimitEntry> requestCounts;
```
`ConcurrentHashMap` — thread-safe. Multiple simultaneous requests won't corrupt the counter.

**How it tracks:**
```
key = clientIp + ":" + path  →  e.g. "192.168.1.100:/api/v1/auth/login"
entry = { windowStart: epoch, count: AtomicInteger }
```

`compute()` is atomic — check-then-update happens as one operation, no race condition between "read count" and "increment count".

**Limit: 5 requests per minute per IP on auth endpoints.** After 5 failed login attempts within a minute, the IP gets HTTP 429 Too Many Requests.

**Limitation:** In-memory means it resets on restart and doesn't work across multiple instances (horizontal scaling). Production would use Redis.

---

#### `AuditLogger.java`

A dedicated security audit log using a named logger `"SECURITY_AUDIT"`:

```java
log.info("[AUDIT] action=LOGIN_SUCCESS email={} ip={}", email, ip);
log.warn("[AUDIT] action=ACCOUNT_LOCKED email={} ip={}", email, ip);
```

In production, this logger would be configured to write to a separate log file (or SIEM system) so security events are never mixed with application logs and are never accidentally deleted. Having it as a separate `@Component` rather than inline in `AuthService` means:
- It's mockable in tests
- You can swap the implementation (e.g., write to a DB table instead)
- `AuthService` doesn't need to know *how* auditing works, just that it happens

---

### Config Layer

#### `SecurityConfig.java`

The master security configuration. Key decisions:

**`SessionCreationPolicy.STATELESS`:**
```java
.sessionManagement(session -> session.sessionCreationPolicy(SessionCreationPolicy.STATELESS))
```
No HTTP sessions. Every request must carry its own JWT. This is required for REST APIs — stateful sessions don't work at scale (multiple server instances).

**CSRF disabled:**
```java
.csrf(csrf -> csrf.disable())
```
CSRF attacks exploit session cookies. Since we don't use sessions (we use Bearer tokens), CSRF is not a threat. Safe to disable.

**Security header chain:**
```java
.headers(headers -> headers
    .httpStrictTransportSecurity(hsts -> hsts.maxAgeInSeconds(31536000))  // force HTTPS for 1 year
    .referrerPolicy(...)                                                    // control referrer info
    .contentSecurityPolicy(csp -> csp.policyDirectives("default-src 'self'; ...")) // prevent XSS
)
```
These are HTTP response headers that tell browsers how to handle the response securely.

**`BCryptPasswordEncoder(12)`:**
Cost factor 12 means 2^12 = 4096 iterations of the BCrypt hash function. Takes ~300ms — fast enough for UX, slow enough to make bulk brute-force impractical.

**`@EnableMethodSecurity`:**
Enables `@PreAuthorize` on methods. Without this, `@PreAuthorize("hasRole('ADMIN')")` on `AdminController` does nothing.

---

#### `CorsConfig.java`

CORS (Cross-Origin Resource Sharing) — browsers block requests from one origin to another by default. This config tells Spring to send CORS headers that allow the frontend (on a different port/domain) to talk to the backend.

```java
config.setAllowedOrigins(allowedOrigins);  // from ${app.cors.allowed-origins}
config.setAllowedMethods(List.of("GET", "POST", "PUT", "PATCH", "DELETE", "OPTIONS"));
config.setAllowCredentials(true);
```

`allowedOrigins` is injected from config: `http://localhost:5173` in dev, configurable per environment via `CORS_ALLOWED_ORIGINS` env var in prod.

---

#### `OpenApiConfig.java`

Configures Swagger UI (SpringDoc). Adds a security scheme so you can enter a JWT token in Swagger UI and test authenticated endpoints directly from the browser at `/swagger-ui.html`.

---

#### `DataLoader.java`

Seeds two users on startup if they don't already exist:
- `admin@capitec.co.za` / `Admin@123` (ADMIN role)
- `user@capitec.co.za` / `User@123` (USER role)

Uses `CommandLineRunner` — runs after Spring context is fully initialized. `existsByEmail()` check makes it idempotent — safe to run on every startup.

---

### Exception Handling

#### `GlobalExceptionHandler.java`

`@RestControllerAdvice` — intercepts exceptions thrown anywhere in the controller layer and converts them to structured JSON responses.

| Exception | HTTP Status | Scenario |
|-----------|------------|---------|
| `SlotNotAvailableException` | 409 Conflict | Slot taken by another user |
| `ResourceNotFoundException` | 404 Not Found | Slot, branch, appointment doesn't exist |
| `InvalidOperationException` | 400 Bad Request | Email duplicate, invalid status transition, wrong password |
| `MethodArgumentNotValidException` | 400 Bad Request | Bean validation failed (`@NotBlank`, `@Email`, etc.) |

**Response format:**
```json
{
  "timestamp": "2026-06-14T10:30:00",
  "status": 409,
  "error": "Conflict",
  "message": "Slot is not available for booking"
}
```

**Validation error format (with field-level detail):**
```json
{
  "timestamp": "2026-06-14T10:30:00",
  "status": 400,
  "error": "Validation Failed",
  "details": {
    "email": "Invalid email format",
    "password": "Password must contain at least one uppercase letter..."
  }
}
```

**Why this matters:** Without it, Spring returns its own default error format (which is verbose and inconsistent). This gives your API a predictable, clean error contract that frontend developers can rely on.

---

### Mapper

#### `AppointmentMapper.java`

Converts internal `Appointment` entities to `AppointmentResponse` DTOs and `AppointmentSlot` entities to `SlotResponse` DTOs.

```java
response.setBranchName(appointment.getSlot().getBranch().getName());
```

This traverses: `Appointment → AppointmentSlot → Branch → name`. The DTO flattens this into a single `branchName` string. The frontend gets a flat, easy-to-use object instead of deeply nested data.

**Why a dedicated mapper class instead of putting this in the controller?**
- Testable in isolation
- Controller stays thin
- If response format changes, one place to update

---

### Test Layer

The project has comprehensive tests across all layers — **91%+ backend coverage** enforced by JaCoCo.

#### Unit Tests (`@ExtendWith(MockitoExtension.class)`)

These test a single class in isolation with all dependencies mocked.

**`AppointmentServiceTest.java`** — tests business logic without a database:
```java
@Mock AppointmentRepository appointmentRepository;
@Mock AppointmentSlotRepository slotRepository;
@InjectMocks AppointmentService appointmentService;
```
When `slotRepository.findById(1L)` is called, Mockito returns a pre-configured `AppointmentSlot` instead of hitting the DB. Tests run in milliseconds.

**`JwtServiceTest.java`** — verifies token generation and validation:
- Token contains correct email as subject
- Token is valid immediately after generation
- Token with wrong signature fails validation
- Expired token fails validation

**`RateLimitFilterTest.java`** — verifies IP-based rate limiting triggers correctly after threshold.

#### Integration Tests (`@SpringBootTest @ActiveProfiles("test") @Transactional`)

**`AppointmentIntegrationTest.java`** — tests the full booking flow with a real (H2) database:
```java
// Creates real Branch, Slot, ServiceType in DB
// Calls real appointmentService.bookAppointment()
// Asserts against real DB state
```
`@Transactional` on the test class means each test runs in a transaction that's rolled back at the end — no data leaks between tests.

#### Controller Tests (`@WebMvcTest`)

Test the HTTP layer: correct status codes, JSON structure, security rules applied. Mock the service layer.

---

### Configuration Files

#### `application.properties`

```properties
spring.application.name=Capitec Appointment Booking System
spring.profiles.active=dev
```
Sets the active profile to `dev` by default. CI/CD overrides with `test` or `prod`.

#### `application-dev.yml`

```yaml
spring:
  datasource:
    url: jdbc:h2:mem:capitec_booking  # in-memory, gone when app stops
  jpa:
    hibernate.ddl-auto: create-drop   # drops and recreates schema on every start

jwt:
  secret: ${JWT_SECRET:dev-only-secret-...}  # fallback for local dev, no env var needed

logging:
  level:
    com.capitec.booking: DEBUG
```

H2 in-memory is perfect for development — no database to install, starts fresh every time. `create-drop` means Hibernate auto-generates the schema from your entity annotations.

#### `application-prod.yml`

```yaml
spring:
  datasource:
    url: ${SPRING_DATASOURCE_URL}        # must be set via env var
    username: ${SPRING_DATASOURCE_USERNAME}
    password: ${SPRING_DATASOURCE_PASSWORD}
  jpa:
    hibernate.ddl-auto: validate         # NEVER auto-modify schema in production

jwt:
  secret: ${JWT_SECRET}  # NO fallback — fails to start if not set

management:
  endpoints:
    web:
      exposure:
        include: health  # only /actuator/health exposed publicly in prod
```

`ddl-auto: validate` — Hibernate checks that your entity classes match the existing DB schema. It throws an error at startup if they don't match (instead of silently creating/dropping columns). This protects production data.

`${JWT_SECRET}` with no default — the application will **not start** without this env var. This is intentional — a missing secret must be a hard failure, not a fallback to an insecure default.

---

### Docker & CI/CD

#### `Dockerfile` (Backend)

```dockerfile
FROM eclipse-temurin:17-jdk-alpine AS build   # Stage 1: build
WORKDIR /app
COPY gradlew . && COPY gradle gradle && COPY build.gradle settings.gradle ./
COPY src src
RUN chmod +x gradlew && ./gradlew bootJar --no-daemon -x test

FROM eclipse-temurin:17-jre-alpine              # Stage 2: runtime (smaller image)
WORKDIR /app
RUN addgroup -S appgroup && adduser -S appuser -G appgroup  # non-root user
COPY --from=build /app/build/libs/*.jar app.jar
RUN chown appuser:appgroup app.jar
USER appuser                                    # run as non-root
EXPOSE 8080
HEALTHCHECK --interval=30s CMD wget -qO- http://localhost:8080/actuator/health || exit 1
ENTRYPOINT ["java", "-jar", "app.jar"]
```

**Multi-stage build** — Stage 1 (with JDK) produces the JAR, Stage 2 (with JRE only) runs it. The final image is ~100MB smaller because build tools aren't included.

**Non-root user** — running as `appuser` not `root`. If the container is compromised, the attacker doesn't have root access to the host.

**HEALTHCHECK** — Docker (and Kubernetes) can check if the app is actually healthy, not just running. Uses the Spring Actuator `/health` endpoint.

#### `docker-compose.yml`

```yaml
services:
  postgres:  # database service
  backend:   # Spring Boot app, depends on postgres being healthy
  frontend:  # React/nginx, depends on backend

volumes:
  postgres_data:  # named volume — data persists between container restarts
```

`depends_on: postgres: condition: service_healthy` — the backend won't start until Postgres has passed its health check (`pg_isready`). Prevents startup race conditions.

#### `.github/workflows/ci.yml`

```yaml
on:
  push:
    branches: [main, develop]
  pull_request:
    branches: [main]
```

**Three jobs run on every push/PR:**

1. **backend-tests:**
   - Spins up a real Postgres container as a service
   - Runs `./gradlew test jacocoTestReport`
   - Runs `./gradlew jacocoTestCoverageVerification` — fails if coverage drops below 80%
   - Uploads HTML coverage report as an artifact

2. **frontend-tests:**
   - `npm ci` — clean install (uses exact versions from `package-lock.json`)
   - `npx eslint src/ --max-warnings 0` — zero lint errors tolerated
   - `npx vitest run --coverage` — all tests + coverage with thresholds (80% lines/funcs, 70% branches)

3. **build-docker:** (only runs if both test jobs pass)
   - `docker build` for both backend and frontend — verifies Docker images build successfully

---

## 4. Frontend — File by File

### Architecture Overview

```
src/
├── main.tsx             → React entry point
├── App.tsx              → Router + context providers
├── types/index.ts       → TypeScript interfaces
├── services/
│   ├── api.ts           → Axios instance + interceptors
│   └── tokenStore.ts    → In-memory JWT storage
├── context/
│   ├── AuthContext.tsx  → Auth state (user, login, logout)
│   └── ToastContext.tsx → Toast notification system
├── components/
│   ├── Layout.tsx       → Nav + Outlet wrapper
│   ├── ProtectedRoute.tsx → Auth guard
│   ├── ErrorBoundary.tsx  → React crash boundary
│   └── ui/             → Reusable UI atoms (Skeleton, StatCard, ConfirmModal)
└── pages/
    ├── HomePage.tsx
    ├── LoginPage.tsx
    ├── RegisterPage.tsx
    ├── BranchesPage.tsx
    ├── BookingPage.tsx       → 3-step booking wizard
    ├── AppointmentsPage.tsx  → User's bookings
    └── AdminPage.tsx         → Admin dashboard
```

---

#### `main.tsx`

```tsx
ReactDOM.createRoot(document.getElementById('root')!).render(<App />)
```
The single DOM injection point. `StrictMode` (if used) renders components twice in dev to detect side effects.

---

#### `App.tsx`

The composition root — wires together all providers and routes.

```tsx
<ErrorBoundary>         ← catches any unhandled React error
  <BrowserRouter>       ← gives access to URL/navigation
    <AuthProvider>      ← auth state available everywhere
      <ToastProvider>   ← toast notifications available everywhere
        <Routes>
          <Route element={<Layout />}>        ← shared nav wrapper
            <Route path="/" element={<HomePage />} />
            <Route path="/login" element={<LoginPage />} />
            <Route path="/branches" element={
              <ProtectedRoute>               ← auth guard
                <BranchesPage />
              </ProtectedRoute>
            } />
            <Route path="/admin" element={
              <ProtectedRoute adminOnly>     ← admin-only guard
                <AdminPage />
              </ProtectedRoute>
            } />
          </Route>
        </Routes>
      </ToastProvider>
    </AuthProvider>
  </BrowserRouter>
</ErrorBoundary>
```

**Why this nesting order matters:**
- `BrowserRouter` must wrap everything that uses navigation
- `AuthProvider` must be inside `BrowserRouter` so `AuthContext` can use `useNavigate`
- `ToastProvider` inside `AuthProvider` so toasts can be triggered after auth actions
- `ErrorBoundary` outside everything — catches crashes from any layer

---

#### `services/tokenStore.ts`

```typescript
let _token: string | null = null;

export const tokenStore = {
  set: (token: string | null) => { _token = token; },
  get: () => _token,
};
```

A module-scoped singleton. `_token` lives in JavaScript memory — not `localStorage`, not `sessionStorage`. When the page refreshes, it's gone. This is intentional: **tokens should not persist across sessions** from a security standpoint. An attacker who reads `localStorage` gets only non-sensitive profile data (`email`, `name`, `role`), never the token.

---

#### `services/api.ts`

```typescript
const api = axios.create({ baseURL: '/api/v1' });
```

One Axios instance used by the entire app. Two interceptors:

**Request interceptor** (runs before every outgoing request):
```typescript
const token = tokenStore.get();
if (token) {
    if (isTokenExpired(token)) {
        // clear state, redirect to /login?reason=expired
        return Promise.reject(new Error('Session expired'));
    }
    config.headers.Authorization = `Bearer ${token}`;
}
```
`isTokenExpired()` decodes the JWT payload (Base64) client-side and checks `exp` claim. This prevents making an API call that will fail with 401 — redirect proactively.

**Response interceptor** (runs on every response):
```typescript
if (!error.response) {
    return Promise.reject(new Error('Network error — please check your connection'));
}
if (error.response.status === 401) {
    // clear token, redirect to /login
}
```
Network errors (offline, DNS failure) are given a human-readable message. 401s trigger a clean logout.

---

#### `context/AuthContext.tsx`

```typescript
const [user, setUser] = useState<User | null>(() => {
    const stored = localStorage.getItem('user_profile');
    return stored ? { ...JSON.parse(stored), token: '' } : null;
});
```

On initial load, reads non-sensitive profile from `localStorage` to restore "logged in" UI state. But `token` is set to `''` — the user sees their name in the nav, but any API call will fail (401 → redirect to login) because the token isn't in `tokenStore`. This is correct: the UI can show who you are, but you still need to re-authenticate to take actions.

```typescript
useEffect(() => {
    if (user && user.token) {
        tokenStore.set(user.token);          // put token in memory
        localStorage.setItem('user_profile', { email, name, role }); // no token!
    } else if (!user) {
        tokenStore.set(null);
        localStorage.removeItem('user_profile');
    }
}, [user]);
```

The token lives in `tokenStore` (memory). Profile lives in `localStorage`. Logout clears both.

---

#### `components/ProtectedRoute.tsx`

```typescript
export default function ProtectedRoute({ children, adminOnly = false }: Props) {
    const { user, isAdmin } = useAuth();

    if (!user) return <Navigate to="/login" replace />;
    if (adminOnly && !isAdmin) return <Navigate to="/" replace />;

    return <>{children}</>;
}
```

`replace` on Navigate means the redirect doesn't add to browser history — pressing Back won't bring you back to the protected page.

Admin check uses `isAdmin` from context, which is computed as `user?.role === 'ADMIN'`. This value comes from the JWT payload via the backend — the client can't fake it (the token is signed).

---

#### `components/ErrorBoundary.tsx`

A React class component (must be a class — hooks can't catch render errors):

```typescript
static getDerivedStateFromError(error: Error): State {
    return { hasError: true, error };
}
```

Catches JavaScript errors that occur during rendering, in lifecycle methods, or in constructors of any child component. Shows a friendly "Something went wrong" UI instead of a blank white screen. The `role="alert"` makes it accessible to screen readers.

---

#### `pages/BookingPage.tsx`

The most complex page — a 3-step wizard:

```
Step 1: Select Service        → sets selectedService
Step 2: Pick Date & Time      → sets selectedDate, selectedSlot
Step 3: Customer Details      → sets customerName, customerEmail, customerPhone
```

**Step tracking:**
```typescript
const currentStep = !selectedService ? 0 : !selectedSlot ? 1 : 2;
```
Derived from state — no separate `step` variable needed.

**Slot loading:**
```typescript
useEffect(() => {
    if (!selectedDate || !branchId) return;
    let cancelled = false;  // cleanup flag
    api.get('/slots', { params: { branchId, date: selectedDate } })
       .then(({ data }) => {
           if (!cancelled) { setSlots(data); setPendingDate(selectedDate); }
       });
    return () => { cancelled = true; };  // cleanup if date changes before response
}, [selectedDate, branchId]);
```

The `cancelled` flag handles **stale requests**: if the user picks Monday, then immediately switches to Tuesday before Monday's response arrives, the Monday data is discarded. `pendingDate !== selectedDate` derives a loading state without a separate `setSlotsLoading(true)` in the effect body.

---

#### `context/ToastContext.tsx`

```typescript
const add = useCallback((message: string, variant: ToastVariant) => {
    const id = ++nextId;
    setToasts(prev => [...prev, { id, message, variant }]);
    setTimeout(() => setToasts(prev => prev.filter(t => t.id !== id)), 4000);
}, []);
```

Toasts auto-dismiss after 4 seconds. Each toast has a unique ID (`++nextId` — module-scoped counter) so multiple toasts can coexist without collision.

`aria-live="polite"` on the container — screen readers announce new toast messages without interrupting current reading.

---

#### `types/index.ts`

Single source of truth for all TypeScript interfaces that mirror backend DTOs:

```typescript
export interface AppointmentSlot {
    status: 'AVAILABLE' | 'BOOKED' | 'BLOCKED';  // union type = exact backend enum values
}

export type AppointmentStatus =
    | 'PENDING' | 'CONFIRMED' | 'IN_PROGRESS' | 'COMPLETED' | 'CANCELLED';
```

Using union types (not just `string`) means TypeScript catches typos at compile time. If you write `status === 'CONFIRMD'`, TypeScript errors.

---

## 5. Authentication & Authorization Deep Dive

### JWT — What It Is and How It Works

JWT (JSON Web Token) is a self-contained, signed token. The server issues it; the client includes it in every subsequent request; the server verifies it without a database lookup.

**Structure:**
```
Header.Payload.Signature

eyJhbGciOiJIUzI1NiJ9  →  {"alg":"HS256"}
.
eyJzdWIiOiJ1c2VyQGNhcGl0ZWMuY28uemEiLCJyb2xlIjoiVVNFUiIsImV4cCI6MTc0OTg3MTAwMH0
→  {"sub":"user@capitec.co.za","role":"USER","exp":1749871000,"userId":3,"name":"Demo User"}
.
<HMAC-SHA256 signature>
```

Anyone can decode the payload — it's just Base64. But to **forge** a token (change the role to ADMIN), you need the secret key. Without it, the signature won't match and `jwtService.isTokenValid()` returns false.

### Full Login Flow

```
1. POST /api/v1/auth/login  { email, password }

2. AuthController receives request
   → @Valid validates: email not blank, password not blank

3. AuthService.login()
   → userRepository.findByEmail(email)
   → if not found: throw InvalidOperationException("Invalid email or password")
   → if account locked (accountLockedUntil > now): throw
   → passwordEncoder.matches(inputPassword, user.getPassword())
     → BCrypt recomputes hash of inputPassword and compares to stored hash
   → if mismatch: increment failedAttempts, maybe lock, throw
   → if match: reset failedAttempts, generate token

4. jwtService.generateToken(user)
   → builds JWT with email as subject, role claim, 15-minute expiry
   → signs with HMAC-SHA256 using secret key

5. Returns: { token, email, name, role }

6. Frontend:
   → setUser({ email, name, role, token })
   → useEffect: tokenStore.set(token), localStorage.setItem('user_profile', {...})
   → navigate to '/'
```

### Full Request Authentication Flow (after login)

```
1. Frontend makes API call (e.g., GET /api/v1/appointments/my)
   → api.ts request interceptor:
     → token = tokenStore.get()
     → isTokenExpired(token)? → if yes: redirect to login
     → config.headers.Authorization = "Bearer " + token

2. Backend receives request
   → RateLimitFilter: not /auth/** → pass through
   → JwtAuthenticationFilter:
     → extract token from "Authorization: Bearer ..." header
     → jwtService.isTokenValid(token):
       → parse JWT, verify HMAC-SHA256 signature
       → check expiration
     → if valid: extract email + role, set in SecurityContextHolder
   → SecurityConfig rules: authenticated? → yes → proceed
   → Controller: authentication.getName() → user's email
```

### Role-Based Access Control

Two levels of enforcement:

**Level 1 — URL pattern (SecurityConfig):**
```java
.requestMatchers("/api/v1/admin/**").hasRole("ADMIN")
.anyRequest().authenticated()
```

**Level 2 — Method level (AdminController):**
```java
@PreAuthorize("hasRole('ADMIN')")
public class AdminController { ... }
```

Both are needed. URL patterns are coarse-grained. Method security is the safety net. If someone misconfigures the URL pattern, `@PreAuthorize` still protects the method.

**User-level ownership check (AppointmentService):**
```java
private void validateOwnership(Appointment appointment, String authenticatedUserId) {
    if (!appointment.getUserId().equals(authenticatedUserId)) {
        throw new InvalidOperationException("You do not have permission...");
    }
}
```
Even authenticated users cannot access other users' appointments. The email from the JWT is compared to the appointment's stored userId.

---

## 6. Frontend ↔ Backend Communication

### API Base URL

```typescript
const api = axios.create({ baseURL: '/api/v1' });
```

`/api/v1` — relative URL. In development, Vite proxies `/api/v1/**` to `http://localhost:8080/api/v1/**`. In production, the frontend Nginx config proxies to the backend container.

### All API Endpoints

| Method | Endpoint | Auth Required | Role | Description |
|--------|----------|---------------|------|-------------|
| POST | `/auth/register` | No | — | Register new user |
| POST | `/auth/login` | No | — | Login, get JWT |
| GET | `/branches` | No | — | List all branches |
| GET | `/branches/{id}` | No | — | Get branch details |
| GET | `/services` | No | — | List service types |
| GET | `/slots?branchId=1&date=2026-06-15` | Yes | USER | Get available slots |
| POST | `/appointments` | Yes | USER | Book an appointment |
| GET | `/appointments/my` | Yes | USER | My appointments |
| GET | `/appointments/{id}` | Yes | USER | Get one appointment |
| DELETE | `/appointments/{id}` | Yes | USER | Cancel appointment |
| GET | `/admin/appointments` | Yes | ADMIN | All appointments |
| PATCH | `/admin/appointments/{id}/confirm` | Yes | ADMIN | Confirm |
| PATCH | `/admin/appointments/{id}/start` | Yes | ADMIN | Start |
| PATCH | `/admin/appointments/{id}/complete` | Yes | ADMIN | Complete |
| PATCH | `/admin/appointments/{id}/cancel` | Yes | ADMIN | Cancel |
| POST | `/admin/slots/generate` | Yes | ADMIN | Generate slots |

### Example: Login Request/Response

**Request:**
```
POST /api/v1/auth/login
Content-Type: application/json

{
  "email": "user@capitec.co.za",
  "password": "User@123"
}
```

**Success Response (200 OK):**
```json
{
  "token": "eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJ1c2VyQGNhcGl0ZWMuY28uemEi...",
  "email": "user@capitec.co.za",
  "name": "Demo User",
  "role": "USER"
}
```

**Error Response (400 Bad Request):**
```json
{
  "timestamp": "2026-06-14T10:30:00",
  "status": 400,
  "error": "Bad Request",
  "message": "Invalid email or password"
}
```

### Example: Book Appointment Request/Response

**Request:**
```
POST /api/v1/appointments
Authorization: Bearer eyJhbGciOiJIUzI1NiJ9...
Content-Type: application/json

{
  "slotId": 5,
  "serviceTypeId": 2,
  "customerName": "Lwazi Shozi",
  "customerEmail": "lwazi@example.com",
  "customerPhone": "0821234567"
}
```

**Success Response (201 Created):**
```json
{
  "id": 42,
  "referenceNumber": "CAP-1749869542831",
  "userId": "user@capitec.co.za",
  "customerName": "Lwazi Shozi",
  "customerEmail": "lwazi@example.com",
  "customerPhone": "0821234567",
  "branchName": "Capitec Sandton",
  "branchAddress": "163 5th St, Sandton",
  "serviceName": "Account Opening",
  "date": "2026-06-20",
  "startTime": "09:00:00",
  "endTime": "09:30:00",
  "status": "PENDING",
  "createdAt": "2026-06-14T10:30:00"
}
```

**Conflict Response (409):**
```json
{
  "timestamp": "2026-06-14T10:30:01",
  "status": 409,
  "error": "Conflict",
  "message": "Slot is not available for booking"
}
```

---

## 7. The Booking Flow — Step by Step

### Phase 1 — Discovery (no auth needed)

```
User lands on /
→ HomePage shows "Sign In" and "Create Account" buttons

User clicks "Sign In" → /login
→ Enters credentials → POST /api/v1/auth/login
→ JWT stored in tokenStore, profile in localStorage
→ Redirected to / — now shows "Book Appointment" and "My Appointments"

User navigates to /branches (protected by ProtectedRoute)
→ GET /api/v1/branches → list of branches displayed
→ User sees Capitec Sandton, Capitec Canal Walk, etc.
→ User clicks a branch → navigates to /book/1
```

### Phase 2 — Booking Wizard

```
/book/1 (BookingPage, branchId=1)

On mount:
  Promise.all([
    GET /api/v1/branches/1,   → branch name, address, province
    GET /api/v1/services      → list of service types
  ])

Step 1: Select Service
  User selects "Account Opening" (serviceTypeId=1, durationMinutes=45)
  → selectedService set, UI advances to Step 2 indicator

Step 2: Date & Time
  User picks date: 2026-06-20
  → GET /api/v1/slots?branchId=1&date=2026-06-20
  → Returns: [
      { id:5, startTime:"08:00", status:"AVAILABLE" },
      { id:6, startTime:"08:30", status:"BOOKED" },
      { id:7, startTime:"09:00", status:"AVAILABLE" },
      ...
    ]
  → BOOKED and PAST slots shown greyed out, unclickable
  User clicks "09:00" → selectedSlot=7

Step 3: Your Details
  customerName pre-filled? No (requires explicit input)
  customerEmail pre-filled from user.email (from AuthContext)
  User fills in phone number

Submit:
  POST /api/v1/appointments {
    slotId: 7,
    serviceTypeId: 1,
    customerName: "Lwazi Shozi",
    customerEmail: "lwazi@capitec.co.za",
    customerPhone: "0821234567"
  }
```

### Phase 3 — Post-Booking

```
201 Created response received
→ navigate('/appointments', { state: { message: 'Appointment booked successfully!' } })
→ AppointmentsPage shows toast: "Appointment booked successfully!"
→ GET /api/v1/appointments/my
→ Shows CAP-1749869542831 with status PENDING

Admin logs in, navigates to /admin
→ GET /api/v1/admin/appointments
→ Sees CAP-1749869542831 PENDING
→ Clicks "Confirm" → PATCH /api/v1/admin/appointments/42/confirm
→ Status: PENDING → CONFIRMED

Day of appointment:
→ Admin clicks "Start" → CONFIRMED → IN_PROGRESS
→ After service: "Complete" → IN_PROGRESS → COMPLETED
```

### Cancellation Flow

```
User clicks "Cancel" on their appointment
→ ConfirmModal appears: "Are you sure?"
→ User confirms
→ DELETE /api/v1/appointments/42
→ AppointmentService.cancelAppointment(42, "user@capitec.co.za")
  → validateOwnership: appointment.userId == authenticatedUserId ✓
  → appointment.status = CANCELLED
  → slot.status = AVAILABLE  ← slot is freed for another user
  → both saved in one transaction
→ UI refreshes, appointment shows as CANCELLED
```

---

## 8. Concurrency & Double-Booking Prevention

### The Problem

Consider two users simultaneously trying to book slot #5:

```
Time T0: User A loads slot #5 → status=AVAILABLE
Time T0: User B loads slot #5 → status=AVAILABLE

Time T1: User A submits booking
Time T1: User B submits booking (at the exact same moment)
```

Without protection, both might succeed — two appointments for one slot.

### Layer 1 — `@Transactional` in `bookAppointment()`

The entire booking logic runs inside one database transaction. No other transaction can see partial changes.

### Layer 2 — Optimistic Locking (`@Version`)

```java
@Version
private Long version;  // starts at 0
```

When Hibernate saves the slot, it generates:
```sql
UPDATE appointment_slots
SET status='BOOKED', version=1
WHERE id=5 AND version=0
```

**Scenario:**
```
Thread A: SELECT → version=0, AVAILABLE
Thread B: SELECT → version=0, AVAILABLE

Thread A: UPDATE ... WHERE id=5 AND version=0 → 1 row updated ✓ → commits
Thread B: UPDATE ... WHERE id=5 AND version=0 → 0 rows updated ✗
          → Hibernate throws OptimisticLockException
          → Transaction rolls back
          → Client gets 409 Conflict (slot no longer available)
```

### Layer 3 — Database Unique Constraint

```java
@UniqueConstraint(columnNames = {"branch_id", "slot_date", "start_time"})
```

Even without Hibernate optimistic locking, the database itself refuses a second INSERT of the same branch/date/time slot. Belt and suspenders.

### Layer 4 — Application-Level Status Check

```java
if (slot.getStatus() != SlotStatus.AVAILABLE) {
    throw new SlotNotAvailableException("Slot is not available for booking");
}
```

Early fail before any DB writes. The optimistic lock is the actual concurrency guard, but this check is cheap and clear.

---

## 9. Challenges & Design Decisions

### Decision: Stateless JWT vs Sessions

**Chosen:** JWT (stateless)

**Why:** Sessions require storing state server-side (memory or Redis). With multiple server instances (horizontal scaling), sessions become complex (sticky sessions or shared session store). JWTs are self-contained — any server instance can validate them with just the secret key.

**Trade-off:** JWT revocation is hard. If a user's account is compromised and you want to invalidate their token, you can't (without a token blacklist). The 15-minute expiry (`expiration: 900000ms`) limits the damage window.

### Decision: H2 for dev, PostgreSQL for prod

**Why H2:** Zero setup, in-memory, schema generated automatically by Hibernate. Developers can run the app immediately with no database installation.

**Why separate prod config:** `ddl-auto: validate` (not `create-drop`) protects production data. `create-drop` on production would delete all data on restart — catastrophic.

### Decision: Slot Pre-generation vs On-Demand

**Chosen:** Admin generates slots in advance via `/admin/slots/generate`

**Alternative:** Generate slots dynamically when a user queries a date.

**Why pre-generation:** 
- Slots can be blocked/manipulated before users see them
- Admin has explicit control over availability
- Simpler concurrency (booking an existing slot vs creating one)

**Trade-off:** Admin must remember to generate slots. If they forget, users see empty calendars.

### Decision: DTO Pattern

All endpoints return DTOs, not entities.

**Why:** If you return entities, you expose internal fields (`version`, `password`, `failedLoginAttempts`). Changing your DB schema breaks your API. DTOs give you a stable contract.

### Decision: `userId` stored as String (email) not Long

```java
private String userId;  // email address
```

**Why:** The JWT subject is the email. Using email as `userId` means no extra DB lookup to get the Long ID from the email. The trade-off: if a user changes their email (not supported in this app), their appointments lose association.

### Limitation: In-Memory Rate Limiting

`RateLimitFilter` uses a `ConcurrentHashMap` — data lives in one JVM. With multiple backend instances, each has its own counter. An attacker hitting multiple instances stays under the limit at each.

**Production solution:** Redis-backed rate limiting (e.g., Bucket4j + Redis or Spring Cloud Gateway).

### Limitation: Slot Duration Hardcoded

```java
private static final int DEFAULT_SLOT_DURATION_MINUTES = 30;
```

Even though `ServiceType` has `durationMinutes`, slot generation always uses 30 minutes. A 45-minute service will be booked in a 30-minute slot — the service could run over.

**Better design:** Generate slots dynamically based on the service type's duration. Or let admins configure slot duration per branch.

---

## 10. Suggested Improvements

### Performance

| Improvement | Why |
|-------------|-----|
| Redis caching for branches and service types | Rarely change; fetched on every booking page load |
| Pagination on `/admin/appointments` | Gets slow with thousands of appointments |
| Database indexes on `appointments.user_id`, `appointments.status` | JPA generates queries without indexes — full table scans |
| Connection pooling tuning (HikariCP) | Default pool size of 10 may be too small under load |

### Scalability

| Improvement | Why |
|-------------|-----|
| Redis for rate limiting | Current in-memory doesn't work across instances |
| Move to JWT refresh tokens | Short-lived access tokens (15 min) + long-lived refresh tokens reduce re-login friction |
| Async email notifications | Send booking confirmation via email after booking (currently none) |
| Consider event-driven for slot management | Publish "SlotBooked" event → multiple consumers can react |

### Security

| Improvement | Why |
|-------------|-----|
| JWT token blacklist on logout | Currently logout only clears client state — old tokens still valid until expiry |
| httpOnly cookies instead of `tokenStore` | Cookies are immune to XSS; JS can't read them |
| Input sanitization for `customerName` | Currently only length-checked; could contain `<script>` |
| API versioning strategy | `v1` is present but no plan for `v2` migration |

### UX

| Improvement | Why |
|-------------|-----|
| Email confirmation on booking | User has no receipt |
| SMS/email reminders | Reduce no-shows |
| Branch search/filter by location | Currently a flat list |
| Waiting list when slot fills up | Currently "slot taken" is a hard rejection |

### Monitoring

| Improvement | Why |
|-------------|-----|
| Structured logging (JSON) | Current pattern format is human-readable; not parseable by Splunk/ELK |
| Correlation IDs (MDC) | Each request gets a UUID that traces through all log lines |
| Prometheus metrics | Track booking volume, auth failures, slot availability per branch |
| Alerting on `ACCOUNT_LOCKED` spikes | Indicates brute-force attack in progress |

---

## 11. Interview Preparation

### Technical Questions & Strong Answers

---

**Q: Explain your system architecture.**

> "The system uses layered REST architecture with four layers: Controller handles HTTP, Service contains all business logic and transaction management, Repository does data access, and Domain represents the data model. A filter chain runs before the controller — RateLimitFilter blocks brute-force on auth endpoints, and JwtAuthenticationFilter validates the Bearer token and sets the security context. The frontend is a React SPA that communicates with the backend over HTTP using Axios, with the JWT stored in memory (not localStorage) to reduce XSS risk."

---

**Q: Why use JWT over sessions?**

> "Sessions require shared state across server instances — either sticky routing or a shared session store like Redis. JWTs are self-contained and stateless: any server instance can validate them using just the secret key. This makes horizontal scaling straightforward. The trade-off is revocation difficulty — we mitigate this with a short 15-minute expiry. If we needed immediate revocation (compromised accounts), we'd add a token blacklist in Redis."

---

**Q: Explain the difference between Service and Repository layers.**

> "The Repository is purely a data access abstraction — it translates method calls into SQL queries using Spring Data JPA. It contains no business logic. The Service layer owns all business rules: validation, state transitions, ownership checks, transaction management. This separation means you can test business logic without a database (mock the repository), and you can change the persistence strategy without touching business rules."

---

**Q: How do you prevent double-booking?**

> "Three layers. First, `@Transactional` wraps the entire booking — slot status update and appointment creation happen atomically. Second, `@Version` on `AppointmentSlot` enables optimistic locking: Hibernate generates `UPDATE ... WHERE id=? AND version=0`. If two concurrent requests both read version=0, only one UPDATE wins — the other gets 0 rows affected and Hibernate throws `OptimisticLockException`. Third, a database unique constraint on `(branch_id, slot_date, start_time)` provides a final safety net even if Hibernate is bypassed."

---

**Q: How does Spring Security work in this system?**

> "Spring Security sits as a filter chain in the servlet pipeline. Before any request reaches a controller, it passes through our two custom filters. `RateLimitFilter` enforces request limits on auth endpoints. `JwtAuthenticationFilter` reads the Authorization header, validates the JWT signature and expiry using the secret key, extracts email and role, and stores a `UsernamePasswordAuthenticationToken` in `SecurityContextHolder`. The security configuration then checks this against URL rules (`/api/v1/admin/**` requires ADMIN role). For admin endpoints, `@PreAuthorize("hasRole('ADMIN')")` adds a method-level second check."

---

**Q: What is the DTO pattern and why do you use it?**

> "A DTO — Data Transfer Object — is a plain class that defines the exact shape of data crossing an API boundary. We use it instead of returning entities directly for three reasons: First, entities contain sensitive fields (password hash, version number, failed login attempts) that we don't want to expose. Second, entities have JPA lazy relationships that can trigger extra SQL queries during JSON serialization. Third, DTOs give us a stable API contract — we can refactor the internal entity without breaking clients. The AppointmentMapper converts between the entity graph and the flat DTO."

---

**Q: Explain `@Transactional` and when you use `readOnly = true`.**

> "`@Transactional` marks a method as a unit of work. All DB operations inside it share one transaction — if any fail, all roll back. The `readOnly = true` flag on query methods does two things: it tells Hibernate to skip dirty checking (no need to snapshot entity state when you know nothing will be written), which improves performance on methods that load many entities. It also signals intent — if someone accidentally adds a write operation to a read-only method, they'll get an exception, preventing silent bugs."

---

**Q: How does BCrypt password hashing work?**

> "BCrypt applies a cost factor (we use 12, meaning 2^12 iterations) to make hashing deliberately slow — about 300ms. This makes bulk brute-force impractical: even with a database breach, an attacker can check roughly 3 passwords per second per CPU core. BCrypt also incorporates a random salt into each hash, so the same password produces different hashes — pre-computed rainbow table attacks don't work. To verify, you call `passwordEncoder.matches(input, storedHash)` — BCrypt extracts the salt from the stored hash and re-applies the same algorithm."

---

**Q: Walk me through what happens when a user logs in.**

> "The login request hits `RateLimitFilter` first — if the IP has exceeded 5 auth requests per minute, it returns 429. Then `JwtAuthenticationFilter` runs — since there's no token yet (it's a login), it passes through. The request reaches `AuthController.login()`, where `@Valid` validates the request body. `AuthService.login()` queries for the user by email — using a generic error message to prevent email enumeration. It checks account lock status — after 5 failed attempts, accounts lock for 15 minutes. If the password matches BCrypt comparison, it resets the failure counter, logs the success to `AuditLogger`, generates a JWT with `JwtService`, and returns the token with the user's profile."

---

### Behavioral Questions & Strong Answers

---

**Q: What was the most challenging part of building this system?**

> "The double-booking prevention required careful thought. My first instinct was to use a pessimistic database lock (SELECT FOR UPDATE), but that holds a lock for the entire transaction duration and degrades under concurrent load. I chose optimistic locking with `@Version` instead — it lets concurrent reads happen freely and only conflicts at the write step. Combined with the `@Transactional` boundary and a unique constraint, the solution handles race conditions without sacrificing throughput. Testing it required writing concurrent integration tests which was itself an interesting challenge."

---

**Q: How do you approach debugging a production issue?**

> "I start with structured logs — search for the request's correlation ID to trace its entire path through the system. In this system, the `AuditLogger` would show auth events; the service layer logs `Booking appointment for user={} slotId={}` at INFO and failures at WARN. If the issue is a data inconsistency, I'd check the `@Version` numbers on affected slots to see if there were conflicting updates. For performance issues, I'd look at slow query logs — queries hitting large tables without the right indexes."

---

**Q: How would you design this system to handle 10x the load?**

> "Three areas: First, horizontal scaling of the backend — the stateless JWT architecture already supports this, but I'd need Redis for rate limiting instead of the in-memory `ConcurrentHashMap`. Second, a read replica for the database — most queries (browse branches, view appointments) are reads. Route reads to the replica, writes to primary. Third, caching branches and service types in Redis — these rarely change but are fetched on every booking page load. I'd also add a queue for slot generation rather than generating synchronously in the admin request."

---

### Quick-Fire Technical Definitions

| Term | Definition |
|------|-----------|
| `@Entity` | Maps a Java class to a database table |
| `@Repository` | Spring-managed DAO; Spring Data generates query implementations |
| `@Service` | Spring-managed business logic component |
| `@RestController` | `@Controller` + `@ResponseBody` — all methods serialize return values to JSON |
| `@Transactional` | Wraps method in a DB transaction; rolls back on unchecked exceptions |
| `@Valid` | Triggers Bean Validation on the annotated parameter |
| `@PreAuthorize` | Method-level security using Spring EL expressions |
| `JpaRepository` | Extends `CrudRepository`; provides `save()`, `findById()`, `findAll()`, `delete()` etc. |
| `SecurityContextHolder` | Thread-local storage for the current user's authentication |
| `OncePerRequestFilter` | Base class for filters that run exactly once per request |
| `OptimisticLocking` | Detect-and-reject conflicts using a version field, without holding DB locks |
| `@PrePersist` | JPA lifecycle callback: runs before the entity is first inserted |
| `ResponseEntity<T>` | Wraps a response body with explicit HTTP status code |

---

## 12. How Everything Connects — Final Summary

### The Complete Picture

```
User opens browser
    │
    ▼
React SPA loads (HTML + JS bundle from Nginx)
    │
    │  Unauthenticated: browse branches, view services
    │  Authenticated: book appointments, view bookings
    │
    ▼
AuthContext holds user state
    ├── Profile (email, name, role) → localStorage (survives refresh)
    └── Token → tokenStore in-memory (cleared on refresh = forced re-auth)
    │
    ▼
api.ts Axios instance
    ├── Request interceptor: check expiry → attach Authorization header
    └── Response interceptor: 401 → logout, network fail → friendly message
    │
    │  Every API call:
    │  POST/GET/PATCH/DELETE /api/v1/...
    │  Headers: { Authorization: Bearer <token>, Content-Type: application/json }
    │
    ▼
Spring Boot (embedded Tomcat)
    │
    ├─ Filter 1: RateLimitFilter
    │   └── /auth/** endpoints: max 5/min per IP
    │
    ├─ Filter 2: JwtAuthenticationFilter
    │   └── Validates token → sets SecurityContextHolder
    │
    ├─ SecurityConfig: URL authorization rules
    │   ├── /auth/** → public
    │   ├── /admin/** → ADMIN only
    │   └── everything else → authenticated
    │
    ├─ Controller (HTTP layer)
    │   ├── @Valid: Bean Validation (reject bad input before service)
    │   ├── authentication.getName(): current user's email
    │   └── Delegates to Service
    │
    ├─ Service (Business logic)
    │   ├── @Transactional: atomic DB operations
    │   ├── Business rules: status transitions, ownership checks
    │   ├── Optimistic locking: @Version on AppointmentSlot
    │   └── Delegates to Repository
    │
    ├─ Repository (Data access)
    │   └── Spring Data JPA → generates SQL from method names
    │
    └─ GlobalExceptionHandler
        └── Converts exceptions → consistent JSON error responses
    │
    ▼
Database
    ├── H2 in-memory (dev/test)
    └── PostgreSQL (prod)
        ├── users
        ├── branches + operating_hours
        ├── service_types
        ├── holidays
        ├── appointment_slots  ← @Version for optimistic locking
        └── appointments
```

### Why This Is Good System Design

**Separation of concerns:** Each layer does one thing. Controllers don't touch the database. Services don't build HTTP responses. Repositories don't contain business logic. This makes each piece independently testable and replaceable.

**Security in depth:** Multiple layers protect each endpoint — rate limiting, JWT validation, URL authorization rules, method-level `@PreAuthorize`, and ownership validation in service code. An attacker must defeat all layers.

**Optimistic concurrency:** The `@Version` field solves the double-booking race condition without database-level locking, preserving throughput under concurrent load.

**Environment separation:** Dev uses H2 with auto-generated schema. Prod uses PostgreSQL with schema validation. Secrets have no defaults in production — missing config fails loudly.

**Observable system:** `AuditLogger` captures every auth event (login success, failure, account lock). Service methods log key operations with structured fields (`user={}`, `slotId={}`). Coverage reports are generated in CI. The system's behavior is visible and verifiable.

**Contract-driven API:** DTOs define the public API contract independent of the internal entity model. Frontend types in `types/index.ts` mirror backend DTOs exactly. Both sides agree on the shape of data.

**Testable at every layer:** Unit tests (mocked repositories), integration tests (real H2 database), controller tests (MockMvc). 91%+ backend coverage enforced by CI. Frontend has 85%+ coverage enforced by Vitest thresholds.

---

*Generated: June 2026 | Stack: Spring Boot 3 + React 18 + TypeScript + PostgreSQL + Docker + GitHub Actions*
