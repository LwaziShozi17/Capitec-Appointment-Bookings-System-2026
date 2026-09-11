package com.capitec.booking.service;

import com.capitec.booking.domain.enums.AppointmentStatus;
import com.capitec.booking.domain.enums.SlotStatus;
import com.capitec.booking.domain.model.Appointment;
import com.capitec.booking.domain.model.AppointmentSlot;
import com.capitec.booking.domain.model.Branch;
import com.capitec.booking.domain.model.ServiceType;
import com.capitec.booking.dto.request.BookingRequest;
import com.capitec.booking.dto.request.UpdateAppointmentRequest;
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

import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;

import java.time.LocalDate;
import java.time.LocalTime;
import java.util.List;
import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.eq;
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
        Page<Appointment> page = new PageImpl<>(List.of(appointment));
        when(appointmentRepository.findByUserId(eq("user-123"), any(Pageable.class))).thenReturn(page);

        Page<Appointment> results = appointmentService.getUserAppointments("user-123", PageRequest.of(0, 20));

        assertThat(results.getContent()).hasSize(1);
        assertThat(results.getContent().get(0).getUserId()).isEqualTo("user-123");
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
        Page<Appointment> page = new PageImpl<>(List.of(new Appointment(), new Appointment()));
        when(appointmentRepository.findAll(any(Pageable.class))).thenReturn(page);

        Page<Appointment> results = appointmentService.getAllAppointments(PageRequest.of(0, 20));

        assertThat(results.getContent()).hasSize(2);
    }

    @Test
    void shouldGetAppointmentsByStatus() {
        Appointment apt = new Appointment();
        apt.setStatus(AppointmentStatus.PENDING);
        Page<Appointment> page = new PageImpl<>(List.of(apt));
        when(appointmentRepository.findByStatus(eq(AppointmentStatus.PENDING), any(Pageable.class))).thenReturn(page);

        Page<Appointment> results = appointmentService.getAppointmentsByStatus(AppointmentStatus.PENDING, PageRequest.of(0, 20));

        assertThat(results.getContent()).hasSize(1);
    }

    @Test
    void shouldThrowWhenAppointmentNotFound() {
        when(appointmentRepository.findById(99L)).thenReturn(Optional.empty());

        assertThatThrownBy(() -> appointmentService.getAppointment(99L))
                .isInstanceOf(ResourceNotFoundException.class)
                .hasMessageContaining("Appointment not found");
    }

    @Test
    void shouldUpdateAppointmentSlotSuccessfully() {
        Appointment appointment = new Appointment();
        appointment.setId(1L);
        appointment.setUserId("user-123");
        appointment.setStatus(AppointmentStatus.PENDING);
        appointment.setSlot(availableSlot);
        availableSlot.setStatus(SlotStatus.BOOKED);

        AppointmentSlot newSlot = new AppointmentSlot(branch, LocalDate.of(2026, 6, 16),
                LocalTime.of(10, 0), LocalTime.of(10, 30));
        newSlot.setId(2L);
        newSlot.setStatus(SlotStatus.AVAILABLE);

        UpdateAppointmentRequest request = new UpdateAppointmentRequest();
        request.setSlotId(2L);
        request.setCustomerName("Updated Name");

        when(appointmentRepository.findById(1L)).thenReturn(Optional.of(appointment));
        when(slotRepository.findById(2L)).thenReturn(Optional.of(newSlot));
        when(slotRepository.save(any())).thenAnswer(invocation -> invocation.getArgument(0));
        when(appointmentRepository.save(any())).thenAnswer(invocation -> invocation.getArgument(0));

        Appointment updated = appointmentService.updateAppointment(1L, request, "user-123");

        assertThat(updated.getSlot().getId()).isEqualTo(2L);
        assertThat(updated.getCustomerName()).isEqualTo("Updated Name");
        assertThat(availableSlot.getStatus()).isEqualTo(SlotStatus.AVAILABLE);
        assertThat(newSlot.getStatus()).isEqualTo(SlotStatus.BOOKED);
        verify(slotRepository).save(availableSlot);
        verify(slotRepository).save(newSlot);
    }

    @Test
    void shouldThrowWhenUpdatingAppointmentWithUnavailableSlot() {
        Appointment appointment = new Appointment();
        appointment.setId(1L);
        appointment.setUserId("user-123");
        appointment.setStatus(AppointmentStatus.PENDING);
        appointment.setSlot(availableSlot);

        AppointmentSlot busySlot = new AppointmentSlot(branch, LocalDate.of(2026, 6, 16),
                LocalTime.of(10, 0), LocalTime.of(10, 30));
        busySlot.setId(2L);
        busySlot.setStatus(SlotStatus.BOOKED);

        UpdateAppointmentRequest request = new UpdateAppointmentRequest();
        request.setSlotId(2L);

        when(appointmentRepository.findById(1L)).thenReturn(Optional.of(appointment));
        when(slotRepository.findById(2L)).thenReturn(Optional.of(busySlot));

        assertThatThrownBy(() -> appointmentService.updateAppointment(1L, request, "user-123"))
                .isInstanceOf(SlotNotAvailableException.class)
                .hasMessageContaining("not available");
    }

    @Test
    void shouldRejectUpdateByNonOwner() {
        Appointment appointment = new Appointment();
        appointment.setId(1L);
        appointment.setUserId("user-123");
        appointment.setStatus(AppointmentStatus.PENDING);

        UpdateAppointmentRequest request = new UpdateAppointmentRequest();

        when(appointmentRepository.findById(1L)).thenReturn(Optional.of(appointment));

        assertThatThrownBy(() -> appointmentService.updateAppointment(1L, request, "other-user"))
                .isInstanceOf(InvalidOperationException.class)
                .hasMessageContaining("permission");
    }

    @Test
    void shouldRejectUpdateOnCancelledAppointment() {
        Appointment appointment = new Appointment();
        appointment.setId(1L);
        appointment.setUserId("user-123");
        appointment.setStatus(AppointmentStatus.CANCELLED);

        UpdateAppointmentRequest request = new UpdateAppointmentRequest();

        when(appointmentRepository.findById(1L)).thenReturn(Optional.of(appointment));

        assertThatThrownBy(() -> appointmentService.updateAppointment(1L, request, "user-123"))
                .isInstanceOf(InvalidOperationException.class)
                .hasMessageContaining("cancelled");
    }
}
