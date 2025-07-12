/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package Controller.forgetPassword;

import dal.DAOOTP;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.Random;
import model.OTP;

@WebServlet(name="OTPChecking", urlPatterns={"/otpchecking"})
public class OTPChecking extends HttpServlet {
   
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet OTPChecking</title>");  
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet OTPChecking at " + request.getContextPath () + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    } 

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        request.getRequestDispatcher("ForgetPassword/OTPChecking.jsp").forward(request, response);
    } 

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        String email = (String) session.getAttribute("email");
        String otp = request.getParameter("otpValue");

        if (email == null || email.isEmpty()) {
            request.setAttribute("error", "Phiên làm việc hết hạn, vui lòng nhập lại email!");
            request.getRequestDispatcher("ForgetPassword/ForgetPassword.jsp").forward(request, response);
            return;
        }

        if (otp == null || otp.length() != 6) {   // check null và check không phải 6 số
            request.setAttribute("error", "Mã OTP không hợp lệ!");
            request.getRequestDispatcher("ForgetPassword/OTPChecking.jsp").forward(request, response);
            return;
        }

        DAOOTP dao = DAOOTP.INSTANCE;
        OTP otpObj = dao.verifyOTP(email, otp);
        if (otpObj == null) {
            request.setAttribute("error", "Mã OTP sai hoặc đã hết hạn!");
            request.getRequestDispatcher("ForgetPassword/OTPChecking.jsp").forward(request, response);
            return;
        }

        dao.markOTPAsUsed(otpObj.getId());  // đánh dấu tình trang otp là đã sử dụng
        dao.deleteExpiredOrUsedOTPs();  

        response.sendRedirect("resetPassword");
    }
    
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
