<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Test Database Connection</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        body {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
        }
        .card {
            border: none;
            border-radius: 15px;
            box-shadow: 0 8px 32px rgba(0,0,0,0.1);
        }
        .status-card {
            background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
            color: white;
        }
        .error-card {
            background: linear-gradient(135deg, #dc3545 0%, #fd7e14 100%);
            color: white;
        }
        .stats-card {
            background: linear-gradient(135deg, #007bff 0%, #6610f2 100%);
            color: white;
        }
        .table {
            border-radius: 10px;
            overflow: hidden;
        }
        .role-badge {
            padding: 6px 12px;
            border-radius: 20px;
            font-size: 0.75rem;
            font-weight: 600;
        }
        .role-admin {
            background: #dc3545;
            color: white;
        }
        .role-manager {
            background: #007bff;
            color: white;
        }
        .role-tenant {
            background: #28a745;
            color: white;
        }
    </style>
</head>
<body>
    <div class="container py-5">
        <div class="row justify-content-center">
            <div class="col-lg-10">
                <!-- Header -->
                <div class="text-center mb-5">
                    <h1 class="text-white mb-3">
                        <i class="fas fa-database"></i> Test Database Connection
                    </h1>
                    <p class="text-white-50">Kiểm tra kết nối cơ sở dữ liệu và dữ liệu người dùng</p>
                </div>

                <!-- Connection Status -->
                <div class="card mb-4 ${not empty error ? 'error-card' : 'status-card'}">
                    <div class="card-body text-center">
                        <h4 class="mb-2">
                            <i class="fas ${not empty error ? 'fa-exclamation-triangle' : 'fa-check-circle'} me-2"></i>
                            Trạng thái kết nối
                        </h4>
                        <p class="mb-0 fs-5">${connectionStatus}</p>
                    </div>
                </div>

                <!-- Error Details -->
                <c:if test="${not empty error}">
                    <div class="card mb-4">
                        <div class="card-header bg-danger text-white">
                            <h5 class="mb-0"><i class="fas fa-bug me-2"></i>Chi tiết lỗi</h5>
                        </div>
                        <div class="card-body">
                            <pre class="mb-0"><code>${error}</code></pre>
                        </div>
                    </div>
                </c:if>

                <!-- Statistics -->
                <c:if test="${empty error}">
                    <div class="row mb-4">
                        <div class="col-md-3">
                            <div class="card stats-card">
                                <div class="card-body text-center">
                                    <h3 class="mb-1">${totalUsers}</h3>
                                    <p class="mb-0">Tổng người dùng</p>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="card stats-card">
                                <div class="card-body text-center">
                                    <h3 class="mb-1">${adminCount}</h3>
                                    <p class="mb-0">Admin</p>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="card stats-card">
                                <div class="card-body text-center">
                                    <h3 class="mb-1">${managerCount}</h3>
                                    <p class="mb-0">Quản lý</p>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="card stats-card">
                                <div class="card-body text-center">
                                    <h3 class="mb-1">${tenantCount}</h3>
                                    <p class="mb-0">Người thuê</p>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Users Table -->
                    <div class="card">
                        <div class="card-header bg-white">
                            <h5 class="mb-0">
                                <i class="fas fa-users me-2"></i>Danh sách người dùng (${totalUsers} người)
                            </h5>
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
                                            <th>Trạng thái</th>
                                            <th>Ngày tạo</th>
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
                                                        <c:when test="${user.roleId == 1}">
                                                            <span class="role-badge role-admin">
                                                                <i class="fas fa-user-shield me-1"></i>Admin
                                                            </span>
                                                        </c:when>
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
                                                    <c:choose>
                                                        <c:when test="${user.active}">
                                                            <span class="badge bg-success">
                                                                <i class="fas fa-check me-1"></i>Hoạt động
                                                            </span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="badge bg-danger">
                                                                <i class="fas fa-times me-1"></i>Vô hiệu
                                                            </span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>
                                                    <fmt:formatDate value="${user.createdAt}" pattern="dd/MM/yyyy HH:mm"/>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </div>

                    <!-- Database Schema Info -->
                    <div class="card mt-4">
                        <div class="card-header bg-white">
                            <h5 class="mb-0">
                                <i class="fas fa-info-circle me-2"></i>Thông tin Schema
                            </h5>
                        </div>
                        <div class="card-body">
                            <div class="row">
                                <div class="col-md-6">
                                    <h6>Bảng users:</h6>
                                    <ul class="list-unstyled">
                                        <li><code>user_id</code> - ID người dùng</li>
                                        <li><code>role_id</code> - ID vai trò (1: Admin, 2: Manager, 3: Tenant)</li>
                                        <li><code>full_name</code> - Họ và tên</li>
                                        <li><code>phone_number</code> - Số điện thoại</li>
                                        <li><code>email</code> - Email</li>
                                        <li><code>password_hash</code> - Mật khẩu đã hash</li>
                                        <li><code>citizen_id</code> - Căn cước công dân</li>
                                        <li><code>address</code> - Địa chỉ</li>
                                        <li><code>is_active</code> - Trạng thái hoạt động</li>
                                        <li><code>created_at</code> - Ngày tạo</li>
                                        <li><code>updated_at</code> - Ngày cập nhật</li>
                                    </ul>
                                </div>
                                <div class="col-md-6">
                                    <h6>Bảng roles:</h6>
                                    <ul class="list-unstyled">
                                        <li><code>role_id</code> - ID vai trò</li>
                                        <li><code>role_name</code> - Tên vai trò</li>
                                    </ul>
                                    
                                    <h6 class="mt-3">Các bảng khác:</h6>
                                    <ul class="list-unstyled">
                                        <li><code>rental_areas</code> - Khu trọ</li>
                                        <li><code>rooms</code> - Phòng trọ</li>
                                        <li><code>contracts</code> - Hợp đồng</li>
                                        <li><code>services</code> - Dịch vụ</li>
                                        <li><code>bills</code> - Hóa đơn</li>
                                        <li><code>bill_details</code> - Chi tiết hóa đơn</li>
                                    </ul>
                                </div>
                            </div>
                        </div>
                    </div>
                </c:if>

                <!-- Navigation -->
                <div class="text-center mt-4">
                    <a href="login" class="btn btn-light btn-lg me-3">
                        <i class="fas fa-sign-in-alt me-2"></i>Đăng nhập
                    </a>
                    <a href="adminusermanagement" class="btn btn-outline-light btn-lg">
                        <i class="fas fa-users me-2"></i>Quản lý người dùng
                    </a>
                </div>
            </div>
        </div>
    </div>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html> 