package Const;

public class ViewingRequestStatus {
    public static final int PENDING = 0;
    public static final int VIEWED = 1;
    public static final int REJECTED = 2;
    public static final int CONTACTED = 3;
    
    public static String getStatusText(int status) {
        switch (status) {
            case PENDING: return "Chờ xử lý";
            case VIEWED: return "Đã xem";
            case REJECTED: return "Từ chối";
            case CONTACTED: return "Đã liên hệ";
            default: return "Không xác định";
        }
    }
}
