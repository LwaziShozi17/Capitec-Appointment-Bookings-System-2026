package com.capitec.booking.mapper;

import com.capitec.booking.domain.model.Appointment;
import com.capitec.booking.domain.model.AppointmentSlot;
import com.capitec.booking.dto.response.AppointmentResponse;
import com.capitec.booking.dto.response.SlotResponse;
import org.springframework.stereotype.Component;

@Component
public class AppointmentMapper {

    public AppointmentResponse toResponse(Appointment appointment) {
        AppointmentResponse response = new AppointmentResponse();
        response.setId(appointment.getId());
        response.setReferenceNumber(appointment.getReferenceNumber());
        response.setUserId(appointment.getUserId());
        response.setCustomerName(appointment.getCustomerName());
        response.setCustomerEmail(appointment.getCustomerEmail());
        response.setCustomerPhone(appointment.getCustomerPhone());
        if (appointment.getSlot() != null) {
            if (appointment.getSlot().getBranch() != null) {
                response.setBranchId(appointment.getSlot().getBranch().getId());
                response.setBranchName(appointment.getSlot().getBranch().getName());
                response.setBranchAddress(appointment.getSlot().getBranch().getAddress());
            }
            response.setSlotId(appointment.getSlot().getId());
            response.setDate(appointment.getSlot().getDate());
            response.setStartTime(appointment.getSlot().getStartTime());
            response.setEndTime(appointment.getSlot().getEndTime());
        }
        if (appointment.getServiceType() != null) {
            response.setServiceTypeId(appointment.getServiceType().getId());
            response.setServiceName(appointment.getServiceType().getName());
        }
        response.setStatus(appointment.getStatus());
        response.setCreatedAt(appointment.getCreatedAt());
        return response;
    }

    public SlotResponse toSlotResponse(AppointmentSlot slot) {
        SlotResponse response = new SlotResponse();
        response.setId(slot.getId());
        response.setBranchId(slot.getBranch().getId());
        response.setDate(slot.getDate());
        response.setStartTime(slot.getStartTime());
        response.setEndTime(slot.getEndTime());
        response.setStatus(slot.getStatus());
        return response;
    }
}
