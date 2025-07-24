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
        int rating = 0;
        try {
            roomId = Integer.parseInt(roomIdStr);
            rating = Integer.parseInt(ratingStr);
        } catch (Exception e) {
            request.getSession().setAttribute("error", "Dữ liệu không hợp lệ!");
            response.sendRedirect("listbills");
            return;
        }
        FeedBack fb = new FeedBack();
        fb.setRoomId(roomId);
        fb.setUserId(user.getUserId());
        fb.setContent(content);
        fb.setRating(rating);
        try {
            DAOFeedBack.INSTANCE.addFeedBack(fb);
            request.getSession().setAttribute("success", "Đánh giá thành công!");
        } catch (Exception e) {
            request.getSession().setAttribute("error", "Lỗi khi lưu đánh giá!");
        }
        response.sendRedirect("listbills");
    }
}
