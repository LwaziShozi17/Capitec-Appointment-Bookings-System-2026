package com.capitec.booking.service;

import com.capitec.booking.domain.enums.AppointmentStatus;
import com.capitec.booking.domain.enums.SlotStatus;
import com.capitec.booking.domain.model.Appointment;
import com.capitec.booking.domain.model.AppointmentSlot;
import com.capitec.booking.domain.model.ServiceType;
import com.capitec.booking.dto.request.BookingRequest;
import com.capitec.booking.exception.InvalidOperationException;
import com.capitec.booking.exception.ResourceNotFoundException;
import com.capitec.booking.exception.SlotNotAvailableException;
import com.capitec.booking.repository.AppointmentRepository;
import com.capitec.booking.repository.AppointmentSlotRepository;
import com.capitec.booking.repository.ServiceTypeRepository;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
public class AppointmentService {

    private static final Logger log = LoggerFactory.getLogger(AppointmentService.class);

    private final AppointmentRepository appointmentRepository;
    private final AppointmentSlotRepository slotRepository;
    private final ServiceTypeRepository serviceTypeRepository;

    public AppointmentService(AppointmentRepository appointmentRepository,
                               AppointmentSlotRepository slotRepository,
                               ServiceTypeRepository serviceTypeRepository) {
        this.appointmentRepository = appointmentRepository;
        this.slotRepository = slotRepository;
        this.serviceTypeRepository = serviceTypeRepository;
    }

    @Transactional
    public Appointment bookAppointment(BookingRequest request) {
        log.info("Booking appointment for user={} slotId={} serviceTypeId={}",
                request.getUserId(), request.getSlotId(), request.getServiceTypeId());

        AppointmentSlot slot = slotRepository.findById(request.getSlotId())
                .orElseThrow(() -> new ResourceNotFoundException("Slot not found: " + request.getSlotId()));

        if (slot.getStatus() != SlotStatus.AVAILABLE) {
            log.warn("Slot {} is not available, status={}", request.getSlotId(), slot.getStatus());
            throw new SlotNotAvailableException("Slot is not available for booking");
        }

        ServiceType serviceType = serviceTypeRepository.findById(request.getServiceTypeId())
                .orElseThrow(() -> new ResourceNotFoundException("Service type not found: " + request.getServiceTypeId()));

        slot.setStatus(SlotStatus.BOOKED);
        slotRepository.save(slot);

        Appointment appointment = new Appointment();
        appointment.setUserId(request.getUserId());
        appointment.setSlot(slot);
        appointment.setServiceType(serviceType);
        appointment.setCustomerName(request.getCustomerName());
        appointment.setCustomerPhone(request.getCustomerPhone());
        appointment.setCustomerEmail(request.getCustomerEmail());
        appointment.setStatus(AppointmentStatus.PENDING);

        Appointment saved = appointmentRepository.save(appointment);
        log.info("Appointment booked successfully id={} ref={}", saved.getId(), saved.getReferenceNumber());
        return saved;
    }
// ADD ORDER. BUT THERE'S NO NEED COS THIS IS NOT A BIG SERVICE
    //FROM HERE
    @Transactional
    public Appointment confirmAppointment(Long appointmentId) {
        Appointment appointment = getAppointment(appointmentId);
        validateStatusTransition(appointment, AppointmentStatus.CONFIRMED);
        appointment.setStatus(AppointmentStatus.CONFIRMED);
        return appointmentRepository.save(appointment);
    }

    @Transactional
    public Appointment startAppointment(Long appointmentId) {
        Appointment appointment = getAppointment(appointmentId);
        validateStatusTransition(appointment, AppointmentStatus.IN_PROGRESS);
        appointment.setStatus(AppointmentStatus.IN_PROGRESS);
        return appointmentRepository.save(appointment);
    }

    @Transactional
    public Appointment completeAppointment(Long appointmentId) {
        Appointment appointment = getAppointment(appointmentId);
        validateStatusTransition(appointment, AppointmentStatus.COMPLETED);
        appointment.setStatus(AppointmentStatus.COMPLETED);
        return appointmentRepository.save(appointment);
    }
//TILL HERE
    @Transactional
    public Appointment cancelAppointment(Long appointmentId, String authenticatedUserId) {
        log.info("User {} requesting cancellation of appointment {}", authenticatedUserId, appointmentId);
        Appointment appointment = getAppointment(appointmentId);
        validateOwnership(appointment, authenticatedUserId);
        return performCancellation(appointment);
    }

    @Transactional
    public Appointment cancelAppointmentAsAdmin(Long appointmentId) {
        Appointment appointment = getAppointment(appointmentId);
        return performCancellation(appointment);
    }

    private Appointment performCancellation(Appointment appointment) {
        if (appointment.getStatus() == AppointmentStatus.CANCELLED) {
            throw new InvalidOperationException("Appointment is already cancelled");
        }
        if (appointment.getStatus() == AppointmentStatus.COMPLETED) {
            throw new InvalidOperationException("Cannot cancel a completed appointment");
        }

        appointment.setStatus(AppointmentStatus.CANCELLED);

        AppointmentSlot slot = appointment.getSlot();
        slot.setStatus(SlotStatus.AVAILABLE);
        slotRepository.save(slot);

        return appointmentRepository.save(appointment);
    }

    @Transactional(readOnly = true)
    public Appointment getAppointmentForUser(Long id, String authenticatedUserId) {
        Appointment appointment = getAppointment(id);
        validateOwnership(appointment, authenticatedUserId);
        return appointment;
    }

    @Transactional(readOnly = true)
    public Appointment getAppointment(Long id) {
        return appointmentRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException("Appointment not found: " + id));
    }

    private void validateOwnership(Appointment appointment, String authenticatedUserId) {
        if (!appointment.getUserId().equals(authenticatedUserId)) {
            log.warn("Unauthorized access attempt: user={} tried to access appointment={} owned by={}",
                    authenticatedUserId, appointment.getId(), appointment.getUserId());
            throw new InvalidOperationException("You do not have permission to access this appointment");
        }
    }

    @Transactional(readOnly = true)
    public List<Appointment> getUserAppointments(String userId) {
        return appointmentRepository.findByUserId(userId);
    }

    @Transactional(readOnly = true)
    public List<Appointment> getAllAppointments() {
        return appointmentRepository.findAll();
    }

    @Transactional(readOnly = true)
    public List<Appointment> getAppointmentsByStatus(AppointmentStatus status) {
        return appointmentRepository.findByStatus(status);
    }

    private void validateStatusTransition(Appointment appointment, AppointmentStatus newStatus) {
        AppointmentStatus current = appointment.getStatus();
        boolean valid = switch (newStatus) {
            case CONFIRMED -> current == AppointmentStatus.PENDING;
            case IN_PROGRESS -> current == AppointmentStatus.CONFIRMED;
            case COMPLETED -> current == AppointmentStatus.IN_PROGRESS;
            default -> false;
        };

        if (!valid) {
            throw new InvalidOperationException(
                    "Cannot transition from " + current + " to " + newStatus);
        }
    }
}
