package com.capitec.booking.dto.response;

import java.util.List;

public class BranchResponse {

    private Long id;
    private String name;
    private String code;
    private String address;
    private String province;
    private Double latitude;
    private Double longitude;
    private List<OperatingHoursResponse> operatingHours;

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getCode() { return code; }
    public void setCode(String code) { this.code = code; }

    public String getAddress() { return address; }
    public void setAddress(String address) { this.address = address; }

    public String getProvince() { return province; }
    public void setProvince(String province) { this.province = province; }

    public Double getLatitude() { return latitude; }
    public void setLatitude(Double latitude) { this.latitude = latitude; }

    public Double getLongitude() { return longitude; }
    public void setLongitude(Double longitude) { this.longitude = longitude; }

    public List<OperatingHoursResponse> getOperatingHours() { return operatingHours; }
    public void setOperatingHours(List<OperatingHoursResponse> operatingHours) { this.operatingHours = operatingHours; }

    public static class OperatingHoursResponse {
        private String dayOfWeek;
        private String openTime;
        private String closeTime;
        private boolean closed;

        public String getDayOfWeek() { return dayOfWeek; }
        public void setDayOfWeek(String dayOfWeek) { this.dayOfWeek = dayOfWeek; }

        public String getOpenTime() { return openTime; }
        public void setOpenTime(String openTime) { this.openTime = openTime; }

        public String getCloseTime() { return closeTime; }
        public void setCloseTime(String closeTime) { this.closeTime = closeTime; }

        public boolean isClosed() { return closed; }
        public void setClosed(boolean closed) { this.closed = closed; }
    }
}
