package com.capitec.booking.repository;

import com.capitec.booking.domain.model.Appointment;
import com.capitec.booking.domain.enums.AppointmentStatus;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.EntityGraph;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface AppointmentRepository extends JpaRepository<Appointment, Long> {

    @Override
    @EntityGraph(attributePaths = {"slot", "slot.branch", "serviceType"})
    Optional<Appointment> findById(Long id);

    @Override
    @EntityGraph(attributePaths = {"slot", "slot.branch", "serviceType"})
    Page<Appointment> findAll(Pageable pageable);

    @EntityGraph(attributePaths = {"slot", "slot.branch", "serviceType"})
    Page<Appointment> findByUserId(String userId, Pageable pageable);

    @EntityGraph(attributePaths = {"slot", "slot.branch", "serviceType"})
    Page<Appointment> findByStatus(AppointmentStatus status, Pageable pageable);
}