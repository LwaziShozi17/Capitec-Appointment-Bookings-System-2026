package com.capitec.booking.security;

import org.junit.jupiter.api.Test;

import static org.assertj.core.api.Assertions.assertThatCode;

class AuditLoggerTest {

    private final AuditLogger auditLogger = new AuditLogger();

    @Test
    void logLoginSuccess_doesNotThrow() {
        assertThatCode(() -> auditLogger.logLoginSuccess("user@test.com", "192.168.1.1"))
                .doesNotThrowAnyException();
    }

    @Test
    void logLoginFailed_doesNotThrow() {
        assertThatCode(() -> auditLogger.logLoginFailed("user@test.com", "192.168.1.1"))
                .doesNotThrowAnyException();
    }

    @Test
    void logAccountLocked_doesNotThrow() {
        assertThatCode(() -> auditLogger.logAccountLocked("user@test.com", "192.168.1.1"))
                .doesNotThrowAnyException();
    }

    @Test
    void logRegistration_doesNotThrow() {
        assertThatCode(() -> auditLogger.logRegistration("new@test.com", "192.168.1.1"))
                .doesNotThrowAnyException();
    }

    @Test
    void logAdminAction_doesNotThrow() {
        assertThatCode(() -> auditLogger.logAdminAction("CONFIRM", "admin@test.com", 1L))
                .doesNotThrowAnyException();
    }

    @Test
    void logUnauthorizedAccess_doesNotThrow() {
        assertThatCode(() -> auditLogger.logUnauthorizedAccess("user@test.com", "/admin/appointments"))
                .doesNotThrowAnyException();
    }
}
