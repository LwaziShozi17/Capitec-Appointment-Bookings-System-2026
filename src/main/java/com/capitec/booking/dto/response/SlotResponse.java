package com.capitec.booking.dto.response;

import com.capitec.booking.domain.enums.SlotStatus;
import java.time.LocalDate;
import java.time.LocalTime;

public class SlotResponse {

    private Long id;
    private Long branchId;
    private LocalDate date;
    private LocalTime startTime;
    private LocalTime endTime;
    private SlotStatus status;

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public Long getBranchId() { return branchId; }
    public void setBranchId(Long branchId) { this.branchId = branchId; }

    public LocalDate getDate() { return date; }
    public void setDate(LocalDate date) { this.date = date; }

    public LocalTime getStartTime() { return startTime; }
    public void setStartTime(LocalTime startTime) { this.startTime = startTime; }

    public LocalTime getEndTime() { return endTime; }
    public void setEndTime(LocalTime endTime) { this.endTime = endTime; }

    public SlotStatus getStatus() { return status; }
    public void setStatus(SlotStatus status) { this.status = status; }
}
