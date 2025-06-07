package Controller.deviceservlet;

import dal.DAODevices;
import model.Devices;
import model.Users;
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

public class ListDevicesServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        DAODevices dao = DAODevices.INSTANCE;
        HttpSession session = request.getSession();
        request.setAttribute("message", "");

        Users user = (Users) session.getAttribute("user");
        
        if (user != null) {
            request.setAttribute("user", user);
            
            // Lấy trang hiện tại từ tham số URL, mặc định là 1
            int currentPage = Integer.parseInt(request.getParameter("page") != null ? request.getParameter("page") : "1");
            int devicesPerPage = 5; // Số thiết bị trên mỗi trang
            String sortBy = request.getParameter("sortBy");

            // Lấy tổng số thiết bị và tổng số trang
            int totalDevices = dao.getTotalDevices();
            int totalPages = (int) Math.ceil((double) totalDevices / devicesPerPage);
            
            // Lấy thiết bị cho trang hiện tại
            ArrayList<Devices> devices;
            if (user.getRoleid() == 2) {
                devices = dao.getDevicesByPage(currentPage, devicesPerPage);
            } else {
                devices = dao.getDevicesByPage2(currentPage, devicesPerPage);
            }
            
            // Xử lý sắp xếp
            if (sortBy != null) {
                switch (sortBy) {
                    case "name_asc":
                        devices.sort(Comparator.comparing(Devices::getName));
                        break;
                    case "name_desc":
                        devices.sort(Comparator.comparing(Devices::getName).reversed());
                        break;
                    case "quantity_asc":
                        devices.sort(Comparator.comparingInt(Devices::getQuantity));
                        break;
                    case "quantity_desc":
                        devices.sort(Comparator.comparingInt(Devices::getQuantity).reversed());
                        break;
                    case "status_asc":
                        devices.sort(Comparator.comparing(Devices::getStatus));
                        break;
                    case "status_desc":
                        devices.sort(Comparator.comparing(Devices::getStatus).reversed());
                        break;
                    case "roomID_asc":
                        devices.sort(Comparator.comparingInt(Devices::getRoomID));
                        break;
                    case "roomID_desc":
                        devices.sort(Comparator.comparingInt(Devices::getRoomID).reversed());
                        break;
                }
            }
            
            // Set attributes for JSP
            request.setAttribute("devices", devices);
            request.setAttribute("currentPage", currentPage);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("sortBy", sortBy);

            // Chuyển đến trang dựa trên vai trò người dùng
            if (user.getRoleid() == 1) {
                request.getRequestDispatcher("DevicesManager/ListDevicesForAdmin.jsp").forward(request, response);
            } else if (user.getRoleid() == 2) {
                request.getRequestDispatcher("DevicesManager/ListDevicesForManager.jsp").forward(request, response);
            } else if (user.getRoleid() == 3) {
                request.getRequestDispatcher("DevicesManager/ListDevicesForTenant.jsp").forward(request, response);
            } else {
                response.sendError(HttpServletResponse.SC_FORBIDDEN, "Không có quyền truy cập.");
            }
        } else {
            response.sendRedirect("login");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        String information = request.getParameter("information");

        DAODevices dao = DAODevices.INSTANCE;
        HttpSession session = request.getSession();
        Users user = (Users) session.getAttribute("user");

        if (user != null) {
            request.setAttribute("user", user);

            ArrayList<Devices> devices;
            try {
                devices = dao.getDevicesBySearch(information);
                if (devices == null || devices.isEmpty()) {
                    request.setAttribute("message", "Không tìm thấy thiết bị nào.");
                } else {
                    request.setAttribute("message", "Kết quả tìm kiếm cho: " + information);
                }

                // Cập nhật currentPage và totalPages
                int totalDevices = devices.size(); // Tổng thiết bị tìm được
                int totalPages = (int) Math.ceil(totalDevices / 5.0); // Cập nhật với số thiết bị mỗi trang

                // Thiết lập các thuộc tính cho JSP
                request.setAttribute("devices", devices);
                request.setAttribute("currentPage", 1); // Đặt lại về trang đầu tiên
                request.setAttribute("totalPages", totalPages); // Cập nhật tổng trang

            } catch (Exception ex) {
                Logger.getLogger(ListDevicesServlet.class.getName()).log(Level.SEVERE, null, ex);
                request.setAttribute("message", "Đã xảy ra lỗi khi tìm kiếm.");
            }

            // Chuyển hướng đến trang dựa trên vai trò người dùng
            if (user.getRoleid() == 1) {
                request.getRequestDispatcher("DevicesManager/ListDevicesForAdmin.jsp").forward(request, response);
            } else if (user.getRoleid() == 2) {
                request.getRequestDispatcher("DevicesManager/ListDevicesForManager.jsp").forward(request, response);
            } else if (user.getRoleid() == 3) {
                request.getRequestDispatcher("DevicesManager/ListDevicesForTenant.jsp").forward(request, response);
            } else {
                response.sendError(HttpServletResponse.SC_FORBIDDEN, "Không có quyền truy cập.");
            }
        } else {
            response.sendRedirect("login");
        }
    }

    @Override
    public String getServletInfo() {
        return "Servlet quản lý thiết bị";
    }
}