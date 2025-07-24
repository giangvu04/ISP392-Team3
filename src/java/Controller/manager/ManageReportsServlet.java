package Controller.manager;

import dal.DAOMaintenance;
import dal.DAOMessage;
import dal.DAOBill;
import dal.DAOUser;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.MaintenanceLog;
import model.Message;
import model.Users;
import model.Bill;
import Ultils.SendMail;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

@WebServlet(name="ManageReportsServlet", urlPatterns={"/manageReports"})
public class ManageReportsServlet extends HttpServlet {
    
    private DAOMaintenance maintenanceDAO = DAOMaintenance.INSTANCE;
    private DAOMessage messageDAO = DAOMessage.INSTANCE;
    private DAOBill billDAO = DAOBill.INSTANCE;
    private DAOUser userDAO = DAOUser.INSTANCE;
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Users currentUser = (Users) session.getAttribute("user");
        
        if (currentUser == null || currentUser.getRoleId() != 2) { // Role 2 = Manager
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        try {
            // Get filter parameters
            String reportType = request.getParameter("type");
            
            if ("maintenance".equals(reportType)) {
                // Get maintenance reports
                List<MaintenanceLog> maintenanceLogs = maintenanceDAO.getAllLogsWithNames();
                request.setAttribute("maintenanceLogs", maintenanceLogs);
                request.setAttribute("activeTab", "maintenance");
            } else if ("messages".equals(reportType)) {
                // Get other messages (bill, contract, general)
                List<Message> messages = messageDAO.getAllMessagesWithUserInfo();
                request.setAttribute("messages", messages);
                request.setAttribute("activeTab", "messages");
            } else {
                // Default: show both
                List<MaintenanceLog> maintenanceLogs = maintenanceDAO.getAllLogsWithNames();
                List<Message> messages = messageDAO.getAllMessagesWithUserInfo();
                request.setAttribute("maintenanceLogs", maintenanceLogs);
                request.setAttribute("messages", messages);
                request.setAttribute("activeTab", "all");
            }
            
            request.getRequestDispatcher("/Manager/ManageReports.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMessage", "Có lỗi xảy ra khi tải danh sách báo cáo: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/ManagerHomepage");
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Users currentUser = (Users) session.getAttribute("user");
        
        if (currentUser == null || currentUser.getRoleId() != 2) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        request.setCharacterEncoding("UTF-8");
        
        String action = request.getParameter("action");
        
        try {
            if ("updateMaintenance".equals(action)) {
                // Update maintenance status
                int maintenanceId = Integer.parseInt(request.getParameter("maintenanceId"));
                String status = request.getParameter("status");
                String ownerNote = request.getParameter("ownerNote");
                
                boolean success = maintenanceDAO.updateMaintenanceStatus(maintenanceId, status, ownerNote);
                
                if (success) {
                    session.setAttribute("successMessage", "Đã cập nhật trạng thái báo cáo bảo trì!");
                } else {
                    session.setAttribute("errorMessage", "Có lỗi khi cập nhật trạng thái!");
                }
            } else if ("completeMaintenance".equals(action)) {
                // Complete maintenance and create expense bill
                int maintenanceId = Integer.parseInt(request.getParameter("maintenanceId"));
                int tenantId = Integer.parseInt(request.getParameter("tenantId"));
                double repairCost = Double.parseDouble(request.getParameter("repairCost"));
                String repairNote = request.getParameter("repairNote");
                
                // Update maintenance status to completed
                boolean statusUpdated = maintenanceDAO.updateMaintenanceStatus(maintenanceId, "completed", repairNote);
                
                if (statusUpdated) {
                    // Get maintenance log info for bill details
                    MaintenanceLog currentLog = maintenanceDAO.getMaintenanceLogById(maintenanceId);
                    
                    // Create expense bill
                    Bill bill = new Bill();
                    bill.setElectricityCost(0);
                    bill.setWaterCost(0);
                    bill.setServiceCost(repairCost); // Use service cost for repair cost
                    bill.setTotal(-repairCost); // Negative for expense bill  
                    bill.setDueDate(new SimpleDateFormat("yyyy-MM-dd").format(new Date()));
                    bill.setStatus("Paid"); // Expense bills are automatically paid
                    bill.setCreatedDate(new SimpleDateFormat("yyyy-MM-dd").format(new Date()));
                    bill.setNote("Chi phí sửa chữa - Maintenance ID: " + maintenanceId + 
                                (repairNote != null ? "\nGhi chú: " + repairNote : ""));
                    
                    // Set tenant info from maintenance log
                    bill.setTenantName("Chi phí sửa chữa");
                    if (currentLog != null && currentLog.getRoomName() != null) {
                        bill.setRoomNumber(currentLog.getRoomName()); // Use actual room number like "101", "202"
                    } else {
                        bill.setRoomNumber("N/A"); // Short fallback
                    }
                    
                    // Add bill to database
                    try {
                        // Use actual room_id from maintenance log
                        int roomIdToUse;
                        if (currentLog != null && currentLog.getRoomId() != null && currentLog.getRoomId() > 0) {
                            // Use room from maintenance log
                            roomIdToUse = currentLog.getRoomId();
                        } else {
                            // Fallback: use tenant's current room or any valid room
                            // This is a workaround since expense bills shouldn't need room association
                            roomIdToUse = tenantId; // Assume room_id matches tenant_id (common pattern)
                        }
                        
                        billDAO.addBill(bill, tenantId, roomIdToUse);
                        
                        session.setAttribute("successMessage", 
                            "Đã hoàn thành sửa chữa và tạo hóa đơn chi phí thành công!");
                    } catch (Exception ex) {
                        session.setAttribute("errorMessage", 
                            "Cập nhật trạng thái thành công nhưng có lỗi khi tạo hóa đơn: " + ex.getMessage());
                    }
                } else {
                    session.setAttribute("errorMessage", "Có lỗi khi cập nhật trạng thái!");
                }
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMessage", "Có lỗi xảy ra: " + e.getMessage());
        }
        
        response.sendRedirect(request.getContextPath() + "/manageReports");
    }
}
