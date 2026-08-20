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

    public SlotService(AppointmentSlotRepository slotRepository) {
        this.slotRepository = slotRepository;
    }

    @Transactional(readOnly = true)
    public List<AppointmentSlot> getSlotsByBranchAndDate(Long branchId, LocalDate date) {
        return slotRepository.findByBranchIdAndDate(branchId, date);
    }
}
