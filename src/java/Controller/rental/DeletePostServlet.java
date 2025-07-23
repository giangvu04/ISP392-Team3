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

@WebServlet(name="DeletePostServlet", urlPatterns={"/rental/deletePost"})
public class DeletePostServlet extends HttpServlet {
    
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
            response.sendRedirect(request.getContextPath() + "/rental/listPost");
            return;
        }
        
        try {
            int postId = Integer.parseInt(postIdStr);
            DAORentalPost rentalPostDAO = new DAORentalPost();
            
            // Kiểm tra quyền sở hữu (chỉ admin hoặc chủ bài viết)
            if (role != 1) {
                // Manager chỉ được xóa bài viết của mình
                // Thêm logic kiểm tra ownership ở đây nếu cần
            }
            
            boolean success = rentalPostDAO.deleteRentalPost(postId);
            
            if (success) {
                session.setAttribute("successMessage", "Xóa bài đăng thành công!");
            } else {
                session.setAttribute("errorMessage", "Có lỗi khi xóa bài đăng!");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("errorMessage", "Có lỗi xảy ra: " + e.getMessage());
        }
        
        response.sendRedirect(request.getContextPath() + "/rental/listPost");
    }
}
