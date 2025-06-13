package model;

import java.sql.Timestamp;

/**
 *
 * @author ADMIN
 */
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
} 