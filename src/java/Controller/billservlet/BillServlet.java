/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controller.billservlet;

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
                case "getRoomsByArea":
                    getRoomsByArea(request, response);
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
        if ("POST".equalsIgnoreCase(request.getMethod())) {
            try {
                String billType = request.getParameter("billType");
                String roomCostStr = request.getParameter("roomCost");
                String electricityStr = request.getParameter("electricityCost");
                String waterStr = request.getParameter("waterCost");
                String serviceStr = request.getParameter("serviceCost");
                String otherServiceStr = request.getParameter("otherServiceCost");
                String dueDate = request.getParameter("dueDate");
                String status = request.getParameter("status");
                String note = request.getParameter("note");

                double roomCost = roomCostStr != null && !roomCostStr.isEmpty() ? Double.parseDouble(roomCostStr) : 0.0;
                double electricityCost = electricityStr != null && !electricityStr.isEmpty() ? Double.parseDouble(electricityStr) : 0.0;
                double waterCost = waterStr != null && !waterStr.isEmpty() ? Double.parseDouble(waterStr) : 0.0;
                double serviceCost = serviceStr != null && !serviceStr.isEmpty() ? Double.parseDouble(serviceStr) : 0.0;
                double otherServiceCost = otherServiceStr != null && !otherServiceStr.isEmpty() ? Double.parseDouble(otherServiceStr) : 0.0;

                // Nếu là chi, chỉ lấy phí dịch vụ khác và chuyển thành số âm
                double total;
                if ("Chi".equalsIgnoreCase(billType)) {
                    otherServiceCost = -Math.abs(otherServiceCost);
                    roomCost = 0.0;
                    electricityCost = 0.0;
                    waterCost = 0.0;
                    serviceCost = 0.0;
                    total = otherServiceCost;
                } else {
                    total = roomCost + electricityCost + waterCost + serviceCost + otherServiceCost;
                }

                Bill bill = new Bill();
                bill.setRoomCost(roomCost);
                bill.setElectricityCost(electricityCost);
                bill.setWaterCost(waterCost);
                bill.setServiceCost(serviceCost);
                bill.setOtherServiceCost(otherServiceCost);
                bill.setTotal(total);
                bill.setDueDate(dueDate);
                bill.setStatus(status);
                bill.setCreatedDate(new SimpleDateFormat("yyyy-MM-dd").format(new Date()));
                bill.setNote(note);

                int tenantId = 0;
                int roomId = 0;
                String tenantName = "";
                String roomNumber = "";

                // Lấy roomId và tenantId từ select (format: "roomId,tenantId,tenantEmail")
                String roomSelection = request.getParameter("roomSelection");

                String[] parts = roomSelection != null ? roomSelection.split("\\|") : new String[0];

                System.out.println("roomSelection: " + roomSelection);
                System.out.println("parts length: " + parts.length);
                for (int i = 0; i < parts.length; i++) {
                    System.out.println("parts[" + i + "]: " + parts[i]);
                }
                if (parts.length >= 1) {
                    roomId = Integer.parseInt(parts[0]);
                }
                if (parts.length >= 2 && !parts[1].isEmpty() && !"null".equals(parts[1])) {
                    tenantId = Integer.parseInt(parts[1]);
                }
                if (parts.length >= 3) {
                    bill.setEmailTelnant(parts[2]);
                }

                // Lấy thông tin phòng và tenant từ roomSelection
                dal.DAORooms roomDao = new dal.DAORooms();
                model.Rooms room = roomDao.getRoomById(roomId);
                if (room != null) {
                    roomNumber = room.getRoomNumber();
                }

                if (tenantId > 0) {
                    dal.DAOUser userDao = new dal.DAOUser();
                    model.Users tenant = userDao.getUserByID(tenantId);
                    if (tenant != null) {
                        tenantName = tenant.getFullName();
                    }
                } else {
                    // Nếu không có tenant, dùng thông tin manager cho hóa đơn chi
                    Users userSession = (Users) request.getSession().getAttribute("user");
                    if (userSession != null && "Chi".equalsIgnoreCase(billType)) {
                        tenantId = userSession.getUserId();
                        tenantName = userSession.getFullName();
                    }
                }

                bill.setTenantName(tenantName);
                bill.setRoomNumber(roomNumber);

                // Thêm vào database
                daoBill.addBill(bill, tenantId, roomId);

                // Đặt message vào session để sau redirect vẫn hiển thị
                request.getSession().setAttribute("success", "Thêm hóa đơn thành công!");
                response.sendRedirect("listbills");
            } catch (Exception e) {
                e.printStackTrace();
                request.setAttribute("error", "Lỗi khi thêm hóa đơn: " + e.getMessage());
                loadBillFormData(request);
                request.getRequestDispatcher("/Bill/add.jsp").forward(request, response);
            }
        } else {
            // GET: hiển thị form
            loadBillFormData(request);
            request.getRequestDispatcher("/Bill/add.jsp").forward(request, response);
        }
    }

    private void loadBillFormData(HttpServletRequest request) {
        Users user = (Users) request.getSession().getAttribute("user");
        System.out.println("loadBillFormData - User: " + (user != null ? "exists, roleId=" + user.getRoleId() : "null"));

        if (user != null) {
            // Load for both Manager (roleId=2) and Admin (roleId=1) for testing
            dal.DAORentalArea rentalAreaDao = new dal.DAORentalArea();
            java.util.List<model.RentalArea> rentalAreas = null;

            if (user.getRoleId() == 2) {
                rentalAreas = rentalAreaDao.getRentalAreasByManager(user.getUserId());
            } else if (user.getRoleId() == 1) {
                // For admin, get all rental areas
                rentalAreas = rentalAreaDao.getAllRentalAreas();
            }

            System.out.println("Found " + (rentalAreas != null ? rentalAreas.size() : 0) + " rental areas");

            if (rentalAreas != null) {
                request.setAttribute("rentalAreas", rentalAreas);
                for (model.RentalArea area : rentalAreas) {
                    System.out.println("RentalArea: " + area.getRentalAreaId() + " - " + area.getName());
                }
            }
        }
    }

    private void getRoomsByArea(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int areaId = Integer.parseInt(request.getParameter("areaId"));
            Users user = (Users) request.getSession().getAttribute("user");

            // Debug logging
            System.out.println("getRoomsByArea called with areaId: " + areaId);
            System.out.println("User: " + (user != null ? "exists, roleId=" + user.getRoleId() : "null"));

            // Allow all authenticated users for now (remove role restriction for debugging)
            if (user != null) {
                dal.DAORooms roomDao = new dal.DAORooms();
                java.util.List<model.Rooms> rooms = roomDao.getRoomsWithTenantsByArea(areaId);

                System.out.println("Found " + rooms.size() + " rooms");

                // Trả về JSONR
                response.setContentType("application/json;charset=UTF-8");
                response.setCharacterEncoding("UTF-8");

                StringBuilder json = new StringBuilder();
                json.append("[");
                for (int i = 0; i < rooms.size(); i++) {
                    model.Rooms room = rooms.get(i);
                    if (i > 0) {
                        json.append(",");
                    }
                    json.append("{");
                    json.append("\"roomId\":").append(room.getRoomId()).append(",");
                    json.append("\"roomNumber\":\"").append(room.getRoomNumber()).append("\",");
                    json.append("\"tenantId\":").append(room.getTenantId() != null ? room.getTenantId() : "null").append(",");
                    json.append("\"tenantName\":\"").append(room.getTenantName() != null ? room.getTenantName() : "").append("\",");
                    json.append("\"tenantEmail\":\"").append(room.getTenantEmail() != null ? room.getTenantEmail() : "").append("\"");
                    json.append("}");
                }
                json.append("]");

                String jsonResult = json.toString();
                System.out.println("JSON response: " + jsonResult);
                response.getWriter().write(jsonResult);
            } else {
                System.out.println("User not authenticated");
                response.getWriter().write("[]");
            }
        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("Error in getRoomsByArea: " + e.getMessage());
            response.getWriter().write("[]");
        }
    }

    private void editBill(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            Bill bill = daoBill.getBillById(id);
            if (bill != null) {
                request.setAttribute("bill", bill);

                // Load rental areas for reference
                loadBillFormData(request);

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

            String roomCostStr = request.getParameter("roomCost");
            String electricityStr = request.getParameter("electricityCost");
            String waterStr = request.getParameter("waterCost");
            String serviceStr = request.getParameter("serviceCost");
            String otherServiceStr = request.getParameter("otherServiceCost");

            double roomCost = roomCostStr != null && !roomCostStr.isEmpty() ? Double.parseDouble(roomCostStr) : 0.0;
            double electricityCost = electricityStr != null && !electricityStr.isEmpty() ? Double.parseDouble(electricityStr) : 0.0;
            double waterCost = waterStr != null && !waterStr.isEmpty() ? Double.parseDouble(waterStr) : 0.0;
            double serviceCost = serviceStr != null && !serviceStr.isEmpty() ? Double.parseDouble(serviceStr) : 0.0;
            double otherServiceCost = otherServiceStr != null && !otherServiceStr.isEmpty() ? Double.parseDouble(otherServiceStr) : 0.0;

            String dueDate = request.getParameter("dueDate");
            String status = request.getParameter("status");

            // Tính tổng
            double total = roomCost + electricityCost + waterCost + serviceCost + otherServiceCost;

            // Tạo đối tượng Bill
            Bill bill = new Bill();
            bill.setId(id);
            bill.setTenantName(tenantName);
            bill.setRoomNumber(roomNumber);
            bill.setRoomCost(roomCost);
            bill.setElectricityCost(electricityCost);
            bill.setWaterCost(waterCost);
            bill.setServiceCost(serviceCost);
            bill.setOtherServiceCost(otherServiceCost);
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
                        bills = daoBill.getBillsByStatus(user, searchValue);
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
