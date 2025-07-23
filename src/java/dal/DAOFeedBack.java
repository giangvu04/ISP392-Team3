package dal;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import model.FeedBack;

public class DAOFeedBack {
    public static final DAOFeedBack INSTANCE = new DAOFeedBack();
    protected Connection connect;

    public DAOFeedBack() {
        connect = new DBContext().connect;
    }

    // Thêm feedback mới
    public void addFeedBack(FeedBack fb) {
        String sql = "INSERT INTO feedback (room_id, user_id, content, rating, created_at) VALUES (?, ?, ?, ?, ?)";
        try (PreparedStatement ps = connect.prepareStatement(sql)) {
            ps.setInt(1, fb.getRoomId());
            ps.setInt(2, fb.getUserId());
            ps.setString(3, fb.getContent());
            if (fb.getRating() != null) {
                ps.setInt(4, fb.getRating());
            } else {
                ps.setNull(4, java.sql.Types.INTEGER);
            }
            ps.setTimestamp(5, new Timestamp(System.currentTimeMillis()));
            ps.executeUpdate();
            System.out.println("✅ Thêm feedback thành công!");
        } catch (SQLException e) {
            System.err.println("❌ Lỗi thêm feedback: " + e.getMessage());
            e.printStackTrace();
        }
    }

    // Lấy tất cả feedback cho 1 phòng
    public ArrayList<FeedBack> getFeedBacksByRoom(int roomId) {
        ArrayList<FeedBack> list = new ArrayList<>();
        String sql = "SELECT * FROM feedback WHERE room_id = ? ORDER BY created_at DESC";
        try (PreparedStatement ps = connect.prepareStatement(sql)) {
            ps.setInt(1, roomId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                FeedBack fb = new FeedBack();
                fb.setFeedbackId(rs.getInt("feedback_id"));
                fb.setRoomId(rs.getInt("room_id"));
                fb.setUserId(rs.getInt("user_id"));
                fb.setContent(rs.getString("content"));
                fb.setRating((Integer)rs.getObject("rating"));
                fb.setCreatedAt(rs.getTimestamp("created_at"));
                list.add(fb);
            }
        } catch (SQLException e) {
            System.err.println("❌ Lỗi lấy feedback theo phòng: " + e.getMessage());
            e.printStackTrace();
        }
        return list;
    }

    // Lấy tất cả feedback của 1 user
    public ArrayList<FeedBack> getFeedBacksByUser(int userId) {
        ArrayList<FeedBack> list = new ArrayList<>();
        String sql = "SELECT * FROM feedback WHERE user_id = ? ORDER BY created_at DESC";
        try (PreparedStatement ps = connect.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                FeedBack fb = new FeedBack();
                fb.setFeedbackId(rs.getInt("feedback_id"));
                fb.setRoomId(rs.getInt("room_id"));
                fb.setUserId(rs.getInt("user_id"));
                fb.setContent(rs.getString("content"));
                fb.setRating((Integer)rs.getObject("rating"));
                fb.setCreatedAt(rs.getTimestamp("created_at"));
                list.add(fb);
            }
        } catch (SQLException e) {
            System.err.println("❌ Lỗi lấy feedback theo user: " + e.getMessage());
            e.printStackTrace();
        }
        return list;
    }

    // Xóa feedback theo id
    public void deleteFeedBack(int feedbackId) {
        String sql = "DELETE FROM feedback WHERE feedback_id = ?";
        try (PreparedStatement ps = connect.prepareStatement(sql)) {
            ps.setInt(1, feedbackId);
            ps.executeUpdate();
            System.out.println("✅ Xóa feedback thành công!");
        } catch (SQLException e) {
            System.err.println("❌ Lỗi xóa feedback: " + e.getMessage());
            e.printStackTrace();
        }
    }

    // Lấy feedback theo id
    public FeedBack getFeedBackById(int feedbackId) {
        String sql = "SELECT * FROM feedback WHERE feedback_id = ?";
        try (PreparedStatement ps = connect.prepareStatement(sql)) {
            ps.setInt(1, feedbackId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                FeedBack fb = new FeedBack();
                fb.setFeedbackId(rs.getInt("feedback_id"));
                fb.setRoomId(rs.getInt("room_id"));
                fb.setUserId(rs.getInt("user_id"));
                fb.setContent(rs.getString("content"));
                fb.setRating((Integer)rs.getObject("rating"));
                fb.setCreatedAt(rs.getTimestamp("created_at"));
                return fb;
            }
        } catch (SQLException e) {
            System.err.println("❌ Lỗi lấy feedback theo id: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }

    // Lấy tất cả feedback (quản lý)
    public ArrayList<FeedBack> getAllFeedBacks() {
        ArrayList<FeedBack> list = new ArrayList<>();
        String sql = "SELECT * FROM feedback ORDER BY created_at DESC";
        try (PreparedStatement ps = connect.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                FeedBack fb = new FeedBack();
                fb.setFeedbackId(rs.getInt("feedback_id"));
                fb.setRoomId(rs.getInt("room_id"));
                fb.setUserId(rs.getInt("user_id"));
                fb.setContent(rs.getString("content"));
                fb.setRating((Integer)rs.getObject("rating"));
                fb.setCreatedAt(rs.getTimestamp("created_at"));
                list.add(fb);
            }
        } catch (SQLException e) {
            System.err.println("❌ Lỗi lấy tất cả feedback: " + e.getMessage());
            e.printStackTrace();
        }
        return list;
    }

    // Cập nhật feedback
    public void updateFeedBack(FeedBack fb) {
        String sql = "UPDATE feedback SET content = ?, rating = ? WHERE feedback_id = ? AND user_id = ?";
        try (PreparedStatement ps = connect.prepareStatement(sql)) {
            ps.setString(1, fb.getContent());
            if (fb.getRating() != null) {
                ps.setInt(2, fb.getRating());
            } else {
                ps.setNull(2, java.sql.Types.INTEGER);
            }
            ps.setInt(3, fb.getFeedbackId());
            ps.setInt(4, fb.getUserId());
            int rowsAffected = ps.executeUpdate();
            if (rowsAffected > 0) {
                System.out.println("✅ Cập nhật feedback thành công!");
            } else {
                System.out.println("❌ Không tìm thấy feedback để cập nhật!");
            }
        } catch (SQLException e) {
            System.err.println("❌ Lỗi cập nhật feedback: " + e.getMessage());
            e.printStackTrace();
        }
    }
}
