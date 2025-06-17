/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package Controller.deviceservlet;

import dal.DAODevices;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.List;
import model.Devices;

/**
 *
 * @author ADMIN
 */
@WebServlet(name="DeviceServlet", urlPatterns={"/listdevices"})
public class DeviceServlet extends HttpServlet {
    
    private final DAODevices deviceDAO = DAODevices.INSTANCE;
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
                    listDevices(request, response);
                    break;
                case "search":
                    searchDevices(request, response);
                    break;
                case "add":
                    showAddForm(request, response);
                    break;
                case "edit":
                    showEditForm(request, response);
                    break;
                case "delete":
                    deleteDevice(request, response);
                    break;
                case "view":
                    viewDevice(request, response);
                    break;
                default:
                    listDevices(request, response);
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
                    addDevice(request, response);
                    break;
                case "update":
                    updateDevice(request, response);
                    break;
                default:
                    response.sendRedirect("device?action=list");
                    break;
            }
        } catch (Exception e) {
            handleError(request, response, "Lỗi xử lý yêu cầu: " + e.getMessage());
        }
    }
    
    private void listDevices(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            // Xử lý phân trang
            int page = 1;
            String pageStr = request.getParameter("page");
            if (pageStr != null && !pageStr.isEmpty()) {
                try {
                    page = Integer.parseInt(pageStr);
                    if (page < 1) page = 1;
                } catch (NumberFormatException e) {
                    page = 1;
                }
            }
            
            // Lấy danh sách thiết bị theo trang
            List<Devices> devices = deviceDAO.getDevicesByPage(page, DEVICES_PER_PAGE);
            int totalDevices = deviceDAO.getTotalDevices();
            int totalPages = (int) Math.ceil((double) totalDevices / DEVICES_PER_PAGE);
            
            // Set attributes
            request.setAttribute("devices", devices);
            request.setAttribute("currentPage", page);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("totalDevices", totalDevices);
            request.setAttribute("devicesPerPage", DEVICES_PER_PAGE);
            
            // Forward đến JSP
            request.getRequestDispatcher("/Device/list.jsp").forward(request, response);
            
        } catch (Exception e) {
            handleError(request, response, "Lỗi khi tải danh sách thiết bị: " + e.getMessage());
        }
    }
    
    private void searchDevices(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            String keyword = request.getParameter("keyword");
            if (keyword == null || keyword.trim().isEmpty()) {
                response.sendRedirect("device?action=list");
                return;
            }
            
            List<Devices> devices = deviceDAO.searchDevicesByName(keyword.trim());
            
            request.setAttribute("devices", devices);
            request.setAttribute("keyword", keyword.trim());
            request.setAttribute("searchMode", true);
            
            request.getRequestDispatcher("/Device/list.jsp").forward(request, response);
            
        } catch (Exception e) {
            handleError(request, response, "Lỗi khi tìm kiếm thiết bị: " + e.getMessage());
        }
    }
    
    private void showAddForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.getRequestDispatcher("/views/device/add.jsp").forward(request, response);
    }
    
    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            String deviceIdStr = request.getParameter("id");
            if (deviceIdStr == null || deviceIdStr.isEmpty()) {
                setErrorMessage(request, "ID thiết bị không hợp lệ");
                response.sendRedirect("listdevices?action=list");
                return;
            }
            
            int deviceId = Integer.parseInt(deviceIdStr);
            Devices device = deviceDAO.getDeviceById(deviceId);
            
            if (device == null) {
                setErrorMessage(request, "Không tìm thấy thiết bị với ID: " + deviceId);
                response.sendRedirect("listdevices?action=list");
                return;
            }
            
            request.setAttribute("device", device);
            request.getRequestDispatcher("/Device/edit.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            setErrorMessage(request, "ID thiết bị không hợp lệ");
            response.sendRedirect("listdevices?action=list");
        } catch (Exception e) {
            handleError(request, response, "Lỗi khi tải thông tin thiết bị: " + e.getMessage());
        }
    }
    
    private void viewDevice(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            String deviceIdStr = request.getParameter("id");
            if (deviceIdStr == null || deviceIdStr.isEmpty()) {
                setErrorMessage(request, "ID thiết bị không hợp lệ");
                response.sendRedirect("device?action=list");
                return;
            }
            
            int deviceId = Integer.parseInt(deviceIdStr);
            Devices device = deviceDAO.getDeviceById(deviceId);
            
            if (device == null) {
                setErrorMessage(request, "Không tìm thấy thiết bị với ID: " + deviceId);
                response.sendRedirect("device?action=list");
                return;
            }
            
            request.setAttribute("device", device);
            request.getRequestDispatcher("/Device/view.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            setErrorMessage(request, "ID thiết bị không hợp lệ");
            response.sendRedirect("device?action=list");
        } catch (Exception e) {
            handleError(request, response, "Lỗi khi tải thông tin thiết bị: " + e.getMessage());
        }
    }
    
    private void addDevice(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            String deviceName = request.getParameter("deviceName");
            
            // Validation
            if (deviceName == null || deviceName.trim().isEmpty()) {
                setErrorMessage(request, "Tên thiết bị không được để trống");
                request.getRequestDispatcher("/views/device/add.jsp").forward(request, response);
                return;
            }
            
            // Kiểm tra tên thiết bị đã tồn tại
            if (deviceDAO.isDeviceNameExists(deviceName.trim(), 0)) {
                setErrorMessage(request, "Tên thiết bị đã tồn tại");
                request.setAttribute("deviceName", deviceName);
                request.getRequestDispatcher("/views/device/add.jsp").forward(request, response);
                return;
            }
            
            // Tạo thiết bị mới
            Devices device = new Devices();
            device.setDeviceName(deviceName.trim());
            
            // Lấy userId từ session (giả sử đã login)
            HttpSession session = request.getSession();
            Integer userId = (Integer) session.getAttribute("userId");
            if (userId == null) userId = 1; // Default user nếu chưa login
            
            int newDeviceId = deviceDAO.addDevice(device, userId);
            
            if (newDeviceId > 0) {
                setSuccessMessage(request, "Thêm thiết bị thành công!");
                response.sendRedirect("device?action=list");
            } else {
                setErrorMessage(request, "Lỗi khi thêm thiết bị");
                request.getRequestDispatcher("/views/device/add.jsp").forward(request, response);
            }
            
        } catch (IllegalArgumentException e) {
            setErrorMessage(request, e.getMessage());
            request.setAttribute("deviceName", request.getParameter("deviceName"));
            request.getRequestDispatcher("/views/device/add.jsp").forward(request, response);
        } catch (Exception e) {
            handleError(request, response, "Lỗi khi thêm thiết bị: " + e.getMessage());
        }
    }
    
    private void updateDevice(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            String deviceIdStr = request.getParameter("deviceId");
            String deviceName = request.getParameter("deviceName");
            
            if (deviceIdStr == null || deviceIdStr.isEmpty()) {
                setErrorMessage(request, "ID thiết bị không hợp lệ");
                response.sendRedirect("listdevices?action=list");
                return;
            }
            
            int deviceId = Integer.parseInt(deviceIdStr);
            
            // Validation
            if (deviceName == null || deviceName.trim().isEmpty()) {
                setErrorMessage(request, "Tên thiết bị không được để trống");
                response.sendRedirect("listdevices?action=edit&id=" + deviceId);
                return;
            }
            
            // Kiểm tra tên thiết bị đã tồn tại (trừ thiết bị hiện tại)
            if (deviceDAO.isDeviceNameExists(deviceName.trim(), deviceId)) {
                setErrorMessage(request, "Tên thiết bị đã tồn tại");
                response.sendRedirect("listdevices?action=edit&id=" + deviceId);
                return;
            }
            
            // Cập nhật thiết bị
            Devices device = new Devices();
            device.setDeviceId(deviceId);
            device.setDeviceName(deviceName.trim());
            
            deviceDAO.updateDevice(device);
            
            setSuccessMessage(request, "Cập nhật thiết bị thành công!");
            response.sendRedirect("listdevices?action=list");
            
        } catch (NumberFormatException e) {
            setErrorMessage(request, "ID thiết bị không hợp lệ");
            response.sendRedirect("listdevices?action=list");
        } catch (IllegalArgumentException e) {
            setErrorMessage(request, e.getMessage());
            String deviceIdStr = request.getParameter("deviceId");
            response.sendRedirect("listdevices?action=edit&id=" + deviceIdStr);
        } catch (Exception e) {
            handleError(request, response, "Lỗi khi cập nhật thiết bị: " + e.getMessage());
        }
    }
    
    private void deleteDevice(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            String deviceIdStr = request.getParameter("id");
            if (deviceIdStr == null || deviceIdStr.isEmpty()) {
                setErrorMessage(request, "ID thiết bị không hợp lệ");
                response.sendRedirect("listdevices?action=list");
                return;
            }
            
            int deviceId = Integer.parseInt(deviceIdStr);
            
            // Lấy userId từ session
            HttpSession session = request.getSession();
            Integer userId = (Integer) session.getAttribute("userId");
            if (userId == null) userId = 1; // Default user
            
            deviceDAO.deleteDevice(deviceId, userId);
            
            setSuccessMessage(request, "Xóa thiết bị thành công!");
            response.sendRedirect("listdevices?action=list");
            
        } catch (NumberFormatException e) {
            setErrorMessage(request, "ID thiết bị không hợp lệ");
            response.sendRedirect("listdevices?action=list");
        } catch (RuntimeException e) {
            setErrorMessage(request, e.getMessage());
            response.sendRedirect("listdevices?action=list");
        } catch (Exception e) {
            handleError(request, response, "Lỗi khi xóa thiết bị: " + e.getMessage());
        }
    }
    
    // Utility methods
    private void setSuccessMessage(HttpServletRequest request, String message) {
        HttpSession session = request.getSession();
        session.setAttribute("successMessage", message);
    }
    
    private void setErrorMessage(HttpServletRequest request, String message) {
        HttpSession session = request.getSession();
        session.setAttribute("errorMessage", message);
    }
    
    private void handleError(HttpServletRequest request, HttpServletResponse response, String errorMessage)
            throws ServletException, IOException {
        request.setAttribute("errorMessage", errorMessage);
        request.getRequestDispatcher("/views/error.jsp").forward(request, response);
    }
}