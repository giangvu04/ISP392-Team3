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

@WebServlet(name="ResetPassword", urlPatterns={"/resetPassword"})
public class ResetPassword extends HttpServlet {
   
   
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet ResetPassword</title>");  
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet ResetPassword at " + request.getContextPath () + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    } 

    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
       request.getRequestDispatcher("ForgetPassword/ResetPassword.jsp").forward(request, response);
    } 

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        String email = (String) session.getAttribute("email");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");

        if (email == null || email.isEmpty()) {  // check phiên làm việc
            request.setAttribute("message", "Phiên làm việc hết hạn, vui lòng bắt đầu lại!");
            request.getRequestDispatcher("ForgetPassword/ForgetPassword.jsp").forward(request, response);
            return;
        }

        if (password == null || confirmPassword == null || password.isEmpty() || confirmPassword.isEmpty()) { 
            request.setAttribute("message", "Vui lòng nhập đầy đủ mật khẩu và xác nhận mật khẩu!");
            request.getRequestDispatcher("ForgetPassword/ResetPassword.jsp").forward(request, response);
            return;
        }

        if (!password.equals(confirmPassword)) {
            request.setAttribute("message", "Mật khẩu và xác nhận mật khẩu không khớp!");
            request.getRequestDispatcher("ForgetPassword/ResetPassword.jsp").forward(request, response);
            return;
        }

        // Giả định mã hóa mật khẩu (nếu có)
        // String hashedPassword = hashPassword(password); // hàm mã hóa(nếu có)

        DAOUser dao = DAOUser.INSTANCE;
        if (dao.updatePassword(email, password)) {
            // Xóa session sau khi reset thành công
            session.invalidate();
            request.setAttribute("message", "Đặt lại mật khẩu thành công! Vui lòng đăng nhập lại.");
            request.getRequestDispatcher("Login/login.jsp").forward(request, response);
        } else {
            request.setAttribute("message", "Lỗi khi đặt lại mật khẩu, vui lòng thử lại!");
            request.getRequestDispatcher("ForgetPassword/ResetPassword.jsp").forward(request, response);
        }
    }

    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
