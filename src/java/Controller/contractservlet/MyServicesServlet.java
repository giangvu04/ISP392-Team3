package Controller.contractservlet;

import dal.DAOServices;
import model.Users;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;
import model.Services;

@WebServlet(name = "MyServicesServlet", urlPatterns = {"/myservices"})
public class MyServicesServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Users user = (Users) request.getSession().getAttribute("user");
        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        // Lấy danh sách dịch vụ đã chọn của user (tenant)
        DAOServices dao = new DAOServices();
        List<Services> myServices = dao.getServicesByTenantId(user.getUserId());
        request.setAttribute("myServices", myServices);
        request.getRequestDispatcher("/Service/MyServices.jsp").forward(request, response);
    }
}
