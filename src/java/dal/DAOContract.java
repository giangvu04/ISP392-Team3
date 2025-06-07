/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;
import model.Contracts;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
public class DAOContract {
    public static final DAOContract INSTANCE = new DAOContract();
    protected Connection connect;

    public DAOContract() {
        connect = new DBContext().connect;
    }
    
    public void insertContract(Contracts contract) {
        String sql = "INSERT INTO Contracts (Contract_id, deal_price, start_date, end_date, deposit_amount, note, tenant_count, tenantsID, roomID) "
                   + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (PreparedStatement ps = connect.prepareStatement(sql)) {
            ps.setInt(1, contract.getContractId());
            ps.setInt(2, contract.getDealPrice());
            ps.setDate(3, contract.getStartDate());
            ps.setDate(4, contract.getEndDate());
            ps.setInt(5, contract.getDepositAmount());
            ps.setString(6, contract.getNote());
            ps.setInt(7, contract.getTenantCount());
            ps.setInt(8, contract.getTenantsID());
            ps.setInt(9, contract.getRoomID());
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public ArrayList<Contracts> getAllContracts() {
        ArrayList<Contracts> contracts = new ArrayList<>();
        String sql = "SELECT * FROM Contracts";
        try (PreparedStatement ps = connect.prepareStatement(sql) ; ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Contracts c = new Contracts();
                c.setContractId(rs.getInt("contractId"));
                c.setDealPrice(rs.getInt("dealPrice"));
                c.setStartDate(rs.getDate("startDate"));
                c.setEndDate(rs.getDate("endDate"));
                c.setDepositAmount(rs.getInt("depositAmount"));
                c.setNote(rs.getString("note"));
                c.setTenantCount(rs.getInt("tenantCount"));
                c.setTenantsID(rs.getInt("tenantsID"));
                c.setRoomID(rs.getInt("roomID"));
                contracts.add(c);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return contracts;
    }

    public Contracts getContractById(int id) {
        String sql = "SELECT * FROM Contracts WHERE Contract_id = ?";
        try (PreparedStatement ps = connect.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Contracts contract = new Contracts();
                contract.setContractId(rs.getInt("contractId"));
                contract.setDealPrice(rs.getInt("dealPrice"));
                contract.setStartDate(rs.getDate("startDate"));
                contract.setEndDate(rs.getDate("endDate"));
                contract.setDepositAmount(rs.getInt("depositAmount"));
                contract.setNote(rs.getString("note"));
                contract.setTenantCount(rs.getInt("tenantCount"));
                contract.setTenantsID(rs.getInt("tenantsID"));
                contract.setRoomID(rs.getInt("roomID"));
                return contract;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public void updateContract(Contracts contract) {
        String sql = "UPDATE Contracts SET deal_price=?, start_date=?, end_date=?, deposit_amount=?, note=?, "
                   + "tenant_count=?, tenantsID=?, roomID=? WHERE Contract_id=?";
        try (PreparedStatement ps = connect.prepareStatement(sql)) {
            ps.setInt(1, contract.getDealPrice());
            ps.setDate(2, contract.getStartDate());
            ps.setDate(3, contract.getEndDate());
            ps.setInt(4, contract.getDepositAmount());
            ps.setString(5, contract.getNote());
            ps.setInt(6, contract.getTenantCount());
            ps.setInt(7, contract.getTenantsID());
            ps.setInt(8, contract.getRoomID());
            ps.setInt(9, contract.getContractId());
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void deleteContract(int id) {
        String sql = "DELETE FROM Contracts WHERE Contract_id=?";
        try (PreparedStatement ps = connect.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
