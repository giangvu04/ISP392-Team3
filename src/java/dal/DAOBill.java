package dal;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import model.Bill;
import model.Users;

public class DAOBill {

    /**
     * Lấy danh sách hóa đơn chưa thanh toán của tenant
     *
     * @param tenantId user_id của tenant
     * @return ArrayList<Bill> hóa đơn chưa thanh toán
     */
    public ArrayList<Bill> getUnpaidBillsByTenantId(int tenantId) {
        ArrayList<Bill> bills = new ArrayList<>();
        String sql = "SELECT * FROM tbBills WHERE TenantID = ? AND Status = 'Unpaid'";
        try (PreparedStatement ps = connect.prepareStatement(sql)) {
            ps.setInt(1, tenantId);
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
                bill.setEmailTelnant(rs.getString("EmailTelnant"));
                // bill.setPhoneTelnant(rs.getString("PhoneTelnant")); // Nếu Bill có field này
                bills.add(bill);
            }
        } catch (SQLException e) {
            System.err.println("Lỗi lấy hóa đơn chưa thanh toán: " + e.getMessage());
        }
        return bills;
    }

    /**
     * Tính tổng doanh thu tháng hiện tại cho manager
     *
     * @param managerId user_id của manager
     * @return tổng doanh thu tháng hiện tại (double)
     */
    public double getMonthlyRevenue(int managerId) {
        String sql = "SELECT ISNULL(SUM(b.Total), 0) AS MonthlyRevenue "
                + "FROM tbBills b "
                + "JOIN rooms r ON b.RoomID = r.room_id "
                + "JOIN rental_areas ra ON r.rental_area_id = ra.rental_area_id "
                + "WHERE ra.manager_id = ? "
                + "AND b.Status = 'Paid' "
                + "AND MONTH(CONVERT(date, b.CreatedDate, 120)) = MONTH(GETDATE()) "
                + "AND YEAR(CONVERT(date, b.CreatedDate, 120)) = YEAR(GETDATE())";
        try (PreparedStatement ps = connect.prepareStatement(sql)) {
            ps.setInt(1, managerId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getDouble("MonthlyRevenue");
            }
        } catch (SQLException e) {
            System.err.println("❌ Lỗi tính doanh thu tháng: " + e.getMessage());
            e.printStackTrace();
        }
        return 0.0;
    }
    // --- Thống kê cho dashboard quản lý ---
    /**
     * Thống kê tổng số phòng, số phòng đã thuê, số phòng trống cho dashboard
     * manager
     *
     * @param managerId id của manager (user_id)
     * @return int[]{totalRooms, rentedRooms, vacantRooms}
     */

    public static final DAOBill INSTANCE = new DAOBill();
    protected Connection connect;

    public DAOBill() {
        connect = new DBContext().connect;
    }

    public static long millis = System.currentTimeMillis();
    public static Date today = new Date(millis);

    // Thêm hóa đơn mới (hợp lý với BillServlet và tbBills schema)
    public void addBill(Bill bill, int tenantId, int roomId) {
        String sql = "INSERT INTO tbBills (TenantID, RoomID, TenantName, RoomNumber, RoomCost, ElectricityCost, WaterCost, ServiceCost, OtherServiceCost, Total, DueDate, Status, CreatedDate, EmailTelnant, PhoneTelnant, Note ) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (PreparedStatement ps = connect.prepareStatement(sql)) {
            ps.setInt(1, tenantId);
            ps.setInt(2, roomId);
            ps.setString(3, bill.getTenantName());
            ps.setString(4, bill.getRoomNumber());
            ps.setDouble(5, bill.getRoomCost());
            ps.setDouble(6, bill.getElectricityCost());
            ps.setDouble(7, bill.getWaterCost());
            ps.setDouble(8, bill.getServiceCost());
            ps.setDouble(9, bill.getOtherServiceCost());
            ps.setDouble(10, bill.getTotal());
            ps.setString(11, bill.getDueDate());
            ps.setString(12, bill.getStatus());
            ps.setString(13, bill.getCreatedDate());
            ps.setString(14, bill.getEmailTelnant() != null ? bill.getEmailTelnant() : null);
            ps.setString(15, null); // Bill model chưa có phoneTelnant, để null
            ps.setString(16, bill.getNote());
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
        int tenantId = user.getUserId();
        int managerId = user.getUserId();
        String sql;
        if (roleID == 2) {
            sql = "SELECT b.*, u.full_name AS managerName FROM tbBills b "
                    + "JOIN rooms r ON b.RoomID = r.room_id "
                    + "JOIN rental_areas ra ON r.rental_area_id = ra.rental_area_id "
                    + "JOIN users u ON ra.manager_id = u.user_id "
                    + "WHERE ra.manager_id = ? "
                    + "ORDER BY b.CreatedDate DESC";
        } else if (roleID == 3) {
            sql = "SELECT b.*, u.full_name AS managerName FROM tbBills b "
                    + "JOIN rooms r ON b.RoomID = r.room_id "
                    + "JOIN rental_areas ra ON r.rental_area_id = ra.rental_area_id "
                    + "JOIN users u ON ra.manager_id = u.user_id "
                    + "WHERE b.TenantID = ? "
                    + "ORDER BY b.CreatedDate DESC";
        } else {
            sql = "SELECT b.*, u.full_name AS managerName FROM tbBills b "
                    + "JOIN rooms r ON b.RoomID = r.room_id "
                    + "JOIN rental_areas ra ON r.rental_area_id = ra.rental_area_id "
                    + "JOIN users u ON ra.manager_id = u.user_id "
                    + "ORDER BY b.CreatedDate DESC";
        }

        try (PreparedStatement ps = connect.prepareStatement(sql)) {
            if (roleID == 2) {
                ps.setInt(1, managerId);
            } else if (roleID == 3) {
                ps.setInt(1, tenantId);
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
                bill.setEmailTelnant(rs.getString("EmailTelnant"));
                bill.setManagerName(rs.getString("managerName"));
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
        String sql = "SELECT b.*, u.full_name AS managerName FROM tbBills b "
                + "JOIN rooms r ON b.RoomID = r.room_id "
                + "JOIN rental_areas ra ON r.rental_area_id = ra.rental_area_id "
                + "JOIN users u ON ra.manager_id = u.user_id "
                + "WHERE b.ID = ?";
        try (PreparedStatement ps = connect.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Bill bill = new Bill();
                bill.setId(rs.getInt("ID"));
                bill.setTenantName(rs.getString("TenantName"));
                bill.setRoomNumber(rs.getString("RoomNumber"));
                bill.setRoomCost(rs.getDouble("RoomCost") != 0 ? rs.getDouble("RoomCost") : 0);
                bill.setElectricityCost(rs.getDouble("ElectricityCost"));
                bill.setWaterCost(rs.getDouble("WaterCost"));
                bill.setServiceCost(rs.getDouble("ServiceCost"));
                bill.setOtherServiceCost(rs.getDouble("OtherServiceCost") != 0 ? rs.getDouble("OtherServiceCost") : 0);
                bill.setTotal(rs.getDouble("Total"));
                bill.setDueDate(rs.getString("DueDate"));
                bill.setStatus(rs.getString("Status"));
                bill.setCreatedDate(rs.getString("CreatedDate"));
                bill.setEmailTelnant(rs.getString("EmailTelnant"));
                bill.setManagerName(rs.getString("managerName"));
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
        String sql = "UPDATE tbBills SET TenantName = ?, RoomNumber = ?, RoomCost = ?, ElectricityCost = ?, WaterCost = ?, ServiceCost = ?, OtherServiceCost = ?, Total = ?, DueDate = ?, Status = ? WHERE ID = ?";
        try (PreparedStatement ps = connect.prepareStatement(sql)) {
            ps.setString(1, bill.getTenantName());
            ps.setString(2, bill.getRoomNumber());
            ps.setDouble(3, bill.getRoomCost());
            ps.setDouble(4, bill.getElectricityCost());
            ps.setDouble(5, bill.getWaterCost());
            ps.setDouble(6, bill.getServiceCost());
            ps.setDouble(7, bill.getOtherServiceCost());
            ps.setDouble(8, bill.getTotal());
            ps.setString(9, bill.getDueDate());
            ps.setString(10, bill.getStatus());
            ps.setInt(11, bill.getId());
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
        String sql = "SELECT b.*, u.full_name AS managerName FROM tbBills b "
                + "JOIN rooms r ON b.RoomID = r.room_id "
                + "JOIN rental_areas ra ON r.rental_area_id = ra.rental_area_id "
                + "JOIN users u ON ra.manager_id = u.user_id "
                + "WHERE b.TenantName LIKE ? ORDER BY b.CreatedDate DESC";
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
                bill.setEmailTelnant(rs.getString("EmailTelnant"));
                bill.setManagerName(rs.getString("managerName"));
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
        String sql = "SELECT b.*, u.full_name AS managerName FROM tbBills b "
                + "JOIN rooms r ON b.RoomID = r.room_id "
                + "JOIN rental_areas ra ON r.rental_area_id = ra.rental_area_id "
                + "JOIN users u ON ra.manager_id = u.user_id "
                + "WHERE b.TenantName LIKE ? ORDER BY b.ID DESC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
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
                bill.setEmailTelnant(rs.getString("EmailTelnant"));
                bill.setManagerName(rs.getString("managerName"));
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
        String sql = "SELECT COUNT(*) FROM tbBills b "
                + "JOIN rooms r ON b.RoomID = r.room_id "
                + "JOIN rental_areas ra ON r.rental_area_id = ra.rental_area_id "
                + "JOIN users u ON ra.manager_id = u.user_id "
                + "WHERE b.TenantName LIKE ?";
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
        String sql = "SELECT b.*, u.full_name AS managerName FROM tbBills b "
                + "JOIN rooms r ON b.RoomID = r.room_id "
                + "JOIN rental_areas ra ON r.rental_area_id = ra.rental_area_id "
                + "JOIN users u ON ra.manager_id = u.user_id "
                + "WHERE b.RoomNumber LIKE ? ORDER BY b.CreatedDate DESC";
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
                bill.setEmailTelnant(rs.getString("EmailTelnant"));
                bill.setManagerName(rs.getString("managerName"));
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
        String sql = "SELECT b.*, u.full_name AS managerName FROM tbBills b "
                + "JOIN rooms r ON b.RoomID = r.room_id "
                + "JOIN rental_areas ra ON r.rental_area_id = ra.rental_area_id "
                + "JOIN users u ON ra.manager_id = u.user_id "
                + "WHERE b.RoomNumber LIKE ? ORDER BY b.ID DESC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
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
                bill.setEmailTelnant(rs.getString("EmailTelnant"));
                bill.setManagerName(rs.getString("managerName"));
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
        String sql = "SELECT COUNT(*) FROM tbBills b "
                + "JOIN rooms r ON b.RoomID = r.room_id "
                + "JOIN rental_areas ra ON r.rental_area_id = ra.rental_area_id "
                + "JOIN users u ON ra.manager_id = u.user_id "
                + "WHERE b.RoomNumber LIKE ?";
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
        int tenantId = user.getUserId();
        int managerId = user.getUserId();
        String sql;
        if (roleID == 2) {
            sql = "SELECT b.*, u.full_name AS managerName FROM tbBills b "
                    + "JOIN rooms r ON b.RoomID = r.room_id "
                    + "JOIN rental_areas ra ON r.rental_area_id = ra.rental_area_id "
                    + "JOIN users u ON ra.manager_id = u.user_id "
                    + "WHERE ra.manager_id = ? AND b.Status = ? "
                    + "ORDER BY b.CreatedDate DESC";
        } else if (roleID == 3) {
            sql = "SELECT b.*, u.full_name AS managerName FROM tbBills b "
                    + "JOIN rooms r ON b.RoomID = r.room_id "
                    + "JOIN rental_areas ra ON r.rental_area_id = ra.rental_area_id "
                    + "JOIN users u ON ra.manager_id = u.user_id "
                    + "WHERE b.TenantID = ? AND b.Status = ? "
                    + "ORDER BY b.CreatedDate DESC";
        } else {
            sql = "SELECT b.*, u.full_name AS managerName FROM tbBills b "
                    + "JOIN rooms r ON b.RoomID = r.room_id "
                    + "JOIN rental_areas ra ON r.rental_area_id = ra.rental_area_id "
                    + "JOIN users u ON ra.manager_id = u.user_id "
                    + "WHERE b.Status = ? "
                    + "ORDER BY b.CreatedDate DESC";
        }

        try (PreparedStatement ps = connect.prepareStatement(sql)) {
            if (roleID == 2) {
                ps.setInt(1, managerId);
                ps.setString(2, status);
            } else if (roleID == 3) {
                ps.setInt(1, tenantId);
                ps.setString(2, status);
            } else {
                ps.setString(1, status);
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
                bill.setEmailTelnant(rs.getString("EmailTelnant"));
                bill.setManagerName(rs.getString("managerName"));
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
        int tenantId = user.getUserId();
        int managerId = user.getUserId();
        String sql;
        if (roleID == 2) {
            sql = "SELECT b.*, u.full_name AS managerName FROM tbBills b "
                    + "JOIN rooms r ON b.RoomID = r.room_id "
                    + "JOIN rental_areas ra ON r.rental_area_id = ra.rental_area_id "
                    + "JOIN users u ON ra.manager_id = u.user_id "
                    + "WHERE ra.manager_id = ? AND b.Status = ? "
                    + "ORDER BY b.ID DESC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
        } else if (roleID == 3) {
            sql = "SELECT b.*, u.full_name AS managerName FROM tbBills b "
                    + "JOIN rooms r ON b.RoomID = r.room_id "
                    + "JOIN rental_areas ra ON r.rental_area_id = ra.rental_area_id "
                    + "JOIN users u ON ra.manager_id = u.user_id "
                    + "WHERE b.TenantID = ? AND b.Status = ? "
                    + "ORDER BY b.ID DESC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
        } else {
            sql = "SELECT b.*, u.full_name AS managerName FROM tbBills b "
                    + "JOIN rooms r ON b.RoomID = r.room_id "
                    + "JOIN rental_areas ra ON r.rental_area_id = ra.rental_area_id "
                    + "JOIN users u ON ra.manager_id = u.user_id "
                    + "WHERE b.Status = ? "
                    + "ORDER BY b.ID DESC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
        }

        try (PreparedStatement ps = connect.prepareStatement(sql)) {
            if (roleID == 2) {
                ps.setInt(1, managerId);
                ps.setString(2, status);
                ps.setInt(3, (page - 1) * billsPerPage);
                ps.setInt(4, billsPerPage);
            } else if (roleID == 3) {
                ps.setInt(1, tenantId);
                ps.setString(2, status);
                ps.setInt(3, (page - 1) * billsPerPage);
                ps.setInt(4, billsPerPage);
            } else {
                ps.setString(1, status);
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
                bill.setEmailTelnant(rs.getString("EmailTelnant"));
                bill.setManagerName(rs.getString("managerName"));
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
        int tenantId = user.getUserId();
        int managerId = user.getUserId();
        String sql;
        if (roleID == 2) {
            sql = "SELECT COUNT(*) FROM tbBills b "
                    + "JOIN rooms r ON b.RoomID = r.room_id "
                    + "JOIN rental_areas ra ON r.rental_area_id = ra.rental_area_id "
                    + "JOIN users u ON ra.manager_id = u.user_id "
                    + "WHERE ra.manager_id = ? AND b.Status = ?";
        } else if (roleID == 3) {
            sql = "SELECT COUNT(*) FROM tbBills b "
                    + "JOIN rooms r ON b.RoomID = r.room_id "
                    + "JOIN rental_areas ra ON r.rental_area_id = ra.rental_area_id "
                    + "JOIN users u ON ra.manager_id = u.user_id "
                    + "WHERE b.TenantID = ? AND b.Status = ?";
        } else {
            sql = "SELECT COUNT(*) FROM tbBills b "
                    + "JOIN rooms r ON b.RoomID = r.room_id "
                    + "JOIN rental_areas ra ON r.rental_area_id = ra.rental_area_id "
                    + "JOIN users u ON ra.manager_id = u.user_id "
                    + "WHERE b.Status = ?";
        }

        try (PreparedStatement ps = connect.prepareStatement(sql)) {
            if (roleID == 2) {
                ps.setInt(1, managerId);
                ps.setString(2, status);
            } else if (roleID == 3) {
                ps.setInt(1, tenantId);
                ps.setString(2, status);
            } else {
                ps.setString(1, status);
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
        int tenantId = user.getUserId();
        int managerId = user.getUserId();
        String sql;
        if (roleID == 2) {
            sql = "SELECT COUNT(*) FROM tbBills b "
                    + "JOIN rooms r ON b.RoomID = r.room_id "
                    + "JOIN rental_areas ra ON r.rental_area_id = ra.rental_area_id "
                    + "JOIN users u ON ra.manager_id = u.user_id "
                    + "WHERE ra.manager_id = ?";
        } else if (roleID == 3) {
            sql = "SELECT COUNT(*) FROM tbBills b "
                    + "JOIN rooms r ON b.RoomID = r.room_id "
                    + "JOIN rental_areas ra ON r.rental_area_id = ra.rental_area_id "
                    + "JOIN users u ON ra.manager_id = u.user_id "
                    + "WHERE b.TenantID = ?";
        } else {
            sql = "SELECT COUNT(*) FROM tbBills b "
                    + "JOIN rooms r ON b.RoomID = r.room_id "
                    + "JOIN rental_areas ra ON r.rental_area_id = ra.rental_area_id "
                    + "JOIN users u ON ra.manager_id = u.user_id";
        }

        try (PreparedStatement ps = connect.prepareStatement(sql)) {
            if (roleID == 2) {
                ps.setInt(1, managerId);
            } else if (roleID == 3) {
                ps.setInt(1, tenantId);
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
        int tenantId = user.getUserId();
        int managerId = user.getUserId();
        String sql;
        if (roleID == 2) {
            sql = "SELECT b.*, u.full_name AS managerName,u.email FROM tbBills b "
                    + "JOIN rooms r ON b.RoomID = r.room_id "
                    + "JOIN rental_areas ra ON r.rental_area_id = ra.rental_area_id "
                    + "JOIN users u ON ra.manager_id = u.user_id "
                    + "WHERE ra.manager_id = ? "
                    + "ORDER BY b.ID DESC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
        } else if (roleID == 3) {
            sql = "SELECT b.*, u.full_name AS managerName,u.email FROM tbBills b "
                    + "JOIN rooms r ON b.RoomID = r.room_id "
                    + "JOIN rental_areas ra ON r.rental_area_id = ra.rental_area_id "
                    + "JOIN users u ON ra.manager_id = u.user_id "
                    + "WHERE b.TenantID = ? "
                    + "ORDER BY b.ID DESC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
        } else {
            sql = "SELECT b.*, u.full_name AS managerName,u.email FROM tbBills b "
                    + "JOIN rooms r ON b.RoomID = r.room_id "
                    + "JOIN rental_areas ra ON r.rental_area_id = ra.rental_area_id "
                    + "JOIN users u ON ra.manager_id = u.user_id "
                    + "ORDER BY b.ID DESC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
        }

        try (PreparedStatement ps = connect.prepareStatement(sql)) {
            if (roleID == 2) {
                ps.setInt(1, managerId);
                ps.setInt(2, (page - 1) * billsPerPage);
                ps.setInt(3, billsPerPage);
            } else if (roleID == 3) {
                ps.setInt(1, tenantId);
                ps.setInt(2, (page - 1) * billsPerPage);
                ps.setInt(3, billsPerPage);
            } else {
                ps.setInt(1, (page - 1) * billsPerPage);
                ps.setInt(2, billsPerPage);
            }
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Bill bill = new Bill();
                bill.setId(rs.getInt("ID"));
                bill.setTenantName(rs.getString("TenantName"));
                bill.setRoomNumber(rs.getString("RoomNumber"));
                bill.setRoomCost(rs.getDouble("RoomCost") != 0 ? rs.getDouble("RoomCost") : 0);
                bill.setElectricityCost(rs.getDouble("ElectricityCost"));
                bill.setWaterCost(rs.getDouble("WaterCost"));
                bill.setServiceCost(rs.getDouble("ServiceCost"));
                bill.setOtherServiceCost(rs.getDouble("OtherServiceCost") != 0 ? rs.getDouble("OtherServiceCost") : 0);
                bill.setTotal(rs.getDouble("Total"));
                bill.setDueDate(rs.getString("DueDate"));
                bill.setStatus(rs.getString("Status"));
                bill.setCreatedDate(rs.getString("CreatedDate"));
                bill.setEmailTelnant(rs.getString("EmailTelnant"));
                bill.setEmailManager(rs.getString("email"));
                bill.setManagerName(rs.getString("managerName")); // Thêm dòng này, cần có setManagerName trong Bill
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

        String sql = "select SUM(b.Total) from tbBills b \n"
                + "join rooms r on b.RoomID = r.room_id\n"
                + "join rental_areas ra on ra.rental_area_id = r.rental_area_id\n"
                + "where ra.manager_id = ? and b.status = 'Paid'";
        try (PreparedStatement ps = connect.prepareStatement(sql)) {
            ps.setInt(1, user.getUserId());
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
        try (PreparedStatement ps = connect.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
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
        try (PreparedStatement ps = connect.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
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
        // Giả lập tenantId, roomId
        int tenantId = 1;
        int roomId = 1;
        dao.addBill(testBill, tenantId, roomId);
    }
}
