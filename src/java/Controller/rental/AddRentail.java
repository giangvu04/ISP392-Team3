/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package Controller.rental;

import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name="AddRentail", urlPatterns={"/add_rentail"})
public class AddRentail extends HttpServlet {
   
   
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet AddRentail</title>");  
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet AddRentail at " + request.getContextPath () + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    } 

    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        
        request.getRequestDispatcher("Manager/AddRentalArea.jsp").forward(request, response);
    } 

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        // Lấy dữ liệu từ form
        int managerId = Integer.parseInt(request.getParameter("user_id"));
        String name = request.getParameter("name");
        String address = request.getParameter("address");
        String province = request.getParameter("province");
        String district = request.getParameter("district");
        String ward = request.getParameter("ward");
        String street = request.getParameter("street");
        String detail = request.getParameter("detail");

        // Gọi DAO để thêm khu trọ
        boolean success = dal.DAORentalArea.INSTANCE.insertRentalArea(managerId, name, address, province, district, ward, street, detail);

        if (success) {
            request.setAttribute("message", "Thêm khu trọ thành công!");
            request.getRequestDispatcher("Manager/AddRentalArea.jsp").forward(request, response);
        } else {
            request.setAttribute("error", "Thêm khu trọ thất bại!");
            request.getRequestDispatcher("Manager/AddRentalArea.jsp").forward(request, response);
        }
    }

   
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
