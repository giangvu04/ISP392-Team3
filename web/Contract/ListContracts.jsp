<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Hợp đồng của tôi</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        .contract-card {
            transition: transform 0.2s, box-shadow 0.2s;
            border: none;
            border-radius: 15px;
            overflow: hidden;
        }
        .contract-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 25px rgba(0,0,0,0.15);
        }
        .search-box {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            padding: 2rem;
            border-radius: 15px;
            margin-bottom: 2rem;
        }
        .page-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 3rem 0;
            margin-bottom: 2rem;
            position: relative;
            overflow: hidden;
        }
        .page-header::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: url('data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100"><defs><pattern id="grain" width="100" height="100" patternUnits="userSpaceOnUse"><circle cx="50" cy="50" r="1" fill="white" opacity="0.1"/></pattern></defs><rect width="100" height="100" fill="url(%23grain)"/></svg>');
        }
        .stats-card {
            background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
            color: white;
            border: none;
            border-radius: 15px;
            overflow: hidden;
        }
        .btn-gradient {
            background: linear-gradient(45deg, #667eea, #764ba2);
            border: none;
            color: white;
            border-radius: 25px;
            padding: 0.5rem 1.5rem;
            transition: all 0.3s ease;
        }
        .btn-gradient:hover {
            background: linear-gradient(45deg, #764ba2, #667eea);
            color: white;
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(0,0,0,0.2);
        }
        .contract-status {
            position: absolute;
            top: 1rem;
            right: 1rem;
            z-index: 10;
        }
        .status-badge {
            font-size: 0.75rem;
            padding: 0.4rem 0.8rem;
            border-radius: 20px;
            font-weight: 600;
        }
        .status-active {
            background: linear-gradient(45deg, #28a745, #20c997);
            color: white;
        }
        .status-expired {
            background: linear-gradient(45deg, #dc3545, #e74c3c);
            color: white;
        }
        .status-pending {
            background: linear-gradient(45deg, #ffc107, #fd7e14);
            color: white;
        }
        .contract-info {
            background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
        }
        .info-item {
            border-left: 4px solid #667eea;
            padding-left: 1rem;
            margin-bottom: 1rem;
        }
        .info-label {
            font-size: 0.85rem;
            color: #6c757d;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        .info-value {
            font-size: 1.1rem;
            font-weight: 700;
            color: #495057;
            margin-top: 0.2rem;
        }
        .empty-state {
            padding: 4rem 2rem;
            text-align: center;
            background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
            border-radius: 20px;
            margin: 2rem 0;
        }
        .empty-icon {
            font-size: 4rem;
            color: #adb5bd;
            margin-bottom: 1rem;
        }
        .pagination .page-link {
            border: none;
            margin: 0 2px;
            border-radius: 8px;
            color: #667eea;
        }
        .pagination .page-item.active .page-link {
            background: linear-gradient(45deg, #667eea, #764ba2);
            border: none;
        }
        .alert {
            border-radius: 15px;
            border: none;
        }
        .welcome-section {
            background: white;
            border-radius: 20px;
            padding: 2rem;
            margin-bottom: 2rem;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
        }
        .filter-section {
            background: white;
            border-radius: 15px;
            padding: 1.5rem;
            margin-bottom: 2rem;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        .filter-btn {
            margin: 0.25rem;
            border-radius: 20px;
            padding: 0.5rem 1rem;
            font-size: 0.9rem;
            transition: all 0.3s ease;
        }
        .filter-btn.active {
            background: linear-gradient(45deg, #667eea, #764ba2);
            color: white;
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
                        <i class="fas fa-file-contract me-3"></i>Hợp đồng của tôi
                    </h1>
                    <p class="mb-0 mt-2 opacity-75">Xem và quản lý các hợp đồng thuê phòng</p>
                </div>
                <div class="col-md-4 text-end">
                    <a class="btn btn-light btn-lg" href="TenantHomepage">
                        <i class="fas fa-home me-2"></i>Trang chủ
                    </a>
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

        <!-- Welcome Section -->
        <div class="welcome-section">
            <div class="row align-items-center">
                <div class="col-md-8">
                    <h4 class="text-primary mb-1">
                        <i class="fas fa-user-circle me-2"></i>Chào mừng trở lại!
                    </h4>
                    <p class="text-muted mb-0">Dưới đây là danh sách tất cả hợp đồng thuê phòng của bạn</p>
                </div>
                <div class="col-md-4 text-end">
                    <div class="d-flex justify-content-end align-items-center">
                        <div class="me-3">
                            <small class="text-muted d-block">Tổng hợp đồng</small>
                            <h3 class="text-primary mb-0">
                                <c:choose>
                                    <c:when test="${searchMode or statusMode}">
                                        ${contracts.size()}
                                    </c:when>
                                    <c:otherwise>
                                        ${totalContracts}
                                    </c:otherwise>
                                </c:choose>
                            </h3>
                        </div>
                        <i class="fas fa-chart-bar fa-2x text-primary opacity-50"></i>
                    </div>
                </div>
            </div>
        </div>

        <!-- Filter Section -->
        <div class="filter-section">
            <div class="row align-items-center">
                <div class="col-md-6">
                    <h6 class="mb-0">
                        <i class="fas fa-filter me-2"></i>Lọc theo trạng thái:
                    </h6>
                </div>
                <div class="col-md-6">
                    <div class="text-end">
                        <a href="${pageContext.request.contextPath}/mycontract" 
                           class="btn btn-outline-primary filter-btn ${empty param.status ? 'active' : ''}">
                            <i class="fas fa-th me-1"></i>Tất cả
                        </a>
                        <a href="${pageContext.request.contextPath}/mycontract?action=status&status=1" 
                           class="btn btn-outline-success filter-btn ${param.status == '1' ? 'active' : ''}">
                            <i class="fas fa-check-circle me-1"></i>Đang hoạt động
                        </a>
                        <a href="${pageContext.request.contextPath}/mycontract?action=status&status=0" 
                           class="btn btn-outline-warning filter-btn ${param.status == '0' ? 'active' : ''}">
                            <i class="fas fa-clock me-1"></i>Chờ xử lý
                        </a>
                        <a href="${pageContext.request.contextPath}/mycontract?action=status&status=2" 
                           class="btn btn-outline-danger filter-btn ${param.status == '2' ? 'active' : ''}">
                            <i class="fas fa-times-circle me-1"></i>Đã hết hạn
                        </a>
                    </div>
                </div>
            </div>
        </div>

        <!-- Search Box -->
        <div class="search-box">
            <form method="GET" action="${pageContext.request.contextPath}/mycontract" class="mb-0">
                <input type="hidden" name="action" value="search">
                <div class="row align-items-center">
                    <div class="col-md-8">
                        <div class="input-group input-group-lg">
                            <span class="input-group-text bg-white border-0">
                                <i class="fas fa-search text-muted"></i>
                            </span>
                            <input type="text" 
                                   class="form-control border-0" 
                                   name="keyword" 
                                   placeholder="Tìm kiếm theo mã phòng, ngày ký hợp đồng..."
                                   value="${keyword}">
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="d-grid gap-2 d-md-flex">
                            <button type="submit" class="btn btn-light btn-lg me-2">
                                <i class="fas fa-search me-2"></i>Tìm kiếm
                            </button>
                            <c:if test="${searchMode}">
                                <a href="${pageContext.request.contextPath}/mycontract" 
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
                Tìm thấy <strong>${contracts.size()}</strong> hợp đồng với từ khóa: "<strong>${keyword}</strong>"
            </div>
        </c:if>

        <!-- Status Filter Results Info -->
        <c:if test="${statusMode}">
            <div class="alert alert-info">
                <i class="fas fa-info-circle me-2"></i>
                Hiển thị <strong>${contracts.size()}</strong> hợp đồng với trạng thái: 
                <strong>
                    <c:choose>
                        <c:when test="${status == 1}">Đang hoạt động</c:when>
                        <c:when test="${status == 0}">Không hoạt động</c:when>
                        <%-- <c:when test="${status == 2}">Đã hết hạn</c:when> --%>
                        <c:otherwise>Không xác định</c:otherwise>
                    </c:choose>
                </strong>
            </div>
        </c:if>

        <!-- Contract List -->
        <c:choose>
            <c:when test="${empty contracts}">
                <div class="empty-state">
                    <div class="empty-icon">
                        <i class="fas fa-file-contract"></i>
                    </div>
                    <h3 class="text-muted mb-3">
                        <c:choose>
                            <c:when test="${searchMode}">
                                Không tìm thấy hợp đồng nào
                            </c:when>
                            <c:when test="${statusMode}">
                                Không có hợp đồng nào với trạng thái này
                            </c:when>
                            <c:otherwise>
                                Bạn chưa có hợp đồng nào
                            </c:otherwise>
                        </c:choose>
                    </h3>
                    <p class="text-muted">
                        <c:choose>
                            <c:when test="${searchMode}">
                                Thử tìm kiếm với từ khóa khác hoặc liên hệ với quản lý để biết thêm thông tin
                            </c:when>
                            <c:when test="${statusMode}">
                                Thử lọc với trạng thái khác hoặc xem tất cả hợp đồng
                            </c:when>
                            <c:otherwise>
                                Liên hệ với quản lý để đăng ký thuê phòng và tạo hợp đồng
                            </c:otherwise>
                        </c:choose>
                    </p>
                    <c:if test="${searchMode or statusMode}">
                        <a href="${pageContext.request.contextPath}/mycontract" class="btn btn-gradient mt-3">
                            <i class="fas fa-arrow-left me-2"></i>Xem tất cả hợp đồng
                        </a>
                    </c:if>
                </div>
            </c:when>
            <c:otherwise>
                <div class="row">
                    <c:forEach var="contract" items="${contracts}" varStatus="status">
                        <div class="col-lg-6 col-xl-4 mb-4">
                            <div class="card contract-card h-100">
                                <!-- Status Badge -->
                                <div class="contract-status">
                                    <c:choose>
                                        <c:when test="${contract.status == 1}">
                                            <span class="badge status-badge status-active">
                                                <i class="fas fa-check-circle me-1"></i>Đang hoạt động
                                            </span>
                                        </c:when>
                                        <c:when test="${contract.status == 2}">
                                            <span class="badge status-badge status-expired">
                                                <i class="fas fa-times-circle me-1"></i>Đã hết hạn
                                            </span>
                                        </c:when>
                                        <c:when test="${contract.status == 0}">
                                            <span class="badge status-badge status-pending">
                                                <i class="fas fa-clock me-1"></i>Không hoạt động
                                            </span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge status-badge bg-secondary">
                                                <i class="fas fa-question-circle me-1"></i>Không xác định
                                            </span>
                                        </c:otherwise>
                                    </c:choose>
                                </div>

                                <!-- Card Header -->
                                <div class="card-header bg-primary text-white">
                                    <div class="d-flex align-items-center">
                                        <i class="fas fa-home fa-2x me-3"></i>
                                        <div>
                                            <h5 class="mb-0">Phòng ${contract.roomID}</h5>
                                            <small class="opacity-75">Mã hợp đồng: #${contract.contractId}</small>
                                        </div>
                                    </div>
                                </div>

                                <!-- Card Body -->
                                <div class="card-body contract-info">
                                    <div class="row">
                                        <div class="col-6">
                                            <div class="info-item">
                                                <div class="info-label">
                                                    <i class="fas fa-calendar-alt me-1"></i>Ngày bắt đầu
                                                </div>
                                                <div class="info-value">
                                                    <fmt:formatDate value="${contract.startDate}" pattern="dd/MM/yyyy"/>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="col-6">
                                            <div class="info-item">
                                                <div class="info-label">
                                                    <i class="fas fa-calendar-check me-1"></i>Ngày kết thúc
                                                </div>
                                                <div class="info-value">
                                                    <c:choose>
                                                        <c:when test="${contract.endDate != null}">
                                                            <fmt:formatDate value="${contract.endDate}" pattern="dd/MM/yyyy"/>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="text-muted">Chưa xác định</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </div>
                                            </div>
                                        </div>
                                    </div>

                                    <div class="row">
                                        <div class="col-12">
                                            <div class="info-item">
                                                <div class="info-label">
                                                    <i class="fas fa-money-bill-wave me-1"></i>Giá thuê hàng tháng
                                                </div>
                                                <div class="info-value text-success">
                                                    <fmt:formatNumber value="${contract.rentPrice}" pattern="#,###"/> VNĐ
                                                </div>
                                            </div>
                                        </div>
                                    </div>

                                    <c:if test="${contract.depositAmount != null && contract.depositAmount > 0}">
                                        <div class="row">
                                            <div class="col-12">
                                                <div class="info-item">
                                                    <div class="info-label">
                                                        <i class="fas fa-shield-alt me-1"></i>Tiền cọc
                                                    </div>
                                                    <div class="info-value text-warning">
                                                        <fmt:formatNumber value="${contract.depositAmount}" pattern="#,###"/> VNĐ
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </c:if>

                                    <c:if test="${not empty contract.note}">
                                        <div class="row">
                                            <div class="col-12">
                                                <div class="info-item">
                                                    <div class="info-label">
                                                        <i class="fas fa-sticky-note me-1"></i>Ghi chú
                                                    </div>
                                                    <div class="info-value text-muted">
                                                        ${contract.note}
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </c:if>
                                </div>

                                <!-- Card Footer -->
                                <div class="card-footer bg-light">
                                    <div class="d-flex justify-content-between align-items-center">
                                        <small class="text-muted">
                                            <i class="fas fa-user me-1"></i>ID Người thuê: ${contract.tenantsID}
                                        </small>
                                        <a href="${pageContext.request.contextPath}/mycontract?action=view&id=${contract.contractId}" 
                                           class="btn btn-gradient btn-sm">
                                            <i class="fas fa-eye me-1"></i>Xem chi tiết
                                        </a>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </c:otherwise>
        </c:choose>

        <!-- Pagination -->
        <c:if test="${not searchMode and not statusMode and totalPages > 1}">
            <div class="d-flex justify-content-center mt-4">
                <nav aria-label="Phân trang hợp đồng">
                    <ul class="pagination pagination-lg">
                        <!-- Previous Button -->
                        <c:if test="${currentPage > 1}">
                            <li class="page-item">
                                <a class="page-link" href="${pageContext.request.contextPath}/mycontract?page=${currentPage - 1}">
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
                                        <a class="page-link" href="${pageContext.request.contextPath}/mycontract?page=${pageNum}">
                                            ${pageNum}
                                        </a>
                                    </li>
                                </c:otherwise>
                            </c:choose>
                        </c:forEach>
                        
                        <!-- Next Button -->
                        <c:if test="${currentPage < totalPages}">
                            <li class="page-item">
                                <a class="page-link" href="${pageContext.request.contextPath}/mycontract?page=${currentPage + 1}">
                                    <i class="fas fa-chevron-right"></i>
                                </a>
                            </li>
                        </c:if>
                    </ul>
                </nav>
            </div>
        </c:if>

        <!-- Page Info -->
        <c:if test="${not searchMode and not statusMode and not empty contracts}">
            <div class="text-center mt-3">
                <small class="text-muted">
                    Hiển thị ${(currentPage - 1) * contractsPerPage + 1} - 
                    ${(currentPage - 1) * contractsPerPage + contracts.size()} 
                    trong tổng số ${totalContracts} hợp đồng
                </small>
            </div>
        </c:if>
    </div>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    
    <script>
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

        // Add smooth scrolling
        document.querySelectorAll('a[href^="#"]').forEach(anchor => {
            anchor.addEventListener('click', function (e) {
                e.preventDefault();
                const target = document.querySelector(this.getAttribute('href'));
                if (target) {
                    target.scrollIntoView({
                        behavior: 'smooth'
                    });
                }
            });
        });

        // Highlight active filter button
        document.addEventListener('DOMContentLoaded', function() {
            const currentUrl = window.location.href;
            const filterButtons = document.querySelectorAll('.filter-btn');
            
            filterButtons.forEach(function(btn) {
                if (btn.href === currentUrl) {
                    btn.classList.add('active');
                }
            });
        });
    </script>
</body>
</html>