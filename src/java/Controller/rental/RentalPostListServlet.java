package Controller.rental;

import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import dal.DAORentalPost;
import dal.DAOViewingRequest;
import dal.DAORentalArea;
import model.RentalPost;
import model.Users;
import model.RentalArea;

@WebServlet(name="RentalPostListServlet", urlPatterns={"/listPost"})
public class RentalPostListServlet extends HttpServlet {
    
    private static final int POSTS_PER_PAGE = 9;
    
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
            response.sendError(403, "Không có quyền truy cập");
            return;
        }
        
        try {
            DAORentalPost rentalPostDAO = new DAORentalPost();
            DAOViewingRequest viewingRequestDAO = new DAOViewingRequest();
            DAORentalArea areaDAO = new DAORentalArea();
            
            // Get search parameters
            String searchQuery = request.getParameter("search");
            String areaIdStr = request.getParameter("areaId");
            String status = request.getParameter("status");
            String pageStr = request.getParameter("page");
            
            int areaId = 0;
            if (areaIdStr != null && !areaIdStr.trim().isEmpty()) {
                try {
                    areaId = Integer.parseInt(areaIdStr);
                } catch (NumberFormatException e) {
                    areaId = 0;
                }
            }
            
            int currentPage = 1;
            if (pageStr != null && !pageStr.trim().isEmpty()) {
                try {
                    currentPage = Integer.parseInt(pageStr);
                    if (currentPage < 1) currentPage = 1;
                } catch (NumberFormatException e) {
                    currentPage = 1;
                }
            }
            
            List<RentalPost> posts;
            List<RentalPost> allPosts;
            
            // Lấy dữ liệu dựa trên role
            if (role == 1) { // Admin - xem tất cả
                allPosts = rentalPostDAO.searchRentalPosts(searchQuery, areaId, status, 0); // 0 means all managers
            } else { // Manager - chỉ xem bài viết của mình
                allPosts = rentalPostDAO.searchRentalPosts(searchQuery, areaId, status, user.getUserId());
            }
            
            // Calculate pagination
            int totalPosts = allPosts.size();
            int totalPages = (int) Math.ceil((double) totalPosts / POSTS_PER_PAGE);
            int startIndex = (currentPage - 1) * POSTS_PER_PAGE;
            int endIndex = Math.min(startIndex + POSTS_PER_PAGE, totalPosts);
            
            // Get posts for current page
            if (startIndex < totalPosts) {
                posts = allPosts.subList(startIndex, endIndex);
            } else {
                posts = List.of(); // Empty list if out of bounds
                currentPage = 1; // Reset to page 1 if invalid
            }
            
            // Lấy số lượt xem cho từng bài viết
            for (RentalPost post : posts) {
                try {
                    int viewCount = viewingRequestDAO.getViewCountByPost(post.getPostId());
                    post.setViewsCount(viewCount);
                } catch (Exception e) {
                    post.setViewsCount(0);
                }
            }
            
            // Tính thống kê từ tất cả bài viết (không chỉ trang hiện tại)
            int activePosts = 0;
            int featuredPosts = 0;
            int totalViews = 0;
            
            for (RentalPost post : allPosts) {
                if (post.isActive()) {
                    activePosts++;
                }
                if (post.isFeatured()) {
                    featuredPosts++;
                }
                // Get view count for statistics
                try {
                    int viewCount = viewingRequestDAO.getViewCountByPost(post.getPostId());
                    totalViews += viewCount;
                } catch (Exception e) {
                    // Ignore error, keep current total
                }
            }
            
            // Get rental areas for filter dropdown
            List<RentalArea> rentalAreas = areaDAO.getAllRentalAreas();
            
            // Set attributes cho JSP
            request.setAttribute("rentalPosts", posts);
            request.setAttribute("rentalAreas", rentalAreas);
            request.setAttribute("totalPosts", totalPosts);
            request.setAttribute("activePosts", activePosts);
            request.setAttribute("featuredPosts", featuredPosts);
            request.setAttribute("totalViews", totalViews);
            request.setAttribute("userRole", role);
            
            // Pagination attributes
            request.setAttribute("currentPage", currentPage);
            request.setAttribute("totalPages", totalPages);
            
            // Search parameters for maintaining state
            request.setAttribute("searchQuery", searchQuery);
            request.setAttribute("selectedAreaId", areaId);
            request.setAttribute("selectedStatus", status);
            
            request.getRequestDispatcher("/RentalPost/list.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Có lỗi xảy ra: " + e.getMessage());
            request.getRequestDispatcher("/RentalPost/list.jsp").forward(request, response);
        }
    }
}
