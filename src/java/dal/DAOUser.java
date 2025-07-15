
package dal;

import Const.ContractStatus;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import model.Role;
import model.Users;

public class DAOUser {

    public static final DAOUser INSTANCE = new DAOUser();
    protected Connection connect;

    public DAOUser() {
        connect = new DBContext().connect;
    }

    public static long millis = System.currentTimeMillis();
    public static Timestamp today = new Timestamp(millis);
    // Cập nhật mật khẩu cho user theo userId
    public void updateUserPassword(Users user) {
        String sql = "UPDATE users SET password_hash = ?, updated_at = ? WHERE user_id = ?";
        try (PreparedStatement ps = connect.prepareStatement(sql)) {
            ps.setString(1, user.getPasswordHash());
            ps.setTimestamp(2, today);
            ps.setInt(3, user.getUserId());
            ps.executeUpdate();
            System.out.println("✅ Đổi mật khẩu thành công!");
        } catch (SQLException e) {
            System.err.println("❌ Lỗi đổi mật khẩu: " + e.getMessage());
            e.printStackTrace();
        }
    }
        // Lấy danh sách người thuê theo roomId
    public ArrayList<Users> getTenantsByRoomId(int roomId) {
        ArrayList<Users> tenants = new ArrayList<>();
        String sql = "SELECT u.* FROM users u " +
                     "JOIN contracts c ON u.user_id = c.tenant_id " +
                     "WHERE c.room_id = ? AND u.role_id = 3 AND c.status = 1";
        try (PreparedStatement ps = connect.prepareStatement(sql)) {
            ps.setInt(1, roomId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Users u = new Users();
                u.setUserId(rs.getInt("user_id"));
                u.setRoleId(rs.getInt("role_id"));
                u.setFullName(rs.getString("full_name"));
                u.setPhoneNumber(rs.getString("phone_number"));
                u.setEmail(rs.getString("email"));
                u.setPasswordHash(rs.getString("password_hash"));
                u.setCitizenId(rs.getString("citizen_id"));
                u.setAddress(rs.getString("address"));
                u.setActive(rs.getBoolean("is_active"));
                u.setCreatedAt(rs.getTimestamp("created_at"));
                u.setUpdatedAt(rs.getTimestamp("updated_at"));
                tenants.add(u);
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error fetching tenants by roomId: " + e.getMessage(), e);
        }
        return tenants;
    }



    public boolean authenticateUser(String username, String password) throws Exception {
        Users user = getUserByEmail(username);
        if (user == null) {
            user = getUserByPhone(username);
        }
        if (user != null) {
            return password.equals(user.getPasswordHash());
        }
        return false;
    }
        // Kích hoạt hợp đồng (từ trạng thái 3 -> 1) khi xác nhận lời mời
    public boolean activateContract(int userId, int roomId) {
        String sql = "UPDATE contracts SET status = 1 WHERE tenant_id = ? AND room_id = ? AND status = 3";
        try (PreparedStatement ps = connect.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ps.setInt(2, roomId);
            int affected = ps.executeUpdate();
            return affected > 0;
        } catch (SQLException e) {
            System.err.println("❌ Lỗi activateContract: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }
        // Tạo hợp đồng trạng thái 3 (lời mời) cho userId/email và roomId
    public boolean createInviteContract(Integer userId, String email, int roomId, java.math.BigDecimal price, java.math.BigDecimal deposit, java.sql.Date endDate) {
        String sql = "INSERT INTO contracts (room_id, tenant_id, start_date, end_date, rent_price, deposit_amount, status, note) "
                + "VALUES (?, ?, GETDATE(), ?, ?, ?, ?, ?)";
        try (PreparedStatement ps = connect.prepareStatement(sql)) {
            ps.setInt(1, roomId);
            if (userId != null) {
                ps.setInt(2, userId);
            } else {
                ps.setNull(2, java.sql.Types.INTEGER);
            }
            ps.setDate(3, endDate);
            ps.setBigDecimal(4, price);
            ps.setBigDecimal(5, deposit);
            ps.setInt(6, ContractStatus.LOI_MOI);
            if (userId != null) {
                ps.setString(7, "Lời mời gửi tới userId=" + userId);
            } else {
                ps.setString(7, "Lời mời gửi tới email=" + email);
            }
            int affected = ps.executeUpdate();
            return affected > 0;
        } catch (Exception e) {
            System.err.println("❌ Lỗi createInviteContract: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

        // Tìm user theo email gần đúng, trả về tối đa limit user
    public ArrayList<Users> searchUsersByEmail(String email, int limit) {
        ArrayList<Users> users = new ArrayList<>();
        String sql = "SELECT TOP " + limit + " user_id, full_name, email FROM users WHERE is_active = 1 AND email LIKE ? ORDER BY created_at DESC";
        try (PreparedStatement ps = connect.prepareStatement(sql)) {
            ps.setString(1, "%" + email + "%");
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Users u = new Users();
                u.setUserId(rs.getInt("user_id"));
                u.setFullName(rs.getString("full_name"));
                u.setEmail(rs.getString("email"));
                users.add(u);
            }
        } catch (SQLException e) {
            System.err.println("❌ Lỗi searchUsersByEmail: " + e.getMessage());
            e.printStackTrace();
        }
        return users;
    }

    // Kích người thuê khỏi phòng: kết thúc hợp đồng và ghi lịch sử
    public boolean kickTenant(int tenantId, int roomId, int managerId) {
        // 1. Kết thúc hợp đồng hiện tại
        String updateContract = "UPDATE contracts SET status = ?, end_date = GETDATE() WHERE tenant_id = ? AND room_id = ? AND status = 1";
        // 2. Lấy thông tin hợp đồng vừa kết thúc để ghi lịch sử
        String selectContract = "SELECT TOP 1 contract_id, start_date, rent_price FROM contracts WHERE tenant_id = ? AND room_id = ? ORDER BY contract_id DESC";
        // 3. Ghi vào RentalHistory
        String insertHistory = "INSERT INTO RentalHistory (RentalID, RoomID, TenantID, TenantName, StartDate, EndDate, RentPrice, Notes, CreatedAt) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        Connection conn = null;
        try {
            conn = this.connect;
            conn.setAutoCommit(false);
            // 1. Update contract
            try (PreparedStatement ps = conn.prepareStatement(updateContract)) {
                ps.setInt(1, ContractStatus.HET_HAN);
                ps.setInt(2, tenantId);
                ps.setInt(3, roomId);
                int affected = ps.executeUpdate();
                if (affected == 0) {
                    conn.rollback();
                    return false;
                }
            }
            // 2. Get contract info
            int rentalId = 0;
            String startDate = null;
            String endDate = null;
            double rentPrice = 0;
            int contractId = 0;
            try (PreparedStatement ps = conn.prepareStatement(selectContract)) {
                ps.setInt(1, tenantId);
                ps.setInt(2, roomId);
                ResultSet rs = ps.executeQuery();
                if (rs.next()) {
                    contractId = rs.getInt("contract_id");
                    startDate = rs.getString("start_date");
                    rentPrice = rs.getDouble("rent_price");
                }
            }
            // 3. Lấy tên tenant
            String tenantName = "";
            try (PreparedStatement ps = conn.prepareStatement("SELECT full_name FROM users WHERE user_id = ?")) {
                ps.setInt(1, tenantId);
                ResultSet rs = ps.executeQuery();
                if (rs.next()) tenantName = rs.getString(1);
            }
            // 4. Lấy rentalId từ room
            try (PreparedStatement ps = conn.prepareStatement("SELECT rental_area_id FROM rooms WHERE room_id = ?")) {
                ps.setInt(1, roomId);
                ResultSet rs = ps.executeQuery();
                if (rs.next()) rentalId = rs.getInt(1);
            }
            // 5. Insert RentalHistory
            try (PreparedStatement ps = conn.prepareStatement(insertHistory)) {
                ps.setObject(1, rentalId);
                ps.setInt(2, roomId);
                ps.setInt(3, tenantId);
                ps.setString(4, tenantName);
                ps.setString(5, startDate);
                ps.setString(6, java.time.LocalDate.now().toString());
                ps.setDouble(7, rentPrice);
                ps.setString(8, "Kicked by managerId=" + managerId);
                ps.setString(9, java.time.LocalDateTime.now().toString());
                ps.executeUpdate();
            }
            conn.commit();
            return true;
        } catch (Exception e) {
            try { if (conn != null) conn.rollback(); } catch (Exception ex) {}
            System.err.println("❌ Lỗi kickTenant: " + e.getMessage());
            e.printStackTrace();
            return false;
        } finally {
            try { if (conn != null) conn.setAutoCommit(true); } catch (Exception ex) {}
        }
    }

    

    public boolean Register(Users user) {
        String sql = "INSERT INTO users (role_id, full_name, phone_number, email, password_hash, citizen_id, address, is_active, created_at) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (PreparedStatement ps = connect.prepareStatement(sql)) {
            ps.setInt(1, user.getRoleId());
            ps.setString(2, user.getFullName());
            ps.setString(3, user.getPhoneNumber());
            ps.setString(4, user.getEmail());
//            ps.setString(5, DAO.PasswordUtils.hashPassword(user.getPasswordHash()));
            ps.setString(5, user.getPasswordHash());
            ps.setString(6, user.getCitizenId());
            ps.setString(7, user.getAddress());
            ps.setBoolean(8, user.isActive());
            ps.setTimestamp(9, today);
            int row = ps.executeUpdate();
            if(row>0){
                return true;
            }
            System.out.println("✅ Đăng ký người dùng thành công!");
        } catch (SQLException e) {
            System.err.println("❌ Lỗi đăng ký người dùng: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }
    // Lấy danh sách người thuê theo managerId, có phân trang và tìm kiếm theo nhiều trường
    public ArrayList<Users> getTenantsByManagerPaged(int managerId, int page, int pageSize, String name, String phone, String email) {
        ArrayList<Users> tenants = new ArrayList<>();
        if (managerId <= 0 || page < 1 || pageSize <= 0) return tenants;
        String baseSql = "SELECT DISTINCT u.user_id, u.full_name, u.phone_number, u.email, u.address, r.room_id, r.room_number, ra.rental_area_id, ra.name AS rental_area_name " +
                "FROM users u " +
                "JOIN contracts c ON u.user_id = c.tenant_id " +
                "JOIN rooms r ON c.room_id = r.room_id " +
                "JOIN rental_areas ra ON r.rental_area_id = ra.rental_area_id " +
                "WHERE ra.manager_id = ? AND u.is_active = 1 AND c.status = 1 ";
        StringBuilder searchSql = new StringBuilder();
        ArrayList<Object> params = new ArrayList<>();
        if (name != null && !name.trim().isEmpty()) {
            searchSql.append("AND u.full_name LIKE ? ");
            params.add("%" + name.trim() + "%");
        }
        if (phone != null && !phone.trim().isEmpty()) {
            searchSql.append("AND u.phone_number LIKE ? ");
            params.add("%" + phone.trim() + "%");
        }
        if (email != null && !email.trim().isEmpty()) {
            searchSql.append("AND u.email LIKE ? ");
            params.add("%" + email.trim() + "%");
        }
        String orderLimit = "ORDER BY u.full_name ASC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
        String sql = baseSql + searchSql.toString() + orderLimit;
        try (PreparedStatement ps = connect.prepareStatement(sql)) {
            int idx = 1;
            ps.setInt(idx++, managerId);
            for (Object param : params) {
                ps.setObject(idx++, param);
            }
            ps.setInt(idx++, (page - 1) * pageSize);
            ps.setInt(idx++, pageSize);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Users u = new Users();
                u.setUserId(rs.getInt("user_id"));
                u.setFullName(rs.getString("full_name"));
                u.setPhoneNumber(rs.getString("phone_number"));
                u.setEmail(rs.getString("email"));
                u.setAddress(rs.getString("address"));
                // custom fields for room and rental area
                u.setRoomId(rs.getInt("room_id"));
                u.setRoomNumber(rs.getString("room_number"));
                u.setRentalAreaId(rs.getInt("rental_area_id"));
                u.setRentalAreaName(rs.getString("rental_area_name"));
                tenants.add(u);
            }
        } catch (SQLException e) {
            System.err.println("❌ Lỗi lấy danh sách người thuê theo manager (paged): " + e.getMessage());
            e.printStackTrace();
        }
        return tenants;
    }

    // Đếm tổng số người thuê theo managerId và nhiều trường tìm kiếm
    public int countTenantsByManager(int managerId, String name, String phone, String email) {
        int total = 0;
        if (managerId <= 0) return 0;
        String baseSql = "SELECT COUNT(DISTINCT u.user_id) as total " +
                "FROM users u " +
                "JOIN contracts c ON u.user_id = c.tenant_id " +
                "JOIN rooms r ON c.room_id = r.room_id " +
                "JOIN rental_areas ra ON r.rental_area_id = ra.rental_area_id " +
                "WHERE ra.manager_id = ? AND u.is_active = 1 AND c.status = 1 ";
        StringBuilder searchSql = new StringBuilder();
        ArrayList<Object> params = new ArrayList<>();
        if (name != null && !name.trim().isEmpty()) {
            searchSql.append("AND u.full_name LIKE ? ");
            params.add("%" + name.trim() + "%");
        }
        if (phone != null && !phone.trim().isEmpty()) {
            searchSql.append("AND u.phone_number LIKE ? ");
            params.add("%" + phone.trim() + "%");
        }
        if (email != null && !email.trim().isEmpty()) {
            searchSql.append("AND u.email LIKE ? ");
            params.add("%" + email.trim() + "%");
        }
        String sql = baseSql + searchSql.toString();
        try (PreparedStatement ps = connect.prepareStatement(sql)) {
            int idx = 1;
            ps.setInt(idx++, managerId);
            for (Object param : params) {
                ps.setObject(idx++, param);
            }
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                total = rs.getInt("total");
            }
        } catch (SQLException e) {
            System.err.println("❌ Lỗi đếm người thuê theo manager: " + e.getMessage());
            e.printStackTrace();
        }
        return total;
    }

    public ArrayList<Users> getUsers() {
        ArrayList<Users> users = new ArrayList<>();
        String sql = "SELECT * FROM users WHERE is_active = 1 ORDER BY created_at DESC";
        try (PreparedStatement statement = connect.prepareStatement(sql); 
             ResultSet rs = statement.executeQuery()) {

            while (rs.next()) {
                Users u = new Users();
                u.setUserId(rs.getInt("user_id"));
                u.setRoleId(rs.getInt("role_id"));
                u.setFullName(rs.getString("full_name"));
                u.setPhoneNumber(rs.getString("phone_number"));
                u.setEmail(rs.getString("email"));
                u.setPasswordHash(rs.getString("password_hash"));
                u.setCitizenId(rs.getString("citizen_id"));
                u.setAddress(rs.getString("address"));
                u.setActive(rs.getBoolean("is_active"));
                u.setCreatedAt(rs.getTimestamp("created_at"));
                u.setUpdatedAt(rs.getTimestamp("updated_at"));
                users.add(u);
            }
        } catch (SQLException e) {
            System.err.println("❌ Lỗi lấy danh sách người dùng: " + e.getMessage());
            e.printStackTrace();
        }
        return users;
    }

    public void deleteUser(int userId) {
        String sql = "UPDATE users SET is_active = 0, updated_at = ? WHERE user_id = ?";
        try (PreparedStatement ps = connect.prepareStatement(sql)) {
            ps.setTimestamp(1, today);
            ps.setInt(2, userId);
            ps.executeUpdate();
            System.out.println("✅ Xóa người dùng thành công!");
        } catch (SQLException e) {
            System.err.println("❌ Lỗi xóa người dùng: " + e.getMessage());
            e.printStackTrace();
        }
    }

    public void updateUser(Users user) {
        String sql = "UPDATE users SET role_id = ?, full_name = ?, phone_number = ?, email = ?, citizen_id = ?, address = ?, updated_at = ? WHERE user_id = ?";
        try (PreparedStatement ps = connect.prepareStatement(sql)) {
            ps.setInt(1, user.getRoleId());
            ps.setString(2, user.getFullName());
            ps.setString(3, user.getPhoneNumber());
            ps.setString(4, user.getEmail());
            
            // Handle citizen_id - if null or empty, set to null in database
            if (user.getCitizenId() != null && !user.getCitizenId().trim().isEmpty()) {
                ps.setString(5, user.getCitizenId().trim());
            } else {
                ps.setNull(5, java.sql.Types.VARCHAR);
            }
            
            // Handle address - if null or empty, set to null in database
            if (user.getAddress() != null && !user.getAddress().trim().isEmpty()) {
                ps.setString(6, user.getAddress().trim());
            } else {
                ps.setNull(6, java.sql.Types.VARCHAR);
            }
            
            ps.setTimestamp(7, today);
            ps.setInt(8, user.getUserId());
            ps.executeUpdate();
            System.out.println("✅ Cập nhật người dùng thành công!");
        } catch (SQLException e) {
            System.err.println("❌ Lỗi cập nhật người dùng: " + e.getMessage());
            e.printStackTrace();
        }
    }

    // Method to update user with password change
    public void updateUserWithPassword(Users user) {
        String sql = "UPDATE users SET role_id = ?, full_name = ?, phone_number = ?, email = ?, password_hash = ?, citizen_id = ?, address = ?, updated_at = ? WHERE user_id = ?";
        try (PreparedStatement ps = connect.prepareStatement(sql)) {
            ps.setInt(1, user.getRoleId());
            ps.setString(2, user.getFullName());
            ps.setString(3, user.getPhoneNumber());
            ps.setString(4, user.getEmail());
            ps.setString(5, DAO.PasswordUtils.hashPassword(user.getPasswordHash()));
            
            // Handle citizen_id - if null or empty, set to null in database
            if (user.getCitizenId() != null && !user.getCitizenId().trim().isEmpty()) {
                ps.setString(6, user.getCitizenId().trim());
            } else {
                ps.setNull(6, java.sql.Types.VARCHAR);
            }
            
            // Handle address - if null or empty, set to null in database
            if (user.getAddress() != null && !user.getAddress().trim().isEmpty()) {
                ps.setString(7, user.getAddress().trim());
            } else {
                ps.setNull(7, java.sql.Types.VARCHAR);
            }
            
            ps.setTimestamp(8, today);
            ps.setInt(9, user.getUserId());
            ps.executeUpdate();
            System.out.println("✅ Cập nhật người dùng với mật khẩu thành công!");
        } catch (SQLException e) {
            System.err.println("❌ Lỗi cập nhật người dùng với mật khẩu: " + e.getMessage());
            e.printStackTrace();
        }
    }

    public Users getUserByEmail(String email) throws Exception {
        String query = "SELECT * FROM users WHERE email = ? AND is_active = 1";
        PreparedStatement ps = connect.prepareStatement(query);
        ps.setString(1, email);
        ResultSet rs = ps.executeQuery();

        if (rs.next()) {
            Users user = new Users();
            user.setUserId(rs.getInt("user_id"));
            user.setRoleId(rs.getInt("role_id"));
            user.setFullName(rs.getString("full_name"));
            user.setPhoneNumber(rs.getString("phone_number"));
            user.setEmail(rs.getString("email"));
            user.setPasswordHash(rs.getString("password_hash"));
            user.setCitizenId(rs.getString("citizen_id"));
            user.setAddress(rs.getString("address"));
            user.setActive(rs.getBoolean("is_active"));
            user.setCreatedAt(rs.getTimestamp("created_at"));
            user.setUpdatedAt(rs.getTimestamp("updated_at"));
            return user;
        }
        return null;
    }

    public Users getUserByPhone(String phone) throws Exception {
        String query = "SELECT * FROM users WHERE phone_number = ? AND is_active = 1";
        PreparedStatement ps = connect.prepareStatement(query);
        ps.setString(1, phone);
        ResultSet rs = ps.executeQuery();

        if (rs.next()) {
            Users user = new Users();
            user.setUserId(rs.getInt("user_id"));
            user.setRoleId(rs.getInt("role_id"));
            user.setFullName(rs.getString("full_name"));
            user.setPhoneNumber(rs.getString("phone_number"));
            user.setEmail(rs.getString("email"));
            user.setPasswordHash(rs.getString("password_hash"));
            user.setCitizenId(rs.getString("citizen_id"));
            user.setAddress(rs.getString("address"));
            user.setActive(rs.getBoolean("is_active"));
            user.setCreatedAt(rs.getTimestamp("created_at"));
            user.setUpdatedAt(rs.getTimestamp("updated_at"));
            return user;
        }
        return null;
    }

    public boolean checkEmailExists(String email) {
        try {
            String query = "SELECT COUNT(*) FROM users WHERE email = ? AND is_active = 1";
            PreparedStatement ps = connect.prepareStatement(query);
            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                int count = rs.getInt(1);
                return count > 0;
            }
        } catch (SQLException e) {
            System.err.println("❌ Lỗi kiểm tra email: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    public boolean checkPhoneExists(String phone) {
        try {
            String query = "SELECT COUNT(*) FROM users WHERE phone_number = ? AND is_active = 1";
            PreparedStatement ps = connect.prepareStatement(query);
            ps.setString(1, phone);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                int count = rs.getInt(1);
                return count > 0;
            }
        } catch (SQLException e) {
            System.err.println("❌ Lỗi kiểm tra số điện thoại: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    public Users getUserByID(int userId) throws Exception {
        String query = "SELECT * FROM users WHERE user_id = ? AND is_active = 1";
        PreparedStatement ps = connect.prepareStatement(query);
        ps.setInt(1, userId);
        ResultSet rs = ps.executeQuery();

        if (rs.next()) {
            Users user = new Users();
            user.setUserId(rs.getInt("user_id"));
            user.setRoleId(rs.getInt("role_id"));
            user.setFullName(rs.getString("full_name"));
            user.setPhoneNumber(rs.getString("phone_number"));
            user.setEmail(rs.getString("email"));
            user.setPasswordHash(rs.getString("password_hash"));
            user.setCitizenId(rs.getString("citizen_id"));
            user.setAddress(rs.getString("address"));
            user.setActive(rs.getBoolean("is_active"));
            user.setCreatedAt(rs.getTimestamp("created_at"));
            user.setUpdatedAt(rs.getTimestamp("updated_at"));
            return user;
        }
        return null;
    }

    public ArrayList<Users> getUsersBySearch(String information) throws Exception {
        ArrayList<Users> users = new ArrayList<>();
        String sql = "SELECT * FROM users WHERE is_active = 1 AND (full_name LIKE ? OR email LIKE ? OR phone_number LIKE ?) ORDER BY created_at DESC";
        
        try (PreparedStatement statement = connect.prepareStatement(sql)) {
            String searchTerm = "%" + information + "%";
            statement.setString(1, searchTerm);
            statement.setString(2, searchTerm);
            statement.setString(3, searchTerm);
            ResultSet rs = statement.executeQuery();
            
            while (rs.next()) {
                Users u = new Users();
                u.setUserId(rs.getInt("user_id"));
                u.setRoleId(rs.getInt("role_id"));
                u.setFullName(rs.getString("full_name"));
                u.setPhoneNumber(rs.getString("phone_number"));
                u.setEmail(rs.getString("email"));
                u.setPasswordHash(rs.getString("password_hash"));
                u.setCitizenId(rs.getString("citizen_id"));
                u.setAddress(rs.getString("address"));
                u.setActive(rs.getBoolean("is_active"));
                u.setCreatedAt(rs.getTimestamp("created_at"));
                u.setUpdatedAt(rs.getTimestamp("updated_at"));
                users.add(u);
            }
        } catch (SQLException e) {
            System.err.println("❌ Lỗi tìm kiếm người dùng: " + e.getMessage());
            e.printStackTrace();
        }
        return users;
    }

    public void resetPasswordUser(int userId) {
        String sql = "UPDATE users SET password_hash = ?, updated_at = ? WHERE user_id = ?";
        try (PreparedStatement ps = connect.prepareStatement(sql)) {
            ps.setString(1, DAO.PasswordUtils.hashPassword("12345678"));
            ps.setTimestamp(2, today);
            ps.setInt(3, userId);
            ps.executeUpdate();
            System.out.println("✅ Reset mật khẩu thành công!");
        } catch (SQLException e) {
            System.err.println("❌ Lỗi reset mật khẩu: " + e.getMessage());
            e.printStackTrace();
        }
    }

    // Get users by role (for admin management)
    public ArrayList<Users> getUsersByRole(int roleId) {
        ArrayList<Users> users = new ArrayList<>();
        String sql = "SELECT * FROM users WHERE role_id = ? AND is_active = 1 ORDER BY created_at DESC";
        try (PreparedStatement statement = connect.prepareStatement(sql)) {
            statement.setInt(1, roleId);
            ResultSet rs = statement.executeQuery();

            while (rs.next()) {
                Users u = new Users();
                u.setUserId(rs.getInt("user_id"));
                u.setRoleId(rs.getInt("role_id"));
                u.setFullName(rs.getString("full_name"));
                u.setPhoneNumber(rs.getString("phone_number"));
                u.setEmail(rs.getString("email"));
                u.setPasswordHash(rs.getString("password_hash"));
                u.setCitizenId(rs.getString("citizen_id"));
                u.setAddress(rs.getString("address"));
                u.setActive(rs.getBoolean("is_active"));
                u.setCreatedAt(rs.getTimestamp("created_at"));
                u.setUpdatedAt(rs.getTimestamp("updated_at"));
                users.add(u);
            }
        } catch (SQLException e) {
            System.err.println("❌ Lỗi lấy danh sách người dùng theo role: " + e.getMessage());
            e.printStackTrace();
        }
        return users;
    }

    // Get users with roles 2 and 3 (for admin management)
    public ArrayList<Users> getManagerAndTenantUsers() {
        ArrayList<Users> users = new ArrayList<>();
        String sql = "SELECT * FROM users WHERE role_id IN (2, 3) AND is_active = 1 ORDER BY created_at DESC";
        try (PreparedStatement statement = connect.prepareStatement(sql); 
             ResultSet rs = statement.executeQuery()) {
            
            while (rs.next()) {
                Users u = new Users();
                u.setUserId(rs.getInt("user_id"));
                u.setRoleId(rs.getInt("role_id"));
                u.setFullName(rs.getString("full_name"));
                u.setPhoneNumber(rs.getString("phone_number"));
                u.setEmail(rs.getString("email"));
                u.setPasswordHash(rs.getString("password_hash"));
                u.setCitizenId(rs.getString("citizen_id"));
                u.setAddress(rs.getString("address"));
                u.setActive(rs.getBoolean("is_active"));
                u.setCreatedAt(rs.getTimestamp("created_at"));
                u.setUpdatedAt(rs.getTimestamp("updated_at"));
                    users.add(u);
            }
        } catch (SQLException e) {
            System.err.println("❌ Lỗi lấy danh sách người dùng quản lý và người thuê: " + e.getMessage());
            e.printStackTrace();
        }
        return users;
    }

    // Create new user (for admin)
    public void createUser(Users user) throws SQLException {
        String sql = "INSERT INTO users (role_id, full_name, phone_number, email, password_hash, citizen_id, address, is_active, created_at) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (PreparedStatement ps = connect.prepareStatement(sql)) {
            ps.setInt(1, user.getRoleId());
            ps.setString(2, user.getFullName());
            ps.setString(3, user.getPhoneNumber());
            ps.setString(4, user.getEmail());
            ps.setString(5, DAO.PasswordUtils.hashPassword(user.getPasswordHash()));
            
            // Handle citizen_id - if null or empty, set to null in database
            if (user.getCitizenId() != null && !user.getCitizenId().trim().isEmpty()) {
                ps.setString(6, user.getCitizenId().trim());
            } else {
                ps.setNull(6, java.sql.Types.VARCHAR);
            }
            
            // Handle address - if null or empty, set to null in database
            if (user.getAddress() != null && !user.getAddress().trim().isEmpty()) {
                ps.setString(7, user.getAddress().trim());
            } else {
                ps.setNull(7, java.sql.Types.VARCHAR);
            }
            
            ps.setBoolean(8, user.isActive());
            ps.setTimestamp(9, today);
            ps.executeUpdate();
            System.out.println("✅ Tạo người dùng thành công!");
        } catch (SQLException e) {
            System.err.println("❌ Lỗi tạo người dùng: " + e.getMessage());
            e.printStackTrace();
            throw e; // Re-throw the exception
        }
    }

    // Update user role (for admin)
    public void updateUserRole(int userId, int newRoleId) {
        String sql = "UPDATE users SET role_id = ?, updated_at = ? WHERE user_id = ?";
        try (PreparedStatement ps = connect.prepareStatement(sql)) {
            ps.setInt(1, newRoleId);
            ps.setTimestamp(2, today);
            ps.setInt(3, userId);
            ps.executeUpdate();
            System.out.println("✅ Cập nhật vai trò người dùng thành công!");
        } catch (SQLException e) {
            System.err.println("❌ Lỗi cập nhật vai trò người dùng: " + e.getMessage());
            e.printStackTrace();
        }
    }
    
    // Get total count of users by role
    public int getTotalUsersByRole(int roleId) {
        String sql = "SELECT COUNT(*) FROM users WHERE role_id = ? AND is_active = 1";
        try (PreparedStatement ps = connect.prepareStatement(sql)) {
            ps.setInt(1, roleId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            System.err.println("❌ Lỗi đếm người dùng theo role: " + e.getMessage());
            e.printStackTrace();
        }
        return 0;
    }

    // Get total count of manager and tenant users
    public int getTotalManagerAndTenantUsers() {
        String sql = "SELECT COUNT(*) FROM users WHERE role_id IN (2, 3) AND is_active = 1";
        try (PreparedStatement ps = connect.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            System.err.println("❌ Lỗi đếm người dùng quản lý và người thuê: " + e.getMessage());
            e.printStackTrace();
        }
        return 0;
    }
    
    // Pagination for manager and tenant users
    public ArrayList<Users> getManagerAndTenantUsersByPage(int page, int usersPerPage) {
        ArrayList<Users> users = new ArrayList<>();
        String sql = "SELECT * FROM users WHERE role_id IN (2, 3) AND is_active = 1 ORDER BY created_at DESC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
        try (PreparedStatement ps = connect.prepareStatement(sql)) {
            ps.setInt(1, (page - 1) * usersPerPage);
            ps.setInt(2, usersPerPage);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Users u = new Users();
                u.setUserId(rs.getInt("user_id"));
                u.setRoleId(rs.getInt("role_id"));
                u.setFullName(rs.getString("full_name"));
                u.setPhoneNumber(rs.getString("phone_number"));
                u.setEmail(rs.getString("email"));
                u.setPasswordHash(rs.getString("password_hash"));
                u.setCitizenId(rs.getString("citizen_id"));
                u.setAddress(rs.getString("address"));
                u.setActive(rs.getBoolean("is_active"));
                u.setCreatedAt(rs.getTimestamp("created_at"));
                u.setUpdatedAt(rs.getTimestamp("updated_at"));
                users.add(u);
            }
        } catch (SQLException e) {
            System.err.println("❌ Lỗi phân trang người dùng: " + e.getMessage());
            e.printStackTrace();
        }
        return users;
    }
    
    // Search users by name or email (for admin)
    public ArrayList<Users> searchManagerAndTenantUsers(String searchTerm) {
        ArrayList<Users> users = new ArrayList<>();
        String sql = "SELECT * FROM users WHERE role_id IN (2, 3) AND is_active = 1 AND (full_name LIKE ? OR email LIKE ?) ORDER BY created_at DESC";
        try (PreparedStatement ps = connect.prepareStatement(sql)) {
            ps.setString(1, "%" + searchTerm + "%");
            ps.setString(2, "%" + searchTerm + "%");
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Users u = new Users();
                u.setUserId(rs.getInt("user_id"));
                u.setRoleId(rs.getInt("role_id"));
                u.setFullName(rs.getString("full_name"));
                u.setPhoneNumber(rs.getString("phone_number"));
                u.setEmail(rs.getString("email"));
                u.setPasswordHash(rs.getString("password_hash"));
                u.setCitizenId(rs.getString("citizen_id"));
                u.setAddress(rs.getString("address"));
                u.setActive(rs.getBoolean("is_active"));
                u.setCreatedAt(rs.getTimestamp("created_at"));
                u.setUpdatedAt(rs.getTimestamp("updated_at"));
                users.add(u);
            }
        } catch (SQLException e) {
            System.err.println("❌ Lỗi tìm kiếm người dùng: " + e.getMessage());
            e.printStackTrace();
        }
        return users;
    }
    
    // Get all roles
    public ArrayList<Role> getAllRoles() {
        ArrayList<Role> roles = new ArrayList<>();
        String sql = "SELECT * FROM roles ORDER BY role_id";
        try (PreparedStatement statement = connect.prepareStatement(sql); 
             ResultSet rs = statement.executeQuery()) {

            while (rs.next()) {
                Role role = new Role();
                role.setRoleId(rs.getInt("role_id"));
                role.setRoleName(rs.getString("role_name"));
                roles.add(role);
            }
        } catch (SQLException e) {
            System.err.println("❌ Lỗi lấy danh sách vai trò: " + e.getMessage());
            e.printStackTrace();
        }
        return roles;
    }
    public boolean updatePassword(String email, String password) {
        String sql = "UPDATE dbo.users SET password_hash = ? WHERE email = ?";
        try (PreparedStatement ps = connect.prepareStatement(sql)) {
            ps.setString(1, password); // Giả định password đã được mã hóa ở tầng servlet
            ps.setString(2, email);
            int rowsAffected = ps.executeUpdate();
            if (rowsAffected > 0) {
                System.out.println("✅ Cập nhật mật khẩu thành công cho email: " + email);
                return true;
            }
            System.out.println("⚠️ Không tìm thấy email để cập nhật: " + email);
            return false;
        } catch (SQLException e) {
            System.err.println("❌ Lỗi cập nhật mật khẩu: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    // Lấy danh sách người thuê trọ thuộc các khu trọ mà manager quản lý
    public ArrayList<Users> getTenantsByManager(int managerId) {
        ArrayList<Users> tenants = new ArrayList<>();
        String sql = "SELECT DISTINCT u.user_id, u.full_name, u.phone_number, u.email, u.address, r.room_id, r.room_number, ra.rental_area_id, ra.name AS rental_area_name " +
                     "FROM users u " +
                     "JOIN contracts c ON u.user_id = c.tenant_id " +
                     "JOIN rooms r ON c.room_id = r.room_id " +
                     "JOIN rental_areas ra ON r.rental_area_id = ra.rental_area_id " +
                     "WHERE ra.manager_id = ? AND u.is_active = 1";
        try (PreparedStatement ps = connect.prepareStatement(sql)) {
            ps.setInt(1, managerId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Users user = new Users();
                user.setUserId(rs.getInt("user_id"));
                user.setFullName(rs.getString("full_name"));
                user.setPhoneNumber(rs.getString("phone_number"));
                user.setEmail(rs.getString("email"));
                user.setAddress(rs.getString("address"));
                // Lưu thêm thông tin phòng và khu trọ vào thuộc tính tạm thời (nếu cần)
                user.setRoomId(rs.getInt("room_id"));
                user.setRoomNumber(rs.getString("room_number"));
                user.setRentalAreaId(rs.getInt("rental_area_id"));
                user.setRentalAreaName(rs.getString("rental_area_name"));
                tenants.add(user);
            }
        } catch (SQLException e) {
            System.err.println("❌ Lỗi lấy danh sách người thuê theo manager: " + e.getMessage());
            e.printStackTrace();
        }
        return tenants;
    }

    public static void main(String[] args) throws Exception {
        DAOUser dao = new DAOUser();
        ArrayList<Users> users = dao.getUsers();
        for (Users user : users) {
            System.out.println(user.getEmail() + " - " + user.getRoleId());
        }
    }
}
