
package Controller.userservlet;

import dal.DAOUser;
import model.Users;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.ArrayList;

@WebServlet(name = "listUser", urlPatterns = {"/listUser"})
public class listUser extends HttpServlet {
    private static final int PAGE_SIZE = 10;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        model.Users user = (model.Users) request.getSession().getAttribute("user");
        if (user == null || user.getRoleId() != 2) { // chỉ cho phép manager (roleId=2)
            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Bạn không có quyền truy cập chức năng này.");
            return;
        }
        int managerId = user.getUserId();
        String pageStr = request.getParameter("page");
        String name = request.getParameter("name");
        String phone = request.getParameter("phone");
        String email = request.getParameter("email");
        int page = 1;
        if (pageStr != null) {
            try { page = Integer.parseInt(pageStr); } catch (Exception ignored) {}
        }
        if (page < 1) page = 1;
        int total = DAOUser.INSTANCE.countTenantsByManager(managerId, name, phone, email);
        int totalPages = (int) Math.ceil((double) total / PAGE_SIZE);
        if (page > totalPages && totalPages > 0) page = totalPages;
        ArrayList<Users> tenants = DAOUser.INSTANCE.getTenantsByManagerPaged(managerId, page, PAGE_SIZE, name, phone, email);
        request.setAttribute("tenants", tenants);
        request.setAttribute("page", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("name", name != null ? name : "");
        request.setAttribute("phone", phone != null ? phone : "");
        request.setAttribute("email", email != null ? email : "");
        boolean hasSearch = (name != null && !name.isEmpty()) || (phone != null && !phone.isEmpty()) || (email != null && !email.isEmpty());
        request.setAttribute("search", hasSearch ? "1" : "");
        request.getRequestDispatcher("/userprofile/TenantManagement.jsp").forward(request, response);
    }
}
