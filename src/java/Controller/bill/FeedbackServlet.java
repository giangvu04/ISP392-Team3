package Controller.bill;

import dal.DAOFeedBack;
import model.FeedBack;
import model.Users;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet(name = "FeedbackServlet", urlPatterns = {"/feedback"})
public class FeedbackServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Users user = (Users) request.getSession().getAttribute("user");
        if (user == null || user.getRoleId() != 3) {
            request.getSession().setAttribute("error", "Bạn không có quyền đánh giá!");
            response.sendRedirect("listbills");
            return;
        }
        String roomIdStr = request.getParameter("roomId");
        String content = request.getParameter("content");
        String ratingStr = request.getParameter("rating");
        
        int roomId = 0;
        Integer rating = null;
        
        try {
            roomId = Integer.parseInt(roomIdStr);
            if (ratingStr != null && !ratingStr.trim().isEmpty()) {
                rating = Integer.parseInt(ratingStr);
            }
        } catch (Exception e) {
            request.getSession().setAttribute("error", "Dữ liệu không hợp lệ!");
            e.printStackTrace();
            response.sendRedirect("feedbacklist");
            return;
        }
        FeedBack fb = new FeedBack();
        fb.setRoomId(roomId);
        fb.setUserId(user.getUserId());
        fb.setContent(content);
        fb.setRating(rating);
        try {
            DAOFeedBack.INSTANCE.addFeedBack(fb);
            request.getSession().setAttribute("success", "Gửi feedback thành công!");
        } catch (Exception e) {
            request.getSession().setAttribute("error", "Lỗi khi lưu feedback: " + e.getMessage());
        }
        
        // Redirect về tenant homepage hoặc feedback list
        String referer = request.getHeader("Referer");
        if (referer != null && referer.contains("tenant_homepage")) {
            response.sendRedirect("Tenant/tenant_homepage.jsp");
        } else {
            response.sendRedirect("feedbacklist");
        }
    }
}
