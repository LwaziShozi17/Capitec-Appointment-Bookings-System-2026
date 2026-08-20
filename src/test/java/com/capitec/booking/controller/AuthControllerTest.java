package com.capitec.booking.controller;

import com.capitec.booking.dto.request.LoginRequest;
import com.capitec.booking.dto.request.RegisterRequest;
import com.capitec.booking.dto.response.AuthResponse;
import com.capitec.booking.exception.InvalidOperationException;
import com.capitec.booking.service.AuthService;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.when;

class AuthControllerTest {

    private AuthService authService;
    private AuthController controller;

    @BeforeEach
    void setUp() {
        authService = mock(AuthService.class);
        controller = new AuthController(authService);
    }

    @Test
    void register_withValidData_returns201() {
        RegisterRequest request = new RegisterRequest();
        request.setFirstName("Test");
        request.setLastName("User");
        request.setEmail("test@capitec.co.za");
        request.setPassword("Str0ng!Pass");

        AuthResponse authResponse = new AuthResponse("jwt-token", "test@capitec.co.za", "Test User", "USER");
        when(authService.register(any(RegisterRequest.class))).thenReturn(authResponse);

        ResponseEntity<AuthResponse> response = controller.register(request);

        assertThat(response.getStatusCode()).isEqualTo(HttpStatus.CREATED);
        assertThat(response.getBody().getToken()).isEqualTo("jwt-token");
        assertThat(response.getBody().getEmail()).isEqualTo("test@capitec.co.za");
        assertThat(response.getBody().getRole()).isEqualTo("USER");
    }

    @Test
    void login_withValidCredentials_returns200() {
        LoginRequest request = new LoginRequest();
        request.setEmail("user@capitec.co.za");
        request.setPassword("password123");

        AuthResponse authResponse = new AuthResponse("jwt-token", "user@capitec.co.za", "User Name", "USER");
        when(authService.login(any(LoginRequest.class))).thenReturn(authResponse);

        ResponseEntity<AuthResponse> response = controller.login(request);

        assertThat(response.getStatusCode()).isEqualTo(HttpStatus.OK);
        assertThat(response.getBody().getToken()).isEqualTo("jwt-token");
    }

    @Test
    void login_withInvalidCredentials_throwsException() {
        LoginRequest request = new LoginRequest();
        request.setEmail("user@test.com");
        request.setPassword("wrong");

        when(authService.login(any(LoginRequest.class)))
                .thenThrow(new InvalidOperationException("Invalid email or password"));

        assertThatThrownBy(() -> controller.login(request))
                .isInstanceOf(InvalidOperationException.class)
                .hasMessageContaining("Invalid email or password");
    }

    @Test
    void register_withDuplicateEmail_throwsException() {
        RegisterRequest request = new RegisterRequest();
        request.setFirstName("Existing");
        request.setLastName("User");
        request.setEmail("existing@test.com");
        request.setPassword("Str0ng!Pass");

        when(authService.register(any(RegisterRequest.class)))
                .thenThrow(new InvalidOperationException("Email already registered"));

        assertThatThrownBy(() -> controller.register(request))
                .isInstanceOf(InvalidOperationException.class)
                .hasMessageContaining("Email already registered");
    }
}
