package dal;

import model.Devices;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class DAODevices {

    public static final DAODevices INSTANCE = new DAODevices();
    protected Connection connect;

    public DAODevices() {
        connect = new DBContext().connect;
    }

    // Get all devices
    public List<Devices> getAllDevices() {
        List<Devices> devices = new ArrayList<>();
        // Sửa tên bảng để nhất quán
        String sql = "SELECT [device_id], [device_name] FROM [HouseSharing].[dbo].[devices]";

        try (PreparedStatement statement = connect.prepareStatement(sql);
             ResultSet rs = statement.executeQuery()) {
            while (rs.next()) {
                Devices device = new Devices();
                device.setDeviceId(rs.getInt("device_id"));
                device.setDeviceName(rs.getString("device_name"));
                devices.add(device);
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error fetching all devices: " + e.getMessage(), e);
        }
        return devices;
    }

    // Get devices with pagination
    public List<Devices> getDevicesByPage(int page, int devicesPerPage) {
        if (page < 1 || devicesPerPage <= 0) {
            throw new IllegalArgumentException("Invalid page or devices per page");
        }

        List<Devices> devices = new ArrayList<>();
        String sql = """
            SELECT [device_id], [device_name] 
            FROM [HouseSharing].[dbo].[devices]
            ORDER BY [device_name]
            OFFSET ? ROWS FETCH NEXT ? ROWS ONLY
            """;

        try (PreparedStatement ps = connect.prepareStatement(sql)) {
            ps.setInt(1, (page - 1) * devicesPerPage);
            ps.setInt(2, devicesPerPage);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                Devices device = new Devices();
                device.setDeviceId(rs.getInt("device_id"));
                device.setDeviceName(rs.getString("device_name"));
                devices.add(device);
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error fetching devices by page: " + e.getMessage(), e);
        }
        return devices;
    }

    // Soft delete a device
    public void deleteDevice(int deviceId, int userId) {
        if (deviceId <= 0) {
            throw new IllegalArgumentException("Invalid device ID");
        }

        // Kiểm tra xem thiết bị có đang được sử dụng không
        DAODeviceInRoom daoDir = new DAODeviceInRoom();
        if (daoDir.isDeviceInUse(deviceId)) {
            throw new RuntimeException("Cannot delete: Device is currently in use in a room");
        }

        // Soft delete bằng cách thêm "[Deleted]" vào tên
        String sql = "DELETE FROM [HouseSharing].[dbo].[devices] WHERE [device_id] = ?";
        
        try (PreparedStatement ps = connect.prepareStatement(sql)) {
            ps.setInt(1, deviceId);
            int rowsAffected = ps.executeUpdate();
            if (rowsAffected == 0) {
                throw new SQLException("No device found with ID: " + deviceId);
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error deleting device: " + e.getMessage(), e);
        }
    }

    // Update device information
    public void updateDevice(Devices device) {
        if (device == null || device.getDeviceId() <= 0 || 
            device.getDeviceName() == null || device.getDeviceName().trim().isEmpty()) {
            throw new IllegalArgumentException("Invalid device data");
        }

        String sql = """
            UPDATE [HouseSharing].[dbo].[devices] 
            SET [device_name] = ? 
            WHERE [device_id] = ?
            """;
        
        try (PreparedStatement ps = connect.prepareStatement(sql)) {
            ps.setString(1, device.getDeviceName().trim());
            ps.setInt(2, device.getDeviceId());
            int rowsAffected = ps.executeUpdate();
            if (rowsAffected == 0) {
                throw new SQLException("No device found with ID: " + device.getDeviceId());
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error updating device: " + e.getMessage(), e);
        }
    }

    // Add a new device and return the generated deviceId
    public int addDevice(Devices device, int userId) {
        if (device == null || device.getDeviceName() == null || 
            device.getDeviceName().trim().isEmpty()) {
            throw new IllegalArgumentException("Invalid device data");
        }

        String sql = """
            INSERT INTO [HouseSharing].[dbo].[devices] ([device_name]) 
            VALUES (?)
            """;
        
        try (PreparedStatement ps = connect.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, device.getDeviceName().trim());
            ps.executeUpdate();

            try (ResultSet generatedKeys = ps.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    return generatedKeys.getInt(1);
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error adding device: " + e.getMessage(), e);
        }
        return -1;
    }

    // Get device by ID
    public Devices getDeviceById(int deviceId) {
        if (deviceId <= 0) {
            throw new IllegalArgumentException("Invalid device ID");
        }

        String sql = """
            SELECT [device_id], [device_name] 
            FROM [HouseSharing].[dbo].[devices] 
            WHERE [device_id] = ?
            """;
        
        try (PreparedStatement ps = connect.prepareStatement(sql)) {
            ps.setInt(1, deviceId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                Devices device = new Devices();
                device.setDeviceId(rs.getInt("device_id"));
                device.setDeviceName(rs.getString("device_name"));
                return device;
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error fetching device by ID: " + e.getMessage(), e);
        }
        return null;
    }

    // Search devices by name
    public List<Devices> searchDevicesByName(String name) {
        if (name == null || name.trim().isEmpty()) {
            throw new IllegalArgumentException("Search name cannot be empty");
        }

        List<Devices> devices = new ArrayList<>();
        String sql = """
            SELECT [device_id], [device_name] 
            FROM [HouseSharing].[dbo].[devices] 
            WHERE LOWER([device_name]) LIKE ?
            ORDER BY [device_name]
            """;

        try (PreparedStatement ps = connect.prepareStatement(sql)) {
            ps.setString(1, "%" + name.toLowerCase() + "%");
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Devices device = new Devices();
                device.setDeviceId(rs.getInt("device_id"));
                device.setDeviceName(rs.getString("device_name"));
                devices.add(device);
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error searching devices: " + e.getMessage(), e);
        }
        return devices;
    }

    // Get total count of devices (for pagination)
    public int getTotalDevices() {
        String sql = "SELECT COUNT(*) FROM [HouseSharing].[dbo].[devices]";
        try (PreparedStatement ps = connect.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error counting devices: " + e.getMessage(), e);
        }
        return 0;
    }

    // Check if device name already exists
    public boolean isDeviceNameExists(String deviceName, int excludeId) {
        if (deviceName == null || deviceName.trim().isEmpty()) {
            return false;
        }

        String sql = """
            SELECT COUNT(*) 
            FROM [HouseSharing].[dbo].[devices] 
            WHERE LOWER([device_name]) = ? AND [device_id] != ?
            """;
        
        try (PreparedStatement ps = connect.prepareStatement(sql)) {
            ps.setString(1, deviceName.toLowerCase().trim());
            ps.setInt(2, excludeId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error checking device name existence: " + e.getMessage(), e);
        }
        return false;
    }
}