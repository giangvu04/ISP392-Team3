<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý Thiết bị - Danh sách</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        .device-card {
            transition: transform 0.2s, box-shadow 0.2s;
        }
        .device-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(0,0,0,0.15);
        }
        .search-box {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            padding: 2rem;
            border-radius: 15px;
            margin-bottom: 2rem;
        }
        .action-buttons .btn {
            margin: 0 2px;
        }
        .page-header {
            background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
            color: white;
            padding: 2rem 0;
            margin-bottom: 2rem;
        }
        .stats-card {
            background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
            color: white;
            border: none;
        }
        .btn-gradient {
            background: linear-gradient(45deg, #667eea, #764ba2);
            border: none;
            color: white;
        }
        .btn-gradient:hover {
            background: linear-gradient(45deg, #764ba2, #667eea);
            color: white;
        }
        .table-responsive {
            border-radius: 10px;
            overflow: hidden;
            box-shadow: 0 0 20px rgba(0,0,0,0.1);
        }
        .alert {
            border-radius: 10px;
        }
        .pagination .page-link {
            border: none;
            margin: 0 2px;
            border-radius: 8px;
        }
        .pagination .page-item.active .page-link {
            background: linear-gradient(45deg, #667eea, #764ba2);
            border: none;
        }
    </style>
</head>
<body class="bg-light">
    <!-- Page Header -->
    <div class="page-header">
        <div class="container">
            <div class="row align-items-center">
                <div class="col-md-8">
                    <h1 class="mb-0">
                        <i class="fas fa-tv me-3"></i>Danh sách các thiết bị trong hệ thống
                    </h1>                   
                </div>
                <div class="col-md-4 text-end">
                     <p><a class="btn btn-light btn-lg" href="ManagerHomepage">Quay lại</a></p>
                </div>
            </div>
        </div>
    </div>

    <div class="container">
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
                                            ${devices.size()}
                                        </c:when>
                                        <c:otherwise>
                                            ${totalDevices}
                                        </c:otherwise>
                                    </c:choose>
                                </h3>
                                <p class="mb-0">Tổng số thiết bị</p>
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
        <div class="search-box">
            <form method="GET" action="${pageContext.request.contextPath}/listdevices" class="mb-0">
                <input type="hidden" name="action" value="search">
                <div class="row align-items-center">
                    <div class="col-md-8">
                        <div class="input-group">
                            <span class="input-group-text bg-white border-0">
                                <i class="fas fa-search text-muted"></i>
                            </span>
                            <input type="text" 
                                   class="form-control form-control-lg border-0" 
                                   name="keyword" 
                                   placeholder="Nhập tên thiết bị cần tìm..."
                                   value="${keyword}"
                                   required>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="d-grid gap-2 d-md-flex">
                            <button type="submit" class="btn btn-light btn-lg me-2">
                                <i class="fas fa-search me-2"></i>Tìm kiếm
                            </button>
                            <c:if test="${searchMode}">
                                <a href="${pageContext.request.contextPath}/listdevices" 
                                   class="btn btn-outline-light btn-lg">
                                    <i class="fas fa-times me-2"></i>Hủy
                                </a>
                            </c:if>
                        </div>
                    </div>
                </div>
            </form>
        </div>

        <!-- Search Results Info -->
        <c:if test="${searchMode}">
            <div class="alert alert-info">
                <i class="fas fa-info-circle me-2"></i>
                Tìm thấy <strong>${devices.size()}</strong> thiết bị với từ khóa: "<strong>${keyword}</strong>"
            </div>
        </c:if>

        <!-- Device List -->
        <div class="card">
            <div class="card-header bg-white">
                <div class="row align-items-center">
                    <div class="col">
                        <h5 class="mb-0">
                            <i class="fas fa-list me-2 text-primary"></i>
                            <c:choose>
                                <c:when test="${searchMode}">
                                    Kết quả tìm kiếm
                                </c:when>
                                <c:otherwise>
                                    Danh sách thiết bị
                                    <c:if test="${not empty currentPage and not empty totalPages}">
                                        (Trang ${currentPage}/${totalPages})
                                    </c:if>
                                </c:otherwise>
                            </c:choose>
                        </h5>
                    </div>
                    <div class="col-auto">
                        <a href="${pageContext.request.contextPath}/listdevices?action=add" 
                           class="btn btn-gradient">
                            <i class="fas fa-plus me-2"></i>Thêm mới
                        </a>
                    </div>
                </div>
            </div>
            
            <div class="card-body p-0">
                <c:choose>
                    <c:when test="${empty devices}">
                        <div class="text-center py-5">
                            <i class="fas fa-inbox fa-3x text-muted mb-3"></i>
                            <h5 class="text-muted">
                                <c:choose>
                                    <c:when test="${searchMode}">
                                        Không tìm thấy thiết bị nào với từ khóa "${keyword}"
                                    </c:when>
                                    <c:otherwise>
                                        Chưa có thiết bị nào trong hệ thống
                                    </c:otherwise>
                                </c:choose>
                            </h5>
                            <c:if test="${not searchMode}">
                                <a href="${pageContext.request.contextPath}/listdevices?action=add" 
                                   class="btn btn-gradient mt-3">
                                    <i class="fas fa-plus me-2"></i>Thêm thiết bị đầu tiên
                                </a>
                            </c:if>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <div class="table-responsive">
                            <table class="table table-hover mb-0">
                                <thead class="table-dark">
                                    <tr>
                                        <th scope="col" class="text-center" style="width: 80px;">#</th>
                                        <th scope="col">
                                            <i class="fas fa-tv me-2"></i>Tên thiết bị
                                        </th>
                                        <th scope="col">
                                            <i class="fas fa-tv me-2"></i>Mã máy
                                        </th>
                                        <th scope="col">
                                            <i class="fas fa-tv me-2"></i>Ngày mua
                                        </th>
                                        <th scope="col" class="text-center" style="width: 200px;">
                                            <i class="fas fa-cogs me-2"></i>Thao tác
                                        </th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="device" items="${devices}" varStatus="status">
                                        <tr>
                                            <td class="text-center align-middle">
                                                <span class="badge bg-primary rounded-pill">
                                                    <c:choose>
                                                        <c:when test="${searchMode}">
                                                            ${status.index + 1}
                                                        </c:when>
                                                        <c:otherwise>
                                                            ${(currentPage - 1) * devicesPerPage + status.index + 1}
                                                        </c:otherwise>
                                                    </c:choose>
                                                </span>
                                            </td>
                                            <td class="align-middle">
                                                <div class="d-flex align-items-center">                                                                                                                                                      
                                                    <div>
                                                        <h6 class="mb-0">${device.deviceName}</h6>
                                                        <small class="text-muted">ID: ${device.deviceId}</small>
                                                    </div>
                                                </div>
                                            </td>
                                            <td class="align-middle">
                                                <div class="d-flex align-items-center">                                                                                                                                                      
                                                    <div>
                                                        
                                                        <h6 class="text-muted">ID: ${device.deviceCode}</small>
                                                    </div>
                                                </div>
                                            </td>
                                            <td class="align-middle">
                                                <div class="d-flex align-items-center">                                                                                                                                                      
                                                    <div>
                                                        
                                                        <h6 class="text-muted">ID: ${device.purchaseDate}</small>
                                                    </div>
                                                </div>
                                            </td>
                                            <td class="text-center align-middle">
                                                <div class="action-buttons">
                                                    <a href="${pageContext.request.contextPath}/listdevices?action=view&id=${device.deviceId}" 
                                                       class="btn btn-sm btn-outline-info" 
                                                       title="Xem chi tiết">
                                                        <i class="fas fa-eye"></i>
                                                    </a>
                                                    <a href="${pageContext.request.contextPath}/listdevices?action=edit&id=${device.deviceId}" 
                                                       class="btn btn-sm btn-outline-warning" 
                                                       title="Chỉnh sửa">
                                                        <i class="fas fa-edit"></i>
                                                    </a>
                                                    <button type="button" 
                                                            class="btn btn-sm btn-outline-danger" 
                                                            title="Xóa thiết bị"
                                                            onclick="confirmDelete(${device.deviceId}, '${device.deviceName}')">
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
            <div class="d-flex justify-content-center mt-4">
                <nav aria-label="Phân trang thiết bị">
                    <ul class="pagination pagination-lg">
                        <!-- Previous Button -->
                        <c:if test="${currentPage > 1}">
                            <li class="page-item">
                                <a class="page-link" href="${pageContext.request.contextPath}/listdevices?page=${currentPage - 1}">
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
                                        <a class="page-link" href="${pageContext.request.contextPath}/listdevices?page=${pageNum}">
                                            ${pageNum}
                                        </a>
                                    </li>
                                </c:otherwise>
                            </c:choose>
                        </c:forEach>
                        
                        <!-- Next Button -->
                        <c:if test="${currentPage < totalPages}">
                            <li class="page-item">
                                <a class="page-link" href="${pageContext.request.contextPath}/listdevices?page=${currentPage + 1}">
                                    <i class="fas fa-chevron-right"></i>
                                </a>
                            </li>
                        </c:if>
                    </ul>
                </nav>
            </div>
        </c:if>

        <!-- Page Info -->
        <c:if test="${not searchMode and not empty devices}">
            <div class="text-center mt-3">
                <small class="text-muted">
                    Hiển thị ${(currentPage - 1) * devicesPerPage + 1} - 
                    ${(currentPage - 1) * devicesPerPage + devices.size()} 
                    trong tổng số ${totalDevices} thiết bị
                </small>
            </div>
        </c:if>
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
                    <p>Bạn có chắc chắn muốn xóa thiết bị <strong id="deviceNameToDelete"></strong> không?</p>
                    <div class="alert alert-warning">
                        <i class="fas fa-info-circle me-2"></i>
                        <strong>Lưu ý:</strong> Thao tác này sẽ đánh dấu thiết bị là đã xóa và không thể hoàn tác.
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">
                        <i class="fas fa-times me-2"></i>Hủy
                    </button>
                    <a href="#" id="confirmDeleteBtn" class="btn btn-danger">
                        <i class="fas fa-trash me-2"></i>Xóa thiết bị
                    </a>
                </div>
            </div>
        </div>
    </div>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    
    <script>
        // Confirm delete function
        function confirmDelete(deviceId, deviceName) {
            document.getElementById('deviceNameToDelete').textContent = deviceName;
            document.getElementById('confirmDeleteBtn').href = 
                '${pageContext.request.contextPath}/listdevices?action=delete&id=' + deviceId;
            
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
    </script>
    
</body>
</html>