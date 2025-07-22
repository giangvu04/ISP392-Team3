package model;

import Const.ViewingRequestStatus;
import java.util.Date;

public class ViewingRequest {
    private int requestId;
    private int postId;
    private int tenantId;
    private String fullName;
    private String phone;
    private String email;
    private String message;
    private Date preferredDate;
    private int status;
    private Date createdAt;
    private String adminNote;
    private Date responseDate;
    private boolean isRead; // Đánh dấu đã đọc cho manager
    
    // Additional fields for JOIN queries
    private String postTitle;
    private String tenantName;
    // Room information - hiển thị tất cả phòng trong post
    private String roomsInfo;         // Thông tin tổng hợp về phòng
    private String rentalAreaName;    // Tên khu trọ
    private String rentalAreaAddress; // Địa chỉ khu trọ
    
    // Constructors
    public ViewingRequest() {}
    
    public ViewingRequest(int postId, int tenantId, String fullName, String phone, 
                         String email, String message, Date preferredDate) {
        this.postId = postId;
        this.tenantId = tenantId;
        this.fullName = fullName;
        this.phone = phone;
        this.email = email;
        this.message = message;
        this.preferredDate = preferredDate;
        this.status = ViewingRequestStatus.PENDING;
        this.createdAt = new Date();
    }
    
    // Getters and Setters
    public int getRequestId() { return requestId; }
    public void setRequestId(int requestId) { this.requestId = requestId; }
    
    public int getPostId() { return postId; }
    public void setPostId(int postId) { this.postId = postId; }
    
    public int getTenantId() { return tenantId; }
    public void setTenantId(int tenantId) { this.tenantId = tenantId; }
    
    public String getFullName() { return fullName; }
    public void setFullName(String fullName) { this.fullName = fullName; }
    
    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }
    
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
    
    public String getMessage() { return message; }
    public void setMessage(String message) { this.message = message; }
    
    public Date getPreferredDate() { return preferredDate; }
    public void setPreferredDate(Date preferredDate) { this.preferredDate = preferredDate; }
    
    public int getStatus() { return status; }
    public void setStatus(int status) { this.status = status; }
    
    public Date getCreatedAt() { return createdAt; }
    public void setCreatedAt(Date createdAt) { this.createdAt = createdAt; }
    
    public String getAdminNote() { return adminNote; }
    public void setAdminNote(String adminNote) { this.adminNote = adminNote; }
    
    public Date getResponseDate() { return responseDate; }
    public void setResponseDate(Date responseDate) { this.responseDate = responseDate; }
    
    // Additional getters/setters for JOIN fields
    public String getPostTitle() { return postTitle; }
    public void setPostTitle(String postTitle) { this.postTitle = postTitle; }
    
    public String getTenantName() { return tenantName; }
    public void setTenantName(String tenantName) { this.tenantName = tenantName; }
    
    // Room information getters/setters
    public String getRoomsInfo() { return roomsInfo; }
    public void setRoomsInfo(String roomsInfo) { this.roomsInfo = roomsInfo; }
    
    public String getRentalAreaName() { return rentalAreaName; }
    public void setRentalAreaName(String rentalAreaName) { this.rentalAreaName = rentalAreaName; }
    
    public String getRentalAreaAddress() { return rentalAreaAddress; }
    public void setRentalAreaAddress(String rentalAreaAddress) { this.rentalAreaAddress = rentalAreaAddress; }
    
    public boolean getIsRead() { return isRead; }
    public void setIsRead(boolean isRead) { this.isRead = isRead; }
    
    // Legacy compatibility methods for backward compatibility
    public Date getRequestedDate() { return preferredDate; }
    public void setRequestedDate(Date requestedDate) { this.preferredDate = requestedDate; }
    
    public String getNote() { return message; }
    public void setNote(String note) { this.message = note; }
    
    // Helper methods
    public String getStatusText() {
        return ViewingRequestStatus.getStatusText(this.status);
    }
}
