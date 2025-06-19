package Controller.adminservlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import model.Users;

@WebServlet(name="TenantHomepageServlet", urlPatterns={"/TenantHomepage"})
public class TenantHomepageServlet extends HttpServlet {

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
        
        // Check if user has tenant role (role_id = 3)
        if (user.getRoleId() != 3) {
            // Redirect to appropriate page based on role
            if (user.getRoleId() == 1) {
                response.sendRedirect("AdminHomepage");
            } else if (user.getRoleId() == 2) {
                response.sendRedirect("ManagerHomepage");
            } else {
                response.sendRedirect("login?error=invalid_role");
            }
            return;
        }
        
        // Tenant is authenticated and authorized
        request.setAttribute("user", user);
        request.getRequestDispatcher("Tenant/tenant_homepage.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
} 