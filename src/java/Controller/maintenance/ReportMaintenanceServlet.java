package Controller.maintenance;

import dal.DAOMaintenance;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Users;
import java.io.IOException;
import java.sql.Timestamp;

@WebServlet("/maintenanceReport")
public class ReportMaintenanceServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        HttpSession session = request.getSession(false);
        Users user = (session != null) ? (Users) session.getAttribute("user") : null;
        if (user == null) {
            response.sendRedirect("login");
            return;
        }
        try {
            int rentalAreaId = Integer.parseInt(request.getParameter("rentalAreaId"));
            String roomIdStr = request.getParameter("roomId");
            Integer roomId = (roomIdStr == null || roomIdStr.isEmpty()) ? null : Integer.parseInt(roomIdStr);
            String title = request.getParameter("title");
            String description = request.getParameter("description");
            Timestamp now = new Timestamp(System.currentTimeMillis());
            DAOMaintenance dao = new DAOMaintenance();
            dao.addMaintenanceLog(rentalAreaId, roomId, title, description, now, user.getUserId());
            response.sendRedirect("maintenanceList");
        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("error", "Có lỗi xảy ra khi gửi báo lỗi!");
            response.sendRedirect("maintenanceList");
        }
    }
}
