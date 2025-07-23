/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.Services;

public class DAOServices {
    /**
     * Lấy danh sách dịch vụ đang sử dụng của tenant (qua hóa đơn chưa thanh toán)
     * @param tenantId user_id của tenant
     * @return List<Services> dịch vụ đang sử dụng
     */
    public List<Services> getCurrentServicesByTenant(int tenantId) {
        List<Services> services = new ArrayList<>();
        String sql = "SELECT s.* FROM tbBills b " +
                "JOIN bill_details bd ON b.ID = bd.bill_id " +
                "JOIN services s ON bd.service_id = s.service_id " +
                "WHERE b.TenantID = ? AND b.Status = 'Unpaid'";
        try (PreparedStatement ps = connect.prepareStatement(sql)) {
            ps.setInt(1, tenantId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Services s = new Services(
                        rs.getInt("service_id"),
                        rs.getInt("rental_area_id"),
                        rs.getString("service_name"),
                        rs.getDouble("unit_price"),
                        rs.getString("unit_name"),
                        rs.getInt("calculation_method")
                );
                services.add(s);
            }
        } catch (SQLException e) {
            System.err.println("Lỗi lấy dịch vụ đang sử dụng: " + e.getMessage());
        }
        return services;
    }

    public static final DAOServices INSTANCE = new DAOServices();
    protected Connection connect;

    public DAOServices() {
        connect = new DBContext().connect;
    }

    // Get all services
    public List<Services> getAllServices() {
        List<Services> services = new ArrayList<>();
        String sql = "SELECT * FROM [HouseSharing].[dbo].[services]";
        try (PreparedStatement ps = connect.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Services s = new Services(
                        rs.getInt("service_id"),
                        rs.getInt("rental_area_id"),
                        rs.getString("service_name"),
                        rs.getDouble("unit_price"),
                        rs.getString("unit_name"),
                        rs.getInt("calculation_method")
                );
                services.add(s);
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error fetching services: " + e.getMessage(), e);
        }
        return services;
    }

    // Get services by rental_area_id
    public List<Services> getServicesByRentalArea(int rentalAreaId) {
        List<Services> services = new ArrayList<>();
        String sql = "SELECT * FROM [HouseSharing].[dbo].[services] WHERE [rental_area_id] = ?";
        try (PreparedStatement ps = connect.prepareStatement(sql)) {
            ps.setInt(1, rentalAreaId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Services s = new Services(
                        rs.getInt("service_id"),
                        rs.getInt("rental_area_id"),
                        rs.getString("service_name"),
                        rs.getDouble("unit_price"),
                        rs.getString("unit_name"),
                        rs.getInt("calculation_method")
                );
                services.add(s);
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error fetching services by rentalAreaId: " + e.getMessage(), e);
        }
        return services;
    }

    // Get service by ID
    public Services getServiceById(int serviceId) {
        String sql = "SELECT * FROM [HouseSharing].[dbo].[services] WHERE [service_id] = ?";
        try (PreparedStatement ps = connect.prepareStatement(sql)) {
            ps.setInt(1, serviceId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return new Services(
                        rs.getInt("service_id"),
                        rs.getInt("rental_area_id"),
                        rs.getString("service_name"),
                        rs.getDouble("unit_price"),
                        rs.getString("unit_name"),
                        rs.getInt("calculation_method")
                );
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error fetching service by ID: " + e.getMessage(), e);
        }
        return null;
    }

    // Add new service
    public int addService(Services service) {
        String sql = """
            INSERT INTO [HouseSharing].[dbo].[services] 
            ([rental_area_id], [service_name], [unit_price], [unit_name], [calculation_method])
            VALUES (?, ?, ?, ?, ?)
            """;

        try (PreparedStatement ps = connect.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, service.getRentalAreaId());
            ps.setString(2, service.getServiceName().trim());
            ps.setDouble(3, service.getUnitPrice());
            ps.setString(4, service.getUnitName().trim());
            ps.setInt(5, service.getCalculationMethod());
            ps.executeUpdate();

            try (ResultSet generatedKeys = ps.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    return generatedKeys.getInt(1);
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error adding service: " + e.getMessage(), e);
        }
        return -1;
    }

    // Update service
    public void updateService(Services service) {
        String sql = """
            UPDATE [HouseSharing].[dbo].[services]
            SET [rental_area_id] = ?, [service_name] = ?, [unit_price] = ?, 
                [unit_name] = ?, [calculation_method] = ?
            WHERE [service_id] = ?
            """;

        try (PreparedStatement ps = connect.prepareStatement(sql)) {
            ps.setInt(1, service.getRentalAreaId());
            ps.setString(2, service.getServiceName().trim());
            ps.setDouble(3, service.getUnitPrice());
            ps.setString(4, service.getUnitName().trim());
            ps.setInt(5, service.getCalculationMethod());
            ps.setInt(6, service.getServiceId());

            int rows = ps.executeUpdate();
            if (rows == 0) {
                throw new SQLException("No service found with ID: " + service.getServiceId());
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error updating service: " + e.getMessage(), e);
        }
    }

    // Delete service
    public void deleteService(int serviceId) {
        String sql = "DELETE FROM [HouseSharing].[dbo].[services] WHERE [service_id] = ?";
        try (PreparedStatement ps = connect.prepareStatement(sql)) {
            ps.setInt(1, serviceId);
            int rows = ps.executeUpdate();
            if (rows == 0) {
                throw new SQLException("No service found with ID: " + serviceId);
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error deleting service: " + e.getMessage(), e);
        }
    }

    // Search services by name
    public List<Services> searchServicesByName(String name) {
        List<Services> services = new ArrayList<>();
        String sql = """
            SELECT * 
            FROM [HouseSharing].[dbo].[services] 
            WHERE LOWER([service_name]) LIKE ? 
            ORDER BY [service_name]
            """;

        try (PreparedStatement ps = connect.prepareStatement(sql)) {
            ps.setString(1, "%" + name.toLowerCase().trim() + "%");
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Services s = new Services(
                        rs.getInt("service_id"),
                        rs.getInt("rental_area_id"),
                        rs.getString("service_name"),
                        rs.getDouble("unit_price"),
                        rs.getString("unit_name"),
                        rs.getInt("calculation_method")
                );
                services.add(s);
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error searching services: " + e.getMessage(), e);
        }
        return services;
    }

    // Get total count of services
    public int getTotalServices() {
        String sql = "SELECT COUNT(*) FROM [HouseSharing].[dbo].[services]";
        try (PreparedStatement ps = connect.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error counting services: " + e.getMessage(), e);
        }
        return 0;
    }

    // Check if service name already exists (exclude ID)
    public boolean isServiceNameExists(String serviceName, int excludeId) {
        if (serviceName == null || serviceName.trim().isEmpty()) {
            return false;
        }

        String sql = """
            SELECT COUNT(*) 
            FROM [HouseSharing].[dbo].[services] 
            WHERE LOWER([service_name]) = ? AND [service_id] != ?
            """;

        try (PreparedStatement ps = connect.prepareStatement(sql)) {
            ps.setString(1, serviceName.toLowerCase().trim());
            ps.setInt(2, excludeId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error checking service name existence: " + e.getMessage(), e);
        }
        return false;
    }
}
