package Controller.adminservlet;

import dal.DAOUser;
import model.Users;
import jakarta.servlet.RequestDispatcher;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 *
 * @author ADMIN
 */
public class AdminHomepageServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Users currentUser = (Users) session.getAttribute("user");
        
        // Check if user is logged in and is admin
        if (currentUser == null || currentUser.getRoleId() != 1) {
            response.sendRedirect("login");
            return;
        }

        DAOUser dao = new DAOUser();
        
        try {
            // Get counts for dashboard
            int managerCount = dao.getTotalUsersByRole(2);
            int tenantCount = dao.getTotalUsersByRole(3);
            int totalUsers = dao.getTotalManagerAndTenantUsers();
            
            // Set attributes for JSP
            request.setAttribute("managerCount", managerCount);
            request.setAttribute("tenantCount", tenantCount);
            request.setAttribute("totalUsers", totalUsers);
            request.setAttribute("currentUser", currentUser);
            
        } catch (Exception e) {
            request.setAttribute("error", "Có lỗi xảy ra: " + e.getMessage());
            e.printStackTrace();
        }
        
        RequestDispatcher dispatcher = request.getRequestDispatcher("Admin/AdminHomepage.jsp");
        dispatcher.forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Admin Homepage Servlet";
    }
} 