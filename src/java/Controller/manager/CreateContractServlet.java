package Controller.manager;

import dal.DAOViewingRequest;
import dal.DAOContract;
import dal.DAOUser;
import dal.DAOPostRoom;
import dal.DAORooms;
import model.Users;
import model.ViewingRequest;
import model.Contracts;
import model.PostRoom;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Date;
import java.time.LocalDate;
import java.util.List;

@WebServlet("/createContract")
public class CreateContractServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Set encoding
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html; charset=UTF-8");
        
        HttpSession session = request.getSession();
        Users user = (Users) session.getAttribute("user");
        
        // Kiểm tra đăng nhập và quyền manager
        if (user == null) {
            request.getSession().setAttribute("error", "Phiên làm việc đã hết hạn vui lòng thử lại");
            response.sendRedirect("login");
            return;
        }
        
        if (user.getRoleId() != 2) {
            request.getSession().setAttribute("error", "Bạn không có quyền vào trang này");
            response.sendRedirect("login");
            return;
        }
        
        // Lấy thông tin từ parameters (từ viewing request)
        String fromRequestParam = request.getParameter("fromRequest");
        String postIdParam = request.getParameter("postId");
        String tenantIdParam = request.getParameter("tenantId");
        
        try {
            // Nếu có fromRequest, lấy thông tin từ session
            ViewingRequest viewingRequest = (ViewingRequest) session.getAttribute("contractFromRequest");
            
            if (viewingRequest != null) {
                // Lấy thông tin tenant
                Users tenant = DAOUser.INSTANCE.getUserByID(viewingRequest.getTenantId());
                
                // Set attributes cho form tạo hợp đồng
                request.setAttribute("viewingRequest", viewingRequest);
                request.setAttribute("tenant", tenant);
                request.setAttribute("postId", viewingRequest.getPostId());
                request.setAttribute("tenantId", viewingRequest.getTenantId());
                
                // Clear session data
                session.removeAttribute("contractFromRequest");
            } else if (postIdParam != null && tenantIdParam != null) {
                // Tạo hợp đồng trực tiếp với postId và tenantId
                int postId = Integer.parseInt(postIdParam);
                int tenantId = Integer.parseInt(tenantIdParam);
                
                Users tenant = DAOUser.INSTANCE.getUserByID(tenantId);
                
                request.setAttribute("postId", postId);
                request.setAttribute("tenantId", tenantId);
                request.setAttribute("tenant", tenant);
            } else {
                request.getSession().setAttribute("error", "Thông tin không đầy đủ để tạo hợp đồng");
                response.sendRedirect("manageViewingRequests");
                return;
            }
            
            request.setAttribute("user", user);
            request.getRequestDispatcher("/Manager/CreateContract.jsp").forward(request, response);
            
        } catch (Exception e) {
            System.err.println("Error in CreateContractServlet GET: " + e.getMessage());
            e.printStackTrace();
            request.getSession().setAttribute("error", "Có lỗi xảy ra khi tải trang tạo hợp đồng");
            response.sendRedirect("manageViewingRequests");
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Set encoding
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html; charset=UTF-8");
        
        HttpSession session = request.getSession();
        Users user = (Users) session.getAttribute("user");
        
        // Kiểm tra đăng nhập và quyền
        if (user == null || user.getRoleId() != 2) {
            request.getSession().setAttribute("error", "Bạn không có quyền thực hiện hành động này");
            response.sendRedirect("login");
            return;
        }
        
        try {
            // Lấy thông tin từ form
            int postId = Integer.parseInt(request.getParameter("postId"));
            int tenantId = Integer.parseInt(request.getParameter("tenantId"));
            String contractTerm = request.getParameter("contractTerm"); // Thời hạn hợp đồng (tháng)
            double monthlyRent = Double.parseDouble(request.getParameter("monthlyRent"));
            double deposit = Double.parseDouble(request.getParameter("deposit"));
            String startDateStr = request.getParameter("startDate");
            String terms = request.getParameter("terms"); // Điều khoản hợp đồng
            
            // Hiện tại form không có trường note riêng, và terms có thể quá dài
            // Nên set note = null để tránh lỗi truncated data
            
            // Tính toán ngày kết thúc
            LocalDate startDate = LocalDate.parse(startDateStr);
            LocalDate endDate = startDate.plusMonths(Integer.parseInt(contractTerm));
            
            
            int roomId = getRoomIdFromPost(postId);
            
            // Tạo contract object
            Contracts contract = new Contracts();
            contract.setRoomId(roomId);
            contract.setTenantId(tenantId);
            contract.setStartDate(Date.valueOf(startDate));
            contract.setEndDate(Date.valueOf(endDate));
            contract.setRentPrice(java.math.BigDecimal.valueOf(monthlyRent));
            contract.setDepositAmount(java.math.BigDecimal.valueOf(deposit));
            contract.setNote(null); // Set null vì form không có trường note và terms quá dài
            contract.setStatus(1); // Active
            
            // Lưu hợp đồng vào database
            int contractId = DAOContract.INSTANCE.addContract(contract);
            
            if (contractId > 0) {
                // Cập nhật status room thành "Occupied" (1) sau khi tạo hợp đồng thành công
                boolean updateRoomSuccess = DAORooms.INSTANCE.updateRoomStatus(roomId, 1);
                
                if (updateRoomSuccess) {
                    request.getSession().setAttribute("success", 
                        "Đã tạo hợp đồng thành công và cập nhật trạng thái phòng cho tenant ID: " + tenantId);
                } else {
                    request.getSession().setAttribute("success", 
                        "Đã tạo hợp đồng thành công cho tenant ID: " + tenantId + " (Lưu ý: Chưa cập nhật được trạng thái phòng)");
                }
                response.sendRedirect("listcontracts"); // Redirect to contract list
            } else {
                request.getSession().setAttribute("error", "Có lỗi xảy ra khi tạo hợp đồng");
                response.sendRedirect("createContract?postId=" + postId + "&tenantId=" + tenantId);
            }
            
        } catch (NumberFormatException e) {
            request.getSession().setAttribute("error", "Dữ liệu nhập vào không hợp lệ");
            response.sendRedirect("manageViewingRequests");
        } catch (Exception e) {
            System.err.println("Error in CreateContractServlet POST: " + e.getMessage());
            e.printStackTrace();
            request.getSession().setAttribute("error", "Có lỗi xảy ra khi tạo hợp đồng");
            response.sendRedirect("manageViewingRequests");
        }
    }
    
    /**
     * Helper method to get roomId from postId
     */
    private int getRoomIdFromPost(int postId) {
        try {
            // Use DAOPostRoom to get rooms from postId
            List<PostRoom> rooms = DAOPostRoom.INSTANCE.getRoomsByPost(postId);
            if (rooms != null && !rooms.isEmpty()) {
                // Return the first room's ID (assuming a post typically has one main room for contract)
                return rooms.get(0).getRoomId();
            }
            return -1; // No rooms found
        } catch (Exception e) {
            System.err.println("Error getting roomId from postId " + postId + ": " + e.getMessage());
            return -1; // Return -1 to indicate error
        }
    }
}
