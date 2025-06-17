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
        .page-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 2rem 0;
            margin-bottom: 2rem;
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
        .input-group-text {
            background: linear-gradient(45deg, #667eea, #764ba2);
            color: white;
            border: none;
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
    </style>
</head>
<body class="bg-light">
    <!-- Page Header -->
    <div class="page-header">
        <div class="container">
            <div class="row align-items-center">
                <div class="col-md-8">
                    <h1 class="mb-0">
                        <i class="fas fa-file-contract me-3"></i>Tạo hợp đồng mới
                    </h1>
                    <p class="mb-0 mt-2 opacity-75">Thêm hợp đồng cho thuê phòng trọ</p>
                </div>
                <div class="col-md-4 text-end">
                    <a href="${pageContext.request.contextPath}/listcontracts" class="btn btn-light btn-lg">
                        <i class="fas fa-arrow-left me-2"></i>Quay lại danh sách
                    </a>
                </div>
            </div>
        </div>
    </div>

    <div class="container">
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
        <div class="row justify-content-center">
            <div class="col-lg-10">
                <div class="form-container">
                    <form action="${pageContext.request.contextPath}/listcontracts" method="POST" id="contractForm">
                        <input type="hidden" name="action" value="add">
                        
                        <!-- Contract ID Section -->
                        <div class="form-section">
                            <h5><i class="fas fa-id-card me-2 text-info"></i>Mã hợp đồng</h5>
                            <div class="row g-3">
                                <div class="col-md-6">
                                    <div class="form-floating">
                                        <input type="number" class="form-control ${not empty contractIdError ? 'error-field' : ''}" 
                                        id="contractId" name="contractId" value="${contractId}" min="1" placeholder="Nhập ID hợp đồng">
                                    <label for="contractId">ID Hợp đồng (Tùy chọn)</label>
                                    </div>
                                    <div class="form-text">
                                        <i class="fas fa-info-circle me-1"></i>Để trống để hệ thống tự động tạo ID. Nếu nhập, phải là số dương và chưa tồn tại.
                                    </div>
                                    <!-- HIỂN THỊ LỖI CHO CONTRACT ID -->
                                    <c:if test="${not empty contractIdError}">
                                        <div class="text-danger small mt-1">
                                            <i class="fas fa-exclamation-circle me-1"></i>${contractIdError}
                                        </div>
                                    </c:if>
                                </div>
                            </div>
                        </div>
                        
                        <!-- Basic Information Section -->
                        <div class="form-section">
                            <h5><i class="fas fa-info-circle me-2 text-primary"></i>Thông tin cơ bản</h5>
                            <div class="row g-3">
                                <!-- Room ID -->
                                <div class="col-md-6">
                                    <div class="form-floating">
                                        <input type="number" class="form-control ${not empty roomIdError ? 'error-field' : ''}" 
                                               id="roomId" name="roomId" value="${roomId}" required min="1">
                                        <label for="roomId" class="required-field">ID Phòng</label>
                                    </div>
                                    <div class="form-text">
                                        <i class="fas fa-info-circle me-1"></i>Nhập ID của phòng cần cho thuê
                                    </div>
                                    <c:if test="${not empty roomIdError}">
                                        <div class="text-danger small mt-1">
                                            <i class="fas fa-exclamation-circle me-1"></i>${roomIdError}
                                        </div>
                                    </c:if>
                                </div>

                                <!-- Tenant ID -->
                                <div class="col-md-6">
                                    <div class="form-floating">
                                        <input type="number" class="form-control ${not empty tenantIdError ? 'error-field' : ''}" 
                                               id="tenantId" name="tenantId" value="${tenantId}" required min="1">
                                        <label for="tenantId" class="required-field">ID Người thuê</label>
                                    </div>
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
                        </div>

                        <!-- Contract Duration Section -->
                        <div class="form-section">
                            <h5><i class="fas fa-calendar-alt me-2 text-success"></i>Thời gian hợp đồng</h5>
                            <div class="row g-3">
                                <!-- Start Date -->
                                <div class="col-md-6">
                                    <div class="form-floating">
                                        <input type="date" class="form-control ${not empty startDateError ? 'error-field' : ''}" 
                                               id="startDate" name="startDate" value="${startDate}" required>
                                        <label for="startDate" class="required-field">Ngày bắt đầu</label>
                                    </div>
                                    <c:if test="${not empty startDateError}">
                                        <div class="text-danger small mt-1">
                                            <i class="fas fa-exclamation-circle me-1"></i>${startDateError}
                                        </div>
                                    </c:if>
                                </div>

                                <!-- End Date -->
                                <div class="col-md-6">
                                    <div class="form-floating">
                                        <input type="date" class="form-control ${not empty endDateError ? 'error-field' : ''}" 
                                               id="endDate" name="endDate" value="${endDate}">
                                        <label for="endDate">Ngày kết thúc</label>
                                    </div>
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
                        </div>

                        <!-- Financial Information Section -->
                        <div class="form-section">
                            <h5><i class="fas fa-money-bill-wave me-2 text-warning"></i>Thông tin tài chính</h5>
                            <div class="row g-3">
                                <!-- Rent Price -->
                                <div class="col-md-6">
                                    <div class="form-floating currency-input">
                                        <input type="number" class="form-control ${not empty rentPriceError ? 'error-field' : ''}" 
                                               id="rentPrice" name="rentPrice" value="${rentPrice}" required min="0" step="1000">
                                        <label for="rentPrice" class="required-field">Giá thuê hàng tháng</label>
                                        <span class="currency-symbol">VNĐ</span>
                                    </div>
                                    <c:if test="${not empty rentPriceError}">
                                        <div class="text-danger small mt-1">
                                            <i class="fas fa-exclamation-circle me-1"></i>${rentPriceError}
                                        </div>
                                    </c:if>
                                </div>

                                <!-- Deposit Amount -->
                                <div class="col-md-6">
                                    <div class="form-floating currency-input">
                                        <input type="number" class="form-control ${not empty depositAmountError ? 'error-field' : ''}" 
                                               id="depositAmount" name="depositAmount" value="${depositAmount}" min="0" step="1000">
                                        <label for="depositAmount">Tiền đặt cọc</label>
                                        <span class="currency-symbol">VNĐ</span>
                                    </div>
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
                        </div>

                        <!-- Contract Status and Notes Section -->
                        <div class="form-section">
                            <h5><i class="fas fa-cog me-2 text-info"></i>Trạng thái và ghi chú</h5>
                            <div class="row g-3">
                                <!-- Status -->
                                <div class="col-md-6">
                                    <div class="form-floating">
                                        <select class="form-select" id="status" name="status">
                                            <option value="0" ${status == 0 ? 'selected' : ''}>Không hoạt động</option>
                                            <option value="1" ${status == 1 || empty status ? 'selected' : ''}>Đang hoạt động</option>
                                        </select>
                                        <label for="status">Trạng thái hợp đồng</label>
                                    </div>
                                </div>
                            </div>

                            <!-- Notes -->
                            <div class="row g-3 mt-2">
                                <div class="col-12">
                                    <div class="form-floating">
                                        <textarea class="form-control" id="note" name="note" 
                                                  style="height: 120px;" placeholder="Nhập ghi chú...">${note}</textarea>
                                        <label for="note">Ghi chú</label>
                                    </div>
                                    <div class="form-text">
                                        <i class="fas fa-info-circle me-1"></i>Thêm các thông tin bổ sung về hợp đồng (không bắt buộc)
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Form Actions -->
                        <div class="form-section">
                            <div class="d-flex justify-content-end gap-3">
                                <a href="${pageContext.request.contextPath}/listcontracts" 
                                   class="btn btn-outline-secondary btn-action">
                                    <i class="fas fa-times me-2"></i>Hủy bỏ
                                </a>
                                <button type="button" class="btn btn-outline-info btn-action" onclick="resetForm()">
                                    <i class="fas fa-undo me-2"></i>Làm mới
                                </button>
                                <button type="submit" class="btn btn-gradient btn-action">
                                    <i class="fas fa-save me-2"></i>Tạo hợp đồng
                                </button>
                            </div>
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
                                    <li>ID Hợp đồng có thể để trống để hệ thống tự tạo</li>
                                    <li>ID Phòng và ID Người thuê phải là số dương</li>
                                    <li>Ngày kết thúc có thể để trống nếu chưa xác định</li>
                                </ul>
                            </div>
                            <div class="col-md-6">
                                <ul class="mb-0">
                                    <li>Giá thuê và tiền cọc tính bằng VNĐ</li>
                                    <li>Trạng thái mặc định là "Đang hoạt động"</li>
                                    <li>Ghi chú có thể để trống</li>
                                    <li>Mỗi phòng chỉ có thể có một hợp đồng đang hoạt động</li>
                                </ul>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    
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
            showAlert('ID Hợp đồng phải là số dương!', 'danger');
            return;
        }
    }
    
    // Validate positive numbers
    if (parseInt(roomId) <= 0 || parseInt(tenantId) <= 0) {
        e.preventDefault();
        showAlert('ID Phòng và ID Người thuê phải là số dương!', 'danger');
        return;
    }
    
    // Validate rent price
    if (parseFloat(rentPrice) <= 0) {
        e.preventDefault();
        showAlert('Giá thuê phải lớn hơn 0!', 'danger');
        return;
    }
    
    // Validate date range
    if (endDate && new Date(endDate) <= new Date(startDate)) {
        e.preventDefault();
        showAlert('Ngày kết thúc phải sau ngày bắt đầu!', 'danger');
        return;
    }
    
    // Show loading state
    const submitBtn = this.querySelector('button[type="submit"]');
    submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin me-2"></i>Đang tạo...';
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
            
            const container = document.querySelector('.container');
            container.insertBefore(alertDiv, container.firstChild);
            
            // Auto hide after 5 seconds
            setTimeout(() => {
                const alert = new bootstrap.Alert(alertDiv);
                alert.close();
            }, 5000);
        }

        // Format currency inputs
        document.getElementById('rentPrice').addEventListener('input', function(e) {
            formatCurrencyInput(e.target);
        });
        
        document.getElementById('depositAmount').addEventListener('input', function(e) {
            formatCurrencyInput(e.target);
        });
        
        function formatCurrencyInput(input) {
            let value = input.value.replace(/\D/g, '');
            if (value) {
                input.value = parseInt(value);
            }
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
                this.closest('.form-floating, .currency-input').style.transform = 'scale(1.02)';
            });
            
            element.addEventListener('blur', function() {
                this.closest('.form-floating, .currency-input').style.transform = 'scale(1)';
            });
        });
    </script>
</body>
</html>