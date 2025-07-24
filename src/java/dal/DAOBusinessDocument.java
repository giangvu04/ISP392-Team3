package dal;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import model.BusinessDocument;

public class DAOBusinessDocument {
    
    public static final DAOBusinessDocument INSTANCE = new DAOBusinessDocument();
    private Connection connect;
    
    public DAOBusinessDocument() {
        connect = new DBContext().connect;
    }
    
    // Thêm giấy tờ kinh doanh mới
    public boolean addBusinessDocument(BusinessDocument document) {
        String sql = "INSERT INTO business_documents (manager_id, business_license, tax_code, " +
                    "business_name, business_address, representative_name, representative_id, " +
                    "id_card_front, id_card_back, additional_documents, status, submitted_at) " +
                    "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        
        try (PreparedStatement ps = connect.prepareStatement(sql)) {
            ps.setInt(1, document.getManagerId());
            ps.setString(2, document.getBusinessLicense());
            ps.setString(3, document.getTaxCode());
            ps.setString(4, document.getBusinessName());
            ps.setString(5, document.getBusinessAddress());
            ps.setString(6, document.getRepresentativeName());
            ps.setString(7, document.getRepresentativeId());
            ps.setString(8, document.getIdCardFront());
            ps.setString(9, document.getIdCardBack());
            ps.setString(10, document.getAdditionalDocuments());
            ps.setInt(11, document.getStatus());
            ps.setTimestamp(12, document.getSubmittedAt());
            
            return ps.executeUpdate() > 0;
            
        } catch (SQLException e) {
            throw new RuntimeException("Error adding business document: " + e.getMessage(), e);
        }
    }
    
    // Lấy giấy tờ theo manager ID
    public BusinessDocument getByManagerId(int managerId) {
        String sql = "SELECT bd.*, u.full_name as manager_name, u.email as manager_email, " +
                    "u.phone_number as manager_phone, a.full_name as admin_name " +
                    "FROM business_documents bd " +
                    "JOIN users u ON bd.manager_id = u.user_id " +
                    "LEFT JOIN users a ON bd.reviewed_by = a.user_id " +
                    "WHERE bd.manager_id = ? " +
                    "ORDER BY bd.submitted_at DESC";
        
        try (PreparedStatement ps = connect.prepareStatement(sql)) {
            ps.setInt(1, managerId);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                return mapResultSetToBusinessDocument(rs);
            }
            return null;
            
        } catch (SQLException e) {
            throw new RuntimeException("Error getting business document by manager ID: " + e.getMessage(), e);
        }
    }
    
    // Lấy danh sách tất cả giấy tờ (cho Super Admin)
    public List<BusinessDocument> getAllDocuments() {
        String sql = "SELECT bd.*, u.full_name as manager_name, u.email as manager_email, " +
                    "u.phone_number as manager_phone, a.full_name as admin_name " +
                    "FROM business_documents bd " +
                    "JOIN users u ON bd.manager_id = u.user_id " +
                    "LEFT JOIN users a ON bd.reviewed_by = a.user_id " +
                    "ORDER BY bd.submitted_at DESC";
        
        return executeDocumentQuery(sql);
    }
    
    // Alias method for servlet compatibility  
    public List<BusinessDocument> getAllBusinessDocuments() {
        return getAllDocuments();
    }
    
    // Alias method for servlet compatibility
    public List<BusinessDocument> getBusinessDocumentsByStatus(int status) {
        return getDocumentsByStatus(status);
    }
    
    // Search documents by business name, manager name, email
    public List<BusinessDocument> searchBusinessDocuments(String searchText) {
        String sql = "SELECT bd.*, u.full_name as manager_name, u.email as manager_email, " +
                    "u.phone_number as manager_phone, a.full_name as admin_name " +
                    "FROM business_documents bd " +
                    "JOIN users u ON bd.manager_id = u.user_id " +
                    "LEFT JOIN users a ON bd.reviewed_by = a.user_id " +
                    "WHERE bd.business_name LIKE ? OR u.full_name LIKE ? OR u.email LIKE ? " +
                    "ORDER BY bd.submitted_at DESC";
        
        try (PreparedStatement ps = connect.prepareStatement(sql)) {
            String searchPattern = "%" + searchText + "%";
            ps.setString(1, searchPattern);
            ps.setString(2, searchPattern);
            ps.setString(3, searchPattern);
            return executeDocumentQuery(ps);
        } catch (SQLException e) {
            throw new RuntimeException("Error searching documents: " + e.getMessage(), e);
        }
    }
    
    // Search documents by text and status
    public List<BusinessDocument> searchBusinessDocumentsByStatus(String searchText, int status) {
        String sql = "SELECT bd.*, u.full_name as manager_name, u.email as manager_email, " +
                    "u.phone_number as manager_phone, a.full_name as admin_name " +
                    "FROM business_documents bd " +
                    "JOIN users u ON bd.manager_id = u.user_id " +
                    "LEFT JOIN users a ON bd.reviewed_by = a.user_id " +
                    "WHERE (bd.business_name LIKE ? OR u.full_name LIKE ? OR u.email LIKE ?) " +
                    "AND bd.status = ? " +
                    "ORDER BY bd.submitted_at DESC";
        
        try (PreparedStatement ps = connect.prepareStatement(sql)) {
            String searchPattern = "%" + searchText + "%";
            ps.setString(1, searchPattern);
            ps.setString(2, searchPattern);
            ps.setString(3, searchPattern);
            ps.setInt(4, status);
            return executeDocumentQuery(ps);
        } catch (SQLException e) {
            throw new RuntimeException("Error searching documents by status: " + e.getMessage(), e);
        }
    }
    
    // Lấy document theo ID
    public BusinessDocument getBusinessDocumentById(int documentId) {
        String sql = "SELECT bd.*, u.full_name as manager_name, u.email as manager_email, " +
                    "u.phone_number as manager_phone, a.full_name as admin_name " +
                    "FROM business_documents bd " +
                    "JOIN users u ON bd.manager_id = u.user_id " +
                    "LEFT JOIN users a ON bd.reviewed_by = a.user_id " +
                    "WHERE bd.document_id = ?";
        
        try (PreparedStatement ps = connect.prepareStatement(sql)) {
            ps.setInt(1, documentId);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                return mapResultSetToBusinessDocument(rs);
            }
            return null;
            
        } catch (SQLException e) {
            throw new RuntimeException("Error getting business document by ID: " + e.getMessage(), e);
        }
    }
    
    // Lấy danh sách giấy tờ theo status
    public List<BusinessDocument> getDocumentsByStatus(int status) {
        String sql = "SELECT bd.*, u.full_name as manager_name, u.email as manager_email, " +
                    "u.phone_number as manager_phone, a.full_name as admin_name " +
                    "FROM business_documents bd " +
                    "JOIN users u ON bd.manager_id = u.user_id " +
                    "LEFT JOIN users a ON bd.reviewed_by = a.user_id " +
                    "WHERE bd.status = ? " +
                    "ORDER BY bd.submitted_at DESC";
        
        try (PreparedStatement ps = connect.prepareStatement(sql)) {
            ps.setInt(1, status);
            return executeDocumentQuery(ps);
        } catch (SQLException e) {
            throw new RuntimeException("Error getting documents by status: " + e.getMessage(), e);
        }
    }
    
    // Cập nhật trạng thái duyệt
    public boolean reviewDocument(int documentId, int status, String adminNote, int reviewedBy) {
        String sql = "UPDATE business_documents SET status = ?, admin_note = ?, " +
                    "reviewed_by = ?, reviewed_at = ? WHERE document_id = ?";
        
        try (PreparedStatement ps = connect.prepareStatement(sql)) {
            ps.setInt(1, status);
            ps.setString(2, adminNote);
            ps.setInt(3, reviewedBy);
            ps.setTimestamp(4, new Timestamp(System.currentTimeMillis()));
            ps.setInt(5, documentId);
            
            boolean updated = ps.executeUpdate() > 0;
            
            // Nếu duyệt thành công (status = 1), cập nhật is_active = 1 cho manager
            if (updated && status == 1) {
                updateManagerActiveStatus(documentId, true);
            }
            
            return updated;
            
        } catch (SQLException e) {
            throw new RuntimeException("Error reviewing document: " + e.getMessage(), e);
        }
    }
    
    // Cập nhật trạng thái active của manager
    private boolean updateManagerActiveStatus(int documentId, boolean isActive) {
        String sql = "UPDATE users SET is_active = ? WHERE user_id = " +
                    "(SELECT manager_id FROM business_documents WHERE document_id = ?)";
        
        try (PreparedStatement ps = connect.prepareStatement(sql)) {
            ps.setBoolean(1, isActive);
            ps.setInt(2, documentId);
            return ps.executeUpdate() > 0;
            
        } catch (SQLException e) {
            throw new RuntimeException("Error updating manager active status: " + e.getMessage(), e);
        }
    }
    
    // Helper method để thực thi query và map kết quả
    private List<BusinessDocument> executeDocumentQuery(String sql) {
        List<BusinessDocument> documents = new ArrayList<>();
        
        try (PreparedStatement ps = connect.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while (rs.next()) {
                documents.add(mapResultSetToBusinessDocument(rs));
            }
            
        } catch (SQLException e) {
            throw new RuntimeException("Error executing document query: " + e.getMessage(), e);
        }
        
        return documents;
    }
    
    private List<BusinessDocument> executeDocumentQuery(PreparedStatement ps) throws SQLException {
        List<BusinessDocument> documents = new ArrayList<>();
        
        try (ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                documents.add(mapResultSetToBusinessDocument(rs));
            }
        }
        
        return documents;
    }
    
    // Map ResultSet thành BusinessDocument object
    private BusinessDocument mapResultSetToBusinessDocument(ResultSet rs) throws SQLException {
        BusinessDocument document = new BusinessDocument();
        
        document.setDocumentId(rs.getInt("document_id"));
        document.setManagerId(rs.getInt("manager_id"));
        document.setBusinessLicense(rs.getString("business_license"));
        document.setTaxCode(rs.getString("tax_code"));
        document.setBusinessName(rs.getString("business_name"));
        document.setBusinessAddress(rs.getString("business_address"));
        document.setRepresentativeName(rs.getString("representative_name"));
        document.setRepresentativeId(rs.getString("representative_id"));
        document.setIdCardFront(rs.getString("id_card_front"));
        document.setIdCardBack(rs.getString("id_card_back"));
        document.setAdditionalDocuments(rs.getString("additional_documents"));
        document.setStatus(rs.getInt("status"));
        document.setAdminNote(rs.getString("admin_note"));
        document.setSubmittedAt(rs.getTimestamp("submitted_at"));
        document.setReviewedAt(rs.getTimestamp("reviewed_at"));
        
        // Handle reviewed_by - SQL Server compatible
        int reviewedByValue = rs.getInt("reviewed_by");
        if (rs.wasNull()) {
            document.setReviewedBy(null);
        } else {
            document.setReviewedBy(reviewedByValue);
        }
        
        // Manager info
        document.setManagerName(rs.getString("manager_name"));
        document.setManagerEmail(rs.getString("manager_email"));
        document.setManagerPhone(rs.getString("manager_phone"));
        
        // Admin info
        document.setAdminName(rs.getString("admin_name"));
        
        return document;
    }
}
