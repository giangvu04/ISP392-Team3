<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Admin Dashboard - Hệ thống quản lý nhà trọ</title>
        <base href="${pageContext.request.contextPath}/">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
        <link href="css/homepage.css" rel="stylesheet">
        <style>
            /* Admin-specific styles */
            .stats-card {
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                color: white;
            }
            .welcome-card {
                background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
                color: white;
            }
            .quick-action-card {
                background: linear-gradient(135deg, #fd7e14 0%, #ffc107 100%);
                color: white;
            }
        </style>
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
                        <!-- Welcome Section -->
                        <div class="card welcome-card mb-4">
                            <div class="card-body">
                                <div class="row align-items-center">
                                    <div class="col-md-8">
                                        <h2 class="mb-2">
                                            <i class="fas fa-home me-2"></i>Chào mừng đến với Hệ thống Quản lý Nhà trọ
                                        </h2>
                                        <p class="mb-0 fs-5">
                                            Xin chào, <strong>${currentUser.fullName}</strong>! 
                                            Bạn đang quản lý hệ thống với vai trò Administrator.
                                        </p>
                                    </div>
                                    <div class="col-md-4 text-end">
                                        <i class="fas fa-user-shield fa-4x opacity-75"></i>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Alert Messages -->
                        <c:if test="${not empty error}">
                            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                                <i class="fas fa-exclamation-circle me-2"></i>${error}
                                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                            </div>
                        </c:if>

                        <!-- Statistics Cards -->
                        <div class="row mb-4">
                            <div class="col-md-4">
                                <div class="card stats-card">
                                    <div class="card-body">
                                        <div class="d-flex justify-content-between">
                                            <div>
                                                <h6 class="card-title">Tổng số người dùng</h6>
                                                <h3 class="mb-0">${totalUsers}</h3>
                                            </div>
                                            <div class="align-self-center">
                                                <i class="fas fa-users fa-2x"></i>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-4">
                                <div class="card stats-card">
                                    <div class="card-body">
                                        <div class="d-flex justify-content-between">
                                            <div>
                                                <h6 class="card-title">Người quản lý</h6>
                                                <h3 class="mb-0">${managerCount}</h3>
                                            </div>
                                            <div class="align-self-center">
                                                <i class="fas fa-user-tie fa-2x"></i>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-4">
                                <div class="card stats-card">
                                    <div class="card-body">
                                        <div class="d-flex justify-content-between">
                                            <div>
                                                <h6 class="card-title">Người thuê</h6>
                                                <h3 class="mb-0">${tenantCount}</h3>
                                            </div>
                                            <div class="align-self-center">
                                                <i class="fas fa-user fa-2x"></i>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Quick Actions -->
                        <div class="row mb-4">
                            <div class="col-12">
                                <div class="card quick-action-card">
                                    <div class="card-header bg-transparent border-0">
                                        <h5 class="mb-0">
                                            <i class="fas fa-bolt me-2"></i>Thao tác nhanh
                                        </h5>
                                    </div>
                                    <div class="card-body">
                                        <div class="row">
                                            <div class="col-md-3 mb-3">
                                                <a href="adminusermanagement?action=create" class="btn btn-light btn-lg w-100">
                                                    <i class="fas fa-user-plus fa-2x mb-2 d-block"></i>
                                                    Thêm người dùng
                                                </a>
                                            </div>
                                            <div class="col-md-3 mb-3">
                                                <a href="adminusermanagement" class="btn btn-light btn-lg w-100">
                                                    <i class="fas fa-users fa-2x mb-2 d-block"></i>
                                                    Quản lý người dùng
                                                </a>
                                            </div>
                                            <div class="col-md-3 mb-3">
                                                <a href="listrooms" class="btn btn-light btn-lg w-100">
                                                    <i class="fas fa-building fa-2x mb-2 d-block"></i>
                                                    Quản lý phòng
                                                </a>
                                            </div>
                                            <div class="col-md-3 mb-3">
                                                <a href="testdatabase" class="btn btn-light btn-lg w-100">
                                                    <i class="fas fa-database fa-2x mb-2 d-block"></i>
                                                    Test Database
                                                </a>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- System Information -->
                        <div class="row">
                            <div class="col-md-6">
                                <div class="card">
                                    <div class="card-header bg-white">
                                        <h5 class="mb-0">
                                            <i class="fas fa-info-circle me-2"></i>Thông tin hệ thống
                                        </h5>
                                    </div>
                                    <div class="card-body">
                                        <ul class="list-unstyled">
                                            <li class="mb-2">
                                                <i class="fas fa-check-circle text-success me-2"></i>
                                                Hệ thống quản lý nhà trọ
                                            </li>
                                            <li class="mb-2">
                                                <i class="fas fa-check-circle text-success me-2"></i>
                                                Quản lý người dùng (Admin, Manager, Tenant)
                                            </li>
                                            <li class="mb-2">
                                                <i class="fas fa-check-circle text-success me-2"></i>
                                                Quản lý phòng trọ và hợp đồng
                                            </li>
                                            <li class="mb-2">
                                                <i class="fas fa-check-circle text-success me-2"></i>
                                                Hệ thống hóa đơn và thanh toán
                                            </li>
                                            <li class="mb-2">
                                                <i class="fas fa-check-circle text-success me-2"></i>
                                                Báo cáo và thống kê
                                            </li>
                                        </ul>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="card">
                                    <div class="card-header bg-white">
                                        <h5 class="mb-0">
                                            <i class="fas fa-cog me-2"></i>Hướng dẫn sử dụng
                                        </h5>
                                    </div>
                                    <div class="card-body">
                                        <div class="accordion" id="helpAccordion">
                                            <div class="accordion-item">
                                                <h2 class="accordion-header">
                                                    <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#help1">
                                                        Quản lý người dùng
                                                    </button>
                                                </h2>
                                                <div id="help1" class="accordion-collapse collapse" data-bs-parent="#helpAccordion">
                                                    <div class="accordion-body">
                                                        Tạo, chỉnh sửa và xóa người dùng quản lý và người thuê. Phân quyền theo vai trò.
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="accordion-item">
                                                <h2 class="accordion-header">
                                                    <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#help2">
                                                        Quản lý phòng trọ
                                                    </button>
                                                </h2>
                                                <div id="help2" class="accordion-collapse collapse" data-bs-parent="#helpAccordion">
                                                    <div class="accordion-body">
                                                        Quản lý thông tin phòng trọ, trạng thái thuê và thiết bị trong phòng.
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="accordion-item">
                                                <h2 class="accordion-header">
                                                    <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#help3">
                                                        Hóa đơn và thanh toán
                                                    </button>
                                                </h2>
                                                <div id="help3" class="accordion-collapse collapse" data-bs-parent="#helpAccordion">
                                                    <div class="accordion-body">
                                                        Tạo hóa đơn, theo dõi thanh toán và quản lý dịch vụ.
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
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
            // Auto-hide alerts after 5 seconds
            setTimeout(function () {
                const alerts = document.querySelectorAll('.alert');
                alerts.forEach(function (alert) {
                    const bsAlert = new bootstrap.Alert(alert);
                    bsAlert.close();
                });
            }, 5000);
        </script>
    </body>
</html> zz