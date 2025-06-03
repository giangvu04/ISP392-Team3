package Controller.roomservlet;

import dal.DAORooms;
import model.Rooms;
import model.Users;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.logging.Level;
import java.util.logging.Logger;

public class ListRoomsServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        DAORooms dao = DAORooms.INSTANCE;
        HttpSession session = request.getSession();
        request.setAttribute("message", "");

        Users user = (Users) session.getAttribute("user");
        
        if (user != null) {
            request.setAttribute("user", user);
            
            // Lấy trang hiện tại từ tham số URL, mặc định là 1
            int currentPage = Integer.parseInt(request.getParameter("page") != null ? request.getParameter("page") : "1");
            int roomsPerPage = 5; // Số phòng trên mỗi trang
            String sortBy = request.getParameter("sortBy");

            // Lấy tổng số phòng và tổng số trang
            int totalRooms = dao.getTotalRooms();
            int totalPages = (int) Math.ceil((double) totalRooms / roomsPerPage);
            
            // Lấy phòng cho trang hiện tại
            ArrayList<Rooms> rooms;
            if(user.getRoleid() == 2) {
                rooms = dao.getRoomsByPage(currentPage, roomsPerPage);
            } else {
                rooms = dao.getRoomsByPage2(currentPage, roomsPerPage);
            }
            
            // Xử lý sắp xếp
            if (sortBy != null) {
                switch (sortBy) {
                    case "price_asc":
                        rooms.sort(Comparator.comparingDouble(Rooms::getPrice));
                        break;
                    case "price_desc":
                        rooms.sort(Comparator.comparingDouble(Rooms::getPrice).reversed());
                        break;
                    case "status_asc":
                        rooms.sort(Comparator.comparing(Rooms::isStatus));
                        break;
                    case "status_desc":
                        rooms.sort(Comparator.comparing(Rooms::isStatus).reversed());
                        break;
                    case "address_asc":
                        rooms.sort(Comparator.comparing(Rooms::getAddress));
                        break;
                    case "address_desc":
                        rooms.sort(Comparator.comparing(Rooms::getAddress).reversed());
                        break;
                    case "type_asc":
                        rooms.sort(Comparator.comparing(Rooms::getRoomType));
                        break;
                    case "type_desc":
                        rooms.sort(Comparator.comparing(Rooms::getRoomType).reversed());
                        break;
                }
            }
            
            // Set attributes for JSP
            request.setAttribute("rooms", rooms);
            request.setAttribute("currentPage", currentPage);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("sortBy", sortBy);

            // Chuyển đến trang dựa trên vai trò người dùng
            if (user.getRoleid() == 1) {
                request.getRequestDispatcher("RoomsManager/ListRoomForAdmin.jsp").forward(request, response);
            } else if (user.getRoleid() == 2) {
                request.getRequestDispatcher("RoomsManager/ListRoomForManager.jsp").forward(request, response);
            } else if (user.getRoleid() == 3) {
                request.getRequestDispatcher("RoomsManager/ListRoomForTenant.jsp").forward(request, response);
            } else {
                response.sendError(HttpServletResponse.SC_FORBIDDEN, "Không có quyền truy cập.");
            }
        } else {
            response.sendRedirect("login.jsp");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        String information = request.getParameter("information");

        DAORooms dao = DAORooms.INSTANCE;
        HttpSession session = request.getSession();
        Users user = (Users) session.getAttribute("user");

        if (user != null) {
            request.setAttribute("user", user);

            ArrayList<Rooms> rooms;
            try {

                rooms = dao.getRoomsBySearch(information);
                if (rooms == null || rooms.isEmpty()) {
                    request.setAttribute("message", "Không tìm thấy phòng nào.");
                } else {
                    request.setAttribute("message", "Kết quả tìm kiếm cho: " + information);
                }

                // Cập nhật currentPage và totalPages
                int totalRooms = rooms.size(); // Tổng sản phẩm tìm được
                int totalPages = (int) Math.ceil(totalRooms / 5.0); // Cập nhật với số sản phẩm mỗi trang

                // Thiết lập các thuộc tính cho JSP
                request.setAttribute("rooms", rooms);
                request.setAttribute("currentPage", 1); // Đặt lại về trang đầu tiên
                request.setAttribute("totalPages", totalPages); // Cập nhật tổng trang

            } catch (Exception ex) {
                Logger.getLogger(ListRoomsServlet.class.getName()).log(Level.SEVERE, null, ex);
                request.setAttribute("message", "Đã xảy ra lỗi khi tìm kiếm.");
            }

            // Chuyển hướng đến trang dựa trên vai trò người dùng
            if (user.getRoleid() == 1) {
                request.getRequestDispatcher("RoomsManager/ListRoomForAdmin.jsp").forward(request, response);
            } else if (user.getRoleid() == 2) {
                request.getRequestDispatcher("RoomsManager/ListRoomForManager.jsp").forward(request, response);
            } else if (user.getRoleid() == 3) {
                request.getRequestDispatcher("RoomsManager/ListRoomForTenant.jsp").forward(request, response);
            } else {
                response.sendError(HttpServletResponse.SC_FORBIDDEN, "Không có quyền truy cập.");
            }
        } else {
            response.sendRedirect("login.jsp");
        }
    }

    @Override
    public String getServletInfo() {
        return "Servlet quản lý phòng";
    }

}
