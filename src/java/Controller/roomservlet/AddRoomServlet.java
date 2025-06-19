package Controller.roomservlet;

import dal.DAORooms;
import java.io.IOException;
import java.math.BigDecimal;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.Rooms;

public class AddRoomServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Forward to the add room JSP
        request.getRequestDispatcher("Manager/addRoom.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Get parameters from the form
            int rentalAreaId = Integer.parseInt(request.getParameter("rentalAreaId"));
            String roomNumber = request.getParameter("roomNumber");
            BigDecimal area = new BigDecimal(request.getParameter("area"));
            BigDecimal price = new BigDecimal(request.getParameter("price"));
            int maxTenants = Integer.parseInt(request.getParameter("maxTenants"));
            int status = Integer.parseInt(request.getParameter("status"));
            String description = request.getParameter("description");

            // Create a new room object
            Rooms room = new Rooms();
            room.setRentalAreaId(rentalAreaId);
            room.setRoomNumber(roomNumber);
            room.setArea(area);
            room.setPrice(price);
            room.setMaxTenants(maxTenants);
            room.setStatus(status);
            room.setDescription(description);

            // Add the room to the database
            boolean success = DAORooms.INSTANCE.addRoom(room);

            if (success) {
                request.getSession().setAttribute("message", "Room added successfully!");
                request.getSession().setAttribute("messageType", "success");
            } else {
                request.getSession().setAttribute("message", "Failed to add room. Please try again.");
                request.getSession().setAttribute("messageType", "danger");
            }

            response.sendRedirect("listrooms");

        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("message", "An error occurred: " + e.getMessage());
            request.getSession().setAttribute("messageType", "danger");
            response.sendRedirect("Manager/addRoom.jsp");
        }
    }
}
