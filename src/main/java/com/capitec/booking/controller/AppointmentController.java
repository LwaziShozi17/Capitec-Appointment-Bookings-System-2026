package com.capitec.booking.controller;

import com.capitec.booking.domain.model.Appointment;
import com.capitec.booking.dto.request.BookingRequest;
import com.capitec.booking.dto.request.UpdateAppointmentRequest;
import com.capitec.booking.dto.response.AppointmentResponse;
import com.capitec.booking.mapper.AppointmentMapper;
import com.capitec.booking.service.AppointmentService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Sort;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/v1/appointments")
@Tag(name = "Appointments", description = "Book and manage appointments")
public class AppointmentController {

    private final AppointmentService appointmentService;
    private final AppointmentMapper mapper;

    public AppointmentController(AppointmentService appointmentService, AppointmentMapper mapper) {
        this.appointmentService = appointmentService;
        this.mapper = mapper;
    }

    @Operation(summary = "Book an appointment", description = "Creates a new appointment for the client or authenticated user")
    @ApiResponse(responseCode = "201", description = "Appointment booked successfully")
    @ApiResponse(responseCode = "409", description = "Slot is no longer available")
    @PostMapping
    public ResponseEntity<AppointmentResponse> bookAppointment(
            @Valid @RequestBody BookingRequest request,
            Authentication authentication) {
        if (authentication != null && authentication.isAuthenticated() && !"anonymousUser".equals(authentication.getName())) {
            request.setUserId(authentication.getName());
        } else if (request.getUserId() == null || request.getUserId().isBlank()) {
            request.setUserId(request.getCustomerEmail() != null ? request.getCustomerEmail().trim().toLowerCase() : null);
        }
        Appointment appointment = appointmentService.bookAppointment(request);
        return ResponseEntity.status(HttpStatus.CREATED).body(mapper.toResponse(appointment));
    }

    @Operation(summary = "Get appointment details", description = "Returns appointment details for the authenticated owner")
    @ApiResponse(responseCode = "200", description = "Appointment found")
    @ApiResponse(responseCode = "404", description = "Appointment not found")
    @GetMapping("/{id}")
    public ResponseEntity<AppointmentResponse> getAppointment(@PathVariable Long id,
                                                               Authentication authentication) {
        Appointment appointment = appointmentService.getAppointmentForUser(id, authentication.getName());
        return ResponseEntity.ok(mapper.toResponse(appointment));
    }

    @Operation(summary = "Cancel an appointment", description = "Cancels the appointment and releases the slot")
    @ApiResponse(responseCode = "200", description = "Appointment cancelled")
    @DeleteMapping("/{id}")
    public ResponseEntity<AppointmentResponse> cancelAppointment(@PathVariable Long id,
                                                                  Authentication authentication) {
        Appointment appointment = appointmentService.cancelAppointment(id, authentication.getName());
        return ResponseEntity.ok(mapper.toResponse(appointment));
    }

    @Operation(summary = "Update / reschedule an appointment", description = "Updates an existing appointment's date, time slot, or details for the authenticated user")
    @ApiResponse(responseCode = "200", description = "Appointment updated successfully")
    @ApiResponse(responseCode = "404", description = "Appointment or slot not found")
    @ApiResponse(responseCode = "409", description = "Slot is no longer available")
    @PutMapping("/{id}")
    public ResponseEntity<AppointmentResponse> updateAppointment(
            @PathVariable Long id,
            @Valid @RequestBody UpdateAppointmentRequest request,
            Authentication authentication) {
        Appointment appointment = appointmentService.updateAppointment(id, request, authentication.getName());
        return ResponseEntity.ok(mapper.toResponse(appointment));
    }

    @Operation(summary = "Get my appointments", description = "Returns all appointments for the authenticated user")
    @GetMapping("/my")
    public ResponseEntity<List<AppointmentResponse>> getMyAppointments(
            Authentication authentication) {
        List<AppointmentResponse> appointments = appointmentService
                .getUserAppointments(authentication.getName(),
                        PageRequest.of(0, 100, Sort.by(Sort.Direction.DESC, "id")))
                .stream()
                .map(mapper::toResponse)
                .collect(Collectors.toList());
        return ResponseEntity.ok(appointments);
    }
}