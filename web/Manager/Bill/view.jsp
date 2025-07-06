<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chi tiết Hóa đơn - Manager Dashboard</title>
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
        .btn-action {
            border-radius: 20px;
            padding: 8px 16px;
            font-size: 0.875rem;
        }
        .user-info {
            background: rgba(255,255,255,0.1);
            border-radius: 10px;
            padding: 15px;
            margin-bottom: 20px;
        }
        .bill-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border-radius: 15px;
            padding: 30px;
            margin-bottom: 30px;
        }
        .bill-details {
            background: white;
            border-radius: 15px;
            padding: 25px;
            margin-bottom: 20px;
        }
        .cost-item {
            background: #f8f9fa;
            border-radius: 10px;
            padding: 15px;
            margin-bottom: 10px;
        }
        .total-section {
            background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
            color: white;
            border-radius: 15px;
            padding: 20px;
            margin-top: 20px;
        }
        .status-badge {
            padding: 8px 16px;
            border-radius: 20px;
            font-weight: bold;
        }
        .status-paid { background: #d4edda; color: #155724; }
        .status-unpaid { background: #f8d7da; color: #721c24; }
        .status-pending { background: #fff3cd; color: #856404; }
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
                            <h6 class="text-white mb-1">${user.fullName}</h6>
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
                        <a class="nav-link active" href="BillServlet?action=list">
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
                            <h2 class="mb-1"><i class="fas fa-eye"></i> Chi tiết Hóa đơn</h2>
                            <p class="text-muted mb-0">Thông tin chi tiết hóa đơn #${bill.id}</p>
                        </div>
                        <a href="BillServlet?action=list" class="btn btn-outline-secondary btn-action">
                            <i class="fas fa-arrow-left me-2"></i>Quay lại
                        </a>
                    </div>

                    <!-- Bill Header -->
                    <div class="bill-header">
                        <div class="row align-items-center">
                            <div class="col-md-8">
                                <h3><i class="fas fa-receipt me-2"></i>Hóa đơn #${bill.id}</h3>
                                <p class="mb-0">Người thuê: <strong>${bill.tenantName}</strong> | Phòng: <strong>${bill.roomNumber}</strong></p>
                            </div>
                            <div class="col-md-4 text-end">
                                <span class="status-badge ${bill.status == 'Paid' ? 'status-paid' : bill.status == 'Unpaid' ? 'status-unpaid' : 'status-pending'}">
                                    ${bill.status == 'Paid' ? 'Đã thanh toán' : bill.status == 'Unpaid' ? 'Chưa thanh toán' : 'Đang xử lý'}
                                </span>
                            </div>
                        </div>
                    </div>

                    <!-- Bill Details -->
                    <div class="bill-details">
                        <div class="row">
                            <div class="col-md-6">
                                <h5><i class="fas fa-info-circle me-2"></i>Thông tin cơ bản</h5>
                                <table class="table table-borderless">
                                    <tr>
                                        <td><strong>ID Hóa đơn:</strong></td>
                                        <td>#${bill.id}</td>
                                    </tr>
                                    <tr>
                                        <td><strong>Người thuê:</strong></td>
                                        <td>${bill.tenantName}</td>
                                    </tr>
                                    <tr>
                                        <td><strong>Số phòng:</strong></td>
                                        <td><span class="badge bg-info">${bill.roomNumber}</span></td>
                                    </tr>
                                    <tr>
                                        <td><strong>Ngày tạo:</strong></td>
                                        <td>${bill.createdDate}</td>
                                    </tr>
                                    <tr>
                                        <td><strong>Hạn thanh toán:</strong></td>
                                        <td>${bill.dueDate}</td>
                                    </tr>
                                    <tr>
                                        <td><strong>Trạng thái:</strong></td>
                                        <td>
                                            <span class="status-badge ${bill.status == 'Paid' ? 'status-paid' : bill.status == 'Unpaid' ? 'status-unpaid' : 'status-pending'}">
                                                ${bill.status == 'Paid' ? 'Đã thanh toán' : bill.status == 'Unpaid' ? 'Chưa thanh toán' : 'Đang xử lý'}
                                            </span>
                                        </td>
                                    </tr>
                                </table>
                            </div>
                            <div class="col-md-6">
                                <h5><i class="fas fa-calculator me-2"></i>Chi tiết chi phí</h5>
                                
                                <div class="cost-item">
                                    <div class="d-flex justify-content-between align-items-center">
                                        <div>
                                            <i class="fas fa-bolt text-warning me-2"></i>
                                            <strong>Tiền điện</strong>
                                        </div>
                                        <div>
                                            <fmt:formatNumber value="${bill.electricityCost}" type="currency" currencySymbol="₫"/>
                                        </div>
                                    </div>
                                </div>
                                
                                <div class="cost-item">
                                    <div class="d-flex justify-content-between align-items-center">
                                        <div>
                                            <i class="fas fa-tint text-primary me-2"></i>
                                            <strong>Tiền nước</strong>
                                        </div>
                                        <div>
                                            <fmt:formatNumber value="${bill.waterCost}" type="currency" currencySymbol="₫"/>
                                        </div>
                                    </div>
                                </div>
                                
                                <div class="cost-item">
                                    <div class="d-flex justify-content-between align-items-center">
                                        <div>
                                            <i class="fas fa-concierge-bell text-success me-2"></i>
                                            <strong>Phí dịch vụ</strong>
                                        </div>
                                        <div>
                                            <fmt:formatNumber value="${bill.serviceCost}" type="currency" currencySymbol="₫"/>
                                        </div>
                                    </div>
                                </div>
                                
                                <div class="total-section">
                                    <div class="d-flex justify-content-between align-items-center">
                                        <div>
                                            <h5 class="mb-0"><i class="fas fa-calculator me-2"></i>Tổng tiền</h5>
                                        </div>
                                        <div>
                                            <h4 class="mb-0"><fmt:formatNumber value="${bill.total}" type="currency" currencySymbol="₫"/></h4>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Action Buttons -->
                    <div class="d-flex justify-content-center gap-3">
                        <a href="BillServlet?action=edit&id=${bill.id}" class="btn btn-warning btn-lg">
                            <i class="fas fa-edit me-2"></i>Sửa hóa đơn
                        </a>
                        
                        <c:if test="${bill.status == 'Unpaid'}">
                            <button type="button" class="btn btn-success btn-lg" onclick="updateStatus(${bill.id}, 'Paid')">
                                <i class="fas fa-check me-2"></i>Đánh dấu đã thanh toán
                            </button>
                        </c:if>
                        
                        <button type="button" class="btn btn-danger btn-lg" onclick="confirmDelete(${bill.id})">
                            <i class="fas fa-trash me-2"></i>Xóa hóa đơn
                        </button>
                        
                        <a href="BillServlet?action=list" class="btn btn-secondary btn-lg">
                            <i class="fas fa-list me-2"></i>Danh sách hóa đơn
                        </a>
                    </div>
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
                    <p>Bạn có chắc chắn muốn xóa hóa đơn #${bill.id}?</p>
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
    </script>
</body>
</html> 