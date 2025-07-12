package model;

import java.math.BigDecimal;

public class Rooms {
    
    private int roomId;
    private int rentalAreaId;
    private String roomNumber;
    private BigDecimal area;
    private BigDecimal price;
    private int maxTenants;
    private int status; // 0: Available, 1: Occupied, 2: Under Maintenance
    private String description;
    // Transient fields for display purposes
    private String rentalAreaName;
    private String currentTenant;
    private RentalArea retalArea;
    private String imageUrl;
    
    public Rooms() {
    }

    public Rooms(int roomId, int rentalAreaId, String roomNumber, BigDecimal area, BigDecimal price, int maxTenants, int status, String description, String rentalAreaName, String currentTenant) {
        this.roomId = roomId;
        this.rentalAreaId = rentalAreaId;
        this.roomNumber = roomNumber;
        this.area = area;
        this.price = price;
        this.maxTenants = maxTenants;
        this.status = status;
        this.description = description;
        this.rentalAreaName = rentalAreaName;
        this.currentTenant = currentTenant;
    }

    public int getRoomId() {
        return roomId;
    }

    public String getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }

    public RentalArea getRetalArea() {
        return retalArea;
    }

    public void setRetalArea(RentalArea retalArea) {
        this.retalArea = retalArea;
    }

    public void setRoomId(int roomId) {
        this.roomId = roomId;
    }

    public int getRentalAreaId() {
        return rentalAreaId;
    }

    public void setRentalAreaId(int rentalAreaId) {
        this.rentalAreaId = rentalAreaId;
    }

    public String getRoomNumber() {
        return roomNumber;
    }

    public void setRoomNumber(String roomNumber) {
        this.roomNumber = roomNumber;
    }

    public BigDecimal getArea() {
        return area;
    }

    public void setArea(BigDecimal area) {
        this.area = area;
    }

    public BigDecimal getPrice() {
        return price;
    }

    public void setPrice(BigDecimal price) {
        this.price = price;
    }

    public int getMaxTenants() {
        return maxTenants;
    }

    public void setMaxTenants(int maxTenants) {
        this.maxTenants = maxTenants;
    }

    public int getStatus() {
        return status;
    }

    public void setStatus(int status) {
        this.status = status;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public String getRentalAreaName() {
        return rentalAreaName;
    }

    public void setRentalAreaName(String rentalAreaName) {
        this.rentalAreaName = rentalAreaName;
    }

    public String getCurrentTenant() {
        return currentTenant;
    }

    public void setCurrentTenant(String currentTenant) {
        this.currentTenant = currentTenant;
    }

    // Helper method to get status as string
    public String getStatusAsString() {
        switch (status) {
            case 0: return "Available";
            case 1: return "Occupied";
            case 2: return "Maintenance";
            default: return "Unknown";
        }
    }
}
