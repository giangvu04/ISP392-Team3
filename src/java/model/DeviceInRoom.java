/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author ADMIN
 */
public class DeviceInRoom {
    private int roomId;
    private int deviceId;
    private int quantity;
    private String status;
    
    // Thông tin mở rộng từ JOIN với bảng Device
    private String deviceName; // Từ bảng devices

    // Constructors
    public DeviceInRoom() {}

    public DeviceInRoom(int roomId, int deviceId, int quantity, String status) {
        this.roomId = roomId;
        this.deviceId = deviceId;
        this.quantity = quantity;
        this.status = status;
    }

    public DeviceInRoom(int roomId, int deviceId, int quantity, String status, String deviceName) {
        this.roomId = roomId;
        this.deviceId = deviceId;
        this.quantity = quantity;
        this.status = status;
        this.deviceName = deviceName;
    }

    // Getters and Setters
    public int getRoomId() {
        return roomId;
    }

    public void setRoomId(int roomId) {
        this.roomId = roomId;
    }

    public int getDeviceId() {
        return deviceId;
    }

    public void setDeviceId(int deviceId) {
        this.deviceId = deviceId;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getDeviceName() {
        return deviceName;
    }

    public void setDeviceName(String deviceName) {
        this.deviceName = deviceName;
    }

    @Override
    public String toString() {
        return "DeviceInRoom{" +
                "roomId=" + roomId +
                ", deviceId=" + deviceId +
                ", quantity=" + quantity +
                ", status='" + status + '\'' +
                ", deviceName='" + deviceName + '\'' +
                '}';
    }
}
    

