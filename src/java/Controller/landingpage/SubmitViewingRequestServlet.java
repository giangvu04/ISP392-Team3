package Controller.landingpage;

import java.io.IOException;
import java.sql.*;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import dal.DAOViewingRequest;
import Const.ViewingRequestStatus;
import model.Users;

@WebServlet(name = "SubmitViewingRequestServlet", urlPatterns = {"/submitViewingRequest"})
public class SubmitViewingRequestServlet extends HttpServlet {
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Set encoding
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html; charset=UTF-8");
        
        HttpSession session = request.getSession();
        
        try {
            // Kiểm tra đăng nhập
            Users user = (Users) session.getAttribute("user");
            
            if (user == null) {
                // Chưa đăng nhập - lưu URL để redirect về sau khi login
                String returnUrl = "roomDetail?id=" + request.getParameter("postId");
                session.setAttribute("returnUrl", returnUrl);
                request.getSession().setAttribute("error", "Vui lòng đăng nhập để tiếp tục");
                response.sendRedirect("login");
                return;
            }
            
            // Lấy dữ liệu từ form
            int postId = Integer.parseInt(request.getParameter("postId"));
            int roomId = Integer.parseInt(request.getParameter("roomId"));
            String message = request.getParameter("message");
            String preferredDateStr = request.getParameter("preferredDate");
            
            // Parse preferred date
            Timestamp preferredDate = null;
            if (preferredDateStr != null && !preferredDateStr.trim().isEmpty()) {
                try {
                    preferredDate = Timestamp.valueOf(preferredDateStr.replace("T", " ") + ":00");
                } catch (Exception e) {
                    // Invalid date format, set to null
                    preferredDate = null;
                }
            }
            
            // Sử dụng DAO pattern đúng cách với tenant_id
            boolean success = DAOViewingRequest.INSTANCE.addViewingRequest(
                postId, user.getUserId(), user.getFullName(), user.getPhone(), 
                user.getEmail(), 
                message != null ? message.trim() : null, 
                preferredDate
            );
            
            if (success) {
                // Redirect về trang chi tiết với thông báo thành công
                response.sendRedirect("roomDetail?id=" + postId + "&success=request_sent");
            } else {
                // Redirect về trang chi tiết với thông báo lỗi
                response.sendRedirect("roomDetail?id=" + postId + "&error=save_failed");
            }
            
        } catch (NumberFormatException e) {
            response.sendRedirect("trangchu?error=invalid_post");
        } catch (Exception e) {
            System.err.println("Error in SubmitViewingRequestServlet: " + e.getMessage());
            response.sendRedirect("trangchu?error=system_error");
        }
    }
}
