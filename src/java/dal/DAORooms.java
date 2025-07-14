package dal;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.RentalArea;
import model.RentalHistory;
import model.Rooms;

public class DAORooms {
    /**
     * Lấy phòng hiện tại mà tenant đang ở (hợp đồng đang hiệu lực)
     * @param tenantId user_id của tenant
     * @return Rooms object hoặc null nếu không có
     */
    public Rooms getCurrentRoomByTenant(int tenantId) {
        String sql = "SELECT r.*, ra.name as rental_area_name FROM contracts c " +
                     "JOIN rooms r ON c.room_id = r.room_id " +
                     "JOIN rental_areas ra ON r.rental_area_id = ra.rental_area_id " +
                     "WHERE c.tenant_id = ? AND c.status = 1";
        try (PreparedStatement ps = connect.prepareStatement(sql)) {
            ps.setInt(1, tenantId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Rooms room = new Rooms();
                room.setRoomId(rs.getInt("room_id"));
                room.setRentalAreaId(rs.getInt("rental_area_id"));
                room.setRoomNumber(rs.getString("room_number"));
                room.setArea(rs.getBigDecimal("area"));
                room.setPrice(rs.getBigDecimal("price"));
                room.setMaxTenants(rs.getInt("max_tenants"));
                room.setStatus(rs.getInt("status"));
                room.setDescription(rs.getString("description"));
                room.setImageUrl(rs.getString("imageUrl"));
                room.setRentalAreaName(rs.getString("rental_area_name"));
                return room;
            }
        } catch (SQLException e) {
            System.err.println("Lỗi lấy phòng hiện tại của tenant: " + e.getMessage());
        }
        return null;
    }

    public static final DAORooms INSTANCE = new DAORooms();

    /**
     * Đếm số lượng tenant đang active (có hợp đồng status = 1) trong phòng
     */
    public int countActiveTenants(int roomId) {
        String sql = "SELECT COUNT(*) FROM contracts WHERE room_id = ? AND status = 1";
        try (PreparedStatement ps = connect.prepareStatement(sql)) {
            ps.setInt(1, roomId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    /**
     * Lấy số tiền đặt cọc mặc định cho phòng (có thể lấy từ bảng rooms hoặc logic riêng)
     */
    public java.math.BigDecimal getDepositAmount(int roomId) {
        String sql = "SELECT deposit_amount FROM rooms WHERE room_id = ?";
        try (PreparedStatement ps = connect.prepareStatement(sql)) {
            ps.setInt(1, roomId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getBigDecimal("deposit_amount");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return java.math.BigDecimal.ZERO;
    }

    /**
     * Lấy ngày kết thúc hợp đồng mặc định (ví dụ: 1 năm kể từ ngày hiện tại)
     */
    public java.sql.Date getDefaultContractEndDate() {
        java.util.Calendar cal = java.util.Calendar.getInstance();
        cal.add(java.util.Calendar.YEAR, 1);
        return new java.sql.Date(cal.getTimeInMillis());
    }
    protected Connection connect;

    public DAORooms() {
        connect = new DBContext().connect;
    }
    public int[] getRoomStatsForManager(int managerId) {
        int totalRooms = 0;
        int rentedRooms = 0;
        int vacantRooms = 0;
        String sqlTotal = "SELECT COUNT(*) FROM rooms WHERE rental_area_id IN (SELECT rental_area_id FROM rental_areas WHERE manager_id = ?)";
        String sqlRented = "SELECT COUNT(*) FROM rooms WHERE status = 1 AND rental_area_id IN (SELECT rental_area_id FROM rental_areas WHERE manager_id = ?)";
        String sqlVacant = "SELECT COUNT(*) FROM rooms WHERE status = 0 AND rental_area_id IN (SELECT rental_area_id FROM rental_areas WHERE manager_id = ?)";
        try (PreparedStatement ps1 = connect.prepareStatement(sqlTotal);
             PreparedStatement ps2 = connect.prepareStatement(sqlRented);
             PreparedStatement ps3 = connect.prepareStatement(sqlVacant)) {
            ps1.setInt(1, managerId);
            ps2.setInt(1, managerId);
            ps3.setInt(1, managerId);
            try (ResultSet rs1 = ps1.executeQuery()) {
                if (rs1.next()) totalRooms = rs1.getInt(1);
            }
            try (ResultSet rs2 = ps2.executeQuery()) {
                if (rs2.next()) rentedRooms = rs2.getInt(1);
            }
            try (ResultSet rs3 = ps3.executeQuery()) {
                if (rs3.next()) vacantRooms = rs3.getInt(1);
            }
        } catch (SQLException e) {
            System.err.println("Lỗi thống kê phòng cho manager: " + e.getMessage());
        }
        return new int[]{totalRooms, rentedRooms, vacantRooms};
    }

    // Get all rooms
    public ArrayList<Rooms> getAllRooms() {
        ArrayList<Rooms> rooms = new ArrayList<>();
        String sql = "SELECT * FROM dbo.rooms JOIN dbo.rental_areas ON rental_areas.rental_area_id = rooms.rental_area_id";

        try (PreparedStatement statement = connect.prepareStatement(sql); ResultSet rs = statement.executeQuery()) {

            while (rs.next()) {
                RentalArea ren = new RentalArea();
                ren.setName(rs.getString("name"));
                Rooms room = new Rooms();
                room.setRoomId(rs.getInt("room_id"));
                
                room.setRentalAreaId(rs.getInt("rental_area_id"));
                room.setRoomNumber(rs.getString("room_number"));
                room.setArea(rs.getBigDecimal("area"));
                room.setPrice(rs.getBigDecimal("price"));
                room.setMaxTenants(rs.getInt("max_tenants"));
                room.setStatus(rs.getInt("status"));
                room.setDescription(rs.getString("description"));
                room.setRetalArea(ren);
                rooms.add(room);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return rooms;
    }

    // Get room by ID
    public Rooms getRoomById(int roomId) {
        String sql = "SELECT * FROM rooms WHERE room_id = ?";
        try (PreparedStatement ps = connect.prepareStatement(sql)) {
            ps.setInt(1, roomId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                Rooms room = new Rooms();
                room.setRoomId(rs.getInt("room_id"));
                room.setRentalAreaId(rs.getInt("rental_area_id"));
                room.setRoomNumber(rs.getString("room_number"));
                room.setArea(rs.getBigDecimal("area"));
                room.setPrice(rs.getBigDecimal("price"));
                room.setMaxTenants(rs.getInt("max_tenants"));
                room.setStatus(rs.getInt("status"));
                room.setDescription(rs.getString("description"));
                room.setImageUrl(rs.getString("imageUrl"));
                return room;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // Add a new room
    public boolean addRoom(Rooms room) {
        // First check if the rental area exists
        String checkSql = "SELECT COUNT(*) FROM rental_areas WHERE rental_area_id = ?";
        try (PreparedStatement checkPs = connect.prepareStatement(checkSql)) {
            checkPs.setInt(1, room.getRentalAreaId());
            ResultSet rs = checkPs.executeQuery();
            if (rs.next() && rs.getInt(1) == 0) {
                // Rental area doesn't exist
                System.err.println("Rental area with ID " + room.getRentalAreaId() + " doesn't exist");
                return false;
            }
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }

        // Proceed with insertion if rental area exists
        String sql = "INSERT INTO rooms (rental_area_id, room_number, area, price, max_tenants, status, description) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (PreparedStatement ps = connect.prepareStatement(sql)) {
            ps.setInt(1, room.getRentalAreaId());
            ps.setString(2, room.getRoomNumber());
            ps.setBigDecimal(3, room.getArea());
            ps.setBigDecimal(4, room.getPrice());
            ps.setInt(5, room.getMaxTenants());
            ps.setInt(6, room.getStatus());
            ps.setString(7, room.getDescription());

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Update room information
    public boolean updateRoom(Rooms room) {
        String sql = "UPDATE rooms SET rental_area_id = ?, room_number = ?, area = ?, price = ?, "
                + "max_tenants = ?, status = ?, description = ? WHERE room_id = ?";
        try (PreparedStatement ps = connect.prepareStatement(sql)) {
            ps.setInt(1, room.getRentalAreaId());
            ps.setString(2, room.getRoomNumber());
            ps.setBigDecimal(3, room.getArea());
            ps.setBigDecimal(4, room.getPrice());
            ps.setInt(5, room.getMaxTenants());
            ps.setInt(6, room.getStatus());
            ps.setString(7, room.getDescription());
            ps.setInt(8, room.getRoomId());

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Change room status
    public boolean changeRoomStatus(int roomId, int status) {
        String sql = "UPDATE rooms SET status = ? WHERE room_id = ?";
        try (PreparedStatement ps = connect.prepareStatement(sql)) {
            ps.setInt(1, status);
            ps.setInt(2, roomId);

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Cập nhật trạng thái phòng (0: Available, 1: Occupied, 2: Maintenance)
    public boolean updateRoomStatus(int roomId, int status) {
        String sql = "UPDATE rooms SET status = ? WHERE room_id = ?";
        try (PreparedStatement ps = connect.prepareStatement(sql)) {
            ps.setInt(1, status);
            ps.setInt(2, roomId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            throw new RuntimeException("Error updating room status: " + e.getMessage(), e);
        }
    }

    // Get rooms by page (for pagination) - support multiple rentalAreaIds
    public ArrayList<Rooms> getRoomsByPage(int page, int roomsPerPage, List<Integer> rentalAreaIds) {
        ArrayList<Rooms> rooms = new ArrayList<>();
        if (rentalAreaIds == null || rentalAreaIds.isEmpty()) return rooms;
        StringBuilder sql = new StringBuilder("SELECT r.*, ra.name as rental_area_name "
                + "FROM rooms r JOIN rental_areas ra ON r.rental_area_id = ra.rental_area_id "
                + "WHERE r.rental_area_id IN (");
        for (int i = 0; i < rentalAreaIds.size(); i++) {
            sql.append("?");
            if (i < rentalAreaIds.size() - 1) sql.append(",");
        }
        sql.append(") ORDER BY r.room_id OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");
        try (PreparedStatement ps = connect.prepareStatement(sql.toString())) {
            int idx = 1;
            for (Integer id : rentalAreaIds) {
                ps.setInt(idx++, id);
            }
            ps.setInt(idx++, (page - 1) * roomsPerPage);
            ps.setInt(idx, roomsPerPage);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Rooms room = new Rooms();
                room.setRoomId(rs.getInt("room_id"));
                room.setRentalAreaId(rs.getInt("rental_area_id"));
                room.setRoomNumber(rs.getString("room_number"));
                room.setArea(rs.getBigDecimal("area"));
                room.setPrice(rs.getBigDecimal("price"));
                room.setMaxTenants(rs.getInt("max_tenants"));
                room.setStatus(rs.getInt("status"));
                room.setDescription(rs.getString("description"));
                room.setRentalAreaName(rs.getString("rental_area_name"));
                rooms.add(room);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return rooms;
    }

    // Get total count of rooms (for pagination) - support multiple rentalAreaIds
    public int getTotalRooms(List<Integer> rentalAreaIds) {
        if (rentalAreaIds == null || rentalAreaIds.isEmpty()) return 0;
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM rooms WHERE rental_area_id IN (");
        for (int i = 0; i < rentalAreaIds.size(); i++) {
            sql.append("?");
            if (i < rentalAreaIds.size() - 1) sql.append(",");
        }
        sql.append(")");
        try (PreparedStatement ps = connect.prepareStatement(sql.toString())) {
            int idx = 1;
            for (Integer id : rentalAreaIds) {
                ps.setInt(idx++, id);
            }
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    // Search rooms by room number or description - support multiple rentalAreaIds
    public ArrayList<Rooms> searchRooms(String searchTerm, List<Integer> rentalAreaIds) {
        ArrayList<Rooms> rooms = new ArrayList<>();
        if (rentalAreaIds == null || rentalAreaIds.isEmpty()) return rooms;
        StringBuilder sql = new StringBuilder("SELECT r.*, ra.name as rental_area_name "
                + "FROM rooms r JOIN rental_areas ra ON r.rental_area_id = ra.rental_area_id "
                + "WHERE r.rental_area_id IN (");
        for (int i = 0; i < rentalAreaIds.size(); i++) {
            sql.append("?");
            if (i < rentalAreaIds.size() - 1) sql.append(",");
        }
        sql.append(") AND (LOWER(r.room_number) LIKE ? OR LOWER(r.description) LIKE ?)");
        try (PreparedStatement ps = connect.prepareStatement(sql.toString())) {
            int idx = 1;
            for (Integer id : rentalAreaIds) {
                ps.setInt(idx++, id);
            }
            String searchPattern = "%" + searchTerm.toLowerCase() + "%";
            ps.setString(idx++, searchPattern);
            ps.setString(idx, searchPattern);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Rooms room = new Rooms();
                room.setRoomId(rs.getInt("room_id"));
                room.setRentalAreaId(rs.getInt("rental_area_id"));
                room.setRoomNumber(rs.getString("room_number"));
                room.setArea(rs.getBigDecimal("area"));
                room.setPrice(rs.getBigDecimal("price"));
                room.setMaxTenants(rs.getInt("max_tenants"));
                room.setStatus(rs.getInt("status"));
                room.setDescription(rs.getString("description"));
                room.setRentalAreaName(rs.getString("rental_area_name"));
                rooms.add(room);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return rooms;
    }

    // Get rooms by status - support multiple rentalAreaIds
    public ArrayList<Rooms> getRoomsByStatus(int status, List<Integer> rentalAreaIds, int page, int roomsPerPage) {
        ArrayList<Rooms> rooms = new ArrayList<>();
        if (rentalAreaIds == null || rentalAreaIds.isEmpty()) return rooms;
        StringBuilder sql = new StringBuilder("SELECT r.*, ra.name as rental_area_name " +
                "FROM rooms r JOIN rental_areas ra ON r.rental_area_id = ra.rental_area_id " +
                "WHERE r.rental_area_id IN (");
        for (int i = 0; i < rentalAreaIds.size(); i++) {
            sql.append("?");
            if (i < rentalAreaIds.size() - 1) sql.append(",");
        }
        sql.append(") AND r.status = ? ORDER BY r.room_id OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");
        try (PreparedStatement ps = connect.prepareStatement(sql.toString())) {
            int idx = 1;
            for (Integer id : rentalAreaIds) {
                ps.setInt(idx++, id);
            }
            ps.setInt(idx++, status);
            ps.setInt(idx++, (page - 1) * roomsPerPage);
            ps.setInt(idx, roomsPerPage);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Rooms room = new Rooms();
                room.setRoomId(rs.getInt("room_id"));
                room.setRentalAreaId(rs.getInt("rental_area_id"));
                room.setRoomNumber(rs.getString("room_number"));
                room.setArea(rs.getBigDecimal("area"));
                room.setPrice(rs.getBigDecimal("price"));
                room.setMaxTenants(rs.getInt("max_tenants"));
                room.setStatus(rs.getInt("status"));
                room.setDescription(rs.getString("description"));
                room.setRentalAreaName(rs.getString("rental_area_name"));
                room.setImageUrl(rs.getString("imageUrl"));
                rooms.add(room);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return rooms;
    }
    public boolean checkExistRoomForManager(int roomID, int userID) {
        String sql = "SELECT COUNT(*) AS count\n"
                + "FROM dbo.rental_areas ra\n"
                + "JOIN dbo.rooms r ON r.rental_area_id = ra.rental_area_id\n"
                + "WHERE ra.manager_id = ? AND r.room_id = ?";
        try (PreparedStatement ps = connect.prepareStatement(sql)) {
            ps.setInt(1, userID);
            ps.setInt(2, roomID);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) { // Di chuyển con trỏ đến hàng đầu tiên
                int count = rs.getInt("count"); // Lấy giá trị cột count
                return count > 0; // Trả về true nếu count > 0
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false; // Trả về false nếu không có kết quả hoặc xảy ra lỗi
    }
    public List<RentalHistory> getTop5RentalHistory(int roomId) {
        List<RentalHistory> historyList = new ArrayList<>();
        String sql = "SELECT TOP 5 RentailHistoryID, RentalID, RoomID, TenantID, TenantName, StartDate, EndDate, RentPrice, Notes, CreatedAt " +
                     "FROM RentalHistory " +
                     "WHERE RoomID = ? " +
                     "ORDER BY StartDate DESC";
        try (PreparedStatement ps = connect.prepareStatement(sql)) {
            ps.setInt(1, roomId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                RentalHistory history = new RentalHistory();
                history.setRentailHistoryID(rs.getInt("RentailHistoryID"));
                history.setRentalID(rs.getInt("RentalID"));
                history.setRoomID(rs.getInt("RoomID"));
                history.setTenantID(rs.getInt("TenantID"));
                history.setTenantName(rs.getString("TenantName"));
                history.setStartDate(rs.getString("StartDate"));
                history.setEndDate(rs.getString("EndDate"));
                history.setRentPrice(rs.getDouble("RentPrice")); // Sử dụng getDouble thay vì getBigDecimal
                history.setNotes(rs.getString("Notes"));
                history.setCreatedAt(rs.getString("CreatedAt"));
                historyList.add(history);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return historyList;
    }
    public ArrayList<Rooms> getRoomsByLocation(String province, String district, String ward, int page, int roomsPerPage) {
        ArrayList<Rooms> rooms = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT r.*, ra.name as rental_area_name " +
                "FROM rooms r " +
                "JOIN rental_areas ra ON r.rental_area_id = ra.rental_area_id " +
                "WHERE 1=1 "); // Bắt đầu với điều kiện luôn đúng để dễ ghép

        // Danh sách tham số
        List<Object> params = new ArrayList<>();

        // Ghép điều kiện lọc
        if (province != null && !province.isEmpty()) {
            sql.append("AND ra.province LIKE ? ");
            params.add("%" + province + "%");
        }
        if (district != null && !district.isEmpty()) {
            sql.append("AND ra.district LIKE ? ");
            params.add("%" + district + "%");
        }
        if (ward != null && !ward.isEmpty()) {
            sql.append("AND ra.ward LIKE ? ");
            params.add("%" + ward + "%");
        }
        sql.append("AND r.status !=1 ");

        sql.append("ORDER BY r.room_id OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");
        params.add((page - 1) * roomsPerPage);
        params.add(roomsPerPage);
        
        try (PreparedStatement ps = connect.prepareStatement(sql.toString())) {
            // Đặt các tham số vào PreparedStatement
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            System.out.println("Em" + sql);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Rooms room = new Rooms();
                room.setRoomId(rs.getInt("room_id"));
                room.setRentalAreaId(rs.getInt("rental_area_id"));
                room.setRoomNumber(rs.getString("room_number"));
                room.setArea(rs.getBigDecimal("area"));
                room.setPrice(rs.getBigDecimal("price"));
                room.setMaxTenants(rs.getInt("max_tenants"));
                room.setStatus(rs.getInt("status"));
                room.setDescription(rs.getString("description"));
                room.setRentalAreaName(rs.getString("rental_area_name"));
                room.setImageUrl(rs.getString("imageUrl"));
                rooms.add(room);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return rooms;
    }

    // Get total rooms by location for pagination
    public int getTotalRoomsByLocation(String province, String district, String ward) {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM rooms r " +
                "JOIN rental_areas ra ON r.rental_area_id = ra.rental_area_id " +
                "WHERE 1=1 "); // Bắt đầu với điều kiện luôn đúng

        // Danh sách tham số
        List<Object> params = new ArrayList<>();

        // Ghép điều kiện lọc
        if (province != null && !province.isEmpty()) {
            sql.append("AND ra.province LIKE ? ");
            params.add("%" + province + "%");
        }
        if (district != null && !district.isEmpty()) {
            sql.append("AND ra.district LIKE ? ");
            params.add("%" + district + "%");
        }
        if (ward != null && !ward.isEmpty()) {
            sql.append("AND ra.ward LIKE ? ");
            params.add("%" + ward + "%");
        }

        try (PreparedStatement ps = connect.prepareStatement(sql.toString())) {
            // Đặt các tham số vào PreparedStatement
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
    
    
    // You'll need to add this method to the Rooms model as a transient field
    public static class RoomWithDetails extends Rooms {

        private String rentalAreaName;
        private String currentTenant;

        // Getters and setters
        public String getRentalAreaName() {
            return rentalAreaName;
        }

        public void setRentalAreaName(String rentalAreaName) {
            this.rentalAreaName = rentalAreaName;
        }

        public String getCurrentTenant() {
            return currentTenant;
        }

        public void setCurrentTenant(String currentTenant) {
            this.currentTenant = currentTenant;
        }
    }

    public static void main(String[] args) {
        // Test main method (empty)
    }
}
