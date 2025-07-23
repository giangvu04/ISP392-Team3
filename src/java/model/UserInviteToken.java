package model;

import java.sql.Timestamp;

public class UserInviteToken {
    private int tokenId;
    private Integer userId; // Có thể null
    private String email;
    private int roomId;
    private String token;
    private Timestamp createdAt;
    private Timestamp expiresAt;
    private boolean isUsed;

    public int getTokenId() { return tokenId; }
    public void setTokenId(int tokenId) { this.tokenId = tokenId; }

    public Integer getUserId() { return userId; }
    public void setUserId(Integer userId) { this.userId = userId; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public int getRoomId() { return roomId; }
    public void setRoomId(int roomId) { this.roomId = roomId; }

    public String getToken() { return token; }
    public void setToken(String token) { this.token = token; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

    public Timestamp getExpiresAt() { return expiresAt; }
    public void setExpiresAt(Timestamp expiresAt) { this.expiresAt = expiresAt; }

    public boolean isIsUsed() { return isUsed; }
    public void setIsUsed(boolean isUsed) { this.isUsed = isUsed; }
}
