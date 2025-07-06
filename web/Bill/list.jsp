<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý Hóa đơn</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        .status-paid { color: #28a745; font-weight: bold; }
        .status-unpaid { color: #dc3545; font-weight: bold; }
        .status-pending { color: #ffc107; font-weight: bold; }
        .table-responsive { margin-top: 20px; }
        .search-section { background: #f8f9fa; padding: 20px; border-radius: 8px; margin-bottom: 20px; }
        .stats-section { margin-bottom: 20px; }
        .btn-action { margin: 2px; }
    </style>
</head>
<body>
    <div class="container-fluid">
        <div class="row">
            <div class="col-12">
                <h2 class="text-center mb-4">
                    <i class="fas fa-file-invoice"></i> Quản lý Hóa đơn
                </h2>

                <!-- Thông báo -->
                <c:if test="${not empty success}">
                    <div class="alert alert-success alert-dismissible fade show" role="alert">
                        <i class="fas fa-check-circle"></i> ${success}
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                </c:if>
                <c:if test="${not empty error}">
                    <div class="alert alert-danger alert-dismissible fade show" role="alert">
                        <i class="fas fa-exclamation-circle"></i> ${error}
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                </c:if>

                <!-- Thống kê -->
                <div class="stats-section">
                    <div class="row">
                        <div class="col-md-4">
                            <div class="card bg-primary text-white">
                                <div class="card-body">
                                    <h5 class="card-title"><i class="fas fa-file-invoice"></i> Tổng hóa đơn</h5>
                                    <h3>${totalBills}</h3>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="card bg-success text-white">
                                <div class="card-body">
                                    <h5 class="card-title"><i class="fas fa-money-bill-wave"></i> doanh thu </h5>
                                    <h3><fmt:formatNumber value="${totalRevenue}" type="currency" currencySymbol="₫"/></h3>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="card bg-warning text-white">
                                <div class="card-body">
                                    <h5 class="card-title"><i class="fas fa-clock"></i> Chưa thanh toán</h5>
                                    <h3>${unpaidCount}</h3>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Tìm kiếm -->
                 <div class="search-section">
                    <form action="BillServlet" method="GET" class="row g-3">
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
                            <input type="text" class="form-control" id="searchValue" name="searchValue" 
                                   value="${searchValue}" placeholder="Nhập từ khóa tìm kiếm...">
                        </div>
                        <div class="col-md-3">
                            <label class="form-label">&nbsp;</label>
                            <div>
                                <button type="submit" class="btn btn-primary">
                                    <i class="fas fa-search"></i> Tìm kiếm
                                </button>
                                <a href="BillServlet?action=list" class="btn btn-secondary">
                                    <i class="fas fa-refresh"></i> Làm mới
                                </a>
                            </div>
                        </div>
                    </form>
                </div> 

                <!-- Nút thêm mới -->
                <div class="mb-3">
                    <a href="BillServlet?action=add" class="btn btn-success">
                        <i class="fas fa-plus"></i> Thêm hóa đơn mới
                    </a>
                </div>

                <!-- Bảng danh sách -->
                <div class="table-responsive">
                    <table class="table table-striped table-hover">
                        <thead class="table-dark">
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
                                    <td>${bill.tenantName}</td>
                                    <td><span class="badge bg-info">${bill.roomNumber}</span></td>
                                    <td><fmt:formatNumber value="${bill.electricityCost}" type="currency" currencySymbol="₫"/></td>
                                    <td><fmt:formatNumber value="${bill.waterCost}" type="currency" currencySymbol="₫"/></td>
                                    <td><fmt:formatNumber value="${bill.serviceCost}" type="currency" currencySymbol="₫"/></td>
                                    <td><strong><fmt:formatNumber value="${bill.total}" type="currency" currencySymbol="₫"/></strong></td>
                                    <td>${bill.dueDate}</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${bill.status == 'Paid'}">
                                                <span class="badge bg-success status-paid">Đã thanh toán</span>
                                            </c:when>
                                            <c:when test="${bill.status == 'Unpaid'}">
                                                <span class="badge bg-danger status-unpaid">Chưa thanh toán</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge bg-warning status-pending">Đang xử lý</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>${bill.createdDate}</td>
                                    <td>
                                        <div class="btn-group" role="group">
                                            <a href="BillServlet?action=view&id=${bill.id}" 
                                               class="btn btn-sm btn-info btn-action" title="Xem chi tiết">
                                                <i class="fas fa-eye"></i>
                                            </a>
                                            <a href="BillServlet?action=edit&id=${bill.id}" 
                                               class="btn btn-sm btn-warning btn-action" title="Sửa">
                                                <i class="fas fa-edit"></i>
                                            </a>
                                            <button type="button" class="btn btn-sm btn-danger btn-action" 
                                                    onclick="confirmDelete(${bill.id})" title="Xóa">
                                                <i class="fas fa-trash"></i>
                                            </button>
                                            <c:if test="${bill.status == 'Unpaid'}">
                                                <button type="button" class="btn btn-sm btn-success btn-action" 
                                                        onclick="updateStatus(${bill.id}, 'Paid')" title="Đánh dấu đã thanh toán">
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

                <!-- Thông báo không có dữ liệu -->
                <c:if test="${empty bills}">
                    <div class="text-center mt-4">
                        <i class="fas fa-inbox fa-3x text-muted"></i>
                        <h4 class="text-muted mt-3">Không có hóa đơn nào</h4>
                        <p class="text-muted">Hãy thêm hóa đơn mới để bắt đầu</p>
                    </div>
                </c:if>
            </div>
        </div>
    </div>

    <!-- Modal xác nhận xóa -->
    <div class="modal fade" id="deleteModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Xác nhận xóa</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <p>Bạn có chắc chắn muốn xóa hóa đơn này?</p>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                    <a href="#" id="confirmDeleteBtn" class="btn btn-danger">Xóa</a>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function confirmDelete(id) {
            document.getElementById('confirmDeleteBtn').href = 'BillServlet?action=delete&id=' + id;
            new bootstrap.Modal(document.getElementById('deleteModal')).show();
        }

        function updateStatus(id, status) {
            if (confirm('Bạn có chắc chắn muốn cập nhật trạng thái hóa đơn?')) {
                window.location.href = 'BillServlet?action=updateStatus&id=' + id + '&status=' + status;
            }
        }

        // Auto-hide alerts after 5 seconds
        setTimeout(function() {
            const alerts = document.querySelectorAll('.alert');
            alerts.forEach(function(alert) {
                new bootstrap.Alert(alert).close();
            });
        }, 5000);
    </script>
</body>
</html> 