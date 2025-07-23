<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sửa Hóa đơn - Manager Dashboard</title>
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
        .form-control, .form-select {
            border-radius: 10px;
            border: 2px solid #e9ecef;
            padding: 12px 15px;
        }
        .form-control:focus, .form-select:focus {
            border-color: #667eea;
            box-shadow: 0 0 0 0.2rem rgba(102, 126, 234, 0.25);
        }
        .user-info {
            background: rgba(255,255,255,0.1);
            border-radius: 10px;
            padding: 15px;
            margin-bottom: 20px;
        }
        .total-display {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border-radius: 15px;
            padding: 20px;
            margin-top: 20px;
        }
        .bill-info {
            background: #e3f2fd;
            border-radius: 10px;
            padding: 15px;
            margin-bottom: 20px;
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
                            <h2 class="mb-1"><i class="fas fa-edit"></i> Sửa Hóa đơn</h2>
                            <p class="text-muted mb-0">Cập nhật thông tin hóa đơn</p>
                        </div>
                        <a href="BillServlet?action=list" class="btn btn-outline-secondary btn-action">
                            <i class="fas fa-arrow-left me-2"></i>Quay lại
                        </a>
                    </div>

                    <!-- Bill Info -->
                    <div class="bill-info">
                        <div class="row">
                            <div class="col-md-3">
                                <strong>ID Hóa đơn:</strong> #${bill.id}
                            </div>
                            <div class="col-md-3">
                                <strong>Ngày tạo:</strong> ${bill.createdDate}
                            </div>
                            <div class="col-md-3">
                                <strong>Trạng thái hiện tại:</strong> 
                                <span class="badge ${bill.status == 'Paid' ? 'bg-success' : bill.status == 'Unpaid' ? 'bg-danger' : 'bg-warning'}">
                                    ${bill.status == 'Paid' ? 'Đã thanh toán' : bill.status == 'Unpaid' ? 'Chưa thanh toán' : 'Đang xử lý'}
                                </span>
                            </div>
                            <div class="col-md-3">
                                <strong>Tổng tiền:</strong> ${bill.total} ₫
                            </div>
                        </div>
                    </div>

                    <!-- Form -->
                    <div class="card">
                        <div class="card-body">
                            <form action="BillServlet" method="POST" id="billForm">
                                <input type="hidden" name="action" value="update">
                                <input type="hidden" name="id" value="${bill.id}">
                                
                                <div class="row">
                                    <div class="col-md-6">
                                        <div class="mb-3">
                                            <label for="tenantName" class="form-label">
                                                <i class="fas fa-user me-2"></i>Tên người thuê <span class="text-danger">*</span>
                                            </label>
                                            <input type="text" class="form-control" id="tenantName" name="tenantName" 
                                                   value="${bill.tenantName}" required placeholder="Nhập tên người thuê">
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <div class="mb-3">
                                            <label for="roomNumber" class="form-label">
                                                <i class="fas fa-bed me-2"></i>Số phòng <span class="text-danger">*</span>
                                            </label>
                                            <input type="text" class="form-control" id="roomNumber" name="roomNumber" 
                                                   value="${bill.roomNumber}" required placeholder="Nhập số phòng">
                                        </div>
                                    </div>
                                </div>

                                <div class="row">
                                    <div class="col-md-4">
                                        <div class="mb-3">
                                            <label for="electricityCost" class="form-label">
                                                <i class="fas fa-bolt me-2"></i>Tiền điện (₫) <span class="text-danger">*</span>
                                            </label>
                                            <input type="number" class="form-control" id="electricityCost" name="electricityCost" 
                                                   value="${bill.electricityCost}" required min="0" step="1000" 
                                                   placeholder="0" onchange="calculateTotal()">
                                        </div>
                                    </div>
                                    <div class="col-md-4">
                                        <div class="mb-3">
                                            <label for="waterCost" class="form-label">
                                                <i class="fas fa-tint me-2"></i>Tiền nước (₫) <span class="text-danger">*</span>
                                            </label>
                                            <input type="number" class="form-control" id="waterCost" name="waterCost" 
                                                   value="${bill.waterCost}" required min="0" step="1000" 
                                                   placeholder="0" onchange="calculateTotal()">
                                        </div>
                                    </div>
                                    <div class="col-md-4">
                                        <div class="mb-3">
                                            <label for="serviceCost" class="form-label">
                                                <i class="fas fa-concierge-bell me-2"></i>Phí dịch vụ (₫) <span class="text-danger">*</span>
                                            </label>
                                            <input type="number" class="form-control" id="serviceCost" name="serviceCost" 
                                                   value="${bill.serviceCost}" required min="0" step="1000" 
                                                   placeholder="0" onchange="calculateTotal()">
                                        </div>
                                    </div>
                                </div>

                                <div class="row">
                                    <div class="col-md-6">
                                        <div class="mb-3">
                                            <label for="dueDate" class="form-label">
                                                <i class="fas fa-calendar me-2"></i>Hạn thanh toán <span class="text-danger">*</span>
                                            </label>
                                            <input type="date" class="form-control" id="dueDate" name="dueDate" 
                                                   value="${bill.dueDate}" required>
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <div class="mb-3">
                                            <label for="status" class="form-label">
                                                <i class="fas fa-info-circle me-2"></i>Trạng thái <span class="text-danger">*</span>
                                            </label>
                                            <select class="form-select" id="status" name="status" required>
                                                <option value="">Chọn trạng thái</option>
                                                <option value="Unpaid" ${bill.status == 'Unpaid' ? 'selected' : ''}>Chưa thanh toán</option>
                                                <option value="Paid" ${bill.status == 'Paid' ? 'selected' : ''}>Đã thanh toán</option>
                                                <option value="Pending" ${bill.status == 'Pending' ? 'selected' : ''}>Đang xử lý</option>
                                            </select>
                                        </div>
                                    </div>
                                </div>

                                <!-- Total Display -->
                                <div class="total-display">
                                    <div class="row">
                                        <div class="col-md-6">
                                            <h5><i class="fas fa-calculator me-2"></i>Tổng tiền:</h5>
                                        </div>
                                        <div class="col-md-6 text-end">
                                            <h3 id="totalDisplay">${bill.total} ₫</h3>
                                        </div>
                                    </div>
                                </div>

                                <!-- Form Actions -->
                                <div class="d-flex justify-content-between mt-4">
                                    <a href="BillServlet?action=list" class="btn btn-outline-secondary btn-lg">
                                        <i class="fas fa-times me-2"></i>Hủy
                                    </a>
                                    <button type="submit" class="btn btn-primary btn-lg">
                                        <i class="fas fa-save me-2"></i>Cập nhật hóa đơn
                                    </button>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    
    <script>
        function calculateTotal() {
            const electricity = parseFloat(document.getElementById('electricityCost').value) || 0;
            const water = parseFloat(document.getElementById('waterCost').value) || 0;
            const service = parseFloat(document.getElementById('serviceCost').value) || 0;
            
            const total = electricity + water + service;
            document.getElementById('totalDisplay').textContent = total.toLocaleString('vi-VN') + ' ₫';
        }

        // Form validation
        document.getElementById('billForm').addEventListener('submit', function(e) {
            const requiredFields = ['tenantName', 'roomNumber', 'electricityCost', 'waterCost', 'serviceCost', 'dueDate', 'status'];
            let isValid = true;

            requiredFields.forEach(fieldId => {
                const field = document.getElementById(fieldId);
                if (!field.value.trim()) {
                    field.classList.add('is-invalid');
                    isValid = false;
                } else {
                    field.classList.remove('is-invalid');
                }
            });

            if (!isValid) {
                e.preventDefault();
                alert('Vui lòng điền đầy đủ thông tin bắt buộc!');
            }
        });
    </script>
</body>
</html> 