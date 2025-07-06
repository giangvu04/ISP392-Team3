<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Tạo hợp đồng mới - Manager Dashboard</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        :root {
            --primary-gradient: linear-gradient(135deg, #6B73FF 0%, #000DFF 100%);
            --sidebar-bg: linear-gradient(135deg, #4e54c8 0%, #8f94fb 100%);
            --card-shadow: 0 6px 10px rgba(0,0,0,0.08);
        }

        .sidebar {
            min-height: 100vh;
            background: var(--sidebar-bg);
        }

        .sidebar .navLink {
            color: rgba(255,255,255,0.85);
            padding: 12px 20px;
            margin: 4px 0;
            border-radius: 8px;
            transition: all 0.3s ease;
        }

        .sidebar .navLink:hover,
        .sidebar .navLink.active {
            background-color: rgba(255,255,255,0.15);
            color: white;
            transform: translateX(5px);
        }

        .mainContent {
            background-color: #f5f7ff;
            min-height: 100vh;
        }

        .page-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 2rem 0;
            margin-bottom: 2rem;
            border-radius: 15px;
        }

        .form-container {
            background: white;
            border-radius: 15px;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
            overflow: hidden;
        }

        .form-control, .form-select {
            border-radius: 10px;
            border: 2px solid #e9ecef;
            padding: 12px 15px;
            transition: all 0.3s ease;
        }

        .form-control:focus, .form-select:focus {
            border-color: #667eea;
            box-shadow: 0 0 0 0.2rem rgba(102, 126, 234, 0.25);
            transform: translateY(-1px);
        }

        .btn-action {
            border-radius: 25px;
            padding: 12px 30px;
            font-weight: 600;
            transition: all 0.3s ease;
        }

        .btn-gradient {
            background: linear-gradient(45deg, #667eea, #764ba2);
            border: none;
            color: white;
        }

        .btn-gradient:hover {
            background: linear-gradient(45deg, #764ba2, #667eea);
            color: white;
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(0,0,0,0.2);
        }

        .required-field::after {
            content: " *";
            color: red;
            font-weight: bold;
        }

        .form-section {
            padding: 1.5rem;
            border-bottom: 1px solid #e9ecef;
        }

        .form-section:last-child {
            border-bottom: none;
        }

        .form-section h5 {
            color: #495057;
            margin-bottom: 1rem;
            font-weight: 600;
        }

        .alert {
            border-radius: 10px;
            border: none;
        }

        .currency-input {
            position: relative;
        }

        .currency-symbol {
            position: absolute;
            right: 15px;
            top: 50%;
            transform: translateY(-50%);
            color: #6c757d;
            font-weight: 500;
        }

        .form-floating label {
            color: #6c757d;
        }

        .error-field {
            border-color: #dc3545 !important;
            box-shadow: 0 0 0 0.2rem rgba(220, 53, 69, 0.25) !important;
        }

        .formLabel {
            font-weight: 500;
            color: #555;
        }

        .card {
            border: none;
            border-radius: 12px;
            box-shadow: var(--card-shadow);
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }

        .card:hover {
            transform: translateY(-5px);
            box-shadow: 0 12px 20px rgba(0,0,0,0.1);
        }

        .formSection {
            background: white;
            border-radius: 12px;
            padding: 2rem;
            box-shadow: var(--card-shadow);
        }

        .btnPrimary {
            background: var(--primary-gradient);
            border: none;
            padding: 10px 25px;
            border-radius: 8px;
        }
    </style>
</head>
<body>
    <div class="container-fluid">
        <div class="row">
            <!-- Sidebar -->
            <div class="col-md-3 col-lg-2 d-md-block sidebar collapse">
                <div class="position-sticky pt-3">
                    <ul class="nav flex-column">
                        <li class="navItem">
                            <a class="navLink" href="ManagerHomepage">
                                <i class="fas fa-tachometer-alt me-2"></i>Dashboard
                            </a>
                        </li>
                        <li class="navItem">
                            <a class="navLink" href="listrooms">
                                <i class="fas fa-door-open me-2"></i>Quản lý Phòng
                            </a>
                        </li>
                        <li class="navItem">
                            <a class="navLink active" href="listcontracts">
                                <i class="fas fa-file-contract me-2"></i>Quản lý Hợp đồng
                            </a>
                        </li>
                        <li class="navItem">
                            <a class="navLink" href="#">
                                <i class="fas fa-users me-2"></i>Quản lý Người thuê
                            </a>
                        </li>
                    </ul>
                </div>
            </div>

            <!-- Main content -->
            <main class="col-md-9 ms-sm-auto col-lg-10 px-md-4 mainContent">
                <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
                    <h1 class="h2">
                        <i class="fas fa-file-contract me-3"></i>Tạo hợp đồng mới
                    </h1>
                    <div class="btn-toolbar mb-2 mb-md-0">
                        <a href="listcontracts" class="btn btn-sm btn-outline-secondary">
                            <i class="fas fa-arrow-left me-1"></i>Quay lại danh sách
                        </a>
                    </div>
                </div>

                <!-- Include messages -->
                <%@include file="messages.jsp" %>

                <!-- Alert Messages -->
                <c:if test="${not empty sessionScope.errorMessage}">
                    <div class="alert alert-danger alert-dismissible fade show" role="alert">
                        <i class="fas fa-exclamation-triangle me-2"></i>
                        ${sessionScope.errorMessage}
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                    <c:remove var="errorMessage" scope="session"/>
                </c:if>

                <c:if test="${not empty errorMessage}">
                    <div class="alert alert-danger alert-dismissible fade show" role="alert">
                        <i class="fas fa-exclamation-triangle me-2"></i>
                        ${errorMessage}
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                </c:if>

                <c:if test="${not empty sessionScope.successMessage}">
                    <div class="alert alert-success alert-dismissible fade show" role="alert">
                        <i class="fas fa-check-circle me-2"></i>
                        ${sessionScope.successMessage}
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                    <c:remove var="successMessage" scope="session"/>
                </c:if>

                <!-- Add Contract Form -->
                <div class="row">
                    <div class="col-lg-10 mx-auto">
                        <div class="formSection">
                            <form action="addcontract" method="POST" id="contractForm">
                                
                                <!-- Contract ID Section -->
                                <div class="row mb-3">
                                    <div class="col-md-6">
                                        <label for="contractId" class="formLabel">Contract ID</label>
                                        <input type="number" class="form-control ${not empty contractIdError ? 'error-field' : ''}" 
                                        id="contractId" name="contractId" value="${contractId}" min="1" placeholder="Để trống để tự động tạo">
                                        <div class="form-text">
                                            <i class="fas fa-info-circle me-1"></i>Để trống để hệ thống tự động tạo ID. Nếu nhập, phải là số dương và chưa tồn tại.
                                        </div>
                                        <c:if test="${not empty contractIdError}">
                                            <div class="text-danger small mt-1">
                                                <i class="fas fa-exclamation-circle me-1"></i>${contractIdError}
                                            </div>
                                        </c:if>
                                    </div>
                                </div>
                                
                                <!-- Basic Information Section -->
                                <div class="row mb-3">
                                    <div class="col-md-6">
                                        <label for="roomId" class="formLabel required-field">Room ID</label>
                                        <input type="number" class="form-control ${not empty roomIdError ? 'error-field' : ''}" 
                                               id="roomId" name="roomId" value="${roomId}" required min="1">
                                        <div class="form-text">
                                            <i class="fas fa-info-circle me-1"></i>Nhập ID của phòng cần cho thuê
                                        </div>
                                        <c:if test="${not empty roomIdError}">
                                            <div class="text-danger small mt-1">
                                                <i class="fas fa-exclamation-circle me-1"></i>${roomIdError}
                                            </div>
                                        </c:if>
                                    </div>
                                    <div class="col-md-6">
                                        <label for="tenantId" class="formLabel required-field">Tenant ID</label>
                                        <input type="number" class="form-control ${not empty tenantIdError ? 'error-field' : ''}" 
                                               id="tenantId" name="tenantId" value="${tenantId}" required min="1">
                                        <div class="form-text">
                                            <i class="fas fa-info-circle me-1"></i>Nhập ID của người thuê
                                        </div>
                                        <c:if test="${not empty tenantIdError}">
                                            <div class="text-danger small mt-1">
                                                <i class="fas fa-exclamation-circle me-1"></i>${tenantIdError}
                                            </div>
                                        </c:if>
                                    </div>
                                </div>

                                <!-- Contract Duration Section -->
                                <div class="row mb-3">
                                    <div class="col-md-6">
                                        <label for="startDate" class="formLabel required-field">Start Date</label>
                                        <input type="date" class="form-control ${not empty startDateError ? 'error-field' : ''}" 
                                               id="startDate" name="startDate" value="${startDate}" required>
                                        <c:if test="${not empty startDateError}">
                                            <div class="text-danger small mt-1">
                                                <i class="fas fa-exclamation-circle me-1"></i>${startDateError}
                                            </div>
                                        </c:if>
                                    </div>
                                    <div class="col-md-6">
                                        <label for="endDate" class="formLabel">End Date</label>
                                        <input type="date" class="form-control ${not empty endDateError ? 'error-field' : ''}" 
                                               id="endDate" name="endDate" value="${endDate}">
                                        <div class="form-text">
                                            <i class="fas fa-info-circle me-1"></i>Để trống nếu chưa xác định
                                        </div>
                                        <c:if test="${not empty endDateError}">
                                            <div class="text-danger small mt-1">
                                                <i class="fas fa-exclamation-circle me-1"></i>${endDateError}
                                            </div>
                                        </c:if>
                                    </div>
                                </div>

                                <!-- Financial Information Section -->
                                <div class="row mb-3">
                                    <div class="col-md-6">
                                        <label for="rentPrice" class="formLabel required-field">Rent Price (VNĐ)</label>
                                        <input type="number" class="form-control ${not empty rentPriceError ? 'error-field' : ''}" 
                                               id="rentPrice" name="rentPrice" value="${rentPrice}" required min="0" step="1000">
                                        <c:if test="${not empty rentPriceError}">
                                            <div class="text-danger small mt-1">
                                                <i class="fas fa-exclamation-circle me-1"></i>${rentPriceError}
                                            </div>
                                        </c:if>
                                    </div>
                                    <div class="col-md-6">
                                        <label for="depositAmount" class="formLabel">Deposit Amount (VNĐ)</label>
                                        <input type="number" class="form-control ${not empty depositAmountError ? 'error-field' : ''}" 
                                               id="depositAmount" name="depositAmount" value="${depositAmount}" min="0" step="1000">
                                        <div class="form-text">
                                            <i class="fas fa-info-circle me-1"></i>Để trống hoặc 0 nếu không có tiền cọc
                                        </div>
                                        <c:if test="${not empty depositAmountError}">
                                            <div class="text-danger small mt-1">
                                                <i class="fas fa-exclamation-circle me-1"></i>${depositAmountError}
                                            </div>
                                        </c:if>
                                    </div>
                                </div>

                                <!-- Contract Status and Notes Section -->
                                <div class="row mb-3">
                                    <div class="col-md-6">
                                        <label for="status" class="formLabel">Contract Status</label>
                                        <select class="form-select" id="status" name="status">
                                            <option value="0" ${status == 0 ? 'selected' : ''}>Tạm dừng</option>
                                            <option value="1" ${status == 1 || empty status ? 'selected' : ''}>Đang hoạt động</option>
                                            <option value="2" ${status == 2 ? 'selected' : ''}>Chờ xử lý</option>
                                        </select>
                                    </div>
                                </div>

                                <div class="mb-3">
                                    <label for="note" class="formLabel">Notes</label>
                                    <textarea class="form-control" id="note" name="note" 
                                              rows="3" placeholder="Nhập ghi chú...">${note}</textarea>
                                    <div class="form-text">
                                        <i class="fas fa-info-circle me-1"></i>Thêm các thông tin bổ sung về hợp đồng (không bắt buộc)
                                    </div>
                                </div>

                                <!-- Form Actions -->
                                <div class="d-grid gap-2 d-md-flex justify-content-md-end">
                                    <button type="reset" class="btn btn-outline-secondary me-md-2" onclick="resetForm()">
                                        <i class="fas fa-undo me-1"></i>Reset
                                    </button>
                                    <button type="submit" class="btn btnPrimary">
                                        <i class="fas fa-save me-1"></i>Tạo hợp đồng
                                    </button>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>

                <!-- Help Section -->
                <div class="row mt-4">
                    <div class="col-12">
                        <div class="card border-0" style="background: linear-gradient(135deg, #e3f2fd 0%, #bbdefb 100%);">
                            <div class="card-body">
                                <h6 class="card-title">
                                    <i class="fas fa-lightbulb me-2 text-warning"></i>Hướng dẫn sử dụng
                                </h6>
                                <div class="row">
                                    <div class="col-md-6">
                                        <ul class="mb-0">
                                            <li>Các trường có dấu <span class="text-danger">*</span> là bắt buộc</li>
                                            <li>Contract ID có thể để trống để hệ thống tự tạo</li>
                                            <li>Room ID và Tenant ID phải là số dương</li>
                                            <li>End Date có thể để trống nếu chưa xác định</li>
                                        </ul>
                                    </div>
                                    <div class="col-md-6">
                                        <ul class="mb-0">
                                            <li>Rent Price và Deposit Amount tính bằng VNĐ</li>
                                            <li>Status mặc định là "Đang hoạt động"</li>
                                            <li>Notes có thể để trống</li>
                                            <li>Mỗi phòng chỉ có thể có một hợp đồng đang hoạt động</li>
                                        </ul>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </main>
        </div>
    </div>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://kit.fontawesome.com/a076d05399.js" crossorigin="anonymous"></script>
    
    <script>
        // Set default start date to today
        document.addEventListener('DOMContentLoaded', function() {
            const startDateInput = document.getElementById('startDate');
            if (!startDateInput.value) {
                const today = new Date().toISOString().split('T')[0];
                startDateInput.value = today;
            }
        });

        // Form validation
        document.getElementById('contractForm').addEventListener('submit', function(e) {
            const contractId = document.getElementById('contractId').value;
            const roomId = document.getElementById('roomId').value;
            const tenantId = document.getElementById('tenantId').value;
            const startDate = document.getElementById('startDate').value;
            const endDate = document.getElementById('endDate').value;
            const rentPrice = document.getElementById('rentPrice').value;
            
            // Validate required fields
            if (!roomId || !tenantId || !startDate || !rentPrice) {
                e.preventDefault();
                showAlert('Vui lòng điền đầy đủ các trường bắt buộc!', 'danger');
                return;
            }
            
            // Validate contract ID if provided
            if (contractId && contractId.trim() !== '') {
                const contractIdNum = parseInt(contractId);
                if (isNaN(contractIdNum) || contractIdNum <= 0) {
                    e.preventDefault();
                    showAlert('Contract ID phải là số dương!', 'danger');
                    return;
                }
            }
            
            // Validate positive numbers
            if (parseInt(roomId) <= 0 || parseInt(tenantId) <= 0) {
                e.preventDefault();
                showAlert('Room ID và Tenant ID phải là số dương!', 'danger');
                return;
            }
            
            // Validate rent price
            if (parseFloat(rentPrice) <= 0) {
                e.preventDefault();
                showAlert('Rent Price phải lớn hơn 0!', 'danger');
                return;
            }
            
            // Validate date range
            if (endDate && new Date(endDate) <= new Date(startDate)) {
                e.preventDefault();
                showAlert('End Date phải sau Start Date!', 'danger');
                return;
            }
            
            // Show loading state
            const submitBtn = this.querySelector('button[type="submit"]');
            submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin me-1"></i>Đang tạo...';
            submitBtn.disabled = true;
        });

        // Reset form function
        function resetForm() {
            if (confirm('Bạn có chắc chắn muốn làm mới form? Tất cả dữ liệu đã nhập sẽ bị xóa.')) {
                document.getElementById('contractForm').reset();
                const today = new Date().toISOString().split('T')[0];
                document.getElementById('startDate').value = today;
                document.getElementById('status').value = '1';
                
                // Remove error styling
                document.querySelectorAll('.error-field').forEach(field => {
                    field.classList.remove('error-field');
                });
            }
        }

        // Show alert function
        function showAlert(message, type) {
            const alertDiv = document.createElement('div');
            alertDiv.className = `alert alert-${type} alert-dismissible fade show`;
            alertDiv.innerHTML = `
                <i class="fas fa-exclamation-triangle me-2"></i>
                ${message}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            `;
            
            const container = document.querySelector('main');
            const firstChild = container.querySelector('.d-flex');
            container.insertBefore(alertDiv, firstChild.nextSibling);
            
            // Auto hide after 5 seconds
            setTimeout(() => {
                const alert = new bootstrap.Alert(alertDiv);
                alert.close();
            }, 5000);
        }

        // Auto-hide alerts
        document.addEventListener('DOMContentLoaded', function() {
            const alerts = document.querySelectorAll('.alert-dismissible');
            alerts.forEach(function(alert) {
                setTimeout(function() {
                    const bsAlert = new bootstrap.Alert(alert);
                    bsAlert.close();
                }, 5000);
            });
        });

        // Enhance form UX with animations
        document.querySelectorAll('.form-control, .form-select').forEach(function(element) {
            element.addEventListener('focus', function() {
                this.style.transform = 'scale(1.02)';
                this.style.transition = 'transform 0.3s ease';
            });
            
            element.addEventListener('blur', function() {
                this.style.transform = 'scale(1)';
            });
        });
    </script>
</body>
</html>