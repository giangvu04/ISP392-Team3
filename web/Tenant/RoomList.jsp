<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Danh sách Phòng - Tenant Dashboard</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        .sidebar {
            min-height: 100vh;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        }
        .sidebar .nav-link {
            color: rgba(255,255,255,0.8);
            padding: 12px 20px;
            margin: 4px 0;
            border-radius: 8px;
            transition: all 0.3s ease;
        }
        .sidebar .nav-link:hover {
            background-color: rgba(255,255,255,0.1);
            color: white;
            transform: translateX(5px);
        }
        .sidebar .nav-link.active {
            background-color: rgba(255,255,255,0.2);
            color: white;
        }
        .main-content {
            background-color: #f8f9fa;
            min-height: 100vh;
        }
        .card {
            border: none;
            border-radius: 15px;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
        }
        .table {
            border-radius: 10px;
            overflow: hidden;
        }
        .table thead th {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border: none;
        }
        .status-available {
            background-color: #d4edda;
            color: #155724;
        }
        .status-occupied {
            background-color: #f8d7da;
            color: #721c24;
        }
        .status-maintenance {
            background-color: #fff3cd;
            color: #856404;
        }
        .search-box {
            background: white;
            border-radius: 25px;
            padding: 10px 20px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        .room-card {
            transition: transform 0.3s ease;
        }
        .room-card:hover {
            transform: translateY(-5px);
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
                            <i class="fas fa-home me-2"></i>
                            Tenant Panel
                        </h4>
                    </div>
                    
                    <!-- User Info -->
                    <div class="text-center mb-4">
                        <i class="fas fa-user-circle fa-3x text-white mb-2"></i>
                        <h6 class="text-white mb-1">${currentUser.fullName}</h6>
                        <small class="text-white-50">Người thuê</small>
                    </div>
                    
                    <!-- Navigation -->
                    <nav class="nav flex-column">
                        <a class="nav-link" href="TenantHomepage">
                            <i class="fas fa-tachometer-alt me-2"></i>
                            Dashboard
                        </a>
                        <a class="nav-link active" href="listrooms">
                            <i class="fas fa-bed me-2"></i>
                            Xem phòng
                        </a>
                        <a class="nav-link" href="mycontract">
                            <i class="fas fa-file-contract me-2"></i>
                            Hợp đồng của tôi
                        </a>
                        <a class="nav-link" href="mybills">
                            <i class="fas fa-receipt me-2"></i>
                            Hóa đơn của tôi
                        </a>
                        <a class="nav-link" href="myservices">
                            <i class="fas fa-concierge-bell me-2"></i>
                            Dịch vụ đã đăng ký
                        </a>
                        <a class="nav-link" href="maintenance">
                            <i class="fas fa-tools me-2"></i>
                            Báo sửa chữa
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
                            <h2 class="mb-1">Danh sách Phòng</h2>
                            <p class="text-muted mb-0">Xem các phòng có sẵn để thuê</p>
                        </div>
                    </div>
                    
                    <!-- Search and Filter -->
                    <div class="card mb-4">
                        <div class="card-body">
                            <form method="GET" action="listrooms" class="row g-3">
                                <div class="col-md-4">
                                    <div class="search-box">
                                        <i class="fas fa-search text-muted me-2"></i>
                                        <input type="text" class="form-control border-0" name="searchTerm" 
                                               placeholder="Tìm kiếm theo số phòng..." 
                                               value="${searchTerm}">
                                    </div>
                                </div>
                                <div class="col-md-3">
                                    <select class="form-select" name="sortBy">
                                        <option value="roomNumber" ${sortBy == 'roomNumber' ? 'selected' : ''}>Sắp xếp theo số phòng</option>
                                        <option value="price" ${sortBy == 'price' ? 'selected' : ''}>Sắp xếp theo giá</option>
                                        <option value="status" ${sortBy == 'status' ? 'selected' : ''}>Sắp xếp theo trạng thái</option>
                                    </select>
                                </div>
                                <div class="col-md-2">
                                    <select class="form-select" name="sortOrder">
                                        <option value="asc" ${sortOrder == 'asc' ? 'selected' : ''}>Tăng dần</option>
                                        <option value="desc" ${sortOrder == 'desc' ? 'selected' : ''}>Giảm dần</option>
                                    </select>
                                </div>
                                <div class="col-md-3">
                                    <button type="submit" class="btn btn-primary me-2">
                                        <i class="fas fa-search me-1"></i>
                                        Tìm kiếm
                                    </button>
                                    <a href="listrooms" class="btn btn-outline-secondary">
                                        <i class="fas fa-refresh me-1"></i>
                                        Làm mới
                                    </a>
                                </div>
                            </form>
                        </div>
                    </div>
                    
                    <!-- Error Message -->
                    <c:if test="${not empty error}">
                        <div class="alert alert-danger alert-dismissible fade show" role="alert">
                            <i class="fas fa-exclamation-triangle me-2"></i>
                            ${error}
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </div>
                    </c:if>
                    
                    <!-- Rooms Grid View -->
                    <div class="row">
                        <c:forEach var="room" items="${rooms}">
                            <div class="col-md-6 col-lg-4 mb-4">
                                <div class="card room-card h-100">
                                    <div class="card-body">
                                        <div class="d-flex justify-content-between align-items-start mb-3">
                                            <h5 class="card-title mb-0">Phòng ${room.roomNumber}</h5>
                                            <c:choose>
                                                <c:when test="${room.status == 'Available'}">
                                                    <span class="badge status-available">
                                                        <i class="fas fa-check-circle me-1"></i>
                                                        Còn trống
                                                    </span>
                                                </c:when>
                                                <c:when test="${room.status == 'Occupied'}">
                                                    <span class="badge status-occupied">
                                                        <i class="fas fa-user me-1"></i>
                                                        Đã thuê
                                                    </span>
                                                </c:when>
                                                <c:when test="${room.status == 'Maintenance'}">
                                                    <span class="badge status-maintenance">
                                                        <i class="fas fa-tools me-1"></i>
                                                        Bảo trì
                                                    </span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge bg-secondary">${room.status}</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                        
                                        <div class="mb-3">
                                            <div class="row">
                                                <div class="col-6">
                                                    <small class="text-muted">Khu vực:</small>
                                                    <div class="fw-bold">${room.rentalAreaName}</div>
                                                </div>
                                                <div class="col-6">
                                                    <small class="text-muted">Loại phòng:</small>
                                                    <div class="fw-bold">${room.roomType}</div>
                                                </div>
                                            </div>
                                        </div>
                                        
                                        <div class="mb-3">
                                            <small class="text-muted">Giá thuê:</small>
                                            <div class="h5 text-primary mb-0">${room.price} VNĐ/tháng</div>
                                        </div>
                                        
                                        <div class="mb-3">
                                            <small class="text-muted">Mô tả:</small>
                                            <p class="mb-0 text-muted">${room.description}</p>
                                        </div>
                                        
                                        <div class="d-grid">
                                            <c:if test="${room.status == 'Available'}">
                                                <a href="roomdetail?id=${room.id}" class="btn btn-primary">
                                                    <i class="fas fa-eye me-2"></i>
                                                    Xem chi tiết
                                                </a>
                                            </c:if>
                                            <c:if test="${room.status != 'Available'}">
                                                <button class="btn btn-secondary" disabled>
                                                    <i class="fas fa-eye me-2"></i>
                                                    Xem chi tiết
                                                </button>
                                            </c:if>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                    
                    <!-- Empty State -->
                    <c:if test="${empty rooms}">
                        <div class="text-center py-5">
                            <i class="fas fa-bed fa-3x text-muted mb-3"></i>
                            <h5 class="text-muted">Không tìm thấy phòng nào</h5>
                            <p class="text-muted">Thử thay đổi tiêu chí tìm kiếm.</p>
                        </div>
                    </c:if>
                    
                    <!-- Pagination -->
                    <c:if test="${totalPages > 1}">
                        <nav aria-label="Room pagination" class="mt-4">
                            <ul class="pagination justify-content-center">
                                <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                                    <a class="page-link" href="listrooms?page=${currentPage - 1}&sortBy=${sortBy}&sortOrder=${sortOrder}&searchTerm=${searchTerm}">
                                        <i class="fas fa-chevron-left"></i>
                                    </a>
                                </li>
                                
                                <c:forEach begin="1" end="${totalPages}" var="i">
                                    <li class="page-item ${currentPage == i ? 'active' : ''}">
                                        <a class="page-link" href="listrooms?page=${i}&sortBy=${sortBy}&sortOrder=${sortOrder}&searchTerm=${searchTerm}">${i}</a>
                                    </li>
                                </c:forEach>
                                
                                <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                                    <a class="page-link" href="listrooms?page=${currentPage + 1}&sortBy=${sortBy}&sortOrder=${sortOrder}&searchTerm=${searchTerm}">
                                        <i class="fas fa-chevron-right"></i>
                                    </a>
                                </li>
                            </ul>
                        </nav>
                    </c:if>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Add active class to current nav item
        document.addEventListener('DOMContentLoaded', function() {
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