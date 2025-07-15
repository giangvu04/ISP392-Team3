<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chỉnh sửa thiết bị</title>
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link href="css/homepage.css" rel="stylesheet">
    <style>
        
        .device-edit-new {
            background: #fff;
            border-radius: 2rem;
            box-shadow: 0 8px 32px rgba(120,80,200,0.10);
            padding: 2.5rem 2rem 2rem 2rem;
            margin: 3rem auto;
            max-width: 700px;
            width: 100%;
        }
        .device-edit-title {
            color: #7c3aed;
            font-weight: 800;
            font-size: 2.1rem;
            margin-bottom: 1.2rem;
            letter-spacing: -1px;
            text-align: center;
        }
        .device-edit-icon {
            font-size: 2.5rem;
            color: #7c3aed;
            margin-bottom: 0.5rem;
            text-align: center;
        }
        .device-edit-btns {
            display: flex;
            justify-content: center;
            gap: 1rem;
            margin-bottom: 1.5rem;
        }
        .device-edit-form-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 1.2rem;
            margin-bottom: 1.2rem;
        }
        .device-edit-form-row .form-group {
            background: #f3f0fa;
            border-radius: 1rem;
            padding: 1.1rem 1.2rem 0.5rem 1.2rem;
            display: flex;
            flex-direction: column;
        }
        .device-edit-form-row .form-label {
            color: #7c3aed;
            font-weight: 600;
            margin-bottom: 0.3rem;
        }
        .device-edit-form-row .form-control, .device-edit-form-row .form-control[readonly] {
            background: transparent;
            border: none;
            border-bottom: 1.5px solid #d1c4e9;
            border-radius: 0;
            font-size: 1.08rem;
            color: #222;
            padding-left: 0;
        }
        .device-edit-form-row .form-control:focus {
            box-shadow: none;
            border-bottom: 1.5px solid #7c3aed;
        }
        .alert-info {
            border-radius: 1rem;
            background: #e0e7ff;
            color: #3730a3;
            border: none;
            text-align: center;
            font-size: 1rem;
        }
        @media (max-width: 900px) {
            .device-edit-new { max-width: 98vw; }
            .device-edit-form-row { grid-template-columns: 1fr; }
        }
        @media (max-width: 600px) {
            .device-edit-new { padding: 1.2rem 0.5rem; }
            .device-edit-title { font-size: 1.3rem; }
        }
    </style>
</head>
<body>
    <div class="container-fluid">
        <div class="row min-vh-100">
            
                <jsp:include page="../Sidebar/SideBarManager.jsp"/>
            
            <div class="col-md-9 col-lg-10 d-flex align-items-center justify-content-center p-0">
                <div class="device-edit-new">
                    <div class="device-edit-icon"><i class="fas fa-edit"></i></div>
                    <div class="device-edit-title">Chỉnh sửa thiết bị</div>
                    <div class="device-edit-btns">
                        <a href="listdevices?action=list" class="btn btn-light btn-lg">
                            <i class="fas fa-arrow-left me-2"></i>Quay lại danh sách
                        </a>
                    </div>
                    <c:if test="${not empty errorMessage}">
                        <div class="alert alert-danger alert-dismissible fade show" role="alert" style="border-radius:1rem;">
                            <i class="fas fa-exclamation-triangle me-2"></i>
                            ${errorMessage}
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </div>
                    </c:if>
                    <form action="listdevices" method="post" id="editDeviceForm" novalidate>
                        <input type="hidden" name="action" value="update">
                        <input type="hidden" name="deviceId" value="${device.deviceId}">
                        <div class="device-edit-form-row">
                            <div class="form-group">
                                <label for="deviceId" class="form-label"><i class="fas fa-hashtag me-1"></i>ID thiết bị</label>
                                <input type="text" class="form-control" id="deviceIdDisplay" value="${device.deviceId}" readonly>
                                <div class="form-text">ID thiết bị không thể thay đổi</div>
                            </div>
                            <div class="form-group">
                                <label for="deviceName" class="form-label"><i class="fas fa-tag me-1"></i>Tên thiết bị <span class="text-danger">*</span></label>
                                <input type="text" class="form-control" id="deviceName" name="deviceName" value="${device.deviceName}" placeholder="Nhập tên thiết bị" maxlength="100" required>
                                <div class="invalid-feedback">Vui lòng nhập tên thiết bị</div>
                            </div>
                        </div>
                        <div class="device-edit-form-row">
                            <div class="form-group">
                                <label for="deviceCode" class="form-label"><i class="fas fa-barcode me-1"></i>Mã thiết bị</label>
                                <input type="text" class="form-control" id="deviceCode" name="deviceCode" value="${device.deviceCode}" readonly>
                            </div>
                            <div class="form-group">
                                <label for="latestWarrantyDate" class="form-label"><i class="fas fa-calendar-alt me-1"></i>Thời gian bảo hành gần nhất</label>
                                <input type="text" class="form-control" id="latestWarrantyDate" name="latestWarrantyDate" value="${device.latestWarrantyDate}" placeholder="Nhập ngày (VD: 2025-07-01)">
                                <div class="invalid-feedback">Vui lòng nhập thời gian bảo hành hợp lệ</div>
                            </div>
                        </div>
                        <div class="device-edit-form-row">
                            <div class="form-group">
                                <label for="purchaseDate" class="form-label"><i class="fas fa-calendar-check me-1"></i>Ngày mua máy</label>
                                <input type="text" class="form-control" id="purchaseDate" value="${device.purchaseDate}" readonly name="purchaseDate">
                            </div>
                            <div class="form-group">
                                <label for="warrantyExpiryDate" class="form-label"><i class="fas fa-calendar-times me-1"></i>Thời gian hết hạn bảo hành</label>
                                <input type="text" class="form-control" id="warrantyExpiryDate" value="${device.warrantyExpiryDate}" name="warrantyExpiryDate" readonly>
                            </div>
                        </div>
                        <div class="d-flex justify-content-end mt-4">
                            <button type="reset" class="btn btn-outline-secondary me-2">
                                <i class="fas fa-undo me-2"></i>Đặt lại
                            </button>
                            <button type="submit" class="btn btn-gradient">
                                <i class="fas fa-save me-2"></i>Cập nhật thiết bị
                            </button>
                        </div>
                    </form>
                    <div class="alert alert-info mt-4 mb-0">
                        <i class="fas fa-info-circle me-2"></i>Lưu ý: Tên thiết bị là bắt buộc và không được để trống. Thời gian bảo hành gần nhất có thể được cập nhật. Tên thiết bị phải là duy nhất trong hệ thống. Độ dài tối đa của tên thiết bị là 100 ký tự.
                    </div>
                </div>
            </div>
        </div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Validation form
        (function() {
            'use strict';
            var form = document.getElementById('editDeviceForm');
            form.addEventListener('submit', function(event) {
                if (!form.checkValidity()) {
                    event.preventDefault();
                    event.stopPropagation();
                }
                form.classList.add('was-validated');
            }, false);
            var deviceNameInput = document.getElementById('deviceName');
            var latestWarrantyDateInput = document.getElementById('latestWarrantyDate');
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
            latestWarrantyDateInput.addEventListener('input', function() {
                var value = this.value.trim();
                if (value.length > 10) {
                    this.setCustomValidity('Thời gian bảo hành không được vượt quá 10 ký tự');
                } else {
                    this.setCustomValidity('');
                }
            });
            var resetBtn = document.querySelector('button[type="reset"]');
            resetBtn.addEventListener('click', function() {
                form.classList.remove('was-validated');
                deviceNameInput.value = '${device.deviceName}';
                latestWarrantyDateInput.value = '${device.latestWarrantyDate}';
                deviceNameInput.setCustomValidity('');
                latestWarrantyDateInput.setCustomValidity('');
            });
        })();
        document.addEventListener('DOMContentLoaded', function() {
            document.getElementById('deviceName').focus();
            document.getElementById('deviceName').select();
        });
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