
package model;

import java.sql.Date;
import java.sql.Timestamp;
/**
 *
 * @author DELL
 */
public class Users {
    
    private int userId;
    private int roleId;
    private String fullName;
    private String phoneNumber;
    private String email;
    private String passwordHash;
    private String citizenId;
    private String address;
    private boolean isActive;
    private Timestamp createdAt;
    private Timestamp updatedAt;
    private int roomId;
    private String roomNumber;
    private int rentalAreaId;
    private String rentalAreaName;

    public int getRoomId() { return roomId; }
    public void setRoomId(int roomId) { this.roomId = roomId; }
    public String getRoomNumber() { return roomNumber; }
    public void setRoomNumber(String roomNumber) { this.roomNumber = roomNumber; }
    public int getRentalAreaId() { return rentalAreaId; }
    public void setRentalAreaId(int rentalAreaId) { this.rentalAreaId = rentalAreaId; }
    public String getRentalAreaName() { return rentalAreaName; }
    public void setRentalAreaName(String rentalAreaName) { this.rentalAreaName = rentalAreaName; }

    public Users() {
    }

    public boolean isIsActive() {
        return isActive;
    }

    public void setIsActive(boolean isActive) {
        this.isActive = isActive;
    }

    public Users(int userId, int roleId, String fullName, String phoneNumber, String email, 
                 String passwordHash, String citizenId, String address, boolean isActive, 
                 Timestamp createdAt, Timestamp updatedAt) {
        this.userId = userId;
        this.roleId = roleId;
        this.fullName = fullName;
        this.phoneNumber = phoneNumber;
        this.email = email;
        this.passwordHash = passwordHash;
        this.citizenId = citizenId;
        this.address = address;
        this.isActive = isActive;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public int getRoleId() {
        return roleId;
    }

    public void setRoleId(int roleId) {
        this.roleId = roleId;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public String getPhoneNumber() {
        return phoneNumber;
    }

    public void setPhoneNumber(String phoneNumber) {
        this.phoneNumber = phoneNumber;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPasswordHash() {
        return passwordHash;
    }

    public void setPasswordHash(String passwordHash) {
        this.passwordHash = passwordHash;
    }

    public String getCitizenId() {
        return citizenId;
    }

    public void setCitizenId(String citizenId) {
        this.citizenId = citizenId;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public boolean isActive() {
        return isActive;
    }

    public void setActive(boolean active) {
        isActive = active;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public Timestamp getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(Timestamp updatedAt) {
        this.updatedAt = updatedAt;
    }

    // Backward compatibility methods for existing code
    public int getID() {
        return userId;
    }

    public void setID(int ID) {
        this.userId = ID;
    }

    public String getUsername() {
        return email != null ? email : phoneNumber;
    }

    public void setUsername(String username) {
        this.email = username;
    }

    public String getPhone() {
        return phoneNumber;
    }

    public void setPhone(String phone) {
        this.phoneNumber = phone;
    }

    public int getRoleid() {
        return roleId;
    }

    public void setRoleid(int roleid) {
        this.roleId = roleid;
    }

    public Date getCreateAt() {
        return createdAt != null ? new Date(createdAt.getTime()) : null;
    }

    public void setCreateAt(Date createAt) {
        this.createdAt = createAt != null ? new Timestamp(createAt.getTime()) : null;
    }

    public Date getUpdateAt() {
        return updatedAt != null ? new Date(updatedAt.getTime()) : null;
    }

    public void setUpdateAt(Date updateAt) {
        this.updatedAt = updateAt != null ? new Timestamp(updateAt.getTime()) : null;
    }

    public int getIsDelete() {
        return isActive ? 0 : 1;
    }

    public void setIsDelete(int isDelete) {
        this.isActive = isDelete == 0;
    }
}
