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
//@WebServlet(name="VerificationMethod", urlPatterns={"/verificationMethod"})
//public class VerificationMethod extends HttpServlet {
//   
//    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
//    throws ServletException, IOException {
//        response.setContentType("text/html;charset=UTF-8");
//        try (PrintWriter out = response.getWriter()) {
//            /* TODO output your page here. You may use following sample code. */
//            out.println("<!DOCTYPE html>");
//            out.println("<html>");
//            out.println("<head>");
//            out.println("<title>Servlet VerificationMethod</title>");  
//            out.println("</head>");
//            out.println("<body>");
//            out.println("<h1>Servlet VerificationMethod at " + request.getContextPath () + "</h1>");
//            out.println("</body>");
//            out.println("</html>");
//        }
//    } 
//
//    @Override
//    protected void doGet(HttpServletRequest request, HttpServletResponse response)
//    throws ServletException, IOException {
//        request.getRequestDispatcher("ForgetPassword/VerificationMethod.jsp").forward(request, response);
//    } 
//
//   
//    @Override
//    protected void doPost(HttpServletRequest request, HttpServletResponse response)
//            throws ServletException, IOException {
//        String method = request.getParameter("method");  // phương thức xác thực
//        HttpSession session = request.getSession();
//        String email = (String) session.getAttribute("email");  
//
//        if (email == null || email.isEmpty()) {   // check tồn tại email step 1
//            request.setAttribute("error", "Phiên làm việc hết hạn, vui lòng nhập lại email!");
//            request.getRequestDispatcher("ForgetPassword/VerificationMethod.jsp").forward(request, response);
//            return;
//        }
//
//        if (!"email".equals(method)) {  // check nếu như phương thức không phải email
//            request.setAttribute("error", "Phương thức xác thực không hợp lệ!");
//            request.getRequestDispatcher("ForgetPassword/VerificationMethod.jsp").forward(request, response);
//            return;
//        }
//
//        DAOOTP dao = DAOOTP.INSTANCE;
//
//        // Kiểm tra xem email có otp trong khoảng 5p không nếu trong 5p báo lỗi và không gửi otp mới
//        if (dao.checkActiveOTP(email)) {
//            request.setAttribute("error", "Vui lòng đợi 5 phút trước khi yêu cầu OTP mới!");
//            request.getRequestDispatcher("ForgetPassword/VerificationMethod.jsp").forward(request, response);
//            return;
//        }
//
//        // Tạo OTP mới và kiểm tra trùng lặp
//        String otp;
//        do {
//            otp = String.format("%06d", new Random().nextInt(999999));
//        } while (dao.checkDuplicateOTP(email, otp)); // Lặp lại nếu OTP trùng
//
//        // Lưu OTP vào bảng tbOTP
//        OTP otpObj = new OTP(email, otp);
//        dao.addOTP(otpObj);
//
//        // Gửi email chứa OTP
//        try {
//            SendMail.sendMailAsyncOTP(email, otp);  // chia luồng riêng, cho email 1 luồng và UI người dùng 1 luồng
//            System.out.println("✅ Gửi email OTP thành công!");
//        } catch (Exception e) {
//            System.err.println("❌ Lỗi gửi email OTP: " + e.getMessage());
//            e.printStackTrace();
//            request.setAttribute("error", "Lỗi gửi email, vui lòng thử lại!");
//            request.getRequestDispatcher("ForgetPassword/VerificationMethod.jsp").forward(request, response);
//            return;
//        }
//
//        response.sendRedirect("otpchecking");
//    }
//
//    @Override
//    public String getServletInfo() {
//        return "Short description";
//    }// </editor-fold>
//
//}
