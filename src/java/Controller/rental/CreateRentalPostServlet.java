package Controller.rental;

import java.io.IOException;
import java.io.InputStream;
import java.sql.SQLException;
import java.util.Date;
import java.util.UUID;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import dal.DAORentalPost;
import dal.DAOPostRoom;
import dal.DAORentalArea;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.annotation.MultipartConfig;
import model.RentalPost;
import model.Users;
import Ultils.ImageServices;

@WebServlet(name="CreateRentalPostServlet", urlPatterns={"/createPost"})
@MultipartConfig(maxFileSize = 1024 * 1024 * 5) // 5MB
public class CreateRentalPostServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Users user = (Users) session.getAttribute("user");
        
        // Kiểm tra đăng nhập và quyền manager
        if (user == null || user.getRoleId() != 2) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        // Lấy danh sách rental areas của manager
        DAORentalArea rentalAreaDAO = new DAORentalArea();
        try {
            request.setAttribute("rentalAreas", rentalAreaDAO.getRentalAreasByManager(user.getUserId()));
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        request.getRequestDispatcher("/RentalPost/create.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        Users user = (Users) session.getAttribute("user");
        
        // Kiểm tra đăng nhập và quyền manager
        if (user == null || user.getRoleId()!= 2) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        try {
            // Lấy dữ liệu từ form
            int rentalAreaId = Integer.parseInt(request.getParameter("rentalAreaId"));
            String title = request.getParameter("title");
            String description = request.getParameter("description");
            String contactInfo = request.getParameter("contactInfo");
            String featuredImageUrl = request.getParameter("featuredImage");
            boolean isFeatured = request.getParameter("isFeatured") != null;
            
            // Xử lý upload ảnh nếu có
            String finalImageUrl = featuredImageUrl;
            try {
                Part filePart = request.getPart("featuredImageFile");
                if (filePart != null && filePart.getSize() > 0) {
                    // Upload file và lấy URL
                    String originalFileName = filePart.getSubmittedFileName();
                    String fileExtension = "";
                    if (originalFileName != null && originalFileName.contains(".")) {
                        fileExtension = originalFileName.substring(originalFileName.lastIndexOf("."));
                    }
                    String fileName = UUID.randomUUID().toString() + fileExtension;
                    
                    InputStream inputStream = filePart.getInputStream();
                    byte[] imageData = inputStream.readAllBytes();
                    inputStream.close();
                    
                    String baseUrl = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + request.getContextPath();
                    String runtimePath = request.getServletContext().getRealPath("/");
                    finalImageUrl = ImageServices.saveImageToLocal2(imageData, fileName, baseUrl, runtimePath);
                }
            } catch (Exception fileEx) {
                System.out.println("File upload error (using URL instead): " + fileEx.getMessage());
            }
            
            // Tạo RentalPost object
            RentalPost post = new RentalPost();
            post.setManagerId(user.getUserId());
            post.setRentalAreaId(rentalAreaId);
            post.setTitle(title);
            post.setDescription(description);
            post.setContactInfo(contactInfo);
            post.setFeaturedImage(finalImageUrl);
            post.setFeatured(isFeatured);
            post.setActive(true);
            post.setCreatedAt(new Date());
            post.setUpdatedAt(new Date());
            
            // Lưu vào database
            DAORentalPost rentalPostDAO = new DAORentalPost();
            int postId = rentalPostDAO.addRentalPost(post);
            
            System.out.println("Debug - Created post with ID: " + postId);
            
            if (postId > 0) {
                // Xử lý phòng được chọn (chỉ 1 phòng)
                String selectedRoom = request.getParameter("selectedRoom");
                System.out.println("Debug - Selected room parameter: " + selectedRoom);
                
                if (selectedRoom != null && !selectedRoom.trim().isEmpty()) {
                    try {
                        DAOPostRoom postRoomDAO = new DAOPostRoom();
                        int roomId = Integer.parseInt(selectedRoom);
                        boolean success = postRoomDAO.addRoomToPost(postId, roomId);
                        System.out.println("✅ Added room " + roomId + " to post " + postId + " - Success: " + success);
                        
                        if (!success) {
                            System.out.println("⚠️ Failed to add room to post_rooms table");
                        }
                    } catch (SQLException e) {
                        System.err.println("❌ SQL Error adding room to post: " + e.getMessage());
                        e.printStackTrace();
                    } catch (NumberFormatException e) {
                        System.err.println("❌ Invalid room ID format: " + selectedRoom);
                    }
                } else {
                    System.out.println("⚠️ No room selected for post " + postId);
                }
                
                session.setAttribute("successMessage", "Tạo tin đăng thành công!");
                response.sendRedirect(request.getContextPath() + "/listPost");
            } else {
                request.setAttribute("errorMessage", "Có lỗi xảy ra khi tạo tin đăng!");
                doGet(request, response);
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Có lỗi xảy ra: " + e.getMessage());
            doGet(request, response);
        }
    }
}
