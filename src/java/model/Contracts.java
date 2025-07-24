package model;

import java.math.BigDecimal;
import java.sql.Date;

public class Contracts {
    private int contractId;
    private int roomId;
    private int tenantId;
    private Date startDate;
    private Date endDate;
    private BigDecimal rentPrice;
    private BigDecimal depositAmount;
    private int status;
    private String note;
    private String roomNumber; 
    private String areaName;
    private String nameTelnant;

    // Constructors
    public Contracts() {
    }

    public Contracts(int contractId, int roomId, int tenantId, Date startDate, Date endDate,
                    BigDecimal rentPrice, BigDecimal depositAmount, int status, String note) {
        this.contractId = contractId;
        this.roomId = roomId;
        this.tenantId = tenantId;
        this.startDate = startDate;
        this.endDate = endDate;
        this.rentPrice = rentPrice;
        this.depositAmount = depositAmount;
        this.status = status;
        this.note = note;
    }

    public String getRoomNumber() {
        return roomNumber;
    }

    public void setRoomNumber(String roomNumber) {
        this.roomNumber = roomNumber;
    }

    public String getAreaName() {
        return areaName;
    }

    public void setAreaName(String areaName) {
        this.areaName = areaName;
    }

    public String getNameTelnant() {
        return nameTelnant;
    }

    public void setNameTelnant(String nameTelnant) {
        this.nameTelnant = nameTelnant;
    }

    // Getters and Setters
    public int getContractId() {
        return contractId;
    }

    public void setContractId(int contractId) {
        this.contractId = contractId;
    }

    public int getRoomId() {
        return roomId;
    }

    public void setRoomId(int roomId) {
        this.roomId = roomId;
    }

    public int getTenantId() {
        return tenantId;
    }

    public void setTenantId(int tenantId) {
        this.tenantId = tenantId;
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

    public BigDecimal getRentPrice() {
        return rentPrice;
    }

    public void setRentPrice(BigDecimal rentPrice) {
        this.rentPrice = rentPrice;
    }

    public BigDecimal getDepositAmount() {
        return depositAmount;
    }

    public void setDepositAmount(BigDecimal depositAmount) {
        this.depositAmount = depositAmount;
    }

    public int getStatus() {
        return status;
    }

    public void setStatus(int status) {
        this.status = status;
    }

    public String getNote() {
        return note;
    }

    public void setNote(String note) {
        this.note = note;
    }

    // Legacy method names for backward compatibility (if needed)
    public int getRoomID() {
        return roomId;
    }

    public void setRoomID(int roomId) {
        this.roomId = roomId;
    }

    public int getTenantsID() {
        return tenantId;
    }

    public void setTenantsID(int tenantId) {
        this.tenantId = tenantId;
    }

    @Override
    public String toString() {
        return "Contracts{" +
                "contractId=" + contractId +
                ", roomId=" + roomId +
                ", tenantId=" + tenantId +
                ", startDate=" + startDate +
                ", endDate=" + endDate +
                ", rentPrice=" + rentPrice +
                ", depositAmount=" + depositAmount +
                ", status=" + status +
                ", note='" + note + '\'' +
                '}';
    }
}