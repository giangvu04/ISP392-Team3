package Controller.adminservlet;

import dal.DAOBill;
import dal.DAOContract;
import dal.DAORooms;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import model.Users;

@WebServlet(name = "ManagerHomepageServlet", urlPatterns = {"/ManagerHomepage"})
public class ManagerHomepageServlet extends HttpServlet {

    DAORooms rdao = DAORooms.INSTANCE;
    DAOContract cdao = DAOContract.INSTANCE;
    DAOBill bdao = DAOBill.INSTANCE;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();

        // Check if user is logged in
        if (session.getAttribute("user") == null) {
            response.sendRedirect("login");
            return;
        }

        Users user = (Users) session.getAttribute("user");

        // Check if user has manager role (role_id = 2)
        if (user.getRoleId() != 2) {
            // Redirect to appropriate page based on role
            if (user.getRoleId() == 1) {
                response.sendRedirect("AdminHomepage");
            } else if (user.getRoleId() == 3) {
                response.sendRedirect("TenantHomepage");
            } else {
                request.getSession().setAttribute("error", "Đã có lỗi xảy ra. Vui lòng thử lại");
                response.sendRedirect("login");
            }
            return;
        }
        int[] room = rdao.getRoomStatsForManager(user.getUserId());
        request.setAttribute("totalRooms", room[0]);
        request.setAttribute("rentedRooms", room[1]);
        request.setAttribute("vacantRooms", room[2]);
        int newContract = cdao.getNewContractsThisMonth(user.getUserId());
        request.setAttribute("newContract", newContract);

        int fillPercent;
        if (room[0] == 0) {
            fillPercent = 0;                       // hoặc -1 để báo "không có phòng"
        } else {
            fillPercent = (int) Math.round((room[1] * 100.0) / room[0]);
        }
        request.setAttribute("fillPercent", fillPercent);

        int expiringContracts = cdao.getExpiringContracts(user.getUserId(), 30);
        request.setAttribute("expiringContracts", expiringContracts);

        double profit = bdao.getMonthlyRevenue(user.getUserId());
        request.setAttribute("profit", profit);

        // Manager is authenticated and authorized
        request.setAttribute("user", user);
        request.getRequestDispatcher("Manager/manager_homepage.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}