package model;

import java.sql.Timestamp;

public class Message {
    private int messageId;
    private int userId;
    private String userName;
    private Integer billId;
    private Integer maintenanceId;
    private String type; // 'bill', 'maintenance', 'general', 'contract'
    private String content;
    private Timestamp createdAt;
    
    // Default constructor
    public Message() {}
    
    // Constructor with main fields
    public Message(int userId, String type, String content) {
        this.userId = userId;
        this.type = type;
        this.content = content;
        this.createdAt = new Timestamp(System.currentTimeMillis());
    }
    
    // Getters and Setters
    public int getMessageId() {
        return messageId;
    }
    
    public void setMessageId(int messageId) {
        this.messageId = messageId;
    }
    
    public int getUserId() {
        return userId;
    }
    
    public void setUserId(int userId) {
        this.userId = userId;
    }
    
    public String getUserName() {
        return userName;
    }
    
    public void setUserName(String userName) {
        this.userName = userName;
    }
    
    public Integer getBillId() {
        return billId;
    }
    
    public void setBillId(Integer billId) {
        this.billId = billId;
    }
    
    public Integer getMaintenanceId() {
        return maintenanceId;
    }
    
    public void setMaintenanceId(Integer maintenanceId) {
        this.maintenanceId = maintenanceId;
    }
    
    public String getType() {
        return type;
    }
    
    public void setType(String type) {
        this.type = type;
    }
    
    public String getContent() {
        return content;
    }
    
    public void setContent(String content) {
        this.content = content;
    }
    
    public Timestamp getCreatedAt() {
        return createdAt;
    }
    
    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }
    
    @Override
    public String toString() {
        return "Message{" +
                "messageId=" + messageId +
                ", userId=" + userId +
                ", userName='" + userName + '\'' +
                ", billId=" + billId +
                ", maintenanceId=" + maintenanceId +
                ", type='" + type + '\'' +
                ", content='" + content + '\'' +
                ", createdAt=" + createdAt +
                '}';
    }
}
