/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package Controller.contractservlet;

import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import dal.DAOContract;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.util.logging.Level;
import java.util.logging.Logger;
import java.util.ArrayList;
import java.util.Comparator;
import dal.DAOContract;
import model.Contracts;
import model.Users;

/**
 *
 * @author ADMIN
 */

public class ListContractsServlet extends HttpServlet {
    
    /** 
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code> methods.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet ListContractsServlet</title>");  
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet ListContractsServlet at " + request.getContextPath () + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
        
    } 

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /** 
     * Handles the HTTP <code>GET</code> method.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        DAOContract dao = DAOContract.INSTANCE;
        HttpSession session = request.getSession();
        request.setAttribute("message", "");

        Users user = (Users) session.getAttribute("user");
        
        if (user != null) {
            request.setAttribute("user", user);
            
            // Lấy trang hiện tại từ tham số URL, mặc định là 1
            int currentPage = Integer.parseInt(request.getParameter("page") != null ? request.getParameter("page") : "1");
            int contractsPerPage = 5; // Số hợp đồng trên mỗi trang
            String sortBy = request.getParameter("sortBy");

            // Lấy hợp đồng dựa theo vai trò người dùng
            ArrayList<Contracts> contracts;
            int totalContracts;
            
            if(user.getRoleid() == 1) {
                // Admin: xem tất cả hợp đồng
                contracts = dao.getContractsByPage(currentPage, contractsPerPage);
                totalContracts = dao.getTotalContracts();
            } else if(user.getRoleid() == 2) {
                // Manager: xem hợp đồng của các phòng mình quản lý
                contracts = dao.getContractsByManagerPage(user.getID(), currentPage, contractsPerPage);
                totalContracts = dao.getTotalContractsByManager(user.getID());
            } else {
                // Tenant: chỉ xem hợp đồng của chính mình
                contracts = dao.getContractsByTenantPage(user.getID(), currentPage, contractsPerPage);
                totalContracts = dao.getTotalContractsByTenant(user.getID());
            }
            
            int totalPages = (int) Math.ceil((double) totalContracts / contractsPerPage);
            
            // Xử lý sắp xếp
            if (sortBy != null) {
                switch (sortBy) {
                    case "start_date_asc":
                        contracts.sort(Comparator.comparing(Contracts::getStartDate));
                        break;
                    case "start_date_desc":
                        contracts.sort(Comparator.comparing(Contracts::getStartDate).reversed());
                        break;
                    case "end_date_asc":
                        contracts.sort(Comparator.comparing(Contracts::getEndDate));
                        break;
                    case "end_date_desc":
                        contracts.sort(Comparator.comparing(Contracts::getEndDate).reversed());
                        break;
                    case "price_asc":
                        contracts.sort(Comparator.comparingInt(Contracts::getDealPrice));
                        break;
                    case "price_desc":
                        contracts.sort(Comparator.comparingInt(Contracts::getDealPrice).reversed());
                        break;
                    case "room_asc":
                        contracts.sort(Comparator.comparingInt(Contracts::getRoomID));
                        break;
                    case "room_desc":
                        contracts.sort(Comparator.comparingInt(Contracts::getRoomID).reversed());
                        break;
                }
            }
            
            // Set attributes for JSP
            request.setAttribute("contracts", contracts);
            request.setAttribute("currentPage", currentPage);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("sortBy", sortBy);

            // Chuyển đến trang dựa trên vai trò người dùng
            if (user.getRoleid() == 1) {
                request.getRequestDispatcher("ContractsManager/ListContractsForAdmin.jsp").forward(request, response);
            } else if (user.getRoleid() == 2) {
                request.getRequestDispatcher("ContractsManager/ListContractsForManager.jsp").forward(request, response);
            } else if (user.getRoleid() == 3) {
                request.getRequestDispatcher("ContractsManager/ListContractsForTenant.jsp").forward(request, response);
            } else {
                response.sendError(HttpServletResponse.SC_FORBIDDEN, "Không có quyền truy cập.");
            }
        } else {
            response.sendRedirect("login");
        }
    } 

    /** 
     * Handles the HTTP <code>POST</code> method.
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        String information = request.getParameter("information");

        DAOContract dao = DAOContract.INSTANCE;
        HttpSession session = request.getSession();
        Users user = (Users) session.getAttribute("user");

        if (user != null) {
            request.setAttribute("user", user);

            ArrayList<Contracts> contracts;
            try {
                // Tìm kiếm hợp đồng dựa theo vai trò
                //if(user.getRoleid() == 1) {
                    // Admin: tìm kiếm tất cả hợp đồng
                    contracts = dao.getContractsBySearch(information);
                //} else if(user.getRoleid() == 2) {
                    // Manager: tìm kiếm hợp đồng trong phạm vi quản lý
                    //contracts = dao.getContractsBySearchForManager(user.getID(), information);
                // else {
                    // Tenant: tìm kiếm hợp đồng của chính mình
                    //contracts = dao.getContractsBySearchForTenant(user.getID(), information);
                //}
                
                if (contracts == null || contracts.isEmpty()) {
                    request.setAttribute("message", "Không tìm thấy hợp đồng nào.");
                } else {
                    request.setAttribute("message", "Kết quả tìm kiếm cho: " + information);
                }

                // Cập nhật currentPage và totalPages
                int totalContracts = contracts.size(); // Tổng hợp đồng tìm được
                int totalPages = (int) Math.ceil(totalContracts / 5.0); // Cập nhật với số hợp đồng mỗi trang

                // Thiết lập các thuộc tính cho JSP
                request.setAttribute("contracts", contracts);
                request.setAttribute("currentPage", 1); // Đặt lại về trang đầu tiên
                request.setAttribute("totalPages", totalPages); // Cập nhật tổng trang

            } catch (Exception ex) {
                Logger.getLogger(ListContractsServlet.class.getName()).log(Level.SEVERE, null, ex);
                request.setAttribute("message", "Đã xảy ra lỗi khi tìm kiếm.");
            }

            // Chuyển hướng đến trang dựa trên vai trò người dùng
            if (user.getRoleid() == 1) {
                request.getRequestDispatcher("ContractsManager/ListContractsForAdmin.jsp").forward(request, response);
            } else if (user.getRoleid() == 2) {
                request.getRequestDispatcher("ContractsManager/ListContractsForManager.jsp").forward(request, response);
            } else if (user.getRoleid() == 3) {
                request.getRequestDispatcher("ContractsManager/ListContractsForTenant.jsp").forward(request, response);
            } else {
                response.sendError(HttpServletResponse.SC_FORBIDDEN, "Không có quyền truy cập.");
            }
        } else {
            response.sendRedirect("login");
        }
    }

    /** 
     * Returns a short description of the servlet.
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Servlet quản lý hợp đồng";
    }

}
