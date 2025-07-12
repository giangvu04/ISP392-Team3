package dal;

import model.DeviceInRoom;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

public class DAODeviceInRoom {

    public static final DAODeviceInRoom INSTANCE = new DAODeviceInRoom();
    protected Connection connect;

    public DAODeviceInRoom() {
        connect = new DBContext().connect;
    }

    // Get all devices in rooms
    public ArrayList<DeviceInRoom> getAllDevicesInRooms() {
        ArrayList<DeviceInRoom> devicesInRooms = new ArrayList<>();
        String sql = """
            SELECT d.[device_id], d.[device_name], dir.[room_id], dir.[quantity], dir.[status]
            FROM [HouseSharing].[dbo].[devices] d
            INNER JOIN [HouseSharing].[dbo].[devices_in_room] dir ON d.[device_id] = dir.[device_id]
            ORDER BY dir.[room_id], d.[device_name]
            """;

        try (PreparedStatement ps = connect.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                DeviceInRoom deviceInRoom = new DeviceInRoom();
                deviceInRoom.setDeviceId(rs.getInt("device_id"));
                deviceInRoom.setDeviceName(rs.getString("device_name"));
                deviceInRoom.setRoomId(rs.getInt("room_id"));
                deviceInRoom.setQuantity(rs.getInt("quantity"));
                deviceInRoom.setStatus(rs.getString("status"));
                devicesInRooms.add(deviceInRoom);
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error fetching devices in rooms: " + e.getMessage(), e);
        }
        return devicesInRooms;
    }

    // Get devices by room ID
    public ArrayList<DeviceInRoom> getDevicesByRoomId(int roomId) {
        if (roomId <= 0) {
            throw new IllegalArgumentException("Invalid room ID");
        }

        ArrayList<DeviceInRoom> devicesInRoom = new ArrayList<>();
        String sql = """
            SELECT d.[device_id], d.[device_name], dir.[room_id], dir.[quantity], dir.[status]
            FROM [HouseSharing].[dbo].[devices] d
            INNER JOIN [HouseSharing].[dbo].[devices_in_room] dir ON d.[device_id] = dir.[device_id]
            WHERE dir.[room_id] = ?
            ORDER BY d.[device_name]
            """;

        try (PreparedStatement ps = connect.prepareStatement(sql)) {
            ps.setInt(1, roomId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                DeviceInRoom deviceInRoom = new DeviceInRoom();
                deviceInRoom.setDeviceId(rs.getInt("device_id"));
                deviceInRoom.setDeviceName(rs.getString("device_name"));
                deviceInRoom.setRoomId(rs.getInt("room_id"));
                deviceInRoom.setQuantity(rs.getInt("quantity"));
                deviceInRoom.setStatus(rs.getString("status"));
                devicesInRoom.add(deviceInRoom);
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error fetching devices by room ID: " + e.getMessage(), e);
        }
        return devicesInRoom;
    }

    // Add device to room
    public void addDeviceToRoom(DeviceInRoom deviceInRoom) {
        if (deviceInRoom.getRoomId() <= 0 || deviceInRoom.getDeviceId() <= 0||
            deviceInRoom.getStatus() == null || deviceInRoom.getStatus().trim().isEmpty()) {
            throw new IllegalArgumentException("Invalid device in room data");
        }

        String sql = """
            INSERT INTO [HouseSharing].[dbo].[devices_in_room] ([room_id], [device_id], [status]) 
            VALUES (?, ?, ?)
            """;
        try (PreparedStatement ps = connect.prepareStatement(sql)) {
            ps.setInt(1, deviceInRoom.getRoomId());
            ps.setInt(2, deviceInRoom.getDeviceId());
            ps.setString(3, deviceInRoom.getStatus());
            ps.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException("Error adding device to room: " + e.getMessage(), e);
        }
    }

    // Update device in room
    public void updateDeviceInRoom(DeviceInRoom deviceInRoom) {
        if (deviceInRoom.getRoomId() <= 0 || deviceInRoom.getDeviceId() <= 0 || deviceInRoom.getQuantity() <= 0 ||
            deviceInRoom.getStatus() == null || deviceInRoom.getStatus().trim().isEmpty()) {
            throw new IllegalArgumentException("Invalid device in room data");
        }

        String sql = """
            UPDATE [HouseSharing].[dbo].[devices_in_room] 
            SET [quantity] = ?, [status] = ? 
            WHERE [room_id] = ? AND [device_id] = ?
            """;
        try (PreparedStatement ps = connect.prepareStatement(sql)) {
            ps.setInt(1, deviceInRoom.getQuantity());
            ps.setString(2, deviceInRoom.getStatus());
            ps.setInt(3, deviceInRoom.getRoomId());
            ps.setInt(4, deviceInRoom.getDeviceId());
            int rowsAffected = ps.executeUpdate();
            if (rowsAffected == 0) {
                throw new SQLException("No device in room found with room ID: " + deviceInRoom.getRoomId() +
                                      " and device ID: " + deviceInRoom.getDeviceId());
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error updating device in room: " + e.getMessage(), e);
        }
    }

    // Remove device from room (soft delete)
    public void removeDeviceFromRoom(int deviceId, int roomId) {
        if (deviceId <= 0 || roomId <= 0) {
            throw new IllegalArgumentException("Invalid device or room ID");
        }

        String sql = """
            UPDATE [HouseSharing].[dbo].[devices_in_room] 
            SET [status] = 'Ngưng hoạt động' 
            WHERE [device_id] = ? AND [room_id] = ?
            """;
        try (PreparedStatement ps = connect.prepareStatement(sql)) {
            ps.setInt(1, deviceId);
            ps.setInt(2, roomId);
            int rowsAffected = ps.executeUpdate();
            if (rowsAffected == 0) {
                throw new SQLException("No device in room found with room ID: " + roomId +
                                      " and device ID: " + deviceId);
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error removing device from room: " + e.getMessage(), e);
        }
    }
    
    public void deleteDeviceFromRoom(int deviceId, int roomId) {
        if (deviceId <= 0 || roomId <= 0) {
            throw new IllegalArgumentException("Invalid device or room ID");
        }

        String sql = """
            DELETE FROM [HouseSharing].[dbo].[devices_in_room] 
            WHERE [device_id] = ? AND [room_id] = ?
            """;
        try (PreparedStatement ps = connect.prepareStatement(sql)) {
            ps.setInt(1, deviceId);
            ps.setInt(2, roomId);
            int rowsAffected = ps.executeUpdate();
            if (rowsAffected == 0) {
                throw new SQLException("No device in room found with room ID: " + roomId +
                                      " and device ID: " + deviceId);
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error removing device from room: " + e.getMessage(), e);
        }
    }

    // Check if a device is in use in any room
    public boolean isDeviceInUse(int deviceId) {
        if (deviceId <= 0) {
            throw new IllegalArgumentException("Invalid device ID");
        }

        String sql = "SELECT COUNT(*) FROM [HouseSharing].[dbo].[devices_in_room] WHERE [device_id] = ?";
        try (PreparedStatement ps = connect.prepareStatement(sql)) {
            ps.setInt(1, deviceId);
            ResultSet rs = ps.executeQuery();
            if (rs.next() && rs.getInt(1) > 0) {
                return true;
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error checking device usage: " + e.getMessage(), e);
        }
        return false;
    }

    // Get devices in rooms with pagination
    public ArrayList<DeviceInRoom> getDevicesInRoomsByPage(int page, int devicesPerPage) {
        if (page < 1 || devicesPerPage <= 0) {
            throw new IllegalArgumentException("Invalid page or devices per page");
        }

        ArrayList<DeviceInRoom> devicesInRooms = new ArrayList<>();
        String sql = """
            SELECT d.[device_id], d.[device_name], dir.[room_id], dir.[quantity], dir.[status]
            FROM [HouseSharing].[dbo].[devices] d
            INNER JOIN [HouseSharing].[dbo].[devices_in_room] dir ON d.[device_id] = dir.[device_id]
            ORDER BY dir.[room_id], d.[device_name]
            OFFSET ? ROWS FETCH NEXT ? ROWS ONLY
            """;

        try (PreparedStatement ps = connect.prepareStatement(sql)) {
            ps.setInt(1, (page - 1) * devicesPerPage);
            ps.setInt(2, devicesPerPage);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                DeviceInRoom deviceInRoom = new DeviceInRoom();
                deviceInRoom.setDeviceId(rs.getInt("device_id"));
                deviceInRoom.setDeviceName(rs.getString("device_name"));
                deviceInRoom.setRoomId(rs.getInt("room_id"));
                deviceInRoom.setQuantity(rs.getInt("quantity"));
                deviceInRoom.setStatus(rs.getString("status"));
                devicesInRooms.add(deviceInRoom);
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error fetching devices by page: " + e.getMessage(), e);
        }
        return devicesInRooms;
    }

    // Search devices in rooms
    public ArrayList<DeviceInRoom> searchDevicesInRooms(String keyword) {
        if (keyword == null || keyword.trim().isEmpty()) {
            throw new IllegalArgumentException("Search keyword cannot be empty");
        }

        ArrayList<DeviceInRoom> devicesInRooms = new ArrayList<>();
        String sql = """
            SELECT d.[device_id], d.[device_name], dir.[room_id], dir.[quantity], dir.[status]
            FROM [HouseSharing].[dbo].[devices] d
            INNER JOIN [HouseSharing].[dbo].[devices_in_room] dir ON d.[device_id] = dir.[device_id]
            WHERE LOWER(d.[device_name]) LIKE ? 
               OR LOWER(dir.[status]) LIKE ?
            ORDER BY dir.[room_id], d.[device_name]
            """;

        try (PreparedStatement ps = connect.prepareStatement(sql)) {
            String searchPattern = "%" + keyword.toLowerCase() + "%";
            ps.setString(1, searchPattern);
            ps.setString(2, searchPattern);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                DeviceInRoom deviceInRoom = new DeviceInRoom();
                deviceInRoom.setDeviceId(rs.getInt("device_id"));
                deviceInRoom.setDeviceName(rs.getString("device_name"));
                deviceInRoom.setRoomId(rs.getInt("room_id"));
                deviceInRoom.setQuantity(rs.getInt("quantity"));
                deviceInRoom.setStatus(rs.getString("status"));
                devicesInRooms.add(deviceInRoom);
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error searching devices in rooms: " + e.getMessage(), e);
        }
        return devicesInRooms;
    }

    // Get total count of devices in rooms
    public int getTotalDevicesInRooms() {
        String sql = """
            SELECT COUNT(*) 
            FROM [HouseSharing].[dbo].[devices] d
            INNER JOIN [HouseSharing].[dbo].[devices_in_room] dir ON d.[device_id] = dir.[device_id]
            """;
        try (PreparedStatement ps = connect.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error counting devices in rooms: " + e.getMessage(), e);
        }
        return 0;
    }
}