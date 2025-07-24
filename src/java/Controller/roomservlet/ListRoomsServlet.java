package Controller.roomservlet;

import Const.Batch;
import Ultils.ReadFile;
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
import java.util.List;

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
            if (user == null) {
                response.sendRedirect("login");
                return;
            }
            request.setAttribute("user", user);

            // Get current page from URL parameter, default to 1
            int currentPage = 1;
            try {
                currentPage = Integer.parseInt(request.getParameter("page") != null ? request.getParameter("page") : "1");
                if (currentPage < 1) currentPage = 1;
            } catch (NumberFormatException e) {
                request.setAttribute("error", "Số trang không hợp lệ: " + e.getMessage());
            }

            int roomsPerPage = Batch.BATCH_ROOM; // Rooms per page
            String sortBy = request.getParameter("sortBy");
            String sortOrder = request.getParameter("sortOrder");
            String searchTerm = request.getParameter("searchTerm");
            String provinceId = request.getParameter("provinceId");
            String districtId = request.getParameter("districtId");
            String wardId = request.getParameter("wardId");

            // Get rental area ID based on user role (for non-location filters)
            List<Integer> rentalAreaIds = new ArrayList<>(); // For multi-area support
            ArrayList<Rooms> rooms = new ArrayList<>(); // Initialize empty list

            if (user.getRoleId() == 2) { // Manager
                List<RentalArea> rentalAreas = daoRentalArea.getListRentalAreaByManagerId(user.getUserId());
                if (rentalAreas != null) {
                    for (RentalArea ra : rentalAreas) {
                        rentalAreaIds.add(ra.getRentalAreaId());
                    }
                }
            } else if (user.getRoleId() == 3) { // Tenant
                List<String> provinces = ReadFile.loadAllProvinces(request);
                request.setAttribute("provinces", provinces);
                RentalArea rentalArea = daoRentalArea.getRentalAreaByTenantId(user.getUserId());
                if (rentalArea != null) {
                    rentalAreaIds.add(rentalArea.getRentalAreaId());
                } else {
                    // Tenant chưa gán khu, lấy tất cả phòng trống của mọi khu
                    List<RentalArea> allAreas = daoRentalArea.getAllRent();
                    if (allAreas != null) {
                        for (RentalArea ra : allAreas) {
                            rentalAreaIds.add(ra.getRentalAreaId());
                        }
                    }
                }
            }

            // Get rooms based on search or location filters
            if (searchTerm != null && !searchTerm.isEmpty()) {
                rooms = dao.searchRooms(searchTerm, rentalAreaIds);
            } else if (provinceId != null || districtId != null || wardId != null) {
                // Filter by location only if at least one is provided
                rooms = dao.getRoomsByLocation(provinceId, districtId, wardId, currentPage, roomsPerPage);
            } else {
                // Default behavior based on user role
                if (user.getRoleId() == 3) { // Tenant sees only available rooms
                    rooms = dao.getRoomsByStatus(0, rentalAreaIds, currentPage, roomsPerPage);
                } else {
                    rooms = dao.getRoomsByPage(currentPage, roomsPerPage, user.getUserId(), user.getRoleId());
                }
            }

            // Get total rooms and total pages
            int totalRooms = 0;
            if (searchTerm != null && !searchTerm.isEmpty()) {
                totalRooms = dao.getTotalRooms(user.getUserId(), user.getRoleId()); // Approx count for search
            } else if (provinceId != null || districtId != null || wardId != null) {
                totalRooms = dao.getTotalRoomsByLocation(provinceId, districtId, wardId);
            } else if (user.getRoleId() == 3) {
                totalRooms = dao.getTotalRooms(user.getUserId(), user.getRoleId()); // Approx for status filter
            } else {
                totalRooms = dao.getTotalRooms(user.getUserId(), user.getRoleId());
            }
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
            request.setAttribute("provinceId", provinceId);
            request.setAttribute("districtId", districtId);
            request.setAttribute("wardId", wardId);
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
            request.getRequestDispatcher("error.jsp").forward(request, response);
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