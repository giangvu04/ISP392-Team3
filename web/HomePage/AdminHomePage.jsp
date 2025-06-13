<%-- 
    Document   : AdminHomePage
    Created on : 12 June 2025, 9:53:34 am
    Author     : Admin
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Admin Dashboard - Hệ thống quản lý nhà trọ</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
        <style>
            :root {
                --primary-color: #4e73df;
                --secondary-color: #858796;
                --success-color: #1cc88a;
                --info-color: #36b9cc;
                --warning-color: #f6c23e;
                --danger-color: #e74a3b;
                --dark-color: #5a5c69;
            }

            body {
                background-color: #f8f9fc;
                font-family: 'Nunito', -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif;
            }

            .sidebar {
                background: linear-gradient(180deg, var(--primary-color) 10%, #224abe 100%);
                min-height: 100vh;
                box-shadow: 0 0.15rem 1.75rem 0 rgba(58, 59, 69, 0.15);
            }

            .sidebar .nav-link {
                color: rgba(255, 255, 255, 0.8);
                padding: 1rem;
                border-radius: 0.35rem;
                margin: 0.2rem 0;
                transition: all 0.3s ease;
            }

            .sidebar .nav-link:hover,
            .sidebar .nav-link.active {
                color: #fff;
                background-color: rgba(255, 255, 255, 0.1);
            }

            .main-content {
                margin-left: 0;
            }

            @media (min-width: 768px) {
                .main-content {
                    margin-left: 250px;
                }
            }

            .card {
                border: none;
                border-radius: 0.35rem;
                box-shadow: 0 0.15rem 1.75rem 0 rgba(58, 59, 69, 0.15);
                transition: transform 0.2s ease;
            }

            .card:hover {
                transform: translateY(-2px);
            }

            .card-header {
                background-color: #f8f9fc;
                border-bottom: 1px solid #e3e6f0;
                font-weight: 600;
            }

            .stats-card {
                border-left: 0.25rem solid;
            }

            .stats-card.primary {
                border-left-color: var(--primary-color);
            }

            .stats-card.success {
                border-left-color: var(--success-color);
            }

            .stats-card.info {
                border-left-color: var(--info-color);
            }

            .stats-card.warning {
                border-left-color: var(--warning-color);
            }

            .btn-primary {
                background-color: var(--primary-color);
                border-color: var(--primary-color);
            }

            .btn-primary:hover {
                background-color: #224abe;
                border-color: #224abe;
            }

            .welcome-section {
                background: linear-gradient(135deg, var(--primary-color) 0%, #224abe 100%);
                color: white;
                border-radius: 0.35rem;
                padding: 2rem;
                margin-bottom: 2rem;
            }

            .feature-card {
                text-decoration: none;
                color: inherit;
                display: block;
            }

            .feature-card:hover {
                color: inherit;
            }

            .feature-icon {
                font-size: 3rem;
                margin-bottom: 1rem;
            }
        </style>
    </head>
    <body>
        <!-- Sidebar -->
        <nav class="sidebar position-fixed d-none d-md-block" style="width: 250px;">
            <div class="p-3">
                <h4 class="text-white mb-4">
                    <i class="fas fa-building me-2"></i>
                    Admin Panel
                </h4>
                <ul class="nav flex-column">
                    <li class="nav-item">
                        <a class="nav-link active" href="AdminHomepage">
                            <i class="fas fa-tachometer-alt me-2"></i>
                            Dashboard
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="adminusermanagement">
                            <i class="fas fa-users me-2"></i>
                            Quản lý người dùng
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="listrooms">
                            <i class="fas fa-home me-2"></i>
                            Quản lý phòng
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="listcontracts">
                            <i class="fas fa-file-contract me-2"></i>
                            Quản lý hợp đồng
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="logout">
                            <i class="fas fa-sign-out-alt me-2"></i>
                            Đăng xuất
                        </a>
                    </li>
                </ul>
            </div>
        </nav>

        <!-- Main Content -->
        <div class="main-content">
            <!-- Top Navigation -->
            <nav class="navbar navbar-expand-lg navbar-light bg-white shadow-sm">
                <div class="container-fluid">
                    <button class="navbar-toggler d-md-none" type="button" data-bs-toggle="collapse" data-bs-target="#sidebarMenu">
                        <span class="navbar-toggler-icon"></span>
                    </button>
                    <span class="navbar-brand mb-0 h1">Admin Dashboard</span>
                    <div class="navbar-nav ms-auto">
                        <span class="navbar-text">
                            Xin chào, ${user.fullName}!
                        </span>
                    </div>
                </div>
            </nav>

            <div class="container-fluid p-4">
                <!-- Welcome Section -->
                <div class="welcome-section">
                    <div class="row align-items-center">
                        <div class="col-md-8">
                            <h2 class="mb-3">
                                <i class="fas fa-tachometer-alt me-2"></i>
                                Chào mừng đến với Admin Dashboard
                            </h2>
                            <p class="mb-0">Quản lý hệ thống nhà trọ một cách hiệu quả và chuyên nghiệp</p>
                        </div>
                        <div class="col-md-4 text-end">
                            <i class="fas fa-chart-line fa-4x opacity-75"></i>
                        </div>
                    </div>
                </div>

                <!-- Quick Stats -->
                <div class="row mb-4">
                    <div class="col-xl-3 col-md-6 mb-4">
                        <div class="card stats-card primary h-100">
                            <div class="card-body">
                                <div class="row no-gutters align-items-center">
                                    <div class="col mr-2">
                                        <div class="text-xs font-weight-bold text-primary text-uppercase mb-1">
                                            Tổng người dùng
                                        </div>
                                        <div class="h5 mb-0 font-weight-bold text-gray-800">150</div>
                                    </div>
                                    <div class="col-auto">
                                        <i class="fas fa-users fa-2x text-gray-300"></i>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="col-xl-3 col-md-6 mb-4">
                        <div class="card stats-card success h-100">
                            <div class="card-body">
                                <div class="row no-gutters align-items-center">
                                    <div class="col mr-2">
                                        <div class="text-xs font-weight-bold text-success text-uppercase mb-1">
                                            Phòng đã thuê
                                        </div>
                                        <div class="h5 mb-0 font-weight-bold text-gray-800">85%</div>
                                    </div>
                                    <div class="col-auto">
                                        <i class="fas fa-home fa-2x text-gray-300"></i>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="col-xl-3 col-md-6 mb-4">
                        <div class="card stats-card info h-100">
                            <div class="card-body">
                                <div class="row no-gutters align-items-center">
                                    <div class="col mr-2">
                                        <div class="text-xs font-weight-bold text-info text-uppercase mb-1">
                                            Hợp đồng hiệu lực
                                        </div>
                                        <div class="h5 mb-0 font-weight-bold text-gray-800">120</div>
                                    </div>
                                    <div class="col-auto">
                                        <i class="fas fa-file-contract fa-2x text-gray-300"></i>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="col-xl-3 col-md-6 mb-4">
                        <div class="card stats-card warning h-100">
                            <div class="card-body">
                                <div class="row no-gutters align-items-center">
                                    <div class="col mr-2">
                                        <div class="text-xs font-weight-bold text-warning text-uppercase mb-1">
                                            Doanh thu tháng
                                        </div>
                                        <div class="h5 mb-0 font-weight-bold text-gray-800">$45,000</div>
                                    </div>
                                    <div class="col-auto">
                                        <i class="fas fa-dollar-sign fa-2x text-gray-300"></i>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Quick Actions -->
                <div class="row mb-4">
                    <div class="col-12">
                        <div class="card">
                            <div class="card-header">
                                <h5 class="mb-0">
                                    <i class="fas fa-bolt me-2"></i>
                                    Thao tác nhanh
                                </h5>
                            </div>
                            <div class="card-body">
                                <div class="row">
                                    <div class="col-md-3 mb-3">
                                        <a href="adminusermanagement" class="feature-card">
                                            <div class="card text-center h-100">
                                                <div class="card-body">
                                                    <div class="feature-icon text-primary">
                                                        <i class="fas fa-users"></i>
                                                    </div>
                                                    <h6 class="card-title">Quản lý người dùng</h6>
                                                    <p class="card-text small">Thêm, sửa, xóa người dùng</p>
                                                </div>
                                            </div>
                                        </a>
                                    </div>
                                    <div class="col-md-3 mb-3">
                                        <a href="listrooms" class="feature-card">
                                            <div class="card text-center h-100">
                                                <div class="card-body">
                                                    <div class="feature-icon text-success">
                                                        <i class="fas fa-home"></i>
                                                    </div>
                                                    <h6 class="card-title">Quản lý phòng</h6>
                                                    <p class="card-text small">Quản lý thông tin phòng trọ</p>
                                                </div>
                                            </div>
                                        </a>
                                    </div>
                                    <div class="col-md-3 mb-3">
                                        <a href="listcontracts" class="feature-card">
                                            <div class="card text-center h-100">
                                                <div class="card-body">
                                                    <div class="feature-icon text-info">
                                                        <i class="fas fa-file-contract"></i>
                                                    </div>
                                                    <h6 class="card-title">Quản lý hợp đồng</h6>
                                                    <p class="card-text small">Theo dõi hợp đồng thuê phòng</p>
                                                </div>
                                            </div>
                                        </a>
                                    </div>
                                    <div class="col-md-3 mb-3">
                                        <a href="#" class="feature-card">
                                            <div class="card text-center h-100">
                                                <div class="card-body">
                                                    <div class="feature-icon text-warning">
                                                        <i class="fas fa-chart-bar"></i>
                                                    </div>
                                                    <h6 class="card-title">Báo cáo</h6>
                                                    <p class="card-text small">Xem báo cáo thống kê</p>
                                                </div>
                                            </div>
                                        </a>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Recent Activities -->
                <div class="row">
                    <div class="col-lg-8">
                        <div class="card">
                            <div class="card-header">
                                <h5 class="mb-0">
                                    <i class="fas fa-history me-2"></i>
                                    Hoạt động gần đây
                                </h5>
                            </div>
                            <div class="card-body">
                                <div class="list-group list-group-flush">
                                    <div class="list-group-item d-flex justify-content-between align-items-center">
                                        <div>
                                            <i class="fas fa-user-plus text-success me-2"></i>
                                            Người dùng mới đăng ký: Nguyễn Văn A
                                        </div>
                                        <small class="text-muted">2 phút trước</small>
                                    </div>
                                    <div class="list-group-item d-flex justify-content-between align-items-center">
                                        <div>
                                            <i class="fas fa-home text-info me-2"></i>
                                            Phòng A101 đã được thuê
                                        </div>
                                        <small class="text-muted">15 phút trước</small>
                                    </div>
                                    <div class="list-group-item d-flex justify-content-between align-items-center">
                                        <div>
                                            <i class="fas fa-file-contract text-warning me-2"></i>
                                            Hợp đồng mới được tạo
                                        </div>
                                        <small class="text-muted">1 giờ trước</small>
                                    </div>
                                    <div class="list-group-item d-flex justify-content-between align-items-center">
                                        <div>
                                            <i class="fas fa-user-edit text-primary me-2"></i>
                                            Thông tin người dùng được cập nhật
                                        </div>
                                        <small class="text-muted">2 giờ trước</small>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-lg-4">
                        <div class="card">
                            <div class="card-header">
                                <h5 class="mb-0">
                                    <i class="fas fa-tasks me-2"></i>
                                    Công việc cần làm
                                </h5>
                            </div>
                            <div class="card-body">
                                <div class="list-group list-group-flush">
                                    <div class="list-group-item">
                                        <div class="d-flex w-100 justify-content-between">
                                            <h6 class="mb-1">Kiểm tra hợp đồng sắp hết hạn</h6>
                                            <small class="text-danger">Ưu tiên cao</small>
                                        </div>
                                        <p class="mb-1">5 hợp đồng sắp hết hạn trong tuần tới</p>
                                    </div>
                                    <div class="list-group-item">
                                        <div class="d-flex w-100 justify-content-between">
                                            <h6 class="mb-1">Cập nhật thông tin phòng</h6>
                                            <small class="text-warning">Trung bình</small>
                                        </div>
                                        <p class="mb-1">Kiểm tra tình trạng các phòng trống</p>
                                    </div>
                                    <div class="list-group-item">
                                        <div class="d-flex w-100 justify-content-between">
                                            <h6 class="mb-1">Tạo báo cáo tháng</h6>
                                            <small class="text-info">Thấp</small>
                                        </div>
                                        <p class="mb-1">Báo cáo doanh thu và thống kê</p>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </body>
</html>
