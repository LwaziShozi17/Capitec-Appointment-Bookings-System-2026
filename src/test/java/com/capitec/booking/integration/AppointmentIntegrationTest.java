package com.capitec.booking.integration;

import com.capitec.booking.domain.enums.AppointmentStatus;
import com.capitec.booking.domain.enums.SlotStatus;
import com.capitec.booking.domain.model.Appointment;
import com.capitec.booking.domain.model.AppointmentSlot;
import com.capitec.booking.domain.model.Branch;
import com.capitec.booking.domain.model.ServiceType;
import com.capitec.booking.dto.request.BookingRequest;
import com.capitec.booking.dto.request.UpdateAppointmentRequest;
import com.capitec.booking.repository.AppointmentRepository;
import com.capitec.booking.repository.AppointmentSlotRepository;
import com.capitec.booking.repository.BranchRepository;
import com.capitec.booking.repository.ServiceTypeRepository;
import com.capitec.booking.service.AppointmentService;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.ActiveProfiles;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.time.LocalTime;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;

@SpringBootTest
@ActiveProfiles("test")
@Transactional
class AppointmentIntegrationTest {

    @Autowired
    private AppointmentService appointmentService;

    @Autowired
    private BranchRepository branchRepository;

    @Autowired
    private AppointmentSlotRepository slotRepository;

    @Autowired
    private ServiceTypeRepository serviceTypeRepository;

    @Autowired
    private AppointmentRepository appointmentRepository;

    private Branch branch;
    private AppointmentSlot slot;
    private ServiceType serviceType;

    @BeforeEach
    void setUp() {
        appointmentRepository.deleteAll();
        slotRepository.deleteAll();
        serviceTypeRepository.deleteAll();
        branchRepository.deleteAll();

        branch = branchRepository.save(new Branch("Capitec Sandton", "CAP-SDN-TEST", "Sandton City"));

        slot = new AppointmentSlot(branch, LocalDate.of(2026, 6, 15),
                LocalTime.of(9, 0), LocalTime.of(9, 30));
        slot = slotRepository.save(slot);

        serviceType = serviceTypeRepository.save(new ServiceType("Account Opening", "Open account", 30));
    }

    @Test
    void fullBookingFlowEndToEnd() {
        BookingRequest request = new BookingRequest();
        request.setSlotId(slot.getId());
        request.setServiceTypeId(serviceType.getId());
        request.setUserId("user@test.com");
        request.setCustomerName("Integration Test User");
        request.setCustomerEmail("lwazishzoi@capitec.co.za");

        // Book appointment - starts as PENDING
        Appointment appointment = appointmentService.bookAppointment(request);
        assertThat(appointment.getStatus()).isEqualTo(AppointmentStatus.PENDING);
        assertThat(appointment.getReferenceNumber()).startsWith("CAP-");

        // Admin confirms
        appointment = appointmentService.confirmAppointment(appointment.getId());
        assertThat(appointment.getStatus()).isEqualTo(AppointmentStatus.CONFIRMED);

        // Admin starts
        appointment = appointmentService.startAppointment(appointment.getId());
        assertThat(appointment.getStatus()).isEqualTo(AppointmentStatus.IN_PROGRESS);

        // Admin completes
        appointment = appointmentService.completeAppointment(appointment.getId());
        assertThat(appointment.getStatus()).isEqualTo(AppointmentStatus.COMPLETED);

        // Verify slot remains booked after completion
        AppointmentSlot updatedSlot = slotRepository.findById(slot.getId()).orElseThrow();
        assertThat(updatedSlot.getStatus()).isEqualTo(SlotStatus.BOOKED);
    }

    @Test
    void shouldPreventDoubleBooking() {
        BookingRequest request1 = new BookingRequest();
        request1.setSlotId(slot.getId());
        request1.setServiceTypeId(serviceType.getId());
        request1.setUserId("user1@test.com");
        request1.setCustomerName("First User");
        request1.setCustomerEmail("first@test.com");

        appointmentService.bookAppointment(request1);

        BookingRequest request2 = new BookingRequest();
        request2.setSlotId(slot.getId());
        request2.setServiceTypeId(serviceType.getId());
        request2.setUserId("user2@test.com");
        request2.setCustomerName("Second User");
        request2.setCustomerEmail("second@test.com");

        assertThatThrownBy(() -> appointmentService.bookAppointment(request2))
                .hasMessageContaining("not available");
    }

    @Test
    void cancelledAppointmentFreesSlot() {
        BookingRequest request = new BookingRequest();
        request.setSlotId(slot.getId());
        request.setServiceTypeId(serviceType.getId());
        request.setUserId("user@test.com");
        request.setCustomerName("Cancel Test");
        request.setCustomerEmail("cancel@test.com");

        Appointment appointment = appointmentService.bookAppointment(request);
        appointmentService.cancelAppointment(appointment.getId(), "user@test.com");

        AppointmentSlot updatedSlot = slotRepository.findById(slot.getId()).orElseThrow();
        assertThat(updatedSlot.getStatus()).isEqualTo(SlotStatus.AVAILABLE);
    }

    @Test
    void shouldRescheduleAppointmentAndFreeOldSlot() {
        // Create second slot
        AppointmentSlot slot2 = new AppointmentSlot(branch, LocalDate.of(2026, 6, 16),
                LocalTime.of(10, 0), LocalTime.of(10, 30));
        slot2 = slotRepository.save(slot2);

        BookingRequest bookRequest = new BookingRequest();
        bookRequest.setSlotId(slot.getId());
        bookRequest.setServiceTypeId(serviceType.getId());
        bookRequest.setUserId("user@test.com");
        bookRequest.setCustomerName("Original Name");
        bookRequest.setCustomerEmail("user@test.com");

        Appointment appointment = appointmentService.bookAppointment(bookRequest);
        assertThat(appointment.getSlot().getId()).isEqualTo(slot.getId());

        // Update / reschedule to slot2
        UpdateAppointmentRequest updateRequest = new UpdateAppointmentRequest();
        updateRequest.setSlotId(slot2.getId());
        updateRequest.setCustomerName("Updated Name");

        Appointment updated = appointmentService.updateAppointment(appointment.getId(), updateRequest, "user@test.com");

        assertThat(updated.getSlot().getId()).isEqualTo(slot2.getId());
        assertThat(updated.getCustomerName()).isEqualTo("Updated Name");

        // Old slot should be AVAILABLE again
        AppointmentSlot oldSlotReloaded = slotRepository.findById(slot.getId()).orElseThrow();
        assertThat(oldSlotReloaded.getStatus()).isEqualTo(SlotStatus.AVAILABLE);

        // New slot should be BOOKED
        AppointmentSlot newSlotReloaded = slotRepository.findById(slot2.getId()).orElseThrow();
        assertThat(newSlotReloaded.getStatus()).isEqualTo(SlotStatus.BOOKED);
    }
}
