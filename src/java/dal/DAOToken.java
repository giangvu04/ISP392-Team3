
package dal;

import Const.Token;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.util.UUID;
import model.UserInviteToken;

public class DAOToken {
    public static final DAOToken INSTANCE = new DAOToken();
    protected Connection connect;

    public DAOToken() {
        connect = new DBContext().connect;
    }

    // Kiểm tra xem đã có token hợp lệ cho user/email và room này chưa (chưa dùng, chưa hết hạn)
    public boolean hasValidInviteToken(Integer userId, String email, int roomId) {
        String sql = "SELECT COUNT(*) FROM user_invite_tokens WHERE ";
        if (userId != null) {
            sql += "user_id = ? ";
        } else {
            sql += "email = ? ";
        }
        sql += "AND room_id = ? AND is_used = 0 AND expires_at > GETDATE()";
        try (PreparedStatement ps = connect.prepareStatement(sql)) {
            if (userId != null) {
                ps.setInt(1, userId);
            } else {
                ps.setString(1, email);
            }
            ps.setInt(2, roomId);
            ResultSet rs = ps.executeQuery();
            if (rs.next() && rs.getInt(1) > 0) {
                return true;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
    

    // Tạo token mới và lưu vào DB, trả về token string
    public String createInviteToken(Integer userId, String email, int roomId) {
        String token = UUID.randomUUID().toString();
        LocalDateTime now = LocalDateTime.now();
        LocalDateTime expires = now.plusDays(Token.TIME_LOI_MOI); // 3 ngày
        String sql = "INSERT INTO user_invite_tokens (user_id, email, room_id, token, created_at, expires_at, is_used) VALUES (?, ?, ?, ?, ?, ?, 0)";
        try (PreparedStatement ps = connect.prepareStatement(sql)) {
            if (userId != null) {
                ps.setInt(1, userId);
            } else {
                ps.setNull(1, java.sql.Types.INTEGER);
            }
            ps.setString(2, email);
            ps.setInt(3, roomId);
            ps.setString(4, token);
            ps.setTimestamp(5, Timestamp.valueOf(now));
            ps.setTimestamp(6, Timestamp.valueOf(expires));
            ps.executeUpdate();
            return token;
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    // Lấy token hợp lệ (chưa dùng, chưa hết hạn)
    public UserInviteToken getValidToken(String token) {
        String sql = "SELECT * FROM user_invite_tokens WHERE token = ? AND is_used = 0 AND expires_at > GETDATE()";
        try (PreparedStatement ps = connect.prepareStatement(sql)) {
            ps.setString(1, token);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                UserInviteToken t = new UserInviteToken();
                t.setTokenId(rs.getInt("token_id"));
                t.setUserId(rs.getObject("user_id") != null ? rs.getInt("user_id") : null);
                t.setEmail(rs.getString("email"));
                t.setRoomId(rs.getInt("room_id"));
                t.setToken(rs.getString("token"));
                t.setCreatedAt(rs.getTimestamp("created_at"));
                t.setExpiresAt(rs.getTimestamp("expires_at"));
                t.setIsUsed(rs.getBoolean("is_used"));
                return t;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    // Đánh dấu token đã dùng
    public boolean markTokenUsed(String token) {
        String sql = "UPDATE user_invite_tokens SET is_used = 1 WHERE token = ?";
        try (PreparedStatement ps = connect.prepareStatement(sql)) {
            ps.setString(1, token);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
}
