package Controller.rental;

import dal.DAORentalArea;
import model.RentalArea;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet(name = "EditRentalArea", urlPatterns = {"/editrentail"})
public class EditRentalArea extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String idStr = request.getParameter("id");
        int id = 0;
        try {
            id = Integer.parseInt(idStr);
        } catch (Exception e) {
            request.setAttribute("error", "ID khu trọ không hợp lệ!");
            request.getRequestDispatcher("Manager/RentalList.jsp").forward(request, response);
            return;
        }
        DAORentalArea dao = new DAORentalArea();
        RentalArea rentalArea = dao.getRentalAreaDetail(id);
        if (rentalArea == null) {
            request.setAttribute("error", "Không tìm thấy khu trọ!");
            request.getRequestDispatcher("Manager/RentalList.jsp").forward(request, response);
            return;
        }
        request.setAttribute("rentalArea", rentalArea);
        request.getRequestDispatcher("Manager/EditRentalArea.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int id = Integer.parseInt(request.getParameter("rentalAreaId"));
        String name = request.getParameter("name");
        String address = request.getParameter("address");
        String province = request.getParameter("province");
        String district = request.getParameter("district");
        String ward = request.getParameter("ward");
        String street = request.getParameter("street");
        String detail = request.getParameter("detail");
        DAORentalArea dao = new DAORentalArea();
        boolean success = dao.updateRentalArea(id, name, address, province, district, ward, street, detail);
        if (success) {
            response.sendRedirect("detailrentail?id=" + id);
        } else {
            request.setAttribute("error", "Cập nhật thất bại!");
            request.setAttribute("rentalArea", dao.getRentalAreaDetail(id));
            request.getRequestDispatcher("Manager/EditRentalArea.jsp").forward(request, response);
        }
    }
}
