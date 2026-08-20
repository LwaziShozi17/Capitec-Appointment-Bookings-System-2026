package com.capitec.booking.service;

import com.capitec.booking.domain.enums.Role;
import com.capitec.booking.domain.model.User;
import com.capitec.booking.dto.request.LoginRequest;
import com.capitec.booking.dto.request.RegisterRequest;
import com.capitec.booking.dto.response.AuthResponse;
import com.capitec.booking.exception.InvalidOperationException;
import com.capitec.booking.repository.UserRepository;
import com.capitec.booking.security.AuditLogger;
import com.capitec.booking.security.JwtService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;

@Service
public class AuthService {

    private static final Logger log = LoggerFactory.getLogger(AuthService.class);

    private static final int MAX_FAILED_ATTEMPTS = 5;
    private static final int LOCKOUT_DURATION_MINUTES = 15;

    private final UserRepository userRepository;
    private final PasswordEncoder passwordEncoder;
    private final JwtService jwtService;
    private final AuditLogger auditLogger;

    public AuthService(UserRepository userRepository, PasswordEncoder passwordEncoder,
                       JwtService jwtService, AuditLogger auditLogger) {
        this.userRepository = userRepository;
        this.passwordEncoder = passwordEncoder;
        this.jwtService = jwtService;
        this.auditLogger = auditLogger;
    }

    public AuthResponse register(RegisterRequest request) {
        log.info("Registration attempt for email={}", request.getEmail());
        if (userRepository.existsByEmail(request.getEmail())) {
            log.warn("Registration failed: email already exists email={}", request.getEmail());
            throw new InvalidOperationException("Email already registered");
        }

        User user = new User();
        user.setEmail(request.getEmail());
        user.setPassword(passwordEncoder.encode(request.getPassword()));
        user.setFirstName(request.getFirstName());
        user.setLastName(request.getLastName());
        user.setPhoneNumber(request.getPhoneNumber());
        user.setRole(Role.USER);

        user = userRepository.save(user);

        auditLogger.logRegistration(user.getEmail(), "system");

        String token = jwtService.generateToken(user);
        return new AuthResponse(token, user.getEmail(), user.getFullName(), user.getRole().name());
    }

    @Transactional
    public AuthResponse login(LoginRequest request) {
        log.info("Login attempt for email={}", request.getEmail());
        User user = userRepository.findByEmail(request.getEmail())
                .orElseThrow(() -> new InvalidOperationException("Invalid email or password"));

        if (user.isAccountLocked()) {
            log.warn("Login rejected: account locked email={}", request.getEmail());
            auditLogger.logLoginFailed(request.getEmail(), "system");
            throw new InvalidOperationException("Account is locked. Please try again later.");
        }

        if (!passwordEncoder.matches(request.getPassword(), user.getPassword())) {
            log.warn("Login failed: invalid password email={}", request.getEmail());
            handleFailedLogin(user);
            throw new InvalidOperationException("Invalid email or password");
        }

        resetFailedAttempts(user);
        auditLogger.logLoginSuccess(user.getEmail(), "system");
        log.info("Login successful email={} role={}", user.getEmail(), user.getRole());

        String token = jwtService.generateToken(user);
        return new AuthResponse(token, user.getEmail(), user.getFullName(), user.getRole().name());
    }

    private void handleFailedLogin(User user) {
        int attempts = user.getFailedLoginAttempts() + 1;
        user.setFailedLoginAttempts(attempts);

        if (attempts >= MAX_FAILED_ATTEMPTS) {
            user.setAccountLockedUntil(LocalDateTime.now().plusMinutes(LOCKOUT_DURATION_MINUTES));
            userRepository.save(user);
            auditLogger.logAccountLocked(user.getEmail(), "system");
        } else {
            userRepository.save(user);
            auditLogger.logLoginFailed(user.getEmail(), "system");
        }
    }

    private void resetFailedAttempts(User user) {
        if (user.getFailedLoginAttempts() > 0) {
            user.setFailedLoginAttempts(0);
            user.setAccountLockedUntil(null);
            userRepository.save(user);
        }
    }
}