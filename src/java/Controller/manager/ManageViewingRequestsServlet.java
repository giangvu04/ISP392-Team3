package Controller.manager;

import dal.DAOViewingRequest;
import model.Users;
import model.ViewingRequest;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet("/manageViewingRequests")
public class ManageViewingRequestsServlet extends HttpServlet {

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
        
        // Chỉ manager (roleId = 2) mới được vào
        if (user.getRoleId() != 2) {
            request.getSession().setAttribute("error", "Bạn không có quyền vào trang này");
            response.sendRedirect("login");
            return;
        }
        
        try {
            // Lấy tất cả viewing requests
            List<ViewingRequest> allRequests = DAOViewingRequest.INSTANCE.getAllViewingRequestsForManager();
            
            // Set attributes
            request.setAttribute("viewingRequests", allRequests);
            request.setAttribute("user", user);
            
            // Thống kê
            long pendingCount = allRequests.stream().filter(r -> r.getStatus() == 0).count();
            long acceptedCount = allRequests.stream().filter(r -> r.getStatus() == 1).count();
            long rejectedCount = allRequests.stream().filter(r -> r.getStatus() == 2).count();
            
            request.setAttribute("pendingCount", pendingCount);
            request.setAttribute("acceptedCount", acceptedCount);
            request.setAttribute("rejectedCount", rejectedCount);
            request.setAttribute("totalCount", allRequests.size());
            
            request.getRequestDispatcher("/Manager/ViewingRequests.jsp").forward(request, response);
            
        } catch (Exception e) {
            System.err.println("Error in ManageViewingRequestsServlet: " + e.getMessage());
            e.printStackTrace();
            request.getSession().setAttribute("error", "Có lỗi xảy ra khi tải danh sách yêu cầu");
            response.sendRedirect("manager_homepage.jsp");
        }
    }
}
