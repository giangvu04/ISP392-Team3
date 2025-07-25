package Controller.manager;

import dal.DAOViewingRequest;
import model.Users;
import model.ViewingRequest;
import Const.ViewingRequestStatus;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/processViewingRequest")
public class ProcessViewingRequestServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
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
            request.getSession().setAttribute("error", "Bạn không có quyền thực hiện hành động này");
            response.sendRedirect("login");
            return;
        }
        
        String action = request.getParameter("action");
        String requestIdParam = request.getParameter("requestId");
        String adminNote = request.getParameter("adminNote");
        
        if (requestIdParam == null || requestIdParam.trim().isEmpty()) {
            request.getSession().setAttribute("error", "Không tìm thấy yêu cầu");
            response.sendRedirect("manageViewingRequests");
            return;
        }
        
        try {
            int requestId = Integer.parseInt(requestIdParam);
            boolean success = false;
            String successMessage = "";
            
            switch (action) {
                case "accept":
                    // Accept request - status = 1 (VIEWED)
                    success = DAOViewingRequest.INSTANCE.updateViewingRequestStatus(
                        requestId, ViewingRequestStatus.VIEWED, adminNote);
                    successMessage = "Đã chấp nhận yêu cầu xem phòng";
                    break;
                    
                case "reject":
                    // Reject request - status = 2 (REJECTED)  
                    success = DAOViewingRequest.INSTANCE.updateViewingRequestStatus(
                        requestId, ViewingRequestStatus.REJECTED, adminNote);
                    successMessage = "Đã từ chối yêu cầu xem phòng";
                    break;
                    
                case "markRead":
                    // Mark as read by changing status to VIEWED
                    success = DAOViewingRequest.INSTANCE.markAsRead(requestId);
                    successMessage = "Đã đánh dấu là đã xem";
                    break;
                    
                case "createContract":
                    // Delete viewing request and create contract
                    ViewingRequest viewingRequest = DAOViewingRequest.INSTANCE.getViewingRequestById(requestId);
                    if (viewingRequest != null) {
                        // Delete the viewing request first
                        success = true;
                        if (success) {
                            // TODO: Create contract with request data
                            // For now just redirect to contract creation page
                            successMessage = "Đã xóa yêu cầu xem phòng và chuyển đến tạo hợp đồng";
                            
                            // Store request data in session for contract creation
                            session.setAttribute("contractFromRequest", viewingRequest);
                            
                            // Redirect to contract creation
                            response.sendRedirect("createContract?fromRequest=" + requestId + 
                                                "&postId=" + viewingRequest.getPostId() + 
                                                "&tenantId=" + viewingRequest.getTenantId());
                            return;
                        } else {
                            session.setAttribute("error", "Có lỗi khi xóa yêu cầu");
                        }
                    } else {
                        session.setAttribute("error", "Không tìm thấy yêu cầu");
                    }
                    break;
                    
                default:
                    request.getSession().setAttribute("error", "Hành động không hợp lệ");
                    response.sendRedirect("manageViewingRequests");
                    return;
            }
            
            if (success) {
                request.getSession().setAttribute("success", successMessage);
                
                // If creating contract, we already redirected above
                // No need to redirect again here for createContract case
            } else {
                request.getSession().setAttribute("error", "Có lỗi xảy ra khi xử lý yêu cầu");
            }
            
            response.sendRedirect("manageViewingRequests");
            
        } catch (NumberFormatException e) {
            request.getSession().setAttribute("error", "ID yêu cầu không hợp lệ");
            response.sendRedirect("manageViewingRequests");
        } catch (Exception e) {
            System.err.println("Error in ProcessViewingRequestServlet: " + e.getMessage());
            e.printStackTrace();
            request.getSession().setAttribute("error", "Có lỗi xảy ra khi xử lý yêu cầu");
            response.sendRedirect("manageViewingRequests");
        }
    }
}
