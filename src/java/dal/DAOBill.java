package dal;

import java.util.ArrayList;
import model.Bill;
import model.Users;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class DAOBill {
    
    public static final DAOBill INSTANCE = new DAOBill();
    protected Connection connect;

    public DAOBill() {
        connect = new DBContext().connect;
    }

    public static long millis = System.currentTimeMillis();
    public static Date today = new Date(millis);

    // Thêm hóa đơn mới
    public void addBill(Bill bill) {
        String sql = "INSERT INTO tbBills (TenantName, RoomNumber, ElectricityCost, WaterCost, ServiceCost, Total, DueDate, Status, CreatedDate) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (PreparedStatement ps = connect.prepareStatement(sql)) {
            ps.setString(1, bill.getTenantName());
            ps.setString(2, bill.getRoomNumber());
            ps.setDouble(3, bill.getElectricityCost());
            ps.setDouble(4, bill.getWaterCost());
            ps.setDouble(5, bill.getServiceCost());
            ps.setDouble(6, bill.getTotal());
            ps.setString(7, bill.getDueDate());
            ps.setString(8, bill.getStatus());
            ps.setString(9, bill.getCreatedDate());
            ps.executeUpdate();
            System.out.println("✅ Thêm hóa đơn thành công!");
        } catch (SQLException e) {
            System.err.println("❌ Lỗi thêm hóa đơn: " + e.getMessage());
            e.printStackTrace();
        }
    }

    // Lấy tất cả hóa đơn, kiểm tra roleID từ Users
    public ArrayList<Bill> getAllBills(Users user) {
        ArrayList<Bill> bills = new ArrayList<>();
        if (user == null) {
            System.err.println("❌ Không tìm thấy thông tin người dùng!");
            return bills;
        }

        int roleID = user.getRoleId();
        String tenantName = user.getFullName();
        String sql = (roleID != 3)
            ? "SELECT * FROM tbBills ORDER BY CreatedDate DESC"
            : "SELECT * FROM tbBills WHERE TenantName = ? ORDER BY CreatedDate DESC";

        try (PreparedStatement ps = connect.prepareStatement(sql)) {
            if (roleID == 3) {
                ps.setString(1, tenantName);
            }
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Bill bill = new Bill();
                bill.setId(rs.getInt("ID"));
                bill.setTenantName(rs.getString("TenantName"));
                bill.setRoomNumber(rs.getString("RoomNumber"));
                bill.setElectricityCost(rs.getDouble("ElectricityCost"));
                bill.setWaterCost(rs.getDouble("WaterCost"));
                bill.setServiceCost(rs.getDouble("ServiceCost"));
                bill.setTotal(rs.getDouble("Total"));
                bill.setDueDate(rs.getString("DueDate"));
                bill.setStatus(rs.getString("Status"));
                bill.setCreatedDate(rs.getString("CreatedDate"));
                bills.add(bill);
            }
        } catch (SQLException e) {
            System.err.println("❌ Lỗi lấy danh sách hóa đơn: " + e.getMessage());
            e.printStackTrace();
        }
        return bills;
    }

    // Lấy hóa đơn theo ID
    public Bill getBillById(int id) {
        String sql = "SELECT * FROM tbBills WHERE ID = ?";
        try (PreparedStatement ps = connect.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Bill bill = new Bill();
                bill.setId(rs.getInt("ID"));
                bill.setTenantName(rs.getString("TenantName"));
                bill.setRoomNumber(rs.getString("RoomNumber"));
                bill.setElectricityCost(rs.getDouble("ElectricityCost"));
                bill.setWaterCost(rs.getDouble("WaterCost"));
                bill.setServiceCost(rs.getDouble("ServiceCost"));
                bill.setTotal(rs.getDouble("Total"));
                bill.setDueDate(rs.getString("DueDate"));
                bill.setStatus(rs.getString("Status"));
                bill.setCreatedDate(rs.getString("CreatedDate"));
                return bill;
            }
        } catch (SQLException e) {
            System.err.println("❌ Lỗi lấy hóa đơn theo ID: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }

    // Cập nhật hóa đơn
    public void updateBill(Bill bill) {
        String sql = "UPDATE tbBills SET TenantName = ?, RoomNumber = ?, ElectricityCost = ?, WaterCost = ?, ServiceCost = ?, Total = ?, DueDate = ?, Status = ? WHERE ID = ?";
        try (PreparedStatement ps = connect.prepareStatement(sql)) {
            ps.setString(1, bill.getTenantName());
            ps.setString(2, bill.getRoomNumber());
            ps.setDouble(3, bill.getElectricityCost());
            ps.setDouble(4, bill.getWaterCost());
            ps.setDouble(5, bill.getServiceCost());
            ps.setDouble(6, bill.getTotal());
            ps.setString(7, bill.getDueDate());
            ps.setString(8, bill.getStatus());
            ps.setInt(9, bill.getId());
            ps.executeUpdate();
            System.out.println("✅ Cập nhật hóa đơn thành công!");
        } catch (SQLException e) {
            System.err.println("❌ Lỗi cập nhật hóa đơn: " + e.getMessage());
            e.printStackTrace();
        }
    }

    // Xóa hóa đơn
    public void deleteBill(int id) {
        String sql = "DELETE FROM tbBills WHERE ID = ?";
        try (PreparedStatement ps = connect.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.executeUpdate();
            System.out.println("✅ Xóa hóa đơn thành công!");
        } catch (SQLException e) {
            System.err.println("❌ Lỗi xóa hóa đơn: " + e.getMessage());
            e.printStackTrace();
        }
    }

    // Tìm kiếm hóa đơn theo tên người thuê (không phân trang)
    public ArrayList<Bill> searchBillsByTenantName(String tenantName) {
        ArrayList<Bill> bills = new ArrayList<>();
        String sql = "SELECT * FROM tbBills WHERE TenantName LIKE ? ORDER BY CreatedDate DESC";
        try (PreparedStatement ps = connect.prepareStatement(sql)) {
            ps.setString(1, "%" + tenantName + "%");
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Bill bill = new Bill();
                bill.setId(rs.getInt("ID"));
                bill.setTenantName(rs.getString("TenantName"));
                bill.setRoomNumber(rs.getString("RoomNumber"));
                bill.setElectricityCost(rs.getDouble("ElectricityCost"));
                bill.setWaterCost(rs.getDouble("WaterCost"));
                bill.setServiceCost(rs.getDouble("ServiceCost"));
                bill.setTotal(rs.getDouble("Total"));
                bill.setDueDate(rs.getString("DueDate"));
                bill.setStatus(rs.getString("Status"));
                bill.setCreatedDate(rs.getString("CreatedDate"));
                bills.add(bill);
            }
        } catch (SQLException e) {
            System.err.println("❌ Lỗi tìm kiếm hóa đơn theo tên: " + e.getMessage());
            e.printStackTrace();
        }
        return bills;
    }

    // Tìm kiếm hóa đơn theo tên người thuê (có phân trang)
    public ArrayList<Bill> searchBillsByTenantName(String tenantName, int page, int billsPerPage) {
        ArrayList<Bill> bills = new ArrayList<>();
        String sql = "SELECT * FROM tbBills WHERE TenantName LIKE ? ORDER BY CreatedDate DESC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
        try (PreparedStatement ps = connect.prepareStatement(sql)) {
            ps.setString(1, "%" + tenantName + "%");
            ps.setInt(2, (page - 1) * billsPerPage);
            ps.setInt(3, billsPerPage);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Bill bill = new Bill();
                bill.setId(rs.getInt("ID"));
                bill.setTenantName(rs.getString("TenantName"));
                bill.setRoomNumber(rs.getString("RoomNumber"));
                bill.setElectricityCost(rs.getDouble("ElectricityCost"));
                bill.setWaterCost(rs.getDouble("WaterCost"));
                bill.setServiceCost(rs.getDouble("ServiceCost"));
                bill.setTotal(rs.getDouble("Total"));
                bill.setDueDate(rs.getString("DueDate"));
                bill.setStatus(rs.getString("Status"));
                bill.setCreatedDate(rs.getString("CreatedDate"));
                bills.add(bill);
            }
        } catch (SQLException e) {
            System.err.println("❌ Lỗi tìm kiếm hóa đơn theo tên (phân trang): " + e.getMessage());
            e.printStackTrace();
        }
        return bills;
    }

    // Đếm số hóa đơn theo tên người thuê
    public int countBillsByTenantName(String tenantName) {
        String sql = "SELECT COUNT(*) FROM tbBills WHERE TenantName LIKE ?";
        try (PreparedStatement ps = connect.prepareStatement(sql)) {
            ps.setString(1, "%" + tenantName + "%");
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            System.err.println("❌ Lỗi đếm hóa đơn theo tên: " + e.getMessage());
            e.printStackTrace();
        }
        return 0;
    }

    // Tìm kiếm hóa đơn theo số phòng (không phân trang)
    public ArrayList<Bill> searchBillsByRoomNumber(String roomNumber) {
        ArrayList<Bill> bills = new ArrayList<>();
        String sql = "SELECT * FROM tbBills WHERE RoomNumber LIKE ? ORDER BY CreatedDate DESC";
        try (PreparedStatement ps = connect.prepareStatement(sql)) {
            ps.setString(1, "%" + roomNumber + "%");
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Bill bill = new Bill();
                bill.setId(rs.getInt("ID"));
                bill.setTenantName(rs.getString("TenantName"));
                bill.setRoomNumber(rs.getString("RoomNumber"));
                bill.setElectricityCost(rs.getDouble("ElectricityCost"));
                bill.setWaterCost(rs.getDouble("WaterCost"));
                bill.setServiceCost(rs.getDouble("ServiceCost"));
                bill.setTotal(rs.getDouble("Total"));
                bill.setDueDate(rs.getString("DueDate"));
                bill.setStatus(rs.getString("Status"));
                bill.setCreatedDate(rs.getString("CreatedDate"));
                bills.add(bill);
            }
        } catch (SQLException e) {
            System.err.println("❌ Lỗi tìm kiếm hóa đơn theo số phòng: " + e.getMessage());
            e.printStackTrace();
        }
        return bills;
    }

    // Tìm kiếm hóa đơn theo số phòng (có phân trang)
    public ArrayList<Bill> searchBillsByRoomNumber(String roomNumber, int page, int billsPerPage) {
        ArrayList<Bill> bills = new ArrayList<>();
        String sql = "SELECT * FROM tbBills WHERE RoomNumber LIKE ? ORDER BY CreatedDate DESC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
        try (PreparedStatement ps = connect.prepareStatement(sql)) {
            ps.setString(1, "%" + roomNumber + "%");
            ps.setInt(2, (page - 1) * billsPerPage);
            ps.setInt(3, billsPerPage);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Bill bill = new Bill();
                bill.setId(rs.getInt("ID"));
                bill.setTenantName(rs.getString("TenantName"));
                bill.setRoomNumber(rs.getString("RoomNumber"));
                bill.setElectricityCost(rs.getDouble("ElectricityCost"));
                bill.setWaterCost(rs.getDouble("WaterCost"));
                bill.setServiceCost(rs.getDouble("ServiceCost"));
                bill.setTotal(rs.getDouble("Total"));
                bill.setDueDate(rs.getString("DueDate"));
                bill.setStatus(rs.getString("Status"));
                bill.setCreatedDate(rs.getString("CreatedDate"));
                bills.add(bill);
            }
        } catch (SQLException e) {
            System.err.println("❌ Lỗi tìm kiếm hóa đơn theo số phòng (phân trang): " + e.getMessage());
            e.printStackTrace();
        }
        return bills;
    }

    // Đếm số hóa đơn theo số phòng
    public int countBillsByRoomNumber(String roomNumber) {
        String sql = "SELECT COUNT(*) FROM tbBills WHERE RoomNumber LIKE ?";
        try (PreparedStatement ps = connect.prepareStatement(sql)) {
            ps.setString(1, "%" + roomNumber + "%");
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            System.err.println("❌ Lỗi đếm hóa đơn theo số phòng: " + e.getMessage());
            e.printStackTrace();
        }
        return 0;
    }

    // Lấy hóa đơn theo trạng thái (không phân trang, sửa lỗi thiếu setter)
    public ArrayList<Bill> getBillsByStatus(Users user, String status) {
        ArrayList<Bill> bills = new ArrayList<>();
        if (user == null) {
            System.err.println("❌ Không tìm thấy thông tin người dùng!");
            return bills;
        }

        int roleID = user.getRoleId();
        String tenantName = user.getFullName();
        String sql = (roleID != 3) ? 
            "SELECT * FROM tbBills WHERE Status = ? ORDER BY CreatedDate DESC" : 
            "SELECT * FROM tbBills WHERE Status = ? AND TenantName = ? ORDER BY CreatedDate DESC";

        try (PreparedStatement ps = connect.prepareStatement(sql)) {
            if (roleID != 3) {
                ps.setString(1, status);
            } else {
                ps.setString(1, status);
                ps.setString(2, tenantName);
            }
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Bill bill = new Bill();
                bill.setId(rs.getInt("ID"));
                bill.setTenantName(rs.getString("TenantName"));
                bill.setRoomNumber(rs.getString("RoomNumber"));
                bill.setElectricityCost(rs.getDouble("ElectricityCost"));
                bill.setWaterCost(rs.getDouble("WaterCost")); // Đã thêm
                bill.setServiceCost(rs.getDouble("ServiceCost")); // Đã thêm
                bill.setTotal(rs.getDouble("Total"));
                bill.setDueDate(rs.getString("DueDate"));
                bill.setStatus(rs.getString("Status"));
                bill.setCreatedDate(rs.getString("CreatedDate"));
                bills.add(bill);
            }
        } catch (SQLException e) {
            System.err.println("❌ Lỗi lấy hóa đơn theo trạng thái: " + e.getMessage());
            e.printStackTrace();
        }
        return bills;
    }

    // Lấy hóa đơn theo trạng thái (có phân trang)
    public ArrayList<Bill> getBillsByStatus(Users user, String status, int page, int billsPerPage) {
        ArrayList<Bill> bills = new ArrayList<>();
        if (user == null) {
            System.err.println("❌ Không tìm thấy thông tin người dùng!");
            return bills;
        }

        int roleID = user.getRoleId();
        String tenantName = user.getFullName();
        String sql = (roleID != 3) ? 
            "SELECT * FROM tbBills WHERE Status = ? ORDER BY CreatedDate DESC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY" : 
            "SELECT * FROM tbBills WHERE Status = ? AND TenantName = ? ORDER BY CreatedDate DESC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";

        try (PreparedStatement ps = connect.prepareStatement(sql)) {
            if (roleID != 3) {
                ps.setString(1, status);
                ps.setInt(2, (page - 1) * billsPerPage);
                ps.setInt(3, billsPerPage);
            } else {
                ps.setString(1, status);
                ps.setString(2, tenantName);
                ps.setInt(3, (page - 1) * billsPerPage);
                ps.setInt(4, billsPerPage);
            }
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Bill bill = new Bill();
                bill.setId(rs.getInt("ID"));
                bill.setTenantName(rs.getString("TenantName"));
                bill.setRoomNumber(rs.getString("RoomNumber"));
                bill.setElectricityCost(rs.getDouble("ElectricityCost"));
                bill.setWaterCost(rs.getDouble("WaterCost"));
                bill.setServiceCost(rs.getDouble("ServiceCost"));
                bill.setTotal(rs.getDouble("Total"));
                bill.setDueDate(rs.getString("DueDate"));
                bill.setStatus(rs.getString("Status"));
                bill.setCreatedDate(rs.getString("CreatedDate"));
                bills.add(bill);
            }
        } catch (SQLException e) {
            System.err.println("❌ Lỗi lấy hóa đơn theo trạng thái (phân trang): " + e.getMessage());
            e.printStackTrace();
        }
        return bills;
    }

    // Đếm số hóa đơn theo trạng thái
    public int countBillsByStatus(Users user, String status) {
        if (user == null) {
            System.err.println("❌ Không tìm thấy thông tin người dùng!");
            return 0;
        }

        int roleID = user.getRoleId();
        String tenantName = user.getFullName();
        String sql = (roleID != 3) ? 
            "SELECT COUNT(*) FROM tbBills WHERE Status = ?" : 
            "SELECT COUNT(*) FROM tbBills WHERE Status = ? AND TenantName = ?";

        try (PreparedStatement ps = connect.prepareStatement(sql)) {
            if (roleID != 3) {
                ps.setString(1, status);
            } else {
                ps.setString(1, status);
                ps.setString(2, tenantName);
            }
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            System.err.println("❌ Lỗi đếm hóa đơn theo trạng thái: " + e.getMessage());
            e.printStackTrace();
        }
        return 0;
    }

    // Cập nhật trạng thái hóa đơn
    public void updateBillStatus(int id, String status) {
        String sql = "UPDATE tbBills SET Status = ? WHERE ID = ?";
        try (PreparedStatement ps = connect.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, id);
            ps.executeUpdate();
            System.out.println("✅ Cập nhật trạng thái hóa đơn thành công!");
        } catch (SQLException e) {
            System.err.println("❌ Lỗi cập nhật trạng thái hóa đơn: " + e.getMessage());
            e.printStackTrace();
        }
    }

    // Đếm tổng số hóa đơn
    public int getTotalBills(Users user) {
        if (user == null) {
            System.err.println("❌ Không tìm thấy thông tin người dùng!");
            return 0;
        }
        int roleID = user.getRoleId();
        String tenantName = user.getFullName();
        String sql = (roleID != 3) ? 
            "SELECT COUNT(*) FROM tbBills" : 
            "SELECT COUNT(*) FROM tbBills WHERE TenantName = ?";
       
        try (PreparedStatement ps = connect.prepareStatement(sql)) {
            if (roleID == 3) { // Sửa điều kiện từ != 1 thành == 3
                ps.setString(1, tenantName);
            }
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            System.err.println("❌ Lỗi đếm hóa đơn: " + e.getMessage());
            e.printStackTrace();
        }
        return 0;
    }

    // Phân trang hóa đơn
    public ArrayList<Bill> getBillsByPage(Users user, int page, int billsPerPage) {
        ArrayList<Bill> bills = new ArrayList<>();
        if (user == null) {
            System.err.println("❌ Không tìm thấy thông tin người dùng!");
            return bills;
        }

        int roleID = user.getRoleId();
        String tenantName = user.getFullName();
        String sql = (roleID != 3) ? 
            "SELECT * FROM tbBills ORDER BY CreatedDate DESC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY" : 
            "SELECT * FROM tbBills WHERE TenantName = ? ORDER BY CreatedDate DESC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";

        try (PreparedStatement ps = connect.prepareStatement(sql)) {
            if (roleID != 3) {
                ps.setInt(1, (page - 1) * billsPerPage);
                ps.setInt(2, billsPerPage);
            } else {
                ps.setString(1, tenantName);
                ps.setInt(2, (page - 1) * billsPerPage);
                ps.setInt(3, billsPerPage);
            }
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Bill bill = new Bill();
                bill.setId(rs.getInt("ID"));
                bill.setTenantName(rs.getString("TenantName"));
                bill.setRoomNumber(rs.getString("RoomNumber"));
                bill.setElectricityCost(rs.getDouble("ElectricityCost"));
                bill.setWaterCost(rs.getDouble("WaterCost"));
                bill.setServiceCost(rs.getDouble("ServiceCost"));
                bill.setTotal(rs.getDouble("Total"));
                bill.setDueDate(rs.getString("DueDate"));
                bill.setStatus(rs.getString("Status"));
                bill.setCreatedDate(rs.getString("CreatedDate"));
                bills.add(bill);
            }
        } catch (SQLException e) {
            System.err.println("❌ Lỗi phân trang hóa đơn: " + e.getMessage());
            e.printStackTrace();
        }
        return bills;
    }

    // Tính tổng số trang
    public int getTotalPages(Users user, int billsPerPage) {
        if (billsPerPage < 1) {
            return 0;
        }
        int totalBills = getTotalBills(user);
        return (int) Math.ceil((double) totalBills / billsPerPage);
    }

    // Tính tổng doanh thu (chỉ dành cho quản lý)
    public double getTotalRevenue(Users user) {
//        if (user == null || user.getRoleId() != 1) {
//            System.err.println("❌ Chỉ quản lý (roleID = 1) được phép xem tổng doanh thu!");
//            return 0.0;
//        }

        String sql = "SELECT SUM(Total) FROM tbBills WHERE Status = 'Paid'";
        try (PreparedStatement ps = connect.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getDouble(1);
            }
        } catch (SQLException e) {
            System.err.println("❌ Lỗi tính tổng doanh thu: " + e.getMessage());
            e.printStackTrace();
        }
        return 0.0;
    }

    // Lấy hóa đơn chưa thanh toán
    public ArrayList<Bill> getUnpaidBills(Users user) {
        return getBillsByStatus(user, "Unpaid");
    }

    // Lấy hóa đơn đã thanh toán
    public ArrayList<Bill> getPaidBills(Users user) {
        return getBillsByStatus(user, "Paid");
    }

    // Lấy danh sách tên người thuê duy nhất (chỉ dành cho quản lý)
    public ArrayList<String> getDistinctTenants(Users user) {
        ArrayList<String> tenants = new ArrayList<>();
        if (user == null || user.getRoleId() != 1) {
            System.err.println("❌ Chỉ quản lý (roleID = 1) được phép xem danh sách người thuê!");
            return tenants;
        }

        String sql = "SELECT DISTINCT TenantName FROM tbBills ORDER BY TenantName";
        try (PreparedStatement ps = connect.prepareStatement(sql); 
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                tenants.add(rs.getString("TenantName"));
            }
        } catch (SQLException e) {
            System.err.println("❌ Lỗi lấy danh sách người thuê: " + e.getMessage());
            e.printStackTrace();
        }
        return tenants;
    }

    // Lấy danh sách số phòng duy nhất (chỉ dành cho quản lý)
    public ArrayList<String> getDistinctRooms(Users user) {
        ArrayList<String> rooms = new ArrayList<>();
        if (user == null || user.getRoleId() != 1) {
            System.err.println("❌ Chỉ quản lý (roleID = 1) được phép xem danh sách phòng!");
            return rooms;
        }

        String sql = "SELECT DISTINCT RoomNumber FROM tbBills ORDER BY RoomNumber";
        try (PreparedStatement ps = connect.prepareStatement(sql); 
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                rooms.add(rs.getString("RoomNumber"));
            }
        } catch (SQLException e) {
            System.err.println("❌ Lỗi lấy danh sách phòng: " + e.getMessage());
            e.printStackTrace();
        }
        return rooms;
    }

    // Test method
    public static void main(String[] args) {
        DAOBill dao = new DAOBill();
        
        // Test thêm hóa đơn
        Bill testBill = new Bill();
        testBill.setTenantName("Nguyễn Văn A");
        testBill.setRoomNumber("A101");
        testBill.setElectricityCost(150000);
        testBill.setWaterCost(50000);
        testBill.setServiceCost(100000);
        testBill.setTotal(300000);
        testBill.setDueDate("2024-01-15");
        testBill.setStatus("Unpaid");
        testBill.setCreatedDate("2024-01-01");
        
        dao.addBill(testBill);
    }
}