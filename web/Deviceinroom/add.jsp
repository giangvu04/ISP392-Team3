<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thêm Thiết Bị Vào Phòng - House Sharing</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            padding: 20px;
        }

        .container {
            max-width: 700px;
            margin: 0 auto;
            background: white;
            border-radius: 15px;
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.1);
            overflow: hidden;
            animation: slideUp 0.6s ease-out;
        }

        @keyframes slideUp {
            from {
                opacity: 0;
                transform: translateY(30px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .header {
            background: linear-gradient(135deg, #4CAF50, #45a049);
            color: white;
            padding: 30px;
            text-align: center;
            position: relative;
        }

        .header::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: url('data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 20"><defs><radialGradient id="a" cx="50%" cy="0%" r="50%"><stop offset="0%" style="stop-color:rgb(255,255,255);stop-opacity:0.1" /><stop offset="100%" style="stop-color:rgb(255,255,255);stop-opacity:0" /></radialGradient></defs><rect width="100" height="20" fill="url(%23a)" /></svg>') repeat-x;
        }

        .header h1 {
            font-size: 2.2rem;
            font-weight: 300;
            margin-bottom: 8px;
            position: relative;
        }

        .header .subtitle {
            font-size: 1rem;
            opacity: 0.9;
            position: relative;
        }

        .header i {
            font-size: 3rem;
            margin-bottom: 15px;
            opacity: 0.8;
        }

        .form-container {
            padding: 40px;
        }

        .breadcrumb {
            margin-bottom: 30px;
            padding: 15px;
            background: #f8f9fa;
            border-radius: 8px;
            border-left: 4px solid #4CAF50;
        }

        .breadcrumb a {
            color: #666;
            text-decoration: none;
            font-weight: 500;
            transition: color 0.3s ease;
        }

        .breadcrumb a:hover {
            color: #4CAF50;
        }

        .breadcrumb .current {
            color: #4CAF50;
            font-weight: 600;
        }

        .form-group {
            margin-bottom: 25px;
        }

        .form-group label {
            display: block;
            margin-bottom: 8px;
            font-weight: 600;
            color: #333;
            font-size: 0.95rem;
        }

        .form-group label .required {
            color: #e74c3c;
            margin-left: 3px;
        }

        .form-control {
            width: 100%;
            padding: 12px 16px;
            border: 2px solid #e1e5e9;
            border-radius: 8px;
            font-size: 1rem;
            transition: all 0.3s ease;
            background: #fff;
        }

        .form-control:focus {
            outline: none;
            border-color: #4CAF50;
            box-shadow: 0 0 0 3px rgba(76, 175, 80, 0.1);
            transform: translateY(-1px);
        }

        .form-control:hover {
            border-color: #c1c7cd;
        }

        .input-group {
            position: relative;
        }

        .input-group i {
            position: absolute;
            left: 12px;
            top: 50%;
            transform: translateY(-50%);
            color: #666;
            font-size: 1.1rem;
        }

        .input-group .form-control {
            padding-left: 45px;
        }

        .btn-group {
            display: flex;
            gap: 15px;
            margin-top: 35px;
        }

        .btn {
            padding: 12px 30px;
            border: none;
            border-radius: 8px;
            font-size: 1rem;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            justify-content: center;
            flex: 1;
        }

        .btn-primary {
            background: linear-gradient(135deg, #4CAF50, #45a049);
            color: white;
            box-shadow: 0 4px 15px rgba(76, 175, 80, 0.3);
        }

        .btn-primary:hover {
            background: linear-gradient(135deg, #45a049, #3d8b40);
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(76, 175, 80, 0.4);
        }

        .btn-secondary {
            background: #6c757d;
            color: white;
            box-shadow: 0 4px 15px rgba(108, 117, 125, 0.3);
        }

        .btn-secondary:hover {
            background: #5a6268;
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(108, 117, 125, 0.4);
        }

        .alert {
            padding: 15px 20px;
            border-radius: 8px;
            margin-bottom: 25px;
            display: flex;
            align-items: center;
            gap: 10px;
            font-weight: 500;
            animation: fadeIn 0.5s ease-out;
        }

        @keyframes fadeIn {
            from {
                opacity: 0;
                transform: translateY(-10px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .alert-danger {
            background: #fee;
            color: #c33;
            border: 1px solid #fcc;
        }

        .alert-success {
            background: #efe;
            color: #363;
            border: 1px solid #cfc;
        }

        .alert i {
            font-size: 1.2rem;
        }

        .form-help {
            font-size: 0.85rem;
            color: #666;
            margin-top: 5px;
            font-style: italic;
        }

        .card-footer {
            background: #f8f9fa;
            padding: 20px 40px;
            border-top: 1px solid #e9ecef;
            text-align: center;
            color: #666;
            font-size: 0.9rem;
        }

        .status-options {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));
            gap: 10px;
            margin-top: 8px;
        }

        .status-option {
            position: relative;
        }

        .status-option input[type="radio"] {
            position: absolute;
            opacity: 0;
            cursor: pointer;
        }

        .status-option label {
            display: block;
            padding: 12px 16px;
            border: 2px solid #e1e5e9;
            border-radius: 8px;
            cursor: pointer;
            text-align: center;
            transition: all 0.3s ease;
            font-weight: 500;
            margin-bottom: 0;
        }

        .status-option input[type="radio"]:checked + label {
            border-color: #4CAF50;
            background: #f0f8f0;
            color: #4CAF50;
        }

        .status-option label:hover {
            border-color: #4CAF50;
            background: #f9f9f9;
        }

        .quantity-group {
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .quantity-btn {
            width: 40px;
            height: 40px;
            border: 2px solid #e1e5e9;
            background: white;
            border-radius: 6px;
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: 600;
            transition: all 0.3s ease;
        }

        .quantity-btn:hover {
            border-color: #4CAF50;
            background: #f0f8f0;
            color: #4CAF50;
        }

        .quantity-input {
            width: 80px;
            text-align: center;
            padding: 8px;
        }

        @media (max-width: 768px) {
            .container {
                margin: 10px;
                border-radius: 10px;
            }

            .header {
                padding: 20px;
            }

            .header h1 {
                font-size: 1.8rem;
            }

            .form-container {
                padding: 25px;
            }

            .btn-group {
                flex-direction: column;
            }

            .btn {
                width: 100%;
            }

            .status-options {
                grid-template-columns: 1fr;
            }

            .quantity-group {
                justify-content: center;
            }
        }

        .btn:disabled {
            opacity: 0.6;
            cursor: not-allowed;
            transform: none !important;
        }

        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }

        .fa-spin {
            animation: spin 1s linear infinite;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <i class="fas fa-plus-circle"></i>
            <h1>Thêm Thiết Bị Vào Phòng</h1>
            <div class="subtitle">Gán thiết bị cho phòng cụ thể với số lượng và trạng thái</div>
        </div>

        <div class="form-container">
            <!-- Breadcrumb -->
            <div class="breadcrumb">
                <a href="deviceinroom?action=list">
                    <i class="fas fa-home"></i> Danh sách thiết bị trong phòng
                </a>
                <span> / </span>
                <span class="current">Thêm thiết bị vào phòng</span>
            </div>

            <!-- Error/Success Messages -->
            <c:if test="${not empty sessionScope.errorMessage}">
                <div class="alert alert-danger">
                    <i class="fas fa-exclamation-triangle"></i>
                    ${sessionScope.errorMessage}
                </div>
                <c:remove var="errorMessage" scope="session"/>
            </c:if>

            <c:if test="${not empty errorMessage}">
                <div class="alert alert-danger">
                    <i class="fas fa-exclamation-triangle"></i>
                    ${errorMessage}
                </div>
            </c:if>

            <c:if test="${not empty sessionScope.successMessage}">
                <div class="alert alert-success">
                    <i class="fas fa-check-circle"></i>
                    ${sessionScope.successMessage}
                </div>
                <c:remove var="successMessage" scope="session"/>
            </c:if>

            <!-- Add Device to Room Form -->
            <form action="deviceinroom" method="post" id="addDeviceToRoomForm">
                <input type="hidden" name="action" value="add">
                
                <div class="form-group">
                    <label for="roomId">
                        ID Phòng
                        <span class="required">*</span>
                    </label>
                    <div class="input-group">
                        <i class="fas fa-door-open"></i>
                        <input type="number" 
                               class="form-control" 
                               id="roomId" 
                               name="roomId" 
                               placeholder="Nhập ID phòng"
                               value="${preselectedRoomId}"
                               required
                               min="1">
                    </div>
                    <div class="form-help">
                        Nhập ID của phòng muốn thêm thiết bị
                    </div>
                </div>

                <div class="form-group">
                    <label for="deviceId">
                        Chọn Thiết Bị
                        <span class="required">*</span>
                    </label>
                    <div class="input-group">
                        <i class="fas fa-microchip"></i>
                        <select class="form-control" id="deviceId" name="deviceId" required>
                            <option value="">-- Chọn thiết bị --</option>
                            <c:forEach var="device" items="${allDevices}">
                                <option value="${device.deviceId}">
                                    ${device.deviceName} (ID: ${device.deviceId})
                                </option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="form-help">
                        Chọn thiết bị từ danh sách có sẵn
                    </div>
                </div>

                <div class="form-group">
                    <label for="quantity">
                        Số Lượng
                        <span class="required">*</span>
                    </label>
                    <div class="quantity-group">
                        <button type="button" class="quantity-btn" id="decreaseBtn">
                            <i class="fas fa-minus"></i>
                        </button>
                        <input type="number" 
                               class="form-control quantity-input" 
                               id="quantity" 
                               name="quantity" 
                               value="1"
                               min="1"
                               max="100"
                               required>
                        <button type="button" class="quantity-btn" id="increaseBtn">
                            <i class="fas fa-plus"></i>
                        </button>
                    </div>
                    <div class="form-help">
                        Số lượng thiết bị (từ 1 đến 100)
                    </div>
                </div>

                <div class="form-group">
                    <label>
                        Trạng Thái
                        <span class="required">*</span>
                    </label>
                    <div class="status-options">
                        <div class="status-option">
                            <input type="radio" id="hoatdong" name="status" value="Hoạt động" checked>
                            <label for="hoatdong">
                                <i class="fas fa-check-circle"></i>
                                Hoạt động
                            </label>
                        </div>
                        <div class="status-option">
                            <input type="radio" id="baoduong" name="status" value="Bảo dưỡng">
                            <label for="baoduong">
                                <i class="fas fa-tools"></i>
                                Bảo dưỡng
                            </label>
                        </div>
                        <div class="status-option">
                            <input type="radio" id="hong" name="status" value="Hỏng">
                            <label for="hong">
                                <i class="fas fa-exclamation-triangle"></i>
                                Hỏng
                            </label>
                        </div>
                        <div class="status-option">
                            <input type="radio" id="ngunghoatdong" name="status" value="Ngưng hoạt động">
                            <label for="ngunghoatdong">
                                <i class="fas fa-stop-circle"></i>
                                Ngưng hoạt động
                            </label>
                        </div>
                    </div>
                    <div class="form-help">
                        Chọn trạng thái hoạt động của thiết bị trong phòng
                    </div>
                </div>

                <div class="btn-group">
                    <button type="submit" class="btn btn-primary" id="submitBtn">
                        <i class="fas fa-plus" id="saveIcon"></i>
                        Thêm Vào Phòng
                    </button>
                    <a href="deviceinroom?action=list" class="btn btn-secondary">
                        <i class="fas fa-times"></i>
                        Hủy Bỏ
                    </a>
                </div>
            </form>
        </div>

        <div class="card-footer">
            <i class="fas fa-info-circle"></i>
            Vui lòng điền đầy đủ thông tin để thêm thiết bị vào phòng
        </div>
    </div>

    <script>
        document.addEventListener('DOMContentLoaded', function() {
            const form = document.getElementById('addDeviceToRoomForm');
            const submitBtn = document.getElementById('submitBtn');
            const saveIcon = document.getElementById('saveIcon');
            const roomIdInput = document.getElementById('roomId');
            const deviceSelect = document.getElementById('deviceId');
            const quantityInput = document.getElementById('quantity');
            const decreaseBtn = document.getElementById('decreaseBtn');
            const increaseBtn = document.getElementById('increaseBtn');

            // Auto focus on room ID input
            roomIdInput.focus();

            // Quantity controls
            decreaseBtn.addEventListener('click', function() {
                const currentValue = parseInt(quantityInput.value) || 1;
                if (currentValue > 1) {
                    quantityInput.value = currentValue - 1;
                    quantityInput.dispatchEvent(new Event('input'));
                }
            });

            increaseBtn.addEventListener('click', function() {
                const currentValue = parseInt(quantityInput.value) || 1;
                if (currentValue < 100) {
                    quantityInput.value = currentValue + 1;
                    quantityInput.dispatchEvent(new Event('input'));
                }
            });

            // Form validation
            form.addEventListener('submit', function(e) {
                const roomId = roomIdInput.value.trim();
                const deviceId = deviceSelect.value;
                const quantity = parseInt(quantityInput.value);
                const status = document.querySelector('input[name="status"]:checked');

                if (!roomId || parseInt(roomId) <= 0) {
                    e.preventDefault();
                    showAlert('Vui lòng nhập ID phòng hợp lệ!', 'danger');
                    roomIdInput.focus();
                    return;
                }

                if (!deviceId) {
                    e.preventDefault();
                    showAlert('Vui lòng chọn thiết bị!', 'danger');
                    deviceSelect.focus();
                    return;
                }

                if (!quantity || quantity <= 0 || quantity > 100) {
                    e.preventDefault();
                    showAlert('Số lượng phải từ 1 đến 100!', 'danger');
                    quantityInput.focus();
                    return;
                }

                if (!status) {
                    e.preventDefault();
                    showAlert('Vui lòng chọn trạng thái!', 'danger');
                    return;
                }

                // Show loading state
                submitBtn.disabled = true;
                saveIcon.className = 'fas fa-spinner fa-spin';
                submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Đang xử lý...';
            });

            // Real-time validation
            roomIdInput.addEventListener('input', function() {
                const value = parseInt(this.value);
                if (value > 0) {
                    this.style.borderColor = '#4CAF50';
                } else if (this.value.trim() !== '') {
                    this.style.borderColor = '#e74c3c';
                } else {
                    this.style.borderColor = '#e1e5e9';
                }
            });

            quantityInput.addEventListener('input', function() {
                const value = parseInt(this.value);
                if (value >= 1 && value <= 100) {
                    this.style.borderColor = '#4CAF50';
                } else if (this.value.trim() !== '') {
                    this.style.borderColor = '#e74c3c';
                } else {
                    this.style.borderColor = '#e1e5e9';
                }
            });

            deviceSelect.addEventListener('change', function() {
                if (this.value) {
                    this.style.borderColor = '#4CAF50';
                } else {
                    this.style.borderColor = '#e1e5e9';
                }
            });

            // Keyboard shortcuts
            document.addEventListener('keydown', function(e) {
                if ((e.ctrlKey || e.metaKey) && e.key === 's') {
                    e.preventDefault();
                    form.submit();
                }
                
                if (e.key === 'Escape') {
                    window.location.href = 'deviceinroom?action=list';
                }
            });

            // Auto-hide alerts
            const alerts = document.querySelectorAll('.alert');
            alerts.forEach(alert => {
                setTimeout(() => {
                    alert.style.transition = 'opacity 0.5s ease-out';
                    alert.style.opacity = '0';
                    setTimeout(() => {
                        alert.remove();
                    }, 500);
                }, 5000);
            });

            function showAlert(message, type) {
                const existingAlert = document.querySelector('.alert');
                if (existingAlert) {
                    existingAlert.remove();
                }

                const alert = document.createElement('div');
                alert.className = `alert alert-${type}`;
                alert.innerHTML = `
                    
                    ${message}
                `;
                
                const breadcrumb = document.querySelector('.breadcrumb');
                breadcrumb.insertAdjacentElement('afterend', alert);
            }
        });
    </script>
</body>
</html>