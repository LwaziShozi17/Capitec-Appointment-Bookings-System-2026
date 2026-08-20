package com.capitec.booking.domain.model;

import com.capitec.booking.domain.enums.SlotStatus;
import jakarta.persistence.*;
import java.time.LocalDate;
import java.time.LocalTime;

@Entity
@Table(name = "appointment_slots", uniqueConstraints = {
    @UniqueConstraint(columnNames = {"branch_id", "slot_date", "start_time"})
})
public class AppointmentSlot {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "branch_id", nullable = false)
    private Branch branch;

    @Column(name = "slot_date", nullable = false)
    private LocalDate date;

    @Column(name = "start_time", nullable = false)
    private LocalTime startTime;

    @Column(name = "end_time", nullable = false)
    private LocalTime endTime;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private SlotStatus status = SlotStatus.AVAILABLE;

    @Version
    private Long version;

    public AppointmentSlot() {}

    public AppointmentSlot(Branch branch, LocalDate date, LocalTime startTime, LocalTime endTime) {
        this.branch = branch;
        this.date = date;
        this.startTime = startTime;
        this.endTime = endTime;
        this.status = SlotStatus.AVAILABLE;
    }

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public Branch getBranch() { return branch; }
    public void setBranch(Branch branch) { this.branch = branch; }

    public LocalDate getDate() { return date; }
    public void setDate(LocalDate date) { this.date = date; }

    public LocalTime getStartTime() { return startTime; }
    public void setStartTime(LocalTime startTime) { this.startTime = startTime; }

    public LocalTime getEndTime() { return endTime; }
    public void setEndTime(LocalTime endTime) { this.endTime = endTime; }

    public SlotStatus getStatus() { return status; }
    public void setStatus(SlotStatus status) { this.status = status; }

    public Long getVersion() { return version; }
    public void setVersion(Long version) { this.version = version; }
}
