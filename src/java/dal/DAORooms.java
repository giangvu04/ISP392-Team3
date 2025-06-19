package dal;

import model.Rooms;
import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class DAORooms {
    public static final DAORooms INSTANCE = new DAORooms();
    protected Connection connect;

    public DAORooms() {
        connect = new DBContext().connect;
    }

    // Get all rooms
    public ArrayList<Rooms> getAllRooms() {
        ArrayList<Rooms> rooms = new ArrayList<>();
        String sql = "SELECT * FROM rooms";

        try (PreparedStatement statement = connect.prepareStatement(sql); 
             ResultSet rs = statement.executeQuery()) {

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
                return room;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // Add a new room
    public boolean addRoom(Rooms room) {
        String sql = "INSERT INTO rooms (rental_area_id, room_number, area, price, max_tenants, status, description) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?)";
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
        String sql = "UPDATE rooms SET rental_area_id = ?, room_number = ?, area = ?, price = ?, " +
                     "max_tenants = ?, status = ?, description = ? WHERE room_id = ?";
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

    // Get rooms by page (for pagination)
    public ArrayList<Rooms> getRoomsByPage(int page, int roomsPerPage, int rentalAreaId) {
        ArrayList<Rooms> rooms = new ArrayList<>();
        String sql = "SELECT r.*, ra.area_name as rental_area_name " +
                     "FROM rooms r JOIN rental_areas ra ON r.rental_area_id = ra.rental_area_id " +
                     "WHERE r.rental_area_id = ? " +
                     "ORDER BY r.room_id OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";

        try (PreparedStatement ps = connect.prepareStatement(sql)) {
            ps.setInt(1, rentalAreaId);
            ps.setInt(2, (page - 1) * roomsPerPage);
            ps.setInt(3, roomsPerPage);
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
                // Additional field for display
                room.setRentalAreaName(rs.getString("rental_area_name"));
                
                rooms.add(room);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return rooms;
    }

    // Get total count of rooms (for pagination)
    public int getTotalRooms(int rentalAreaId) {
        String sql = "SELECT COUNT(*) FROM rooms WHERE rental_area_id = ?";
        try (PreparedStatement ps = connect.prepareStatement(sql)) {
            ps.setInt(1, rentalAreaId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    // Search rooms by room number or description
    public ArrayList<Rooms> searchRooms(String searchTerm, int rentalAreaId) {
        ArrayList<Rooms> rooms = new ArrayList<>();
        String sql = "SELECT r.*, ra.area_name as rental_area_name " +
                     "FROM rooms r JOIN rental_areas ra ON r.rental_area_id = ra.rental_area_id " +
                     "WHERE r.rental_area_id = ? AND " +
                     "(LOWER(r.room_number) LIKE ? OR LOWER(r.description) LIKE ?)";

        try (PreparedStatement ps = connect.prepareStatement(sql)) {
            String searchPattern = "%" + searchTerm.toLowerCase() + "%";
            ps.setInt(1, rentalAreaId);
            ps.setString(2, searchPattern);
            ps.setString(3, searchPattern);
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

    // Get rooms by status
    public ArrayList<Rooms> getRoomsByStatus(int status, int rentalAreaId) {
        ArrayList<Rooms> rooms = new ArrayList<>();
        String sql = "SELECT r.*, ra.area_name as rental_area_name " +
                     "FROM rooms r JOIN rental_areas ra ON r.rental_area_id = ra.rental_area_id " +
                     "WHERE r.rental_area_id = ? AND r.status = ?";

        try (PreparedStatement ps = connect.prepareStatement(sql)) {
            ps.setInt(1, rentalAreaId);
            ps.setInt(2, status);
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
        DAORooms dao = DAORooms.INSTANCE;
    }
}
