package com.capitec.booking.domain;

import com.capitec.booking.domain.enums.AppointmentStatus;
import com.capitec.booking.domain.enums.Role;
import com.capitec.booking.domain.enums.SlotStatus;
import com.capitec.booking.domain.model.*;
import org.junit.jupiter.api.Test;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;

import static org.assertj.core.api.Assertions.assertThat;

class DomainModelTest {

    @Test
    void user_defaultConstructorAndSetters() {
        User user = new User();
        user.setId(1L);
        user.setEmail("user@test.com");
        user.setPassword("encoded");
        user.setFirstName("Test");
        user.setLastName("User");
        user.setPhoneNumber("082123");
        user.setRole(Role.USER);

        assertThat(user.getId()).isEqualTo(1L);
        assertThat(user.getEmail()).isEqualTo("user@test.com");
        assertThat(user.getPassword()).isEqualTo("encoded");
        assertThat(user.getFirstName()).isEqualTo("Test");
        assertThat(user.getLastName()).isEqualTo("User");
        assertThat(user.getPhoneNumber()).isEqualTo("082123");
        assertThat(user.getRole()).isEqualTo(Role.USER);
    }

    @Test
    void user_parameterizedConstructor() {
        User user = new User("admin@test.com", "pass", "Admin", "User", Role.ADMIN);

        assertThat(user.getEmail()).isEqualTo("admin@test.com");
        assertThat(user.getFirstName()).isEqualTo("Admin");
        assertThat(user.getLastName()).isEqualTo("User");
        assertThat(user.getRole()).isEqualTo(Role.ADMIN);
    }

    @Test
    void user_getFullName() {
        User user = new User("e", "p", "John", "Doe", Role.USER);
        assertThat(user.getFullName()).isEqualTo("John Doe");
    }

    @Test
    void user_isAccountLocked_returnsFalseWhenNotLocked() {
        User user = new User();
        assertThat(user.isAccountLocked()).isFalse();
    }

    @Test
    void user_isAccountLocked_returnsTrueWhenLocked() {
        User user = new User();
        user.setAccountLockedUntil(LocalDateTime.now().plusMinutes(15));
        assertThat(user.isAccountLocked()).isTrue();
    }

    @Test
    void user_isAccountLocked_returnsFalseWhenLockExpired() {
        User user = new User();
        user.setAccountLockedUntil(LocalDateTime.now().minusMinutes(1));
        assertThat(user.isAccountLocked()).isFalse();
    }

    @Test
    void user_failedLoginAttempts() {
        User user = new User();
        assertThat(user.getFailedLoginAttempts()).isEqualTo(0);
        user.setFailedLoginAttempts(3);
        assertThat(user.getFailedLoginAttempts()).isEqualTo(3);
    }

    @Test
    void branch_defaultConstructorAndSetters() {
        Branch branch = new Branch();
        branch.setId(1L);
        branch.setName("Capitec Sandton");
        branch.setCode("CAP-GP-SDN");
        branch.setAddress("163 5th St");
        branch.setProvince("Gauteng");
        branch.setLatitude(-26.1);
        branch.setLongitude(28.0);

        assertThat(branch.getId()).isEqualTo(1L);
        assertThat(branch.getName()).isEqualTo("Capitec Sandton");
        assertThat(branch.getCode()).isEqualTo("CAP-GP-SDN");
        assertThat(branch.getProvince()).isEqualTo("Gauteng");
        assertThat(branch.getLatitude()).isEqualTo(-26.1);
        assertThat(branch.getLongitude()).isEqualTo(28.0);
    }

    @Test
    void branch_parameterizedConstructor() {
        Branch branch = new Branch("Test Branch", "TB-001", "123 St");

        assertThat(branch.getName()).isEqualTo("Test Branch");
        assertThat(branch.getCode()).isEqualTo("TB-001");
        assertThat(branch.getAddress()).isEqualTo("123 St");
    }

    @Test
    void branch_operatingHours() {
        Branch branch = new Branch();
        assertThat(branch.getOperatingHours()).isEmpty();
    }

    @Test
    void serviceType_defaultConstructorAndSetters() {
        ServiceType service = new ServiceType();
        service.setId(1L);
        service.setName("Card Collection");
        service.setDescription("Collect your card");
        service.setDurationMinutes(20);
        service.setRequiredDocuments("SA ID;Proof of Address");

        assertThat(service.getId()).isEqualTo(1L);
        assertThat(service.getName()).isEqualTo("Card Collection");
        assertThat(service.getDescription()).isEqualTo("Collect your card");
        assertThat(service.getDurationMinutes()).isEqualTo(20);
        assertThat(service.getRequiredDocuments()).isEqualTo("SA ID;Proof of Address");
    }

    @Test
    void serviceType_parameterizedConstructor() {
        ServiceType service = new ServiceType("Loan", "Apply for loan", 60);

        assertThat(service.getName()).isEqualTo("Loan");
        assertThat(service.getDescription()).isEqualTo("Apply for loan");
        assertThat(service.getDurationMinutes()).isEqualTo(60);
    }

    @Test
    void appointmentSlot_defaultConstructorAndSetters() {
        AppointmentSlot slot = new AppointmentSlot();
        slot.setId(1L);
        slot.setDate(LocalDate.of(2099, 12, 1));
        slot.setStartTime(LocalTime.of(8, 0));
        slot.setEndTime(LocalTime.of(8, 30));
        slot.setStatus(SlotStatus.AVAILABLE);
        slot.setVersion(0L);

        assertThat(slot.getId()).isEqualTo(1L);
        assertThat(slot.getDate()).isEqualTo(LocalDate.of(2099, 12, 1));
        assertThat(slot.getStartTime()).isEqualTo(LocalTime.of(8, 0));
        assertThat(slot.getEndTime()).isEqualTo(LocalTime.of(8, 30));
        assertThat(slot.getStatus()).isEqualTo(SlotStatus.AVAILABLE);
        assertThat(slot.getVersion()).isEqualTo(0L);
    }

    @Test
    void appointmentSlot_parameterizedConstructor() {
        Branch branch = new Branch("Branch", "B-1", "St");
        AppointmentSlot slot = new AppointmentSlot(branch, LocalDate.of(2099, 12, 1),
                LocalTime.of(9, 0), LocalTime.of(9, 30));

        assertThat(slot.getBranch()).isEqualTo(branch);
        assertThat(slot.getDate()).isEqualTo(LocalDate.of(2099, 12, 1));
        assertThat(slot.getStartTime()).isEqualTo(LocalTime.of(9, 0));
        assertThat(slot.getEndTime()).isEqualTo(LocalTime.of(9, 30));
        assertThat(slot.getStatus()).isEqualTo(SlotStatus.AVAILABLE);
    }

    @Test
    void appointment_gettersAndSetters() {
        Appointment apt = new Appointment();
        apt.setId(1L);
        apt.setUserId("user@test.com");
        apt.setCustomerName("John Doe");
        apt.setCustomerEmail("john@test.com");
        apt.setCustomerPhone("082123");
        apt.setStatus(AppointmentStatus.PENDING);
        apt.setReferenceNumber("REF-001");
        apt.setCreatedAt(LocalDateTime.of(2099, 11, 1, 10, 0));

        assertThat(apt.getId()).isEqualTo(1L);
        assertThat(apt.getUserId()).isEqualTo("user@test.com");
        assertThat(apt.getCustomerName()).isEqualTo("John Doe");
        assertThat(apt.getCustomerEmail()).isEqualTo("john@test.com");
        assertThat(apt.getCustomerPhone()).isEqualTo("082123");
        assertThat(apt.getStatus()).isEqualTo(AppointmentStatus.PENDING);
        assertThat(apt.getReferenceNumber()).isEqualTo("REF-001");
        assertThat(apt.getCreatedAt()).isEqualTo(LocalDateTime.of(2099, 11, 1, 10, 0));
    }

    @Test
    void appointment_slotAndServiceRelations() {
        Appointment apt = new Appointment();
        AppointmentSlot slot = new AppointmentSlot();
        ServiceType service = new ServiceType("Test", "Desc", 30);

        apt.setSlot(slot);
        apt.setServiceType(service);

        assertThat(apt.getSlot()).isEqualTo(slot);
        assertThat(apt.getServiceType()).isEqualTo(service);
    }
}
