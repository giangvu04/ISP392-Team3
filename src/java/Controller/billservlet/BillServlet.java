/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controller.billservlet;

import Controller.billservlet.*;
import dal.DAOBill;
import model.Bill;
import java.io.IOException;
import java.io.PrintWriter;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Users;
import dal.DAOUser;

/**
 *
 * @author Admin
 */
@WebServlet(name = "BillServlet", urlPatterns = {"/BillServlet"})
public class BillServlet extends HttpServlet {

    private DAOBill daoBill;

    @Override
    public void init() throws ServletException {
        daoBill = new DAOBill();
    }

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        HttpSession session = request.getSession(false);
        Users user = (session != null) ? (Users) session.getAttribute("user") : null;

    if (user == null) {
        // Người dùng chưa đăng nhập → điều hướng về trang login
        response.sendRedirect("login.jsp");
        return;
    }
        String action = request.getParameter("action");
        if (action == null) {
            action = "list";
        }

        try {
            switch (action) {
                case "list":
                    listBills(request, response);
                    break;
                case "add":
                    addBill(request, response);
                    break;
                case "edit":
                    editBill(request, response);
                    break;
                case "update":
                    updateBill(request, response);
                    break;
                case "delete":
                    deleteBill(request, response);
                    break;
                case "search":
                    searchBills(request, response);
                    break;
                case "view":
                    viewBill(request, response);
                    break;
                case "updateStatus":
                    updateBillStatus(request, response);
                    break;
                default:
                    listBills(request, response);
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Có lỗi xảy ra: " + e.getMessage());
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }

    private void listBills(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            Users user = (Users) request.getSession().getAttribute("user");
            ArrayList<Bill> bills = daoBill.getAllBills(user);
            request.setAttribute("bills", bills);
            request.setAttribute("totalBills", daoBill.getTotalBills(user));
            request.setAttribute("totalRevenue", daoBill.getTotalRevenue(user));
            request.getRequestDispatcher("/Bill/list.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi khi lấy danh sách hóa đơn: " + e.getMessage());
            request.getRequestDispatcher("/error.jsp").forward(request, response);
        }
    }

    private void addBill(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (request.getMethod().equals("POST")) {
            try {
                // Lấy dữ liệu từ form
                String tenantRoom = request.getParameter("tenantRoom");
                String[] parts = tenantRoom != null ? tenantRoom.split(",") : new String[0];
                int tenantId = parts.length > 0 ? Integer.parseInt(parts[0]) : 0;
                int roomId = parts.length > 1 ? Integer.parseInt(parts[1]) : 0;

                double electricityCost = Double.parseDouble(request.getParameter("electricityCost"));
                double waterCost = Double.parseDouble(request.getParameter("waterCost"));
                double serviceCost = Double.parseDouble(request.getParameter("serviceCost"));
                String dueDate = request.getParameter("dueDate");
                String status = request.getParameter("status");
                double total = electricityCost + waterCost + serviceCost;

                // Lấy thông tin người thuê và phòng
                String tenantName = "";
                String roomNumber = "";
                ArrayList<Users> tenants = (ArrayList<Users>) request.getSession().getAttribute("tenants");
                if (tenants != null) {
                    for (Users u : tenants) {
                        if (u.getUserId() == tenantId && u.getRoomId() == roomId) {
                            tenantName = u.getFullName();
                            roomNumber = u.getRoomNumber();
                            break;
                        }
                    }
                }

                Bill bill = new Bill();
                bill.setTenantName(tenantName);
                bill.setRoomNumber(roomNumber);
                bill.setElectricityCost(electricityCost);
                bill.setWaterCost(waterCost);
                bill.setServiceCost(serviceCost);
                bill.setTotal(total);
                bill.setDueDate(dueDate);
                bill.setStatus(status);
                bill.setCreatedDate(new SimpleDateFormat("yyyy-MM-dd").format(new Date()));

                // Thêm vào database (cần sửa DAOBill.addBill để nhận đủ tenantId, roomId)
                daoBill.addBill(bill, tenantId, roomId);

                request.setAttribute("success", "Thêm hóa đơn thành công!");
                response.sendRedirect("listbills");
            } catch (Exception e) {
                e.printStackTrace();
                request.setAttribute("error", "Lỗi khi thêm hóa đơn: " + e.getMessage());
                request.getRequestDispatcher("/Bill/add.jsp").forward(request, response);
            }
        } else {
            // Lấy user hiện tại (manager)
            Users user = (Users) request.getSession().getAttribute("user");
            ArrayList<Users> tenants = new ArrayList<>();
            if (user != null && user.getRoleId() == 2) { // 2 = manager
                tenants = dal.DAOUser.INSTANCE.getTenantsByManager(user.getUserId());
            }
            request.setAttribute("tenants", tenants);
            request.getSession().setAttribute("tenants", tenants);
            request.getRequestDispatcher("/Bill/add.jsp").forward(request, response);
        }
    }

    private void editBill(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            Bill bill = daoBill.getBillById(id);
            if (bill != null) {
                request.setAttribute("bill", bill);
                request.getRequestDispatcher("/Bill/edit.jsp").forward(request, response);
            } else {
                request.setAttribute("error", "Không tìm thấy hóa đơn!");
                response.sendRedirect("listbills");
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi khi lấy thông tin hóa đơn: " + e.getMessage());
            response.sendRedirect("listbills");
        }
    }

    private void updateBill(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            String tenantName = request.getParameter("tenantName");
            String roomNumber = request.getParameter("roomNumber");
            double electricityCost = Double.parseDouble(request.getParameter("electricityCost"));
            double waterCost = Double.parseDouble(request.getParameter("waterCost"));
            double serviceCost = Double.parseDouble(request.getParameter("serviceCost"));
            String dueDate = request.getParameter("dueDate");
            String status = request.getParameter("status");

            // Tính tổng
            double total = electricityCost + waterCost + serviceCost;

            // Tạo đối tượng Bill
            Bill bill = new Bill();
            bill.setId(id);
            bill.setTenantName(tenantName);
            bill.setRoomNumber(roomNumber);
            bill.setElectricityCost(electricityCost);
            bill.setWaterCost(waterCost);
            bill.setServiceCost(serviceCost);
            bill.setTotal(total);
            bill.setDueDate(dueDate);
            bill.setStatus(status);

            // Cập nhật vào database
            daoBill.updateBill(bill);

            request.setAttribute("success", "Cập nhật hóa đơn thành công!");
            response.sendRedirect("listbills");
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi khi cập nhật hóa đơn: " + e.getMessage());
            response.sendRedirect("listbills");
        }
    }

    private void deleteBill(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            daoBill.deleteBill(id);
            request.setAttribute("success", "Xóa hóa đơn thành công!");
            response.sendRedirect("listbills");
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi khi xóa hóa đơn: " + e.getMessage());
            response.sendRedirect("listbills");
        }
    }

    private void searchBills(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String searchType = request.getParameter("searchType");
            String searchValue = request.getParameter("searchValue");
            ArrayList<Bill> bills = new ArrayList<>();
            Users user = (Users) request.getSession().getAttribute("user");
            if (searchType != null && searchValue != null && !searchValue.trim().isEmpty()) {
                switch (searchType) {
                    case "tenantName":
                        bills = daoBill.searchBillsByTenantName(searchValue);
                        break;
                    case "roomNumber":
                        bills = daoBill.searchBillsByRoomNumber(searchValue);
                        break;
                    case "status":
                        bills = daoBill.getBillsByStatus(user,searchValue);
                        break;
                    default:
                        bills = daoBill.getAllBills(user);
                        break;
                }
            } else {
                bills = daoBill.getAllBills(user);
            }

            request.setAttribute("bills", bills);
            request.setAttribute("searchType", searchType);
            request.setAttribute("searchValue", searchValue);
            request.getRequestDispatcher("/Bill/list.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi khi tìm kiếm hóa đơn: " + e.getMessage());
            request.getRequestDispatcher("/Bill/list.jsp").forward(request, response);
        }
    }

    private void viewBill(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            Bill bill = daoBill.getBillById(id);
            if (bill != null) {
                request.setAttribute("bill", bill);
                request.getRequestDispatcher("/Bill/view.jsp").forward(request, response);
            } else {
                request.setAttribute("error", "Không tìm thấy hóa đơn!");
                response.sendRedirect("listbills");
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi khi xem thông tin hóa đơn: " + e.getMessage());
            response.sendRedirect("listbills");
        }
    }

    private void updateBillStatus(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            String status = request.getParameter("status");
            daoBill.updateBillStatus(id, status);
            request.setAttribute("success", "Cập nhật trạng thái hóa đơn thành công!");
            response.sendRedirect("listbills");
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi khi cập nhật trạng thái hóa đơn: " + e.getMessage());
            response.sendRedirect("listbills");
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Bill Servlet for managing bills";
    }// </editor-fold>

}
