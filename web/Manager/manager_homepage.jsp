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
                <jsp:include page="../Sidebar/SideBarManager.jsp"/>

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
                                                <h3 class="mb-0">${totalRooms}</h3>
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
                                                <h3 class="mb-0">${rentedRooms}</h3>
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
                                                <h3 class="mb-0">${vacantRooms}</h3>
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
                                                <h3 class="mb-0">${newContract}</h3>
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
                                                <a href="listUser" class="btn btn-outline-success w-100">
                                                    <i class="fas fa-users me-2"></i>
                                                    Quản lý người thuê
                                                </a>
                                            </div>
                                            <div class="col-6 mb-3">
                                                <a href="manageViewingRequests" class="btn btn-outline-danger w-100">
                                                    <i class="fas fa-eye me-2"></i>
                                                    Yêu cầu xem phòng
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
                                            <div class="col-6 mb-3">
                                                <a href="feedbacklist" class="btn btn-outline-warning w-100">
                                                    <i class="fas fa-clock me-2"></i>
                                                    Phản hồi
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
                                                <span class="fw-bold">${fillPercent}%</span>
                                            </div>
                                            <div class="progress mt-1">
                                                <div class="progress-bar bg-success" style="width: ${fillPercent}%"></div>
                                            </div>
                                        </div>
                                        <div class="mb-3">
                                            <div class="d-flex justify-content-between">
                                                <span>Doanh thu tháng</span>
                                                <span class="fw-bold">${profit} VND</span>
                                            </div>
                                            <div class="progress mt-1">
                                                <div class="progress-bar bg-info" style="width: 85%"></div>
                                            </div>
                                        </div>
                                        <div class="mb-3">
                                            <div class="d-flex justify-content-between">
                                                <span>Hợp đồng sắp hết hạn</span>
                                                <span class="fw-bold">${expiringContracts}</span>
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
        <jsp:include page="../Message.jsp"/>
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