package com.capitec.booking.service;

import com.capitec.booking.domain.enums.Role;
import com.capitec.booking.domain.model.User;
import com.capitec.booking.dto.request.ForgotPasswordRequest;
import com.capitec.booking.dto.request.LoginRequest;
import com.capitec.booking.dto.request.RegisterRequest;
import com.capitec.booking.dto.request.ResetPasswordRequest;
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
import java.util.UUID;

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

    @Transactional
    public AuthResponse register(RegisterRequest request) {
        String email = request.getEmail() != null ? request.getEmail().trim().toLowerCase() : "";
        log.info("Registration attempt for email={}", email);
        if (userRepository.existsByEmail(email)) {
            log.warn("Registration failed: email already exists email={}", email);
            throw new InvalidOperationException("Email already registered");
        }

        User user = new User();
        user.setEmail(email);
        user.setPassword(passwordEncoder.encode(request.getPassword()));
        user.setFirstName(request.getFirstName() != null ? request.getFirstName().trim() : "");
        user.setLastName(request.getLastName() != null ? request.getLastName().trim() : "");
        user.setPhoneNumber(request.getPhoneNumber() != null && !request.getPhoneNumber().trim().isEmpty() ? request.getPhoneNumber().trim() : null);
        user.setRole(Role.USER);

        user = userRepository.save(user);

        auditLogger.logRegistration(user.getEmail(), "system");

        String token = jwtService.generateToken(user);
        return new AuthResponse(token, user.getEmail(), user.getFullName(), user.getRole().name());
    }

    @Transactional
    public AuthResponse login(LoginRequest request) {
        String email = request.getEmail() != null ? request.getEmail().trim().toLowerCase() : "";
        log.info("Login attempt for email={}", email);
        User user = userRepository.findByEmail(email)
                .orElseThrow(() -> new InvalidOperationException("Invalid email or password"));

        if (user.isAccountLocked()) {
            log.warn("Login rejected: account locked email={}", email);
            auditLogger.logLoginFailed(email, "system");
            throw new InvalidOperationException("Account is locked. Please try again later.");
        }

        if (!passwordEncoder.matches(request.getPassword(), user.getPassword())) {
            log.warn("Login failed: invalid password email={}", email);
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

    @Transactional
    public String forgotPassword(ForgotPasswordRequest request) {
        String email = request.getEmail() != null ? request.getEmail().trim().toLowerCase() : "";
        log.info("Password reset requested for email={}", email);

        // Always return the same message to prevent email enumeration
        userRepository.findByEmail(email).ifPresent(user -> {
            String token = UUID.randomUUID().toString();
            user.setPasswordResetToken(token);
            user.setPasswordResetTokenExpiry(LocalDateTime.now().plusHours(1));
            userRepository.save(user);
            // In production this token would be emailed; log it for dev use
            log.info("Password reset token for email={}: {}", email, token);
        });

        return "If that email is registered, a password reset link has been sent.";
    }

    @Transactional
    public void resetPassword(ResetPasswordRequest request) {
        String token = request.getToken() != null ? request.getToken().trim() : "";
        User user = userRepository.findByPasswordResetToken(token)
                .orElseThrow(() -> new InvalidOperationException("Invalid or expired reset token"));

        if (user.getPasswordResetTokenExpiry() == null || LocalDateTime.now().isAfter(user.getPasswordResetTokenExpiry())) {
            throw new InvalidOperationException("Invalid or expired reset token");
        }

        user.setPassword(passwordEncoder.encode(request.getNewPassword()));
        user.setPasswordResetToken(null);
        user.setPasswordResetTokenExpiry(null);
        user.setFailedLoginAttempts(0);
        user.setAccountLockedUntil(null);
        userRepository.save(user);
        log.info("Password reset successful for email={}", user.getEmail());
    }
}