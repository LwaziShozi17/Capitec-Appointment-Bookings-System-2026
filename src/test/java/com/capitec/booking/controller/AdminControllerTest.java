package com.capitec.booking.controller;

import com.capitec.booking.domain.enums.AppointmentStatus;
import com.capitec.booking.domain.enums.SlotStatus;
import com.capitec.booking.domain.model.Appointment;
import com.capitec.booking.domain.model.AppointmentSlot;
import com.capitec.booking.domain.model.Branch;
import com.capitec.booking.domain.model.ServiceType;
import com.capitec.booking.dto.response.AppointmentResponse;
import com.capitec.booking.mapper.AppointmentMapper;
import com.capitec.booking.service.AppointmentService;
import com.capitec.booking.service.SlotGenerationService;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;

import java.time.LocalDate;
import java.time.LocalTime;
import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.when;

class AdminControllerTest {

    private AppointmentService appointmentService;
    private SlotGenerationService slotGenerationService;
    private AppointmentMapper mapper;
    private AdminController controller;

    @BeforeEach
    void setUp() {
        appointmentService = mock(AppointmentService.class);
        slotGenerationService = mock(SlotGenerationService.class);
        mapper = new AppointmentMapper();
        controller = new AdminController(appointmentService, slotGenerationService, mapper);
    }

    private Appointment createAppointment(Long id, AppointmentStatus status) {
        Appointment apt = new Appointment();
        apt.setId(id);
        apt.setUserId("user@test.com");
        apt.setCustomerName("Lwazi Shozi");
        apt.setCustomerEmail("lwaziShozi@test.com");
        apt.setCustomerPhone("082123");
        apt.setStatus(status);
        apt.setReferenceNumber("REF-" + id);

        AppointmentSlot slot = new AppointmentSlot();
        slot.setId(id);
        slot.setDate(LocalDate.of(2099, 12, 1));
        slot.setStartTime(LocalTime.of(8, 0));
        slot.setEndTime(LocalTime.of(8, 30));
        slot.setStatus(SlotStatus.BOOKED);
        Branch branch = new Branch("Test Branch", "TB-1", "123 St");
        slot.setBranch(branch);
        apt.setSlot(slot);

        ServiceType service = new ServiceType("Card Collection", "Collect card", 20);
        apt.setServiceType(service);

        return apt;
    }

    @Test
    void getAllAppointments_returnsAll() {
        List<Appointment> appointments = List.of(
                createAppointment(1L, AppointmentStatus.PENDING),
                createAppointment(2L, AppointmentStatus.CONFIRMED)
        );
        when(appointmentService.getAllAppointments()).thenReturn(appointments);

        ResponseEntity<List<AppointmentResponse>> response = controller.getAllAppointments(null);

        assertThat(response.getStatusCode()).isEqualTo(HttpStatus.OK);
        assertThat(response.getBody()).hasSize(2);
    }

    @Test
    void getAllAppointments_filteredByStatus() {
        List<Appointment> appointments = List.of(createAppointment(1L, AppointmentStatus.PENDING));
        when(appointmentService.getAppointmentsByStatus(AppointmentStatus.PENDING)).thenReturn(appointments);

        ResponseEntity<List<AppointmentResponse>> response = controller.getAllAppointments(AppointmentStatus.PENDING);

        assertThat(response.getStatusCode()).isEqualTo(HttpStatus.OK);
        assertThat(response.getBody()).hasSize(1);
    }

    @Test
    void confirmAppointment_returns200() {
        Appointment apt = createAppointment(1L, AppointmentStatus.CONFIRMED);
        when(appointmentService.confirmAppointment(1L)).thenReturn(apt);

        ResponseEntity<AppointmentResponse> response = controller.confirmAppointment(1L);

        assertThat(response.getStatusCode()).isEqualTo(HttpStatus.OK);
    }

    @Test
    void startAppointment_returns200() {
        Appointment apt = createAppointment(1L, AppointmentStatus.IN_PROGRESS);
        when(appointmentService.startAppointment(1L)).thenReturn(apt);

        ResponseEntity<AppointmentResponse> response = controller.startAppointment(1L);

        assertThat(response.getStatusCode()).isEqualTo(HttpStatus.OK);
    }

    @Test
    void completeAppointment_returns200() {
        Appointment apt = createAppointment(1L, AppointmentStatus.COMPLETED);
        when(appointmentService.completeAppointment(1L)).thenReturn(apt);

        ResponseEntity<AppointmentResponse> response = controller.completeAppointment(1L);

        assertThat(response.getStatusCode()).isEqualTo(HttpStatus.OK);
    }

    @Test
    void cancelAppointment_returns200() {
        Appointment apt = createAppointment(1L, AppointmentStatus.CANCELLED);
        when(appointmentService.cancelAppointmentAsAdmin(1L)).thenReturn(apt);

        ResponseEntity<AppointmentResponse> response = controller.cancelAppointment(1L);

        assertThat(response.getStatusCode()).isEqualTo(HttpStatus.OK);
    }

    @Test
    void generateSlots_returns200WithMessage() {
        LocalDate start = LocalDate.of(2099, 12, 1);
        LocalDate end = LocalDate.of(2099, 12, 5);
        when(slotGenerationService.generateSlotsForDateRange(eq(1L), eq(start), eq(end)))
                .thenReturn(List.of());

        ResponseEntity<String> response = controller.generateSlots(1L, start, end);

        assertThat(response.getStatusCode()).isEqualTo(HttpStatus.OK);
        assertThat(response.getBody()).isEqualTo("Generated 0 slots");
    }
}
