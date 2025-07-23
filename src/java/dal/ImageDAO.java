package dal;

import model.Users;
import model.Role;
import java.sql.Connection;
import java.sql.Timestamp;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.Image;

public class ImageDAO {

    public static final ImageDAO INSTANCE = new ImageDAO();
    protected Connection connect;

    public ImageDAO() {
        connect = new DBContext().connect;
    }

    public static long millis = System.currentTimeMillis();
    public static Timestamp today = new Timestamp(millis);
    public List<Image> getImagesByHouse(int rentalId) {
        List<Image> images = new ArrayList<>();
        String sql = "SELECT * FROM Images WHERE rentalId = ?";
        try (PreparedStatement ps = connect.prepareStatement(sql)) {
            ps.setInt(1, rentalId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Image image = new Image();
                image.setImageId(rs.getInt("imageId"));
                image.setRoomId(rs.getInt("roomId"));
                image.setRentalId(rs.getInt("rentalId"));
                image.setUrlImage(rs.getString("url_image"));
                images.add(image);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return images;
    }

    public List<Image> getImagesByRoom(int roomId) {
        List<Image> images = new ArrayList<>();
        String sql = "SELECT * FROM Images WHERE roomId = ?";
        try (PreparedStatement ps = connect.prepareStatement(sql)) {
            ps.setInt(1, roomId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Image image = new Image();
                image.setImageId(rs.getInt("imageId"));
                image.setRoomId(rs.getInt("roomId"));
                image.setRentalId(rs.getInt("rentalId"));
                image.setUrlImage(rs.getString("url_image"));
                images.add(image);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return images;
    }

    public boolean addImage(Image image) {
        String sql = "INSERT INTO Images (roomId, rentalId, url_image) VALUES (?, ?, ?)";
        try (PreparedStatement ps = connect.prepareStatement(sql)) {
            if (image.getRoomId()!=0) {
                ps.setInt(1, image.getRoomId());
            } else {
                ps.setNull(1, java.sql.Types.INTEGER);
            }
            if (image.getRentalId() != 0) {
                ps.setInt(2, image.getRentalId());
            } else {
                ps.setNull(2, java.sql.Types.INTEGER);
            }
            ps.setString(3, image.getUrlImage());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    // Phương thức getImageById
    public Image getImageById(int imageId) {
        String sql = "SELECT * FROM Images WHERE imageId = ?";
        try (PreparedStatement pstmt = connect.prepareStatement(sql)) {
            pstmt.setInt(1, imageId);
            ResultSet rs = pstmt.executeQuery();
            if (rs.next()) {
                Image image = new Image();
                image.setImageId(rs.getInt("imageId"));
                image.setRentalId(rs.getInt("rentalId"));
                image.setRoomId(rs.getInt("roomId"));
                image.setUrlImage(rs.getString("url_image"));
                return image;
            }
        } catch (SQLException e) {
            System.out.println("Lỗi khi lấy ảnh theo ID: " + e.getMessage());
        }
        return null;
    }

    // Phương thức deleteImage
    public boolean deleteImage(int imageId) {
        String sql = "DELETE FROM Images WHERE imageId = ?";
        try (PreparedStatement pstmt = connect.prepareStatement(sql)) {
            pstmt.setInt(1, imageId);
            int rowsAffected = pstmt.executeUpdate();
            return rowsAffected > 0;
        } catch (SQLException e) {
            System.out.println("Lỗi khi xóa ảnh: " + e.getMessage());
        }
        return false;
    }
    
}
