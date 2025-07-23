package Controller.userservlet;

import dal.DAOUser;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet(name = "kickTenant", urlPatterns = {"/kickTenant"})
public class kickTenant extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int tenantId = Integer.parseInt(request.getParameter("tenantId"));
            int roomId = Integer.parseInt(request.getParameter("roomId"));
            int managerId = ((model.Users) request.getSession().getAttribute("user")).getUserId();
            boolean ok = DAOUser.INSTANCE.kickTenant(tenantId, roomId, managerId);
            if (ok) {
                request.getSession().setAttribute("kickSuccess", "Kích người thuê thành công!");
            } else {
                request.getSession().setAttribute("kickError", "Kích người thuê thất bại!");
            }
        } catch (Exception e) {
            request.getSession().setAttribute("kickError", "Lỗi: " + e.getMessage());
        }
        response.sendRedirect("listUser");
    }
}
