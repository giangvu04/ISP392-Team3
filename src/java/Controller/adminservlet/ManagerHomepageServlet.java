package Controller.adminservlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import model.Users;

@WebServlet(name="ManagerHomepageServlet", urlPatterns={"/ManagerHomepage"})
public class ManagerHomepageServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        
        // Check if user is logged in
        if (session.getAttribute("user") == null) {
            response.sendRedirect("login");
            return;
        }
        
        Users user = (Users) session.getAttribute("user");
        
        // Check if user has manager role (role_id = 2)
        if (user.getRoleId() != 2) {
            // Redirect to appropriate page based on role
            if (user.getRoleId() == 1) {
                response.sendRedirect("AdminHomepage");
            } else if (user.getRoleId() == 3) {
                response.sendRedirect("TenantHomepage");
            } else {
                response.sendRedirect("login?error=invalid_role");
            }
            return;
        }
        
        // Manager is authenticated and authorized
        request.setAttribute("user", user);
        request.getRequestDispatcher("Manager/manager_homepage.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
} 