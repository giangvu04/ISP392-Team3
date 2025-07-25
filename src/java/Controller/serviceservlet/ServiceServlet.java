/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package Controller.serviceservlet;

import dal.DAORentalArea;
import dal.DAOServices;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;
import model.RentalArea;
import model.Services;

/**
 *
 * @author ADMIN
 */
@WebServlet(name="ServiceServlet", urlPatterns={"/listservices"})
public class ServiceServlet extends HttpServlet {

    private final DAOServices serviceDAO = DAOServices.INSTANCE;
    private static final int SERVICES_PER_PAGE = 10;

    private final DAORentalArea renDAO = DAORentalArea.INSTANCE;
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        if (action == null) action = "list";

        try {
            switch (action) {
                case "list":
                    listServices(request, response);
                    break;
                case "search":
                    searchServices(request, response);
                    break;
                case "add":
                    showAddForm(request, response);
                    break;
                case "edit":
                    showEditForm(request, response);
                    break;
                case "view":
                    viewService(request, response);
                    break;
                default:
                    listServices(request, response);
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
                    addService(request, response);
                    break;
                case "update":
                    updateService(request, response);
                    break;
                
                default:
                    response.sendRedirect("listservices?action=list");
                    break;
            }
        } catch (Exception e) {
            handleError(request, response, "Lỗi xử lý yêu cầu: " + e.getMessage());
        }
    }

    private void listServices(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int page = 1;
        String pageStr = request.getParameter("page");
        if (pageStr != null) {
            try {
                page = Integer.parseInt(pageStr);
                if (page < 1) page = 1;
            } catch (NumberFormatException ignored) {}
        }
        // Lấy user từ session để xác định role
        model.Users user = (model.Users) request.getSession().getAttribute("user");
        Integer managerId = null;
        if (user != null && user.getRoleId() == 2) {
            managerId = user.getUserId();
            List<RentalArea> rentalAreaId = renDAO.getAllRent(managerId);
            request.setAttribute("retalArea", rentalAreaId);
        }
        
        
        List<Services> services = serviceDAO.getAllServicesByManager(managerId);
        int totalServices = serviceDAO.getTotalServicesByManager(managerId);
        int totalPages = (int) Math.ceil((double) totalServices / SERVICES_PER_PAGE);
        // Thống kê dịch vụ theo manager
       
        int managerServiceCount = managerId != null ? serviceDAO.getServiceCountByManager(managerId) : totalServices;
        request.setAttribute("services", services);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("servicesPerPage", SERVICES_PER_PAGE);
        request.setAttribute("totalServices", totalServices);
        request.setAttribute("managerServiceCount", managerServiceCount);
        request.getRequestDispatcher("/Service/list.jsp").forward(request, response);
    }

    private void searchServices(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String keyword = request.getParameter("keyword");
        if (keyword == null || keyword.trim().isEmpty()) {
            response.sendRedirect("listservices?action=list");
            return;
        }
        // Lấy user từ session để xác định role
        model.Users user = (model.Users) request.getSession().getAttribute("user");
        Integer managerId = null;
        if (user != null && user.getRoleId() == 2) {
            managerId = user.getUserId();
        }
        List<Services> services = serviceDAO.searchServicesByName(keyword.trim(), managerId);
        request.setAttribute("services", services);
        request.setAttribute("keyword", keyword.trim());
        request.setAttribute("searchMode", true);
        request.getRequestDispatcher("/Service/list.jsp").forward(request, response);
    }

    private void showAddForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        model.Users user = (model.Users) request.getSession().getAttribute("user");
        if (user != null && user.getRoleId() == 2) {
            int managerId = user.getUserId();
            List<RentalArea> rentalAreaId = renDAO.getAllRent(managerId);
            request.setAttribute("retalArea", rentalAreaId);
        }
        request.getRequestDispatcher("/Service/add.jsp").forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int serviceId = Integer.parseInt(request.getParameter("id"));
            Services service = serviceDAO.getServiceById(serviceId);
            if (service == null) {
                setErrorMessage(request, "Không tìm thấy dịch vụ");
                response.sendRedirect("listservices?action=list");
                return;
            }
            request.setAttribute("service", service);
            request.getRequestDispatcher("/Service/edit.jsp").forward(request, response);
        } catch (Exception e) {
            handleError(request, response, "Lỗi khi hiển thị biểu mẫu sửa: " + e.getMessage());
        }
    }

    private void viewService(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int serviceId = Integer.parseInt(request.getParameter("id"));
            Services service = serviceDAO.getServiceById(serviceId);
            if (service == null) {
                setErrorMessage(request, "Không tìm thấy dịch vụ");
                response.sendRedirect("listservices?action=list");
                return;
            }
            request.setAttribute("service", service);
            request.getRequestDispatcher("/Service/view.jsp").forward(request, response);
        } catch (Exception e) {
            handleError(request, response, "Lỗi khi xem thông tin dịch vụ: " + e.getMessage());
        }
    }

    private void addService(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int rentalAreaId = Integer.parseInt(request.getParameter("addRentalArea"));
            String name = request.getParameter("serviceName");
            double unitPrice = Double.parseDouble(request.getParameter("unitPrice"));
            String unit = request.getParameter("unitName");
            int calcMethod = Integer.parseInt(request.getParameter("calculationMethod"));

            Services service = new Services(0, rentalAreaId, name, unitPrice, unit, calcMethod);
            int newId = serviceDAO.addService(service);

            if (newId > 0) {
                setSuccessMessage(request, "Thêm dịch vụ thành công!");
                response.sendRedirect("listservices?action=list");
            } else {
                setErrorMessage(request, "Thêm dịch vụ thất bại!");
                request.getRequestDispatcher("/Service/add.jsp").forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            handleError(request, response, "Lỗi khi thêm dịch vụ: " + e.getMessage());
        }
    }

    private void updateService(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int id = Integer.parseInt(request.getParameter("serviceId"));
            int rentalAreaId = Integer.parseInt(request.getParameter("rentalAreaId"));
            String name = request.getParameter("serviceName");
            double price = Double.parseDouble(request.getParameter("unitPrice"));
            String unit = request.getParameter("unitName");
            int method = Integer.parseInt(request.getParameter("calculationMethod"));

            Services s = new Services(id, rentalAreaId, name, price, unit, method);
            serviceDAO.updateService(s);

            setSuccessMessage(request, "Cập nhật thành công!");
            response.sendRedirect("listservices?action=list");

        } catch (Exception e) {
            handleError(request, response, "Lỗi khi cập nhật dịch vụ: " + e.getMessage());
        }
    }


    // Utility
    private void setSuccessMessage(HttpServletRequest request, String msg) {
        request.getSession().setAttribute("successMessage", msg);
    }

    private void setErrorMessage(HttpServletRequest request, String msg) {
        request.getSession().setAttribute("errorMessage", msg);
    }

    private void handleError(HttpServletRequest request, HttpServletResponse response, String msg)
            throws ServletException, IOException {
        request.setAttribute("errorMessage", msg);
        request.getRequestDispatcher("/views/error.jsp").forward(request, response);
    }
}