package model;

import java.util.Date;

public class MaintenanceLog {
    private int maintenanceId;
    private int rentalAreaId;
    private String rentalAreaName;
    private Integer roomId;
    private String roomName;
    private String title;
    private String description;
    private String deviceInfo; // Added for device information
    private Date maintenanceDate;
    private Double cost;
    private int createdBy;
    private String createdByName;
    private Date createdAt;
    private String status; // trạng thái xử lý
    private String ownerNote; // phản hồi chủ nhà

    // Getters and setters
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    public String getOwnerNote() { return ownerNote; }
    public void setOwnerNote(String ownerNote) { this.ownerNote = ownerNote; }
    public int getMaintenanceId() { return maintenanceId; }
    public void setMaintenanceId(int maintenanceId) { this.maintenanceId = maintenanceId; }
    public int getRentalAreaId() { return rentalAreaId; }
    public void setRentalAreaId(int rentalAreaId) { this.rentalAreaId = rentalAreaId; }
    public String getRentalAreaName() { return rentalAreaName; }
    public void setRentalAreaName(String rentalAreaName) { this.rentalAreaName = rentalAreaName; }
    public Integer getRoomId() { return roomId; }
    public void setRoomId(Integer roomId) { this.roomId = roomId; }
    public String getRoomName() { return roomName; }
    public void setRoomName(String roomName) { this.roomName = roomName; }
    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
    public String getDeviceInfo() { return deviceInfo; }
    public void setDeviceInfo(String deviceInfo) { this.deviceInfo = deviceInfo; }
    public Date getMaintenanceDate() { return maintenanceDate; }
    public void setMaintenanceDate(Date maintenanceDate) { this.maintenanceDate = maintenanceDate; }
    public Double getCost() { return cost; }
    public void setCost(Double cost) { this.cost = cost; }
    public int getCreatedBy() { return createdBy; }
    public void setCreatedBy(int createdBy) { this.createdBy = createdBy; }
    public String getCreatedByName() { return createdByName; }
    public void setCreatedByName(String createdByName) { this.createdByName = createdByName; }
    public Date getCreatedAt() { return createdAt; }
    public void setCreatedAt(Date createdAt) { this.createdAt = createdAt; }
}
