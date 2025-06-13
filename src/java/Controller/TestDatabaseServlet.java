package Controller;

import dal.DAOUser;
import model.Users;
import jakarta.servlet.RequestDispatcher;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.ArrayList;

/**
 *
 * @author ADMIN
 */
public class TestDatabaseServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        DAOUser dao = new DAOUser();
        
        try {
            // Test database connection and get users
            ArrayList<Users> users = dao.getUsers();
            
            // Get specific user counts
            int managerCount = dao.getTotalUsersByRole(2);
            int tenantCount = dao.getTotalUsersByRole(3);
            int adminCount = dao.getTotalUsersByRole(1);
            
            // Set attributes for JSP
            request.setAttribute("users", users);
            request.setAttribute("managerCount", managerCount);
            request.setAttribute("tenantCount", tenantCount);
            request.setAttribute("adminCount", adminCount);
            request.setAttribute("totalUsers", users.size());
            request.setAttribute("connectionStatus", "✅ Kết nối thành công!");
            
        } catch (Exception e) {
            request.setAttribute("connectionStatus", "❌ Lỗi kết nối: " + e.getMessage());
            request.setAttribute("error", e);
            e.printStackTrace();
        }
        
        RequestDispatcher dispatcher = request.getRequestDispatcher("test_database.jsp");
        dispatcher.forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Test Database Connection Servlet";
    }
} 