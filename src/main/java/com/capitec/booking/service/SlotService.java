package com.capitec.booking.service;

import com.capitec.booking.domain.model.AppointmentSlot;
import com.capitec.booking.repository.AppointmentSlotRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.util.List;

@Service
public class SlotService {

    private final AppointmentSlotRepository slotRepository;
    private final SlotGenerationService slotGenerationService;

    public SlotService(AppointmentSlotRepository slotRepository,
                       SlotGenerationService slotGenerationService) {
        this.slotRepository = slotRepository;
        this.slotGenerationService = slotGenerationService;
    }

    @Transactional
    public List<AppointmentSlot> getSlotsByBranchAndDate(Long branchId, LocalDate date) {
        List<AppointmentSlot> slots = slotRepository.findByBranchIdAndDate(branchId, date);
        if (slots.isEmpty()) {
            // Auto-generate slots on first request for this branch/date combination
            slots = slotGenerationService.generateSlotsForDate(branchId, date);
        }
        return slots;
    }
}
