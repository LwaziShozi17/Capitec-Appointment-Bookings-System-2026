package com.capitec.booking.controller;

import com.capitec.booking.domain.enums.SlotStatus;
import com.capitec.booking.domain.model.AppointmentSlot;
import com.capitec.booking.domain.model.Branch;
import com.capitec.booking.mapper.AppointmentMapper;
import com.capitec.booking.service.SlotService;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;

import java.time.LocalDate;
import java.time.LocalTime;
import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.when;

class SlotControllerTest {

    private SlotService slotService;
    private AppointmentMapper mapper;
    private SlotController controller;

    @BeforeEach
    void setUp() {
        slotService = mock(SlotService.class);
        mapper = new AppointmentMapper();
        controller = new SlotController(slotService, mapper);
    }

    @Test
    void shouldReturnSlotsWithCorrectStatus() {
        Branch branch = new Branch("Capitec Sandton", "CAP-SDN", "Sandton City");
        branch.setId(1L);

        AppointmentSlot available = new AppointmentSlot(branch, LocalDate.of(2026, 6, 15),
                LocalTime.of(9, 0), LocalTime.of(9, 30));
        available.setId(1L);
        available.setStatus(SlotStatus.AVAILABLE);

        AppointmentSlot booked = new AppointmentSlot(branch, LocalDate.of(2026, 6, 15),
                LocalTime.of(9, 30), LocalTime.of(10, 0));
        booked.setId(2L);
        booked.setStatus(SlotStatus.BOOKED);

        when(slotService.getSlotsByBranchAndDate(1L, LocalDate.of(2026, 6, 15)))
                .thenReturn(List.of(available, booked));

        ResponseEntity<?> response = controller.getSlots(1L, LocalDate.of(2026, 6, 15));

        assertThat(response.getStatusCode()).isEqualTo(HttpStatus.OK);
        var slots = (List<?>) response.getBody();
        assertThat(slots).hasSize(2);
    }
}
