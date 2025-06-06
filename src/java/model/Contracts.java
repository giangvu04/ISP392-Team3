/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;
//import java.util.Date;
import java.sql.Date;
public class Contracts {
    private int contractId;
    private int dealPrice;           
    private Date startDate;
    private Date endDate;
    private int depositAmount;      
    private String note;
    private int tenantCount;
    private int tenantsID;  // Foreign key reference to Tenants
    private int roomID;     // Foreign key reference to Rooms

    // Constructors
    public Contracts() {}

    public Contracts(int contractId, int dealPrice, Date startDate, Date endDate,
                    int depositAmount, String note, int tenantCount, int tenantsID, int roomID) {
        this.contractId = contractId;
        this.dealPrice = dealPrice;
        this.startDate = startDate;
        this.endDate = endDate;
        this.depositAmount = depositAmount;
        this.note = note;
        this.tenantCount = tenantCount;
        this.tenantsID = tenantsID;
        this.roomID = roomID;
    }

    // Getters and Setters
    public int getContractId() {
        return contractId;
    }

    public void setContractId(int contractId) {
        this.contractId = contractId;
    }

    public int getDealPrice() {
        return dealPrice;
    }

    public void setDealPrice(int dealPrice) {
        this.dealPrice = dealPrice;
    }

    public Date getStartDate() {
        return startDate;
    }

    public void setStartDate(Date startDate) {
        this.startDate = startDate;
    }

    public Date getEndDate() {
        return endDate;
    }

    public void setEndDate(Date endDate) {
        this.endDate = endDate;
    }

    public int getDepositAmount() {
        return depositAmount;
    }

    public void setDepositAmount(int depositAmount) {
        this.depositAmount = depositAmount;
    }

    public String getNote() {
        return note;
    }

    public void setNote(String note) {
        this.note = note;
    }

    public int getTenantCount() {
        return tenantCount;
    }

    public void setTenantCount(int tenantCount) {
        this.tenantCount = tenantCount;
    }

    public int getTenantsID() {
        return tenantsID;
    }

    public void setTenantsID(int tenantsID) {
        this.tenantsID = tenantsID;
    }

    public int getRoomID() {
        return roomID;
    }

    public void setRoomID(int roomID) {
        this.roomID = roomID;
    }

}
