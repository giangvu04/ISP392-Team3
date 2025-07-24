<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng ký tài khoản Manager - House Sharing</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        body {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        .register-container {
            background: white;
            border-radius: 20px;
            box-shadow: 0 20px 40px rgba(0,0,0,0.1);
            overflow: hidden;
            width: 100%;
        }
        .register-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 2rem;
            text-align: center;
        }
        .register-body {
            padding: 2rem;
        }
        .form-control {
            border-radius: 10px;
            border: 2px solid #e0e6ed;
            padding: 12px 15px;
            transition: all 0.3s;
        }
        .form-control:focus {
            border-color: #667eea;
            box-shadow: 0 0 0 0.2rem rgba(102, 126, 234, 0.25);
        }
        .btn-primary {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border: none;
            padding: 12px 30px;
            border-radius: 10px;
            font-weight: 600;
            transition: all 0.3s;
        }
        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 20px rgba(0,0,0,0.1);
        }
        .step-indicator {
            display: flex;
            justify-content: center;
            margin-bottom: 2rem;
        }
        .step {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 10px;
            font-weight: bold;
            position: relative;
        }
        .step.active {
            background: #667eea;
            color: white;
        }
        .step.inactive {
            background: #e0e6ed;
            color: #6c757d;
        }
        .step::after {
            content: '';
            position: absolute;
            top: 50%;
            left: 100%;
            width: 20px;
            height: 2px;
            background: #e0e6ed;
            transform: translateY(-50%);
        }
        .step:last-child::after {
            display: none;
        }
        .form-text {
            color: #6c757d;
            font-size: 0.875rem;
        }
        .required {
            color: #dc3545;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="row justify-content-center">
            <div class="col-lg-8">
                <div class="register-container">
                    <div class="register-header">
                        <h2 class="mb-2">
                            <i class="fas fa-building me-2"></i>
                            Đăng ký tài khoản Manager
                        </h2>
                        <p class="mb-0">Tạo tài khoản để quản lý nhà trọ của bạn</p>
                    </div>
                    
                    <div class="register-body">
                        <!-- Step Indicator -->
                        <div class="step-indicator">
                            <div class="step active">
                                <span>1</span>
                            </div>
                            <div class="step inactive">
                                <span>2</span>
                            </div>
                        </div>
                        
                        <div class="text-center mb-4">
                            <h5>Bước 1: Thông tin cơ bản</h5>
                            <p class="text-muted">Nhập thông tin tài khoản của bạn</p>
                        </div>

                        <!-- Display Messages -->
                        <c:if test="${not empty sessionScope.error}">
                            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                                <i class="fas fa-exclamation-triangle me-2"></i>
                                ${sessionScope.error}
                                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                            </div>
                            <c:remove var="error" scope="session"/>
                        </c:if>

                        <c:if test="${not empty sessionScope.success}">
                            <div class="alert alert-success alert-dismissible fade show" role="alert">
                                <i class="fas fa-check-circle me-2"></i>
                                ${sessionScope.success}
                                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                            </div>
                            <c:remove var="success" scope="session"/>
                        </c:if>

                        <form action="registerManager" method="POST" id="registerForm">
                            <div class="row">
                                <div class="col-12">
                                    <div class="mb-3">
                                        <label for="fullName" class="form-label">
                                            Họ và tên <span class="required">*</span>
                                        </label>
                                        <input type="text" class="form-control" id="fullName" name="fullName" 
                                               placeholder="Nhập họ và tên đầy đủ" required maxlength="100">
                                        <div class="form-text">Ví dụ: Nguyễn Văn An</div>
                                    </div>
                                </div>
                            </div>

                            <div class="row">
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <label for="email" class="form-label">
                                            Email <span class="required">*</span>
                                        </label>
                                        <input type="email" class="form-control" id="email" name="email" 
                                               placeholder="example@email.com" required maxlength="100">
                                        <div class="form-text">Email sẽ dùng để đăng nhập</div>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <label for="phone" class="form-label">
                                            Số điện thoại <span class="required">*</span>
                                        </label>
                                        <input type="tel" class="form-control" id="phone" name="phone" 
                                               placeholder="0901234567" required maxlength="20" pattern="[0-9]{10,11}">
                                        <div class="form-text">10-11 chữ số</div>
                                    </div>
                                </div>
                            </div>

                            <div class="row">
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <label for="password" class="form-label">
                                            Mật khẩu <span class="required">*</span>
                                        </label>
                                        <input type="password" class="form-control" id="password" name="password" 
                                               placeholder="Nhập mật khẩu" required minlength="6" maxlength="50">
                                        <div class="form-text">Tối thiểu 6 ký tự</div>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <label for="confirmPassword" class="form-label">
                                            Xác nhận mật khẩu <span class="required">*</span>
                                        </label>
                                        <input type="password" class="form-control" id="confirmPassword" name="confirmPassword" 
                                               placeholder="Nhập lại mật khẩu" required minlength="6" maxlength="50">
                                        <div class="form-text">Nhập lại mật khẩu để xác nhận</div>
                                    </div>
                                </div>
                            </div>

                            <div class="row">
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <label for="citizenId" class="form-label">
                                            CMND/CCCD <span class="required">*</span>
                                        </label>
                                        <input type="text" class="form-control" id="citizenId" name="citizenId" 
                                               placeholder="123456789012" required maxlength="20" pattern="[0-9]{9,12}">
                                        <div class="form-text">9-12 chữ số</div>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <label for="address" class="form-label">
                                            Địa chỉ
                                        </label>
                                        <input type="text" class="form-control" id="address" name="address" 
                                               placeholder="Nhập địa chỉ hiện tại" maxlength="255">
                                        <div class="form-text">Địa chỉ nơi ở hiện tại</div>
                                    </div>
                                </div>
                            </div>

                            <div class="alert alert-info" role="alert">
                                <h6 class="alert-heading"><i class="fas fa-info-circle me-2"></i>Lưu ý quan trọng</h6>
                                <ul class="mb-0">
                                    <li>Sau khi đăng ký, bạn cần upload giấy tờ kinh doanh để kích hoạt tài khoản</li>
                                    <li>Tài khoản chỉ được kích hoạt sau khi Super Admin duyệt giấy tờ</li>
                                    <li>Vui lòng cung cấp thông tin chính xác để quá trình duyệt nhanh chóng</li>
                                </ul>
                            </div>

                            <div class="d-grid gap-2">
                                <button type="submit" class="btn btn-primary btn-lg">
                                    <i class="fas fa-arrow-right me-2"></i>
                                    Tiếp tục (Bước 2)
                                </button>
                            </div>
                        </form>

                        <div class="text-center mt-4">
                            <p class="text-muted">
                                Đã có tài khoản? 
                                <a href="login" class="text-decoration-none fw-bold">Đăng nhập ngay</a>
                            </p>
                            <p class="text-muted">
                                <a href="registerr" class="text-decoration-none">Đăng ký tài khoản Tenant</a>
                            </p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Form validation
        document.getElementById('registerForm').addEventListener('submit', function(e) {
            const password = document.getElementById('password').value;
            const confirmPassword = document.getElementById('confirmPassword').value;
            
            if (password !== confirmPassword) {
                e.preventDefault();
                alert('Mật khẩu và xác nhận mật khẩu không khớp!');
                document.getElementById('confirmPassword').focus();
                return false;
            }
            
            // Show loading state
            const submitBtn = this.querySelector('button[type="submit"]');
            submitBtn.innerHTML = '<span class="spinner-border spinner-border-sm me-2"></span>Đang xử lý...';
            submitBtn.disabled = true;
        });

        // Phone number validation
        document.getElementById('phone').addEventListener('input', function(e) {
            this.value = this.value.replace(/[^0-9]/g, '');
        });

        // Citizen ID validation
        document.getElementById('citizenId').addEventListener('input', function(e) {
            this.value = this.value.replace(/[^0-9]/g, '');
        });
    </script>
</body>
</html>
