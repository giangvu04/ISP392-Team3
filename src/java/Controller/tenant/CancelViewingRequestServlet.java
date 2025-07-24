package Controller.tenant;

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

@WebServlet("/cancelViewingRequest")
public class CancelViewingRequestServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Set encoding
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html; charset=UTF-8");
        
        HttpSession session = request.getSession();
        Users user = (Users) session.getAttribute("user");
        
        // Kiểm tra đăng nhập và quyền
        if (user == null) {
            request.getSession().setAttribute("error", "Phiên làm việc đã hết hạn vui lòng thử lại");
            response.sendRedirect("login");
            return;
        }
        
        // Chỉ tenant (roleId = 3) mới được hủy
        if (user.getRoleId() != 3) {
            request.getSession().setAttribute("error", "Bạn không có quyền thực hiện hành động này");
            response.sendRedirect("login");
            return;
        }
        
        String requestIdParam = request.getParameter("id");
        if (requestIdParam == null || requestIdParam.trim().isEmpty()) {
            request.getSession().setAttribute("error", "Không tìm thấy yêu cầu");
            response.sendRedirect("myViewingRequests");
            return;
        }
        
        try {
            int requestId = Integer.parseInt(requestIdParam);
            
            // Lấy thông tin viewing request để kiểm tra
            ViewingRequest viewingRequest = DAOViewingRequest.INSTANCE.getViewingRequestById(requestId);
            
            if (viewingRequest == null) {
                request.getSession().setAttribute("error", "Không tìm thấy yêu cầu");
                response.sendRedirect("myViewingRequests");
                return;
            }
            
            // Kiểm tra quyền - chỉ được hủy request của chính mình
            if (viewingRequest.getTenantId() != user.getUserId()) {
                request.getSession().setAttribute("error", "Bạn không có quyền hủy yêu cầu này");
                response.sendRedirect("myViewingRequests");
                return;
            }
            
            // Chỉ có thể hủy yêu cầu đang ở trạng thái PENDING
            if (viewingRequest.getStatus() != ViewingRequestStatus.PENDING) {
                request.getSession().setAttribute("error", "Chỉ có thể hủy yêu cầu đang chờ xử lý");
                response.sendRedirect("myViewingRequests");
                return;
            }
            
            // Thực hiện hủy - xóa yêu cầu khỏi database
            boolean success = DAOViewingRequest.INSTANCE.deleteViewingRequest(requestId);
            
            if (success) {
                request.getSession().setAttribute("success", "Đã hủy yêu cầu thành công");
            } else {
                request.getSession().setAttribute("error", "Có lỗi xảy ra khi hủy yêu cầu");
            }
            
            response.sendRedirect("myViewingRequests");
            
        } catch (NumberFormatException e) {
            request.getSession().setAttribute("error", "ID yêu cầu không hợp lệ");
            response.sendRedirect("myViewingRequests");
        } catch (Exception e) {
            System.err.println("Error in CancelViewingRequestServlet: " + e.getMessage());
            e.printStackTrace();
            request.getSession().setAttribute("error", "Có lỗi xảy ra khi hủy yêu cầu");
            response.sendRedirect("myViewingRequests");
        }
    }
}
