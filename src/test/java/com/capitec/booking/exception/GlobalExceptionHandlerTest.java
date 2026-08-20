package com.capitec.booking.exception;

import org.junit.jupiter.api.Test;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;

import java.util.Map;

import static org.assertj.core.api.Assertions.assertThat;

class GlobalExceptionHandlerTest {

    private final GlobalExceptionHandler handler = new GlobalExceptionHandler();

    @Test
    void handleSlotNotAvailable_returns409() {
        SlotNotAvailableException ex = new SlotNotAvailableException("Slot already booked");

        ResponseEntity<Map<String, Object>> response = handler.handleSlotNotAvailable(ex);

        assertThat(response.getStatusCode()).isEqualTo(HttpStatus.CONFLICT);
        assertThat(response.getBody()).containsEntry("message", "Slot already booked");
        assertThat(response.getBody()).containsEntry("status", 409);
    }

    @Test
    void handleNotFound_returns404() {
        ResourceNotFoundException ex = new ResourceNotFoundException("Appointment not found: 99");

        ResponseEntity<Map<String, Object>> response = handler.handleNotFound(ex);

        assertThat(response.getStatusCode()).isEqualTo(HttpStatus.NOT_FOUND);
        assertThat(response.getBody()).containsEntry("message", "Appointment not found: 99");
        assertThat(response.getBody()).containsEntry("status", 404);
    }

    @Test
    void handleInvalidOperation_returns400() {
        InvalidOperationException ex = new InvalidOperationException("Cannot cancel completed appointment");

        ResponseEntity<Map<String, Object>> response = handler.handleInvalidOperation(ex);

        assertThat(response.getStatusCode()).isEqualTo(HttpStatus.BAD_REQUEST);
        assertThat(response.getBody()).containsEntry("message", "Cannot cancel completed appointment");
        assertThat(response.getBody()).containsEntry("status", 400);
    }

    @Test
    void handleSlotNotAvailable_includesTimestamp() {
        SlotNotAvailableException ex = new SlotNotAvailableException("test");

        ResponseEntity<Map<String, Object>> response = handler.handleSlotNotAvailable(ex);

        assertThat(response.getBody()).containsKey("timestamp");
        assertThat(response.getBody().get("timestamp")).isNotNull();
    }

    @Test
    void handleNotFound_includesErrorField() {
        ResourceNotFoundException ex = new ResourceNotFoundException("Not found");

        ResponseEntity<Map<String, Object>> response = handler.handleNotFound(ex);

        assertThat(response.getBody()).containsEntry("error", "Not Found");
    }

    @Test
    void handleInvalidOperation_includesErrorField() {
        InvalidOperationException ex = new InvalidOperationException("Bad request");

        ResponseEntity<Map<String, Object>> response = handler.handleInvalidOperation(ex);

        assertThat(response.getBody()).containsEntry("error", "Bad Request");
    }
}
