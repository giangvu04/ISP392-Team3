package Controller.rental;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import dal.DAORentalPost;
import model.Users;

@WebServlet(name="TogglePostFeaturedServlet", urlPatterns={"/toggleFeatured"})
public class TogglePostFeaturedServlet extends HttpServlet {
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Users user = (Users) session.getAttribute("user");
        
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        int role = user.getRoleId();
        if (role != 1 && role != 2) {
            response.sendError(403, "Không có quyền truy cập");
            return;
        }
        
        String postIdStr = request.getParameter("postId");
        if (postIdStr == null) {
            session.setAttribute("errorMessage", "Thiếu thông tin bài đăng");
            response.sendRedirect(request.getContextPath() + "/listPost");
            return;
        }
        
        try {
            int postId = Integer.parseInt(postIdStr);
            DAORentalPost rentalPostDAO = new DAORentalPost();
            
            boolean success = rentalPostDAO.togglePostFeatured(postId);
            
            if (success) {
                session.setAttribute("successMessage", "Cập nhật trạng thái nổi bật thành công!");
            } else {
                session.setAttribute("errorMessage", "Có lỗi khi cập nhật trạng thái nổi bật!");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMessage", "Có lỗi xảy ra: " + e.getMessage());
        }
        
        response.sendRedirect(request.getContextPath() + "listPost");
    }
}
