package com.capitec.booking.controller;

import com.capitec.booking.domain.model.ServiceType;
import com.capitec.booking.repository.ServiceTypeRepository;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;

import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.when;

class ServiceTypeControllerTest {

    private ServiceTypeRepository serviceTypeRepository;
    private ServiceTypeController controller;

    @BeforeEach
    void setUp() {
        serviceTypeRepository = mock(ServiceTypeRepository.class);
        controller = new ServiceTypeController(serviceTypeRepository);
    }

    @Test
    void getAllServices_returns200WithList() {
        ServiceType service1 = new ServiceType("Card Collection", "Collect your card", 20);
        service1.setId(1L);
        service1.setRequiredDocuments("SA ID;Proof of Address");

        ServiceType service2 = new ServiceType("New Account", "Open account", 45);
        service2.setId(2L);
        service2.setRequiredDocuments("SA ID;Proof of Income");

        when(serviceTypeRepository.findAll()).thenReturn(List.of(service1, service2));

        ResponseEntity<List<ServiceType>> response = controller.getAllServiceTypes();

        assertThat(response.getStatusCode()).isEqualTo(HttpStatus.OK);
        assertThat(response.getBody()).hasSize(2);
        assertThat(response.getBody().get(0).getName()).isEqualTo("Card Collection");
        assertThat(response.getBody().get(0).getDurationMinutes()).isEqualTo(20);
    }

    @Test
    void getAllServices_emptyList() {
        when(serviceTypeRepository.findAll()).thenReturn(List.of());

        ResponseEntity<List<ServiceType>> response = controller.getAllServiceTypes();

        assertThat(response.getStatusCode()).isEqualTo(HttpStatus.OK);
        assertThat(response.getBody()).isEmpty();
    }
}
