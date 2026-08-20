package com.capitec.booking.dto;

import com.capitec.booking.domain.enums.AppointmentStatus;
import com.capitec.booking.domain.enums.SlotStatus;
import com.capitec.booking.dto.response.AppointmentResponse;
import com.capitec.booking.dto.response.AuthResponse;
import com.capitec.booking.dto.response.BranchResponse;
import com.capitec.booking.dto.response.SlotResponse;
import org.junit.jupiter.api.Test;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;

class DtoResponseTest {

    @Test
    void authResponse_constructorAndGetters() {
        AuthResponse response = new AuthResponse("token123", "user@test.com", "Test User", "USER");

        assertThat(response.getToken()).isEqualTo("token123");
        assertThat(response.getEmail()).isEqualTo("user@test.com");
        assertThat(response.getName()).isEqualTo("Test User");
        assertThat(response.getRole()).isEqualTo("USER");
    }

    @Test
    void authResponse_setters() {
        AuthResponse response = new AuthResponse("t", "e", "n", "r");
        response.setToken("newToken");
        response.setEmail("new@test.com");
        response.setName("New Name");
        response.setRole("ADMIN");

        assertThat(response.getToken()).isEqualTo("newToken");
        assertThat(response.getEmail()).isEqualTo("new@test.com");
        assertThat(response.getName()).isEqualTo("New Name");
        assertThat(response.getRole()).isEqualTo("ADMIN");
    }

    @Test
    void appointmentResponse_gettersAndSetters() {
        AppointmentResponse response = new AppointmentResponse();
        response.setId(1L);
        response.setReferenceNumber("REF001");
        response.setUserId("user@test.com");
        response.setCustomerName("John Doe");
        response.setCustomerEmail("john@test.com");
        response.setCustomerPhone("082123");
        response.setBranchName("Capitec Sandton");
        response.setBranchAddress("163 5th St");
        response.setServiceName("Card Collection");
        response.setDate(LocalDate.of(2099, 12, 1));
        response.setStartTime(LocalTime.of(8, 0));
        response.setEndTime(LocalTime.of(8, 30));
        response.setStatus(AppointmentStatus.PENDING);
        response.setCreatedAt(LocalDateTime.of(2099, 11, 1, 10, 0));

        assertThat(response.getId()).isEqualTo(1L);
        assertThat(response.getReferenceNumber()).isEqualTo("REF001");
        assertThat(response.getUserId()).isEqualTo("user@test.com");
        assertThat(response.getCustomerName()).isEqualTo("John Doe");
        assertThat(response.getCustomerEmail()).isEqualTo("john@test.com");
        assertThat(response.getCustomerPhone()).isEqualTo("082123");
        assertThat(response.getBranchName()).isEqualTo("Capitec Sandton");
        assertThat(response.getBranchAddress()).isEqualTo("163 5th St");
        assertThat(response.getServiceName()).isEqualTo("Card Collection");
        assertThat(response.getDate()).isEqualTo(LocalDate.of(2099, 12, 1));
        assertThat(response.getStartTime()).isEqualTo(LocalTime.of(8, 0));
        assertThat(response.getEndTime()).isEqualTo(LocalTime.of(8, 30));
        assertThat(response.getStatus()).isEqualTo(AppointmentStatus.PENDING);
        assertThat(response.getCreatedAt()).isEqualTo(LocalDateTime.of(2099, 11, 1, 10, 0));
    }

    @Test
    void branchResponse_gettersAndSetters() {
        BranchResponse response = new BranchResponse();
        response.setId(1L);
        response.setName("Capitec Sandton");
        response.setCode("CAP-GP-SDN");
        response.setAddress("163 5th St");
        response.setProvince("Gauteng");
        response.setLatitude(-26.1);
        response.setLongitude(28.0);

        assertThat(response.getId()).isEqualTo(1L);
        assertThat(response.getName()).isEqualTo("Capitec Sandton");
        assertThat(response.getCode()).isEqualTo("CAP-GP-SDN");
        assertThat(response.getAddress()).isEqualTo("163 5th St");
        assertThat(response.getProvince()).isEqualTo("Gauteng");
        assertThat(response.getLatitude()).isEqualTo(-26.1);
        assertThat(response.getLongitude()).isEqualTo(28.0);
    }

    @Test
    void branchResponse_operatingHoursResponse() {
        BranchResponse.OperatingHoursResponse hours = new BranchResponse.OperatingHoursResponse();
        hours.setDayOfWeek("MONDAY");
        hours.setOpenTime("08:00");
        hours.setCloseTime("17:00");
        hours.setClosed(false);

        assertThat(hours.getDayOfWeek()).isEqualTo("MONDAY");
        assertThat(hours.getOpenTime()).isEqualTo("08:00");
        assertThat(hours.getCloseTime()).isEqualTo("17:00");
        assertThat(hours.isClosed()).isFalse();
    }

    @Test
    void branchResponse_withOperatingHoursList() {
        BranchResponse response = new BranchResponse();
        BranchResponse.OperatingHoursResponse h = new BranchResponse.OperatingHoursResponse();
        h.setDayOfWeek("SUNDAY");
        h.setClosed(true);

        response.setOperatingHours(List.of(h));

        assertThat(response.getOperatingHours()).hasSize(1);
        assertThat(response.getOperatingHours().get(0).isClosed()).isTrue();
    }

    @Test
    void slotResponse_gettersAndSetters() {
        SlotResponse response = new SlotResponse();
        response.setId(1L);
        response.setBranchId(5L);
        response.setDate(LocalDate.of(2099, 12, 1));
        response.setStartTime(LocalTime.of(8, 0));
        response.setEndTime(LocalTime.of(8, 30));
        response.setStatus(SlotStatus.AVAILABLE);

        assertThat(response.getId()).isEqualTo(1L);
        assertThat(response.getBranchId()).isEqualTo(5L);
        assertThat(response.getDate()).isEqualTo(LocalDate.of(2099, 12, 1));
        assertThat(response.getStartTime()).isEqualTo(LocalTime.of(8, 0));
        assertThat(response.getEndTime()).isEqualTo(LocalTime.of(8, 30));
        assertThat(response.getStatus()).isEqualTo(SlotStatus.AVAILABLE);
    }
}
