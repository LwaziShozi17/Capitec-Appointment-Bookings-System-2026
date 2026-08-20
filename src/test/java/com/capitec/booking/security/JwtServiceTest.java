package com.capitec.booking.security;

import com.capitec.booking.domain.enums.Role;
import com.capitec.booking.domain.model.User;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.test.util.ReflectionTestUtils;

import static org.assertj.core.api.Assertions.assertThat;

class JwtServiceTest {

    private JwtService jwtService;

    @BeforeEach
    void setUp() {
        jwtService = new JwtService();
        ReflectionTestUtils.setField(jwtService, "secret", "test-secret-key-that-is-at-least-256-bits-long-for-hmac-sha256");
        ReflectionTestUtils.setField(jwtService, "expiration", 900000L);
    }

    private User createUser() {
        User user = new User("test@capitec.co.za", "encoded", "Test", "User", Role.USER);
        user.setId(1L);
        return user;
    }

    @Test
    void generateToken_returnsNonNullToken() {
        String token = jwtService.generateToken(createUser());
        assertThat(token).isNotNull().isNotEmpty();
    }

    @Test
    void extractEmail_returnsCorrectSubject() {
        String token = jwtService.generateToken(createUser());
        assertThat(jwtService.extractEmail(token)).isEqualTo("test@capitec.co.za");
    }

    @Test
    void extractRole_returnsCorrectRole() {
        String token = jwtService.generateToken(createUser());
        assertThat(jwtService.extractRole(token)).isEqualTo("USER");
    }

    @Test
    void extractRole_returnsAdminForAdminUser() {
        User admin = new User("admin@capitec.co.za", "encoded", "Admin", "User", Role.ADMIN);
        admin.setId(2L);
        String token = jwtService.generateToken(admin);
        assertThat(jwtService.extractRole(token)).isEqualTo("ADMIN");
    }

    @Test
    void isTokenValid_returnsTrueForValidToken() {
        String token = jwtService.generateToken(createUser());
        assertThat(jwtService.isTokenValid(token)).isTrue();
    }

    @Test
    void isTokenValid_returnsFalseForExpiredToken() {
        ReflectionTestUtils.setField(jwtService, "expiration", -1000L);
        String token = jwtService.generateToken(createUser());
        assertThat(jwtService.isTokenValid(token)).isFalse();
    }

    @Test
    void isTokenValid_returnsFalseForTamperedToken() {
        String token = jwtService.generateToken(createUser());
        String tampered = token.substring(0, token.length() - 5) + "XXXXX";
        assertThat(jwtService.isTokenValid(tampered)).isFalse();
    }

    @Test
    void isTokenValid_returnsFalseForGarbageToken() {
        assertThat(jwtService.isTokenValid("not.a.valid.token")).isFalse();
    }
}
