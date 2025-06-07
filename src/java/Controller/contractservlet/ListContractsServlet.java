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

        //if (user != null) {
            //request.setAttribute("user", user);

            // Lấy trang hiện tại từ URL (mặc định là 1)
            int currentPage = Integer.parseInt(request.getParameter("page") != null ? request.getParameter("page") : "1");
            int contractsPerPage = 5;

            // Lấy toàn bộ hợp đồng
            ArrayList<Contracts> allContracts = dao.getAllContracts();
            if (allContracts == null) {
                allContracts = new ArrayList<>();
            }

            int totalContracts = allContracts.size();
            int totalPages = (int) Math.ceil((double) totalContracts / contractsPerPage);

            // Điều chỉnh currentPage hợp lệ
            if (totalPages == 0) {
                currentPage = 1;
                totalPages = 1;
            } else if (currentPage > totalPages) {
                currentPage = totalPages;
            } else if (currentPage < 1) {
                currentPage = 1;
            }

            // Phân trang
            int start = (currentPage - 1) * contractsPerPage;
            int end = Math.min(start + contractsPerPage, totalContracts);
            ArrayList<Contracts> pagedContracts = new ArrayList<>(allContracts.subList(start, end));

            // Thiết lập attributes cho JSP
            request.setAttribute("contracts", pagedContracts);
            request.setAttribute("currentPage", currentPage);
            request.setAttribute("totalPages", totalPages);

            // Chuyển hướng đến trang theo vai trò
            //if (user.getRoleid() == 1) {
            //    request.getRequestDispatcher("Contracts/ListContractForAdmin.jsp").forward(request, response);
            //} else if (user.getRoleid() == 2) {
            //    request.getRequestDispatcher("Contracts/ListContractForManager.jsp").forward(request, response);
            //} else if (user.getRoleid() == 3) {
            //    request.getRequestDispatcher("Contracts/ListContractForTenant.jsp").forward(request, response);
            //} else {
            //    response.sendError(HttpServletResponse.SC_FORBIDDEN, "Không có quyền truy cập.");
            //}

        //} else {
            //response.sendRedirect("login.jsp");
            
        //}
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
        DAOContract dao = DAOContract.INSTANCE;
        //HttpSession session = request.getSession();
        //Users user = (Users) session.getAttribute("user");

        //if (user != null) {
            //request.setAttribute("user", user);
            String searchInfo = request.getParameter("searchInfo");

            ArrayList<Contracts> filteredContracts = new ArrayList<>();
            try {
                ArrayList<Contracts> allContracts = dao.getAllContracts();
                if (allContracts == null) {
                    allContracts = new ArrayList<>();
                }

                String lowerSearch = (searchInfo != null) ? searchInfo.trim().toLowerCase() : "";

                if (!lowerSearch.isEmpty()) {
                    for (Contracts c : allContracts) {
                        String tenantId = String.valueOf(c.getTenantsID());
                        String contractId = String.valueOf(c.getContractId());

                        if (tenantId.contains(lowerSearch) || contractId.contains(lowerSearch)) {
                            filteredContracts.add(c);
                        }
                    }
                } else {
                    filteredContracts = allContracts;
                }

                if (filteredContracts.isEmpty() && !lowerSearch.isEmpty()) {
                    request.setAttribute("message", "Không tìm thấy hợp đồng nào cho '" + searchInfo + "'.");
                } else if (!lowerSearch.isEmpty()) {
                    request.setAttribute("message", "Kết quả tìm kiếm cho: " + searchInfo);
                } else {
                    request.setAttribute("message", "");
                }

                // Khi tìm kiếm thường không phân trang
                int totalContracts = filteredContracts.size();
                int totalPages = (int) Math.ceil((double) totalContracts / 5.0);

                request.setAttribute("contracts", filteredContracts);
                request.setAttribute("currentPage", 1);
                request.setAttribute("totalPages", totalPages);

            } catch (Exception ex) {
                Logger.getLogger(ListContractsServlet.class.getName()).log(Level.SEVERE, null, ex);
                request.setAttribute("message", "Đã xảy ra lỗi khi tìm kiếm.");
            }

            // Chuyển hướng đến trang theo vai trò
            //if (user.getRoleid() == 1) {
            //    request.getRequestDispatcher("Contracts/ListContractForAdmin.jsp").forward(request, response);
            //} else if (user.getRoleid() == 2) {
             //   request.getRequestDispatcher("Contracts/ListContractForManager.jsp").forward(request, response);
            //} else if (user.getRoleid() == 3) {
            //    request.getRequestDispatcher("Contracts/ListContractForTenant.jsp").forward(request, response);
            //} else {
            //    response.sendError(HttpServletResponse.SC_FORBIDDEN, "Không có quyền truy cập.");
            //}
        //} else {
            //response.sendRedirect("login.jsp");
        //}
    }

    /** 
     * Returns a short description of the servlet.
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Servlet hiển thị danh sách hợp đồng với phân trang và tìm kiếm";
    }// </editor-fold>

}
