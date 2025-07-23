<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thêm Hóa đơn - Manager Dashboard</title>
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
        .cost-breakdown {
            background: #f8f9fa;
            border-radius: 10px;
            padding: 15px;
            margin-top: 15px;
        }
        .cost-item {
            display: flex;
            justify-content: space-between;
            margin-bottom: 8px;
            padding: 5px 0;
            border-bottom: 1px solid #e9ecef;
        }
        .cost-item:last-child {
            border-bottom: none;
            font-weight: bold;
            font-size: 1.1em;
        }
        .form-label {
            font-weight: 600;
            color: #495057;
        }
        .required-field::after {
            content: " *";
            color: #dc3545;
        }
        .help-text {
            font-size: 0.875rem;
            color: #6c757d;
            margin-top: 5px;
        }
        .auto-complete-list {
            position: absolute;
            top: 100%;
            left: 0;
            right: 0;
            background: white;
            border: 1px solid #ddd;
            border-radius: 5px;
            max-height: 200px;
            overflow-y: auto;
            z-index: 1000;
            display: none;
        }
        .auto-complete-item {
            padding: 10px 15px;
            cursor: pointer;
            border-bottom: 1px solid #f0f0f0;
        }
        .auto-complete-item:hover {
            background-color: #f8f9fa;
        }
        .auto-complete-item:last-child {
            border-bottom: none;
        }
        .position-relative {
            position: relative;
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
                            <h2 class="mb-1"><i class="fas fa-plus"></i> Thêm Hóa đơn Mới</h2>
                            <p class="text-muted mb-0">Tạo hóa đơn mới cho người thuê</p>
                        </div>
                        <a href="BillServlet?action=list" class="btn btn-outline-secondary btn-action">
                            <i class="fas fa-arrow-left me-2"></i>Quay lại
                        </a>
                    </div>

                    <!-- Form -->
                    <div class="card">
                        <div class="card-body">
                            <form action="BillServlet" method="POST" id="billForm">
                                <input type="hidden" name="action" value="create">
                                
                                <div class="row">
                                    <div class="col-md-6">
                                        <div class="mb-3 position-relative">
                                            <label for="tenantName" class="form-label required-field">
                                                <i class="fas fa-user me-2"></i>Tên người thuê
                                            </label>
                                            <input type="text" class="form-control" id="tenantName" name="tenantName" 
                                                   required placeholder="Nhập tên người thuê" autocomplete="off">
                                            <div class="help-text">Nhập tên người thuê để tìm kiếm nhanh</div>
                                            <div class="auto-complete-list" id="tenantAutoComplete"></div>
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <div class="mb-3 position-relative">
                                            <label for="roomNumber" class="form-label required-field">
                                                <i class="fas fa-bed me-2"></i>Số phòng
                                            </label>
                                            <input type="text" class="form-control" id="roomNumber" name="roomNumber" 
                                                   required placeholder="Nhập số phòng" autocomplete="off">
                                            <div class="help-text">Ví dụ: A101, B201, C301</div>
                                            <div class="auto-complete-list" id="roomAutoComplete"></div>
                                        </div>
                                    </div>
                                </div>

                                <div class="row">
                                    <div class="col-md-4">
                                        <div class="mb-3">
                                            <label for="electricityCost" class="form-label required-field">
                                                <i class="fas fa-bolt me-2"></i>Tiền điện (₫)
                                            </label>
                                            <input type="number" class="form-control" id="electricityCost" name="electricityCost" 
                                                   required min="0" step="1000" placeholder="0" onchange="calculateTotal()" oninput="calculateTotal()">
                                            <div class="help-text">Nhập số tiền điện tháng này</div>
                                        </div>
                                    </div>
                                    <div class="col-md-4">
                                        <div class="mb-3">
                                            <label for="waterCost" class="form-label required-field">
                                                <i class="fas fa-tint me-2"></i>Tiền nước (₫)
                                            </label>
                                            <input type="number" class="form-control" id="waterCost" name="waterCost" 
                                                   required min="0" step="1000" placeholder="0" onchange="calculateTotal()" oninput="calculateTotal()">
                                            <div class="help-text">Nhập số tiền nước tháng này</div>
                                        </div>
                                    </div>
                                    <div class="col-md-4">
                                        <div class="mb-3">
                                            <label for="serviceCost" class="form-label required-field">
                                                <i class="fas fa-concierge-bell me-2"></i>Phí dịch vụ (₫)
                                            </label>
                                            <input type="number" class="form-control" id="serviceCost" name="serviceCost" 
                                                   required min="0" step="1000" placeholder="0" onchange="calculateTotal()" oninput="calculateTotal()">
                                            <div class="help-text">Phí dịch vụ, internet, vệ sinh...</div>
                                        </div>
                                    </div>
                                </div>

                                <div class="row">
                                    <div class="col-md-6">
                                        <div class="mb-3">
                                            <label for="dueDate" class="form-label required-field">
                                                <i class="fas fa-calendar me-2"></i>Hạn thanh toán
                                            </label>
                                            <input type="date" class="form-control" id="dueDate" name="dueDate" required>
                                            <div class="help-text">Ngày hạn chót thanh toán hóa đơn</div>
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <div class="mb-3">
                                            <label for="status" class="form-label required-field">
                                                <i class="fas fa-info-circle me-2"></i>Trạng thái
                                            </label>
                                            <select class="form-select" id="status" name="status" required>
                                                <option value="">Chọn trạng thái</option>
                                                <option value="Unpaid">Chưa thanh toán</option>
                                                <option value="Paid">Đã thanh toán</option>
                                                <option value="Pending">Đang xử lý</option>
                                            </select>
                                            <div class="help-text">Trạng thái hiện tại của hóa đơn</div>
                                        </div>
                                    </div>
                                </div>

                                <!-- Cost Breakdown -->
                                <div class="cost-breakdown">
                                    <h6><i class="fas fa-calculator me-2"></i>Chi tiết chi phí:</h6>
                                    <div class="cost-item">
                                        <span>Tiền điện:</span>
                                        <span id="electricityDisplay">0 ₫</span>
                                    </div>
                                    <div class="cost-item">
                                        <span>Tiền nước:</span>
                                        <span id="waterDisplay">0 ₫</span>
                                    </div>
                                    <div class="cost-item">
                                        <span>Phí dịch vụ:</span>
                                        <span id="serviceDisplay">0 ₫</span>
                                    </div>
                                    <div class="cost-item">
                                        <span>Tổng cộng:</span>
                                        <span id="totalDisplay">0 ₫</span>
                                    </div>
                                </div>

                                <!-- Form Actions -->
                                <div class="d-flex justify-content-between mt-4">
                                    <a href="BillServlet?action=list" class="btn btn-outline-secondary btn-lg">
                                        <i class="fas fa-times me-2"></i>Hủy
                                    </a>
                                    <button type="submit" class="btn btn-primary btn-lg">
                                        <i class="fas fa-save me-2"></i>Lưu hóa đơn
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
        // Global variables for auto-complete data
        let tenants = [];
        let rooms = [];

        // Set default due date to today + 30 days
        document.addEventListener('DOMContentLoaded', function() {
            const today = new Date();
            const dueDate = new Date(today.getTime() + (30 * 24 * 60 * 60 * 1000)); // 30 days from now
            document.getElementById('dueDate').value = dueDate.toISOString().split('T')[0];
            
            // Set default status
            document.getElementById('status').value = 'Unpaid';
            
            // Load auto-complete data from server
            loadAutoCompleteData();
        });

        // Load auto-complete data from server
        async function loadAutoCompleteData() {
            try {
                // Load tenants
                const tenantsResponse = await fetch('BillServlet?action=getTenants');
                if (tenantsResponse.ok) {
                    tenants = await tenantsResponse.json();
                }
                
                // Load rooms
                const roomsResponse = await fetch('BillServlet?action=getRooms');
                if (roomsResponse.ok) {
                    rooms = await roomsResponse.json();
                }
                
                // Initialize auto-complete after loading data
                initializeAutoComplete();
                
            } catch (error) {
                console.error('Error loading auto-complete data:', error);
                // Fallback to sample data if server fails
                tenants = ['Nguyễn Văn An', 'Trần Thị Bình', 'Lê Văn Cường', 'Phạm Thị Dung', 'Hoàng Văn Em'];
                rooms = ['A101', 'A102', 'A103', 'B201', 'B202', 'B203', 'C301', 'C302', 'C303'];
                initializeAutoComplete();
            }
        }

        function calculateTotal() {
            const electricity = parseFloat(document.getElementById('electricityCost').value) || 0;
            const water = parseFloat(document.getElementById('waterCost').value) || 0;
            const service = parseFloat(document.getElementById('serviceCost').value) || 0;
            
            const total = electricity + water + service;
            
            // Update displays
            document.getElementById('electricityDisplay').textContent = electricity.toLocaleString('vi-VN') + ' ₫';
            document.getElementById('waterDisplay').textContent = water.toLocaleString('vi-VN') + ' ₫';
            document.getElementById('serviceDisplay').textContent = service.toLocaleString('vi-VN') + ' ₫';
            document.getElementById('totalDisplay').textContent = total.toLocaleString('vi-VN') + ' ₫';
        }

        function initializeAutoComplete() {
            // Tenant auto-complete
            const tenantInput = document.getElementById('tenantName');
            const tenantList = document.getElementById('tenantAutoComplete');
            
            tenantInput.addEventListener('input', function() {
                const value = this.value.toLowerCase();
                tenantList.innerHTML = '';
                
                if (value.length > 0) {
                    const matches = tenants.filter(tenant => 
                        tenant.toLowerCase().includes(value)
                    );
                    
                    matches.forEach(tenant => {
                        const item = document.createElement('div');
                        item.className = 'auto-complete-item';
                        item.textContent = tenant;
                        item.onclick = function() {
                            tenantInput.value = tenant;
                            tenantList.style.display = 'none';
                        };
                        tenantList.appendChild(item);
                    });
                    
                    tenantList.style.display = matches.length > 0 ? 'block' : 'none';
                } else {
                    tenantList.style.display = 'none';
                }
            });

            // Room auto-complete
            const roomInput = document.getElementById('roomNumber');
            const roomList = document.getElementById('roomAutoComplete');
            
            roomInput.addEventListener('input', function() {
                const value = this.value.toUpperCase();
                roomList.innerHTML = '';
                
                if (value.length > 0) {
                    const matches = rooms.filter(room => 
                        room.includes(value)
                    );
                    
                    matches.forEach(room => {
                        const item = document.createElement('div');
                        item.className = 'auto-complete-item';
                        item.textContent = room;
                        item.onclick = function() {
                            roomInput.value = room;
                            roomList.style.display = 'none';
                        };
                        roomList.appendChild(item);
                    });
                    
                    roomList.style.display = matches.length > 0 ? 'block' : 'none';
                } else {
                    roomList.style.display = 'none';
                }
            });

            // Hide auto-complete when clicking outside
            document.addEventListener('click', function(e) {
                if (!e.target.closest('.position-relative')) {
                    tenantList.style.display = 'none';
                    roomList.style.display = 'none';
                }
            });
        }

        // Form validation
        document.getElementById('billForm').addEventListener('submit', function(e) {
            const requiredFields = ['tenantName', 'roomNumber', 'electricityCost', 'waterCost', 'serviceCost', 'dueDate', 'status'];
            let isValid = true;
            let firstInvalidField = null;

            requiredFields.forEach(fieldId => {
                const field = document.getElementById(fieldId);
                if (!field.value.trim()) {
                    field.classList.add('is-invalid');
                    if (!firstInvalidField) firstInvalidField = field;
                    isValid = false;
                } else {
                    field.classList.remove('is-invalid');
                }
            });

            // Validate numeric fields
            const numericFields = ['electricityCost', 'waterCost', 'serviceCost'];
            numericFields.forEach(fieldId => {
                const field = document.getElementById(fieldId);
                const value = parseFloat(field.value);
                if (isNaN(value) || value < 0) {
                    field.classList.add('is-invalid');
                    if (!firstInvalidField) firstInvalidField = field;
                    isValid = false;
                }
            });

            if (!isValid) {
                e.preventDefault();
                if (firstInvalidField) {
                    firstInvalidField.focus();
                }
                alert('Vui lòng điền đầy đủ và chính xác thông tin bắt buộc!');
            }
        });

        // Real-time validation
        document.querySelectorAll('input, select').forEach(field => {
            field.addEventListener('blur', function() {
                if (this.hasAttribute('required') && !this.value.trim()) {
                    this.classList.add('is-invalid');
                } else {
                    this.classList.remove('is-invalid');
                }
            });
        });
    </script>
</body>
</html> 