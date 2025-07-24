package Controller;

import java.io.IOException;
import java.io.InputStream;
import java.util.UUID;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.annotation.MultipartConfig;
import Ultils.ImageServices;

@WebServlet(name="UploadImageServlet", urlPatterns={"/api/upload-image"})
@MultipartConfig(maxFileSize = 1024 * 1024 * 5) // 5MB
public class UploadImageServlet extends HttpServlet {
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        try {
            // Lấy file từ request
            Part filePart = request.getPart("file");
            
            if (filePart == null || filePart.getSize() == 0) {
                response.getWriter().write("{\"error\": \"No file uploaded\", \"success\": false}");
                return;
            }
            
            // Kiểm tra loại file
            String contentType = filePart.getContentType();
            if (!contentType.startsWith("image/")) {
                response.getWriter().write("{\"error\": \"Only image files are allowed\", \"success\": false}");
                return;
            }
            
            // Tạo tên file unique
            String originalFileName = filePart.getSubmittedFileName();
            String fileExtension = "";
            if (originalFileName != null && originalFileName.contains(".")) {
                fileExtension = originalFileName.substring(originalFileName.lastIndexOf("."));
            }
            String fileName = UUID.randomUUID().toString() + fileExtension;
            
            // Đọc file data
            InputStream inputStream = filePart.getInputStream();
            byte[] imageData = inputStream.readAllBytes();
            inputStream.close();
            
            // Lưu ảnh sử dụng ImageServices
            String baseUrl = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + request.getContextPath();
            String runtimePath = request.getServletContext().getRealPath("/");
            String imageUrl = ImageServices.saveImageToLocal2(imageData, fileName, baseUrl, runtimePath);
            
            // Trả về JSON response
            response.getWriter().write("{\"imageUrl\": \"" + imageUrl + "\", \"success\": true}");
            
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().write("{\"error\": \"Upload failed: " + e.getMessage() + "\", \"success\": false}");
        }
    }
}
