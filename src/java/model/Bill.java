 /*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */

package model;

import java.lang.*;
/**
 *
 * @author Vu Thi Huong Giang
 */

public class Bill {
    private int id;
    private String tenantName;
    private String roomNumber;
    private double electricityCost;
    private double waterCost;
    private double serviceCost;
    private double total;
    private String dueDate;
    private String status;
    private String createdDate;
    private String emailTelnant;
    private String note; // Ghi chú hóa đơn

    // Constructor mặc định
    public Bill() {}

    // Constructor đầy đủ
    public Bill(int id, String tenantName, String roomNumber, double electricityCost, 
                double waterCost, double serviceCost, double total, String dueDate, 
                String status, String createdDate, String note) {
        this.id = id;
        this.tenantName = tenantName;
        this.roomNumber = roomNumber;
        this.electricityCost = electricityCost;
        this.waterCost = waterCost;
        this.serviceCost = serviceCost;
        this.total = total;
        this.dueDate = dueDate;
        this.status = status;
        this.createdDate = createdDate;
        this.note = note;
    }
    public String getNote() {
        return note;
    }

    public void setNote(String note) {
        this.note = note;
    }

    public String getEmailTelnant() {
        return emailTelnant;
    }

    public void setEmailTelnant(String emailTelnant) {
        this.emailTelnant = emailTelnant;
    }

    // Getters và Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    public String getTenantName() { return tenantName; }
    public void setTenantName(String tenantName) { this.tenantName = tenantName; }
    public String getRoomNumber() { return roomNumber; }
    public void setRoomNumber(String roomNumber) { this.roomNumber = roomNumber; }
    public double getElectricityCost() { return electricityCost; }
    public void setElectricityCost(double electricityCost) { this.electricityCost = electricityCost; }
    public double getWaterCost() { return waterCost; }
    public void setWaterCost(double waterCost) { this.waterCost = waterCost; }
    public double getServiceCost() { return serviceCost; }
    public void setServiceCost(double serviceCost) { this.serviceCost = serviceCost; }
    public double getTotal() { return total; }
    public void setTotal(double total) { this.total = total; }
    public String getDueDate() { return dueDate; }
    public void setDueDate(String dueDate) { this.dueDate = dueDate; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }
    public String getCreatedDate() { return createdDate; }
    public void setCreatedDate(String createdDate) { this.createdDate = createdDate; }

}