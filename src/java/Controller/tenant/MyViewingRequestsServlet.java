package Controller.tenant;

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

@WebServlet("/myViewingRequests")
public class MyViewingRequestsServlet extends HttpServlet {

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
        
        // Chỉ tenant (roleId = 3) mới được xem
        if (user.getRoleId() != 3) {
            request.getSession().setAttribute("error", "Bạn không có quyền vô trang này");
            response.sendRedirect("login");
            return;
        }
        
        try {
            // Lấy danh sách viewing requests của tenant này
            List<ViewingRequest> viewingRequests = DAOViewingRequest.INSTANCE.getRequestsByTenant(user.getUserId());
            
            // Set attribute và forward to JSP
            request.setAttribute("viewingRequests", viewingRequests);
            request.setAttribute("user", user);
            
            request.getRequestDispatcher("/Tenant/MyViewingRequests.jsp").forward(request, response);
            
        } catch (Exception e) {
            System.err.println("Error in MyViewingRequestsServlet: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect("login");
        }
    }
}
