package Controller.adminservlet;

import dal.DAOBusinessDocument;
import java.io.IOException;
import java.util.List;
import model.BusinessDocument;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import Ultils.SendMail;

@WebServlet(name="ReviewDocumentsController", urlPatterns={"/reviewDocuments"})
public class ReviewDocumentsController extends HttpServlet {
    
    private DAOBusinessDocument dao = DAOBusinessDocument.INSTANCE;
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Pagination parameters
        int page = 1;
        int pageSize = 10;
        String pageParam = request.getParameter("page");
        if (pageParam != null && !pageParam.isEmpty()) {
            try {
                page = Integer.parseInt(pageParam);
                if (page < 1) page = 1;
            } catch (NumberFormatException e) {
                page = 1;
            }
        }
        
        // Get documents based on search and status filter
        String statusParam = request.getParameter("status");
        String searchParam = request.getParameter("search");
        List<BusinessDocument> allDocs;
        
        // Apply search and status filters
        if (searchParam != null && !searchParam.trim().isEmpty()) {
            if (statusParam != null && !statusParam.isEmpty()) {
                // Search with status filter
                int status = Integer.parseInt(statusParam);
                allDocs = dao.searchBusinessDocumentsByStatus(searchParam.trim(), status);
            } else {
                // Search only
                allDocs = dao.searchBusinessDocuments(searchParam.trim());
            }
        } else if (statusParam != null && !statusParam.isEmpty()) {
            // Status filter only
            int status = Integer.parseInt(statusParam);
            allDocs = dao.getBusinessDocumentsByStatus(status);
        } else {
            // No filters
            allDocs = dao.getAllBusinessDocuments();
        }
        
        // Calculate pagination
        int totalRecords = allDocs.size();
        int totalPages = (int) Math.ceil((double) totalRecords / pageSize);
        int startIndex = (page - 1) * pageSize;
        int endIndex = Math.min(startIndex + pageSize, totalRecords);
        
        // Get documents for current page
        List<BusinessDocument> docs = allDocs.subList(startIndex, endIndex);
        
        // Set attributes
        request.setAttribute("docs", docs);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalRecords", totalRecords);
        request.setAttribute("pageSize", pageSize);
        request.getRequestDispatcher("/Admin/ReviewDocuments.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        int docId = Integer.parseInt(request.getParameter("documentId"));
        String note = request.getParameter("adminNote");
        
        // Get document info for email
        BusinessDocument doc = dao.getBusinessDocumentById(docId);
        
        if ("approve".equals(action)) {
            boolean success = dao.reviewDocument(docId, 1, note, 1);
            if (success && doc != null) {
                request.getSession().setAttribute("message", 
                    "Đã phê duyệt hồ sơ của " + doc.getManagerName() + "! Email thông báo đã được gửi.");
                
                // Send approval email using SendMail
                SendMail.sendManagerApprovalEmailAsync(
                    doc.getManagerEmail(), 
                    doc.getManagerName(), 
                    doc.getBusinessName()
                );
                
                System.out.println("✅ Đã gửi email phê duyệt cho: " + doc.getManagerEmail());
            } else {
                request.getSession().setAttribute("message", "Đã phê duyệt hồ sơ!");
            }
            
        } else if ("reject".equals(action)) {
            boolean success = dao.reviewDocument(docId, 2, note, 1);
            if (success && doc != null) {
                request.getSession().setAttribute("message", 
                    "Đã từ chối hồ sơ của " + doc.getManagerName() + "! Email thông báo đã được gửi.");
                
                // Send rejection email using SendMail
                SendMail.sendManagerRejectionEmailAsync(
                    doc.getManagerEmail(), 
                    doc.getManagerName(), 
                    doc.getBusinessName(),
                    note
                );
                
                System.out.println("❌ Đã gửi email từ chối cho: " + doc.getManagerEmail());
            } else {
                request.getSession().setAttribute("message", "Đã từ chối hồ sơ!");
            }
        }
        
        response.sendRedirect(request.getContextPath() + "/reviewDocuments");
    }
}
