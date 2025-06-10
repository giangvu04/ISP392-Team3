package model;

import java.sql.Date;
/**
 *
 * @author DELL
 */
public class Users {
    
    private int ID;
    private String Username;
    private String PasswordHash;
    private String Phone;
    private int Roleid;
    private String FullName;
    private int RentalAreaID;
    private Date CreateAt;
    private Date UpdateAt;
    private int CreateBy;
    private int isDelete;
    private Date deletedAt;
    private int deleteBy;

    public Users() {
    }

    public Users(int ID, String Username, String PasswordHash, String Phone, int Roleid, String FullName, int RentalAreaID, Date CreateAt, Date UpdateAt, int CreateBy, int isDelete, Date deletedAt, int deleteBy) {
        this.ID = ID;
        this.Username = Username;
        this.PasswordHash = PasswordHash;
        this.Phone = Phone;
        this.Roleid = Roleid;
        this.FullName = FullName;
        this.RentalAreaID = RentalAreaID;
        this.CreateAt = CreateAt;
        this.UpdateAt = UpdateAt;
        this.CreateBy = CreateBy;
        this.isDelete = isDelete;
        this.deletedAt = deletedAt;
        this.deleteBy = deleteBy;
    }

    public int getID() {
        return ID;
    }

    public void setID(int ID) {
        this.ID = ID;
    }

    public String getUsername() {
        return Username;
    }

    public void setUsername(String Username) {
        this.Username = Username;
    }

    public String getPasswordHash() {
        return PasswordHash;
    }

    public void setPasswordHash(String PasswordHash) {
        this.PasswordHash = PasswordHash;
    }

    public String getPhone() {
        return Phone;
    }

    public void setPhone(String Phone) {
        this.Phone = Phone;
    }

    public int getRoleid() {
        return Roleid;
    }

    public void setRoleid(int Roleid) {
        this.Roleid = Roleid;
    }

    public String getFullName() {
        return FullName;
    }

    public void setFullName(String FullName) {
        this.FullName = FullName;
    }

    public int getRentalAreaID() {
        return RentalAreaID;
    }

    public void setRentalAreaID(int RentalAreaID) {
        this.RentalAreaID = RentalAreaID;
    }

    public Date getCreateAt() {
        return CreateAt;
    }

    public void setCreateAt(Date CreateAt) {
        this.CreateAt = CreateAt;
    }

    public Date getUpdateAt() {
        return UpdateAt;
    }

    public void setUpdateAt(Date UpdateAt) {
        this.UpdateAt = UpdateAt;
    }

    public int getCreateBy() {
        return CreateBy;
    }

    public void setCreateBy(int CreateBy) {
        this.CreateBy = CreateBy;
    }

    public int getIsDelete() {
        return isDelete;
    }

    public void setIsDelete(int isDelete) {
        this.isDelete = isDelete;
    }

    public Date getDeletedAt() {
        return deletedAt;
    }

    public void setDeletedAt(Date deletedAt) {
        this.deletedAt = deletedAt;
    }

    public int getDeleteBy() {
        return deleteBy;
    }

    public void setDeleteBy(int deleteBy) {
        this.deleteBy = deleteBy;
    }

    
}
