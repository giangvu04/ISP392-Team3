package dal;

import Const.ViewingRequestStatus;
import java.sql.*;
import java.util.*;
import model.ViewingRequest;

public class DAOViewingRequest extends DBContext {
    
    public static final DAOViewingRequest INSTANCE = new DAOViewingRequest();
    protected Connection connect;

    public DAOViewingRequest() {
        connect = new DBContext().connect;
    }
    // Thêm yêu cầu xem phòng mới với tenant_id
    public boolean addViewingRequest(int postId, int tenantId, String fullName, String phone, String email, 
                                   String message, Timestamp preferredDate) {
        String sql = "INSERT INTO viewing_requests (post_id, tenant_id, full_name, phone, email, message, preferred_date, status, created_at) " +
                    "VALUES (?, ?, ?, ?, ?, ?, ?, ?, GETDATE())";
        
        try (PreparedStatement ps = connect.prepareStatement(sql)) {
            
            ps.setInt(1, postId);
            ps.setInt(2, tenantId);
            ps.setString(3, fullName);
            ps.setString(4, phone);
            ps.setString(5, email);
            ps.setString(6, message);
            
            if (preferredDate != null) {
                ps.setTimestamp(7, preferredDate);
            } else {
                ps.setNull(7, Types.TIMESTAMP);
            }
            
            ps.setInt(8, ViewingRequestStatus.PENDING);
            
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            System.err.println("Database error in addViewingRequest: " + e.getMessage());
            return false;
        }
    }
    
    // Thêm yêu cầu xem phòng mới
    public boolean addViewingRequest(ViewingRequest request) throws SQLException {
        String sql = "INSERT INTO viewing_requests (post_id, tenant_id, requested_date, status, note) VALUES (?, ?, ?, ?, ?)";
        
        try (PreparedStatement ps = connect.prepareStatement(sql)) {
            ps.setInt(1, request.getPostId());
            ps.setInt(2, request.getTenantId());
            ps.setDate(3, new java.sql.Date(request.getRequestedDate().getTime()));
            ps.setInt(4, request.getStatus());
            ps.setString(5, request.getNote());
            return ps.executeUpdate() > 0;
        }
    }
    
    // Lấy yêu cầu xem phòng theo ID
    public ViewingRequest getViewingRequestById(int requestId) {
        String sql = "SELECT DISTINCT vr.*, rp.title as post_title, u.full_name as tenant_name, " +
                    "ra.name as rental_area_name, ra.address as rental_area_address " +
                    "FROM viewing_requests vr " +
                    "LEFT JOIN rental_posts rp ON vr.post_id = rp.post_id " +
                    "LEFT JOIN users u ON vr.tenant_id = u.user_id " +
                    "LEFT JOIN post_rooms pr ON pr.post_id = rp.post_id " +
                    "LEFT JOIN rooms r ON r.room_id = pr.room_id " +
                    "LEFT JOIN rental_areas ra ON r.rental_area_id = ra.rental_area_id " +
                    "WHERE vr.request_id = ?";
        
        try (PreparedStatement ps = connect.prepareStatement(sql)) {
            ps.setInt(1, requestId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                ViewingRequest request = mapResultSetToViewingRequest(rs);
                // Get room info for this post
                request.setRoomsInfo(getRoomInfoByPost(request.getPostId(), connect));
                return request;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    // Lấy danh sách yêu cầu theo tin đăng
    public List<ViewingRequest> getRequestsByPost(int postId) {
        List<ViewingRequest> requests = new ArrayList<>();
        String sql = "SELECT vr.*, rp.title as post_title, u.full_name as tenant_name " +
                    "FROM viewing_requests vr " +
                    "LEFT JOIN rental_posts rp ON vr.post_id = rp.post_id " +
                    "LEFT JOIN users u ON vr.tenant_id = u.user_id " +
                    "WHERE vr.post_id = ? " +
                    "ORDER BY vr.created_at DESC";
        
        try (PreparedStatement ps = connect.prepareStatement(sql)) {
            ps.setInt(1, postId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                requests.add(mapResultSetToViewingRequest(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return requests;
    }
    
    // Lấy danh sách yêu cầu theo tenant
    public List<ViewingRequest> getRequestsByTenant(int tenantId) {
        List<ViewingRequest> requests = new ArrayList<>();
        String sql = "SELECT DISTINCT vr.*, rp.title as post_title, u.full_name as tenant_name, " +
                    "ra.name as rental_area_name, ra.address as rental_area_address " +
                    "FROM viewing_requests vr " +
                    "LEFT JOIN rental_posts rp ON vr.post_id = rp.post_id " +
                    "LEFT JOIN users u ON vr.tenant_id = u.user_id " +
                    "LEFT JOIN post_rooms pr ON pr.post_id = rp.post_id " +
                    "LEFT JOIN rooms r ON r.room_id = pr.room_id " +
                    "LEFT JOIN rental_areas ra ON r.rental_area_id = ra.rental_area_id " +
                    "WHERE vr.tenant_id = ? " +
                    "ORDER BY vr.created_at DESC";
        
        try (PreparedStatement ps = connect.prepareStatement(sql)) {
            ps.setInt(1, tenantId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                ViewingRequest request = mapResultSetToViewingRequest(rs);
                // Get room info for this post separately
                request.setRoomsInfo(getRoomInfoByPost(request.getPostId(), connect));
                requests.add(request);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return requests;
    }
    
    // Helper method to get room info for a post
    private String getRoomInfoByPost(int postId, Connection conn) {
        StringBuilder roomInfo = new StringBuilder();
        String sql = "SELECT r.room_number, r.price FROM rooms r " +
                    "INNER JOIN post_rooms pr ON r.room_id = pr.room_id " +
                    "WHERE pr.post_id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, postId);
            ResultSet rs = ps.executeQuery();
            boolean first = true;
            while (rs.next()) {
                if (!first) {
                    roomInfo.append(", ");
                }
                roomInfo.append(rs.getString("room_number"))
                       .append(" (")
                       .append(rs.getDouble("price"))
                       .append(" VND)");
                first = false;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return roomInfo.toString();
    }
    
    // Lấy danh sách yêu cầu theo trạng thái
    public List<ViewingRequest> getRequestsByStatus(int status) {
        List<ViewingRequest> requests = new ArrayList<>();
        String sql = "SELECT vr.*, rp.title as post_title, u.full_name as tenant_name " +
                    "FROM viewing_requests vr " +
                    "LEFT JOIN rental_posts rp ON vr.post_id = rp.post_id " +
                    "LEFT JOIN users u ON vr.tenant_id = u.user_id " +
                    "WHERE vr.status = ? " +
                    "ORDER BY vr.created_at DESC";
        
        try (PreparedStatement ps = connect.prepareStatement(sql)) {
            ps.setInt(1, status);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                requests.add(mapResultSetToViewingRequest(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return requests;
    }
    
    // Lấy tất cả yêu cầu xem phòng với phân trang
    public List<ViewingRequest> getAllRequests(int page, int size) {
        List<ViewingRequest> requests = new ArrayList<>();
        String sql = "SELECT vr.*, rp.title as post_title, u.full_name as tenant_name " +
                    "FROM viewing_requests vr " +
                    "LEFT JOIN rental_posts rp ON vr.post_id = rp.post_id " +
                    "LEFT JOIN users u ON vr.tenant_id = u.user_id " +
                    "ORDER BY vr.created_at DESC " +
                    "OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
        
        try (PreparedStatement ps = connect.prepareStatement(sql)) {
            ps.setInt(1, (page - 1) * size);
            ps.setInt(2, size);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                requests.add(mapResultSetToViewingRequest(rs));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return requests;
    }
    
    // Đếm tổng số yêu cầu
    public int getTotalRequests() {
        String sql = "SELECT COUNT(*) FROM viewing_requests";
        try (PreparedStatement ps = connect.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
    
    // Kiểm tra xem tenant đã có yêu cầu xem tin đăng này chưa
    public boolean hasExistingRequest(int postId, int tenantId) {
        String sql = "SELECT COUNT(*) FROM viewing_requests WHERE post_id = ? AND tenant_id = ? AND status IN (?, ?)";
        try (PreparedStatement ps = connect.prepareStatement(sql)) {
            ps.setInt(1, postId);
            ps.setInt(2, tenantId);
            ps.setInt(3, ViewingRequestStatus.PENDING);
            ps.setInt(4, ViewingRequestStatus.VIEWED);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    // Cập nhật trạng thái và ghi chú admin
    public boolean updateRequestStatus(int requestId, int status, String adminNote) {
        String sql = "UPDATE viewing_requests SET status = ?, admin_note = ?, response_date = GETDATE() WHERE request_id = ?";
        try (PreparedStatement ps = connect.prepareStatement(sql)) {
            ps.setInt(1, status);
            ps.setString(2, adminNote);
            ps.setInt(3, requestId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    // Cập nhật chỉ trạng thái
    public boolean updateRequestStatus(int requestId, int status) {
        String sql = "UPDATE viewing_requests SET status = ?, response_date = GETDATE() WHERE request_id = ?";
        try (PreparedStatement ps = connect.prepareStatement(sql)) {
            ps.setInt(1, status);
            ps.setInt(2, requestId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    // Xóa yêu cầu xem phòng
    public boolean deleteViewingRequest(int requestId) throws SQLException {
        String sql = "DELETE FROM viewing_requests WHERE request_id = ?";
        
        try (PreparedStatement ps = connect.prepareStatement(sql)) {
            ps.setInt(1, requestId);
            return ps.executeUpdate() > 0;
        }
    }
    
    // Hàm helper để map ResultSet thành ViewingRequest object
    private ViewingRequest mapResultSetToViewingRequest(ResultSet rs) throws SQLException {
        ViewingRequest request = new ViewingRequest();
        request.setRequestId(rs.getInt("request_id"));
        request.setPostId(rs.getInt("post_id"));
        
        // Kiểm tra tenant_id có null không
        int tenantId = rs.getInt("tenant_id");
        if (!rs.wasNull()) {
            request.setTenantId(tenantId);
        }
        
        // Map theo đúng tên cột trong database
        request.setFullName(rs.getString("full_name"));
        request.setPhone(rs.getString("phone"));
        request.setEmail(rs.getString("email"));
        request.setMessage(rs.getString("message"));
        request.setPreferredDate(rs.getTimestamp("preferred_date"));
        request.setStatus(rs.getInt("status"));
        request.setCreatedAt(rs.getTimestamp("created_at"));
        request.setAdminNote(rs.getString("admin_note"));
        request.setResponseDate(rs.getTimestamp("response_date"));
        
        // isRead logic based on status - if not PENDING (0) then considered read
        request.setIsRead(request.getStatus() != 0);
        
        // JOIN fields (có thể null)
        try {
            request.setPostTitle(rs.getString("post_title"));
        } catch (SQLException e) {
            // Cột không tồn tại trong query
        }
        
        try {
            request.setTenantName(rs.getString("tenant_name"));
        } catch (SQLException e) {
            // Cột không tồn tại trong query  
        }
        
        // Room information fields
        try {
            request.setRoomsInfo(rs.getString("rooms_info"));
            request.setRentalAreaName(rs.getString("rental_area_name"));
            request.setRentalAreaAddress(rs.getString("rental_area_address"));
        } catch (SQLException e) {
            // Cột không tồn tại trong query
        }
        
        return request;
    }
    
    // Lấy tất cả yêu cầu cho manager
    public List<ViewingRequest> getAllViewingRequestsForManager() {
        List<ViewingRequest> requests = new ArrayList<>();
        String sql = "SELECT DISTINCT vr.*, rp.title as post_title, u.full_name as tenant_name, " +
                    "ra.name as rental_area_name, ra.address as rental_area_address " +
                    "FROM viewing_requests vr " +
                    "LEFT JOIN rental_posts rp ON vr.post_id = rp.post_id " +
                    "LEFT JOIN users u ON vr.tenant_id = u.user_id " +
                    "LEFT JOIN post_rooms pr ON pr.post_id = rp.post_id " +
                    "LEFT JOIN rooms r ON r.room_id = pr.room_id " +
                    "LEFT JOIN rental_areas ra ON r.rental_area_id = ra.rental_area_id " +
                    "ORDER BY vr.created_at DESC";
        
        try (PreparedStatement ps = connect.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                ViewingRequest request = mapResultSetToViewingRequest(rs);
                // Get room info for this post
                request.setRoomsInfo(getRoomInfoByPost(request.getPostId(), connect));
                // Set isRead based on status logic - pending = unread, others = read
                request.setIsRead(request.getStatus() != 0);
                requests.add(request);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return requests;
    }

    // Cập nhật trạng thái yêu cầu (cho manager)
    public boolean updateViewingRequestStatus(int requestId, int status, String adminNote) {
        String sql = "UPDATE viewing_requests SET status = ?, admin_note = ?, response_date = GETDATE() WHERE request_id = ?";
        
        try (PreparedStatement ps = connect.prepareStatement(sql)) {
            ps.setInt(1, status);
            ps.setString(2, adminNote);
            ps.setInt(3, requestId);
            
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            System.err.println("Database error in updateViewingRequestStatus: " + e.getMessage());
            return false;
        }
    }

    // Đánh dấu yêu cầu đã đọc (thay đổi status từ PENDING sang VIEWED)
    public boolean markAsRead(int requestId) {
        String sql = "UPDATE viewing_requests SET status = ?, response_date = GETDATE() WHERE request_id = ? AND status = 0";
        
        try (PreparedStatement ps = connect.prepareStatement(sql)) {
            ps.setInt(1, ViewingRequestStatus.VIEWED); // Chuyển sang VIEWED (1)
            ps.setInt(2, requestId);
            
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;
            
        } catch (SQLException e) {
            System.err.println("Database error in markAsRead: " + e.getMessage());
            return false;
        }
    }

    // Lấy số lượt xem của một bài đăng
    public int getViewCountByPost(int postId) throws SQLException {
        String sql = "SELECT COUNT(*) as view_count FROM viewing_requests WHERE post_id = ?";
        
        try (PreparedStatement ps = connect.prepareStatement(sql)) {
            ps.setInt(1, postId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt("view_count");
            }
        }
        return 0;
    }
}
