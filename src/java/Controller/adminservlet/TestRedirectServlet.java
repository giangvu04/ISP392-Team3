package Controller.adminservlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import model.Users;

@WebServlet(name="TestRedirectServlet", urlPatterns={"/testredirect"})
public class TestRedirectServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Users user = (Users) session.getAttribute("user");
        
        if (user == null) {
            response.sendRedirect("login");
            return;
        }
        
        // Test redirect based on role
        int roleId = user.getRoleId();
        if (roleId == 1) {
            response.sendRedirect("AdminHomepage");
        } else if (roleId == 2) {
            response.sendRedirect("ManagerHomepage");
        } else if (roleId == 3) {
            response.sendRedirect("TenantHomepage");
        } else {
            response.sendRedirect("login?error=invalid_role");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
} 