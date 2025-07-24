package dal;

import java.sql.*;
import java.util.*;
import model.Message;

public class DAOMessage extends DBContext {
    public static final DAOMessage INSTANCE = new DAOMessage();
    protected Connection connect;

    public DAOMessage() {
        connect = new DBContext().connect;
    }

    // Thêm message mới
    public boolean addMessage(Message message) {
        String sql = "INSERT INTO messages (user_id, bill_id, maintenance_id, type, content, created_at) " +
                     "VALUES (?, ?, ?, ?, ?, ?)";
        
        try (PreparedStatement ps = connect.prepareStatement(sql)) {
            
            ps.setInt(1, message.getUserId());
            
            if (message.getBillId() != null) {
                ps.setInt(2, message.getBillId());
            } else {
                ps.setNull(2, Types.INTEGER);
            }
            
            if (message.getMaintenanceId() != null) {
                ps.setInt(3, message.getMaintenanceId());
            } else {
                ps.setNull(3, Types.INTEGER);
            }
            
            ps.setString(4, message.getType());
            ps.setString(5, message.getContent());
            ps.setTimestamp(6, message.getCreatedAt());
            
            int result = ps.executeUpdate();
            return result > 0;
            
        } catch (SQLException e) {
            System.err.println("Error adding message: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    // Lấy tất cả messages với thông tin user
    public List<Message> getAllMessagesWithUserInfo() {
        List<Message> messages = new ArrayList<>();
        String sql = "SELECT m.message_id, m.user_id, u.full_name as user_name, " +
                     "m.bill_id, m.maintenance_id, m.type, m.content, m.created_at " +
                     "FROM messages m " +
                     "LEFT JOIN users u ON m.user_id = u.user_id " +
                     "ORDER BY m.created_at DESC";
        
        try (PreparedStatement ps = connect.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                Message message = new Message();
                message.setMessageId(rs.getInt("message_id"));
                message.setUserId(rs.getInt("user_id"));
                message.setUserName(rs.getString("user_name"));
                message.setBillId(rs.getObject("bill_id") != null ? rs.getInt("bill_id") : null);
                message.setMaintenanceId(rs.getObject("maintenance_id") != null ? rs.getInt("maintenance_id") : null);
                message.setType(rs.getString("type"));
                message.setContent(rs.getString("content"));
                message.setCreatedAt(rs.getTimestamp("created_at"));
                
                messages.add(message);
            }
            
        } catch (SQLException e) {
            System.err.println("Error getting messages: " + e.getMessage());
            e.printStackTrace();
        }
        
        return messages;
    }
    
    // Lấy messages theo type
    public List<Message> getMessagesByType(String type) {
        List<Message> messages = new ArrayList<>();
        String sql = "SELECT m.message_id, m.user_id, u.full_name as user_name, " +
                     "m.bill_id, m.maintenance_id, m.type, m.content, m.created_at " +
                     "FROM messages m " +
                     "LEFT JOIN users u ON m.user_id = u.user_id " +
                     "WHERE m.type = ? " +
                     "ORDER BY m.created_at DESC";
        
        try (PreparedStatement ps = connect.prepareStatement(sql)) {
            
            ps.setString(1, type);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Message message = new Message();
                    message.setMessageId(rs.getInt("message_id"));
                    message.setUserId(rs.getInt("user_id"));
                    message.setUserName(rs.getString("user_name"));
                    message.setBillId(rs.getObject("bill_id") != null ? rs.getInt("bill_id") : null);
                    message.setMaintenanceId(rs.getObject("maintenance_id") != null ? rs.getInt("maintenance_id") : null);
                    message.setType(rs.getString("type"));
                    message.setContent(rs.getString("content"));
                    message.setCreatedAt(rs.getTimestamp("created_at"));
                    
                    messages.add(message);
                }
            }
            
        } catch (SQLException e) {
            System.err.println("Error getting messages by type: " + e.getMessage());
            e.printStackTrace();
        }
        
        return messages;
    }
    
    // Lấy messages theo user
    public List<Message> getMessagesByUserId(int userId) {
        List<Message> messages = new ArrayList<>();
        String sql = "SELECT m.message_id, m.user_id, u.full_name as user_name, " +
                     "m.bill_id, m.maintenance_id, m.type, m.content, m.created_at " +
                     "FROM messages m " +
                     "LEFT JOIN users u ON m.user_id = u.user_id " +
                     "WHERE m.user_id = ? " +
                     "ORDER BY m.created_at DESC";
        
        try (PreparedStatement ps = connect.prepareStatement(sql)) {
            
            ps.setInt(1, userId);
            
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Message message = new Message();
                    message.setMessageId(rs.getInt("message_id"));
                    message.setUserId(rs.getInt("user_id"));
                    message.setUserName(rs.getString("user_name"));
                    message.setBillId(rs.getObject("bill_id") != null ? rs.getInt("bill_id") : null);
                    message.setMaintenanceId(rs.getObject("maintenance_id") != null ? rs.getInt("maintenance_id") : null);
                    message.setType(rs.getString("type"));
                    message.setContent(rs.getString("content"));
                    message.setCreatedAt(rs.getTimestamp("created_at"));
                    
                    messages.add(message);
                }
            }
            
        } catch (SQLException e) {
            System.err.println("Error getting messages by user: " + e.getMessage());
            e.printStackTrace();
        }
        
        return messages;
    }
}
