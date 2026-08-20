package com.capitec.booking.repository;

import com.capitec.booking.domain.model.OperatingHours;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.time.DayOfWeek;
import java.util.Optional;

@Repository
public interface OperatingHoursRepository extends JpaRepository<OperatingHours, Long> {
    Optional<OperatingHours> findByBranchIdAndDayOfWeek(Long branchId, DayOfWeek dayOfWeek);
}
