package Controller.adminservlet;

import dal.DAOUser;
import model.Users;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;

@WebServlet(name="TestUpdateUserServlet", urlPatterns={"/testupdateuser"})
public class TestUpdateUserServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();
        
        try {
            DAOUser dao = new DAOUser();
            
            // Test 1: Get a user by ID
            out.println("<h2>Test 1: Get User by ID</h2>");
            Users user = dao.getUserByID(1); // Assuming user ID 1 exists
            if (user != null) {
                out.println("<p>✅ Found user: " + user.getFullName() + " (ID: " + user.getUserId() + ")</p>");
                out.println("<p>Email: " + user.getEmail() + "</p>");
                out.println("<p>Phone: " + user.getPhoneNumber() + "</p>");
                out.println("<p>Role: " + user.getRoleId() + "</p>");
                out.println("<p>Citizen ID: " + user.getCitizenId() + "</p>");
                out.println("<p>Address: " + user.getAddress() + "</p>");
                
                // Test 2: Update user
                out.println("<h2>Test 2: Update User</h2>");
                String originalName = user.getFullName();
                String originalEmail = user.getEmail();
                
                // Update some fields
                user.setFullName(originalName + " (Updated)");
                user.setEmail("updated_" + originalEmail);
                user.setCitizenId("123456789");
                user.setAddress("123 Test Street");
                
                dao.updateUser(user);
                out.println("<p>✅ User updated successfully!</p>");
                
                // Test 3: Verify update
                out.println("<h2>Test 3: Verify Update</h2>");
                Users updatedUser = dao.getUserByID(user.getUserId());
                if (updatedUser != null) {
                    out.println("<p>✅ Updated user retrieved successfully!</p>");
                    out.println("<p>New name: " + updatedUser.getFullName() + "</p>");
                    out.println("<p>New email: " + updatedUser.getEmail() + "</p>");
                    out.println("<p>New citizen ID: " + updatedUser.getCitizenId() + "</p>");
                    out.println("<p>New address: " + updatedUser.getAddress() + "</p>");
                    
                    // Test 4: Revert changes
                    out.println("<h2>Test 4: Revert Changes</h2>");
                    updatedUser.setFullName(originalName);
                    updatedUser.setEmail(originalEmail);
                    updatedUser.setCitizenId(null);
                    updatedUser.setAddress(null);
                    
                    dao.updateUser(updatedUser);
                    out.println("<p>✅ Changes reverted successfully!</p>");
                }
            } else {
                out.println("<p>❌ No user found with ID 1</p>");
            }
            
            // Test 5: Check email exists
            out.println("<h2>Test 5: Check Email Exists</h2>");
            boolean emailExists = dao.checkEmailExists("admin@example.com");
            out.println("<p>Email 'admin@example.com' exists: " + emailExists + "</p>");
            
            // Test 6: Check phone exists
            out.println("<h2>Test 6: Check Phone Exists</h2>");
            boolean phoneExists = dao.checkPhoneExists("0123456789");
            out.println("<p>Phone '0123456789' exists: " + phoneExists + "</p>");
            
        } catch (Exception e) {
            out.println("<p>❌ Error: " + e.getMessage() + "</p>");
            e.printStackTrace(out);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
} 