package Controller.roomservlet;

import dal.DAORentalArea;
import dal.DAORooms;
import java.io.IOException;
import java.math.BigDecimal;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;
import model.RentalArea;
import model.Rooms;
import model.Users;
@WebServlet(name = "AddRoomServlet", urlPatterns = {"/addroom"})
public class AddRoomServlet extends HttpServlet {
    private DAORentalArea rentaldao = DAORentalArea.INSTANCE;
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Forward to the add room JSP
        Users user = (Users) request.getSession().getAttribute("user");
        if(user == null){
            request.getSession().setAttribute("error","Phiên đã hết hạn vui lòng login lại !");
            response.sendRedirect("login");
            return;
        }
        List<RentalArea> rental = rentaldao.getListRentalAreaByManagerId(user.getUserId());
        request.setAttribute("rentail", rental);
        request.getRequestDispatcher("Manager/addRoom.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Get all parameters from the request
        String rentalAreaIdStr = request.getParameter("rentalAreaId");
        String roomNumber = request.getParameter("roomNumber");
        String areaStr = request.getParameter("area");
        String priceStr = request.getParameter("price");
        String maxTenantsStr = request.getParameter("maxTenants");
        String statusStr = request.getParameter("status");
        String description = request.getParameter("description");

        // Initialize error message
        String errorMessage = null;

        try {
            // Validate and parse parameters
            int rentalAreaId = Integer.parseInt(rentalAreaIdStr);
            BigDecimal area = new BigDecimal(areaStr);
            BigDecimal price = new BigDecimal(priceStr);
            int maxTenants = Integer.parseInt(maxTenantsStr);
            int status = Integer.parseInt(statusStr);

            // Create room object
            Rooms room = new Rooms();
            room.setRentalAreaId(rentalAreaId);
            room.setRoomNumber(roomNumber);
            room.setArea(area);
            room.setPrice(price);
            room.setMaxTenants(maxTenants);
            room.setStatus(status);
            room.setDescription(description);

            // Attempt to add the room
            boolean success = DAORooms.INSTANCE.addRoom(room);

            if (success) {
                // Redirect to success page or room listing
                request.getSession().setAttribute("ms", "Thêm phòng thành công");
                response.sendRedirect("listrooms");
                return;
            } else {
                request.getSession().setAttribute("error", "Thêm phòng không thành công");
                response.sendRedirect("listrooms");
                return;
            }
        } catch (NumberFormatException e) {
            request.getSession().setAttribute("error", "Đã có lỗi xảy ra. Vui lòng thử lại");
            response.sendRedirect("listrooms");
            return;
        } catch (Exception e) {
            request.getSession().setAttribute("error", "Đã có lỗi xảy ra. Vui lòng thử lại");
            response.sendRedirect("listrooms");
            e.printStackTrace(); // Log the full error for debugging
        }

        // If we get here, there was an error
        request.setAttribute("error", errorMessage);

        // Preserve the form inputs so user doesn't lose their data
        request.setAttribute("rentalAreaId", rentalAreaIdStr);
        request.setAttribute("roomNumber", roomNumber);
        request.setAttribute("area", areaStr);
        request.setAttribute("price", priceStr);
        request.setAttribute("maxTenants", maxTenantsStr);
        request.setAttribute("status", statusStr);
        request.setAttribute("description", description);

        // Forward back to the form page
        request.getRequestDispatcher("Manager/addRoom.jsp").forward(request, response);
    }
}
