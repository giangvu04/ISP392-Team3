package Controller.manager;

import dal.DAOBusinessDocument;
import model.BusinessDocument;
import model.Users;
import Ultils.ImageServices;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import java.io.IOException;
import java.sql.Timestamp;
import java.util.UUID;

@WebServlet("/uploadBusinessDocuments")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2,  // 2MB
    maxFileSize = 1024 * 1024 * 10,       // 10MB
    maxRequestSize = 1024 * 1024 * 50     // 50MB
)
public class UploadBusinessDocumentsServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Set encoding
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html; charset=UTF-8");
        
        HttpSession session = request.getSession();
        
        // Kiểm tra có managerId từ bước 1 không
        Integer newManagerId = (Integer) session.getAttribute("newManagerId");
        String newManagerName = (String) session.getAttribute("newManagerName");
        
        // Hoặc kiểm tra user đã login (manager chưa active)
        Users user = (Users) session.getAttribute("user");
        
        if (newManagerId == null && (user == null || user.getRoleId() != 2)) {
            request.getSession().setAttribute("error", "Phiên làm việc không hợp lệ. Vui lòng đăng ký lại.");
            response.sendRedirect("registerManager");
            return;
        }
        
        // Set attributes cho JSP
        if (newManagerId != null) {
            request.setAttribute("managerId", newManagerId);
            request.setAttribute("managerName", newManagerName);
            request.setAttribute("isNewRegistration", true);
        } else {
            request.setAttribute("managerId", user.getUserId());
            request.setAttribute("managerName", user.getFullName());
            request.setAttribute("isNewRegistration", false);
        }
        
        request.getRequestDispatcher("/Manager/UploadBusinessDocuments.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Set encoding
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html; charset=UTF-8");
        
        HttpSession session = request.getSession();
        
        // Get managerId
        Integer managerId = null;
        Integer newManagerId = (Integer) session.getAttribute("newManagerId");
        Users user = (Users) session.getAttribute("user");
        
        if (newManagerId != null) {
            managerId = newManagerId;
        } else if (user != null && user.getRoleId() == 2) {
            managerId = user.getUserId();
        }
        
        if (managerId == null) {
            request.getSession().setAttribute("error", "Phiên làm việc không hợp lệ.");
            response.sendRedirect("registerManager");
            return;
        }

        try {
            // Get form data
            String businessName = request.getParameter("businessName");
            String taxCode = request.getParameter("taxCode");
            String businessAddress = request.getParameter("businessAddress");
            String representativeName = request.getParameter("representativeName");
            String representativeId = request.getParameter("representativeId");
            
            // Get runtime path for image storage
            String runtimePath = getServletContext().getRealPath("/");
            String baseUrl = request.getScheme() + "://" + request.getServerName() + ":" + request.getServerPort() + request.getContextPath();
            
            // Upload files and get URLs
            String businessLicenseUrl = uploadFile(request.getPart("businessLicense"), "business_license", baseUrl, runtimePath);
            String idCardFrontUrl = uploadFile(request.getPart("idCardFront"), "id_card_front", baseUrl, runtimePath);
            String idCardBackUrl = uploadFile(request.getPart("idCardBack"), "id_card_back", baseUrl, runtimePath);
            
            // Create BusinessDocument object
            BusinessDocument document = new BusinessDocument();
            document.setManagerId(managerId);
            document.setBusinessName(businessName);
            document.setTaxCode(taxCode);
            document.setBusinessAddress(businessAddress);
            document.setRepresentativeName(representativeName);
            document.setRepresentativeId(representativeId);
            document.setBusinessLicense(businessLicenseUrl);
            document.setIdCardFront(idCardFrontUrl);
            document.setIdCardBack(idCardBackUrl);
            document.setStatus(0); // Chờ duyệt
            document.setSubmittedAt(new Timestamp(System.currentTimeMillis()));
            
            // Save to database
            boolean success = DAOBusinessDocument.INSTANCE.addBusinessDocument(document);
            
            if (success) {
                // Clear session data from step 1
                session.removeAttribute("newManagerId");
                session.removeAttribute("newManagerName");
                
                request.getSession().setAttribute("success", 
                    "Upload giấy tờ thành công! Tài khoản đang chờ Super Admin duyệt.");
                response.sendRedirect("login");
            } else {
                request.getSession().setAttribute("error", "Có lỗi xảy ra khi lưu giấy tờ. Vui lòng thử lại.");
                response.sendRedirect("uploadBusinessDocuments");
            }
            
        } catch (Exception e) {
            System.err.println("Error uploading business documents: " + e.getMessage());
            e.printStackTrace();
            request.getSession().setAttribute("error", "Có lỗi xảy ra khi upload. Vui lòng thử lại.");
            response.sendRedirect("uploadBusinessDocuments");
        }
    }
    
    private String uploadFile(Part filePart, String fileType, String baseUrl, String runtimePath) throws IOException {
        if (filePart == null || filePart.getSize() == 0) {
            return null;
        }
        
        // Generate unique filename
        String originalFileName = filePart.getSubmittedFileName();
        String fileExtension = originalFileName.substring(originalFileName.lastIndexOf("."));
        String fileName = fileType + "_" + UUID.randomUUID().toString() + fileExtension;
        
        // Convert Part to byte array
        byte[] fileData = filePart.getInputStream().readAllBytes();
        
        // Use ImageServices to save file
        return ImageServices.saveImageToLocal2(fileData, fileName, baseUrl, runtimePath);
    }
}
