package Controller.adminservlet;

import dal.DAOUser;
import model.Users;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;
import java.sql.Timestamp;

@WebServlet(name="TestCreateUserServlet", urlPatterns={"/testcreateuser"})
public class TestCreateUserServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        
        DAOUser dao = new DAOUser();
        
        try {
            // Generate unique email and phone for testing
            long timestamp = System.currentTimeMillis();
            String testEmail = "test" + timestamp + "@example.com";
            String testPhone = "0123456" + (timestamp % 10000);
            
            response.getWriter().println("<h1>🧪 Test Tạo User</h1>");
            response.getWriter().println("<h2>Thông tin test:</h2>");
            response.getWriter().println("<ul>");
            response.getWriter().println("<li>Email: " + testEmail + "</li>");
            response.getWriter().println("<li>Phone: " + testPhone + "</li>");
            response.getWriter().println("<li>Timestamp: " + new Timestamp(timestamp) + "</li>");
            response.getWriter().println("</ul>");
            
            // Test creating a user
            Users testUser = new Users();
            testUser.setEmail(testEmail);
            testUser.setPasswordHash("password123");
            testUser.setFullName("Test User " + timestamp);
            testUser.setPhoneNumber(testPhone);
            testUser.setCitizenId("123456789"); // Set a value
            testUser.setAddress("Test Address"); // Set a value
            testUser.setRoleId(2); // Manager
            testUser.setActive(true);
            
            response.getWriter().println("<h2>Đang tạo user...</h2>");
            
            dao.createUser(testUser);
            
            response.getWriter().println("<h2 style='color: green;'>✅ Test tạo user thành công!</h2>");
            response.getWriter().println("<p>User đã được tạo với email: " + testUser.getEmail() + "</p>");
            
            // Check if user exists
            response.getWriter().println("<h2>Kiểm tra user trong database...</h2>");
            Users createdUser = dao.getUserByEmail(testUser.getEmail());
            if (createdUser != null) {
                response.getWriter().println("<h3 style='color: green;'>✅ User được tìm thấy trong database!</h3>");
                response.getWriter().println("<table border='1' style='border-collapse: collapse; width: 100%;'>");
                response.getWriter().println("<tr><th>Field</th><th>Value</th></tr>");
                response.getWriter().println("<tr><td>ID</td><td>" + createdUser.getUserId() + "</td></tr>");
                response.getWriter().println("<tr><td>Email</td><td>" + createdUser.getEmail() + "</td></tr>");
                response.getWriter().println("<tr><td>Full Name</td><td>" + createdUser.getFullName() + "</td></tr>");
                response.getWriter().println("<tr><td>Phone</td><td>" + createdUser.getPhoneNumber() + "</td></tr>");
                response.getWriter().println("<tr><td>Role ID</td><td>" + createdUser.getRoleId() + "</td></tr>");
                response.getWriter().println("<tr><td>Citizen ID</td><td>" + (createdUser.getCitizenId() != null ? createdUser.getCitizenId() : "NULL") + "</td></tr>");
                response.getWriter().println("<tr><td>Address</td><td>" + (createdUser.getAddress() != null ? createdUser.getAddress() : "NULL") + "</td></tr>");
                response.getWriter().println("<tr><td>Active</td><td>" + createdUser.isActive() + "</td></tr>");
                response.getWriter().println("<tr><td>Created At</td><td>" + createdUser.getCreatedAt() + "</td></tr>");
                response.getWriter().println("</table>");
            } else {
                response.getWriter().println("<h3 style='color: red;'>❌ User không được tìm thấy trong database!</h3>");
            }
            
            // Test with null values
            response.getWriter().println("<h2>Test với giá trị null...</h2>");
            String testEmail2 = "testnull" + timestamp + "@example.com";
            String testPhone2 = "0123457" + (timestamp % 10000);
            
            Users testUser2 = new Users();
            testUser2.setEmail(testEmail2);
            testUser2.setPasswordHash("password123");
            testUser2.setFullName("Test User Null " + timestamp);
            testUser2.setPhoneNumber(testPhone2);
            testUser2.setCitizenId(null); // Test null
            testUser2.setAddress(null); // Test null
            testUser2.setRoleId(3); // Tenant
            testUser2.setActive(true);
            
            dao.createUser(testUser2);
            response.getWriter().println("<h3 style='color: green;'>✅ Test với null values thành công!</h3>");
            
        } catch (SQLException e) {
            response.getWriter().println("<h1 style='color: red;'>❌ Lỗi SQL: " + e.getMessage() + "</h1>");
            response.getWriter().println("<h2>Chi tiết lỗi:</h2>");
            response.getWriter().println("<pre>" + e.toString() + "</pre>");
            e.printStackTrace(response.getWriter());
        } catch (Exception e) {
            response.getWriter().println("<h1 style='color: red;'>❌ Lỗi: " + e.getMessage() + "</h1>");
            response.getWriter().println("<h2>Chi tiết lỗi:</h2>");
            response.getWriter().println("<pre>" + e.toString() + "</pre>");
            e.printStackTrace(response.getWriter());
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
} 