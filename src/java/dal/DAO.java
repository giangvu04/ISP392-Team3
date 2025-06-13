/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.sql.Date;

/**
 *
 * @author ADMIN
 */
public class DAO {

    public static final DAO INSTANCE = new DAO();
    protected Connection connect;

    public DAO() {
        connect = new DBContext().connect;
    }

    public static long millis = System.currentTimeMillis();
    public static Date today = new Date(millis);

    public static class PasswordUtils {

        public static String hashPassword(String password) {
            try {
                MessageDigest md = MessageDigest.getInstance("SHA-256");
                byte[] hashedBytes = md.digest(password.getBytes());
                StringBuilder sb = new StringBuilder();
                for (byte b : hashedBytes) {
                    sb.append(String.format("%02x", b));
                }
                return sb.toString();
            } catch (NoSuchAlgorithmException e) {
                throw new RuntimeException("Error hashing password", e);
            }
        }

        public static boolean verifyPassword(String password, String hashedPassword) {
            String hashedInput = hashPassword(password);
            return hashedInput.equals(hashedPassword);
        }
    }

    // Generic database utility methods
    public boolean executeUpdate(String sql, Object... params) {
        try (PreparedStatement ps = connect.prepareStatement(sql)) {
            for (int i = 0; i < params.length; i++) {
                ps.setObject(i + 1, params[i]);
            }
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("❌ Lỗi thực thi câu lệnh SQL: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    public ResultSet executeQuery(String sql, Object... params) {
        try {
            PreparedStatement ps = connect.prepareStatement(sql);
            for (int i = 0; i < params.length; i++) {
                ps.setObject(i + 1, params[i]);
            }
            return ps.executeQuery();
        } catch (SQLException e) {
            System.err.println("❌ Lỗi thực thi câu lệnh SQL: " + e.getMessage());
            e.printStackTrace();
            return null;
        }
    }

    public int getCount(String tableName, String condition, Object... params) {
        String sql = "SELECT COUNT(*) FROM " + tableName;
        if (condition != null && !condition.trim().isEmpty()) {
            sql += " WHERE " + condition;
        }
        
        try (PreparedStatement ps = connect.prepareStatement(sql)) {
            for (int i = 0; i < params.length; i++) {
                ps.setObject(i + 1, params[i]);
            }
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            System.err.println("❌ Lỗi đếm bản ghi: " + e.getMessage());
            e.printStackTrace();
        }
        return 0;
    }

    public boolean tableExists(String tableName) {
        String sql = "SELECT COUNT(*) FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = ?";
        try (PreparedStatement ps = connect.prepareStatement(sql)) {
            ps.setString(1, tableName);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            System.err.println("❌ Lỗi kiểm tra bảng: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    public boolean columnExists(String tableName, String columnName) {
        String sql = "SELECT COUNT(*) FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = ? AND COLUMN_NAME = ?";
        try (PreparedStatement ps = connect.prepareStatement(sql)) {
            ps.setString(1, tableName);
            ps.setString(2, columnName);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            System.err.println("❌ Lỗi kiểm tra cột: " + e.getMessage());
            e.printStackTrace();
        }
        return false;
    }

    public void closeConnection() {
        try {
            if (connect != null && !connect.isClosed()) {
                connect.close();
            }
        } catch (SQLException e) {
            System.err.println("❌ Lỗi đóng kết nối: " + e.getMessage());
            e.printStackTrace();
        }
    }

    public static void main(String[] args) {
        DAO dao = new DAO();
        
        // Test database connection
        System.out.println("Testing database connection...");
        
        // Test if tables exist
        String[] tables = {"users", "roles", "rental_areas", "rooms", "contracts", "services", "bills", "bill_details"};
        for (String table : tables) {
            boolean exists = dao.tableExists(table);
            System.out.println("Table " + table + ": " + (exists ? "✅ Exists" : "❌ Not found"));
        }
        
        // Test password hashing
        String testPassword = "test123";
        String hashed = PasswordUtils.hashPassword(testPassword);
        System.out.println("Password hashing test: " + (PasswordUtils.verifyPassword(testPassword, hashed) ? "✅ Pass" : "❌ Fail"));
        
        dao.closeConnection();
    }
}
