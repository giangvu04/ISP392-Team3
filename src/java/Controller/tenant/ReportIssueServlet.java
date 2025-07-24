package Controller.tenant;

import dal.DAODeviceInRoom;
import dal.DAOMaintenance;
import dal.DAOMessage;
import dal.DAORooms;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.DeviceInRoom;
import model.Message;
import model.Rooms;
import model.Users;
import java.io.IOException;
import java.sql.Timestamp;
import java.util.ArrayList;

@WebServlet(name="ReportIssueServlet", urlPatterns={"/reportIssue"})
public class ReportIssueServlet extends HttpServlet {
    
    private DAODeviceInRoom deviceInRoomDAO = DAODeviceInRoom.INSTANCE;
    private DAOMaintenance maintenanceDAO = DAOMaintenance.INSTANCE;
    private DAOMessage messageDAO = DAOMessage.INSTANCE;
    private DAORooms roomDAO = DAORooms.INSTANCE;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Users currentUser = (Users) session.getAttribute("user");
        
        if (currentUser == null || currentUser.getRoleId() != 3) { // Role 3 = Tenant
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        // Get tenant's current room and devices
        int tenantId = currentUser.getUserId();
        System.out.println("=== DOGET DEBUG ===");
        System.out.println("TenantId: " + tenantId);
        
        Rooms currentRoom = roomDAO.getCurrentRoomByTenant(tenantId);
        System.out.println("CurrentRoom: " + (currentRoom != null ? currentRoom.getRoomNumber() : "null"));
        
        if (currentRoom != null) {
            ArrayList<DeviceInRoom> devicesInRoom = deviceInRoomDAO.getDevicesByRoomId(currentRoom.getRoomId());
            System.out.println("DevicesInRoom count: " + (devicesInRoom != null ? devicesInRoom.size() : 0));
            request.setAttribute("devicesInRoom", devicesInRoom);
            request.setAttribute("currentRoom", currentRoom);
        } else {
            System.out.println("No room found for tenant!");
        }
        
        request.getRequestDispatcher("/Tenant/ReportIssue.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Users currentUser = (Users) session.getAttribute("user");
        
        if (currentUser == null || currentUser.getRoleId() != 3) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        request.setCharacterEncoding("UTF-8");
        
        String issueType = request.getParameter("issueType");
        String description = request.getParameter("description");
        String deviceInfo = request.getParameter("deviceInfo");
        String roomId = request.getParameter("roomId");
        int tenantId = currentUser.getUserId();
        
        System.out.println("=== ALL FORM PARAMETERS ===");
        System.out.println("IssueType: " + issueType);
        System.out.println("Description: " + description);
        System.out.println("DeviceInfo: " + deviceInfo);
        System.out.println("RoomId: " + roomId);
        System.out.println("TenantId: " + tenantId);
        System.out.println("===========================");
        
        try {
            boolean success = false;
            
            if ("maintenance".equals(issueType)) {
                // Báo cáo sự cố thiết bị
                System.out.println("DeviceInfo: " + deviceInfo);
                
                try {
                    // Lấy phòng hiện tại của tenant từ database
                    Rooms room = roomDAO.getCurrentRoomByTenant(tenantId);
                    System.out.println("Current room: " + (room != null ? room.getRoomNumber() : "null"));
                    
                    if (room != null) {
                        // Thêm vào maintenance_logs
                        maintenanceDAO.addMaintenanceLog(
                            room.getRentalAreaId(), 
                            room.getRoomId(),
                            "Báo cáo sự cố thiết bị - Phòng " + room.getRoomNumber(),
                            "Thiết bị: " + (deviceInfo != null ? deviceInfo : "Không xác định") + ";Mô tả sự cố: " + description,
                            new Timestamp(System.currentTimeMillis()),
                            tenantId
                        );
                        success = true;
                        System.out.println("Maintenance log added successfully");
                    } else {
                        System.out.println("ERROR: Tenant has no room assigned");
                        session.setAttribute("errorMessage", "Bạn chưa có phòng nào được gán. Vui lòng liên hệ quản lý.");
                        response.sendRedirect(request.getContextPath() + "/reportIssue");
                        return;
                    }
                } catch (Exception e) {
                    System.out.println("ERROR in maintenance: " + e.getMessage());
                    e.printStackTrace();
                    session.setAttribute("errorMessage", "Lỗi khi thêm báo cáo bảo trì: " + e.getMessage());
                    response.sendRedirect(request.getContextPath() + "/reportIssue");
                    return;
                }
                
                if (success) {
                    session.setAttribute("successMessage", "Đã gửi báo cáo sự cố thiết bị thành công!");
                }
                
            } else {
                // Các loại thông báo khác: bill, contract, general
                try {
                    Message message = new Message(tenantId, issueType, description);
                    success = messageDAO.addMessage(message);
                    
                    if (success) {
                        String typeText = "general".equals(issueType) ? "thông báo" : 
                                        "bill".equals(issueType) ? "thắc mắc về hóa đơn" : 
                                        "contract".equals(issueType) ? "thắc mắc về hợp đồng" : "thông báo";
                        session.setAttribute("successMessage", "Đã gửi " + typeText + " thành công!");
                    }
                } catch (Exception e) {
                    System.out.println("ERROR in message: " + e.getMessage());
                    e.printStackTrace();
                    session.setAttribute("errorMessage", "Lỗi khi gửi thông báo: " + e.getMessage());
                    response.sendRedirect(request.getContextPath() + "/reportIssue");
                    return;
                }
            }
            
            if (!success) {
                session.setAttribute("errorMessage", "Có lỗi xảy ra khi gửi thông báo!");
            }
            
        } catch (Exception e) {
            System.out.println("GENERAL ERROR: " + e.getMessage());
            e.printStackTrace();
            session.setAttribute("errorMessage", "Có lỗi xảy ra: " + e.getMessage());
        }
        
        response.sendRedirect(request.getContextPath() + "/reportIssue");
    }
}

