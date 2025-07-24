package model;

import java.sql.Timestamp;

/**
 * Model class for business_documents table
 * Dùng để lưu giấy tờ kinh doanh của manager chờ super admin duyệt
 */
public class BusinessDocument {
    private int documentId;
    private int managerId;
    private String businessLicense;
    private String taxCode;
    private String businessName;
    private String businessAddress;
    private String representativeName;
    private String representativeId;
    private String idCardFront;
    private String idCardBack;
    private String additionalDocuments;
    private int status; // 0: Chờ duyệt, 1: Đã duyệt, 2: Từ chối
    private String adminNote;
    private Timestamp submittedAt;
    private Timestamp reviewedAt;
    private Integer reviewedBy;
    
    // Manager information (từ JOIN với users table)
    private String managerName;
    private String managerEmail;
    private String managerPhone;
    
    // Admin information (từ JOIN với users table)
    private String adminName;

    // Constructors
    public BusinessDocument() {}

    public BusinessDocument(int managerId, String businessLicense, String taxCode, 
                          String businessName, String businessAddress, String representativeName,
                          String representativeId, String idCardFront, String idCardBack) {
        this.managerId = managerId;
        this.businessLicense = businessLicense;
        this.taxCode = taxCode;
        this.businessName = businessName;
        this.businessAddress = businessAddress;
        this.representativeName = representativeName;
        this.representativeId = representativeId;
        this.idCardFront = idCardFront;
        this.idCardBack = idCardBack;
        this.status = 0; // Default: Chờ duyệt
    }

    // Getters and Setters
    public int getDocumentId() { return documentId; }
    public void setDocumentId(int documentId) { this.documentId = documentId; }

    public int getManagerId() { return managerId; }
    public void setManagerId(int managerId) { this.managerId = managerId; }

    public String getBusinessLicense() { return businessLicense; }
    public void setBusinessLicense(String businessLicense) { this.businessLicense = businessLicense; }

    public String getTaxCode() { return taxCode; }
    public void setTaxCode(String taxCode) { this.taxCode = taxCode; }

    public String getBusinessName() { return businessName; }
    public void setBusinessName(String businessName) { this.businessName = businessName; }

    public String getBusinessAddress() { return businessAddress; }
    public void setBusinessAddress(String businessAddress) { this.businessAddress = businessAddress; }

    public String getRepresentativeName() { return representativeName; }
    public void setRepresentativeName(String representativeName) { this.representativeName = representativeName; }

    public String getRepresentativeId() { return representativeId; }
    public void setRepresentativeId(String representativeId) { this.representativeId = representativeId; }

    public String getIdCardFront() { return idCardFront; }
    public void setIdCardFront(String idCardFront) { this.idCardFront = idCardFront; }

    public String getIdCardBack() { return idCardBack; }
    public void setIdCardBack(String idCardBack) { this.idCardBack = idCardBack; }

    public String getAdditionalDocuments() { return additionalDocuments; }
    public void setAdditionalDocuments(String additionalDocuments) { this.additionalDocuments = additionalDocuments; }

    public int getStatus() { return status; }
    public void setStatus(int status) { this.status = status; }

    public String getAdminNote() { return adminNote; }
    public void setAdminNote(String adminNote) { this.adminNote = adminNote; }

    public Timestamp getSubmittedAt() { return submittedAt; }
    public void setSubmittedAt(Timestamp submittedAt) { this.submittedAt = submittedAt; }

    public Timestamp getReviewedAt() { return reviewedAt; }
    public void setReviewedAt(Timestamp reviewedAt) { this.reviewedAt = reviewedAt; }

    public Integer getReviewedBy() { return reviewedBy; }
    public void setReviewedBy(Integer reviewedBy) { this.reviewedBy = reviewedBy; }

    // Manager info getters/setters
    public String getManagerName() { return managerName; }
    public void setManagerName(String managerName) { this.managerName = managerName; }

    public String getManagerEmail() { return managerEmail; }
    public void setManagerEmail(String managerEmail) { this.managerEmail = managerEmail; }

    public String getManagerPhone() { return managerPhone; }
    public void setManagerPhone(String managerPhone) { this.managerPhone = managerPhone; }

    // Admin info getters/setters
    public String getAdminName() { return adminName; }
    public void setAdminName(String adminName) { this.adminName = adminName; }

    // Utility methods
    public String getStatusText() {
        switch (status) {
            case 0: return "Chờ duyệt";
            case 1: return "Đã duyệt";
            case 2: return "Từ chối";
            default: return "Không xác định";
        }
    }
    
    public String getStatusBadgeClass() {
        switch (status) {
            case 0: return "badge bg-warning text-dark";
            case 1: return "badge bg-success";
            case 2: return "badge bg-danger";
            default: return "badge bg-secondary";
        }
    }

    public boolean isPending() { return status == 0; }
    public boolean isApproved() { return status == 1; }
    public boolean isRejected() { return status == 2; }

    @Override
    public String toString() {
        return "BusinessDocument{" +
                "documentId=" + documentId +
                ", managerId=" + managerId +
                ", businessName='" + businessName + '\'' +
                ", taxCode='" + taxCode + '\'' +
                ", status=" + status +
                ", submittedAt=" + submittedAt +
                '}';
    }
}
