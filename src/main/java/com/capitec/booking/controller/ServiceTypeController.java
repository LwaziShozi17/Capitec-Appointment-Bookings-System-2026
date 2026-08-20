package com.capitec.booking.controller;

import com.capitec.booking.domain.model.ServiceType;
import com.capitec.booking.repository.ServiceTypeRepository;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/api/v1/services")
@Tag(name = "Services", description = "Available service types")
public class ServiceTypeController {

    private final ServiceTypeRepository serviceTypeRepository;

    public ServiceTypeController(ServiceTypeRepository serviceTypeRepository) {
        this.serviceTypeRepository = serviceTypeRepository;
    }

    @Operation(summary = "List all service types", description = "Returns available services with duration and required documents")
    @GetMapping
    public ResponseEntity<List<ServiceType>> getAllServiceTypes() {
        return ResponseEntity.ok(serviceTypeRepository.findAll());
    }
}
