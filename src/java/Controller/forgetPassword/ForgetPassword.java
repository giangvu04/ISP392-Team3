/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package Controller.forgetPassword;

import dal.DAOUser;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name="ForgetPassword", urlPatterns={"/forgetPassword"})
public class ForgetPassword extends HttpServlet {
   
    
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet ForgetPassword</title>");  
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet ForgetPassword at " + request.getContextPath () + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    } 

   
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        
        // ánh xạ file jsp
       request.getRequestDispatcher("ForgetPassword/ForgetPassword.jsp").forward(request, response);
    } 


    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String email = request.getParameter("email");
        HttpSession session = request.getSession();

        if (email == null || email.isEmpty()) {  // check null khi người dùng nhập
            request.setAttribute("error", "Vui lòng nhập email!");
            request.getRequestDispatcher("ForgetPassword/ForgetPassword.jsp").forward(request, response);
            return;
        }

        // Kiểm tra email tồn tại
        DAOUser dao = DAOUser.INSTANCE;
        if (!dao.checkEmailExists(email)) {
            request.setAttribute("error", "Email không tồn tại trong hệ thống!");
            request.getRequestDispatcher("ForgetPassword/ForgetPassword.jsp").forward(request, response);
            return;
        }

        // Lưu email vào session
        session.setAttribute("email", email);
        response.sendRedirect("verificationMethod");
    }

    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
