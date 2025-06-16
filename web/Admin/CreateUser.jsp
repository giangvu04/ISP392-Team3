<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <base href="${pageContext.request.contextPath}/">
    <title>Tạo người dùng mới - Admin Dashboard</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link href="css/CreateUser.css" rel="stylesheet">
</head>
<body>
    <div class="container-fluid">
        <div class="row">
            <!-- Sidebar -->
            <div class="col-md-3 col-lg-2 px-0">
                <div class="sidebar p-3">
                    <div class="text-center mb-4">
                        <h4 class="text-white"><i class="fas fa-user-shield"></i> Admin Panel</h4>
                    </div>
                    <nav class="nav flex-column">
                        <a class="nav-link" href="AdminHomepage">
                            <i class="fas fa-tachometer-alt me-2"></i> Dashboard
                        </a>
                        <a class="nav-link active" href="adminusermanagement">
                            <i class="fas fa-users me-2"></i> Quản lý người dùng
                        </a>
                        <a class="nav-link" href="listrooms">
                            <i class="fas fa-building me-2"></i> Quản lý phòng
                        </a>
                        <a class="nav-link" href="logout">
                            <i class="fas fa-sign-out-alt me-2"></i> Đăng xuất
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
                            <h2 class="mb-1"><i class="fas fa-user-plus"></i> Tạo người dùng mới</h2>
                            <p class="text-muted mb-0">Thêm người dùng quản lý hoặc người thuê mới</p>
                        </div>
                        <a href="adminusermanagement" class="btn btn-outline-secondary btn-action">
                            <i class="fas fa-arrow-left me-2"></i>Quay lại
                        </a>
                    </div>

                    <!-- Alert Messages -->
                    <c:if test="${not empty error}">
                        <div class="alert alert-danger alert-dismissible fade show" role="alert">
                            <i class="fas fa-exclamation-circle me-2"></i>${error}
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </div>
                    </c:if>

                    <!-- Create User Form -->
                    <div class="card">
                        <div class="card-header bg-white">
                            <h5 class="mb-0"><i class="fas fa-user-plus me-2"></i>Thông tin người dùng</h5>
                        </div>
                        <div class="card-body">
                            <form action="adminusermanagement" method="POST" class="row g-3">
                                <input type="hidden" name="action" value="create">
                                
                                <!-- Full Name -->
                                <div class="col-md-6">
                                    <label for="fullName" class="form-label required-field">Họ và tên</label>
                                    <input type="text" class="form-control" id="fullName" name="fullName" 
                                           value="${fullName}" required>
                                </div>

                                <!-- Email -->
                                <div class="col-md-6">
                                    <label for="email" class="form-label required-field">Email</label>
                                    <input type="email" class="form-control" id="email" name="email" 
                                           value="${email}" required>
                                </div>

                                <!-- Phone Number -->
                                <div class="col-md-6">
                                    <label for="phoneNumber" class="form-label required-field">Số điện thoại</label>
                                    <input type="tel" class="form-control" id="phoneNumber" name="phoneNumber" 
                                           value="${phoneNumber}" required>
                                </div>

                                <!-- Citizen ID -->
                                <div class="col-md-6">
                                    <label for="citizenId" class="form-label">Căn cước công dân</label>
                                    <input type="text" class="form-control" id="citizenId" name="citizenId" 
                                           value="${citizenId}">
                                </div>

                                <!-- Role -->
                                <div class="col-md-6">
                                    <label for="roleId" class="form-label required-field">Vai trò</label>
                                    <select class="form-select" id="roleId" name="roleId" required>
                                        <option value="">Chọn vai trò</option>
                                        <option value="2" ${roleId == 2 ? 'selected' : ''}>Quản lý</option>
                                        <option value="3" ${roleId == 3 ? 'selected' : ''}>Người thuê</option>
                                    </select>
                                </div>

                                <!-- Password -->
                                <div class="col-md-6">
                                    <label for="password" class="form-label required-field">Mật khẩu</label>
                                    <div class="input-group">
                                        <input type="password" class="form-control" id="password" name="password" required>
                                        <button class="btn btn-outline-secondary" type="button" onclick="togglePassword()">
                                            <i class="fas fa-eye" id="passwordIcon"></i>
                                        </button>
                                    </div>
                                </div>

                                <!-- Address -->
                                <div class="col-12">
                                    <label for="address" class="form-label">Địa chỉ</label>
                                    <textarea class="form-control" id="address" name="address" rows="3">${address}</textarea>
                                </div>

                                <!-- Submit Buttons -->
                                <div class="col-12">
                                    <hr>
                                    <div class="d-flex justify-content-end gap-2">
                                        <a href="adminusermanagement" class="btn btn-outline-secondary btn-action">
                                            <i class="fas fa-times me-2"></i>Hủy
                                        </a>
                                        <button type="submit" class="btn btn-primary btn-action">
                                            <i class="fas fa-save me-2"></i>Tạo người dùng
                                        </button>
                                    </div>
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
        function togglePassword() {
            const passwordField = document.getElementById('password');
            const passwordIcon = document.getElementById('passwordIcon');
            
            if (passwordField.type === 'password') {
                passwordField.type = 'text';
                passwordIcon.classList.remove('fa-eye');
                passwordIcon.classList.add('fa-eye-slash');
            } else {
                passwordField.type = 'password';
                passwordIcon.classList.remove('fa-eye-slash');
                passwordIcon.classList.add('fa-eye');
            }
        }

        // Form validation
        document.querySelector('form').addEventListener('submit', function(e) {
            const email = document.getElementById('email').value;
            const phoneNumber = document.getElementById('phoneNumber').value;
            const password = document.getElementById('password').value;
            
            // Basic email validation
            const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
            if (!emailRegex.test(email)) {
                e.preventDefault();
                alert('Vui lòng nhập email hợp lệ!');
                return;
            }
            
            // Basic phone validation (Vietnamese phone numbers)
            const phoneRegex = /^(0|\+84)[3|5|7|8|9][0-9]{8}$/;
            if (!phoneRegex.test(phoneNumber)) {
                e.preventDefault();
                alert('Vui lòng nhập số điện thoại hợp lệ!');
                return;
            }
            
            // Password validation
            if (password.length < 6) {
                e.preventDefault();
                alert('Mật khẩu phải có ít nhất 6 ký tự!');
                return;
            }
        });

        // Auto-hide alerts after 5 seconds
        setTimeout(function() {
            const alerts = document.querySelectorAll('.alert');
            alerts.forEach(function(alert) {
                const bsAlert = new bootstrap.Alert(alert);
                bsAlert.close();
            });
        }, 5000);
    </script>
</body>
</html> 