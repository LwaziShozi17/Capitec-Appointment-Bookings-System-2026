package com.capitec.booking.security;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Component;

@Component
public class AuditLogger {

    private static final Logger log = LoggerFactory.getLogger("SECURITY_AUDIT");

    public void logLoginSuccess(String email, String ip) {
        log.info("[AUDIT] action=LOGIN_SUCCESS email={} ip={}", email, ip);
    }

    public void logLoginFailed(String email, String ip) {
        log.warn("[AUDIT] action=LOGIN_FAILED email={} ip={}", email, ip);
    }

    public void logAccountLocked(String email, String ip) {
        log.warn("[AUDIT] action=ACCOUNT_LOCKED email={} ip={}", email, ip);
    }

    public void logRegistration(String email, String ip) {
        log.info("[AUDIT] action=REGISTRATION email={} ip={}", email, ip);
    }

    public void logAdminAction(String action, String adminEmail, Long appointmentId) {
        log.info("[AUDIT] action={} admin={} appointmentId={}", action, adminEmail, appointmentId);
    }

    public void logUnauthorizedAccess(String email, String resource) {
        log.warn("[AUDIT] action=UNAUTHORIZED_ACCESS email={} resource={}", email, resource);
    }
}