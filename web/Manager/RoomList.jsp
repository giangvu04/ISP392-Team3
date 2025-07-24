<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý Phòng - Manager Dashboard</title>
    <base href="${pageContext.request.contextPath}/">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link href="css/rooms.css" rel="stylesheet">
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
                            <h2 class="mb-1">Quản lý Phòng</h2>
                            <p class="text-muted mb-0">Quản lý tất cả phòng trong khu vực của bạn</p>
                        </div>
                        <div>
                            <a href="addroom" class="btn btn-primary">
                                <i class="fas fa-plus me-2"></i>
                                Thêm phòng mới
                            </a>
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
                    
                    <!-- Rooms Table -->
                    <div class="card">
                        <div class="card-header bg-primary text-white">
                            <h5 class="mb-0">
                                <i class="fas fa-list me-2"></i>
                                Danh sách phòng (${totalRooms} phòng)
                            </h5>
                        </div>
                        <div class="card-body p-0">
                            <div class="table-responsive">
                                <table class="table table-hover mb-0">
                                    <thead>
                                        <tr>
                                            <th>Số phòng</th>
                                            <th>Khu vực</th>
                                            <th>Diện tích</th>
                                            <th>Giá (VNĐ/tháng)</th>
                                            <th>Trạng thái</th>
                                            <th>Người thuê hiện tại</th>
                                            <th>Thao tác</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="room" items="${rooms}">
                                            <tr>
                                                <td>
                                                    <strong>${room.roomNumber}</strong>
                                                </td>
                                                <td>${room.rentalAreaName}</td>
                                                <td>${room.area}</td>
                                                <td>
                                                    <span class="fw-bold text-primary">
                                                        ${room.price}
                                                    </span>
                                                </td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${room.status == 0}">
                                                            <span class="badge status-available">
                                                                <i class="fas fa-check-circle me-1"></i>
                                                                Còn trống
                                                            </span>
                                                        </c:when>
                                                        <c:when test="${room.status == 1}">
                                                            <span class="badge status-occupied">
                                                                <i class="fas fa-user me-1"></i>
                                                                Đã thuê
                                                            </span>
                                                        </c:when>
                                                        <c:when test="${room.status == 3}">
                                                            <span class="badge status-maintenance">
                                                                <i class="fas fa-tools me-1"></i>
                                                                Bảo trì
                                                            </span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="badge bg-secondary">${room.status}</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>
                                                    <c:if test="${not empty room.currentTenant}">
                                                        ${room.currentTenant}
                                                    </c:if>
                                                    <c:if test="${empty room.currentTenant}">
                                                        <span class="text-muted">-</span>
                                                    </c:if>
                                                </td>
                                                <td>
                                                    <div class="btn-group" role="group">
                                                        <a href="roomdetail?id=${room.roomId}" class="btn btn-sm btn-outline-info" title="Xem chi tiết">
                                                            <i class="fas fa-eye"></i>
                                                        </a>
                                                        <a href="updateroom?id=${room.roomId}" class="btn btn-sm btn-outline-warning" title="Chỉnh sửa">
                                                            <i class="fas fa-edit"></i>
                                                        </a>
                                                        <c:if test="${room.status == 0}">
                                                            <a href="assignroom?id=${room.roomId}" class="btn btn-sm btn-outline-success" title="Gán người thuê">
                                                                <i class="fas fa-user-plus"></i>
                                                            </a>
                                                        </c:if>
                                                    </div>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                            
                            <!-- Empty State -->
                            <c:if test="${empty rooms}">
                                <div class="text-center py-5">
                                    <i class="fas fa-bed fa-3x text-muted mb-3"></i>
                                    <h5 class="text-muted">Không tìm thấy phòng nào</h5>
                                    <p class="text-muted">Thử thay đổi tiêu chí tìm kiếm hoặc thêm phòng mới.</p>
                                </div>
                            </c:if>
                        </div>
                    </div>
                    
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