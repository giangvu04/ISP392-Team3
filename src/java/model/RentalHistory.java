package model;

public class RentalHistory {
    private int rentailHistoryID; // RentailHistoryID (INT, PRIMARY KEY)
    private int rentalID;         // RentalID (INT, FOREIGN KEY to rental_areas)
    private int roomID;           // RoomID (INT, FOREIGN KEY to Rooms)
    private int tenantID;         // TenantID (INT, FOREIGN KEY to users)
    private String tenantName;    // TenantName (NVARCHAR(100))
    private String startDate;     // StartDate (NVARCHAR(255))
    private String endDate;       // EndDate (NVARCHAR(255), nullable)
    private double rentPrice;     // RentPrice (DECIMAL(10,2), nullable)
    private String notes;         // Notes (TEXT, nullable)
    private String createdAt;     // CreatedAt (NVARCHAR(255), nullable)

    // Constructor mặc định
    public RentalHistory() {
    }

    // Constructor đầy đủ
    public RentalHistory(int rentailHistoryID, int rentalID, int roomID, int tenantID, 
                         String tenantName, String startDate, String endDate, 
                         double rentPrice, String notes, String createdAt) {
        this.rentailHistoryID = rentailHistoryID;
        this.rentalID = rentalID;
        this.roomID = roomID;
        this.tenantID = tenantID;
        this.tenantName = tenantName;
        this.startDate = startDate;
        this.endDate = endDate;
        this.rentPrice = rentPrice;
        this.notes = notes;
        this.createdAt = createdAt;
    }

    // Getters và Setters
    public int getRentailHistoryID() {
        return rentailHistoryID;
    }

    public void setRentailHistoryID(int rentailHistoryID) {
        this.rentailHistoryID = rentailHistoryID;
    }

    public int getRentalID() {
        return rentalID;
    }

    public void setRentalID(int rentalID) {
        this.rentalID = rentalID;
    }

    public int getRoomID() {
        return roomID;
    }

    public void setRoomID(int roomID) {
        this.roomID = roomID;
    }

    public int getTenantID() {
        return tenantID;
    }

    public void setTenantID(int tenantID) {
        this.tenantID = tenantID;
    }

    public String getTenantName() {
        return tenantName;
    }

    public void setTenantName(String tenantName) {
        this.tenantName = tenantName;
    }

    public String getStartDate() {
        return startDate;
    }

    public void setStartDate(String startDate) {
        this.startDate = startDate;
    }

    public String getEndDate() {
        return endDate;
    }

    public void setEndDate(String endDate) {
        this.endDate = endDate;
    }

    public double getRentPrice() {
        return rentPrice;
    }

    public void setRentPrice(double rentPrice) {
        this.rentPrice = rentPrice;
    }

    public String getNotes() {
        return notes;
    }

    public void setNotes(String notes) {
        this.notes = notes;
    }

    public String getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(String createdAt) {
        this.createdAt = createdAt;
    }

    // toString (dùng cho debug)
    @Override
    public String toString() {
        return "RentalHistory{" +
               "rentailHistoryID=" + rentailHistoryID +
               ", rentalID=" + rentalID +
               ", roomID=" + roomID +
               ", tenantID=" + tenantID +
               ", tenantName='" + tenantName + '\'' +
               ", startDate='" + startDate + '\'' +
               ", endDate='" + endDate + '\'' +
               ", rentPrice=" + rentPrice +
               ", notes='" + notes + '\'' +
               ", createdAt='" + createdAt + '\'' +
               '}';
    }
}