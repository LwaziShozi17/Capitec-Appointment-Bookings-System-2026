package com.capitec.booking.controller;

import com.capitec.booking.dto.response.SlotResponse;
import com.capitec.booking.mapper.AppointmentMapper;
import com.capitec.booking.service.SlotService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;
import java.util.List;

@RestController
@RequestMapping("/api/v1/slots")
@Tag(name = "Slots", description = "Available appointment time slots")
public class SlotController {

    private final SlotService slotService;
    private final AppointmentMapper mapper;

    public SlotController(SlotService slotService, AppointmentMapper mapper) {
        this.slotService = slotService;
        this.mapper = mapper;
    }

    @Operation(summary = "Get available slots", description = "Returns time slots for a branch on a specific date")
    @GetMapping
    public ResponseEntity<List<SlotResponse>> getSlots(
            @RequestParam Long branchId,
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate date) {
        List<SlotResponse> slots = slotService.getSlotsByBranchAndDate(branchId, date)
                .stream()
                .map(mapper::toSlotResponse)
                .toList();
        return ResponseEntity.ok(slots);
    }
}
