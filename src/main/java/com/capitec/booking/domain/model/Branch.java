package com.capitec.booking.domain.model;

import jakarta.persistence.*;
import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "branches")
public class Branch {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false)
    private String name;

    @Column(nullable = false, unique = true)
    private String code;

    private String address;

    private String province;

    private Double latitude;

    private Double longitude;

    @OneToMany(mappedBy = "branch", cascade = CascadeType.ALL, orphanRemoval = true)
    private List<OperatingHours> operatingHours = new ArrayList<>();

    public Branch() {}

    public Branch(String name, String code, String address) {
        this.name = name;
        this.code = code;
        this.address = address;
    }

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

    public List<OperatingHours> getOperatingHours() { return operatingHours; }
    public void setOperatingHours(List<OperatingHours> operatingHours) { this.operatingHours = operatingHours; }
}
