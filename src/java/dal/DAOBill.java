/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */

package dal;

import java.lang.*;
import java.util.*;
import java.io.*;
import model.Bill;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

/**
 *
 * @author Vu Thi Huong Giang
 */

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
        String sql = "INSERT INTO Bills (TenantName, RoomNumber, ElectricityCost, WaterCost, ServiceCost, Total, DueDate, Status, CreatedDate) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
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

    // Lấy tất cả hóa đơn
    public ArrayList<Bill> getAllBills() {
        ArrayList<Bill> bills = new ArrayList<>();
        String sql = "SELECT * FROM Bills ORDER BY CreatedDate DESC";
        try (PreparedStatement statement = connect.prepareStatement(sql); 
             ResultSet rs = statement.executeQuery()) {

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
        String sql = "SELECT * FROM Bills WHERE ID = ?";
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
        String sql = "UPDATE Bills SET TenantName = ?, RoomNumber = ?, ElectricityCost = ?, WaterCost = ?, ServiceCost = ?, Total = ?, DueDate = ?, Status = ? WHERE ID = ?";
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
            System.out.println(" Cập nhật hóa đơn thành công!");
        } catch (SQLException e) {
            System.err.println(" Lỗi cập nhật hóa đơn: " + e.getMessage());
            e.printStackTrace();
        }
    }

    // Xóa hóa đơn
    public void deleteBill(int id) {
        String sql = "DELETE FROM Bills WHERE ID = ?";
        try (PreparedStatement ps = connect.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.executeUpdate();
            System.out.println(" Xóa hóa đơn thành công!");
        } catch (SQLException e) {
            System.err.println(" Lỗi xóa hóa đơn: " + e.getMessage());
            e.printStackTrace();
        }
    }

    // Tìm kiếm hóa đơn theo tên người thuê
    public ArrayList<Bill> searchBillsByTenantName(String tenantName) {
        ArrayList<Bill> bills = new ArrayList<>();
        String sql = "SELECT * FROM Bills WHERE TenantName LIKE ? ORDER BY CreatedDate DESC";
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
            System.err.println(" Lỗi tìm kiếm hóa đơn: " + e.getMessage());
            e.printStackTrace();
        }
        return bills;
    }

    // Tìm kiếm hóa đơn theo số phòng
    public ArrayList<Bill> searchBillsByRoomNumber(String roomNumber) {
        ArrayList<Bill> bills = new ArrayList<>();
        String sql = "SELECT * FROM Bills WHERE RoomNumber LIKE ? ORDER BY CreatedDate DESC";
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
            System.err.println("❌ Lỗi tìm kiếm hóa đơn: " + e.getMessage());
            e.printStackTrace();
        }
        return bills;
    }

    // Lấy hóa đơn theo trạng thái
    public ArrayList<Bill> getBillsByStatus(String status) {
        ArrayList<Bill> bills = new ArrayList<>();
        String sql = "SELECT * FROM Bills WHERE Status = ? ORDER BY CreatedDate DESC";
        try (PreparedStatement ps = connect.prepareStatement(sql)) {
            ps.setString(1, status);
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
            System.err.println("❌ Lỗi lấy hóa đơn theo trạng thái: " + e.getMessage());
            e.printStackTrace();
        }
        return bills;
    }

    // Cập nhật trạng thái hóa đơn
    public void updateBillStatus(int id, String status) {
        String sql = "UPDATE Bills SET Status = ? WHERE ID = ?";
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
    public int getTotalBills() {
        String sql = "SELECT COUNT(*) FROM Bills";
        try (PreparedStatement ps = connect.prepareStatement(sql)) {
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
    public ArrayList<Bill> getBillsByPage(int page, int billsPerPage) {
        ArrayList<Bill> bills = new ArrayList<>();
        String sql = "SELECT * FROM Bills ORDER BY CreatedDate DESC OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";
        try (PreparedStatement ps = connect.prepareStatement(sql)) {
            ps.setInt(1, (page - 1) * billsPerPage);
            ps.setInt(2, billsPerPage);
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

    // Tính tổng doanh thu
    public double getTotalRevenue() {
        String sql = "SELECT SUM(Total) FROM Bills WHERE Status = 'Paid'";
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
    public ArrayList<Bill> getUnpaidBills() {
        return getBillsByStatus("Unpaid");
    }

    // Lấy hóa đơn đã thanh toán
    public ArrayList<Bill> getPaidBills() {
        return getBillsByStatus("Paid");
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
        
        // Test lấy danh sách
        ArrayList<Bill> bills = dao.getAllBills();
        System.out.println("Tổng số hóa đơn: " + bills.size());
    }
}
