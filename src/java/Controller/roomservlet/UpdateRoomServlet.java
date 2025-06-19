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

public class UpdateRoomServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int roomId = Integer.parseInt(request.getParameter("roomId"));
            Rooms room = DAORooms.INSTANCE.getRoomById(roomId);
            
            if (room != null) {
                request.setAttribute("room", room);
                request.getRequestDispatcher("Manager/updateRoom.jsp").forward(request, response);
            } else {
                request.getSession().setAttribute("message", "Room not found!");
                request.getSession().setAttribute("messageType", "danger");
                response.sendRedirect("listrooms");
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("message", "An error occurred: " + e.getMessage());
            request.getSession().setAttribute("messageType", "danger");
            response.sendRedirect("listrooms");
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Get parameters from the form
            int roomId = Integer.parseInt(request.getParameter("roomId"));
            int rentalAreaId = Integer.parseInt(request.getParameter("rentalAreaId"));
            String roomNumber = request.getParameter("roomNumber");
            BigDecimal area = new BigDecimal(request.getParameter("area"));
            BigDecimal price = new BigDecimal(request.getParameter("price"));
            int maxTenants = Integer.parseInt(request.getParameter("maxTenants"));
            int status = Integer.parseInt(request.getParameter("status"));
            String description = request.getParameter("description");

            // Create a room object with updated information
            Rooms room = new Rooms();
            room.setRoomId(roomId);
            room.setRentalAreaId(rentalAreaId);
            room.setRoomNumber(roomNumber);
            room.setArea(area);
            room.setPrice(price);
            room.setMaxTenants(maxTenants);
            room.setStatus(status);
            room.setDescription(description);

            // Update the room in the database
            boolean success = DAORooms.INSTANCE.updateRoom(room);

            if (success) {
                request.getSession().setAttribute("message", "Room updated successfully!");
                request.getSession().setAttribute("messageType", "success");
            } else {
                request.getSession().setAttribute("message", "Failed to update room. Please try again.");
                request.getSession().setAttribute("messageType", "danger");
            }
            
            response.sendRedirect("listrooms");
            
        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("message", "An error occurred: " + e.getMessage());
            request.getSession().setAttribute("messageType", "danger");
            response.sendRedirect("listrooms");
        }
    }
}
