package Controller.register;

import dal.DAOUser;
import model.Users;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet(name = "RegisterManager", urlPatterns = {"/registerManager"})
public class RegisterManager extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/register/RegisterManager.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Set encoding
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html; charset=UTF-8");

        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        String citizenId = request.getParameter("citizenId");
        String address = request.getParameter("address");

        String message = null;
        
        // Validation
        if (!password.equals(confirmPassword)) {
            message = "Mật khẩu nhập lại không khớp.";
            request.getSession().setAttribute("error", message);
            response.sendRedirect("registerManager");
            return;
        }

        DAOUser dao = DAOUser.INSTANCE;
        
        // Check email exists
        if (dao.checkEmailExists(email)) {
            message = "Địa chỉ email đã được sử dụng.";
            request.getSession().setAttribute("error", message);
            response.sendRedirect("registerManager");
            return;
        }
        
        // Check phone exists
        if (dao.checkPhoneExists(phone)) {
            message = "Số điện thoại đã được sử dụng.";
            request.getSession().setAttribute("error", message);
            response.sendRedirect("registerManager");
            return;
        }

        // Create new manager user
        Users user = new Users();
        user.setFullName(fullName);
        user.setEmail(email);
        user.setPhoneNumber(phone);
        user.setPasswordHash(password); // Hash sẽ thực hiện ở DAL
        user.setCitizenId(citizenId);
        user.setAddress(address);
        user.setRoleId(2); // Manager role
        user.setActive(false); // Chưa kích hoạt - chờ upload giấy tờ và duyệt

        try {
            boolean userId = dao.Register(user);
            if (userId) {
                Users users = dao.getUserByEmail2(email);
                int userID = users.getID();
                // Lưu userId vào session để bước 2 sử dụng
                request.getSession().setAttribute("newManagerId", userID);
                request.getSession().setAttribute("newManagerName", fullName);
                
                message = "Đăng ký thành công! Bước tiếp theo: Upload giấy tờ kinh doanh.";
                request.getSession().setAttribute("success", message);
                response.sendRedirect("uploadBusinessDocuments");
            } else {
                message = "Đăng ký thất bại. Vui lòng thử lại.";
                request.getSession().setAttribute("error", message);
                response.sendRedirect("registerManager");
            }
        } catch (Exception e) {
            System.err.println("Error registering manager: " + e.getMessage());
            e.printStackTrace();
            message = "Đăng ký thất bại. Vui lòng thử lại.";
            request.getSession().setAttribute("error", message);
            response.sendRedirect("registerManager");
        }
    }
}
