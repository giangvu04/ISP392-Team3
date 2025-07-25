package model;

import java.sql.Timestamp;

public class RentalArea {
    private int rentalAreaId;
    private int managerId;
    private String name;
    private String address;
    private String province;
    private String district;
    private String ward;
    private String street;
    private String detail;
    private String qrForBill;
    private Timestamp createdAt;
    private int totalRooms;
    private int status;

    public RentalArea() {}

    // Getters and setters
    public int getRentalAreaId() { return rentalAreaId; }
    public void setRentalAreaId(int rentalAreaId) { this.rentalAreaId = rentalAreaId; }

    public int getManagerId() { return managerId; }
    public void setManagerId(int managerId) { this.managerId = managerId; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getAddress() { return address; }
    public void setAddress(String address) { this.address = address; }

    public String getProvince() { return province; }
    public void setProvince(String province) { this.province = province; }

    public String getDistrict() { return district; }
    public void setDistrict(String district) { this.district = district; }

    public String getWard() { return ward; }
    public void setWard(String ward) { this.ward = ward; }

    public String getStreet() { return street; }
    public void setStreet(String street) { this.street = street; }

    public String getDetail() { return detail; }
    public void setDetail(String detail) { this.detail = detail; }

    public String getQrForBill() { return qrForBill; }
    public void setQrForBill(String qrForBill) { this.qrForBill = qrForBill; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

    public int getTotalRooms() { return totalRooms; }
    public void setTotalRooms(int totalRooms) { this.totalRooms = totalRooms; }

    public int getStatus() { return status; }
    public void setStatus(int status) { this.status = status; }

    @Override
    public String toString() {
        return "RentalArea{" +
                "rentalAreaId=" + rentalAreaId +
                ", managerId=" + managerId +
                ", name='" + name + '\'' +
                ", address='" + address + '\'' +
                ", province='" + province + '\'' +
                ", district='" + district + '\'' +
                ", ward='" + ward + '\'' +
                ", street='" + street + '\'' +
                ", detail='" + detail + '\'' +
                ", qrForBill='" + qrForBill + '\'' +
                ", createdAt=" + createdAt +
                ", totalRooms=" + totalRooms +
                ", status=" + status +
                '}';
    }
}