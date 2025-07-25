/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controller.deviceservlet;

import dal.DAODeviceInRoom;
import dal.DAODevices;
import dal.DAORooms;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.ArrayList;
import java.util.List;
import model.DeviceInRoom;
import model.Devices;
import model.Room;
import model.Rooms;
import model.Users;

/**
 *
 * @author ADMIN
 */
@WebServlet(name = "DeviceInRoomServlet", urlPatterns = {"/deviceinroom"})
public class DeviceInRoomServlet extends HttpServlet {

    private final DAODeviceInRoom deviceInRoomDAO = DAODeviceInRoom.INSTANCE;
    private final DAODevices deviceDAO = DAODevices.INSTANCE;
    private final DAORooms roomDAO = DAORooms.INSTANCE;
    private static final int DEVICES_PER_PAGE = 10;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        if (action == null) {
            action = "list";
        }

        try {
            switch (action) {
                case "list":
                    listDevicesInRooms(request, response);
                    break;
                case "listByRoom":
                    listDevicesByRoom(request, response);
                    break;
                case "search":
                    searchDevicesInRooms(request, response);
                    break;
                case "add":
                    showAddForm(request, response);
                    break;
                case "edit":
                    showEditForm(request, response);
                    break;
                case "delete":
                    removeDeviceFromRoom(request, response);
                    break;
                case "view":
                    viewDeviceInRoom(request, response);
                    break;
                default:
                    listDevicesInRooms(request, response);
                    break;
            }
        } catch (Exception e) {
            handleError(request, response, "Lỗi xử lý yêu cầu: " + e.getMessage());
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");

        try {
            switch (action) {
                case "add":
                    addDeviceToRoom(request, response);
                    break;
                case "update":
                    updateDeviceInRoom(request, response);
                    break;
                case "delete":
                    removeDeviceFromRoom(request, response);
                    break;
                default:
                    response.sendRedirect("deviceinroom?action=list");
                    break;
            }
        } catch (Exception e) {
            handleError(request, response, "Lỗi xử lý yêu cầu: " + e.getMessage());
        }
    }

    private void listDevicesInRooms(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            // Xử lý phân trang
            int page = 1;
            String pageStr = request.getParameter("page");
            if (pageStr != null && !pageStr.isEmpty()) {
                try {
                    page = Integer.parseInt(pageStr);
                    if (page < 1) {
                        page = 1;
                    }
                } catch (NumberFormatException e) {
                    page = 1;
                }
            }
            HttpSession session = request.getSession();
            Users user = (Users) session.getAttribute("user");
            ArrayList<DeviceInRoom> devicesInRooms;
            int totalDevices;
            if (user != null && user.getRoleId()== 2) { // Manager
                devicesInRooms = deviceInRoomDAO.getDevicesInRoomsByPageAndManager(page, DEVICES_PER_PAGE, user.getUserId());
                totalDevices = deviceInRoomDAO.getTotalDevicesInRoomsByManager(user.getUserId());
            } else { // Admin or fallback
                System.out.println("hehehe nó khác manager");
                devicesInRooms = deviceInRoomDAO.getDevicesInRoomsByPage(page, DEVICES_PER_PAGE);
                totalDevices = deviceInRoomDAO.getTotalDevicesInRooms();
            }
            int totalPages = (int) Math.ceil((double) totalDevices / DEVICES_PER_PAGE);
            request.setAttribute("devicesInRooms", devicesInRooms);
            request.setAttribute("currentPage", page);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("totalDevices", totalDevices);
            request.setAttribute("devicesPerPage", DEVICES_PER_PAGE);

            // Forward đến JSP
            request.getRequestDispatcher("/Deviceinroom/list.jsp").forward(request, response);

        } catch (Exception e) {
            handleError(request, response, "Lỗi khi tải danh sách thiết bị trong phòng: " + e.getMessage());
        }
    }

    private void listDevicesByRoom(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            String roomIdStr = request.getParameter("roomId");
            if (roomIdStr == null || roomIdStr.isEmpty()) {
                setErrorMessage(request, "ID phòng không hợp lệ");
                response.sendRedirect("deviceinroom?action=list");
                return;
            }

            int roomId = Integer.parseInt(roomIdStr);
            ArrayList<DeviceInRoom> devicesInRoom = deviceInRoomDAO.getDevicesByRoomId(roomId);

            request.setAttribute("devicesInRooms", devicesInRoom);
            request.setAttribute("roomId", roomId);
            request.setAttribute("filterByRoom", true);

            request.getRequestDispatcher("/views/deviceinroom/list.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            setErrorMessage(request, "ID phòng không hợp lệ");
            response.sendRedirect("deviceinroom?action=list");
        } catch (Exception e) {
            handleError(request, response, "Lỗi khi tải thiết bị theo phòng: " + e.getMessage());
        }
    }

    private void searchDevicesInRooms(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            String keyword = request.getParameter("keyword");
            if (keyword == null || keyword.trim().isEmpty()) {
                response.sendRedirect("deviceinroom?action=list");
                return;
            }
            HttpSession session = request.getSession();
            Integer role = (Integer) session.getAttribute("role");
            Integer managerId = (Integer) session.getAttribute("userId");
            ArrayList<DeviceInRoom> devicesInRooms;
            if (role != null && role == 2 && managerId != null) { // Manager
                devicesInRooms = deviceInRoomDAO.searchDevicesInRoomsByManager(keyword.trim(), managerId);
            } else {
                devicesInRooms = deviceInRoomDAO.searchDevicesInRooms(keyword.trim());
            }
            request.setAttribute("devicesInRooms", devicesInRooms);
            request.setAttribute("keyword", keyword.trim());
            request.setAttribute("searchMode", true);

            request.getRequestDispatcher("/Deviceinroom/list.jsp").forward(request, response);

        } catch (Exception e) {
            handleError(request, response, "Lỗi khi tìm kiếm thiết bị: " + e.getMessage());
        }
    }

    private void showAddForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            // Lấy danh sách tất cả thiết bị để hiển thị trong dropdown
            List<Devices> allDevices = deviceDAO.getAllDevices();
            request.setAttribute("allDevices", allDevices);
            List<Rooms> allRooms = roomDAO.getAllRooms();
            request.setAttribute("rooms", allRooms);

            // Lấy roomId nếu có (để pre-select)
            String roomIdStr = request.getParameter("roomId");
            if (roomIdStr != null && !roomIdStr.isEmpty()) {
                try {
                    int roomId = Integer.parseInt(roomIdStr);
                    request.setAttribute("preselectedRoomId", roomId);
                } catch (NumberFormatException e) {
                    // Ignore invalid roomId
                }
            }

            request.getRequestDispatcher("/Deviceinroom/add.jsp").forward(request, response);

        } catch (Exception e) {
            handleError(request, response, "Lỗi khi tải form thêm thiết bị: " + e.getMessage());
        }
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            String roomIdStr = request.getParameter("roomId");
            String deviceIdStr = request.getParameter("deviceId");

            if (roomIdStr == null || roomIdStr.isEmpty()
                    || deviceIdStr == null || deviceIdStr.isEmpty()) {
                setErrorMessage(request, "Thông tin thiết bị không hợp lệ");
                response.sendRedirect("deviceinroom?action=list");
                return;
            }

            int roomId = Integer.parseInt(roomIdStr);
            int deviceId = Integer.parseInt(deviceIdStr);

            // Tìm thiết bị trong phòng
            ArrayList<DeviceInRoom> devicesInRoom = deviceInRoomDAO.getDevicesByRoomId(roomId);
            DeviceInRoom deviceInRoom = null;

            for (DeviceInRoom dir : devicesInRoom) {
                if (dir.getDeviceId() == deviceId) {
                    deviceInRoom = dir;
                    break;
                }
            }

            if (deviceInRoom == null) {
                setErrorMessage(request, "Không tìm thấy thiết bị trong phòng");
                response.sendRedirect("deviceinroom?action=list");
                return;
            }

            request.setAttribute("deviceInRoom", deviceInRoom);
            request.getRequestDispatcher("/views/deviceinroom/edit.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            setErrorMessage(request, "Thông tin thiết bị không hợp lệ");
            response.sendRedirect("deviceinroom?action=list");
        } catch (Exception e) {
            handleError(request, response, "Lỗi khi tải thông tin thiết bị: " + e.getMessage());
        }
    }

    private void viewDeviceInRoom(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            String roomIdStr = request.getParameter("roomId");
            String deviceIdStr = request.getParameter("deviceId");

            if (roomIdStr == null || roomIdStr.isEmpty()
                    || deviceIdStr == null || deviceIdStr.isEmpty()) {
                setErrorMessage(request, "Thông tin thiết bị không hợp lệ");
                response.sendRedirect("deviceinroom?action=list");
                return;
            }

            int roomId = Integer.parseInt(roomIdStr);
            int deviceId = Integer.parseInt(deviceIdStr);

            // Tìm thiết bị trong phòng
            ArrayList<DeviceInRoom> devicesInRoom = deviceInRoomDAO.getDevicesByRoomId(roomId);
            DeviceInRoom deviceInRoom = null;

            for (DeviceInRoom dir : devicesInRoom) {
                if (dir.getDeviceId() == deviceId) {
                    deviceInRoom = dir;
                    break;
                }
            }

            if (deviceInRoom == null) {
                setErrorMessage(request, "Không tìm thấy thiết bị trong phòng");
                response.sendRedirect("deviceinroom?action=list");
                return;
            }

            request.setAttribute("deviceInRoom", deviceInRoom);
            request.getRequestDispatcher("/views/deviceinroom/view.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            setErrorMessage(request, "Thông tin thiết bị không hợp lệ");
            response.sendRedirect("deviceinroom?action=list");
        } catch (Exception e) {
            handleError(request, response, "Lỗi khi tải thông tin thiết bị: " + e.getMessage());
        }
    }

    private void addDeviceToRoom(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            String roomIdStr = request.getParameter("roomId");
            String deviceIdStr = request.getParameter("deviceId");
            String status = request.getParameter("status");

            // Validation
            if (roomIdStr == null || roomIdStr.isEmpty()
                    || deviceIdStr == null || deviceIdStr.isEmpty()
                    || status == null || status.trim().isEmpty()) {

                setErrorMessage(request, "Vui lòng điền đầy đủ thông tin");
                response.sendRedirect("deviceinroom?action=add");
                return;
            }

            int roomId = Integer.parseInt(roomIdStr);
            int deviceId = Integer.parseInt(deviceIdStr);

            // Tạo đối tượng DeviceInRoom
            DeviceInRoom deviceInRoom = new DeviceInRoom();
            deviceInRoom.setRoomId(roomId);
            deviceInRoom.setDeviceId(deviceId);
            deviceInRoom.setStatus(status.trim());

            deviceInRoomDAO.addDeviceToRoom(deviceInRoom);

            setSuccessMessage(request, "Thêm thiết bị vào phòng thành công!");
            response.sendRedirect("deviceinroom?action=list");

        } catch (NumberFormatException e) {
            setErrorMessage(request, "Thông tin số không hợp lệ");
            response.sendRedirect("deviceinroom?action=add");
        } catch (IllegalArgumentException e) {
            setErrorMessage(request, e.getMessage());
            response.sendRedirect("deviceinroom?action=add");
        } catch (Exception e) {
            handleError(request, response, "Lỗi khi thêm thiết bị vào phòng: " + e.getMessage());
        }
    }

    private void updateDeviceInRoom(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            String roomIdStr = request.getParameter("roomId");
            String deviceIdStr = request.getParameter("deviceId");
            String quantityStr = request.getParameter("quantity");
            String status = request.getParameter("status");

            if (roomIdStr == null || roomIdStr.isEmpty()
                    || deviceIdStr == null || deviceIdStr.isEmpty()
                    || quantityStr == null || quantityStr.isEmpty()
                    || status == null || status.trim().isEmpty()) {

                setErrorMessage(request, "Vui lòng điền đầy đủ thông tin");
                response.sendRedirect("deviceinroom?action=list");
                return;
            }

            int roomId = Integer.parseInt(roomIdStr);
            int deviceId = Integer.parseInt(deviceIdStr);
            int quantity = Integer.parseInt(quantityStr);

            if (quantity <= 0) {
                setErrorMessage(request, "Số lượng phải lớn hơn 0");
                response.sendRedirect("deviceinroom?action=edit&roomId=" + roomId + "&deviceId=" + deviceId);
                return;
            }

            // Tạo đối tượng DeviceInRoom
            DeviceInRoom deviceInRoom = new DeviceInRoom();
            deviceInRoom.setRoomId(roomId);
            deviceInRoom.setDeviceId(deviceId);
            deviceInRoom.setQuantity(quantity);
            deviceInRoom.setStatus(status.trim());

            deviceInRoomDAO.updateDeviceInRoom(deviceInRoom);

            setSuccessMessage(request, "Cập nhật thiết bị trong phòng thành công!");
            response.sendRedirect("deviceinroom?action=list");

        } catch (NumberFormatException e) {
            setErrorMessage(request, "Thông tin số không hợp lệ");
            response.sendRedirect("deviceinroom?action=list");
        } catch (IllegalArgumentException e) {
            setErrorMessage(request, e.getMessage());
            response.sendRedirect("deviceinroom?action=list");
        } catch (Exception e) {
            handleError(request, response, "Lỗi khi cập nhật thiết bị trong phòng: " + e.getMessage());
        }
    }

    private void removeDeviceFromRoom(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            String roomIdStr = request.getParameter("roomId");
            String deviceIdStr = request.getParameter("deviceId");

            if (roomIdStr == null || roomIdStr.isEmpty()
                    || deviceIdStr == null || deviceIdStr.isEmpty()) {
                setErrorMessage(request, "Thông tin thiết bị không hợp lệ");
                response.sendRedirect("deviceinroom?action=list");
                return;
            }

            int roomId = Integer.parseInt(roomIdStr);
            int deviceId = Integer.parseInt(deviceIdStr);

            try {
                deviceInRoomDAO.deleteDeviceFromRoom(roomId, deviceId);
                setSuccessMessage(request, "Xóa thiết bị khỏi phòng thành công!");
            } catch (Exception e) {
                setErrorMessage(request, "Không thể xóa thiết bị khỏi phòng: " + e.getMessage());
            }

            response.sendRedirect("deviceinroom?action=list");

        } catch (NumberFormatException e) {
            setErrorMessage(request, "Thông tin thiết bị không hợp lệ");
            response.sendRedirect("deviceinroom?action=list");
        } catch (Exception e) {
            handleError(request, response, "Lỗi khi xóa thiết bị khỏi phòng: " + e.getMessage());
        }
    }

    // Utility methods for error handling and messaging
    private void handleError(HttpServletRequest request, HttpServletResponse response, String errorMessage)
            throws ServletException, IOException {

        setErrorMessage(request, errorMessage);
        request.getRequestDispatcher("/error.jsp").forward(request, response);
    }

    private void setErrorMessage(HttpServletRequest request, String message) {
        HttpSession session = request.getSession();
        session.setAttribute("errorMessage", message);
    }

    private void setSuccessMessage(HttpServletRequest request, String message) {
        HttpSession session = request.getSession();
        session.setAttribute("successMessage", message);
    }
}
