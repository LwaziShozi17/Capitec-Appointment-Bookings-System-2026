package com.capitec.booking.service;

import com.capitec.booking.domain.enums.SlotStatus;
import com.capitec.booking.domain.model.AppointmentSlot;
import com.capitec.booking.domain.model.Branch;
import com.capitec.booking.domain.model.Holiday;
import com.capitec.booking.domain.model.OperatingHours;
import com.capitec.booking.exception.ResourceNotFoundException;
import com.capitec.booking.repository.AppointmentSlotRepository;
import com.capitec.booking.repository.BranchRepository;
import com.capitec.booking.repository.HolidayRepository;
import com.capitec.booking.repository.OperatingHoursRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.time.LocalTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

@Service
public class SlotGenerationService {

    private static final int DEFAULT_SLOT_DURATION_MINUTES = 30;

    private final BranchRepository branchRepository;
    private final OperatingHoursRepository operatingHoursRepository;
    private final HolidayRepository holidayRepository;
    private final AppointmentSlotRepository slotRepository;

    public SlotGenerationService(BranchRepository branchRepository,
                                  OperatingHoursRepository operatingHoursRepository,
                                  HolidayRepository holidayRepository,
                                  AppointmentSlotRepository slotRepository) {
        this.branchRepository = branchRepository;
        this.operatingHoursRepository = operatingHoursRepository;
        this.holidayRepository = holidayRepository;
        this.slotRepository = slotRepository;
    }

    @Transactional
    public List<AppointmentSlot> generateSlotsForDate(Long branchId, LocalDate date) {
        Branch branch = branchRepository.findById(branchId)
                .orElseThrow(() -> new ResourceNotFoundException("Branch not found: " + branchId));

        Optional<Holiday> holiday = holidayRepository.findByDate(date);
        if (holiday.isPresent() && !holiday.get().isOpen()) {
            return List.of();
        }

        LocalTime openTime;
        LocalTime closeTime;

        if (holiday.isPresent() && holiday.get().isOpen()) {
            openTime = holiday.get().getSpecialOpenTime();
            closeTime = holiday.get().getSpecialCloseTime();
        } else {
            OperatingHours hours = operatingHoursRepository
                    .findByBranchIdAndDayOfWeek(branchId, date.getDayOfWeek())
                    .orElseThrow(() -> new ResourceNotFoundException(
                            "Operating hours not found for branch " + branchId + " on " + date.getDayOfWeek()));

            if (hours.isClosed()) {
                return List.of();
            }
            openTime = hours.getOpenTime();
            closeTime = hours.getCloseTime();
        }

        List<AppointmentSlot> slots = new ArrayList<>();
        LocalTime current = openTime;

        while (current.plusMinutes(DEFAULT_SLOT_DURATION_MINUTES).compareTo(closeTime) <= 0) {
            if (!slotRepository.existsByBranchIdAndDateAndStartTime(branchId, date, current)) {
                AppointmentSlot slot = new AppointmentSlot(
                        branch, date, current, current.plusMinutes(DEFAULT_SLOT_DURATION_MINUTES));
                slots.add(slot);
            }
            current = current.plusMinutes(DEFAULT_SLOT_DURATION_MINUTES);
        }

        return slotRepository.saveAll(slots);
    }

    @Transactional
    public List<AppointmentSlot> generateSlotsForDateRange(Long branchId, LocalDate startDate, LocalDate endDate) {
        List<AppointmentSlot> allSlots = new ArrayList<>();
        LocalDate current = startDate;
        while (!current.isAfter(endDate)) {
            allSlots.addAll(generateSlotsForDate(branchId, current));
            current = current.plusDays(1);
        }
        return allSlots;
    }
}
