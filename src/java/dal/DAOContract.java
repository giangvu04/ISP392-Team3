package dal;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.Contracts;

public class DAOContract {
    // Lấy hợp đồng theo status và tenantId
    public ArrayList<Contracts> getContractsByStatusAndTenant(int status, int tenantId) {
        ArrayList<Contracts> contracts = new ArrayList<>();
        String sql = "SELECT [contract_id], [room_id], [tenant_id], [start_date], [end_date], "
                + "[rent_price], [deposit_amount], [status], [note] FROM [dbo].[contracts] "
                + "WHERE [status] = ? AND [tenant_id] = ? ORDER BY [contract_id] DESC";
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
            System.err.println("Lỗi lấy hợp đồng theo status và tenant: " + e.getMessage());
        }
        return contracts;
    }
    public boolean updateStatusContract(int status, int contractID) {
        String sql = "UPDATE dbo.contracts SET status = ? WHERE contract_id = ?";
        try (PreparedStatement ps = connect.prepareStatement(sql)) {
            ps.setInt(1, status);
            ps.setInt(2, contractID);
            int row = ps.executeUpdate();
            if(row>0){
                return true;
            }
        } catch (SQLException e) {
            System.err.println("Lỗi lấy hợp đồng theo status và tenant: " + e.getMessage());
        }
        return false;
    }

    /**
     * Lấy hợp đồng active mới nhất của một phòng (roomId), status = 1
     * @param roomId room cần lấy hợp đồng
     * @return Contracts object hoặc null nếu không có
     */
    public Contracts getLatestActiveContractByRoom(int roomId) {
        String sql = "SELECT TOP 1 * FROM contracts WHERE room_id = ? AND status = 1 ORDER BY contract_id DESC";
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
            System.err.println("Lỗi lấy hợp đồng active mới nhất của phòng: " + e.getMessage());
        }
        return null;
    }

    public static final DAOContract INSTANCE = new DAOContract();
    protected Connection connect;

    public DAOContract() {
        connect = new DBContext().connect;
    }

    /**
     * Lấy số ngày còn lại của hợp đồng đang hiệu lực cho tenant
     *
     * @param tenantId user_id của tenant
     * @return số ngày còn lại, -1 nếu không có hợp đồng
     */
    public int getDaysLeftOfActiveContract(int tenantId) {
        String sql = "SELECT DATEDIFF(day, GETDATE(), end_date) AS days_left FROM contracts WHERE tenant_id = ? AND status = 1";
        try (PreparedStatement ps = connect.prepareStatement(sql)) {
            ps.setInt(1, tenantId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt("days_left");
            }
        } catch (SQLException e) {
            System.err.println("Lỗi lấy số ngày còn lại của hợp đồng: " + e.getMessage());
        }
        return -1;
    }

    public List<Contracts> getTop5LatestContractsByManagerId(int managerId) {
        String sql = "SELECT TOP 5 c.* FROM contracts c "
                + "JOIN rooms r ON c.room_id = r.room_id "
                + "JOIN rental_areas ra ON r.rental_area_id = ra.rental_area_id "
                + "WHERE ra.manager_id = ? "
                + "ORDER BY c.contract_id DESC";
        List<Contracts> contracts = new ArrayList<>();
        try (PreparedStatement ps = connect.prepareStatement(sql)) {
            ps.setInt(1, managerId);
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
            return contracts;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return contracts;
    }

    // Get all contracts
    public ArrayList<Contracts> getAllContracts() {
        ArrayList<Contracts> contracts = new ArrayList<>();
        String sql = "SELECT [contract_id], [room_id], [tenant_id], [start_date], [end_date], "
                + "[rent_price], [deposit_amount], [status], [note] FROM [dbo].[contracts] "
                + "ORDER BY c.created_at DESC";

        try (PreparedStatement ps = connect.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {

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

        String sql = "INSERT INTO [dbo].[contracts] ([room_id], [tenant_id], [start_date], [end_date], "
                + "[rent_price], [deposit_amount], [status], [note]) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

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

        String sql = "UPDATE [dbo].[contracts] SET [room_id]=?, [tenant_id]=?, [start_date]=?, [end_date]=?, "
                + "[rent_price]=?, [deposit_amount]=?, [status]=?, [note]=? WHERE [contract_id]=?";

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
    public void deleteContract(int contractId) {
        if (contractId <= 0) {
            throw new IllegalArgumentException("Invalid contract ID");
        }

        String sql = "DELETE FROM [dbo].[contracts] WHERE [contract_id]=?";
        try (PreparedStatement ps = connect.prepareStatement(sql)) {
            ps.setInt(1, contractId);
            int rowsAffected = ps.executeUpdate();
            if (rowsAffected == 0) {
                throw new SQLException("No contract found with ID: " + contractId);
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error deleting contract: " + e.getMessage(), e);
        }
    }

    // Get contract by ID
    public Contracts getContractById(int id) {
        if (id <= 0) {
            throw new IllegalArgumentException("Invalid contract ID");
        }

        String sql = "SELECT c.[contract_id], c.[room_id], c.[tenant_id], c.[start_date], c.[end_date], "
                + "c.[rent_price], c.[deposit_amount], c.[status], c.[note], "
                + "r.room_number, ra.name AS area_name "
                + "FROM [dbo].[contracts] c "
                + "JOIN [dbo].[rooms] r ON c.room_id = r.room_id "
                + "JOIN [dbo].[rental_areas] ra ON r.rental_area_id = ra.rental_area_id "
                + "WHERE c.[contract_id]=?";

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
                c.setRoomNumber(rs.getString("room_number"));
                c.setAreaName(rs.getString("area_name"));
                return c;
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error fetching contract by ID: " + e.getMessage(), e);
        }

        return null;
    }

    // Get contracts by page for a specific manager (by managerId)
    public ArrayList<Contracts> getContractsByPage(int page, int pageSize, int managerId) {
        if (page < 1 || pageSize <= 0 || managerId <= 0) {
            throw new IllegalArgumentException("Invalid page, page size, or managerId");
        }

        ArrayList<Contracts> contracts = new ArrayList<>();
        String sql = "SELECT c.[contract_id], c.[room_id], c.[tenant_id], c.[start_date], c.[end_date], "
                + "c.[rent_price], c.[deposit_amount], c.[status], c.[note] ,r.room_number, ra.name, u.full_name "
                + "FROM [dbo].[contracts] c "
                + "JOIN [dbo].[rooms] r ON c.room_id = r.room_id "
                + "JOIN [dbo].[rental_areas] ra ON r.rental_area_id = ra.rental_area_id "
                + "JOIN dbo.users u ON u.user_id = c.tenant_id "
                + "WHERE ra.manager_id = ? "
                + "ORDER BY c.contract_id DESC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";

        try (PreparedStatement ps = connect.prepareStatement(sql)) {
            ps.setInt(1, managerId);
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
                c.setAreaName(rs.getString("name"));
                c.setRoomNumber(rs.getString("room_number"));
                c.setNameTelnant(rs.getString("full_name"));
                contracts.add(c);
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error fetching contracts by page for manager: " + e.getMessage(), e);
        }

        return contracts;
    }

    // Get contracts by page for specific tenant
    public ArrayList<Contracts> getContractsByPage2(int page, int pageSize, int tenantId) {
        if (page < 1 || pageSize <= 0 || tenantId <= 0) {
            throw new IllegalArgumentException("Invalid parameters");
        }

        ArrayList<Contracts> contracts = new ArrayList<>();
        String sql = "SELECT [contract_id], [room_id], [tenant_id], [start_date], [end_date], "
                + "[rent_price], [deposit_amount], [status], [note] FROM [dbo].[contracts] "
                + "WHERE [tenant_id] = ? ORDER BY [contract_id] OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";

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
        String sql = "SELECT [contract_id], [room_id], [tenant_id], [start_date], [end_date], "
                + "[rent_price], [deposit_amount], [status], [note] FROM [dbo].[contracts] "
                + "WHERE [tenant_id] = ? ORDER BY [contract_id]";

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
        String sql = "SELECT c.[contract_id], c.[room_id], c.[tenant_id], c.[start_date], c.[end_date], "
                + "c.[rent_price], c.[deposit_amount], c.[status], c.[note], r.room_number, ra.name, u.full_name "
                + "FROM [dbo].[contracts] c "
                + "JOIN [dbo].[rooms] r ON c.room_id = r.room_id "
                + "JOIN [dbo].[rental_areas] ra ON r.rental_area_id = ra.rental_area_id "
                + "JOIN [dbo].[users] u ON c.tenant_id = u.user_id "
                + "WHERE u.full_name LIKE ? OR r.room_number LIKE ? OR CAST(c.[contract_id] AS VARCHAR) LIKE ? OR "
                + "CAST(c.[rent_price] AS VARCHAR) LIKE ? OR c.[note] LIKE ?";

        try (PreparedStatement ps = connect.prepareStatement(sql)) {
            String searchPattern = "%" + keyword.trim() + "%";
            ps.setString(1, searchPattern); // tenant name
            ps.setString(2, searchPattern); // room number
            ps.setString(3, searchPattern); // contract id
            ps.setString(4, searchPattern); // rent price
            ps.setString(5, searchPattern); // note

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
                c.setAreaName(rs.getString("name"));
                c.setRoomNumber(rs.getString("room_number"));
                c.setNameTelnant(rs.getString("full_name"));
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
        String sql = "SELECT c.[contract_id], c.[room_id], c.[tenant_id], c.[start_date], c.[end_date], "
                + "c.[rent_price], c.[deposit_amount], c.[status], c.[note], r.room_number, ra.name, u.full_name "
                + "FROM [dbo].[contracts] c "
                + "JOIN [dbo].[rooms] r ON c.room_id = r.room_id "
                + "JOIN [dbo].[rental_areas] ra ON r.rental_area_id = ra.rental_area_id "
                + "JOIN [dbo].[users] u ON c.tenant_id = u.user_id "
                + "WHERE c.[tenant_id] = ? AND (u.full_name LIKE ? OR r.room_number LIKE ? OR "
                + "CAST(c.[contract_id] AS VARCHAR) LIKE ? OR CAST(c.[rent_price] AS VARCHAR) LIKE ? OR c.[note] LIKE ?)";

        try (PreparedStatement ps = connect.prepareStatement(sql)) {
            String searchPattern = "%" + keyword.trim() + "%";
            ps.setInt(1, tenantId);
            ps.setString(2, searchPattern); // tenant name
            ps.setString(3, searchPattern); // room number
            ps.setString(4, searchPattern); // contract id
            ps.setString(5, searchPattern); // rent price
            ps.setString(6, searchPattern); // note

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
                c.setAreaName(rs.getString("name"));
                c.setRoomNumber(rs.getString("room_number"));
                c.setNameTelnant(rs.getString("full_name"));
                contracts.add(c);
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error searching contracts by tenant: " + e.getMessage(), e);
        }

        return contracts;
    }

    // Count total contracts for a specific manager (by managerId)
    public int getTotalContracts(int managerId) {
        if (managerId <= 0) {
            throw new IllegalArgumentException("Invalid managerId");
        }
        String sql = "SELECT COUNT(*) FROM [dbo].[contracts] c "
                + "JOIN [dbo].[rooms] r ON c.room_id = r.room_id "
                + "JOIN [dbo].[rental_areas] ra ON r.rental_area_id = ra.rental_area_id "
                + "WHERE ra.manager_id = ?";
        try (PreparedStatement ps = connect.prepareStatement(sql)) {
            ps.setInt(1, managerId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error counting total contracts for manager: " + e.getMessage(), e);
        }
        return 0;
    }

    // Get contracts by status
    public ArrayList<Contracts> getContractsByStatus(int status) {
        ArrayList<Contracts> contracts = new ArrayList<>();
        String sql = "SELECT [contract_id], [room_id], [tenant_id], [start_date], [end_date], "
                + "[rent_price], [deposit_amount], [status], [note] FROM [dbo].[contracts] "
                + "WHERE [status] = ? ORDER BY [contract_id]";

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

    /**
     * Lấy 5 hợp đồng gần nhất (mới nhất) của 1 phòng (roomId), sắp xếp theo
     * start_date DESC
     */
    public ArrayList<Contracts> getTop5ContractsByRoom(int roomId) {
        ArrayList<Contracts> contracts = new ArrayList<>();
        String sql = "SELECT TOP 5 c.[contract_id], c.[room_id], c.[tenant_id], c.[start_date], c.[end_date], \n"
                + "c.[rent_price], c.[deposit_amount], c.[status], c.[note] ,r.room_number, ra.name, u.full_name\n"
                + "FROM [dbo].[contracts] c \n"
                + "JOIN [dbo].[rooms] r ON c.room_id = r.room_id \n"
                + "JOIN [dbo].[rental_areas] ra ON r.rental_area_id = ra.rental_area_id \n"
                + "JOIN dbo.users u ON u.user_id = c.tenant_id\n"
                + "WHERE r.room_id = ? \n"
                + "ORDER BY c.contract_id DESC";
        try (PreparedStatement ps = connect.prepareStatement(sql)) {
            ps.setInt(1, roomId);
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
                c.setNameTelnant(rs.getString("full_name"));
                contracts.add(c);
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error fetching top 5 contracts by room: " + e.getMessage(), e);
        }
        return contracts;
    }

    // Cập nhật trạng thái và tiền cọc của hợp đồng
    public boolean updateContractStatusAndDeposit(int contractId, int status, java.math.BigDecimal depositAmount) {
        String sql = "UPDATE [dbo].[contracts] SET [status]=?, [deposit_amount]=? WHERE [contract_id]=?";
        try (PreparedStatement ps = connect.prepareStatement(sql)) {
            ps.setInt(1, status);
            ps.setBigDecimal(2, depositAmount);
            ps.setInt(3, contractId);
            int rows = ps.executeUpdate();
            return rows > 0;
        } catch (SQLException e) {
            throw new RuntimeException("Error updating contract status/deposit: " + e.getMessage(), e);
        }
    }

    public String[] getDataRoomFromContractID(int contractID) {
        String sql = "SELECT DISTINCT room_number, r.name, u.email FROM dbo.contracts c\n"
                + "JOIN dbo.rooms ON rooms.room_id = c.room_id\n"
                + "JOIN dbo.rental_areas r ON r.rental_area_id = rooms.rental_area_id\n"
                + "JOIN dbo.users u ON u.user_id = c.tenant_id\n"
                + "WHERE c.contract_id = ?";
        String[] result = new String[3];
        try (PreparedStatement ps = connect.prepareStatement(sql)) {
            ps.setInt(1, contractID);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                result[0] = rs.getString(1);
                result[1] = rs.getString(2);
                result[2] = rs.getString(3);
            }
        } catch (SQLException e) {
            throw new RuntimeException("Error updating contract status/deposit: " + e.getMessage(), e);
        }
        return result;
    }

    /**
     * Đếm số hợp đồng mới trong tháng hiện tại cho manager (theo các phòng
     * thuộc khu của manager)
     *
     * @param managerId user_id của manager
     * @return số hợp đồng mới trong tháng
     */
    public int getNewContractsThisMonth(int managerId) {
        String sql = "SELECT COUNT(*) FROM contracts WHERE MONTH(start_date) = ? AND YEAR(start_date) = ? AND room_id IN (SELECT room_id FROM rooms WHERE rental_area_id IN (SELECT rental_area_id FROM rental_areas WHERE manager_id = ?))";
        try (PreparedStatement ps = connect.prepareStatement(sql)) {
            java.time.LocalDate now = java.time.LocalDate.now();
            ps.setInt(1, now.getMonthValue());
            ps.setInt(2, now.getYear());
            ps.setInt(3, managerId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            System.err.println("Lỗi lấy số hợp đồng mới trong tháng: " + e.getMessage());
        }
        return 0;
    }

    /**
     * Đếm số hợp đồng sắp hết hạn trong X ngày tới cho manager
     *
     * @param managerId user_id của manager
     * @param days số ngày tới (ví dụ 30)
     * @return số hợp đồng sắp hết hạn
     */
    public int getExpiringContracts(int managerId, int days) {
        String sql = "SELECT COUNT(*) FROM contracts c "
                + "JOIN rooms r ON c.room_id = r.room_id "
                + "JOIN rental_areas ra ON r.rental_area_id = ra.rental_area_id "
                + "WHERE ra.manager_id = ? "
                + "AND c.status = 1 "
                + "AND c.end_date IS NOT NULL "
                + "AND c.end_date BETWEEN ? AND ?";
        try (PreparedStatement ps = connect.prepareStatement(sql)) {
            java.time.LocalDate now = java.time.LocalDate.now();
            java.time.LocalDate future = now.plusDays(days);
            ps.setInt(1, managerId);
            ps.setDate(2, java.sql.Date.valueOf(now));
            ps.setDate(3, java.sql.Date.valueOf(future));
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            System.err.println("Lỗi lấy số hợp đồng sắp hết hạn: " + e.getMessage());
        }
        return 0;
    }

    // Test main method
    public static void main(String[] args) {
        try {
            DAOContract dao = DAOContract.INSTANCE;
//            System.out.println("Total contracts: " + dao.getTotalContracts());

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
