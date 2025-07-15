package Controller.adminservlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import model.Rooms;
import model.Users;

@WebServlet(name="TenantHomepageServlet", urlPatterns={"/TenantHomepage"})
public class TenantHomepageServlet extends HttpServlet {

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
        
        // Check if user has tenant role (role_id = 3)
        if (user.getRoleId() != 3) {
            // Redirect to appropriate page based on role
            if (user.getRoleId() == 1) {
                response.sendRedirect("AdminHomepage");
            } else if (user.getRoleId() == 2) {
                response.sendRedirect("ManagerHomepage");
            } else {
                request.getSession().setAttribute("error", "Bạn không có quyền vào trang này");
                response.sendRedirect("login");
            }
            return;
        }
        // --- Lấy thông tin cho tenant homepage ---
        int tenantId = user.getUserId();
        // 1. Phòng hiện tại
        Rooms currentRoom = dal.DAORooms.INSTANCE.getCurrentRoomByTenant(tenantId);
        // 2. Hóa đơn chưa thanh toán
        ArrayList<model.Bill> unpaidBills = dal.DAOBill.INSTANCE.getUnpaidBillsByTenantId(tenantId);
        // 3. Dịch vụ đang sử dụng
        List<model.Services> currentServices = dal.DAOServices.INSTANCE.getCurrentServicesByTenant(tenantId);
        // 4. Số ngày còn lại của hợp đồng
        int daysLeft = dal.DAOContract.INSTANCE.getDaysLeftOfActiveContract(tenantId);

        request.setAttribute("user", user);
        request.setAttribute("currentRoom", currentRoom);
        request.setAttribute("unpaidBills", unpaidBills);
        request.setAttribute("currentServices", currentServices);
        request.setAttribute("daysLeft", daysLeft);
        request.getRequestDispatcher("Tenant/tenant_homepage.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
} 