/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package Controller.forgetPassword;

//import dal.DAOOTP;
//import java.io.IOException;
//import java.io.PrintWriter;
//import jakarta.servlet.ServletException;
//import jakarta.servlet.annotation.WebServlet;
//import jakarta.servlet.http.HttpServlet;
//import jakarta.servlet.http.HttpServletRequest;
//import jakarta.servlet.http.HttpServletResponse;
//import jakarta.servlet.http.HttpSession;
//import java.util.Random;
//import model.OTP;
//
//
//@WebServlet(name="ResendOTP", urlPatterns={"/resendOTP"})
//public class ResendOTP extends HttpServlet {
//   
//    
//    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
//    throws ServletException, IOException {
//        response.setContentType("text/html;charset=UTF-8");
//        try (PrintWriter out = response.getWriter()) {
//            /* TODO output your page here. You may use following sample code. */
//            out.println("<!DOCTYPE html>");
//            out.println("<html>");
//            out.println("<head>");
//            out.println("<title>Servlet ResendOTP</title>");  
//            out.println("</head>");
//            out.println("<body>");
//            out.println("<h1>Servlet ResendOTP at " + request.getContextPath () + "</h1>");
//            out.println("</body>");
//            out.println("</html>");
//        }
//    } 
//
//    
//    @Override
//    protected void doGet(HttpServletRequest request, HttpServletResponse response)
//    throws ServletException, IOException {
//
//        HttpSession session = request.getSession();
//        String email = (String) session.getAttribute("email");
//
//        if (email == null || email.isEmpty()) {
//            request.setAttribute("error", "Phiên làm việc hết hạn, vui lòng nhập lại email!");
//            request.getRequestDispatcher("ForgetPassword/ForgetPassword.jsp").forward(request, response);
//            return;
//        }
//
//        DAOOTP dao = DAOOTP.INSTANCE;
//
//        // Kiểm tra xem email có OTP chưa hết hạn không
//        if (dao.checkActiveOTP(email)) {
//            request.setAttribute("error", "Vui lòng đợi 5 phút trước khi yêu cầu OTP mới!");
//            request.getRequestDispatcher("ForgetPassword/OTPChecking.jsp").forward(request, response);
//            return;
//        }
//
//        // Tạo OTP mới và kiểm tra trùng lặp
//        String otp;
//        do {
//            otp = String.format("%06d", new Random().nextInt(999999));
//        } while (dao.checkDuplicateOTP(email, otp));
//
//        // Lưu OTP vào bảng tbOTP
//        OTP otpObj = new OTP(email, otp);
//        dao.addOTP(otpObj);
//
//        // Gửi email chứa OTP
//        try {
//            SendMail.sendMailAsyncOTP(email, otp);
//            System.out.println("✅ Gửi email OTP thành công!");
//        } catch (Exception e) {
//            System.err.println("❌ Lỗi gửi email OTP: " + e.getMessage());
//            e.printStackTrace();
//            request.setAttribute("error", "Lỗi gửi email, vui lòng thử lại!");
//            request.getRequestDispatcher("ForgetPassword/OTPChecking.jsp").forward(request, response);
//            return;
//        }
//
//        // Thông báo gửi OTP thành công
//        request.setAttribute("error", "Mã OTP mới đã được gửi tới email của bạn!");
//        request.getRequestDispatcher("ForgetPassword/OTPChecking.jsp").forward(request, response);
//    }
//    
//
//    
//    @Override
//    public String getServletInfo() {
//        return "Short description";
//    }// </editor-fold>
//
//}
