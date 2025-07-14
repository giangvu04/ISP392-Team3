package model;

import java.sql.Timestamp;

public class FeedBack {
    private int feedbackId;
    private int roomId;
    private int userId;
    private String content;
    private Integer rating; // 1-5 sao, có thể null
    private Timestamp createdAt;
    private String authorName;

    public FeedBack() {}

    public int getFeedbackId() {
        return feedbackId;
    }
    public void setFeedbackId(int feedbackId) {
        this.feedbackId = feedbackId;
    }
    public int getRoomId() {
        return roomId;
    }

    public String getAuthorName() {
        return authorName;
    }

    public void setAuthorName(String authorName) {
        this.authorName = authorName;
    }
    
    public void setRoomId(int roomId) {
        this.roomId = roomId;
    }
    public int getUserId() {
        return userId;
    }
    public void setUserId(int userId) {
        this.userId = userId;
    }
    public String getContent() {
        return content;
    }
    public void setContent(String content) {
        this.content = content;
    }
    public Integer getRating() {
        return rating;
    }
    public void setRating(Integer rating) {
        this.rating = rating;
    }
    public Timestamp getCreatedAt() {
        return createdAt;
    }
    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }
}
