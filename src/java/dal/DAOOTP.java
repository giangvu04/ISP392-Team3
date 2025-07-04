package dal;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import model.OTP;

public class DAOOTP {
    
    public static final DAOOTP INSTANCE = new DAOOTP();
    protected Connection connect;

    public DAOOTP() {
        connect = new DBContext().connect;
    }

    // Thêm OTP mới
    public void addOTP(OTP otp) {
        String sql = "INSERT INTO tbOTP (email, otp, created_at, expires_at, is_used) VALUES (?, ?, GETDATE(), DATEADD(MINUTE, 5, GETDATE()), 0)";
        try (PreparedStatement ps = connect.prepareStatement(sql)) {
            ps.setString(1, otp.getEmail());
            ps.setString(2, otp.getOtp());
            ps.executeUpdate();
            System.out.println("✅ Thêm OTP thành công!");
        } catch (SQLException e) {
            System.err.println("❌ Lỗi thêm OTP: " + e.getMessage());
            e.printStackTrace();
        }
    }

    // Kiểm tra OTP hợp lệ
    public OTP verifyOTP(String email, String otp) {
        String sql = "SELECT id, email, otp, created_at, expires_at, is_used FROM tbOTP WHERE email = ? AND otp = ? AND is_used = 0 AND expires_at > GETDATE()";
        try (PreparedStatement ps = connect.prepareStatement(sql)) {
            ps.setString(1, email);
            ps.setString(2, otp);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                OTP result = new OTP();
                result.setId(rs.getInt("id"));
                result.setEmail(rs.getString("email"));
                result.setOtp(rs.getString("otp"));
                result.setCreatedAt(rs.getTimestamp("created_at"));
                result.setExpiresAt(rs.getTimestamp("expires_at"));
                result.setUsed(rs.getBoolean("is_used"));
                return result;
            }
        } catch (SQLException e) {
            System.err.println("❌ Lỗi kiểm tra OTP: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }

    // Cập nhật trạng thái OTP đã sử dụng
    public void markOTPAsUsed(int id) {
        String sql = "UPDATE tbOTP SET is_used = 1 WHERE id = ?";
        try (PreparedStatement ps = connect.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.executeUpdate();
            System.out.println("✅ Cập nhật trạng thái OTP thành công!");
        } catch (SQLException e) {
            System.err.println("❌ Lỗi cập nhật trạng thái OTP: " + e.getMessage());
            e.printStackTrace();
        }
    }

    // Xóa OTP hết hạn hoặc đã sử dụng
    public void deleteExpiredOrUsedOTPs() {
        String sql = "DELETE FROM tbOTP WHERE expires_at < GETDATE() OR is_used = 1";
        try (PreparedStatement ps = connect.prepareStatement(sql)) {
            ps.executeUpdate();
            System.out.println("✅ Xóa OTP hết hạn hoặc đã sử dụng thành công!");
        } catch (SQLException e) {
            System.err.println("❌ Lỗi xóa OTP: " + e.getMessage());
            e.printStackTrace();
        }
    }

    // Kiểm tra xem email có OTP chưa hết hạn không
    public boolean checkActiveOTP(String email) {
        String sql = "SELECT id FROM tbOTP WHERE email = ? AND is_used = 0 AND expires_at > GETDATE()";
        try (PreparedStatement ps = connect.prepareStatement(sql)) {
            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                System.out.println("⚠️ Tồn tại OTP chưa hết hạn cho email: " + email);
                return true;
            }
            return false;
        } catch (SQLException e) {
            System.err.println("❌ Lỗi kiểm tra OTP chưa hết hạn: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }

    // Kiểm tra OTP trùng lặp
    public boolean checkDuplicateOTP(String email, String otp) {
        String sql = "SELECT id FROM tbOTP WHERE email = ? AND otp = ? AND is_used = 0 AND expires_at > GETDATE()";
        try (PreparedStatement ps = connect.prepareStatement(sql)) {
            ps.setString(1, email);
            ps.setString(2, otp);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                System.out.println("⚠️ OTP trùng lặp cho email: " + email);
                return true;
            }
            return false;
        } catch (SQLException e) {
            System.err.println("❌ Lỗi kiểm tra OTP trùng lặp: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
}