<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chỉnh sửa thiết bị</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
</head>
<body>
    <div class="container mt-4">
        <div class="row justify-content-center">
            <div class="col-md-8">
                <div class="card shadow">
                    <div class="card-header bg-primary text-white">
                        <h4 class="mb-0">
                            <i class="fas fa-edit me-2"></i>
                            Chỉnh sửa thiết bị
                        </h4>
                    </div>
                    <div class="card-body">
                        <!-- Hiển thị thông báo lỗi -->
                        <c:if test="${not empty errorMessage}">
                            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                                <i class="fas fa-exclamation-triangle me-2"></i>
                                ${errorMessage}
                                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                            </div>
                        </c:if>

                        <!-- Form chỉnh sửa thiết bị -->
                        <form action="listdevices" method="post" id="editDeviceForm">
                            <input type="hidden" name="action" value="update">
                            <input type="hidden" name="deviceId" value="${device.deviceId}">
                            
                            <div class="mb-3">
                                <label for="deviceId" class="form-label">
                                    <i class="fas fa-hashtag me-1"></i>
                                    ID thiết bị
                                </label>
                                <input type="text" class="form-control" id="deviceIdDisplay" 
                                       value="${device.deviceId}" readonly>
                                <div class="form-text">ID thiết bị không thể thay đổi</div>
                            </div>

                            <div class="mb-3">
                                <label for="deviceName" class="form-label">
                                    <i class="fas fa-tag me-1"></i>
                                    Tên thiết bị <span class="text-danger">*</span>
                                </label>
                                <input type="text" class="form-control" id="deviceName" 
                                       name="deviceName" value="${device.deviceName}" 
                                       placeholder="Nhập tên thiết bị" maxlength="100" required>
                                <div class="invalid-feedback">
                                    Vui lòng nhập tên thiết bị
                                </div>
                            </div>

                            <div class="d-flex justify-content-between">
                                <a href="listdevices?action=list" class="btn btn-secondary">
                                    <i class="fas fa-arrow-left me-2"></i>
                                    Quay lại danh sách
                                </a>
                                <div>
                                    <button type="reset" class="btn btn-outline-secondary me-2">
                                        <i class="fas fa-undo me-2"></i>
                                        Đặt lại
                                    </button>
                                    <button type="submit" class="btn btn-primary">
                                        <i class="fas fa-save me-2"></i>
                                        Cập nhật thiết bị
                                    </button>
                                </div>
                            </div>
                        </form>
                    </div>
                </div>

                <!-- Thông tin bổ sung -->
                <div class="card mt-3">
                    <div class="card-body">
                        <h6 class="card-title">
                            <i class="fas fa-info-circle me-2"></i>
                            Lưu ý
                        </h6>
                        <ul class="mb-0">
                            <li>Tên thiết bị là bắt buộc và không được để trống</li>
                            <li>Tên thiết bị phải là duy nhất trong hệ thống</li>
                            <li>Độ dài tối đa của tên thiết bị là 100 ký tự</li>
                        </ul>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    
    <!-- Custom JavaScript -->
    <script>
        // Validation form
        (function() {
            'use strict';
            
            // Lấy form
            var form = document.getElementById('editDeviceForm');
            
            // Thêm event listener cho submit
            form.addEventListener('submit', function(event) {
                // Kiểm tra validation
                if (!form.checkValidity()) {
                    event.preventDefault();
                    event.stopPropagation();
                }
                
                // Thêm class bootstrap validation
                form.classList.add('was-validated');
            }, false);
            
            // Validation tên thiết bị
            var deviceNameInput = document.getElementById('deviceName');
            deviceNameInput.addEventListener('input', function() {
                var value = this.value.trim();
                
                if (value === '') {
                    this.setCustomValidity('Tên thiết bị không được để trống');
                } else if (value.length > 100) {
                    this.setCustomValidity('Tên thiết bị không được vượt quá 100 ký tự');
                } else {
                    this.setCustomValidity('');
                }
            });
            
            // Xử lý reset form
            var resetBtn = document.querySelector('button[type="reset"]');
            resetBtn.addEventListener('click', function() {
                form.classList.remove('was-validated');
                // Reset về giá trị ban đầu
                deviceNameInput.value = '${device.deviceName}';
                deviceNameInput.setCustomValidity('');
            });
        })();
        
        // Focus vào trường tên thiết bị khi trang load
        document.addEventListener('DOMContentLoaded', function() {
            document.getElementById('deviceName').focus();
            document.getElementById('deviceName').select();
        });
        
        // Tự động ẩn alert sau 5 giây
        setTimeout(function() {
            var alerts = document.querySelectorAll('.alert');
            alerts.forEach(function(alert) {
                var bsAlert = new bootstrap.Alert(alert);
                bsAlert.close();
            });
        }, 5000);
    </script>
</body>
</html>