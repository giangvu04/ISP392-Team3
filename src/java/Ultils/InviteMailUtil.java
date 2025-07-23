package Ultils;

public class InviteMailUtil {
    /**
     * Tạo link xác nhận lời mời cho tenant
     * @param baseUrl Địa chỉ base (ví dụ: https://yourdomain.com/acceptInvite)
     * @param userId userId (có thể null nếu chưa đăng ký)
     * @param roomId roomId
     * @param token token random
     * @return link dạng: baseUrl?token=userIdxroomIdxToken
     */
    public static String buildInviteLink(String baseUrl, Integer userId, int roomId, String token) {
        String uid = (userId != null) ? userId.toString() : "0";
        return baseUrl + "?token=" + uid + "x" + roomId + "x" + token;
    }

    /**
     * Parse chuỗi token dạng userIdxroomIdxtoken
     * @param tokenStr
     * @return mảng [userId, roomId, token] (userId có thể là "0" nếu chưa đăng ký)
     */
    public static String[] parseInviteToken(String tokenStr) {
        if (tokenStr == null) return null;
        String[] arr = tokenStr.split("x", 3);
        if (arr.length == 3) return arr;
        return null;
    }
}
