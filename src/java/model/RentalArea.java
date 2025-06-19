package model;

import java.sql.Timestamp;
import java.util.Objects;

public class RentalArea {
    
    private int rentalAreaId;
    private int managerId;
    private String name;
    private String address;
    private Timestamp createdAt;

    public RentalArea() {
    }

    public RentalArea(int rentalAreaId, int managerId, String name, String address, Timestamp createdAt) {
        this.rentalAreaId = rentalAreaId;
        this.managerId = managerId;
        this.name = name;
        this.address = address;
        this.createdAt = createdAt;
    }

    public int getRentalAreaId() {
        return rentalAreaId;
    }

    public void setRentalAreaId(int rentalAreaId) {
        this.rentalAreaId = rentalAreaId;
    }

    public int getManagerId() {
        return managerId;
    }

    public void setManagerId(int managerId) {
        this.managerId = managerId;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }
    
    @Override
    public String toString() {
        return "RentalArea{" +
                "rentalAreaId=" + rentalAreaId +
                ", managerId=" + managerId +
                ", name='" + name + '\'' +
                ", address='" + address + '\'' +
                ", createdAt=" + createdAt +
                '}';
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        RentalArea that = (RentalArea) o;
        return rentalAreaId == that.rentalAreaId &&
                managerId == that.managerId &&
                Objects.equals(name, that.name) &&
                Objects.equals(address, that.address) &&
                Objects.equals(createdAt, that.createdAt);
    }
} 