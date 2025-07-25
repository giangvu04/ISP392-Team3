package Controller.rental;

import dal.DAORentalArea;
import model.RentalArea;
import Ultils.ReadFile;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet(name = "ListRentalArea", urlPatterns = {"/listrentail"})
public class ListRentalArea extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Lấy các tham số filter, search, sort, phân trang
        String searchTerm = request.getParameter("searchTerm") != null ? request.getParameter("searchTerm") : "";
        String province = request.getParameter("province") != null ? request.getParameter("province") : "";
        String district = request.getParameter("district") != null ? request.getParameter("district") : "";
        String ward = request.getParameter("ward") != null ? request.getParameter("ward") : "";
        String sortBy = request.getParameter("sortBy") != null ? request.getParameter("sortBy") : "name";
        String sortOrder = request.getParameter("sortOrder") != null ? request.getParameter("sortOrder") : "asc";
        int page = 1;
        int pageSize = 10;
        try {
            page = Integer.parseInt(request.getParameter("page"));
        } catch (Exception e) { page = 1; }

        // Lấy user từ session để xác định role
        model.Users user = (model.Users) request.getSession().getAttribute("user");
        Integer managerId = null;
        boolean isAdmin = false;
        if (user != null) {
            if (user.getRoleId() == 2) {
                managerId = user.getUserId(); // Manager chỉ xem khu trọ của mình
            } else if (user.getRoleId() == 1) {
                isAdmin = true; // Admin xem tất cả
            }
        }

        // Lấy danh sách tỉnh/thành
        List<String> provinces = ReadFile.loadAllProvinces(request);
        request.setAttribute("provinces", provinces);
        request.setAttribute("selectedProvince", province);
        request.setAttribute("selectedDistrict", district);
        request.setAttribute("selectedWard", ward);
        request.setAttribute("sortBy", sortBy);
        request.setAttribute("sortOrder", sortOrder);
        request.setAttribute("searchTerm", searchTerm);
        request.setAttribute("currentPage", page);

        // Gọi DAO lấy danh sách khu trọ theo filter, search, sort, phân trang, role
        DAORentalArea dao = new DAORentalArea();
        List<RentalArea> rentails = dao.getRentalAreas(searchTerm, province, district, ward, sortBy, sortOrder, page, pageSize, managerId);
        int totalRentail = dao.countRentalAreas(searchTerm, province, district, ward, managerId);
        int totalPages = (int) Math.ceil((double) totalRentail / pageSize);

        request.setAttribute("rentails", rentails);
        request.setAttribute("totalRentail", totalRentail);
        request.setAttribute("totalPages", totalPages);

        // Trả về các biến filter để FE giữ state
        request.setAttribute("selectedProvince", province);
        request.setAttribute("selectedDistrict", district);
        request.setAttribute("selectedWard", ward);
        request.setAttribute("sortBy", sortBy);
        request.setAttribute("sortOrder", sortOrder);
        request.setAttribute("searchTerm", searchTerm);
        request.setAttribute("currentPage", page);

        request.getRequestDispatcher("Manager/RentalList.jsp").forward(request, response);
    }
}
