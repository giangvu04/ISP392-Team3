package dal;

import java.sql.*;
import java.util.*;
import model.PostRoom;

public class DAOPostRoom {
    
    public static final DAOPostRoom INSTANCE = new DAOPostRoom();
    protected Connection connect;
    
    public DAOPostRoom() {
        connect = new DBContext().connect;
    }
    
    // Thêm phòng vào tin đăng
    public boolean addRoomToPost(int postId, int roomId) throws SQLException {
        String sql = "INSERT INTO post_rooms (post_id, room_id) VALUES (?, ?)";
        
        try (PreparedStatement ps = connect.prepareStatement(sql)) {
            ps.setInt(1, postId);
            ps.setInt(2, roomId);
            return ps.executeUpdate() > 0;
        }
    }
    
    // Xóa phòng khỏi tin đăng
    public boolean removeRoomFromPost(int postId, int roomId) throws SQLException {
        String sql = "DELETE FROM post_rooms WHERE post_id = ? AND room_id = ?";
        
        try (PreparedStatement ps = connect.prepareStatement(sql)) {
            ps.setInt(1, postId);
            ps.setInt(2, roomId);
            return ps.executeUpdate() > 0;
        }
    }
    
    // Lấy danh sách phòng của một tin đăng
    public List<PostRoom> getRoomsByPost(int postId) {
        List<PostRoom> rooms = new ArrayList<>();
        String sql = "SELECT pr.*, r.room_number, r.description, r.price, r.area, r.max_tenants, r.status " +
                    "FROM post_rooms pr " +
                    "JOIN rooms r ON pr.room_id = r.room_id " +
                    "WHERE pr.post_id = ?";
        
        try (PreparedStatement ps = connect.prepareStatement(sql)) {
            ps.setInt(1, postId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                PostRoom postRoom = new PostRoom();
                postRoom.setPostId(rs.getInt("post_id"));
                postRoom.setRoomId(rs.getInt("room_id"));
                postRoom.setRoomNumber(rs.getString("room_number"));
                postRoom.setRoomDescription(rs.getString("description"));
                postRoom.setRoomPrice(rs.getDouble("price"));
                postRoom.setRoomArea(rs.getDouble("area"));
                postRoom.setMaxTenants(rs.getInt("max_tenants"));
                postRoom.setRoomStatus(rs.getInt("status"));
                rooms.add(postRoom);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return rooms;
    }
    
    // Lấy danh sách tin đăng có chứa phòng cụ thể
    public List<Integer> getPostsByRoom(int roomId) {
        List<Integer> postIds = new ArrayList<>();
        String sql = "SELECT post_id FROM post_rooms WHERE room_id = ?";
        
        try (PreparedStatement ps = connect.prepareStatement(sql)) {
            ps.setInt(1, roomId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                postIds.add(rs.getInt("post_id"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return postIds;
    }
    
    // Xóa tất cả phòng khỏi tin đăng
    public boolean removeAllRoomsFromPost(int postId) throws SQLException {
        String sql = "DELETE FROM post_rooms WHERE post_id = ?";
        
        try (PreparedStatement ps = connect.prepareStatement(sql)) {
            ps.setInt(1, postId);
            return ps.executeUpdate() >= 0; // Có thể xóa 0 bản ghi (không có lỗi)
        }
    }
    
    // Thêm nhiều phòng vào tin đăng
    public boolean addRoomsToPost(int postId, List<Integer> roomIds) throws SQLException {
        String sql = "INSERT INTO post_rooms (post_id, room_id) VALUES (?, ?)";
        
        Connection conn = null;
        try {
            conn = connect;
            conn.setAutoCommit(false);
            
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                for (Integer roomId : roomIds) {
                    ps.setInt(1, postId);
                    ps.setInt(2, roomId);
                    ps.addBatch();
                }
                
                int[] results = ps.executeBatch();
                conn.commit();
                
                // Kiểm tra xem tất cả insert có thành công không
                for (int result : results) {
                    if (result <= 0) {
                        return false;
                    }
                }
                return true;
                
            } catch (SQLException e) {
                if (conn != null) {
                    conn.rollback();
                }
                throw e;
            } finally {
                if (conn != null) {
                    conn.setAutoCommit(true);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
}
