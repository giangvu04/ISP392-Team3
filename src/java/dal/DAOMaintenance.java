

package dal;

import java.sql.*;
import java.util.*;
import model.MaintenanceLog;

public class DAOMaintenance extends DBContext {
    
    public static final DAOMaintenance INSTANCE = new DAOMaintenance();
    protected Connection connect;

    public DAOMaintenance() {
        connect = new DBContext().connect;
    }

    // Thêm báo lỗi vào bảng maintenance_logs
    public void addMaintenanceLog(int rentalAreaId, Integer roomId, String title, String description, Timestamp maintenanceDate, int createdBy) throws SQLException {
        String sql = "INSERT INTO maintenance_logs (rental_area_id, room_id, title, description, maintenance_date, cost, created_by, created_at, status, owner_note) " +
                     "VALUES (?, ?, ?, ?, ?, 0, ?, GETDATE(), N'pending', NULL)";
        try (PreparedStatement ps = connect.prepareStatement(sql)) {
            ps.setInt(1, rentalAreaId);
            if (roomId == null) {
                ps.setNull(2, java.sql.Types.INTEGER);
            } else {
                ps.setInt(2, roomId);
            }
            ps.setString(3, title);
            ps.setString(4, description);
            ps.setTimestamp(5, maintenanceDate);
            ps.setInt(6, createdBy);
            ps.executeUpdate();
        }
    }
    public List<MaintenanceLog> getAllLogsWithNames() {
    List<MaintenanceLog> list = new ArrayList<>();
    String sql = "SELECT m.*, ra.name AS rental_area_name, r.room_number AS room_name, u.full_name AS created_by_name " +
            "FROM maintenance_logs m " +
            "JOIN rental_areas ra ON m.rental_area_id = ra.rental_area_id " +
            "LEFT JOIN rooms r ON m.room_id = r.room_id " +
            "JOIN users u ON m.created_by = u.user_id " +
            "ORDER BY m.maintenance_date DESC";
    try (PreparedStatement ps = connect.prepareStatement(sql)) {
        ResultSet rs = ps.executeQuery();
        while (rs.next()) {
            MaintenanceLog log = new MaintenanceLog();
            log.setMaintenanceId(rs.getInt("maintenance_id"));
            log.setRentalAreaId(rs.getInt("rental_area_id"));
            log.setRentalAreaName(rs.getString("rental_area_name"));
            int roomId = rs.getInt("room_id");
            log.setRoomId(rs.wasNull() ? null : roomId);
            log.setRoomName(rs.getString("room_name"));
            log.setTitle(rs.getString("title"));
            log.setDescription(rs.getString("description"));

            // Extract device info and issue description
            String desc = rs.getString("description");
            String deviceInfo = "Không xác định";
            String issueDescription = "Không có mô tả";

            if (desc != null) {
                try {
                    // Split by newline to match format: "Thiết bị: ... \nMô tả sự cố: ..."
                    String[] lines = desc.split("\\n");
                    for (String line : lines) {
                        line = line.trim();
                        if (line.startsWith("Thiết bị:")) {
                            deviceInfo = line.replace("Thiết bị:", "").trim();
                        } else if (line.startsWith("Mô tả sự cố:")) {
                            issueDescription = line.replace("Mô tả sự cố:", "").trim();
                        }
                    }
                    // If no issue description found, use original desc as fallback
                    if (issueDescription.equals("Không có mô tả") && deviceInfo.equals("Không xác định")) {
                        issueDescription = desc;
                    }
                } catch (Exception e) {
                    deviceInfo = "Không xác định";
                    issueDescription = desc; // Fallback: use full description if parsing fails
                    e.printStackTrace();
                }
            }

            log.setDeviceInfo(deviceInfo);
            log.setDescription(issueDescription);
            log.setMaintenanceDate(rs.getTimestamp("maintenance_date"));
            log.setCost(rs.getObject("cost") == null ? null : rs.getDouble("cost"));
            log.setCreatedBy(rs.getInt("created_by"));
            log.setCreatedByName(rs.getString("created_by_name"));
            log.setCreatedAt(rs.getTimestamp("created_at"));
            log.setStatus(rs.getString("status"));
            log.setOwnerNote(rs.getString("owner_note"));
            list.add(log);
        }
    } catch (SQLException e) {
        e.printStackTrace();
    }
    return list;
}
        public List<MaintenanceLog> getLogsByRentalAreaId(int rentalAreaId) {
        List<MaintenanceLog> list = new ArrayList<>();
        String sql = "SELECT m.*, ra.name AS rental_area_name, r.room_number AS room_name, u.full_name AS created_by_name " +
                "FROM maintenance_logs m " +
                "JOIN rental_areas ra ON m.rental_area_id = ra.rental_area_id " +
                "LEFT JOIN rooms r ON m.room_id = r.room_id " +
                "JOIN users u ON m.created_by = u.user_id " +
                "WHERE m.rental_area_id = ? " +
                "ORDER BY m.maintenance_date DESC";
        try (PreparedStatement ps = connect.prepareStatement(sql)) {
            ps.setInt(1, rentalAreaId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                MaintenanceLog log = new MaintenanceLog();
                log.setMaintenanceId(rs.getInt("maintenance_id"));
                log.setRentalAreaId(rs.getInt("rental_area_id"));
                log.setRentalAreaName(rs.getString("rental_area_name"));
                int roomId = rs.getInt("room_id");
                log.setRoomId(rs.wasNull() ? null : roomId);
                log.setRoomName(rs.getString("room_name"));
                log.setTitle(rs.getString("title"));
                log.setDescription(rs.getString("description"));
                log.setMaintenanceDate(rs.getTimestamp("maintenance_date"));
                log.setCost(rs.getObject("cost") == null ? null : rs.getDouble("cost"));
                log.setCreatedBy(rs.getInt("created_by"));
                log.setCreatedByName(rs.getString("created_by_name"));
                log.setCreatedAt(rs.getTimestamp("created_at"));
                list.add(log);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
        public List<MaintenanceLog> getLogsFiltered(int managerId, String startDate, String endDate, String type) {
        List<MaintenanceLog> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT m.*, ra.name AS rental_area_name, r.room_number AS room_name, u.full_name AS created_by_name " +
                "FROM maintenance_logs m " +
                "JOIN rental_areas ra ON m.rental_area_id = ra.rental_area_id " +
                "LEFT JOIN rooms r ON m.room_id = r.room_id " +
                "JOIN users u ON m.created_by = u.user_id " +
                "WHERE ra.manager_id = ?");
        if (startDate != null && !startDate.isEmpty()) sql.append(" AND m.maintenance_date >= ?");
        if (endDate != null && !endDate.isEmpty()) sql.append(" AND m.maintenance_date <= ?");
        if (type != null && !type.isEmpty()) sql.append(" AND m.status = ?");
        sql.append(" ORDER BY m.maintenance_date DESC");
        try (PreparedStatement ps = connect.prepareStatement(sql.toString())) {
            int idx = 1;
            ps.setInt(idx++, managerId);
            if (startDate != null && !startDate.isEmpty()) ps.setString(idx++, startDate);
            if (endDate != null && !endDate.isEmpty()) ps.setString(idx++, endDate);
            if (type != null && !type.isEmpty()) ps.setString(idx++, type);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                MaintenanceLog log = new MaintenanceLog();
                log.setMaintenanceId(rs.getInt("maintenance_id"));
                log.setRentalAreaId(rs.getInt("rental_area_id"));
                log.setRentalAreaName(rs.getString("rental_area_name"));
                int roomId = rs.getInt("room_id");
                log.setRoomId(rs.wasNull() ? null : roomId);
                log.setRoomName(rs.getString("room_name"));
                log.setTitle(rs.getString("title"));
                log.setDescription(rs.getString("description"));
                log.setMaintenanceDate(rs.getTimestamp("maintenance_date"));
                log.setCost(rs.getObject("cost") == null ? null : rs.getDouble("cost"));
                log.setCreatedBy(rs.getInt("created_by"));
                log.setCreatedByName(rs.getString("created_by_name"));
                log.setCreatedAt(rs.getTimestamp("created_at"));
                log.setStatus(rs.getString("status"));
                log.setOwnerNote(rs.getString("owner_note"));
                list.add(log);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
    
    // Update maintenance status and owner note
    public boolean updateMaintenanceStatus(int maintenanceId, String status, String ownerNote) {
        String sql = "UPDATE maintenance_logs SET status = ?, owner_note = ? WHERE maintenance_id = ?";
        
        try (
             PreparedStatement ps = connect.prepareStatement(sql)) {
            
            ps.setString(1, status);
            ps.setString(2, ownerNote);
            ps.setInt(3, maintenanceId);
            
            int result = ps.executeUpdate();
            return result > 0;
            
        } catch (SQLException e) {
            System.err.println("Error updating maintenance status: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
    
    // Get maintenance log by ID
    public MaintenanceLog getMaintenanceLogById(int maintenanceId) {
        String sql = "SELECT m.*, ra.name AS rental_area_name, r.room_number AS room_name, u.full_name AS created_by_name " +
                "FROM maintenance_logs m " +
                "JOIN rental_areas ra ON m.rental_area_id = ra.rental_area_id " +
                "LEFT JOIN rooms r ON m.room_id = r.room_id " +
                "JOIN users u ON m.created_by = u.user_id " +
                "WHERE m.maintenance_id = ?";
        
        try (PreparedStatement ps = connect.prepareStatement(sql)) {
            ps.setInt(1, maintenanceId);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                MaintenanceLog log = new MaintenanceLog();
                log.setMaintenanceId(rs.getInt("maintenance_id"));
                log.setRentalAreaId(rs.getInt("rental_area_id"));
                log.setRentalAreaName(rs.getString("rental_area_name"));
                int roomId = rs.getInt("room_id");
                log.setRoomId(rs.wasNull() ? null : roomId);
                log.setRoomName(rs.getString("room_name"));
                log.setTitle(rs.getString("title"));
                log.setDescription(rs.getString("description"));

                // Extract device info
                String desc = rs.getString("description");
                String deviceInfo = "Không xác định";
                String issueDescription = "Không có mô tả";

                if (desc != null) {
                    try {
                        // Split by newline to match format: "Thiết bị: ... \nMô tả sự cố: ..."
                        String[] lines = desc.split(";");
                        for (String line : lines) {
                            line = line.trim();
                            if (line.startsWith("Thiết bị:")) {
                                deviceInfo = line.replace("Thiết bị:", "").trim();
                            } else if (line.startsWith("Mô tả sự cố:")) {
                                issueDescription = line.replace("Mô tả sự cố:", "").trim();
                            }
                        }
                        // If no issue description found, use original desc as fallback
                        if (issueDescription.equals("Không có mô tả") && deviceInfo.equals("Không xác định")) {
                            issueDescription = desc;
                        }
                    } catch (Exception e) {
                        deviceInfo = "Không xác định";
                        issueDescription = desc;
                    }
                }

                log.setDeviceInfo(deviceInfo);
                log.setDescription(issueDescription);
                log.setMaintenanceDate(rs.getTimestamp("maintenance_date"));
                log.setCost(rs.getObject("cost") == null ? null : rs.getDouble("cost"));
                log.setCreatedBy(rs.getInt("created_by"));
                log.setCreatedByName(rs.getString("created_by_name"));
                log.setCreatedAt(rs.getTimestamp("created_at"));
                log.setStatus(rs.getString("status"));
                log.setOwnerNote(rs.getString("owner_note"));
                
                return log;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
}
