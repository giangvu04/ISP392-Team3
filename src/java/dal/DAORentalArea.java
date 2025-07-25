package dal;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.RentalArea;

public class DAORentalArea {
    /**
     * Thêm mới khu trọ
     */
    public boolean insertRentalArea(int managerId, String name, String address, String province, String district, String ward, String street, String detail) {
        // Gộp địa chỉ
        String fullAddress = "";
        if (street != null && !street.isEmpty()) fullAddress += street + ", ";
        if (ward != null && !ward.isEmpty()) fullAddress += ward + ", ";
        if (district != null && !district.isEmpty()) fullAddress += district + ", ";
        if (province != null && !province.isEmpty()) fullAddress += province;
        if (detail != null && !detail.isEmpty()) fullAddress = detail + ", " + fullAddress;

        String sql = "INSERT INTO rental_areas (manager_id, name, address, province, district, ward, street, detail, created_at) VALUES (?, ?, ?, ?, ?, ?, ?, ?, GETDATE())";
        try (PreparedStatement ps = connect.prepareStatement(sql)) {
            ps.setInt(1, managerId);
            ps.setString(2, name);
            ps.setString(3, fullAddress);
            ps.setString(4, province);
            ps.setString(5, district);
            ps.setString(6, ward);
            ps.setString(7, street);
            ps.setString(8, detail);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public static final DAORentalArea INSTANCE = new DAORentalArea();
    protected Connection connect;

    public DAORentalArea() {
        connect = new DBContext().connect;
    }
        // Lấy chi tiết khu trọ theo id
    public RentalArea getRentalAreaDetail(int id) {
        String sql = "SELECT r.*, (SELECT COUNT(*) FROM rooms rm WHERE rm.rental_area_id = r.rental_area_id) AS totalRooms FROM rental_areas r WHERE r.rental_area_id = ?";
        try (PreparedStatement ps = connect.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                RentalArea r = new RentalArea();
                r.setRentalAreaId(rs.getInt("rental_area_id"));
                r.setManagerId(rs.getInt("manager_id"));
                r.setName(rs.getString("name"));
                r.setAddress(rs.getString("address"));
                r.setProvince(rs.getString("province"));
                r.setDistrict(rs.getString("district"));
                r.setWard(rs.getString("ward"));
                r.setStreet(rs.getString("street"));
                r.setDetail(rs.getString("detail"));
                r.setQrForBill(rs.getString("qr_for_bill"));
                r.setCreatedAt(rs.getTimestamp("created_at"));
                r.setTotalRooms(rs.getInt("totalRooms"));
                r.setStatus(1); // Nếu có trường status thì lấy, chưa có thì mặc định 1
                return r;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<RentalArea> getAllRentalAreas() {
        List<RentalArea> areas = new ArrayList<>();
        String sql = "SELECT * FROM rental_areas";
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
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return areas;
    }
        // Lấy danh sách khu trọ theo search, filter, sort, phân trang, có thể lọc theo managerId
    public List<RentalArea> getRentalAreas(String searchTerm, String province, String district, String ward, String sortBy, String sortOrder, int page, int pageSize, Integer managerId) {
        List<RentalArea> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder();
        sql.append("SELECT r.*, (SELECT COUNT(*) FROM rooms rm WHERE rm.rental_area_id = r.rental_area_id) AS totalRooms FROM rental_areas r WHERE 1=1 ");
        List<Object> params = new ArrayList<>();
        if (searchTerm != null && !searchTerm.isEmpty()) {
            sql.append(" AND r.name LIKE ? ");
            params.add("%" + searchTerm + "%");
        }
        if (province != null && !province.isEmpty()) {
            sql.append(" AND r.province = ? ");
            params.add(province);
        }
        if (district != null && !district.isEmpty()) {
            sql.append(" AND r.district = ? ");
            params.add(district);
        }
        if (ward != null && !ward.isEmpty()) {
            sql.append(" AND r.ward = ? ");
            params.add(ward);
        }
        if (managerId != null) {
            sql.append(" AND r.manager_id = ? ");
            params.add(managerId);
        }
        // Sort
        String sortCol = "r.name";
        if ("address".equals(sortBy)) sortCol = "r.address";
        if ("totalRooms".equals(sortBy)) sortCol = "totalRooms";
        sql.append(" ORDER BY " + sortCol + ("desc".equalsIgnoreCase(sortOrder) ? " DESC" : " ASC"));
        // Phân trang
        sql.append(" OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");
        params.add((page - 1) * pageSize);
        params.add(pageSize);
        try (PreparedStatement ps = connect.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                RentalArea r = new RentalArea();
                r.setRentalAreaId(rs.getInt("rental_area_id"));
                r.setManagerId(rs.getInt("manager_id"));
                r.setName(rs.getString("name"));
                r.setAddress(rs.getString("address"));
                r.setProvince(rs.getString("province"));
                r.setDistrict(rs.getString("district"));
                r.setWard(rs.getString("ward"));
                r.setStreet(rs.getString("street"));
                r.setDetail(rs.getString("detail"));
                r.setQrForBill(rs.getString("qr_for_bill"));
                r.setCreatedAt(rs.getTimestamp("created_at"));
                r.setTotalRooms(rs.getInt("totalRooms"));
                r.setStatus(1); // Nếu có trường status thì lấy, chưa có thì mặc định 1
                list.add(r);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // Đếm tổng số khu trọ theo search, filter, có thể lọc theo managerId
    public int countRentalAreas(String searchTerm, String province, String district, String ward, Integer managerId) {
        int count = 0;
        StringBuilder sql = new StringBuilder();
        sql.append("SELECT COUNT(*) FROM rental_areas WHERE 1=1 ");
        List<Object> params = new ArrayList<>();
        if (searchTerm != null && !searchTerm.isEmpty()) {
            sql.append(" AND name LIKE ? ");
            params.add("%" + searchTerm + "%");
        }
        if (province != null && !province.isEmpty()) {
            sql.append(" AND province = ? ");
            params.add(province);
        }
        if (district != null && !district.isEmpty()) {
            sql.append(" AND district = ? ");
            params.add(district);
        }
        if (ward != null && !ward.isEmpty()) {
            sql.append(" AND ward = ? ");
            params.add(ward);
        }
        if (managerId != null) {
            sql.append(" AND manager_id = ? ");
            params.add(managerId);
        }
        try (PreparedStatement ps = connect.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                count = rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return count;
    }

    public List<RentalArea> getRentalAreasByManagerId(int managerId) {
        List<RentalArea> areas = new ArrayList<>();
        String sql = "SELECT * FROM rental_areas WHERE manager_id = ?";
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
                areas.add(area);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return areas;
    }

    /**
     * Lấy danh sách khu trọ theo manager ID (alias cho getRentalAreasByManagerId)
     * @param managerId ID của manager
     * @return List<RentalArea> danh sách khu trọ
     */
    public List<RentalArea> getRentalAreasByManager(int managerId) {
        return getRentalAreasByManagerId(managerId);
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

    public List<RentalArea> getAllRent(int manager_id) {
        String sql = "SELECT * FROM dbo.rental_areas WHERE manager_id = ?";
        List<RentalArea> areas = new ArrayList<>();
        try (PreparedStatement ps = connect.prepareStatement(sql)) {
            ps.setInt(1, manager_id);
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

    // Lấy danh sách phòng theo rental_area_id
    public List<model.Room> getRoomsByRentalAreaId(int rentalAreaId) {
        List<model.Room> rooms = new ArrayList<>();
        String sql = "SELECT * FROM rooms WHERE rental_area_id = ?";
        try (PreparedStatement ps = connect.prepareStatement(sql)) {
            ps.setInt(1, rentalAreaId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                model.Room room = new model.Room();
                room.setRoomId(rs.getInt("room_id"));
                room.setRentalAreaId(rs.getInt("rental_area_id"));
                room.setRoomNumber(rs.getString("room_number"));
                room.setArea(rs.getBigDecimal("area"));
                room.setPrice(rs.getBigDecimal("price"));
                room.setMaxTenants(rs.getInt("max_tenants"));
                room.setStatus(rs.getInt("status"));
                room.setDescription(rs.getString("description"));
                room.setImageUrl(rs.getString("imageUrl"));
                rooms.add(room);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return rooms;
    }

    // Chỉnh sửa khu trọ
    public boolean updateRentalArea(int rentalAreaId, String name, String address, String province, String district, String ward, String street, String detail) {
        String sql = "UPDATE rental_areas SET name = ?, address = ?, province = ?, district = ?, ward = ?, street = ?, detail = ? WHERE rental_area_id = ?";
        try (PreparedStatement ps = connect.prepareStatement(sql)) {
            ps.setString(1, name);
            ps.setString(2, address);
            ps.setString(3, province);
            ps.setString(4, district);
            ps.setString(5, ward);
            ps.setString(6, street);
            ps.setString(7, detail);
            ps.setInt(8, rentalAreaId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
}
