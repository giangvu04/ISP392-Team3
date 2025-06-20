<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Manager Dashboard - Hệ thống Quản lý Ký túc xá</title>
        <base href="${pageContext.request.contextPath}/">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
        <link href="css/homepage.css" rel="stylesheet">
        <style>
            /* Manager-specific styles */
            .stat-card {
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                color: white;
            }
            .stat-card-2 {
                background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
                color: white;
            }
            .stat-card-3 {
                background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
                color: white;
            }
            .stat-card-4 {
                background: linear-gradient(135deg, #43e97b 0%, #38f9d7 100%);
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
                            <h4 class="text-white mb-0">
                                <i class="fas fa-building me-2"></i>
                                Manager Panel
                            </h4>
                        </div>

                        <!-- User Info -->
                        <div class="user-info">
                            <div class="text-center">
                                <i class="fas fa-user-circle fa-3x text-white mb-2"></i>
                                <h6 class="text-white mb-1">${user.fullName}</h6>
                                <small class="text-white-50">Manager</small>
                            </div>
                        </div>

                        <!-- Navigation -->
                        <nav class="nav flex-column">
                            <a class="nav-link active" href="ManagerHomepage">
                                <i class="fas fa-tachometer-alt me-2"></i>
                                Dashboard
                            </a>
                            <a class="nav-link" href="listrooms">
                                <i class="fas fa-bed me-2"></i>
                                Quản lý Phòng
                            </a>
                            <a class="nav-link" href="listusers?role=3">
                                <i class="fas fa-users me-2"></i>
                                Quản lý Người thuê
                            </a>
                            <a class="nav-link" href="listcontracts">
                                <i class="fas fa-file-contract me-2"></i>
                                Hợp đồng
                            </a>
                            <a class="nav-link" href="listbills">
                                <i class="fas fa-receipt me-2"></i>
                                Hóa đơn
                            </a>
                            <div class="nav-item dropdown">
                            <a class="nav-link dropdown-toggle" href="#" id="equipmentDropdown" role="button" data-bs-toggle="collapse" data-bs-target="#equipmentSubmenu" aria-expanded="false" aria-controls="equipmentSubmenu">
                                <i class="fas fa-tools me-2"></i>
                                Thiết bị
                            </a>
                            <div class="collapse submenu" id="equipmentSubmenu">
                                <a class="nav-link" href="listdevices">                                  
                                    Danh sách thiết bị
                                </a>
                                <a class="nav-link" href="deviceinroom">                                   
                                    Thiết bị trong phòng
                                </a>
                            </div>
                        </div>
                            <a class="nav-link" href="listservices">
                                <i class="fas fa-concierge-bell me-2"></i>
                                Dịch vụ
                            </a>
                            <hr class="text-white-50">
                            <a class="nav-link" href="profile">
                                <i class="fas fa-user-cog me-2"></i>
                                Hồ sơ cá nhân
                            </a>
                            <a class="nav-link" href="logout">
                                <i class="fas fa-sign-out-alt me-2"></i>
                                Đăng xuất
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
                                <h2 class="mb-1">Dashboard</h2>
                                <p class="text-muted mb-0">Chào mừng trở lại, ${user.fullName}!</p>
                            </div>
                            <div class="text-end">
                                <small class="text-muted">Hôm nay: <span id="current-date"></span></small>
                            </div>
                        </div>

                        <!-- Statistics Cards -->
                        <div class="row mb-4">
                            <div class="col-md-3 mb-3">
                                <div class="card stat-card">
                                    <div class="card-body">
                                        <div class="d-flex justify-content-between">
                                            <div>
                                                <h6 class="card-title">Tổng số phòng</h6>
                                                <h3 class="mb-0">25</h3>
                                            </div>
                                            <div class="align-self-center">
                                                <i class="fas fa-bed fa-2x"></i>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-3 mb-3">
                                <div class="card stat-card-2">
                                    <div class="card-body">
                                        <div class="d-flex justify-content-between">
                                            <div>
                                                <h6 class="card-title">Phòng đã thuê</h6>
                                                <h3 class="mb-0">18</h3>
                                            </div>
                                            <div class="align-self-center">
                                                <i class="fas fa-user-check fa-2x"></i>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-3 mb-3">
                                <div class="card stat-card-3">
                                    <div class="card-body">
                                        <div class="d-flex justify-content-between">
                                            <div>
                                                <h6 class="card-title">Phòng trống</h6>
                                                <h3 class="mb-0">7</h3>
                                            </div>
                                            <div class="align-self-center">
                                                <i class="fas fa-door-open fa-2x"></i>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-3 mb-3">
                                <div class="card stat-card-4">
                                    <div class="card-body">
                                        <div class="d-flex justify-content-between">
                                            <div>
                                                <h6 class="card-title">Hợp đồng mới</h6>
                                                <h3 class="mb-0">3</h3>
                                            </div>
                                            <div class="align-self-center">
                                                <i class="fas fa-file-signature fa-2x"></i>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Quick Actions -->
                        <div class="row">
                            <div class="col-md-6 mb-4">
                                <div class="card">
                                    <div class="card-header bg-primary text-white">
                                        <h5 class="mb-0">
                                            <i class="fas fa-bolt me-2"></i>
                                            Thao tác nhanh
                                        </h5>
                                    </div>
                                    <div class="card-body">
                                        <div class="row">
                                            <div class="col-6 mb-3">
                                                <a href="listrooms" class="btn btn-outline-primary w-100">
                                                    <i class="fas fa-bed me-2"></i>
                                                    Xem phòng
                                                </a>
                                            </div>
                                            <div class="col-6 mb-3">
                                                <a href="listusers?role=3" class="btn btn-outline-success w-100">
                                                    <i class="fas fa-users me-2"></i>
                                                    Quản lý người thuê
                                                </a>
                                            </div>
                                            <div class="col-6 mb-3">
                                                <a href="listcontracts" class="btn btn-outline-info w-100">
                                                    <i class="fas fa-file-contract me-2"></i>
                                                    Hợp đồng
                                                </a>
                                            </div>
                                            <div class="col-6 mb-3">
                                                <a href="listbills" class="btn btn-outline-warning w-100">
                                                    <i class="fas fa-receipt me-2"></i>
                                                    Hóa đơn
                                                </a>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <div class="col-md-6 mb-4">
                                <div class="card">
                                    <div class="card-header bg-success text-white">
                                        <h5 class="mb-0">
                                            <i class="fas fa-chart-line me-2"></i>
                                            Thống kê gần đây
                                        </h5>
                                    </div>
                                    <div class="card-body">
                                        <div class="mb-3">
                                            <div class="d-flex justify-content-between">
                                                <span>Tỷ lệ lấp đầy</span>
                                                <span class="fw-bold">72%</span>
                                            </div>
                                            <div class="progress mt-1">
                                                <div class="progress-bar bg-success" style="width: 72%"></div>
                                            </div>
                                        </div>
                                        <div class="mb-3">
                                            <div class="d-flex justify-content-between">
                                                <span>Doanh thu tháng</span>
                                                <span class="fw-bold">45.2M VNĐ</span>
                                            </div>
                                            <div class="progress mt-1">
                                                <div class="progress-bar bg-info" style="width: 85%"></div>
                                            </div>
                                        </div>
                                        <div class="mb-3">
                                            <div class="d-flex justify-content-between">
                                                <span>Hợp đồng sắp hết hạn</span>
                                                <span class="fw-bold">5</span>
                                            </div>
                                            <div class="progress mt-1">
                                                <div class="progress-bar bg-warning" style="width: 20%"></div>
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

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        <script>
            // Set current date
            document.getElementById('current-date').textContent = new Date().toLocaleDateString('vi-VN');

            // Add active class to current nav item
            document.addEventListener('DOMContentLoaded', function () {
                const currentPath = window.location.pathname;
                const navLinks = document.querySelectorAll('.nav-link');

                navLinks.forEach(link => {
                    if (link.getAttribute('href') && currentPath.includes(link.getAttribute('href'))) {
                        link.classList.add('active');
                    }
                });
            });
        </script>
    </body>
</html> 