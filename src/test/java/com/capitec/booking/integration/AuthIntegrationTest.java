package com.capitec.booking.integration;

import com.capitec.booking.dto.request.LoginRequest;
import com.capitec.booking.dto.request.RegisterRequest;
import com.capitec.booking.dto.response.AuthResponse;
import com.capitec.booking.repository.UserRepository;
import com.capitec.booking.service.AuthService;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.transaction.annotation.Transactional;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;

@SpringBootTest
@ActiveProfiles("test")
@Transactional
class AuthIntegrationTest {

    @Autowired
    private AuthService authService;

    @Autowired
    private UserRepository userRepository;

    @BeforeEach
    void setUp() {
        userRepository.deleteAll();
    }

    @Test
    void shouldRegisterAndLoginSuccessfully() {
        RegisterRequest registerRequest = new RegisterRequest();
        registerRequest.setFirstName("John");
        registerRequest.setLastName("Doe");
        registerRequest.setEmail("John.Doe@example.com");
        registerRequest.setPassword("SecurePass123#");
        registerRequest.setPhoneNumber("0821234567");

        AuthResponse registerResponse = authService.register(registerRequest);

        assertThat(registerResponse).isNotNull();
        assertThat(registerResponse.getEmail()).isEqualTo("john.doe@example.com");
        assertThat(registerResponse.getToken()).isNotBlank();
        assertThat(registerResponse.getRole()).isEqualTo("USER");
        assertThat(userRepository.existsByEmail("john.doe@example.com")).isTrue();

        LoginRequest loginRequest = new LoginRequest();
        loginRequest.setEmail("JOHN.DOE@example.com");
        loginRequest.setPassword("SecurePass123#");

        AuthResponse loginResponse = authService.login(loginRequest);

        assertThat(loginResponse).isNotNull();
        assertThat(loginResponse.getEmail()).isEqualTo("john.doe@example.com");
        assertThat(loginResponse.getToken()).isNotBlank();
    }

    @Test
    void shouldRejectDuplicateRegistration() {
        RegisterRequest request1 = new RegisterRequest();
        request1.setFirstName("Jane");
        request1.setLastName("Doe");
        request1.setEmail("jane@example.com");
        request1.setPassword("SecurePass123!");

        authService.register(request1);

        RegisterRequest request2 = new RegisterRequest();
        request2.setFirstName("Jane");
        request2.setLastName("Smith");
        request2.setEmail("JANE@example.com");
        request2.setPassword("AnotherPass123!");

        assertThatThrownBy(() -> authService.register(request2))
                .hasMessageContaining("Email already registered");
    }
}
