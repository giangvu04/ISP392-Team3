package Controller.userservlet;

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
public class RegisterServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Users currentUser = (Users) session.getAttribute("user");
        
        // Check if user is logged in
        if (currentUser == null) {
            response.sendRedirect("login");
            return;
        }
        
        // Only managers can register new tenants
        if (currentUser.getRoleId() != 2) {
            request.setAttribute("error", "Bạn không có quyền đăng ký người dùng mới!");
            response.sendRedirect("listusers");
            return;
        }
        
        RequestDispatcher dispatcher = request.getRequestDispatcher("Manager/RegisterTenant.jsp");
        dispatcher.forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Users currentUser = (Users) session.getAttribute("user");
        
        // Check if user is logged in and is manager
        if (currentUser == null || currentUser.getRoleId() != 2) {
            response.sendRedirect("login");
            return;
        }

        DAOUser dao = new DAOUser();
        
        try {
            // Get form parameters
            String email = request.getParameter("email");
            String password = request.getParameter("password");
            String confirmPassword = request.getParameter("confirmPassword");
            String fullName = request.getParameter("fullName");
            String phoneNumber = request.getParameter("phoneNumber");
            String citizenId = request.getParameter("citizenId");
            String address = request.getParameter("address");

            // Validate required fields
            if (email == null || email.trim().isEmpty() ||
                password == null || password.trim().isEmpty() ||
                fullName == null || fullName.trim().isEmpty() ||
                phoneNumber == null || phoneNumber.trim().isEmpty()) {
                
                request.setAttribute("error", "Vui lòng điền đầy đủ thông tin bắt buộc!");
                request.setAttribute("email", email);
                request.setAttribute("fullName", fullName);
                request.setAttribute("phoneNumber", phoneNumber);
                request.setAttribute("citizenId", citizenId);
                request.setAttribute("address", address);
                
                RequestDispatcher dispatcher = request.getRequestDispatcher("Manager/RegisterTenant.jsp");
                dispatcher.forward(request, response);
                return;
            }

            // Validate password confirmation
            if (!password.equals(confirmPassword)) {
                request.setAttribute("error", "Mật khẩu xác nhận không khớp!");
                request.setAttribute("email", email);
                request.setAttribute("fullName", fullName);
                request.setAttribute("phoneNumber", phoneNumber);
                request.setAttribute("citizenId", citizenId);
                request.setAttribute("address", address);
                
                RequestDispatcher dispatcher = request.getRequestDispatcher("Manager/RegisterTenant.jsp");
                dispatcher.forward(request, response);
                return;
            }

            // Validate password length
            if (password.length() < 6) {
                request.setAttribute("error", "Mật khẩu phải có ít nhất 6 ký tự!");
                request.setAttribute("email", email);
                request.setAttribute("fullName", fullName);
                request.setAttribute("phoneNumber", phoneNumber);
                request.setAttribute("citizenId", citizenId);
                request.setAttribute("address", address);
                
                RequestDispatcher dispatcher = request.getRequestDispatcher("Manager/RegisterTenant.jsp");
                dispatcher.forward(request, response);
                return;
            }

            // Check if email already exists
            if (dao.checkEmailExists(email)) {
                request.setAttribute("error", "Email đã tồn tại!");
                request.setAttribute("email", email);
                request.setAttribute("fullName", fullName);
                request.setAttribute("phoneNumber", phoneNumber);
                request.setAttribute("citizenId", citizenId);
                request.setAttribute("address", address);
                
                RequestDispatcher dispatcher = request.getRequestDispatcher("Manager/RegisterTenant.jsp");
                dispatcher.forward(request, response);
                return;
            }

            // Check if phone number already exists
            if (dao.checkPhoneExists(phoneNumber)) {
                request.setAttribute("error", "Số điện thoại đã tồn tại!");
                request.setAttribute("email", email);
                request.setAttribute("fullName", fullName);
                request.setAttribute("phoneNumber", phoneNumber);
                request.setAttribute("citizenId", citizenId);
                request.setAttribute("address", address);
                
                RequestDispatcher dispatcher = request.getRequestDispatcher("Manager/RegisterTenant.jsp");
                dispatcher.forward(request, response);
                return;
            }

            // Create new tenant user
            Users newTenant = new Users();
            newTenant.setEmail(email);
            newTenant.setPasswordHash(password);
            newTenant.setFullName(fullName);
            newTenant.setPhoneNumber(phoneNumber);
            newTenant.setCitizenId(citizenId);
            newTenant.setAddress(address);
            newTenant.setRoleId(3); // Tenant role
            newTenant.setActive(true);

            // Register the new tenant
            dao.createUser(newTenant);
            
            request.setAttribute("success", "Đăng ký người thuê thành công!");
            response.sendRedirect("listusers");

        } catch (Exception e) {
            request.setAttribute("error", "Có lỗi xảy ra: " + e.getMessage());
            e.printStackTrace();
            
            RequestDispatcher dispatcher = request.getRequestDispatcher("Manager/RegisterTenant.jsp");
            dispatcher.forward(request, response);
        }
    }

    @Override
    public String getServletInfo() {
        return "Register Servlet";
    }
}
