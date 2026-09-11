package com.capitec.booking.controller;

import com.capitec.booking.domain.enums.AppointmentStatus;
import com.capitec.booking.domain.enums.SlotStatus;
import com.capitec.booking.domain.model.Appointment;
import com.capitec.booking.domain.model.AppointmentSlot;
import com.capitec.booking.domain.model.Branch;
import com.capitec.booking.domain.model.ServiceType;
import com.capitec.booking.mapper.AppointmentMapper;
import com.capitec.booking.service.AppointmentService;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.when;

class AppointmentControllerTest {

    private AppointmentService appointmentService;
    private AppointmentMapper mapper;
    private AppointmentController controller;

    private Appointment sampleAppointment;
    private Authentication authentication;

    @BeforeEach
    void setUp() {
        appointmentService = mock(AppointmentService.class);
        mapper = new AppointmentMapper();
        controller = new AppointmentController(appointmentService, mapper);

        Branch branch = new Branch("Capitec Sandton", "CAP-SDN", "Sandton City");
        branch.setId(1L);

        AppointmentSlot slot = new AppointmentSlot(branch, LocalDate.of(2026, 6, 15),
                LocalTime.of(9, 0), LocalTime.of(9, 30));
        slot.setId(1L);
        slot.setStatus(SlotStatus.BOOKED);

        ServiceType serviceType = new ServiceType("Account Opening", "Open account", 30);
        serviceType.setId(1L);

        sampleAppointment = new Appointment();
        sampleAppointment.setId(1L);
        sampleAppointment.setUserId("user@test.com");
        sampleAppointment.setSlot(slot);
        sampleAppointment.setServiceType(serviceType);
        sampleAppointment.setStatus(AppointmentStatus.PENDING);
        sampleAppointment.setCustomerName("John Doe");
        sampleAppointment.setCustomerEmail("jo@example.com");
        sampleAppointment.setReferenceNumber("CAP-123456");
        sampleAppointment.setCreatedAt(LocalDateTime.of(2026, 6, 11, 10, 0));

        authentication = new UsernamePasswordAuthenticationToken("user@test.com", null, List.of());
    }

    @Test
    void shouldReturn201OnSuccessfulBooking() {
        when(appointmentService.bookAppointment(any())).thenReturn(sampleAppointment);

        var request = new com.capitec.booking.dto.request.BookingRequest();
        request.setSlotId(1L);
        request.setServiceTypeId(1L);
        request.setCustomerName("John Doe");
        request.setCustomerEmail("john@example.com");

        ResponseEntity<?> response = controller.bookAppointment(request, authentication);

        assertThat(response.getStatusCode()).isEqualTo(HttpStatus.CREATED);
    }

    @Test
    void shouldReturn200OnCancellation() {
        sampleAppointment.setStatus(AppointmentStatus.CANCELLED);
        when(appointmentService.cancelAppointment(1L, "user@test.com")).thenReturn(sampleAppointment);

        ResponseEntity<?> response = controller.cancelAppointment(1L, authentication);

        assertThat(response.getStatusCode()).isEqualTo(HttpStatus.OK);
    }

    @Test
    void shouldReturnUserAppointments() {
        Page<Appointment> page = new PageImpl<>(List.of(sampleAppointment));
        when(appointmentService.getUserAppointments(eq("user@test.com"), any(Pageable.class)))
                .thenReturn(page);

        ResponseEntity<?> response = controller.getMyAppointments(authentication);

        assertThat(response.getStatusCode()).isEqualTo(HttpStatus.OK);
    }

    @Test
    void shouldReturn200OnSuccessfulUpdate() {
        when(appointmentService.updateAppointment(eq(1L), any(), eq("user@test.com"))).thenReturn(sampleAppointment);

        var request = new com.capitec.booking.dto.request.UpdateAppointmentRequest();
        request.setSlotId(2L);
        request.setCustomerName("John Doe");

        ResponseEntity<?> response = controller.updateAppointment(1L, request, authentication);

        assertThat(response.getStatusCode()).isEqualTo(HttpStatus.OK);
    }
}