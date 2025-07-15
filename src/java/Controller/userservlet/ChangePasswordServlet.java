package Controller.userservlet;

import dal.DAOUser;
import model.Users;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet(name = "ChangePasswordServlet", urlPatterns = {"/changePassword"})
public class ChangePasswordServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        Users user = (Users) session.getAttribute("user");
        if (user == null) {
            response.sendRedirect("login");
            return;
        }
        String oldPassword = request.getParameter("oldPassword");
        String newPassword = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");

        if (!user.getPasswordHash().equals(oldPassword)) {
            // Mật khẩu cũ không đúng
            request.getSession().setAttribute("error", "Mật khẩu cũ không đúng!");
            if (user.getRoleId() == 2) {
                response.sendRedirect("profileManager");
            } else {
                response.sendRedirect("profileTelnant");
            }
            return;
        }
        if (!newPassword.equals(confirmPassword)) {
            // Mật khẩu mới không khớp
            request.getSession().setAttribute("error", "Mật khẩu mới không khớp!");
            if (user.getRoleId() == 2) {
                response.sendRedirect("profileManager");
            } else {
                response.sendRedirect("profileTelnant");
            }
            return;
        }
        user.setPasswordHash(newPassword);
        DAOUser dao = new DAOUser();
        dao.updateUserPassword(user);
        session.setAttribute("user", user);
        if (user.getRoleId() == 2) {
            response.sendRedirect("profileManager");
        } else {
            response.sendRedirect("profileTelnant");
        }
    }
}
