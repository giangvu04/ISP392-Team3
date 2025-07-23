package Controller.rental;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import dal.DAORentalPost;
import dal.DAORentalArea;
import model.RentalPost;
import model.RentalArea;
import model.Users;
import java.util.List;

@WebServlet(name="EditRentalPostServlet", urlPatterns={"/editPost"})
public class EditRentalPostServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Users user = (Users) session.getAttribute("user");
        
        // Kiểm tra đăng nhập và quyền
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        int role = user.getRoleId();
        if (role != 1 && role != 2) {
            session.setAttribute("errorMessage", "Không có quyền truy cập");
            response.sendRedirect(request.getContextPath() + "/listPost");
            return;
        }
        
        try {
            String postIdStr = request.getParameter("id");
            if (postIdStr == null || postIdStr.trim().isEmpty()) {
                session.setAttribute("errorMessage", "ID bài viết không hợp lệ");
                response.sendRedirect(request.getContextPath() + "/listPost");
                return;
            }
            
            int postId = Integer.parseInt(postIdStr);
            DAORentalPost rentalPostDAO = new DAORentalPost();
            DAORentalArea areaDAO = new DAORentalArea();
            
            RentalPost post = rentalPostDAO.getRentalPostById(postId);
            if (post == null) {
                session.setAttribute("errorMessage", "Không tìm thấy bài viết");
                response.sendRedirect(request.getContextPath() + "/listPost");
                return;
            }
            
            // Kiểm tra quyền sở hữu nếu là Manager
            if (role == 2 && post.getManagerId() != user.getUserId()) {
                session.setAttribute("errorMessage", "Bạn chỉ có thể sửa bài viết của mình");
                response.sendRedirect(request.getContextPath() + "/listPost");
                return;
            }
            
            // Lấy danh sách khu trọ
            List<RentalArea> rentalAreas = areaDAO.getAllRentalAreas();
            
            // Set attributes cho JSP
            request.setAttribute("rentalPost", post);
            request.setAttribute("rentalAreas", rentalAreas);
            
            request.getRequestDispatcher("/RentalPost/edit.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            session.setAttribute("errorMessage", "ID bài viết không hợp lệ");
            response.sendRedirect(request.getContextPath() + "/listPost");
        } catch (Exception e) {
            session.setAttribute("errorMessage", "Có lỗi xảy ra: " + e.getMessage());
            response.sendRedirect(request.getContextPath() + "/listPost");
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Users user = (Users) session.getAttribute("user");
        
        // Kiểm tra đăng nhập và quyền
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        int role = user.getRoleId();
        if (role != 1 && role != 2) {
            session.setAttribute("errorMessage", "Không có quyền truy cập");
            response.sendRedirect(request.getContextPath() + "/listPost");
            return;
        }
        
        try {
            // Get form parameters
            String postIdStr = request.getParameter("postId");
            String title = request.getParameter("title");
            String description = request.getParameter("description");
            String contactInfo = request.getParameter("contactInfo");
            String areaIdStr = request.getParameter("areaId");
            String featuredImage = request.getParameter("featuredImage");
            
            // Validation
            if (postIdStr == null || title == null || description == null || 
                areaIdStr == null || title.trim().isEmpty() || description.trim().isEmpty()) {
                session.setAttribute("errorMessage", "Vui lòng điền đầy đủ thông tin bắt buộc");
                response.sendRedirect(request.getContextPath() + "/editPost?id=" + postIdStr);
                return;
            }
            
            int postId = Integer.parseInt(postIdStr);
            int areaId = Integer.parseInt(areaIdStr);
            
            DAORentalPost rentalPostDAO = new DAORentalPost();
            
            // Lấy bài viết hiện tại để kiểm tra quyền sở hữu
            RentalPost existingPost = rentalPostDAO.getRentalPostById(postId);
            if (existingPost == null) {
                session.setAttribute("errorMessage", "Không tìm thấy bài viết");
                response.sendRedirect(request.getContextPath() + "/listPost");
                return;
            }
            
            // Kiểm tra quyền sở hữu nếu là Manager
            if (role == 2 && existingPost.getManagerId() != user.getUserId()) {
                session.setAttribute("errorMessage", "Bạn chỉ có thể sửa bài viết của mình");
                response.sendRedirect(request.getContextPath() + "/listPost");
                return;
            }
            
            // Tạo object cập nhật
            RentalPost updatedPost = new RentalPost();
            updatedPost.setPostId(postId);
            updatedPost.setTitle(title.trim());
            updatedPost.setDescription(description.trim());
            updatedPost.setContactInfo(contactInfo != null ? contactInfo.trim() : "");
            updatedPost.setRentalAreaId(areaId);
            updatedPost.setFeaturedImage(featuredImage != null ? featuredImage.trim() : "");
            
            // Giữ nguyên các thuộc tính khác
            updatedPost.setManagerId(existingPost.getManagerId());
            updatedPost.setFeatured(existingPost.isFeatured());
            updatedPost.setActive(existingPost.isActive());
            updatedPost.setViewsCount(existingPost.getViewsCount());
            
            // Cập nhật bài viết
            boolean success = rentalPostDAO.updateRentalPost(updatedPost);
            
            if (success) {
                session.setAttribute("successMessage", "Cập nhật bài viết thành công");
            } else {
                session.setAttribute("errorMessage", "Có lỗi xảy ra khi cập nhật bài viết");
            }
            
            response.sendRedirect(request.getContextPath() + "/listPost");
            
        } catch (NumberFormatException e) {
            session.setAttribute("errorMessage", "Dữ liệu không hợp lệ");
            response.sendRedirect(request.getContextPath() + "/listPost");
        } catch (Exception e) {
            session.setAttribute("errorMessage", "Có lỗi xảy ra: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/listPost");
        }
    }
}
