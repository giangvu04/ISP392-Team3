package dal;

import java.math.BigDecimal;
import model.Contracts;
import java.sql.*;
import java.util.ArrayList;

public class DAOContract {

    public static final DAOContract INSTANCE = new DAOContract();
    protected Connection connect;

    public DAOContract() {
        connect = new DBContext().connect;
    }

    // Get all contracts
    public ArrayList<Contracts> getAllContracts() {
        ArrayList<Contracts> contracts = new ArrayList<>();
        String sql = "SELECT [contract_id], [room_id], [tenant_id], [start_date], [end_date], " +
                    "[rent_price], [deposit_amount], [status], [note] FROM [dbo].[contracts]";

        try (PreparedStatement ps = connect.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Contracts c = new Contracts();
                c.setContractId(rs.getInt("contract_id"));
                c.setRoomID(rs.getInt("room_id"));
                c.setTenantsID(rs.getInt("tenant_id"));
                c.setStartDate(rs.getDate("start_date"));
                c.setEndDate(rs.getDate("end_date"));
                c.setRentPrice(rs.getBigDecimal("rent_price"));
                c.setDepositAmount(rs.getBigDecimal("deposit_amount"));
                c.setStatus(rs.getInt("status"));
                c.setNote(rs.getString("note"));

                contracts.add(c);
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error fetching all contracts: " + e.getMessage(), e);
        }

        return contracts;
    }

    // Add new contract
    public int addContract(Contracts contract) {
        if (contract == null) {
            throw new IllegalArgumentException("Contract cannot be null");
        }

        String sql = "INSERT INTO [dbo].[contracts] ([room_id], [tenant_id], [start_date], [end_date], " +
                    "[rent_price], [deposit_amount], [status], [note]) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

        try (PreparedStatement ps = connect.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, contract.getRoomID());
            ps.setInt(2, contract.getTenantsID());
            ps.setDate(3, contract.getStartDate());
            ps.setDate(4, contract.getEndDate());
            ps.setBigDecimal(5, contract.getRentPrice());
            ps.setBigDecimal(6, contract.getDepositAmount());
            ps.setInt(7, contract.getStatus());
            ps.setString(8, contract.getNote());

            ps.executeUpdate();

            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) {
                    return rs.getInt(1); // return new contract ID
                }
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error adding contract: " + e.getMessage(), e);
        }

        return -1;
    }
    public boolean hasActiveContract(int roomId) {
    String sql = "SELECT COUNT(*) FROM Contracts WHERE room_id = ? AND status = 1";
    
    try (
         PreparedStatement ps = connect.prepareStatement(sql)) {
        
        ps.setInt(1, roomId);
        ResultSet rs = ps.executeQuery();
        
        if (rs.next()) {
            return rs.getInt(1) > 0;
        }
        
    } catch (SQLException e) {
        System.err.println("Lỗi khi kiểm tra hợp đồng hoạt động: " + e.getMessage());
    }
    
    return false;
}


    // Update contract
    public void updateContract(Contracts contract) {
        if (contract == null || contract.getContractId() <= 0) {
            throw new IllegalArgumentException("Invalid contract data");
        }

        String sql = "UPDATE [dbo].[contracts] SET [room_id]=?, [tenant_id]=?, [start_date]=?, [end_date]=?, " +
                    "[rent_price]=?, [deposit_amount]=?, [status]=?, [note]=? WHERE [contract_id]=?";

        try (PreparedStatement ps = connect.prepareStatement(sql)) {
            ps.setInt(1, contract.getRoomID());
            ps.setInt(2, contract.getTenantsID());
            ps.setDate(3, contract.getStartDate());
            ps.setDate(4, contract.getEndDate());
            ps.setBigDecimal(5, contract.getRentPrice());
            ps.setBigDecimal(6, contract.getDepositAmount());
            ps.setInt(7, contract.getStatus());
            ps.setString(8, contract.getNote());
            ps.setInt(9, contract.getContractId());

            int rowsAffected = ps.executeUpdate();
            if (rowsAffected == 0) {
                throw new SQLException("No contract found with ID: " + contract.getContractId());
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error updating contract: " + e.getMessage(), e);
        }
    }

    // Delete contract
    public boolean deleteContract(int contractId) {
    if (contractId <= 0) {
        throw new IllegalArgumentException("Invalid contract ID");
    }

    String sql = "DELETE FROM [dbo].[contracts] WHERE [contract_id]=?";
    try (PreparedStatement ps = connect.prepareStatement(sql)) {
        ps.setInt(1, contractId);
        int rowsAffected = ps.executeUpdate();
        return rowsAffected > 0; // Trả về true nếu có ít nhất 1 dòng bị xóa
    } catch (SQLException e) {
        throw new RuntimeException("Error deleting contract: " + e.getMessage(), e);
    }
}

    // Get contract by ID
    public Contracts getContractById(int id) {
        if (id <= 0) {
            throw new IllegalArgumentException("Invalid contract ID");
        }

        String sql = "SELECT [contract_id], [room_id], [tenant_id], [start_date], [end_date], " +
                    "[rent_price], [deposit_amount], [status], [note] FROM [dbo].[contracts] WHERE [contract_id]=?";
        
        try (PreparedStatement ps = connect.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                Contracts c = new Contracts();
                c.setContractId(rs.getInt("contract_id"));
                c.setRoomID(rs.getInt("room_id"));
                c.setTenantsID(rs.getInt("tenant_id"));
                c.setStartDate(rs.getDate("start_date"));
                c.setEndDate(rs.getDate("end_date"));
                c.setRentPrice(rs.getBigDecimal("rent_price"));
                c.setDepositAmount(rs.getBigDecimal("deposit_amount"));
                c.setStatus(rs.getInt("status"));
                c.setNote(rs.getString("note"));
                return c;
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error fetching contract by ID: " + e.getMessage(), e);
        }
        
        return null;
    }

    // Get contracts by page (for Admin/Manager)
    public ArrayList<Contracts> getContractsByPage(int page, int pageSize) {
        if (page < 1 || pageSize <= 0) {
            throw new IllegalArgumentException("Invalid page or page size");
        }

        ArrayList<Contracts> contracts = new ArrayList<>();
        String sql = "SELECT [contract_id], [room_id], [tenant_id], [start_date], [end_date], " +
                    "[rent_price], [deposit_amount], [status], [note] FROM [dbo].[contracts] " +
                    "ORDER BY [contract_id] OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";

        try (PreparedStatement ps = connect.prepareStatement(sql)) {
            ps.setInt(1, (page - 1) * pageSize);
            ps.setInt(2, pageSize);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Contracts c = new Contracts();
                c.setContractId(rs.getInt("contract_id"));
                c.setRoomID(rs.getInt("room_id"));
                c.setTenantsID(rs.getInt("tenant_id"));
                c.setStartDate(rs.getDate("start_date"));
                c.setEndDate(rs.getDate("end_date"));
                c.setRentPrice(rs.getBigDecimal("rent_price"));
                c.setDepositAmount(rs.getBigDecimal("deposit_amount"));
                c.setStatus(rs.getInt("status"));
                c.setNote(rs.getString("note"));

                contracts.add(c);
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error fetching contracts by page: " + e.getMessage(), e);
        }

        return contracts;
    }

    // Get contracts by page for specific tenant
    public ArrayList<Contracts> getContractsByPage2(int page, int pageSize, int tenantId) {
        if (page < 1 || pageSize <= 0 || tenantId <= 0) {
            throw new IllegalArgumentException("Invalid parameters");
        }

        ArrayList<Contracts> contracts = new ArrayList<>();
        String sql = "SELECT [contract_id], [room_id], [tenant_id], [start_date], [end_date], " +
                    "[rent_price], [deposit_amount], [status], [note] FROM [dbo].[contracts] " +
                    "WHERE [tenant_id] = ? ORDER BY [contract_id] OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
        
        System.out.println("DEBUG: Querying contracts for tenant_id: " + tenantId);
        
        try (PreparedStatement ps = connect.prepareStatement(sql)) {
            ps.setInt(1, tenantId);
            ps.setInt(2, (page - 1) * pageSize);
            ps.setInt(3, pageSize);

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Contracts c = new Contracts();
                c.setContractId(rs.getInt("contract_id"));
                c.setRoomID(rs.getInt("room_id"));
                c.setTenantsID(rs.getInt("tenant_id"));
                c.setStartDate(rs.getDate("start_date"));
                c.setEndDate(rs.getDate("end_date"));
                c.setRentPrice(rs.getBigDecimal("rent_price"));
                c.setDepositAmount(rs.getBigDecimal("deposit_amount"));
                c.setStatus(rs.getInt("status"));
                c.setNote(rs.getString("note"));
                
                contracts.add(c);
                System.out.println("DEBUG: Found contract " + c.getContractId() + " for tenant " + c.getTenantsID());
            }
        } catch (SQLException e) {
            System.err.println("ERROR in getContractsByPage2: " + e.getMessage());
            throw new RuntimeException("Error fetching contracts by page for tenant: " + e.getMessage(), e);
        }
        
        System.out.println("DEBUG: Total contracts found: " + contracts.size());
        return contracts;
    }

    // Get all contracts by tenant (no pagination)
    public ArrayList<Contracts> getContractsByTenantId(int tenantId) {
        if (tenantId <= 0) {
            throw new IllegalArgumentException("Invalid tenant ID");
        }

        ArrayList<Contracts> contracts = new ArrayList<>();
        String sql = "SELECT [contract_id], [room_id], [tenant_id], [start_date], [end_date], " +
                    "[rent_price], [deposit_amount], [status], [note] FROM [dbo].[contracts] " +
                    "WHERE [tenant_id] = ? ORDER BY [contract_id]";
        
        try (PreparedStatement ps = connect.prepareStatement(sql)) {
            ps.setInt(1, tenantId);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                Contracts contract = new Contracts();
                contract.setContractId(rs.getInt("contract_id"));
                contract.setRoomID(rs.getInt("room_id"));
                contract.setTenantsID(rs.getInt("tenant_id"));
                contract.setStartDate(rs.getDate("start_date"));
                contract.setEndDate(rs.getDate("end_date"));
                contract.setRentPrice(rs.getBigDecimal("rent_price"));
                contract.setDepositAmount(rs.getBigDecimal("deposit_amount"));
                contract.setStatus(rs.getInt("status"));
                contract.setNote(rs.getString("note"));
                
                contracts.add(contract);
            }
            
        } catch (SQLException e) {
            throw new RuntimeException("Error fetching contracts by tenant ID: " + e.getMessage(), e);
        }
        
        return contracts;
    }

    // Count total contracts by tenant
    public int getTotalContractsByTenant(int tenantId) {
        if (tenantId <= 0) {
            throw new IllegalArgumentException("Invalid tenant ID");
        }

        String sql = "SELECT COUNT(*) FROM [dbo].[contracts] WHERE [tenant_id] = ?";
        try (PreparedStatement ps = connect.prepareStatement(sql)) {
            ps.setInt(1, tenantId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                int count = rs.getInt(1);
                System.out.println("DEBUG: Total contracts for tenant " + tenantId + ": " + count);
                return count;
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error counting contracts by tenant: " + e.getMessage(), e);
        }
        return 0;
    }

    // Search contracts by keyword (for Admin/Manager)
    public ArrayList<Contracts> getContractsBySearch(String keyword) {
        if (keyword == null || keyword.trim().isEmpty()) {
            throw new IllegalArgumentException("Search keyword cannot be empty");
        }

        ArrayList<Contracts> contracts = new ArrayList<>();
        String sql = "SELECT [contract_id], [room_id], [tenant_id], [start_date], [end_date], " +
                    "[rent_price], [deposit_amount], [status], [note] FROM [dbo].[contracts] WHERE " +
                    "CAST([contract_id] AS VARCHAR) LIKE ? OR " +
                    "CAST([room_id] AS VARCHAR) LIKE ? OR " +
                    "CAST([tenant_id] AS VARCHAR) LIKE ? OR " +
                    "CAST([rent_price] AS VARCHAR) LIKE ? OR " +
                    "[note] LIKE ?";

        try (PreparedStatement ps = connect.prepareStatement(sql)) {
            String searchPattern = "%" + keyword.trim() + "%";
            ps.setString(1, searchPattern);
            ps.setString(2, searchPattern);
            ps.setString(3, searchPattern);
            ps.setString(4, searchPattern);
            ps.setString(5, searchPattern);

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Contracts c = new Contracts();
                c.setContractId(rs.getInt("contract_id"));
                c.setRoomID(rs.getInt("room_id"));
                c.setTenantsID(rs.getInt("tenant_id"));
                c.setStartDate(rs.getDate("start_date"));
                c.setEndDate(rs.getDate("end_date"));
                c.setRentPrice(rs.getBigDecimal("rent_price"));
                c.setDepositAmount(rs.getBigDecimal("deposit_amount"));
                c.setStatus(rs.getInt("status"));
                c.setNote(rs.getString("note"));

                contracts.add(c);
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error searching contracts: " + e.getMessage(), e);
        }

        return contracts;
    }

    // Search contracts by tenant and keyword
    public ArrayList<Contracts> getContractsBySearchAndTenant(String keyword, int tenantId) {
        if (keyword == null || keyword.trim().isEmpty()) {
            throw new IllegalArgumentException("Search keyword cannot be empty");
        }
        if (tenantId <= 0) {
            throw new IllegalArgumentException("Invalid tenant ID");
        }

        ArrayList<Contracts> contracts = new ArrayList<>();
        String sql = "SELECT [contract_id], [room_id], [tenant_id], [start_date], [end_date], " +
                    "[rent_price], [deposit_amount], [status], [note] FROM [dbo].[contracts] " +
                    "WHERE [tenant_id] = ? AND (" +
                    "CAST([contract_id] AS VARCHAR) LIKE ? OR " +
                    "CAST([room_id] AS VARCHAR) LIKE ? OR " +
                    "CAST([rent_price] AS VARCHAR) LIKE ? OR " +
                    "[note] LIKE ?)";

        try (PreparedStatement ps = connect.prepareStatement(sql)) {
            String searchPattern = "%" + keyword.trim() + "%";
            ps.setInt(1, tenantId);
            ps.setString(2, searchPattern);
            ps.setString(3, searchPattern);
            ps.setString(4, searchPattern);
            ps.setString(5, searchPattern);

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Contracts c = new Contracts();
                c.setContractId(rs.getInt("contract_id"));
                c.setRoomID(rs.getInt("room_id"));
                c.setTenantsID(rs.getInt("tenant_id"));
                c.setStartDate(rs.getDate("start_date"));
                c.setEndDate(rs.getDate("end_date"));
                c.setRentPrice(rs.getBigDecimal("rent_price"));
                c.setDepositAmount(rs.getBigDecimal("deposit_amount"));
                c.setStatus(rs.getInt("status"));
                c.setNote(rs.getString("note"));

                contracts.add(c);
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error searching contracts by tenant: " + e.getMessage(), e);
        }

        return contracts;
    }

    // Count total contracts (for Admin/Manager)
    public int getTotalContracts() {
        String sql = "SELECT COUNT(*) FROM [dbo].[contracts]";
        try (PreparedStatement ps = connect.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error counting total contracts: " + e.getMessage(), e);
        }
        return 0;
    }

    // Get contracts by status
    public ArrayList<Contracts> getContractsByStatus(int status) {
        ArrayList<Contracts> contracts = new ArrayList<>();
        String sql = "SELECT [contract_id], [room_id], [tenant_id], [start_date], [end_date], " +
                    "[rent_price], [deposit_amount], [status], [note] FROM [dbo].[contracts] " +
                    "WHERE [status] = ? ORDER BY [contract_id]";

        try (PreparedStatement ps = connect.prepareStatement(sql)) {
            ps.setInt(1, status);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Contracts c = new Contracts();
                c.setContractId(rs.getInt("contract_id"));
                c.setRoomID(rs.getInt("room_id"));
                c.setTenantsID(rs.getInt("tenant_id"));
                c.setStartDate(rs.getDate("start_date"));
                c.setEndDate(rs.getDate("end_date"));
                c.setRentPrice(rs.getBigDecimal("rent_price"));
                c.setDepositAmount(rs.getBigDecimal("deposit_amount"));
                c.setStatus(rs.getInt("status"));
                c.setNote(rs.getString("note"));

                contracts.add(c);
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error fetching contracts by status: " + e.getMessage(), e);
        }

        return contracts;
    }

    // Check if contract exists for a specific room and tenant
    public boolean contractExists(int roomId, int tenantId) {
        if (roomId <= 0 || tenantId <= 0) {
            return false;
        }

        String sql = "SELECT COUNT(*) FROM [dbo].[contracts] WHERE [room_id] = ? AND [tenant_id] = ? AND [status] = 1";
        try (PreparedStatement ps = connect.prepareStatement(sql)) {
            ps.setInt(1, roomId);
            ps.setInt(2, tenantId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error checking contract existence: " + e.getMessage(), e);
        }
        return false;
    }
    // Bổ sung các phương thức sau vào class DAOContract:

    // Get contracts by tenant ID (không phân trang - khác với getContractsByTenantId đã có)
    public ArrayList<Contracts> getContractsByTenant(int tenantId) {
        if (tenantId <= 0) {
            throw new IllegalArgumentException("Invalid tenant ID");
        }

        ArrayList<Contracts> contracts = new ArrayList<>();
        String sql = "SELECT [contract_id], [room_id], [tenant_id], [start_date], [end_date], " +
                    "[rent_price], [deposit_amount], [status], [note] FROM [dbo].[contracts] " +
                    "WHERE [tenant_id] = ? ORDER BY [contract_id] DESC";
        
        try (PreparedStatement ps = connect.prepareStatement(sql)) {
            ps.setInt(1, tenantId);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                Contracts contract = new Contracts();
                contract.setContractId(rs.getInt("contract_id"));
                contract.setRoomID(rs.getInt("room_id"));
                contract.setTenantsID(rs.getInt("tenant_id"));
                contract.setStartDate(rs.getDate("start_date"));
                contract.setEndDate(rs.getDate("end_date"));
                contract.setRentPrice(rs.getBigDecimal("rent_price"));
                contract.setDepositAmount(rs.getBigDecimal("deposit_amount"));
                contract.setStatus(rs.getInt("status"));
                contract.setNote(rs.getString("note"));
                
                contracts.add(contract);
            }
            
        } catch (SQLException e) {
            throw new RuntimeException("Error fetching contracts by tenant: " + e.getMessage(), e);
        }
        
        return contracts;
    }

    // Get contracts by rental area ID (cho Manager)
    public ArrayList<Contracts> getContractsByRentalArea(int rentalAreaId) {
        if (rentalAreaId <= 0) {
            throw new IllegalArgumentException("Invalid rental area ID");
        }

        ArrayList<Contracts> contracts = new ArrayList<>();
        String sql = "SELECT c.[contract_id], c.[room_id], c.[tenant_id], c.[start_date], c.[end_date], " +
                    "c.[rent_price], c.[deposit_amount], c.[status], c.[note] " +
                    "FROM [dbo].[contracts] c " +
                    "INNER JOIN [dbo].[rooms] r ON c.[room_id] = r.[room_id] " +
                    "WHERE r.[rental_area_id] = ? " +
                    "ORDER BY c.[contract_id] DESC";
        
        try (PreparedStatement ps = connect.prepareStatement(sql)) {
            ps.setInt(1, rentalAreaId);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                Contracts contract = new Contracts();
                contract.setContractId(rs.getInt("contract_id"));
                contract.setRoomID(rs.getInt("room_id"));
                contract.setTenantsID(rs.getInt("tenant_id"));
                contract.setStartDate(rs.getDate("start_date"));
                contract.setEndDate(rs.getDate("end_date"));
                contract.setRentPrice(rs.getBigDecimal("rent_price"));
                contract.setDepositAmount(rs.getBigDecimal("deposit_amount"));
                contract.setStatus(rs.getInt("status"));
                contract.setNote(rs.getString("note"));
                
                contracts.add(contract);
            }
            
        } catch (SQLException e) {
            throw new RuntimeException("Error fetching contracts by rental area: " + e.getMessage(), e);
        }
        
        return contracts;
    }

    // Get contracts by rental area with pagination (cho Manager)
    public ArrayList<Contracts> getContractsByRentalAreaAndPage(int rentalAreaId, int page, int pageSize) {
        if (rentalAreaId <= 0 || page < 1 || pageSize <= 0) {
            throw new IllegalArgumentException("Invalid parameters");
        }

        ArrayList<Contracts> contracts = new ArrayList<>();
        String sql = "SELECT c.[contract_id], c.[room_id], c.[tenant_id], c.[start_date], c.[end_date], " +
                    "c.[rent_price], c.[deposit_amount], c.[status], c.[note] " +
                    "FROM [dbo].[contracts] c " +
                    "INNER JOIN [dbo].[rooms] r ON c.[room_id] = r.[room_id] " +
                    "WHERE r.[rental_area_id] = ? " +
                    "ORDER BY c.[contract_id] DESC " +
                    "OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
        
        try (PreparedStatement ps = connect.prepareStatement(sql)) {
            ps.setInt(1, rentalAreaId);
            ps.setInt(2, (page - 1) * pageSize);
            ps.setInt(3, pageSize);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                Contracts contract = new Contracts();
                contract.setContractId(rs.getInt("contract_id"));
                contract.setRoomID(rs.getInt("room_id"));
                contract.setTenantsID(rs.getInt("tenant_id"));
                contract.setStartDate(rs.getDate("start_date"));
                contract.setEndDate(rs.getDate("end_date"));
                contract.setRentPrice(rs.getBigDecimal("rent_price"));
                contract.setDepositAmount(rs.getBigDecimal("deposit_amount"));
                contract.setStatus(rs.getInt("status"));
                contract.setNote(rs.getString("note"));
                
                contracts.add(contract);
            }
            
        } catch (SQLException e) {
            throw new RuntimeException("Error fetching contracts by rental area and page: " + e.getMessage(), e);
        }
        
        return contracts;
    }

    // Count total contracts by rental area (cho Manager)
    public int getTotalContractsByRentalArea(int rentalAreaId) {
        if (rentalAreaId <= 0) {
            throw new IllegalArgumentException("Invalid rental area ID");
        }

        String sql = "SELECT COUNT(*) FROM [dbo].[contracts] c " +
                    "INNER JOIN [dbo].[rooms] r ON c.[room_id] = r.[room_id] " +
                    "WHERE r.[rental_area_id] = ?";
        
        try (PreparedStatement ps = connect.prepareStatement(sql)) {
            ps.setInt(1, rentalAreaId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error counting contracts by rental area: " + e.getMessage(), e);
        }
        return 0;
    }

    // Search contracts by keyword and rental area (cho Manager)
    public ArrayList<Contracts> getContractsBySearchAndRentalArea(String keyword, int rentalAreaId) {
        if (keyword == null || keyword.trim().isEmpty()) {
            throw new IllegalArgumentException("Search keyword cannot be empty");
        }
        if (rentalAreaId <= 0) {
            throw new IllegalArgumentException("Invalid rental area ID");
        }

        ArrayList<Contracts> contracts = new ArrayList<>();
        String sql = "SELECT c.[contract_id], c.[room_id], c.[tenant_id], c.[start_date], c.[end_date], " +
                    "c.[rent_price], c.[deposit_amount], c.[status], c.[note] " +
                    "FROM [dbo].[contracts] c " +
                    "INNER JOIN [dbo].[rooms] r ON c.[room_id] = r.[room_id] " +
                    "WHERE r.[rental_area_id] = ? AND (" +
                    "CAST(c.[contract_id] AS VARCHAR) LIKE ? OR " +
                    "CAST(c.[room_id] AS VARCHAR) LIKE ? OR " +
                    "CAST(c.[tenant_id] AS VARCHAR) LIKE ? OR " +
                    "CAST(c.[rent_price] AS VARCHAR) LIKE ? OR " +
                    "c.[note] LIKE ?) " +
                    "ORDER BY c.[contract_id] DESC";

        try (PreparedStatement ps = connect.prepareStatement(sql)) {
            String searchPattern = "%" + keyword.trim() + "%";
            ps.setInt(1, rentalAreaId);
            ps.setString(2, searchPattern);
            ps.setString(3, searchPattern);
            ps.setString(4, searchPattern);
            ps.setString(5, searchPattern);
            ps.setString(6, searchPattern);

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Contracts c = new Contracts();
                c.setContractId(rs.getInt("contract_id"));
                c.setRoomID(rs.getInt("room_id"));
                c.setTenantsID(rs.getInt("tenant_id"));
                c.setStartDate(rs.getDate("start_date"));
                c.setEndDate(rs.getDate("end_date"));
                c.setRentPrice(rs.getBigDecimal("rent_price"));
                c.setDepositAmount(rs.getBigDecimal("deposit_amount"));
                c.setStatus(rs.getInt("status"));
                c.setNote(rs.getString("note"));

                contracts.add(c);
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error searching contracts by rental area: " + e.getMessage(), e);
        }

        return contracts;
    }

    // Get contracts by status and rental area (cho Manager)
    public ArrayList<Contracts> getContractsByStatusAndRentalArea(int status, int rentalAreaId) {
        if (rentalAreaId <= 0) {
            throw new IllegalArgumentException("Invalid rental area ID");
        }

        ArrayList<Contracts> contracts = new ArrayList<>();
        String sql = "SELECT c.[contract_id], c.[room_id], c.[tenant_id], c.[start_date], c.[end_date], " +
                    "c.[rent_price], c.[deposit_amount], c.[status], c.[note] " +
                    "FROM [dbo].[contracts] c " +
                    "INNER JOIN [dbo].[rooms] r ON c.[room_id] = r.[room_id] " +
                    "WHERE c.[status] = ? AND r.[rental_area_id] = ? " +
                    "ORDER BY c.[contract_id] DESC";

        try (PreparedStatement ps = connect.prepareStatement(sql)) {
            ps.setInt(1, status);
            ps.setInt(2, rentalAreaId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Contracts c = new Contracts();
                c.setContractId(rs.getInt("contract_id"));
                c.setRoomID(rs.getInt("room_id"));
                c.setTenantsID(rs.getInt("tenant_id"));
                c.setStartDate(rs.getDate("start_date"));
                c.setEndDate(rs.getDate("end_date"));
                c.setRentPrice(rs.getBigDecimal("rent_price"));
                c.setDepositAmount(rs.getBigDecimal("deposit_amount"));
                c.setStatus(rs.getInt("status"));
                c.setNote(rs.getString("note"));

                contracts.add(c);
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error fetching contracts by status and rental area: " + e.getMessage(), e);
        }

        return contracts;
    }

    // Get contracts by status and tenant
    public ArrayList<Contracts> getContractsByStatusAndTenant(int status, int tenantId) {
        if (tenantId <= 0) {
            throw new IllegalArgumentException("Invalid tenant ID");
        }

        ArrayList<Contracts> contracts = new ArrayList<>();
        String sql = "SELECT [contract_id], [room_id], [tenant_id], [start_date], [end_date], " +
                    "[rent_price], [deposit_amount], [status], [note] FROM [dbo].[contracts] " +
                    "WHERE [status] = ? AND [tenant_id] = ? ORDER BY [contract_id] DESC";

        try (PreparedStatement ps = connect.prepareStatement(sql)) {
            ps.setInt(1, status);
            ps.setInt(2, tenantId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Contracts c = new Contracts();
                c.setContractId(rs.getInt("contract_id"));
                c.setRoomID(rs.getInt("room_id"));
                c.setTenantsID(rs.getInt("tenant_id"));
                c.setStartDate(rs.getDate("start_date"));
                c.setEndDate(rs.getDate("end_date"));
                c.setRentPrice(rs.getBigDecimal("rent_price"));
                c.setDepositAmount(rs.getBigDecimal("deposit_amount"));
                c.setStatus(rs.getInt("status"));
                c.setNote(rs.getString("note"));

                contracts.add(c);
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error fetching contracts by status and tenant: " + e.getMessage(), e);
        }

        return contracts;
    }

    // Validate contract data before adding/updating
    public boolean isValidContract(Contracts contract) {
        if (contract == null) {
            return false;
        }
        
        // Check required fields
        if (contract.getRoomID() <= 0 || contract.getTenantsID() <= 0) {
            return false;
        }
        
        if (contract.getStartDate() == null) {
            return false;
        }
        
        if (contract.getRentPrice() == null || contract.getRentPrice().compareTo(BigDecimal.ZERO) <= 0) {
            return false;
        }
        
        // Check if end date is after start date (if provided)
        if (contract.getEndDate() != null && contract.getEndDate().before(contract.getStartDate())) {
            return false;
        }
        
        return true;
    }

    // Get active contract for a room
    public Contracts getActiveContractByRoomId(int roomId) {
        if (roomId <= 0) {
            throw new IllegalArgumentException("Invalid room ID");
        }

        String sql = "SELECT [contract_id], [room_id], [tenant_id], [start_date], [end_date], " +
                    "[rent_price], [deposit_amount], [status], [note] FROM [dbo].[contracts] " +
                    "WHERE [room_id] = ? AND [status] = 1";
        
        try (PreparedStatement ps = connect.prepareStatement(sql)) {
            ps.setInt(1, roomId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                Contracts c = new Contracts();
                c.setContractId(rs.getInt("contract_id"));
                c.setRoomID(rs.getInt("room_id"));
                c.setTenantsID(rs.getInt("tenant_id"));
                c.setStartDate(rs.getDate("start_date"));
                c.setEndDate(rs.getDate("end_date"));
                c.setRentPrice(rs.getBigDecimal("rent_price"));
                c.setDepositAmount(rs.getBigDecimal("deposit_amount"));
                c.setStatus(rs.getInt("status"));
                c.setNote(rs.getString("note"));
                return c;
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error fetching active contract by room ID: " + e.getMessage(), e);
        }
        
        return null;
    }

    // Get active contract for a tenant
    public Contracts getActiveContractByTenantId(int tenantId) {
        if (tenantId <= 0) {
            throw new IllegalArgumentException("Invalid tenant ID");
        }

        String sql = "SELECT [contract_id], [room_id], [tenant_id], [start_date], [end_date], " +
                    "[rent_price], [deposit_amount], [status], [note] FROM [dbo].[contracts] " +
                    "WHERE [tenant_id] = ? AND [status] = 1 ORDER BY [start_date] DESC";
        
        try (PreparedStatement ps = connect.prepareStatement(sql)) {
            ps.setInt(1, tenantId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                Contracts c = new Contracts();
                c.setContractId(rs.getInt("contract_id"));
                c.setRoomID(rs.getInt("room_id"));
                c.setTenantsID(rs.getInt("tenant_id"));
                c.setStartDate(rs.getDate("start_date"));
                c.setEndDate(rs.getDate("end_date"));
                c.setRentPrice(rs.getBigDecimal("rent_price"));
                c.setDepositAmount(rs.getBigDecimal("deposit_amount"));
                c.setStatus(rs.getInt("status"));
                c.setNote(rs.getString("note"));
                return c;
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error fetching active contract by tenant ID: " + e.getMessage(), e);
        }
        
        return null;
    }
    // Test main method
    public static void main(String[] args) {
        try {
            DAOContract dao = DAOContract.INSTANCE;
            System.out.println("Total contracts: " + dao.getTotalContracts());
            
            // Test specific tenant
            System.out.println("Contracts for tenant 3: " + dao.getTotalContractsByTenant(3));
            ArrayList<Contracts> contracts = dao.getContractsByTenantId(3);
            for (Contracts c : contracts) {
                System.out.println("Contract ID: " + c.getContractId() + ", Room: " + c.getRoomID());
            }
        } catch (Exception e) {
            System.err.println("Error in main method: " + e.getMessage());
            e.printStackTrace();
        }
    }
}