package Controller.register;

import dal.DAOUser;
import model.Users;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet(name = "Register", urlPatterns = {"/registerr"})
public class Register extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/register/Register.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Kiểm tra quyền feedback/gửi tin nhắn dựa trên roleId trong session
        Integer roleId = (Integer) request.getSession().getAttribute("roleId");
        String action = request.getParameter("action"); // "feedback" hoặc "message" hoặc null
        if (action != null) {
            if (action.equals("feedback") && (roleId == null || roleId != 3)) {
                request.getSession().setAttribute("error", "Chỉ tenant (role 3) mới được phép feedback.");
                response.sendRedirect("registerr");
                return;
            }
            if (action.equals("message") && (roleId == null || roleId != 2)) {
                request.getSession().setAttribute("error", "Chỉ manager (role 2) mới được gửi tin nhắn.");
                response.sendRedirect("registerr");
                return;
            }
        }

        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");

        String message = null;
        if (!password.equals(confirmPassword)) {
            message = "Mật khẩu nhập lại không khớp.";
            request.getSession().setAttribute("error", message);
            response.sendRedirect("registerr");
            return;
        }

        DAOUser dao = DAOUser.INSTANCE;
        if (dao.checkEmailExists(email)) {
            message = "Địa chỉ email đã được sử dụng.";
            request.getSession().setAttribute("error", message);
            response.sendRedirect("registerr");
            return;
        }
        if (dao.checkPhoneExists(phone)) {
            message = "Số điện thoại đã được sử dụng.";
            request.getSession().setAttribute("error", message);
            response.sendRedirect("registerr");
            return;
        }
        

        Users user = new Users();
        user.setFullName(fullName);
        user.setEmail(email);
        user.setPhoneNumber(phone);
        user.setPasswordHash(password); // Hash sẽ thực hiện ở DAL
        user.setRoleId(3); // Mặc định là tenant
        user.setActive(true);

        try {
            dao.Register(user);
            message = "Đăng ký thành công! Vui lòng đăng nhập.";
            request.getSession().setAttribute("ms", message);
            response.sendRedirect("login");
        } catch (Exception e) {
            message = "Đăng ký thất bại. Vui lòng thử lại.";
            request.getSession().setAttribute("error", message);
            response.sendRedirect("registerr");
        }
    }
}
