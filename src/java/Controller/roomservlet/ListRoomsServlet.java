package Controller.roomservlet;

import dal.DAORooms;
import dal.DAORentalArea;
import model.Rooms;
import model.Users;
import model.RentalArea;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.logging.Level;
import java.util.logging.Logger;

@WebServlet(name = "ListRoomsServlet", urlPatterns = {"/listrooms"})
public class ListRoomsServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        DAORooms dao = DAORooms.INSTANCE;
        DAORentalArea daoRentalArea = DAORentalArea.INSTANCE;
        HttpSession session = request.getSession();
        request.setAttribute("message", "");

        try {
            Users user = (Users) session.getAttribute("user");

            if (user != null) {
                request.setAttribute("user", user);

                // Get current page from URL parameter, default to 1
                int currentPage = 1;
                try {
                    currentPage = Integer.parseInt(request.getParameter("page") != null ? request.getParameter("page") : "1");
                    if (currentPage < 1) currentPage = 1;
                } catch (NumberFormatException e) {
                    request.setAttribute("error", "Số trang không hợp lệ: " + e.getMessage());
                }

                int roomsPerPage = 5; // Rooms per page
                String sortBy = request.getParameter("sortBy");
                String sortOrder = request.getParameter("sortOrder");
                String searchTerm = request.getParameter("searchTerm");

                // Get rental area ID based on user role
                int rentalAreaId = 0; // Default to 0 (all areas) for admin and tenant
                ArrayList<Rooms> rooms = new ArrayList<>(); // Initialize empty list

                try {
                    if (user.getRoleId() == 2) { // Manager
                        RentalArea rentalArea = daoRentalArea.getRentalAreaByManagerId(user.getUserId());
                        if (rentalArea != null) {
                            rentalAreaId = rentalArea.getRentalAreaId();
                        }
                    } else if (user.getRoleId() == 3) { // Tenant
                        RentalArea rentalArea = daoRentalArea.getRentalAreaByTenantId(user.getUserId());
                        if (rentalArea != null) {
                            rentalAreaId = rentalArea.getRentalAreaId();
                        }
                    }

                    // Get rooms based on search or all rooms
                    if (searchTerm != null && !searchTerm.isEmpty()) {
                        rooms = dao.searchRooms(searchTerm, rentalAreaId);
                    } else {
                        // For tenants, only show available rooms
                        if (user.getRoleId() == 3) {
                            rooms = dao.getRoomsByStatus(0, rentalAreaId);
                        } else {
                            rooms = dao.getRoomsByPage(currentPage, roomsPerPage, rentalAreaId);
                        }
                    }

                    // Handle case where tenant has no rental area assigned
                    if (user.getRoleId() == 3 && rentalAreaId == 0) {
                        request.setAttribute("error", "Bạn chưa được gán vào khu thuê nhà nào");
                    }

                    // Get rooms based on search or all rooms
                    if (searchTerm != null && !searchTerm.isEmpty()) {
                        rooms = dao.searchRooms(searchTerm, rentalAreaId);
                    } else if (user.getRoleId() == 3) { // Tenant sees only available rooms
                        rooms = dao.getRoomsByStatus(0, rentalAreaId);
                    } else {
                        rooms = dao.getRoomsByPage(currentPage, roomsPerPage, rentalAreaId);
                    }

                    // Get total rooms and total pages
                    int totalRooms = dao.getTotalRooms(rentalAreaId);
                    int totalPages = (int) Math.ceil((double) totalRooms / roomsPerPage);

                    // Handle sorting
                    if (sortBy != null && sortOrder != null) {
                        switch (sortBy) {
                            case "roomNumber":
                                if ("asc".equals(sortOrder)) {
                                    rooms.sort(Comparator.comparing(Rooms::getRoomNumber));
                                } else {
                                    rooms.sort(Comparator.comparing(Rooms::getRoomNumber).reversed());
                                }
                                break;
                            case "price":
                                if ("asc".equals(sortOrder)) {
                                    rooms.sort(Comparator.comparing(Rooms::getPrice));
                                } else {
                                    rooms.sort(Comparator.comparing(Rooms::getPrice).reversed());
                                }
                                break;
                            case "status":
                                if ("asc".equals(sortOrder)) {
                                    rooms.sort(Comparator.comparingInt(Rooms::getStatus));
                                } else {
                                    rooms.sort(Comparator.comparingInt(Rooms::getStatus).reversed());
                                }
                                break;
                        }
                    }
                    

                    // Set attributes for JSP
                    request.setAttribute("rooms", rooms);
                    request.setAttribute("currentPage", currentPage);
                    request.setAttribute("totalPages", totalPages);
                    request.setAttribute("sortBy", sortBy);
                    request.setAttribute("sortOrder", sortOrder);
                    request.setAttribute("searchTerm", searchTerm);
                    request.setAttribute("totalRooms", totalRooms);

                    // Forward based on user role
                    String destination;
                    switch (user.getRoleId()) {
                        case 1: // Admin
                            destination = "AdminHomepage";
                            break;
                        case 2: // Manager
                            destination = "Manager/RoomList.jsp";
                            break;
                        case 3: // Tenant
                            destination = "Tenant/RoomList.jsp";
                            break;
                        default:
                            response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access denied.");
                            return;
                    }

                    request.getRequestDispatcher(destination).forward(request, response);
                } catch (Exception e) {
                    request.setAttribute("error", "Lỗi khi tải danh sách phòng: " + e.getMessage());
                    request.getRequestDispatcher("error.jsp").forward(request, response); // Chuyển đến trang lỗi
                }
            } else {
                response.sendRedirect("login");
            }
        } catch (Exception e) {
            request.setAttribute("error", "Lỗi không xác định: " + e.getMessage());
            response.sendRedirect("error.jsp"); // Redirect nếu session hoặc user null
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response); // Just call doGet for form submissions
    }

    @Override
    public String getServletInfo() {
        return "Servlet for room management";
    }
}