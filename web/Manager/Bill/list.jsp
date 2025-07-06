<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý Hóa đơn - Manager Dashboard</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        .sidebar {
            min-height: 100vh;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        }
        .sidebar .nav-link {
            color: rgba(255,255,255,0.8);
            padding: 12px 20px;
            margin: 4px 0;
            border-radius: 8px;
            transition: all 0.3s ease;
        }
        .sidebar .nav-link:hover, .sidebar .nav-link.active {
            color: white;
            background: rgba(255,255,255,0.1);
            transform: translateX(5px);
        }
        .main-content {
            background: #f8f9fa;
            min-height: 100vh;
        }
        .card {
            border: none;
            border-radius: 15px;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
            transition: transform 0.3s ease;
        }
        .card:hover {
            transform: translateY(-5px);
        }
        .stats-card {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }
        .stats-card-2 {
            background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
            color: white;
        }
        .stats-card-3 {
            background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
            color: white;
        }
        .table {
            border-radius: 10px;
            overflow: hidden;
        }
        .btn-action {
            border-radius: 20px;
            padding: 8px 16px;
            font-size: 0.875rem;
            transition: all 0.3s ease;
        }
        .btn-action:hover {
            transform: translateY(-2px);
            box-shadow: 0 2px 5px rgba(0,0,0,0.2);
        }
        .search-box {
            border-radius: 25px;
            border: 2px solid #e9ecef;
            padding: 10px 20px;
        }
        .search-box:focus {
            border-color: #667eea;
            box-shadow: 0 0 0 0.2rem rgba(102, 126, 234, 0.25);
        }
        .status-paid { 
            background: #d4edda !important; 
            color: #155724 !important; 
            font-weight: bold; 
        }
        .status-unpaid { 
            background: #f8d7da !important; 
            color: #721c24 !important; 
            font-weight: bold; 
        }
        .status-pending { 
            background: #fff3cd !important; 
            color: #856404 !important; 
            font-weight: bold; 
        }
        .user-info {
            background: rgba(255,255,255,0.1);
            border-radius: 10px;
            padding: 15px;
            margin-bottom: 20px;
        }
        .pagination-section {
            margin-top: 20px;
            display: flex;
            justify-content: center;
            align-items: center;
        }
        .pagination-section .page-item .page-link {
            border-radius: 20px;
            margin: 0 5px;
            color: #667eea;
            background: #fff;
            border: 1px solid #e9ecef;
            transition: all 0.3s ease;
            padding: 8px 14px;
        }
        .pagination-section .page-item.active .page-link {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border-color: #667eea;
            color: white;
        }
        .pagination-section .page-item.disabled .page-link {
            color: #6c757d;
            background: #f8f9fa;
            border-color: #e9ecef;
            cursor: not-allowed;
        }
        .pagination-section .page-link:hover {
            background: #e9ecef;
            border-color: #667eea;
            color: #667eea;
        }
    </style>
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
                    <div class="user-info">
                        <div class="text-center">
                            <i class="fas fa-user-circle fa-3x text-white mb-2"></i>
                            <h6 class="text-white mb-1">${sessionScope.user.fullName}</h6>
                            <small class="text-white-50">Manager</small>
                        </div>
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
                        <a class="nav-link" href="listcontracts">
                            <i class="fas fa-file-contract me-2"></i>
                            Hợp đồng
                        </a>
                        <a class="nav-link active" href="listbills">
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
                            <h2 class="mb-1"><i class="fas fa-receipt"></i> Quản lý Hóa đơn</h2>
                            <p class="text-muted mb-0">Quản lý và theo dõi hóa đơn của người thuê</p>
                        </div>
                        <a href="BillServlet?action=add" class="btn btn-primary btn-action">
                            <i class="fas fa-plus me-2"></i>Thêm hóa đơn
                        </a>
                    </div>

                    <!-- Alert Messages -->
                    <c:if test="${not empty success}">
                        <div class="alert alert-success alert-dismissible fade show" role="alert">
                            <i class="fas fa-check-circle me-2"></i>${success}
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </div>
                    </c:if>
                    <c:if test="${not empty error}">
                        <div class="alert alert-danger alert-dismissible fade show" role="alert">
                            <i class="fas fa-exclamation-circle me-2"></i>${error}
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </div>
                    </c:if>

                    <!-- Stats Cards -->
                    <div class="row mb-4">
                        <div class="col-md-4">
                            <div class="card stats-card">
                                <div class="card-body">
                                    <div class="d-flex justify-content-between">
                                        <div>
                                            <h6 class="card-title">Tổng hóa đơn</h6>
                                            <h3 class="mb-0">${totalBills}</h3>
                                        </div>
                                        <div class="align-self-center">
                                            <i class="fas fa-file-invoice fa-2x"></i>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="card stats-card-2">
                                <div class="card-body">
                                    <div class="d-flex justify-content-between">
                                        <div>
                                            <h6 class="card-title">Doanh thu</h6>
                                            <h3 class="mb-0"><fmt:formatNumber value="${totalRevenue}" type="currency" currencySymbol="₫"/></h3>
                                        </div>
                                        <div class="align-self-center">
                                            <i class="fas fa-money-bill-wave fa-2x"></i>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="card stats-card-3">
                                <div class="card-body">
                                    <div class="d-flex justify-content-between">
                                        <div>
                                            <h6 class="card-title">Chưa thanh toán</h6>
                                            <h3 class="mb-0">${unpaidCount}</h3>
                                        </div>
                                        <div class="align-self-center">
                                            <i class="fas fa-clock fa-2x"></i>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Search and Filter -->
                     <div class="card mb-4">
                        <div class="card-body">
                            <form action="listbills" method="GET" class="row g-3">
                                <input type="hidden" name="action" value="search">
                                <div class="col-md-3">
                                    <label for="searchType" class="form-label">Tìm kiếm theo:</label>
                                    <select class="form-select" id="searchType" name="searchType">
                                        <option value="tenantName" ${searchType == 'tenantName' ? 'selected' : ''}>Tên người thuê</option>
                                        <option value="roomNumber" ${searchType == 'roomNumber' ? 'selected' : ''}>Số phòng</option>
                                        <option value="status" ${searchType == 'status' ? 'selected' : ''}>Trạng thái</option>
                                    </select>
                                </div>
                                <div class="col-md-6">
                                    <label for="searchValue" class="form-label">Giá trị tìm kiếm:</label>
                                    <input type="text" class="form-control search-box" id="searchValue" name="searchValue" 
                                           value="${searchValue}" placeholder="Nhập từ khóa tìm kiếm...">
                                </div>
                                <div class="col-md-3">
                                    <label class="form-label"> </label>
                                    <div>
                                        <button type="submit" class="btn btn-primary btn-action">
                                            <i class="fas fa-search me-2"></i>Tìm kiếm
                                        </button>
                                        <a href="listbills" class="btn btn-outline-secondary btn-action">
                                            <i class="fas fa-refresh me-2"></i>Làm mới
                                        </a>
                                    </div>
                                </div>
                            </form>
                        </div>
                    </div> 

                    <!-- Bills Table -->
                    <div class="card">
                        <div class="card-header bg-white">
                            <h5 class="mb-0"><i class="fas fa-list me-2"></i>Danh sách hóa đơn</h5>
                        </div>
                        <div class="card-body p-0">
                            <div class="table-responsive">
                                <table class="table table-hover mb-0">
                                    <thead class="table-light">
                                        <tr>
                                            <th>ID</th>
                                            <th>Tên người thuê</th>
                                            <th>Số phòng</th>
                                            <th>Tiền điện</th>
                                            <th>Tiền nước</th>
                                            <th>Phí dịch vụ</th>
                                            <th>Tổng tiền</th>
                                            <th>Hạn thanh toán</th>
                                            <th>Trạng thái</th>
                                            <th>Ngày tạo</th>
                                            <th>Thao tác</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="bill" items="${bills}">
                                            <tr>
                                                <td>${bill.id}</td>
                                                <td>
                                                    <div class="fw-bold">${bill.tenantName}</div>
                                                </td>
                                                <td><span class="badge bg-info">${bill.roomNumber}</span></td>
                                                <td><fmt:formatNumber value="${bill.electricityCost}" type="currency" currencySymbol="₫"/></td>
                                                <td><fmt:formatNumber value="${bill.waterCost}" type="currency" currencySymbol="₫"/></td>
                                                <td><fmt:formatNumber value="${bill.serviceCost}" type="currency" currencySymbol="₫"/></td>
                                                <td><strong><fmt:formatNumber value="${bill.total}" type="currency" currencySymbol="₫"/></strong></td>
                                                <td>${bill.dueDate}</td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${bill.status == 'Paid'}">
                                                            <span class="badge status-paid">Đã thanh toán</span>
                                                        </c:when>
                                                        <c:when test="${bill.status == 'Unpaid'}">
                                                            <span class="badge status-unpaid">Chưa thanh toán</span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="badge status-pending">Đang xử lý</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>${bill.createdDate}</td>
                                                <td>
                                                    <div class="btn-group" role="group">
                                                        <a href="BillServlet?action=view&id=${bill.id}" 
                                                           class="btn btn-sm btn-outline-info btn-action" 
                                                           title="Xem chi tiết">
                                                            <i class="fas fa-eye"></i>
                                                        </a>
                                                        <a href="BillServlet?action=edit&id=${bill.id}" 
                                                           class="btn btn-sm btn-outline-warning btn-action" 
                                                           title="Sửa">
                                                            <i class="fas fa-edit"></i>
                                                        </a>
                                                        <button type="button" 
                                                                class="btn btn-sm btn-outline-danger btn-action" 
                                                                onclick="confirmDelete(${bill.id})"
                                                                title="Xóa">
                                                            <i class="fas fa-trash"></i>
                                                        </button>
                                                        <c:if test="${bill.status == 'Unpaid'}">
                                                            <button type="button" 
                                                                    class="btn btn-sm btn-outline-success btn-action" 
                                                                    onclick="updateStatus(${bill.id}, 'Paid')"
                                                                    title="Đánh dấu đã thanh toán">
                                                                <i class="fas fa-check"></i>
                                                            </button>
                                                        </c:if>
                                                    </div>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>

                    <!-- Pagination -->
                    <c:if test="${not empty bills}">
                        <div class="pagination-section">
                            <nav aria-label="Page navigation">
                                <ul class="pagination">
                                    <li class="page-item ${currentPage <= 1 ? 'disabled' : ''}">
                                        <a class="page-link" href="listbills?action=list&page=${currentPage - 1}" aria-label="Previous">
                                            <span aria-hidden="true">« Trước</span>
                                        </a>
                                    </li>
                                    <c:forEach begin="1" end="${totalPages}" var="i">
                                        <li class="page-item ${currentPage == i ? 'active' : ''}">
                                            <a class="page-link" href="listbills?action=list&page=${i}">${i}</a>
                                        </li>
                                    </c:forEach>
                                    <li class="page-item ${currentPage >= totalPages ? 'disabled' : ''}">
                                        <a class="page-link" href="listbills?action=list&page=${currentPage + 1}" aria-label="Next">
                                            <span aria-hidden="true">Tiếp »</span>
                                        </a>
                                    </li>
                                </ul>
                            </nav>
                        </div>
                    </c:if>

                    <!-- Empty State -->
                    <c:if test="${empty bills}">
                        <div class="text-center mt-5">
                            <i class="fas fa-inbox fa-4x text-muted mb-3"></i>
                            <h4 class="text-muted">Không có hóa đơn nào</h4>
                            <p class="text-muted">Hãy thêm hóa đơn mới để bắt đầu</p>
                            <a href="BillServlet?action=add" class="btn btn-primary btn-action">
                                <i class="fas fa-plus me-2"></i>Thêm hóa đơn đầu tiên
                            </a>
                        </div>
                    </c:if>
                </div>
            </div>
        </div>
    </div>

    <!-- Delete Confirmation Modal -->
    <div class="modal fade" id="deleteModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Xác nhận xóa</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <p>Bạn có chắc chắn muốn xóa hóa đơn này?</p>
                    <p class="text-danger"><small>Hành động này không thể hoàn tác.</small></p>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                    <a href="#" id="confirmDeleteBtn" class="btn btn-danger">Xóa</a>
                </div>
            </div>
        </div>
    </div>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    
    <script>
        function confirmDelete(id) {
            document.getElementById('confirmDeleteBtn').href = 'BillServlet?action=delete&id=' + id;
            new bootstrap.Modal(document.getElementById('deleteModal')).show();
        }

        function updateStatus(id, status) {
            if (confirm('Bạn có chắc chắn muốn cập nhật trạng thái hóa đơn này?')) {
                window.location.href = 'BillServlet?action=updateStatus&id=' + id + '&status=' + status;
            }
        }

        // Auto-hide alerts after 5 seconds
        setTimeout(function() {
            const alerts = document.querySelectorAll('.alert');
            alerts.forEach(function(alert) {
                const bsAlert = new bootstrap.Alert(alert);
                bsAlert.close();
            });
        }, 5000);
    </script>
</body>
</html>