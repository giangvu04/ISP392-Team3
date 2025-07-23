package model;

import java.math.BigDecimal;

/**
 *
 * @author ADMIN
 */
public class Room {
    
    private int roomId;
    private int rentalAreaId;
    private String roomNumber;
    private BigDecimal area;
    private BigDecimal price;
    private int maxTenants;
    private int status; // 0: Trống, 1: Đã có người thuê, 2: Đang sửa chữa
    private String description;
     private String imageUrl;

    public Room() {
    }

    public Room(int roomId, int rentalAreaId, String roomNumber, BigDecimal area, 
                BigDecimal price, int maxTenants, int status, String description) {
        this.roomId = roomId;
        this.rentalAreaId = rentalAreaId;
        this.roomNumber = roomNumber;
        this.area = area;
        this.price = price;
        this.maxTenants = maxTenants;
        this.status = status;
        this.description = description;
    }

    public String getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }

    public int getRoomId() {
        return roomId;
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

    // Helper methods for status
    public String getStatusText() {
        switch (status) {
            case 0: return "Trống";
            case 1: return "Đã thuê";
            case 2: return "Đang sửa chữa";
            default: return "Không xác định";
        }
    }

    public boolean isAvailable() {
        return status == 0;
    }

    public boolean isOccupied() {
        return status == 1;
    }

    public boolean isUnderMaintenance() {
        return status == 2;
    }
}