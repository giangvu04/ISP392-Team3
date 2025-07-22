package dal;

import java.sql.*;
import java.util.*;
import model.RentalPost;

public class DAORentalPost {
    
    public static final DAORentalPost INSTANCE = new DAORentalPost();
    protected Connection connect;
    
    public DAORentalPost() {
        connect = new DBContext().connect;
    }
    
    // Lấy tất cả tin đăng active với thông tin chi tiết
    public List<RentalPost> getAllActivePosts() {
        List<RentalPost> posts = new ArrayList<>();
        String sql = "SELECT rp.*, u.full_name AS manager_name, ra.name AS rental_area_name, ra.address AS rental_area_address " +
                    "FROM rental_posts rp " +
                    "JOIN users u ON rp.manager_id = u.user_id " +
                    "JOIN rental_areas ra ON rp.rental_area_id = ra.rental_area_id " +
                    "WHERE rp.is_active = 1 " +
                    "ORDER BY rp.is_featured DESC, rp.created_at DESC";
        
        try (PreparedStatement ps = connect.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                RentalPost post = extractRentalPost(rs);
                posts.add(post);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return posts;
    }
    
    // Lấy tin đăng theo ID
    public RentalPost getPostById(int postId) {
        String sql = "SELECT rp.*, u.full_name AS manager_name, ra.name AS rental_area_name, ra.address AS rental_area_address " +
                    "FROM rental_posts rp " +
                    "JOIN users u ON rp.manager_id = u.user_id " +
                    "JOIN rental_areas ra ON rp.rental_area_id = ra.rental_area_id " +
                    "WHERE rp.post_id = ?";
        
        try (PreparedStatement ps = connect.prepareStatement(sql)) {
            ps.setInt(1, postId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return extractRentalPost(rs);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    // Lấy tin đăng theo manager
    public List<RentalPost> getPostsByManager(int managerId) {
        List<RentalPost> posts = new ArrayList<>();
        String sql = "SELECT rp.*, u.full_name AS manager_name, ra.name AS rental_area_name, ra.address AS rental_area_address " +
                    "FROM rental_posts rp " +
                    "JOIN users u ON rp.manager_id = u.user_id " +
                    "JOIN rental_areas ra ON rp.rental_area_id = ra.rental_area_id " +
                    "WHERE rp.manager_id = ? " +
                    "ORDER BY rp.created_at DESC";
        
        try (PreparedStatement ps = connect.prepareStatement(sql)) {
            ps.setInt(1, managerId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                RentalPost post = extractRentalPost(rs);
                posts.add(post);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return posts;
    }
    
    // Thêm tin đăng mới
    public int addRentalPost(RentalPost post) throws SQLException {
        String sql = "INSERT INTO rental_posts (manager_id, rental_area_id, title, description, contact_info, featured_image, is_featured, is_active, views_count, created_at, updated_at) " +
                    "VALUES (?, ?, ?, ?, ?, ?, ?, ?, 0, GETDATE(), GETDATE())";
        
        try (PreparedStatement ps = connect.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, post.getManagerId());
            ps.setInt(2, post.getRentalAreaId());
            ps.setString(3, post.getTitle());
            ps.setString(4, post.getDescription());
            ps.setString(5, post.getContactInfo());
            ps.setString(6, post.getFeaturedImage());
            ps.setBoolean(7, post.isFeatured());
            ps.setBoolean(8, post.isActive());
            
            int rowsAffected = ps.executeUpdate();
            if (rowsAffected > 0) {
                ResultSet generatedKeys = ps.getGeneratedKeys();
                if (generatedKeys.next()) {
                    return generatedKeys.getInt(1);
                }
            }
        }
        return -1;
    }
    
    // Cập nhật tin đăng
    public boolean updateRentalPost(RentalPost post) throws SQLException {
        String sql = "UPDATE rental_posts SET title = ?, description = ?, contact_info = ?, featured_image = ?, is_featured = ?, is_active = ?, updated_at = GETDATE() " +
                    "WHERE post_id = ?";
        
        try (PreparedStatement ps = connect.prepareStatement(sql)) {
            ps.setString(1, post.getTitle());
            ps.setString(2, post.getDescription());
            ps.setString(3, post.getContactInfo());
            ps.setString(4, post.getFeaturedImage());
            ps.setBoolean(5, post.isFeatured());
            ps.setBoolean(6, post.isActive());
            ps.setInt(7, post.getPostId());
            
            return ps.executeUpdate() > 0;
        }
    }
    
    // Tăng lượt xem
    public void incrementViews(int postId) {
        String sql = "UPDATE rental_posts SET views_count = views_count + 1 WHERE post_id = ?";
        
        try (PreparedStatement ps = connect.prepareStatement(sql)) {
            ps.setInt(1, postId);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    
    // Tìm kiếm tin đăng theo từ khóa và vị trí
    public List<RentalPost> searchPosts(String keyword, String province, String district, String ward) {
        List<RentalPost> posts = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
            "SELECT rp.*, u.full_name AS manager_name, u.phone_number AS manager_phone, u.email AS manager_email, " +
            "ra.name AS rental_area_name, ra.address AS rental_area_address, " +
            "r.price AS room_price, r.room_number " +
            "FROM rental_posts rp " +
            "JOIN users u ON rp.manager_id = u.user_id " +
            "JOIN rental_areas ra ON rp.rental_area_id = ra.rental_area_id " +
            "LEFT JOIN post_rooms pr ON rp.post_id = pr.post_id " +
            "LEFT JOIN rooms r ON pr.room_id = r.room_id " +
            "WHERE rp.is_active = 1"
        );
        
        List<Object> params = new ArrayList<>();
        
        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append(" AND (rp.title LIKE ? OR rp.description LIKE ? OR ra.name LIKE ?)");
            String searchPattern = "%" + keyword.trim() + "%";
            params.add(searchPattern);
            params.add(searchPattern);
            params.add(searchPattern);
        }
        
        if (province != null && !province.trim().isEmpty()) {
            sql.append(" AND ra.province LIKE ?");
            params.add("%" + province + "%");
        }
        
        if (district != null && !district.trim().isEmpty()) {
            sql.append(" AND ra.district LIKE ?");
            params.add("%" + district + "%");
        }
        
        if (ward != null && !ward.trim().isEmpty()) {
            sql.append(" AND ra.ward LIKE ?");
            params.add("%" + ward + "%");
        }
        
        sql.append(" ORDER BY rp.is_featured DESC, rp.created_at DESC");
        
        try (PreparedStatement ps = connect.prepareStatement(sql.toString())) {
            
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                RentalPost post = extractRentalPost(rs);
                posts.add(post);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return posts;
    }
    
    // Helper method để extract RentalPost từ ResultSet
    private RentalPost extractRentalPost(ResultSet rs) throws SQLException {
        RentalPost post = new RentalPost();
        post.setPostId(rs.getInt("post_id"));
        post.setManagerId(rs.getInt("manager_id"));
        post.setRentalAreaId(rs.getInt("rental_area_id"));
        post.setTitle(rs.getString("title"));
        post.setDescription(rs.getString("description"));
        post.setContactInfo(rs.getString("contact_info"));
        post.setFeaturedImage(rs.getString("featured_image"));
        post.setFeatured(rs.getBoolean("is_featured"));
        post.setActive(rs.getBoolean("is_active"));
        post.setViewsCount(rs.getInt("views_count"));
        post.setCreatedAt(rs.getTimestamp("created_at"));
        post.setUpdatedAt(rs.getTimestamp("updated_at"));
        
        // Set additional fields from JOIN
        post.setManagerName(rs.getString("manager_name"));
        post.setRentalAreaName(rs.getString("rental_area_name"));
        post.setRentalAreaAddress(rs.getString("rental_area_address"));
        
        // Set manager contact info if available
        try {
            post.setManagerPhone(rs.getString("manager_phone"));
            post.setManagerEmail(rs.getString("manager_email"));
        } catch (SQLException e) {
            // Fields may not be available in all queries
        }
        
        // Set room info if available
        try {
            post.setRoomPrice(rs.getDouble("room_price"));
            post.setRoomNumber(rs.getString("room_number"));
        } catch (SQLException e) {
            // Fields may not be available in all queries
        }
        
        return post;
    }
    
    // Lấy tất cả tin đăng (cho admin)
    public List<RentalPost> getAllRentalPosts() {
        List<RentalPost> posts = new ArrayList<>();
        String sql = "SELECT rp.*, u.full_name AS manager_name, ra.name AS rental_area_name, ra.address AS rental_area_address " +
                    "FROM rental_posts rp " +
                    "JOIN users u ON rp.manager_id = u.user_id " +
                    "JOIN rental_areas ra ON rp.rental_area_id = ra.rental_area_id " +
                    "ORDER BY rp.created_at DESC";
        
        try (PreparedStatement ps = connect.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                RentalPost post = extractRentalPost(rs);
                posts.add(post);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return posts;
    }
    
    // Lấy tin đăng theo manager
    public List<RentalPost> getRentalPostsByManager(int managerId) {
        List<RentalPost> posts = new ArrayList<>();
        String sql = "SELECT rp.*, u.full_name AS manager_name, ra.name AS rental_area_name, ra.address AS rental_area_address " +
                    "FROM rental_posts rp " +
                    "JOIN users u ON rp.manager_id = u.user_id " +
                    "JOIN rental_areas ra ON rp.rental_area_id = ra.rental_area_id " +
                    "WHERE rp.manager_id = ? " +
                    "ORDER BY rp.created_at DESC";
        
        try (PreparedStatement ps = connect.prepareStatement(sql)) {
            ps.setInt(1, managerId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                RentalPost post = extractRentalPost(rs);
                posts.add(post);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return posts;
    }
    
    // Search rental posts with filters
    public List<RentalPost> searchRentalPosts(String searchQuery, int areaId, String status, int managerId) {
        List<RentalPost> posts = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
            "SELECT rp.*, u.full_name AS manager_name, ra.name AS rental_area_name, ra.address AS rental_area_address " +
            "FROM rental_posts rp " +
            "JOIN users u ON rp.manager_id = u.user_id " +
            "JOIN rental_areas ra ON rp.rental_area_id = ra.rental_area_id " +
            "WHERE 1=1 ");
        
        List<Object> params = new ArrayList<>();
        
        // Manager filter (0 means all for admin)
        if (managerId > 0) {
            sql.append("AND rp.manager_id = ? ");
            params.add(managerId);
        }
        
        // Search query filter
        if (searchQuery != null && !searchQuery.trim().isEmpty()) {
            sql.append("AND (rp.title LIKE ? OR rp.description LIKE ?) ");
            String searchPattern = "%" + searchQuery.trim() + "%";
            params.add(searchPattern);
            params.add(searchPattern);
        }
        
        // Area filter
        if (areaId > 0) {
            sql.append("AND rp.rental_area_id = ? ");
            params.add(areaId);
        }
        
        // Status filter
        if (status != null && !status.trim().isEmpty()) {
            if ("active".equals(status)) {
                sql.append("AND rp.is_active = 1 ");
            } else if ("inactive".equals(status)) {
                sql.append("AND rp.is_active = 0 ");
            }
        }
        
        sql.append("ORDER BY rp.is_featured DESC, rp.created_at DESC");
        
        try (PreparedStatement ps = connect.prepareStatement(sql.toString())) {
            
            // Set parameters
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                RentalPost post = extractRentalPost(rs);
                posts.add(post);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return posts;
    }
    
    // Lấy tin đăng theo ID
    public RentalPost getRentalPostById(int postId) {
        return getPostById(postId);
    }
    
    // Toggle trạng thái active/inactive
    public boolean togglePostStatus(int postId) {
        String sql = "UPDATE rental_posts SET is_active = CASE WHEN is_active = 1 THEN 0 ELSE 1 END WHERE post_id = ?";
        
        try (PreparedStatement ps = connect.prepareStatement(sql)) {
            ps.setInt(1, postId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    // Toggle trạng thái featured
    public boolean togglePostFeatured(int postId) {
        String sql = "UPDATE rental_posts SET is_featured = CASE WHEN is_featured = 1 THEN 0 ELSE 1 END WHERE post_id = ?";
        
        try (PreparedStatement ps = connect.prepareStatement(sql)) {
            ps.setInt(1, postId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    // Xóa tin đăng
    public boolean deleteRentalPost(int postId) {
        String sql = "DELETE FROM rental_posts WHERE post_id = ?";
        
        try (PreparedStatement ps = connect.prepareStatement(sql)) {
            ps.setInt(1, postId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    // Lấy top posts có view cao nhất trong tháng
    public List<RentalPost> getTopViewedPostsThisMonth(int limit) {
        List<RentalPost> posts = new ArrayList<>();
        String sql = "SELECT TOP (?) rp.*, u.full_name AS manager_name, u.phone_number AS manager_phone, u.email AS manager_email, " +
                    "ra.name AS rental_area_name, ra.address AS rental_area_address, " +
                    "r.price AS room_price, r.room_number " +
                    "FROM rental_posts rp " +
                    "JOIN users u ON rp.manager_id = u.user_id " +
                    "JOIN rental_areas ra ON rp.rental_area_id = ra.rental_area_id " +
                    "LEFT JOIN post_rooms pr ON rp.post_id = pr.post_id " +
                    "LEFT JOIN rooms r ON pr.room_id = r.room_id " +
                    "WHERE rp.is_active = 1 " +
                    "AND MONTH(rp.created_at) = MONTH(GETDATE()) " +
                    "AND YEAR(rp.created_at) = YEAR(GETDATE()) " +
                    "ORDER BY rp.views_count DESC";
        
        try (PreparedStatement ps = connect.prepareStatement(sql)) {
            ps.setInt(1, limit);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                RentalPost post = extractRentalPost(rs);
                posts.add(post);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return posts;
    }
    
    // Lấy posts mới nhất
    public List<RentalPost> getRecentPosts(int limit) {
        List<RentalPost> posts = new ArrayList<>();
        String sql = "SELECT TOP (?) rp.*, u.full_name AS manager_name, u.phone_number AS manager_phone, u.email AS manager_email, " +
                    "ra.name AS rental_area_name, ra.address AS rental_area_address, " +
                    "r.price AS room_price, r.room_number " +
                    "FROM rental_posts rp " +
                    "JOIN users u ON rp.manager_id = u.user_id " +
                    "JOIN rental_areas ra ON rp.rental_area_id = ra.rental_area_id " +
                    "LEFT JOIN post_rooms pr ON rp.post_id = pr.post_id " +
                    "LEFT JOIN rooms r ON pr.room_id = r.room_id " +
                    "WHERE rp.is_active = 1 " +
                    "ORDER BY rp.created_at DESC";
        
        try (PreparedStatement ps = connect.prepareStatement(sql)) {
            ps.setInt(1, limit);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                RentalPost post = extractRentalPost(rs);
                posts.add(post);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return posts;
    }
    
    // Tăng view count cho tin đăng
    public void incrementViewCount(int postId) {
        String sql = "UPDATE rental_posts SET views_count = views_count + 1 WHERE post_id = ?";
        try (PreparedStatement ps = connect.prepareStatement(sql)) {
            ps.setInt(1, postId);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
