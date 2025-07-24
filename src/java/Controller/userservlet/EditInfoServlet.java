
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

@WebServlet(name = "EditInfoServlet", urlPatterns = {"/editInfo"})
public class EditInfoServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        Users user = (Users) session.getAttribute("user");
        if (user == null) {
            response.sendRedirect("login");
            return;
        }
        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String phoneNumber = request.getParameter("phoneNumber");
        String citizenId = request.getParameter("citizenId");
        String address = request.getParameter("address");

        user.setFullName(fullName);
        user.setEmail(email);
        user.setPhoneNumber(phoneNumber);
        user.setCitizenId(citizenId);
        user.setAddress(address);

        DAOUser dao = new DAOUser();
        dao.updateUser(user);
        session.setAttribute("user", user);
        // Redirect theo roleId
        if (user.getRoleId() == 2) {
            session.setAttribute("ms", "Cập nhật thông tin thành công!");
            response.sendRedirect("profileManager");
        } else {
            session.setAttribute("ms", "Cập nhật thông tin thành công!");
            response.sendRedirect("profileTelnant");
        }
    }
}
