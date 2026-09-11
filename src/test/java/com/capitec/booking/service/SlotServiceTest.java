package com.capitec.booking.service;

import com.capitec.booking.domain.model.AppointmentSlot;
import com.capitec.booking.domain.model.Branch;
import com.capitec.booking.repository.AppointmentSlotRepository;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.time.LocalDate;
import java.time.LocalTime;
import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class SlotServiceTest {

    @Mock
    private AppointmentSlotRepository slotRepository;

    @Mock
    private SlotGenerationService slotGenerationService;

    @InjectMocks
    private SlotService slotService;

    @Test
    void shouldReturnSlotsByBranchAndDate() {
        Branch branch = new Branch("Capitec Sandton", "CAP-SDN", "Sandton City");
        branch.setId(1L);
        LocalDate date = LocalDate.of(2026, 6, 15);

        AppointmentSlot slot1 = new AppointmentSlot(branch, date, LocalTime.of(9, 0), LocalTime.of(9, 30));
        AppointmentSlot slot2 = new AppointmentSlot(branch, date, LocalTime.of(9, 30), LocalTime.of(10, 0));

        when(slotRepository.findByBranchIdAndDate(1L, date)).thenReturn(List.of(slot1, slot2));

        List<AppointmentSlot> results = slotService.getSlotsByBranchAndDate(1L, date);

        assertThat(results).hasSize(2);
        assertThat(results.get(0).getStartTime()).isEqualTo(LocalTime.of(9, 0));
    }

    @Test
    void shouldReturnEmptyListWhenNoSlots() {
        LocalDate date = LocalDate.of(2026, 6, 21);
        when(slotRepository.findByBranchIdAndDate(1L, date)).thenReturn(List.of());
        when(slotGenerationService.generateSlotsForDate(1L, date)).thenReturn(List.of());

        List<AppointmentSlot> results = slotService.getSlotsByBranchAndDate(1L, date);

        assertThat(results).isEmpty();
    }

    @Test
    void shouldAutoGenerateSlotsWhenNoneExist() {
        Branch branch = new Branch("Capitec Sandton", "CAP-SDN", "Sandton City");
        branch.setId(1L);
        LocalDate date = LocalDate.of(2026, 6, 15);

        AppointmentSlot generatedSlot = new AppointmentSlot(branch, date, LocalTime.of(8, 0), LocalTime.of(8, 30));

        when(slotRepository.findByBranchIdAndDate(1L, date)).thenReturn(List.of());
        when(slotGenerationService.generateSlotsForDate(1L, date)).thenReturn(List.of(generatedSlot));

        List<AppointmentSlot> results = slotService.getSlotsByBranchAndDate(1L, date);

        assertThat(results).containsExactly(generatedSlot);
    }
}
