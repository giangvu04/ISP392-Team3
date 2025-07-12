package dal;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.RentalArea;

public class DAORentalArea {

    public static final DAORentalArea INSTANCE = new DAORentalArea();
    protected Connection connect;

    public DAORentalArea() {
        connect = new DBContext().connect;
    }

    // Get rental area by manager ID
    public RentalArea getRentalAreaByManagerId(int managerId) {
        String sql = "SELECT * FROM rental_areas WHERE manager_id = ?";
        try (PreparedStatement ps = connect.prepareStatement(sql)) {
            ps.setInt(1, managerId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                RentalArea area = new RentalArea();
                area.setRentalAreaId(rs.getInt("rental_area_id"));
                area.setManagerId(rs.getInt("manager_id"));
                area.setName(rs.getString("name"));
                area.setAddress(rs.getString("address"));
                area.setCreatedAt(rs.getTimestamp("created_at"));
                return area;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // Returns all rental areas managed by a manager
    public List<RentalArea> getListRentalAreaByManagerId(int managerId) {
        String sql = "SELECT * FROM rental_areas WHERE manager_id = ?";
        List<RentalArea> retail = new ArrayList<>();
        try (PreparedStatement ps = connect.prepareStatement(sql)) {
            ps.setInt(1, managerId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                RentalArea area = new RentalArea();
                area.setRentalAreaId(rs.getInt("rental_area_id"));
                area.setManagerId(rs.getInt("manager_id"));
                area.setName(rs.getString("name"));
                area.setAddress(rs.getString("address"));
                area.setCreatedAt(rs.getTimestamp("created_at"));
                retail.add(area);
            }
            return retail;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public RentalArea getRentalAreaByTenantId(int tenantId) {
        String sql = "SELECT ra.*, r.room_id, r.room_number, r.area, r.price, r.max_tenants, r.status as room_status, r.description, r.imageUrl "
                + "FROM rental_areas ra "
                + "JOIN rooms r ON ra.rental_area_id = r.rental_area_id "
                + "JOIN contracts c ON c.room_id = r.room_id "
                + "WHERE c.tenant_id = ?";
        try (PreparedStatement ps = connect.prepareStatement(sql)) {
            ps.setInt(1, tenantId);
            ResultSet rs = ps.executeQuery();
            RentalArea area = null;
            List<model.Room> rooms = new ArrayList<>();
            while (rs.next()) {
                if (area == null) {
                    area = new RentalArea();
                    area.setRentalAreaId(rs.getInt("rental_area_id"));
                    area.setManagerId(rs.getInt("manager_id"));
                    area.setName(rs.getString("name"));
                    area.setAddress(rs.getString("address"));
                    area.setCreatedAt(rs.getTimestamp("created_at"));
                }
                model.Room room = new model.Room();
                room.setRoomId(rs.getInt("room_id"));
                room.setRentalAreaId(rs.getInt("rental_area_id"));
                room.setRoomNumber(rs.getString("room_number"));
                room.setArea(rs.getBigDecimal("area"));
                room.setPrice(rs.getBigDecimal("price"));
                room.setMaxTenants(rs.getInt("max_tenants"));
                room.setStatus(rs.getInt("room_status"));
                room.setDescription(rs.getString("description"));
                room.setImageUrl(rs.getString("imageUrl"));
                rooms.add(room);
            }
            // Nếu muốn trả về cả danh sách phòng, có thể mở rộng model RentalArea để chứa List<Room>
            // area.setRooms(rooms); // nếu có field này
            return area;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean assignTenantToRentalArea(int tenantId, int rentalAreaId) {
        // Implementation for admin to assign tenants
        return true;
    }

    public boolean isTenantAssigned(int tenantId) {
        // Check if tenant has rental area
        return true;
    }

    public List<RentalArea> getAllRent() {
        String sql = "SELECT * FROM dbo.rental_areas";
        List<RentalArea> areas = new ArrayList<>();
        try (PreparedStatement ps = connect.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                RentalArea area = new RentalArea();
                area.setRentalAreaId(rs.getInt("rental_area_id"));
                area.setManagerId(rs.getInt("manager_id"));
                area.setName(rs.getString("name"));
                area.setAddress(rs.getString("address"));
                area.setCreatedAt(rs.getTimestamp("created_at"));
                areas.add(area);

            }
            return areas;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;

    }

    public RentalArea getRentalFromRoomID(int roomID) {
        String sql = "SELECT r.rental_area_id, r.manager_id, r.name, r.address, r.created_at "
                + "FROM dbo.rental_areas r "
                + "JOIN dbo.rooms ro ON ro.rental_area_id = r.rental_area_id "
                + "WHERE ro.room_id = ?;";
        try (PreparedStatement ps = connect.prepareStatement(sql)) {
            ps.setInt(1, roomID);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                RentalArea area = new RentalArea();
                area.setRentalAreaId(rs.getInt("rental_area_id"));
                area.setManagerId(rs.getInt("manager_id"));
                area.setName(rs.getString("name"));
                area.setAddress(rs.getString("address"));
                area.setCreatedAt(rs.getTimestamp("created_at"));
                return area;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
}
