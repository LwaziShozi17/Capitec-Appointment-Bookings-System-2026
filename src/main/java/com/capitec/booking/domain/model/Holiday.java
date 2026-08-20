package com.capitec.booking.domain.model;

import jakarta.persistence.*;
import java.time.LocalDate;
import java.time.LocalTime;

@Entity
@Table(name = "holidays")
public class Holiday {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false)
    private LocalDate date;

    @Column(nullable = false)
    private String name;

    @Column(nullable = false)
    private boolean open;

    private LocalTime specialOpenTime;

    private LocalTime specialCloseTime;

    public Holiday() {}

    public Holiday(LocalDate date, String name, boolean open) {
        this.date = date;
        this.name = name;
        this.open = open;
    }

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public LocalDate getDate() { return date; }
    public void setDate(LocalDate date) { this.date = date; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public boolean isOpen() { return open; }
    public void setOpen(boolean open) { this.open = open; }

    public LocalTime getSpecialOpenTime() { return specialOpenTime; }
    public void setSpecialOpenTime(LocalTime specialOpenTime) { this.specialOpenTime = specialOpenTime; }

    public LocalTime getSpecialCloseTime() { return specialCloseTime; }
    public void setSpecialCloseTime(LocalTime specialCloseTime) { this.specialCloseTime = specialCloseTime; }
}
