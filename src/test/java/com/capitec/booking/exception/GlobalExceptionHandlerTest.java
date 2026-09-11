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

    @Test
    void handleValidation_includesMessageAndDetails() {
        org.springframework.validation.BindingResult bindingResult = new org.springframework.validation.BeanPropertyBindingResult(new Object(), "target");
        bindingResult.addError(new org.springframework.validation.FieldError("target", "email", "Invalid email format"));

        org.springframework.core.MethodParameter methodParameter = new org.springframework.core.MethodParameter(
                GlobalExceptionHandlerTest.class.getDeclaredMethods()[0], -1);
        org.springframework.web.bind.MethodArgumentNotValidException ex =
                new org.springframework.web.bind.MethodArgumentNotValidException(methodParameter, bindingResult);

        ResponseEntity<Map<String, Object>> response = handler.handleValidation(ex);

        assertThat(response.getStatusCode()).isEqualTo(HttpStatus.BAD_REQUEST);
        assertThat(response.getBody()).containsEntry("error", "Validation Failed");
        assertThat(response.getBody()).containsEntry("message", "Invalid email format");
        assertThat(response.getBody()).containsKey("details");
    }

    @Test
    void handleIllegalArgument_returns400() {
        IllegalArgumentException ex = new IllegalArgumentException("Invalid argument provided");

        ResponseEntity<Map<String, Object>> response = handler.handleIllegalArgument(ex);

        assertThat(response.getStatusCode()).isEqualTo(HttpStatus.BAD_REQUEST);
        assertThat(response.getBody()).containsEntry("message", "Invalid argument provided");
    }

    @Test
    void handleGeneralException_returns500() {
        RuntimeException ex = new RuntimeException("Server error");

        ResponseEntity<Map<String, Object>> response = handler.handleGeneralException(ex);

        assertThat(response.getStatusCode()).isEqualTo(HttpStatus.INTERNAL_SERVER_ERROR);
        assertThat(response.getBody()).containsEntry("message", "Server error");
    }
}
