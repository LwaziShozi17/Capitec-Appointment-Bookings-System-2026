package com.capitec.booking.controller;

import com.capitec.booking.domain.model.Appointment;
import com.capitec.booking.dto.request.BookingRequest;
import com.capitec.booking.dto.response.AppointmentResponse;
import com.capitec.booking.mapper.AppointmentMapper;
import com.capitec.booking.service.AppointmentService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

import java.util.List;

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

    @Operation(summary = "Book an appointment", description = "Creates a new appointment for the authenticated user")
    @ApiResponse(responseCode = "201", description = "Appointment booked successfully")
    @ApiResponse(responseCode = "409", description = "Slot is no longer available")
    @PostMapping
    public ResponseEntity<AppointmentResponse> bookAppointment(
            @Valid @RequestBody BookingRequest request,
            Authentication authentication) {
        request.setUserId(authentication.getName());
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

    @Operation(summary = "Get my appointments", description = "Returns all appointments for the authenticated user")
    @GetMapping("/my")
    public ResponseEntity<List<AppointmentResponse>> getMyAppointments(Authentication authentication) {
        List<AppointmentResponse> appointments = appointmentService
                .getUserAppointments(authentication.getName())
                .stream()
                .map(mapper::toResponse)
                .toList();
        return ResponseEntity.ok(appointments);
    }
}
