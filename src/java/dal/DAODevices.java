package dal;

import jakarta.servlet.http.HttpServletRequest;
import model.Devices;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.Users;

public class DAODevices {

    public static final DAODevices INSTANCE = new DAODevices();
    protected Connection connect;

    public DAODevices() {
        connect = new DBContext().connect; // Initialize connection
    }

    public static long millis = System.currentTimeMillis();
    public static Date today = new Date(millis);

    // Get all devices
    public ArrayList<Devices> getAllDevices() {
        ArrayList<Devices> devices = new ArrayList<>();
        String sql = "SELECT * FROM Device";

        try (PreparedStatement statement = connect.prepareStatement(sql); ResultSet rs = statement.executeQuery()) {
            while (rs.next()) {
                Devices device = new Devices();
                device.setDeviceID(rs.getInt("deviceID"));
                device.setName(rs.getString("Name"));
                device.setQuantity(rs.getInt("Quantity"));
                device.setStatus(rs.getString("status"));
                device.setRoomID(rs.getInt("roomID"));

                devices.add(device);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return devices;
    }

    // Soft delete a device (simulated by setting status or marking as inactive if no isDelete column)
    public void deleteDevices(int deleteId, int userId) {
        // Since there is no isDelete column, we can update status to 'Deleted' or similar
        String sql = "UPDATE Device SET status = ? WHERE deviceID = ?";
        try (PreparedStatement ps = connect.prepareStatement(sql)) {
            ps.setString(1, "Deleted"); // Mark as deleted by updating status
            ps.setInt(2, deleteId);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // Update device information
    public void updateDevices(Devices device) {
        String sql = "UPDATE Device SET Name = ?, Quantity = ?, status = ?, roomID = ? WHERE deviceID = ?";
        try (PreparedStatement ps = connect.prepareStatement(sql)) {
            ps.setString(1, device.getName());
            ps.setInt(2, device.getQuantity());
            ps.setString(3, device.getStatus());
            ps.setInt(4, device.getRoomID());
            ps.setInt(5, device.getDeviceID());
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    // Add a new device and return the generated deviceID
    public int addDevices(Devices device, int userId) {
        String sql = "INSERT INTO Device (Name, Quantity, status, roomID) VALUES (?, ?, ?, ?)";
        try (PreparedStatement ps = connect.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, device.getName());
            ps.setInt(2, device.getQuantity());
            ps.setString(3, device.getStatus());
            ps.setInt(4, device.getRoomID());

            ps.executeUpdate();

            ResultSet generatedKeys = ps.getGeneratedKeys();
            if (generatedKeys.next()) {
                return generatedKeys.getInt(1); // Return new device ID
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return -1; // Return -1 if error occurs
    }

    // Get device by ID
    public Devices getDevicesByID(int ID) throws Exception {
        String query = "SELECT * FROM Device WHERE deviceID = ?";
        try (PreparedStatement ps = connect.prepareStatement(query)) {
            ps.setInt(1, ID);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                Devices d = new Devices();
                d.setDeviceID(rs.getInt("deviceID"));
                d.setName(rs.getString("Name"));
                d.setQuantity(rs.getInt("Quantity"));
                d.setStatus(rs.getString("status"));
                d.setRoomID(rs.getInt("roomID"));
                return d;
            }
        }
        return null; // Return null if device not found
    }

    // Get devices by page (for pagination)
    public ArrayList<Devices> getDevicesByPage(int page, int devicesPerPage) {
        ArrayList<Devices> devices = new ArrayList<>();
        String sql = "SELECT * FROM Device ORDER BY deviceID OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";

        try (PreparedStatement ps = connect.prepareStatement(sql)) {
            ps.setInt(1, (page - 1) * devicesPerPage);
            ps.setInt(2, devicesPerPage);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Devices device = new Devices();
                device.setDeviceID(rs.getInt("deviceID"));
                device.setName(rs.getString("Name"));
                device.setQuantity(rs.getInt("Quantity"));
                device.setStatus(rs.getString("status"));
                device.setRoomID(rs.getInt("roomID"));

                devices.add(device);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return devices;
    }

    // Alternative version of getDevicesByPage
    public ArrayList<Devices> getDevicesByPage2(int page, int devicesPerPage) {
        ArrayList<Devices> devices = new ArrayList<>();
        String sql = "SELECT * FROM Device ORDER BY deviceID OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";

        try (PreparedStatement ps = connect.prepareStatement(sql)) {
            ps.setInt(1, (page - 1) * devicesPerPage);
            ps.setInt(2, devicesPerPage);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Devices device = new Devices();
                device.setDeviceID(rs.getInt("deviceID"));
                device.setName(rs.getString("Name"));
                device.setQuantity(rs.getInt("Quantity"));
                device.setStatus(rs.getString("status"));
                device.setRoomID(rs.getInt("roomID"));

                devices.add(device);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return devices;
    }

    // Search devices by any information
    public ArrayList<Devices> getDevicesBySearch(String information) {
        information = information.toLowerCase();
        ArrayList<Devices> devices = new ArrayList<>();
        String sql = "SELECT * FROM Device";

        try (PreparedStatement statement = connect.prepareStatement(sql); ResultSet rs = statement.executeQuery()) {
            while (rs.next()) {
                Devices device = new Devices();
                device.setDeviceID(rs.getInt("deviceID"));
                device.setName(rs.getString("Name"));
                device.setQuantity(rs.getInt("Quantity"));
                device.setStatus(rs.getString("status"));
                device.setRoomID(rs.getInt("roomID"));

                // Create string with all device information for searching
                String deviceData = (device.getName() + " "
                        + device.getStatus() + " "
                        + device.getQuantity() + " "
                        + device.getRoomID() + " ").toLowerCase();

                if (deviceData.contains(information)) {
                    devices.add(device);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return devices;
    }

    // Search devices by name
    public ArrayList<Devices> searchDevicesByName(String name) {
        ArrayList<Devices> devices = new ArrayList<>();
        String sql = "SELECT * FROM Device WHERE Name LIKE ?";

        try (PreparedStatement ps = connect.prepareStatement(sql)) {
            ps.setString(1, "%" + name + "%");
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Devices device = new Devices();
                device.setDeviceID(rs.getInt("deviceID"));
                device.setName(rs.getString("Name"));
                device.setQuantity(rs.getInt("Quantity"));
                device.setStatus(rs.getString("status"));
                device.setRoomID(rs.getInt("roomID"));

                devices.add(device);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return devices;
    }

    // Optional: Get total count of devices (for pagination)
    public int getTotalDevices() {
        String sql = "SELECT COUNT(*) FROM Device";
        try (PreparedStatement ps = connect.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
    
    public static void main(String[] args) {
        DAODevices dao = DAODevices.INSTANCE;
    }
}