<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <base href="${pageContext.request.contextPath}/">
    <title>Chỉnh sửa người dùng - Admin Dashboard</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="css/EditUser.css" rel="stylesheet">
</head>
<body>
    <div class="container mt-5">
        <div class="row justify-content-center">
            <div class="col-lg-8">
                <div class="card">
                    <div class="card-header d-flex justify-content-between align-items-center">
                        <h5 class="mb-0">
                            <i class="fas fa-user-edit me-2"></i>
                            Chỉnh sửa người dùng
                        </h5>
                        <a href="adminusermanagement" class="btn btn-outline-secondary btn-sm">
                            <i class="fas fa-arrow-left me-1"></i>
                            Quay lại
                        </a>
                    </div>
                    <div class="card-body">
                        <c:if test="${not empty success}">
                            <div class="alert alert-success alert-dismissible fade show" role="alert">
                                <i class="fas fa-check-circle me-2"></i>
                                ${success}
                                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                            </div>
                        </c:if>
                        
                        <c:if test="${not empty error}">
                            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                                <i class="fas fa-exclamation-circle me-2"></i>
                                ${error}
                                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                            </div>
                        </c:if>

                        <!-- User Information Display -->
                        <div class="user-info">
                            <div class="row">
                                <div class="col-md-6">
                                    <strong>ID:</strong> ${user.userId}<br>
                                    <strong>Username:</strong> ${user.username}<br>
                                    <strong>Vai trò hiện tại:</strong> 
                                    <c:choose>
                                        <c:when test="${user.roleId == 2}">
                                            <span class="badge bg-success">Quản lý (Role 2)</span>
                                        </c:when>
                                        <c:when test="${user.roleId == 3}">
                                            <span class="badge bg-info">Người thuê (Role 3)</span>
                                        </c:when>
                                    </c:choose>
                                </div>
                                <div class="col-md-6">
                                    <strong>Ngày tạo:</strong> 
                                    <fmt:formatDate value="${user.createAt}" pattern="dd/MM/yyyy HH:mm"/><br>
                                    <strong>Ngày cập nhật:</strong> 
                                    <c:choose>
                                        <c:when test="${not empty user.updateAt}">
                                            <fmt:formatDate value="${user.updateAt}" pattern="dd/MM/yyyy HH:mm"/>
                                        </c:when>
                                        <c:otherwise>
                                            Chưa cập nhật
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                        </div>

                        <form action="adminusermanagement" method="POST" id="editUserForm">
                            <input type="hidden" name="action" value="update">
                            <input type="hidden" name="id" value="${user.userId}">
                            
                            <div class="row">
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <label for="fullName" class="form-label">
                                            <i class="fas fa-id-card me-1"></i>
                                            Họ và tên <span class="text-danger">*</span>
                                        </label>
                                        <input type="text" class="form-control" id="fullName" name="fullName" 
                                               value="${user.fullName}" required>
                                    </div>
                                </div>
                                
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <label for="email" class="form-label">
                                            <i class="fas fa-envelope me-1"></i>
                                            Email <span class="text-danger">*</span>
                                        </label>
                                        <input type="email" class="form-control" id="email" name="email" 
                                               value="${user.email}" required>
                                    </div>
                                </div>
                            </div>

                            <div class="row">
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <label for="phoneNumber" class="form-label">
                                            <i class="fas fa-phone me-1"></i>
                                            Số điện thoại <span class="text-danger">*</span>
                                        </label>
                                        <input type="tel" class="form-control" id="phoneNumber" name="phoneNumber" 
                                               value="${user.phoneNumber}" required>
                                    </div>
                                </div>
                                
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <label for="citizenId" class="form-label">
                                            <i class="fas fa-id-badge me-1"></i>
                                            CCCD/CMND
                                        </label>
                                        <input type="text" class="form-control" id="citizenId" name="citizenId" 
                                               value="${user.citizenId}">
                                    </div>
                                </div>
                            </div>

                            <div class="row">
                                <div class="col-md-12">
                                    <div class="mb-3">
                                        <label for="address" class="form-label">
                                            <i class="fas fa-map-marker-alt me-1"></i>
                                            Địa chỉ
                                        </label>
                                        <textarea class="form-control" id="address" name="address" rows="3">${user.address}</textarea>
                                    </div>
                                </div>
                            </div>

                            <div class="row">
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <label for="roleId" class="form-label">
                                            <i class="fas fa-user-tag me-1"></i>
                                            Vai trò <span class="text-danger">*</span>
                                        </label>
                                        <select class="form-select" id="roleId" name="roleId" required>
                                            <option value="">Chọn vai trò</option>
                                            <option value="2" ${user.roleId == 2 ? 'selected' : ''}>Quản lý (Role 2)</option>
                                            <option value="3" ${user.roleId == 3 ? 'selected' : ''}>Người thuê (Role 3)</option>
                                        </select>
                                    </div>
                                </div>
                                
                                <div class="col-md-6">
                                    <div class="mb-3">
                                        <label for="password" class="form-label">
                                            <i class="fas fa-lock me-1"></i>
                                            Mật khẩu mới
                                        </label>
                                        <input type="password" class="form-control" id="password" name="password">
                                        <div class="form-text">Để trống nếu không muốn thay đổi mật khẩu</div>
                                    </div>
                                </div>
                            </div>

                            <div class="d-grid gap-2 d-md-flex justify-content-md-end">
                                <a href="adminusermanagement" class="btn btn-secondary me-md-2">
                                    <i class="fas fa-times me-1"></i>
                                    Hủy
                                </a>
                                <button type="submit" class="btn btn-primary">
                                    <i class="fas fa-save me-1"></i>
                                    Cập nhật
                                </button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        document.getElementById('editUserForm').addEventListener('submit', function(e) {
            const password = document.getElementById('password').value;
            if (password.length > 0 && password.length < 6) {
                e.preventDefault();
                alert('Mật khẩu phải có ít nhất 6 ký tự!');
                return false;
            }
        });

        // Password strength indicator (only if password is being changed)
        document.getElementById('password').addEventListener('input', function() {
            const password = this.value;
            if (password.length > 0) {
                const strength = calculatePasswordStrength(password);
                updatePasswordStrengthIndicator(strength);
            } else {
                // Clear strength indicator if password field is empty
                const feedback = this.nextElementSibling;
                feedback.className = 'form-text';
                feedback.textContent = 'Để trống nếu không muốn thay đổi mật khẩu';
            }
        });

        function calculatePasswordStrength(password) {
            let strength = 0;
            if (password.length >= 6) strength++;
            if (password.match(/[a-z]/)) strength++;
            if (password.match(/[A-Z]/)) strength++;
            if (password.match(/[0-9]/)) strength++;
            if (password.match(/[^a-zA-Z0-9]/)) strength++;
            return strength;
        }

        function updatePasswordStrengthIndicator(strength) {
            const feedback = document.querySelector('#password').nextElementSibling;
            const colors = ['text-danger', 'text-warning', 'text-info', 'text-primary', 'text-success'];
            const messages = [
                'Rất yếu',
                'Yếu', 
                'Trung bình',
                'Mạnh',
                'Rất mạnh'
            ];
            
            feedback.className = 'form-text ' + colors[Math.min(strength - 1, 4)];
            feedback.textContent = `Độ mạnh mật khẩu: ${messages[Math.min(strength - 1, 4)]}`;
        }
    </script>
</body>
</html> 