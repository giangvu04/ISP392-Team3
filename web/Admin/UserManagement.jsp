<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <base href="${pageContext.request.contextPath}/">
    <title>Quản lý người dùng - Admin Dashboard</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link href="css/UserManagement.css" rel="stylesheet">
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
                        <a class="nav-link active" href="AdminHomepage">
                            <i class="fas fa-tachometer-alt me-2"></i> Dashboard
                        </a>
                        <a class="nav-link" href="adminusermanagement">
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
                            <h2 class="mb-1"><i class="fas fa-users"></i> Quản lý người dùng</h2>
                            <p class="text-muted mb-0">Quản lý người dùng quản lý và người thuê</p>
                        </div>
                        <a href="adminusermanagement?action=create" class="btn btn-primary btn-action">
                            <i class="fas fa-plus me-2"></i>Thêm người dùng
                        </a>
                    </div>

                    <!-- Alert Messages -->
                    <c:if test="${not empty success}">
                        <div class="alert alert-success alert-dismissible fade show" role="alert">
                            <i class="fas fa-check-circle me-2"></i>${success}
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </div>
                    </c:if>
                    <c:if test="${not empty error}">
                        <div class="alert alert-danger alert-dismissible fade show" role="alert">
                            <i class="fas fa-exclamation-circle me-2"></i>${error}
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </div>
                    </c:if>

                    <!-- Stats Cards -->
                    <div class="row mb-4">
                        <div class="col-md-6">
                            <div class="card stats-card">
                                <div class="card-body">
                                    <div class="d-flex justify-content-between">
                                        <div>
                                            <h6 class="card-title">Tổng số người quản lý</h6>
                                            <h3 class="mb-0">${managerCount}</h3>
                                        </div>
                                        <div class="align-self-center">
                                            <i class="fas fa-user-tie fa-2x"></i>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="card stats-card">
                                <div class="card-body">
                                    <div class="d-flex justify-content-between">
                                        <div>
                                            <h6 class="card-title">Tổng số người thuê</h6>
                                            <h3 class="mb-0">${tenantCount}</h3>
                                        </div>
                                        <div class="align-self-center">
                                            <i class="fas fa-users fa-2x"></i>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Search and Filter -->
                    <div class="card mb-4">
                        <div class="card-body">
                            <form action="adminusermanagement" method="GET" class="row g-3">
                                <input type="hidden" name="action" value="search">
                                <div class="col-md-8">
                                    <div class="input-group">
                                        <span class="input-group-text"><i class="fas fa-search"></i></span>
                                        <input type="text" class="form-control search-box" name="searchTerm" 
                                               placeholder="Tìm kiếm theo tên hoặc email..." 
                                               value="${searchTerm}">
                                        <button type="submit" class="btn btn-primary">Tìm kiếm</button>
                                    </div>
                                </div>
                                <div class="col-md-4 text-end">
                                    <a href="adminusermanagement" class="btn btn-outline-secondary">
                                        <i class="fas fa-refresh me-2"></i>Làm mới
                                    </a>
                                </div>
                            </form>
                        </div>
                    </div>

                    <!-- Users Table -->
                    <div class="card">
                        <div class="card-header bg-white">
                            <h5 class="mb-0"><i class="fas fa-list me-2"></i>Danh sách người dùng</h5>
                        </div>
                        <div class="card-body p-0">
                            <div class="table-responsive">
                                <table class="table table-hover mb-0">
                                    <thead class="table-light">
                                        <tr>
                                            <th>ID</th>
                                            <th>Họ tên</th>
                                            <th>Email</th>
                                            <th>Số điện thoại</th>
                                            <th>Vai trò</th>
                                            <th>CCCD</th>
                                            <th>Địa chỉ</th>
                                            <th>Ngày tạo</th>
                                            <th>Thao tác</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="user" items="${users}">
                                            <tr>
                                                <td>${user.userId}</td>
                                                <td>
                                                    <div class="fw-bold">${user.fullName}</div>
                                                </td>
                                                <td>${user.email}</td>
                                                <td>${user.phoneNumber}</td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${user.roleId == 2}">
                                                            <span class="role-badge role-manager">
                                                                <i class="fas fa-user-tie me-1"></i>Quản lý
                                                            </span>
                                                        </c:when>
                                                        <c:when test="${user.roleId == 3}">
                                                            <span class="role-badge role-tenant">
                                                                <i class="fas fa-user me-1"></i>Người thuê
                                                            </span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="badge bg-secondary">Không xác định</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>${user.citizenId}</td>
                                                <td>${user.address}</td>
                                                <td>
                                                    <fmt:formatDate value="${user.createdAt}" pattern="dd/MM/yyyy HH:mm"/>
                                                </td>
                                                <td>
                                                    <div class="btn-group" role="group">
                                                        <a href="adminusermanagement?action=edit&id=${user.userId}" 
                                                           class="btn btn-sm btn-outline-primary btn-action" 
                                                           title="Chỉnh sửa">
                                                            <i class="fas fa-edit"></i>
                                                        </a>
                                                        <button type="button" 
                                                                class="btn btn-sm btn-outline-warning btn-action" 
                                                                onclick="resetPassword(${user.userId})"
                                                                title="Reset mật khẩu">
                                                            <i class="fas fa-key"></i>
                                                        </button>
                                                        <button type="button" 
                                                                class="btn btn-sm btn-outline-danger btn-action" 
                                                                onclick="deleteUser(${user.userId})"
                                                                title="Xóa">
                                                            <i class="fas fa-trash"></i>
                                                        </button>
                                                    </div>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>

                    <!-- Pagination -->
                    <c:if test="${not empty totalPages and totalPages > 1}">
                        <nav aria-label="User pagination" class="mt-4">
                            <ul class="pagination justify-content-center">
                                <c:if test="${currentPage > 1}">
                                    <li class="page-item">
                                        <a class="page-link" href="adminusermanagement?page=${currentPage - 1}">
                                            <i class="fas fa-chevron-left"></i>
                                        </a>
                                    </li>
                                </c:if>
                                
                                <c:forEach begin="1" end="${totalPages}" var="pageNum">
                                    <li class="page-item ${pageNum == currentPage ? 'active' : ''}">
                                        <a class="page-link" href="adminusermanagement?page=${pageNum}">${pageNum}</a>
                                    </li>
                                </c:forEach>
                                
                                <c:if test="${currentPage < totalPages}">
                                    <li class="page-item">
                                        <a class="page-link" href="adminusermanagement?page=${currentPage + 1}">
                                            <i class="fas fa-chevron-right"></i>
                                        </a>
                                    </li>
                                </c:if>
                            </ul>
                        </nav>
                    </c:if>
                </div>
            </div>
        </div>
    </div>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function deleteUser(userId) {
            if (confirm('Bạn có chắc chắn muốn xóa người dùng này?')) {
                window.location.href = 'adminusermanagement?action=delete&id=' + userId;
            }
        }

        function resetPassword(userId) {
            if (confirm('Bạn có chắc chắn muốn reset mật khẩu của người dùng này?')) {
                // You can implement this functionality
                alert('Chức năng reset mật khẩu sẽ được thêm sau!');
            }
        }

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