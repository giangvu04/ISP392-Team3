package dal;

import model.RentalArea;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

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
        String sql = "SELECT ra.* FROM rental_areas ra "
                + "JOIN tenant_rental_area tra ON ra.rental_area_id = tra.rental_area_id "
                + "WHERE tra.tenant_id = ?";
        try (PreparedStatement ps = connect.prepareStatement(sql)) {
            ps.setInt(1, tenantId);
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

    public boolean assignTenantToRentalArea(int tenantId, int rentalAreaId) {
        // Implementation for admin to assign tenants
        return true;
    }

    public boolean isTenantAssigned(int tenantId) {
        // Check if tenant has rental area
        return true;
    }
    
    public List<RentalArea> getAllRent(){
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
}
