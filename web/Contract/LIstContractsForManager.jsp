<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý Hợp đồng - Manager Dashboard</title>
    <base href="${pageContext.request.contextPath}/">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link href="css/contracts.css" rel="stylesheet">
</head>
<body>
    <div class="container-fluid">
        <div class="row">
            <!-- Sidebar -->
            <div class="col-md-3 col-lg-2 px-0">
                <div class="sidebar p-3">
                    <div class="text-center mb-4">
                        <h4 class="text-white mb-0">
                            <i class="fas fa-building me-2"></i>
                            Manager Panel
                        </h4>
                    </div>
                    
                    <!-- User Info -->
                    <div class="text-center mb-4">
                        <i class="fas fa-user-circle fa-3x text-white mb-2"></i>
                        <h6 class="text-white mb-1">${currentUser.fullName}</h6>
                        <small class="text-white-50">Manager</small>
                    </div>
                    
                    <!-- Navigation -->
                    <nav class="nav flex-column">
                        <a class="nav-link" href="ManagerHomepage">
                            <i class="fas fa-tachometer-alt me-2"></i>
                            Dashboard
                        </a>
                        <a class="nav-link" href="listrooms">
                            <i class="fas fa-bed me-2"></i>
                            Quản lý Phòng
                        </a>
                        <a class="nav-link" href="listusers?role=3">
                            <i class="fas fa-users me-2"></i>
                            Quản lý Người thuê
                        </a>
                        <a class="nav-link active" href="listcontracts">
                            <i class="fas fa-file-contract me-2"></i>
                            Hợp đồng
                        </a>
                        <a class="nav-link" href="listbills">
                            <i class="fas fa-receipt me-2"></i>
                            Hóa đơn
                        </a>
                        <a class="nav-link" href="listdevices">
                            <i class="fas fa-tools me-2"></i>
                            Thiết bị
                        </a>
                        <a class="nav-link" href="listservices">
                            <i class="fas fa-concierge-bell me-2"></i>
                            Dịch vụ
                        </a>
                        <hr class="text-white-50">
                        <a class="nav-link" href="profile">
                            <i class="fas fa-user-cog me-2"></i>
                            Hồ sơ cá nhân
                        </a>
                        <a class="nav-link" href="logout">
                            <i class="fas fa-sign-out-alt me-2"></i>
                            Đăng xuất
                        </a>
                    </nav>
                </div>
            </div>
            
            <!-- Main Content -->
            <div class="col-md-9 col-lg-10">
                <div class="main-content p-4">
                    <!-- Header -->
                    <div class="d-flex justify-content-between align-items-center mb-4">
                        <div>
                            <h2 class="mb-1">
                                <i class="fas fa-file-contract me-3"></i>Danh sách hợp đồng trong hệ thống
                            </h2>
                            <p class="text-muted mb-0">Quản lý tất cả hợp đồng thuê phòng</p>
                        </div>
                    </div>

                    <!-- Alert Messages -->
                    <c:if test="${not empty sessionScope.successMessage}">
                        <div class="alert alert-success alert-dismissible fade show" role="alert">
                            <i class="fas fa-check-circle me-2"></i>
                            ${sessionScope.successMessage}
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </div>
                        <c:remove var="successMessage" scope="session"/>
                    </c:if>
                    
                    <c:if test="${not empty sessionScope.errorMessage}">
                        <div class="alert alert-danger alert-dismissible fade show" role="alert">
                            <i class="fas fa-exclamation-triangle me-2"></i>
                            ${sessionScope.errorMessage}
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </div>
                        <c:remove var="errorMessage" scope="session"/>
                    </c:if>

                    <!-- Statistics Card -->
                    <div class="row mb-4">
                        <div class="col-md-12">
                            <div class="card stats-card">
                                <div class="card-body text-center">
                                    <div class="row">
                                        <div class="col-md-4">
                                            <h3 class="mb-1">
                                                <c:choose>
                                                    <c:when test="${searchMode}">
                                                        ${contracts.size()}
                                                    </c:when>
                                                    <c:otherwise>
                                                        ${totalContracts}
                                                    </c:otherwise>
                                                </c:choose>
                                            </h3>
                                            <p class="mb-0">Tổng số hợp đồng</p>
                                        </div>
                                        <div class="col-md-4">
                                            <h3 class="mb-1">
                                                <c:choose>
                                                    <c:when test="${searchMode}">
                                                        1
                                                    </c:when>
                                                    <c:otherwise>
                                                        ${totalPages}
                                                    </c:otherwise>
                                                </c:choose>
                                            </h3>
                                            <p class="mb-0">Tổng số trang</p>
                                        </div>
                                        <div class="col-md-4">
                                            <h3 class="mb-1">
                                                <c:choose>
                                                    <c:when test="${searchMode}">
                                                        <i class="fas fa-search"></i>
                                                    </c:when>
                                                    <c:otherwise>
                                                        ${currentPage}
                                                    </c:otherwise>
                                                </c:choose>
                                            </h3>
                                            <p class="mb-0">
                                                <c:choose>
                                                    <c:when test="${searchMode}">Chế độ tìm kiếm</c:when>
                                                    <c:otherwise>Trang hiện tại</c:otherwise>
                                                </c:choose>
                                            </p>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Search Box -->
                    <div class="card mb-4">
                        <div class="card-body">
                            <form method="GET" action="${pageContext.request.contextPath}/listcontracts" class="mb-0">
                                <input type="hidden" name="action" value="search">
                                <div class="row align-items-center">
                                    <div class="col-md-8">
                                        <div class="search-box">
                                            <i class="fas fa-search text-muted me-2"></i>
                                            <input type="text" 
                                                   class="form-control border-0" 
                                                   name="keyword" 
                                                   placeholder="Nhập từ khóa tìm kiếm hợp đồng..."
                                                   value="${keyword}"
                                                   required>
                                        </div>
                                    </div>
                                    <div class="col-md-4">
                                        <div class="d-grid gap-2 d-md-flex">
                                            <button type="submit" class="btn btn-primary me-2">
                                                <i class="fas fa-search me-2"></i>Tìm kiếm
                                            </button>
                                            <c:if test="${searchMode}">
                                                <a href="${pageContext.request.contextPath}/listcontracts" 
                                                   class="btn btn-outline-secondary">
                                                    <i class="fas fa-times me-2"></i>Hủy
                                                </a>
                                            </c:if>
                                        </div>
                                    </div>
                                </div>
                            </form>
                        </div>
                    </div>

                    <!-- Search Results Info -->
                    <c:if test="${searchMode}">
                        <div class="alert alert-info">
                            <i class="fas fa-info-circle me-2"></i>
                            Tìm thấy <strong>${contracts.size()}</strong> hợp đồng với từ khóa: "<strong>${keyword}</strong>"
                        </div>
                    </c:if>

                    <!-- Contract List -->
                    <div class="card">
                        <div class="card-header bg-primary text-white">
                            <div class="row align-items-center">
                                <div class="col">
                                    <h5 class="mb-0">
                                        <i class="fas fa-list me-2"></i>
                                        <c:choose>
                                            <c:when test="${searchMode}">
                                                Kết quả tìm kiếm
                                            </c:when>
                                            <c:otherwise>
                                                Danh sách hợp đồng
                                                <c:if test="${not empty currentPage and not empty totalPages}">
                                                    (Trang ${currentPage}/${totalPages})
                                                </c:if>
                                            </c:otherwise>
                                        </c:choose>
                                    </h5>
                                </div>
                                <div class="col-auto">
                                    <a href="${pageContext.request.contextPath}/listcontracts?action=add" 
                                       class="btn btn-light">
                                        <i class="fas fa-plus me-2"></i>Thêm mới
                                    </a>
                                </div>
                            </div>
                        </div>
                        
                        <div class="card-body p-0">
                            <c:choose>
                                <c:when test="${empty contracts}">
                                    <div class="text-center py-5">
                                        <i class="fas fa-inbox fa-3x text-muted mb-3"></i>
                                        <h5 class="text-muted">
                                            <c:choose>
                                                <c:when test="${searchMode}">
                                                    Không tìm thấy hợp đồng nào với từ khóa "${keyword}"
                                                </c:when>
                                                <c:otherwise>
                                                    Chưa có hợp đồng nào trong hệ thống
                                                </c:otherwise>
                                            </c:choose>
                                        </h5>
                                        <c:if test="${not searchMode}">
                                            <a href="${pageContext.request.contextPath}/listcontracts?action=add" 
                                               class="btn btn-primary mt-3">
                                                <i class="fas fa-plus me-2"></i>Tạo hợp đồng đầu tiên
                                            </a>
                                        </c:if>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <div class="table-responsive">
                                        <table class="table table-hover mb-0">
                                            <thead>
                                                <tr>
                                                    <th scope="col" class="text-center" style="width: 80px;">#</th>
                                                    <th scope="col">
                                                        <i class="fas fa-home me-2"></i>Phòng
                                                    </th>
                                                    <th scope="col">
                                                        <i class="fas fa-user me-2"></i>Người thuê
                                                    </th>
                                                    <th scope="col">
                                                        <i class="fas fa-calendar me-2"></i>Ngày bắt đầu
                                                    </th>
                                                    <th scope="col">
                                                        <i class="fas fa-calendar-alt me-2"></i>Ngày kết thúc
                                                    </th>
                                                    <th scope="col">
                                                        <i class="fas fa-money-bill me-2"></i>Giá thuê
                                                    </th>
                                                    <th scope="col" class="text-center">
                                                        <i class="fas fa-info-circle me-2"></i>Trạng thái
                                                    </th>
                                                    <th scope="col" class="text-center" style="width: 200px;">
                                                        <i class="fas fa-cogs me-2"></i>Thao tác
                                                    </th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <c:forEach var="contract" items="${contracts}" varStatus="status">
                                                    <tr>
                                                        <td class="text-center align-middle">
                                                            <span class="badge bg-primary rounded-pill">
                                                                <c:choose>
                                                                    <c:when test="${searchMode}">
                                                                        ${status.index + 1}
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        ${(currentPage - 1) * contractsPerPage + status.index + 1}
                                                                    </c:otherwise>
                                                                </c:choose>
                                                            </span>
                                                        </td>
                                                        <td class="align-middle">
                                                            <div class="d-flex align-items-center">                                                                                                                                                      
                                                                <div>
                                                                    <h6 class="mb-0">Phòng ${contract.roomNumber}</h6>
                                                                    <small class="text-muted">Khu vực: ${contract.areaName}</small>
                                                                </div>
                                                            </div>
                                                        </td>
                                                        <td class="align-middle">
                                                            <h6 class="mb-0">${contract.nameTelnant}</h6>
                                                        </td>
                                                        <td class="align-middle">
                                                            <fmt:formatDate value="${contract.startDate}" pattern="dd/MM/yyyy"/>
                                                        </td>
                                                        <td class="align-middle">
                                                            <c:choose>
                                                                <c:when test="${contract.endDate != null}">
                                                                    <fmt:formatDate value="${contract.endDate}" pattern="dd/MM/yyyy"/>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <span class="text-muted">Chưa xác định</span>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </td>
                                                        <td class="align-middle">
                                                            <strong class="text-success">
                                                                <fmt:formatNumber value="${contract.rentPrice}" pattern="#,###"/> VNĐ
                                                            </strong>
                                                        </td>
                                                        <td class="text-center align-middle">
                                                            <c:choose>
                                                                <c:when test="${contract.status == 1}">
                                                                    <span class="badge status-badge status-active">Đang hoạt động</span>
                                                                </c:when>
                                                                <c:when test="${contract.status == 0}">
                                                                    <span class="badge status-badge status-pending">Không hoạt động</span>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <span class="badge status-badge bg-secondary">Không xác định</span>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </td>
                                                        <td class="text-center align-middle">
                                                            <div class="action-buttons">
                                                                <a href="${pageContext.request.contextPath}/listcontracts?action=view&id=${contract.contractId}" 
                                                                   class="btn btn-sm btn-outline-info" 
                                                                   title="Xem chi tiết">
                                                                    <i class="fas fa-eye"></i>
                                                                </a>
                                                                <a href="${pageContext.request.contextPath}/listcontracts?action=edit&id=${contract.contractId}" 
                                                                   class="btn btn-sm btn-outline-warning" 
                                                                   title="Chỉnh sửa">
                                                                    <i class="fas fa-edit"></i>
                                                                </a>
                                                                <button type="button" 
                                                                        class="btn btn-sm btn-outline-danger" 
                                                                        title="Xóa hợp đồng"
                                                                        onclick="confirmDelete(${contract.contractId}, 'Hợp đồng phòng ${contract.roomID}')">
                                                                    <i class="fas fa-trash"></i>
                                                                </button>
                                                            </div>
                                                        </td>
                                                    </tr>
                                                </c:forEach>
                                            </tbody>
                                        </table>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>

                    <!-- Pagination -->
                    <c:if test="${not searchMode and totalPages > 1}">
                        <nav aria-label="Phân trang hợp đồng" class="mt-4">
                            <ul class="pagination justify-content-center">
                                <!-- Previous Button -->
                                <c:if test="${currentPage > 1}">
                                    <li class="page-item">
                                        <a class="page-link" href="${pageContext.request.contextPath}/listcontracts?page=${currentPage - 1}">
                                            <i class="fas fa-chevron-left"></i>
                                        </a>
                                    </li>
                                </c:if>
                                
                                <!-- Page Numbers -->
                                <c:forEach begin="1" end="${totalPages}" var="pageNum">
                                    <c:choose>
                                        <c:when test="${pageNum == currentPage}">
                                            <li class="page-item active">
                                                <span class="page-link">${pageNum}</span>
                                            </li>
                                        </c:when>
                                        <c:otherwise>
                                            <li class="page-item">
                                                <a class="page-link" href="${pageContext.request.contextPath}/listcontracts?page=${pageNum}">
                                                    ${pageNum}
                                                </a>
                                            </li>
                                        </c:otherwise>
                                    </c:choose>
                                </c:forEach>
                                
                                <!-- Next Button -->
                                <c:if test ="${currentPage < totalPages}">
                                    <li class="page-item">
                                        <a class="page-link" href="${pageContext.request.contextPath}/listcontracts?page=${currentPage + 1}">
                                            <i class="fas fa-chevron-right"></i>
                                        </a>
                                    </li>
                                </c:if>
                            </ul>
                        </nav>
                    </c:if>

                    <!-- Page Info -->
                    <c:if test="${not searchMode and not empty contracts}">
                        <div class="text-center mt-3">
                            <small class="text-muted">
                                Hiển thị ${(currentPage - 1) * contractsPerPage + 1} - 
                                ${(currentPage - 1) * contractsPerPage + contracts.size()} 
                                trong tổng số ${totalContracts} hợp đồng
                            </small>
                        </div>
                    </c:if>
                </div>
            </div>
        </div>
    </div>

    <!-- Delete Confirmation Modal -->
    <div class="modal fade" id="deleteModal" tabindex="-1" aria-labelledby="deleteModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header bg-danger text-white">
                    <h5 class="modal-title" id="deleteModalLabel">
                        <i class="fas fa-exclamation-triangle me-2"></i>Xác nhận xóa
                    </h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <p>Bạn có chắc chắn muốn xóa <strong id="contractNameToDelete"></strong> không?</p>
                    <div class="alert alert-warning">
                        <i class="fas fa-info-circle me-2"></i>
                        <strong>Lưu ý:</strong> Thao tác này sẽ xóa hợp đồng và không thể hoàn tác.
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">
                        <i class="fas fa-times me-2"></i>Hủy
                    </button>
                    <a href="#" id="confirmDeleteBtn" class="btn btn-danger">
                        <i class="fas fa-trash me-2"></i>Xóa hợp đồng
                    </a>
                </div>
            </div>
        </div>
    </div>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    
    <script>
        // Confirm delete function
        function confirmDelete(contractId, contractName) {
            document.getElementById('contractNameToDelete').textContent = contractName;
            document.getElementById('confirmDeleteBtn').href = 
                '${pageContext.request.contextPath}/listcontracts?action=delete&id=' + contractId;
            
            const deleteModal = new bootstrap.Modal(document.getElementById('deleteModal'));
            deleteModal.show();
        }

        // Auto-hide alerts after 5 seconds
        document.addEventListener('DOMContentLoaded', function() {
            const alerts = document.querySelectorAll('.alert-dismissible');
            alerts.forEach(function(alert) {
                setTimeout(function() {
                    const bsAlert = new bootstrap.Alert(alert);
                    bsAlert.close();
                }, 5000);
            });
        });

        // Search form enhancement
        document.addEventListener('DOMContentLoaded', function() {
            const searchInput = document.querySelector('input[name="keyword"]');
            if (searchInput) {
                searchInput.addEventListener('keypress', function(e) {
                    if (e.key === 'Enter') {
                        this.form.submit();
                    }
                });
            }
        });

        // Add active class to current nav item
        document.addEventListener('DOMContentLoaded', function() {
            const currentPath = window.location.pathname;
            const navLinks = document.querySelectorAll('.nav-link');
            
            navLinks.forEach(link => {
                if (link.getAttribute('href') && currentPath.includes(link.getAttribute('href'))) {
                    link.classList.add('active');
                }
            });
        });
    </script>
    
</body>
</html>