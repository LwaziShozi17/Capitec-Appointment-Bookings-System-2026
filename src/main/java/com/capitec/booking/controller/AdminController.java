package com.capitec.booking.controller;

import com.capitec.booking.domain.enums.AppointmentStatus;
import com.capitec.booking.domain.model.Appointment;
import com.capitec.booking.dto.response.AppointmentResponse;
import com.capitec.booking.mapper.AppointmentMapper;
import com.capitec.booking.service.AppointmentService;
import com.capitec.booking.service.SlotGenerationService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;
import java.util.List;

@RestController
@RequestMapping("/api/v1/admin")
@PreAuthorize("hasRole('ADMIN')")
@Tag(name = "Admin", description = "Administrative operations (ADMIN role required)")
public class AdminController {

    private final AppointmentService appointmentService;
    private final SlotGenerationService slotGenerationService;
    private final AppointmentMapper mapper;

    public AdminController(AppointmentService appointmentService,
                           SlotGenerationService slotGenerationService,
                           AppointmentMapper mapper) {
        this.appointmentService = appointmentService;
        this.slotGenerationService = slotGenerationService;
        this.mapper = mapper;
    }

    @Operation(summary = "List all appointments", description = "Returns all appointments, optionally filtered by status")
    @GetMapping("/appointments")
    public ResponseEntity<List<AppointmentResponse>> getAllAppointments(
            @RequestParam(required = false) AppointmentStatus status) {
        List<Appointment> appointments;
        if (status != null) {
            appointments = appointmentService.getAppointmentsByStatus(status);
        } else {
            appointments = appointmentService.getAllAppointments();
        }
        return ResponseEntity.ok(appointments.stream().map(mapper::toResponse).toList());
    }

    @Operation(summary = "Confirm appointment")
    @PatchMapping("/appointments/{id}/confirm")
    public ResponseEntity<AppointmentResponse> confirmAppointment(@PathVariable Long id) {
        Appointment appointment = appointmentService.confirmAppointment(id);
        return ResponseEntity.ok(mapper.toResponse(appointment));
    }

    @Operation(summary = "Start appointment")
    @PatchMapping("/appointments/{id}/start")
    public ResponseEntity<AppointmentResponse> startAppointment(@PathVariable Long id) {
        Appointment appointment = appointmentService.startAppointment(id);
        return ResponseEntity.ok(mapper.toResponse(appointment));
    }

    @Operation(summary = "Complete appointment")
    @PatchMapping("/appointments/{id}/complete")
    public ResponseEntity<AppointmentResponse> completeAppointment(@PathVariable Long id) {
        Appointment appointment = appointmentService.completeAppointment(id);
        return ResponseEntity.ok(mapper.toResponse(appointment));
    }

    @Operation(summary = "Cancel appointment")
    @PatchMapping("/appointments/{id}/cancel")
    public ResponseEntity<AppointmentResponse> cancelAppointment(@PathVariable Long id) {
        Appointment appointment = appointmentService.cancelAppointmentAsAdmin(id);
        return ResponseEntity.ok(mapper.toResponse(appointment));
    }

    @Operation(summary = "Generate appointment slots", description = "Generates time slots for a branch over a date range")
    @PostMapping("/slots/generate")
    public ResponseEntity<String> generateSlots(
            @RequestParam Long branchId,
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate startDate,
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate endDate) {
        var slots = slotGenerationService.generateSlotsForDateRange(branchId, startDate, endDate);
        return ResponseEntity.ok("Generated " + slots.size() + " slots");
    }
}
