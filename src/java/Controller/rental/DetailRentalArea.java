package Controller.rental;

import dal.DAORentalArea;
import model.RentalArea;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet(name = "DetailRentalArea", urlPatterns = {"/detailrentail"})
public class DetailRentalArea extends HttpServlet {
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
        // Lấy danh sách phòng của khu trọ
        java.util.List<model.Room> rooms = dao.getRoomsByRentalAreaId(id);
        request.setAttribute("rentalArea", rentalArea);
        request.setAttribute("rooms", rooms);
        request.getRequestDispatcher("Manager/RentalDetail.jsp").forward(request, response);
    }
}
