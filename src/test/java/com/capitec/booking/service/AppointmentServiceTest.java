package com.capitec.booking.service;

import com.capitec.booking.domain.enums.AppointmentStatus;
import com.capitec.booking.domain.enums.SlotStatus;
import com.capitec.booking.domain.model.Appointment;
import com.capitec.booking.domain.model.AppointmentSlot;
import com.capitec.booking.domain.model.Branch;
import com.capitec.booking.domain.model.ServiceType;
import com.capitec.booking.dto.request.BookingRequest;
import com.capitec.booking.exception.InvalidOperationException;
import com.capitec.booking.exception.ResourceNotFoundException;
import com.capitec.booking.exception.SlotNotAvailableException;
import com.capitec.booking.repository.AppointmentRepository;
import com.capitec.booking.repository.AppointmentSlotRepository;
import com.capitec.booking.repository.ServiceTypeRepository;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.time.LocalDate;
import java.time.LocalTime;
import java.util.List;
import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class AppointmentServiceTest {

    @Mock
    private AppointmentRepository appointmentRepository;

    @Mock
    private AppointmentSlotRepository slotRepository;

    @Mock
    private ServiceTypeRepository serviceTypeRepository;

    @InjectMocks
    private AppointmentService appointmentService;

    private Branch branch;
    private AppointmentSlot availableSlot;
    private ServiceType serviceType;
    private BookingRequest bookingRequest;

    @BeforeEach
    void setUp() {
        branch = new Branch("Capitec Sandton", "CAP-SDN", "Sandton City");
        branch.setId(1L);

        availableSlot = new AppointmentSlot(branch, LocalDate.of(2026, 6, 15),
                LocalTime.of(9, 0), LocalTime.of(9, 30));
        availableSlot.setId(1L);
        availableSlot.setStatus(SlotStatus.AVAILABLE);

        serviceType = new ServiceType("Account Opening", "Open a new account", 30);
        serviceType.setId(1L);

        bookingRequest = new BookingRequest();
        bookingRequest.setSlotId(1L);
        bookingRequest.setServiceTypeId(1L);
        bookingRequest.setUserId("user-123");
        bookingRequest.setCustomerName("John Doe");
        bookingRequest.setCustomerEmail("john@example.com");
    }

    @Test
    void shouldBookAppointmentSuccessfully() {
        when(slotRepository.findById(1L)).thenReturn(Optional.of(availableSlot));
        when(serviceTypeRepository.findById(1L)).thenReturn(Optional.of(serviceType));
        when(slotRepository.save(any())).thenReturn(availableSlot);
        when(appointmentRepository.save(any(Appointment.class))).thenAnswer(invocation -> {
            Appointment saved = invocation.getArgument(0);
            saved.setId(1L);
            return saved;
        });

        Appointment result = appointmentService.bookAppointment(bookingRequest);

        assertThat(result).isNotNull();
        assertThat(result.getUserId()).isEqualTo("user-123");
        assertThat(result.getStatus()).isEqualTo(AppointmentStatus.PENDING);
        assertThat(result.getSlot().getStatus()).isEqualTo(SlotStatus.BOOKED);
        verify(slotRepository).save(availableSlot);
    }

    @Test
    void shouldPreventDoubleBooking() {
        availableSlot.setStatus(SlotStatus.BOOKED);
        when(slotRepository.findById(1L)).thenReturn(Optional.of(availableSlot));

        assertThatThrownBy(() -> appointmentService.bookAppointment(bookingRequest))
                .isInstanceOf(SlotNotAvailableException.class)
                .hasMessageContaining("not available");
    }

    @Test
    void shouldThrowWhenSlotNotFound() {
        when(slotRepository.findById(1L)).thenReturn(Optional.empty());

        assertThatThrownBy(() -> appointmentService.bookAppointment(bookingRequest))
                .isInstanceOf(ResourceNotFoundException.class)
                .hasMessageContaining("Slot not found");
    }

    @Test
    void shouldThrowWhenServiceTypeNotFound() {
        when(slotRepository.findById(1L)).thenReturn(Optional.of(availableSlot));
        when(serviceTypeRepository.findById(1L)).thenReturn(Optional.empty());

        assertThatThrownBy(() -> appointmentService.bookAppointment(bookingRequest))
                .isInstanceOf(ResourceNotFoundException.class)
                .hasMessageContaining("Service type not found");
    }

    @Test
    void shouldConfirmPendingAppointment() {
        Appointment appointment = new Appointment();
        appointment.setId(1L);
        appointment.setStatus(AppointmentStatus.PENDING);

        when(appointmentRepository.findById(1L)).thenReturn(Optional.of(appointment));
        when(appointmentRepository.save(any())).thenReturn(appointment);

        Appointment result = appointmentService.confirmAppointment(1L);

        assertThat(result.getStatus()).isEqualTo(AppointmentStatus.CONFIRMED);
    }

    @Test
    void shouldNotConfirmNonPendingAppointment() {
        Appointment appointment = new Appointment();
        appointment.setId(1L);
        appointment.setStatus(AppointmentStatus.CONFIRMED);

        when(appointmentRepository.findById(1L)).thenReturn(Optional.of(appointment));

        assertThatThrownBy(() -> appointmentService.confirmAppointment(1L))
                .isInstanceOf(InvalidOperationException.class)
                .hasMessageContaining("Cannot transition");
    }

    @Test
    void shouldCompleteInProgressAppointment() {
        Appointment appointment = new Appointment();
        appointment.setId(1L);
        appointment.setStatus(AppointmentStatus.IN_PROGRESS);

        when(appointmentRepository.findById(1L)).thenReturn(Optional.of(appointment));
        when(appointmentRepository.save(any())).thenReturn(appointment);

        Appointment result = appointmentService.completeAppointment(1L);

        assertThat(result.getStatus()).isEqualTo(AppointmentStatus.COMPLETED);
    }

    @Test
    void shouldCancelAppointment() {
        Appointment appointment = new Appointment();
        appointment.setId(1L);
        appointment.setStatus(AppointmentStatus.CONFIRMED);
        appointment.setSlot(availableSlot);
        availableSlot.setStatus(SlotStatus.BOOKED);

        when(appointmentRepository.findById(1L)).thenReturn(Optional.of(appointment));
        when(slotRepository.save(any())).thenReturn(availableSlot);
        when(appointmentRepository.save(any())).thenReturn(appointment);

        Appointment result = appointmentService.cancelAppointmentAsAdmin(1L);

        assertThat(result.getStatus()).isEqualTo(AppointmentStatus.CANCELLED);
        assertThat(availableSlot.getStatus()).isEqualTo(SlotStatus.AVAILABLE);
    }

    @Test
    void shouldNotCancelAlreadyCancelledAppointment() {
        Appointment appointment = new Appointment();
        appointment.setId(1L);
        appointment.setStatus(AppointmentStatus.CANCELLED);

        when(appointmentRepository.findById(1L)).thenReturn(Optional.of(appointment));

        assertThatThrownBy(() -> appointmentService.cancelAppointmentAsAdmin(1L))
                .isInstanceOf(InvalidOperationException.class)
                .hasMessageContaining("already cancelled");
    }

    @Test
    void shouldNotCancelCompletedAppointment() {
        Appointment appointment = new Appointment();
        appointment.setId(1L);
        appointment.setStatus(AppointmentStatus.COMPLETED);

        when(appointmentRepository.findById(1L)).thenReturn(Optional.of(appointment));

        assertThatThrownBy(() -> appointmentService.cancelAppointmentAsAdmin(1L))
                .isInstanceOf(InvalidOperationException.class)
                .hasMessageContaining("completed");
    }

    @Test
    void shouldGetUserAppointments() {
        Appointment appointment = new Appointment();
        appointment.setUserId("user-123");
        when(appointmentRepository.findByUserId("user-123")).thenReturn(List.of(appointment));

        List<Appointment> results = appointmentService.getUserAppointments("user-123");

        assertThat(results).hasSize(1);
        assertThat(results.get(0).getUserId()).isEqualTo("user-123");
    }

    @Test
    void shouldStartConfirmedAppointment() {
        Appointment appointment = new Appointment();
        appointment.setId(1L);
        appointment.setStatus(AppointmentStatus.CONFIRMED);

        when(appointmentRepository.findById(1L)).thenReturn(Optional.of(appointment));
        when(appointmentRepository.save(any())).thenReturn(appointment);

        Appointment result = appointmentService.startAppointment(1L);

        assertThat(result.getStatus()).isEqualTo(AppointmentStatus.IN_PROGRESS);
    }

    @Test
    void shouldNotStartPendingAppointment() {
        Appointment appointment = new Appointment();
        appointment.setId(1L);
        appointment.setStatus(AppointmentStatus.PENDING);

        when(appointmentRepository.findById(1L)).thenReturn(Optional.of(appointment));

        assertThatThrownBy(() -> appointmentService.startAppointment(1L))
                .isInstanceOf(InvalidOperationException.class)
                .hasMessageContaining("Cannot transition");
    }

    @Test
    void shouldCancelAppointmentAsOwner() {
        Appointment appointment = new Appointment();
        appointment.setId(1L);
        appointment.setUserId("user@test.com");
        appointment.setStatus(AppointmentStatus.PENDING);
        appointment.setSlot(availableSlot);
        availableSlot.setStatus(SlotStatus.BOOKED);

        when(appointmentRepository.findById(1L)).thenReturn(Optional.of(appointment));
        when(slotRepository.save(any())).thenReturn(availableSlot);
        when(appointmentRepository.save(any())).thenReturn(appointment);

        Appointment result = appointmentService.cancelAppointment(1L, "user@test.com");

        assertThat(result.getStatus()).isEqualTo(AppointmentStatus.CANCELLED);
    }

    @Test
    void shouldRejectCancellationByNonOwner() {
        Appointment appointment = new Appointment();
        appointment.setId(1L);
        appointment.setUserId("owner@test.com");
        appointment.setStatus(AppointmentStatus.PENDING);

        when(appointmentRepository.findById(1L)).thenReturn(Optional.of(appointment));

        assertThatThrownBy(() -> appointmentService.cancelAppointment(1L, "other@test.com"))
                .isInstanceOf(InvalidOperationException.class)
                .hasMessageContaining("permission");
    }

    @Test
    void shouldGetAppointmentForOwner() {
        Appointment appointment = new Appointment();
        appointment.setId(1L);
        appointment.setUserId("user@test.com");

        when(appointmentRepository.findById(1L)).thenReturn(Optional.of(appointment));

        Appointment result = appointmentService.getAppointmentForUser(1L, "user@test.com");

        assertThat(result).isNotNull();
        assertThat(result.getUserId()).isEqualTo("user@test.com");
    }

    @Test
    void shouldRejectGetAppointmentByNonOwner() {
        Appointment appointment = new Appointment();
        appointment.setId(1L);
        appointment.setUserId("owner@test.com");

        when(appointmentRepository.findById(1L)).thenReturn(Optional.of(appointment));

        assertThatThrownBy(() -> appointmentService.getAppointmentForUser(1L, "other@test.com"))
                .isInstanceOf(InvalidOperationException.class)
                .hasMessageContaining("permission");
    }

    @Test
    void shouldGetAllAppointments() {
        when(appointmentRepository.findAll()).thenReturn(List.of(new Appointment(), new Appointment()));

        List<Appointment> results = appointmentService.getAllAppointments();

        assertThat(results).hasSize(2);
    }

    @Test
    void shouldGetAppointmentsByStatus() {
        Appointment apt = new Appointment();
        apt.setStatus(AppointmentStatus.PENDING);
        when(appointmentRepository.findByStatus(AppointmentStatus.PENDING)).thenReturn(List.of(apt));

        List<Appointment> results = appointmentService.getAppointmentsByStatus(AppointmentStatus.PENDING);

        assertThat(results).hasSize(1);
    }

    @Test
    void shouldThrowWhenAppointmentNotFound() {
        when(appointmentRepository.findById(99L)).thenReturn(Optional.empty());

        assertThatThrownBy(() -> appointmentService.getAppointment(99L))
                .isInstanceOf(ResourceNotFoundException.class)
                .hasMessageContaining("Appointment not found");
    }
}
