package com.capitec.booking.service;

import com.capitec.booking.domain.model.AppointmentSlot;
import com.capitec.booking.domain.model.Branch;
import com.capitec.booking.domain.model.Holiday;
import com.capitec.booking.domain.model.OperatingHours;
import com.capitec.booking.repository.AppointmentSlotRepository;
import com.capitec.booking.repository.BranchRepository;
import com.capitec.booking.repository.HolidayRepository;
import com.capitec.booking.repository.OperatingHoursRepository;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.time.DayOfWeek;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.List;
import java.util.Optional;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.eq;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class SlotGenerationServiceTest {

    @Mock
    private BranchRepository branchRepository;

    @Mock
    private OperatingHoursRepository operatingHoursRepository;

    @Mock
    private HolidayRepository holidayRepository;

    @Mock
    private AppointmentSlotRepository slotRepository;

    @InjectMocks
    private SlotGenerationService slotGenerationService;

    private Branch branch;

    @BeforeEach
    void setUp() {
        branch = new Branch("Capitec Sandton", "CAP-SDN", "Sandton City");
        branch.setId(1L);
    }

    @Test
    void shouldGenerateSlotsForWeekday() {
        LocalDate monday = LocalDate.of(2026, 6, 15); // Monday
        OperatingHours hours = new OperatingHours(branch, DayOfWeek.MONDAY,
                LocalTime.of(8, 0), LocalTime.of(17, 0), false);

        when(branchRepository.findById(1L)).thenReturn(Optional.of(branch));
        when(holidayRepository.findByDate(monday)).thenReturn(Optional.empty());
        when(operatingHoursRepository.findByBranchIdAndDayOfWeek(1L, DayOfWeek.MONDAY))
                .thenReturn(Optional.of(hours));
        when(slotRepository.existsByBranchIdAndDateAndStartTime(any(), any(), any())).thenReturn(false);
        when(slotRepository.saveAll(any())).thenAnswer(invocation -> invocation.getArgument(0));

        List<AppointmentSlot> slots = slotGenerationService.generateSlotsForDate(1L, monday);

        // 08:00-17:00 in 30min intervals = 18 slots
        assertThat(slots).hasSize(18);
        assertThat(slots.get(0).getStartTime()).isEqualTo(LocalTime.of(8, 0));
        assertThat(slots.get(17).getStartTime()).isEqualTo(LocalTime.of(16, 30));
    }

    @Test
    void shouldGenerateSlotsForSaturday() {
        LocalDate saturday = LocalDate.of(2026, 6, 20); // Saturday
        OperatingHours hours = new OperatingHours(branch, DayOfWeek.SATURDAY,
                LocalTime.of(8, 0), LocalTime.of(13, 0), false);

        when(branchRepository.findById(1L)).thenReturn(Optional.of(branch));
        when(holidayRepository.findByDate(saturday)).thenReturn(Optional.empty());
        when(operatingHoursRepository.findByBranchIdAndDayOfWeek(1L, DayOfWeek.SATURDAY))
                .thenReturn(Optional.of(hours));
        when(slotRepository.existsByBranchIdAndDateAndStartTime(any(), any(), any())).thenReturn(false);
        when(slotRepository.saveAll(any())).thenAnswer(invocation -> invocation.getArgument(0));

        List<AppointmentSlot> slots = slotGenerationService.generateSlotsForDate(1L, saturday);

        // 08:00-13:00 in 30min intervals = 10 slots
        assertThat(slots).hasSize(10);
        assertThat(slots.get(0).getStartTime()).isEqualTo(LocalTime.of(8, 0));
        assertThat(slots.get(9).getStartTime()).isEqualTo(LocalTime.of(12, 30));
    }

    @Test
    void shouldNotGenerateSlotsForSunday() {
        LocalDate sunday = LocalDate.of(2026, 6, 21); // Sunday
        OperatingHours hours = new OperatingHours(branch, DayOfWeek.SUNDAY, null, null, true);

        when(branchRepository.findById(1L)).thenReturn(Optional.of(branch));
        when(holidayRepository.findByDate(sunday)).thenReturn(Optional.empty());
        when(operatingHoursRepository.findByBranchIdAndDayOfWeek(1L, DayOfWeek.SUNDAY))
                .thenReturn(Optional.of(hours));

        List<AppointmentSlot> slots = slotGenerationService.generateSlotsForDate(1L, sunday);

        assertThat(slots).isEmpty();
    }

    @Test
    void shouldNotGenerateSlotsForClosedHoliday() {
        LocalDate holiday = LocalDate.of(2026, 12, 25); // Christmas
        Holiday christmas = new Holiday(holiday, "Christmas Day", false);

        when(branchRepository.findById(1L)).thenReturn(Optional.of(branch));
        when(holidayRepository.findByDate(holiday)).thenReturn(Optional.of(christmas));

        List<AppointmentSlot> slots = slotGenerationService.generateSlotsForDate(1L, holiday);

        assertThat(slots).isEmpty();
    }

    @Test
    void shouldGenerateSpecialHolidaySlots() {
        LocalDate holidayDate = LocalDate.of(2026, 9, 24); // Heritage Day - open with special hours
        Holiday heritageDay = new Holiday(holidayDate, "Heritage Day", true);
        heritageDay.setSpecialOpenTime(LocalTime.of(9, 0));
        heritageDay.setSpecialCloseTime(LocalTime.of(12, 0));

        when(branchRepository.findById(1L)).thenReturn(Optional.of(branch));
        when(holidayRepository.findByDate(holidayDate)).thenReturn(Optional.of(heritageDay));
        when(slotRepository.existsByBranchIdAndDateAndStartTime(any(), any(), any())).thenReturn(false);
        when(slotRepository.saveAll(any())).thenAnswer(invocation -> invocation.getArgument(0));

        List<AppointmentSlot> slots = slotGenerationService.generateSlotsForDate(1L, holidayDate);

        // 09:00-12:00 in 30min intervals = 6 slots
        assertThat(slots).hasSize(6);
        assertThat(slots.get(0).getStartTime()).isEqualTo(LocalTime.of(9, 0));
        assertThat(slots.get(5).getStartTime()).isEqualTo(LocalTime.of(11, 30));
    }
}
