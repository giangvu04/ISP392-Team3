package dal;

import model.Users;
import model.Role;
import java.sql.Connection;
import java.sql.Timestamp;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

public class DAOUser {

    public static final DAOUser INSTANCE = new DAOUser();
    protected Connection connect;

    public DAOUser() {
        connect = new DBContext().connect;
    }

    public static long millis = System.currentTimeMillis();
    public static Timestamp today = new Timestamp(millis);

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
    
    public static void main(String[] args) throws Exception {
        DAOUser dao = new DAOUser();
        ArrayList<Users> users = dao.getUsers();
        for (Users user : users) {
            System.out.println(user.getEmail() + " - " + user.getRoleId());
        }
    }
}
