package com.capitec.booking.repository;

import com.capitec.booking.domain.model.AppointmentSlot;
import com.capitec.booking.domain.enums.SlotStatus;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.time.LocalDate;
import java.util.List;

@Repository
public interface AppointmentSlotRepository extends JpaRepository<AppointmentSlot, Long> {

    List<AppointmentSlot> findByBranchIdAndDate(Long branchId, LocalDate date);

    boolean existsByBranchIdAndDateAndStartTime(Long branchId, LocalDate date, java.time.LocalTime startTime);
}
