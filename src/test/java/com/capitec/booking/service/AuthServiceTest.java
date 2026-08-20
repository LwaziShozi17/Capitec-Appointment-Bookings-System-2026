package com.capitec.booking.service;

import com.capitec.booking.domain.enums.Role;
import com.capitec.booking.domain.model.User;
import com.capitec.booking.dto.request.LoginRequest;
import com.capitec.booking.dto.request.RegisterRequest;
import com.capitec.booking.dto.response.AuthResponse;
import com.capitec.booking.exception.InvalidOperationException;
import com.capitec.booking.repository.UserRepository;
import com.capitec.booking.security.JwtService;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.security.crypto.password.PasswordEncoder;

import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class AuthServiceTest {

    @Mock
    private UserRepository userRepository;

    @Mock
    private PasswordEncoder passwordEncoder;

    @Mock
    private JwtService jwtService;

    @Mock
    private com.capitec.booking.security.AuditLogger auditLogger;

    @InjectMocks
    private AuthService authService;

    @BeforeEach
    void setUp() {
    }

    @Test
    void shouldRegisterNewUser() {
        RegisterRequest request = new RegisterRequest();
        request.setEmail("newuser@test.com");
        request.setPassword("password123");
        request.setFirstName("New");
        request.setLastName("User");

        when(userRepository.existsByEmail("newuser@test.com")).thenReturn(false);
        when(passwordEncoder.encode("password123")).thenReturn("$2a$encoded");
        when(userRepository.save(any(User.class))).thenAnswer(invocation -> {
            User saved = invocation.getArgument(0);
            saved.setId(1L);
            return saved;
        });
        when(jwtService.generateToken(any(User.class))).thenReturn("jwt-token");

        AuthResponse response = authService.register(request);

        assertThat(response.getToken()).isEqualTo("jwt-token");
        assertThat(response.getEmail()).isEqualTo("newuser@test.com");
        assertThat(response.getRole()).isEqualTo("USER");
    }

    @Test
    void shouldRejectDuplicateEmail() {
        RegisterRequest request = new RegisterRequest();
        request.setEmail("existing@test.com");
        request.setPassword("password123");
        request.setFirstName("Existing");
        request.setLastName("User");

        when(userRepository.existsByEmail("existing@test.com")).thenReturn(true);

        assertThatThrownBy(() -> authService.register(request))
                .isInstanceOf(InvalidOperationException.class)
                .hasMessageContaining("already registered");
    }

    @Test
    void shouldLoginWithValidCredentials() {
        LoginRequest request = new LoginRequest();
        request.setEmail("user@test.com");
        request.setPassword("password123");

        User user = new User("user@test.com", "$2a$encoded", "Test", "User", Role.USER);
        user.setId(1L);

        when(userRepository.findByEmail("user@test.com")).thenReturn(Optional.of(user));
        when(passwordEncoder.matches("password123", "$2a$encoded")).thenReturn(true);
        when(jwtService.generateToken(user)).thenReturn("jwt-token");

        AuthResponse response = authService.login(request);

        assertThat(response.getToken()).isEqualTo("jwt-token");
        assertThat(response.getEmail()).isEqualTo("user@test.com");
    }

    @Test
    void shouldRejectInvalidPassword() {
        LoginRequest request = new LoginRequest();
        request.setEmail("user@test.com");
        request.setPassword("wrongpassword");

        User user = new User("user@test.com", "$2a$encoded", "Test", "User", Role.USER);
        user.setId(1L);

        when(userRepository.findByEmail("user@test.com")).thenReturn(Optional.of(user));
        when(passwordEncoder.matches("wrongpassword", "$2a$encoded")).thenReturn(false);
        when(userRepository.save(any(User.class))).thenReturn(user);

        assertThatThrownBy(() -> authService.login(request))
                .isInstanceOf(InvalidOperationException.class)
                .hasMessageContaining("Invalid email or password");
    }

    @Test
    void shouldRejectNonExistentUser() {
        LoginRequest request = new LoginRequest();
        request.setEmail("nobody@test.com");
        request.setPassword("password123");

        when(userRepository.findByEmail("nobody@test.com")).thenReturn(Optional.empty());

        assertThatThrownBy(() -> authService.login(request))
                .isInstanceOf(InvalidOperationException.class)
                .hasMessageContaining("Invalid email or password");
    }

    @Test
    void shouldRejectLockedAccount() {
        LoginRequest request = new LoginRequest();
        request.setEmail("locked@test.com");
        request.setPassword("password123");

        User user = new User("locked@test.com", "$2a$encoded", "Locked", "User", Role.USER);
        user.setId(1L);
        user.setFailedLoginAttempts(5);
        user.setAccountLockedUntil(java.time.LocalDateTime.now().plusMinutes(10));

        when(userRepository.findByEmail("locked@test.com")).thenReturn(Optional.of(user));

        assertThatThrownBy(() -> authService.login(request))
                .isInstanceOf(InvalidOperationException.class)
                .hasMessageContaining("Account is locked");
    }

    @Test
    void shouldLockAccountAfterMaxFailedAttempts() {
        LoginRequest request = new LoginRequest();
        request.setEmail("user@test.com");
        request.setPassword("wrongpassword");

        User user = new User("user@test.com", "$2a$encoded", "Test", "User", Role.USER);
        user.setId(1L);
        user.setFailedLoginAttempts(4);

        when(userRepository.findByEmail("user@test.com")).thenReturn(Optional.of(user));
        when(passwordEncoder.matches("wrongpassword", "$2a$encoded")).thenReturn(false);
        when(userRepository.save(any(User.class))).thenReturn(user);

        assertThatThrownBy(() -> authService.login(request))
                .isInstanceOf(InvalidOperationException.class)
                .hasMessageContaining("Invalid email or password");

        assertThat(user.getFailedLoginAttempts()).isEqualTo(5);
        assertThat(user.getAccountLockedUntil()).isNotNull();
    }

    @Test
    void shouldResetFailedAttemptsOnSuccessfulLogin() {
        LoginRequest request = new LoginRequest();
        request.setEmail("user@test.com");
        request.setPassword("password123");

        User user = new User("user@test.com", "$2a$encoded", "Test", "User", Role.USER);
        user.setId(1L);
        user.setFailedLoginAttempts(3);

        when(userRepository.findByEmail("user@test.com")).thenReturn(Optional.of(user));
        when(passwordEncoder.matches("password123", "$2a$encoded")).thenReturn(true);
        when(jwtService.generateToken(user)).thenReturn("jwt-token");
        when(userRepository.save(any(User.class))).thenReturn(user);

        AuthResponse response = authService.login(request);

        assertThat(response.getToken()).isEqualTo("jwt-token");
        assertThat(user.getFailedLoginAttempts()).isEqualTo(0);
        assertThat(user.getAccountLockedUntil()).isNull();
    }
}
