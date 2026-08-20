package com.capitec.booking.repository;

import com.capitec.booking.domain.model.Appointment;
import com.capitec.booking.domain.enums.AppointmentStatus;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface AppointmentRepository extends JpaRepository<Appointment, Long> {

    List<Appointment> findByUserId(String userId);

    List<Appointment> findByStatus(AppointmentStatus status);
}
