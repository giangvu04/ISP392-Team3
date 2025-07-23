package model;

import java.util.Date;

public class RentalPost {
    private int postId;
    private int managerId;
    private int rentalAreaId;
    private String title;
    private String description;
    private String contactInfo;
    private String featuredImage;
    private boolean isFeatured;
    private boolean isActive;
    private int viewsCount;
    private Date createdAt;
    private Date updatedAt;
    
    // Additional fields for JOIN queries
    private String managerName;
    private String managerPhone;
    private String managerEmail;
    private String rentalAreaName;
    private String rentalAreaAddress;
    private double roomPrice;
    private String roomNumber;
    
    // Constructors
    public RentalPost() {}
    
    public RentalPost(int managerId, int rentalAreaId, String title, String description, String contactInfo) {
        this.managerId = managerId;
        this.rentalAreaId = rentalAreaId;
        this.title = title;
        this.description = description;
        this.contactInfo = contactInfo;
        this.isFeatured = false;
        this.isActive = true;
        this.viewsCount = 0;
    }
    
    // Getters and Setters
    public int getPostId() { return postId; }
    public void setPostId(int postId) { this.postId = postId; }
    
    public int getManagerId() { return managerId; }
    public void setManagerId(int managerId) { this.managerId = managerId; }
    
    public int getRentalAreaId() { return rentalAreaId; }
    public void setRentalAreaId(int rentalAreaId) { this.rentalAreaId = rentalAreaId; }
    
    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }
    
    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }
    
    public String getContactInfo() { return contactInfo; }
    public void setContactInfo(String contactInfo) { this.contactInfo = contactInfo; }
    
    public String getFeaturedImage() { return featuredImage; }
    public void setFeaturedImage(String featuredImage) { this.featuredImage = featuredImage; }
    
    public boolean isFeatured() { return isFeatured; }
    public void setFeatured(boolean featured) { isFeatured = featured; }
    
    public boolean isActive() { return isActive; }
    public void setActive(boolean active) { isActive = active; }
    
    public int getViewsCount() { return viewsCount; }
    public void setViewsCount(int viewsCount) { this.viewsCount = viewsCount; }
    
    public Date getCreatedAt() { return createdAt; }
    public void setCreatedAt(Date createdAt) { this.createdAt = createdAt; }
    
    public Date getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(Date updatedAt) { this.updatedAt = updatedAt; }
    
    public String getManagerName() { return managerName; }
    public void setManagerName(String managerName) { this.managerName = managerName; }
    
    public String getManagerPhone() { return managerPhone; }
    public void setManagerPhone(String managerPhone) { this.managerPhone = managerPhone; }
    
    public String getManagerEmail() { return managerEmail; }
    public void setManagerEmail(String managerEmail) { this.managerEmail = managerEmail; }
    
    public String getRentalAreaName() { return rentalAreaName; }
    public void setRentalAreaName(String rentalAreaName) { this.rentalAreaName = rentalAreaName; }
    
    public String getRentalAreaAddress() { return rentalAreaAddress; }
    public void setRentalAreaAddress(String rentalAreaAddress) { this.rentalAreaAddress = rentalAreaAddress; }
    
    public double getRoomPrice() { return roomPrice; }
    public void setRoomPrice(double roomPrice) { this.roomPrice = roomPrice; }
    
    public String getRoomNumber() { return roomNumber; }
    public void setRoomNumber(String roomNumber) { this.roomNumber = roomNumber; }
}
