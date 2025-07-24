
package Controller.feedbackservlet;

import dal.DAOFeedBack;
import dal.DAORooms;
import dal.DAOUser;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.ArrayList;
import model.FeedBack;
import model.Rooms;
import model.Users;


@WebServlet(name="FeedbackList", urlPatterns={"/feedbacklist"})
public class FeedbackList extends HttpServlet {
    
    private DAOFeedBack daoFeedback = DAOFeedBack.INSTANCE;
    private DAOUser daoUser = DAOUser.INSTANCE;
    private DAORooms daoRoom = DAORooms.INSTANCE;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Users user = (Users) session.getAttribute("user");
        
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        System.out.println("oke em ơi");

        String action = request.getParameter("action");
        if (action == null) action = "list";

        switch (action) {
            case "list":
                if (user.getRoleId() == 2) { // Manager
                    listAllFeedbacks(request, response, user);
                } else if (user.getRoleId() == 3) { // Tenant
                    listMyFeedbacks(request, response, user);
                }
                break;
            case "search":
                if (user.getRoleId() == 2) { // Manager
                    searchFeedbacks(request, response, user);
                } else if (user.getRoleId() == 3) { // Tenant
                    listMyFeedbacks(request, response, user);
                }
                break;
            default:
                if (user.getRoleId() == 2) {
                    listAllFeedbacks(request, response, user);
                } else {
                    listMyFeedbacks(request, response, user);
                }
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Users user = (Users) session.getAttribute("user");
        
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String action = request.getParameter("action");
        
        if (user.getRoleId() == 3) { // Chỉ tenant được thêm/sửa/xóa
            switch (action) {
                case "add":
                    addFeedback(request, response, user);
                    break;
                case "update":
                    updateFeedback(request, response, user);
                    break;
                case "delete":
                    deleteFeedback(request, response, user);
                    break;
                default:
                    response.sendRedirect("feedback");
            }
        } else {
            response.sendRedirect("feedbacklist");
        }
    }

    private void listAllFeedbacks(HttpServletRequest request, HttpServletResponse response, Users manager)
            throws ServletException, IOException {
        
        ArrayList<FeedBack> feedbacks = daoFeedback.getAllFeedBacks();
        
        // Lấy thêm thông tin user cho mỗi feedback
        for (FeedBack fb : feedbacks) {
            try {
                Users author = daoUser.getUserByID(fb.getUserId());
                if (author != null) {
                    fb.setAuthorName(author.getFullName());
                }
            } catch (Exception e) {
                System.err.println("Lỗi lấy thông tin user: " + e.getMessage());
            }
        }
        
        request.setAttribute("feedbacks", feedbacks);
        request.setAttribute("totalFeedbacks", feedbacks.size());
        
        // Tính đánh giá trung bình
        double averageRating = feedbacks.stream()
                .filter(fb -> fb.getRating() != null)
                .mapToInt(FeedBack::getRating)
                .average().orElse(0.0);
        request.setAttribute("averageRating", averageRating);
        
        // Tính feedback tháng này
        java.util.Calendar cal = java.util.Calendar.getInstance();
        int currentMonth = cal.get(java.util.Calendar.MONTH);
        int currentYear = cal.get(java.util.Calendar.YEAR);
        
        long monthlyFeedbacks = feedbacks.stream()
                .filter(fb -> {
                    if (fb.getCreatedAt() != null) {
                        java.util.Calendar fbCal = java.util.Calendar.getInstance();
                        fbCal.setTime(fb.getCreatedAt());
                        return fbCal.get(java.util.Calendar.MONTH) == currentMonth &&
                               fbCal.get(java.util.Calendar.YEAR) == currentYear;
                    }
                    return false;
                })
                .count();
        
        request.setAttribute("monthlyFeedbacks", monthlyFeedbacks);
        
        request.getRequestDispatcher("Manager/FeedbackList.jsp").forward(request, response);
    }

    private void searchFeedbacks(HttpServletRequest request, HttpServletResponse response, Users manager)
            throws ServletException, IOException {
        
        String searchType = request.getParameter("searchType");
        String searchValue = request.getParameter("searchValue");
        
        // Lấy tất cả feedback trước
        ArrayList<FeedBack> allFeedbacks = daoFeedback.getAllFeedBacks();
        ArrayList<FeedBack> filteredFeedbacks = new ArrayList<>();
        
        // Lấy thông tin user cho tất cả feedback
        for (FeedBack fb : allFeedbacks) {
            try {
                Users author = daoUser.getUserByID(fb.getUserId());
                if (author != null) {
                    fb.setAuthorName(author.getFullName());
                }
            } catch (Exception e) {
                System.err.println("Lỗi lấy thông tin user: " + e.getMessage());
            }
        }
        
        // Áp dụng filter search
        if (searchValue != null && !searchValue.trim().isEmpty()) {
            String lowerSearchValue = searchValue.toLowerCase().trim();
            
            for (FeedBack fb : allFeedbacks) {
                boolean matches = false;
                
                if (searchType == null || "content".equals(searchType)) {
                    // Tìm theo nội dung
                    if (fb.getContent() != null && 
                        fb.getContent().toLowerCase().contains(lowerSearchValue)) {
                        matches = true;
                    }
                } else if ("authorName".equals(searchType)) {
                    // Tìm theo tên người gửi
                    if (fb.getAuthorName() != null && 
                        fb.getAuthorName().toLowerCase().contains(lowerSearchValue)) {
                        matches = true;
                    }
                } else if ("roomId".equals(searchType)) {
                    // Tìm theo room ID
                    if (String.valueOf(fb.getRoomId()).contains(lowerSearchValue)) {
                        matches = true;
                    }
                }
                
                if (matches) {
                    filteredFeedbacks.add(fb);
                }
            }
        } else {
            // Không có search value, hiển thị tất cả
            filteredFeedbacks = allFeedbacks;
        }
        
        // Set attributes cho JSP
        request.setAttribute("feedbacks", filteredFeedbacks);
        request.setAttribute("totalFeedbacks", filteredFeedbacks.size());
        request.setAttribute("searchType", searchType);
        request.setAttribute("searchValue", searchValue);
        
        // Tính đánh giá trung bình từ kết quả search
        double averageRating = 0;
        int ratingCount = 0;
        for (FeedBack fb : filteredFeedbacks) {
            if (fb.getRating() != null) {
                averageRating += fb.getRating();
                ratingCount++;
            }
        }
        if (ratingCount > 0) {
            averageRating = averageRating / ratingCount;
        }
        request.setAttribute("averageRating", averageRating);
        
        // Tính feedback tháng này từ kết quả search
        java.util.Calendar cal = java.util.Calendar.getInstance();
        int currentMonth = cal.get(java.util.Calendar.MONTH);
        int currentYear = cal.get(java.util.Calendar.YEAR);
        
        int monthlyCount = 0;
        for (FeedBack fb : filteredFeedbacks) {
            if (fb.getCreatedAt() != null) {
                java.util.Calendar fbCal = java.util.Calendar.getInstance();
                fbCal.setTime(fb.getCreatedAt());
                
                if (fbCal.get(java.util.Calendar.MONTH) == currentMonth &&
                    fbCal.get(java.util.Calendar.YEAR) == currentYear) {
                    monthlyCount++;
                }
            }
        }
        request.setAttribute("monthlyFeedbacks", monthlyCount);
        
        request.getRequestDispatcher("Manager/FeedbackList.jsp").forward(request, response);
    }

    private void listMyFeedbacks(HttpServletRequest request, HttpServletResponse response, Users tenant)
            throws ServletException, IOException {
        
        ArrayList<FeedBack> myFeedbacks = daoFeedback.getFeedBacksByUser(tenant.getUserId());
        
        // Lấy danh sách phòng có thể feedback (phòng hiện tại và đã từng thuê)
        ArrayList<Rooms> availableRooms = new ArrayList<>();
        try {
            // Phòng hiện tại
            Rooms currentRoom = daoRoom.getCurrentRoomByTenant(tenant.getUserId());
            if (currentRoom != null) {
                availableRooms.add(currentRoom);
            }
            // Có thể thêm logic lấy phòng đã thuê trước đó
        } catch (Exception e) {
            System.err.println("Lỗi lấy phòng: " + e.getMessage());
        }
        
        request.setAttribute("myFeedbacks", myFeedbacks);
        request.setAttribute("availableRooms", availableRooms);
        request.setAttribute("totalMyFeedbacks", myFeedbacks.size());
        
        // Tính đánh giá trung bình của tenant
        double myAverageRating = myFeedbacks.stream()
                .filter(fb -> fb.getRating() != null)
                .mapToInt(FeedBack::getRating)
                .average().orElse(0.0);
        request.setAttribute("myAverageRating", myAverageRating);
        
        request.getRequestDispatcher("Tenant/MyFeedback.jsp").forward(request, response);
    }

    private void addFeedback(HttpServletRequest request, HttpServletResponse response, Users tenant)
            throws ServletException, IOException {
        
        try {
            int roomId = Integer.parseInt(request.getParameter("roomId"));
            String content = request.getParameter("content");
            String ratingStr = request.getParameter("rating");
            
            Integer rating = null;
            if (ratingStr != null && !ratingStr.trim().isEmpty()) {
                rating = Integer.parseInt(ratingStr);
            }
            
            FeedBack feedback = new FeedBack();
            feedback.setRoomId(roomId);
            feedback.setUserId(tenant.getUserId());
            feedback.setContent(content);
            feedback.setRating(rating);
            
            daoFeedback.addFeedBack(feedback);
            
            request.getSession().setAttribute("success", "Thêm feedback thành công!");
        } catch (Exception e) {
            request.getSession().setAttribute("error", "Có lỗi xảy ra: " + e.getMessage());
        }
        
        response.sendRedirect("feedbacklist");
    }

    private void updateFeedback(HttpServletRequest request, HttpServletResponse response, Users tenant)
            throws ServletException, IOException {
        
        try {
            int feedbackId = Integer.parseInt(request.getParameter("feedbackId"));
            String content = request.getParameter("content");
            String ratingStr = request.getParameter("rating");
            
            // Kiểm tra quyền sửa
            FeedBack existingFeedback = daoFeedback.getFeedBackById(feedbackId);
            if (existingFeedback == null || existingFeedback.getUserId() != tenant.getUserId()) {
                request.getSession().setAttribute("error", "Bạn không có quyền sửa feedback này!");
                response.sendRedirect("feedbacklist");
                return;
            }
            
            Integer rating = null;
            if (ratingStr != null && !ratingStr.trim().isEmpty()) {
                rating = Integer.parseInt(ratingStr);
            }
            
            FeedBack updatedFeedback = new FeedBack();
            updatedFeedback.setFeedbackId(feedbackId);
            updatedFeedback.setUserId(tenant.getUserId());
            updatedFeedback.setContent(content);
            updatedFeedback.setRating(rating);
            
            daoFeedback.updateFeedBack(updatedFeedback);
            
            request.getSession().setAttribute("success", "Cập nhật feedback thành công!");
        } catch (Exception e) {
            request.getSession().setAttribute("error", "Có lỗi xảy ra: " + e.getMessage());
        }
        
        response.sendRedirect("feedbacklist");
    }

    private void deleteFeedback(HttpServletRequest request, HttpServletResponse response, Users tenant)
            throws ServletException, IOException {
        
        try {
            int feedbackId = Integer.parseInt(request.getParameter("feedbackId"));
            
            // Kiểm tra quyền xóa
            FeedBack feedback = daoFeedback.getFeedBackById(feedbackId);
            if (feedback != null && feedback.getUserId() == tenant.getUserId()) {
                daoFeedback.deleteFeedBack(feedbackId);
                request.getSession().setAttribute("success", "Xóa feedback thành công!");
            } else {
                request.getSession().setAttribute("error", "Bạn không có quyền xóa feedback này!");
            }
        } catch (Exception e) {
            request.getSession().setAttribute("error", "Có lỗi xảy ra: " + e.getMessage());
        }
        
        response.sendRedirect("feedbacklist");
    }
}


