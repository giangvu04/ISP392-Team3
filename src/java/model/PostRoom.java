package model;

public class PostRoom {
    private int postId;
    private int roomId;
    
    // Additional fields for JOIN queries
    private String roomNumber;
    private String roomDescription;
    private double roomPrice;
    private double roomArea;
    private int maxTenants;
    private int roomStatus;
    
    // Constructors
    public PostRoom() {}
    
    public PostRoom(int postId, int roomId) {
        this.postId = postId;
        this.roomId = roomId;
    }
    
    // Getters and Setters
    public int getPostId() { return postId; }
    public void setPostId(int postId) { this.postId = postId; }
    
    public int getRoomId() { return roomId; }
    public void setRoomId(int roomId) { this.roomId = roomId; }
    
    public String getRoomNumber() { return roomNumber; }
    public void setRoomNumber(String roomNumber) { this.roomNumber = roomNumber; }
    
    public String getRoomDescription() { return roomDescription; }
    public void setRoomDescription(String roomDescription) { this.roomDescription = roomDescription; }
    
    public double getRoomPrice() { return roomPrice; }
    public void setRoomPrice(double roomPrice) { this.roomPrice = roomPrice; }
    
    public double getRoomArea() { return roomArea; }
    public void setRoomArea(double roomArea) { this.roomArea = roomArea; }
    
    public int getMaxTenants() { return maxTenants; }
    public void setMaxTenants(int maxTenants) { this.maxTenants = maxTenants; }
    
    public int getRoomStatus() { return roomStatus; }
    public void setRoomStatus(int roomStatus) { this.roomStatus = roomStatus; }
}
