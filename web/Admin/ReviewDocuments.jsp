<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Duyệt Hồ Sơ Manager - Admin Panel</title>
    <base href="${pageContext.request.contextPath}/">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link href="css/homepage.css" rel="stylesheet">
    <style>
        .document-card {
            transition: all 0.3s ease;
        }
        .document-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
        }
        .image-preview {
            cursor: pointer;
            transition: transform 0.2s;
        }
        .image-preview:hover {
            transform: scale(1.05);
        }
    </style>
</head>
<body>
    <div class="container-fluid">
        <div class="row">
            <jsp:include page="../Sidebar/SideBarAdmin.jsp"/>

            <!-- Main Content -->
            <div class="col-md-9 col-lg-10">
                <div class="main-content p-4">
                    
                    <!-- Page Header -->
                    <div class="d-flex justify-content-between align-items-center mb-4">
                        <div>
                            <h2 class="mb-1">
                                <i class="fas fa-file-check text-primary me-2"></i>
                                Duyệt Hồ Sơ Manager
                            </h2>
                            <p class="text-muted mb-0">Xem xét và phê duyệt các hồ sơ đăng ký từ Manager</p>
                        </div>
                        <div class="text-end">
                            <small class="text-muted">
                                <i class="fas fa-clock me-1"></i>
                                Cập nhật: <fmt:formatDate value="${now}" pattern="dd/MM/yyyy HH:mm"/>
                            </small>
                        </div>
                    </div>
                    
                    <!-- Alert Messages -->
                    <c:if test="${not empty sessionScope.message}">
                        <div class="alert alert-success alert-dismissible fade show" role="alert">
                            <i class="fas fa-check-circle me-2"></i>
                            ${sessionScope.message}
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </div>
                        <c:remove var="message" scope="session"/>
                    </c:if>
    
    <!-- Filter & Search -->
    <div class="card mb-4">
        <div class="card-body">
            <form method="GET" action="reviewDocuments">
                <div class="row g-3">
                    <div class="col-md-4">
                        <label class="form-label">Tìm kiếm</label>
                        <div class="input-group">
                            <span class="input-group-text">
                                <i class="fas fa-search"></i>
                            </span>
                            <input type="text" class="form-control" name="search" 
                                   value="${param.search}" placeholder="Tên doanh nghiệp, tên manager, email...">
                        </div>
                    </div>
                    <div class="col-md-3">
                        <label class="form-label">Trạng thái</label>
                        <select name="status" class="form-select">
                            <option value="">Tất cả</option>
                            <option value="0" ${param.status == '0' ? 'selected' : ''}>Chờ duyệt</option>
                            <option value="1" ${param.status == '1' ? 'selected' : ''}>Đã duyệt</option>
                            <option value="2" ${param.status == '2' ? 'selected' : ''}>Từ chối</option>
                        </select>
                    </div>
                    <div class="col-md-3">
                        <label class="form-label">&nbsp;</label>
                        <div class="d-flex gap-2">
                            <button type="submit" class="btn btn-primary">
                                <i class="fas fa-filter me-1"></i>Lọc
                            </button>
                            <a href="reviewDocuments" class="btn btn-outline-secondary">
                                <i class="fas fa-refresh me-1"></i>Reset
                            </a>
                        </div>
                    </div>
                </div>
            </form>
        </div>
    </div>
    
    <!-- Documents -->
    <c:forEach var="doc" items="${docs}">
        <div class="card mb-3">
            <div class="card-header d-flex justify-content-between">
                <h5>${doc.businessName}</h5>
                <c:choose>
                    <c:when test="${doc.status == 0}">
                        <span class="badge bg-warning">Chờ duyệt</span>
                    </c:when>
                    <c:when test="${doc.status == 1}">
                        <span class="badge bg-success">Đã duyệt</span>
                    </c:when>
                    <c:otherwise>
                        <span class="badge bg-danger">Từ chối</span>
                    </c:otherwise>
                </c:choose>
            </div>
            <div class="card-body">
                <div class="row">
                    <div class="col-md-6">
                        <p><strong>Manager:</strong> ${doc.managerName}</p>
                        <p><strong>Email:</strong> ${doc.managerEmail}</p>
                        <p><strong>Mã số thuế:</strong> ${doc.taxCode}</p>
                        <p><strong>Người đại diện:</strong> ${doc.representativeName}</p>
                        <p><strong>CMND:</strong> ${doc.representativeId}</p>
                        <p><strong>Địa chỉ:</strong> ${doc.businessAddress}</p>
                    </div>
                    <div class="col-md-6">
                        <p><strong>Tài liệu:</strong></p>
                        <div class="d-flex flex-wrap">
                            <c:if test="${not empty doc.businessLicense}">
                                <img src="${doc.businessLicense}" 
                                     class="img-thumbnail me-2 mb-2" style="width: 100px; height: 100px; object-fit: cover;"
                                     onclick="showImage(this.src)" data-bs-toggle="modal" data-bs-target="#imageModal">
                            </c:if>
                            <c:if test="${not empty doc.idCardFront}">
                                <img src="${doc.idCardFront}" 
                                     class="img-thumbnail me-2 mb-2" style="width: 100px; height: 100px; object-fit: cover;"
                                     onclick="showImage(this.src)" data-bs-toggle="modal" data-bs-target="#imageModal">
                            </c:if>
                            <c:if test="${not empty doc.idCardBack}">
                                <img src="${doc.idCardBack}" 
                                     class="img-thumbnail me-2 mb-2" style="width: 100px; height: 100px; object-fit: cover;"
                                     onclick="showImage(this.src)" data-bs-toggle="modal" data-bs-target="#imageModal">
                            </c:if>
                        </div>
                    </div>
                </div>
                
                <c:if test="${not empty doc.adminNote}">
                    <div class="alert alert-info mt-3">
                        <strong>Ghi chú admin:</strong> ${doc.adminNote}
                    </div>
                </c:if>
                
                <c:if test="${doc.status == 0}">
                    <div class="mt-3">
                        <button class="btn btn-success me-2" onclick="approve(${doc.documentId})">
                            <i class="fas fa-check"></i> Phê duyệt
                        </button>
                        <button class="btn btn-danger" onclick="reject(${doc.documentId})">
                            <i class="fas fa-times"></i> Từ chối
                        </button>
                    </div>
                </c:if>
            </div>
        </div>
    </c:forEach>
    
    <c:if test="${empty docs}">
        <div class="text-center py-5">
            <i class="fas fa-folder-open fa-4x text-muted mb-3"></i>
            <h4>Không có hồ sơ nào</h4>
        </div>
    </c:if>
    
    <!-- Pagination -->
    <c:if test="${not empty docs}">
        <nav aria-label="Page navigation">
            <ul class="pagination justify-content-center">
                <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                    <a class="page-link" href="?page=${currentPage - 1}&status=${param.status}&search=${param.search}">
                        <i class="fas fa-chevron-left"></i> Trước
                    </a>
                </li>
                
                <c:forEach begin="1" end="${totalPages}" var="i">
                    <li class="page-item ${currentPage == i ? 'active' : ''}">
                        <a class="page-link" href="?page=${i}&status=${param.status}&search=${param.search}">${i}</a>
                    </li>
                </c:forEach>
                
                <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                    <a class="page-link" href="?page=${currentPage + 1}&status=${param.status}&search=${param.search}">
                        Sau <i class="fas fa-chevron-right"></i>
                    </a>
                </li>
            </ul>
        </nav>
        
        <div class="text-center text-muted">
            Hiển thị ${(currentPage - 1) * pageSize + 1} - ${currentPage * pageSize > totalRecords ? totalRecords : currentPage * pageSize} 
            trên tổng ${totalRecords} hồ sơ
            <c:if test="${not empty param.search}">
                <span class="text-primary">(tìm kiếm: "${param.search}")</span>
            </c:if>
        </div>
    </c:if>
    
                </div>
            </div>
        </div>
    </div>

<!-- Image Modal -->
<div class="modal fade" id="imageModal" tabindex="-1">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-body text-center">
                <img id="modalImage" src="" class="img-fluid">
            </div>
        </div>
    </div>
</div>

<!-- Action Modal -->
<div class="modal fade" id="actionModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <form method="POST" action="reviewDocuments">
                <div class="modal-header">
                    <h5 id="modalTitle">Xác nhận</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <input type="hidden" name="action" id="modalAction">
                    <input type="hidden" name="documentId" id="modalDocId">
                    <div class="mb-3">
                        <label class="form-label">Ghi chú:</label>
                        <textarea name="adminNote" class="form-control" rows="3" id="modalNote"></textarea>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                    <button type="submit" class="btn" id="modalSubmitBtn">Xác nhận</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
function showImage(src) {
    document.getElementById('modalImage').src = src;
}

function approve(docId) {
    document.getElementById('modalTitle').textContent = 'Phê duyệt hồ sơ';
    document.getElementById('modalAction').value = 'approve';
    document.getElementById('modalDocId').value = docId;
    document.getElementById('modalNote').placeholder = 'Ghi chú phê duyệt (tùy chọn)';
    document.getElementById('modalNote').required = false;
    document.getElementById('modalSubmitBtn').className = 'btn btn-success';
    document.getElementById('modalSubmitBtn').textContent = 'Phê duyệt';
    new bootstrap.Modal(document.getElementById('actionModal')).show();
}

function reject(docId) {
    document.getElementById('modalTitle').textContent = 'Từ chối hồ sơ';
    document.getElementById('modalAction').value = 'reject';
    document.getElementById('modalDocId').value = docId;
    document.getElementById('modalNote').placeholder = 'Lý do từ chối (bắt buộc)';
    document.getElementById('modalNote').required = true;
    document.getElementById('modalSubmitBtn').className = 'btn btn-danger';
    document.getElementById('modalSubmitBtn').textContent = 'Từ chối';
    new bootstrap.Modal(document.getElementById('actionModal')).show();
}

// Auto-hide alerts after 5 seconds
setTimeout(function () {
    const alerts = document.querySelectorAll('.alert');
    alerts.forEach(function (alert) {
        const bsAlert = new bootstrap.Alert(alert);
        bsAlert.close();
    });
}, 5000);
</script>

<jsp:include page="../Message.jsp"/>
</body>
</html>
