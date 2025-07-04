<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chi tiết Phòng - Manager Dashboard</title>
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
                            <h2 class="mb-1">Chi tiết Phòng #${rooms.roomNumber}</h2>
                            <p class="text-muted mb-0">Thông tin chi tiết về phòng và ảnh phòng</p>
                        </div>
                        <div>
                            <a href="updateroom?id=${rooms.roomId}" class="btn btn-warning me-2">
                                <i class="fas fa-edit me-2"></i>
                                Chỉnh sửa
                            </a>
                            <a href="listrooms" class="btn btn-outline-secondary">
                                <i class="fas fa-arrow-left me-2"></i>
                                Quay lại
                            </a>
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
                    
                    <!-- Room Details -->
                    <div class="card mb-4">
                        <div class="card-header bg-primary text-white">
                            <h5 class="mb-0">
                                <i class="fas fa-info-circle me-2"></i>
                                Thông tin phòng
                            </h5>
                        </div>
                        <div class="card-body">
                            <div class="row">
                                <div class="col-md-6">
                                    <h6 class="text-muted">Số phòng</h6>
                                    <p class="fw-bold">${rooms.roomNumber}</p>
                                </div>
                                <div class="col-md-6">
                                    <h6 class="text-muted">Khu vực</h6>
                                    <p>${rooms.rentalAreaName}</p>
                                </div>
                                <div class="col-md-6">
                                    <h6 class="text-muted">Diện tích (m²)</h6>
                                    <p>${rooms.area}</p>
                                </div>
                                <div class="col-md-6">
                                    <h6 class="text-muted">Giá (VNĐ/tháng)</h6>
                                    <p class="fw-bold text-primary">${rooms.price}</p>
                                </div>
                                <div class="col-md-6">
                                    <h6 class="text-muted">Trạng thái</h6>
                                    <c:choose>
                                        <c:when test="${rooms.status == 0}">
                                            <span class="badge status-available">
                                                <i class="fas fa-check-circle me-1"></i>
                                                Còn trống
                                            </span>
                                        </c:when>
                                        <c:when test="${rooms.status == 1}">
                                            <span class="badge status-occupied">
                                                <i class="fas fa-user me-1"></i>
                                                Đã thuê
                                            </span>
                                        </c:when>
                                        <c:when test="${rooms.status == 3}">
                                            <span class="badge status-maintenance">
                                                <i class="fas fa-tools me-1"></i>
                                                Bảo trì
                                            </span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge bg-secondary">${rooms.status}</span>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                                <div class="col-md-6">
                                    <h6 class="text-muted">Người thuê hiện tại</h6>
                                    <p>
                                        <c:if test="${not empty rooms.currentTenant}">
                                            ${rooms.currentTenant}
                                        </c:if>
                                        <c:if test="${empty rooms.currentTenant}">
                                            <span class="text-muted">-</span>
                                        </c:if>
                                    </p>
                                </div>
                                <div class="col-md-12">
                                    <h6 class="text-muted">Mô tả</h6>
                                    <p>
                                        <c:if test="${not empty rooms.description}">
                                            ${rooms.description}
                                        </c:if>
                                        <c:if test="${empty rooms.description}">
                                            <span class="text-muted">Không có mô tả</span>
                                        </c:if>
                                    </p>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Room Images -->
                    <div class="card mb-4">
                        <div class="card-header bg-primary text-white">
                            <h5 class="mb-0">
                                <i class="fas fa-image me-2"></i>
                                Ảnh phòng
                            </h5>
                        </div>
                        <div class="card-body">
                            <c:if test="${not empty image}">
                                <div class="row">
                                    <c:forEach var="image" items="${image}">
                                        <div class="col-md-4 mb-3">
                                            <div class="card">
                                                <img src="${image.urlImage}" class="card-img-top" alt="Ảnh phòng ${rooms.roomNumber}" style="height: 200px; object-fit: cover;">
                                                <div class="card-body text-center">
                                                    <p class="card-text text-muted">${rooms.roomNumber}</p>
                                                </div>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </div>
                            </c:if>
                            <c:if test="${empty image}">
                                <div class="text-center py-5">
                                    <i class="fas fa-image fa-3x text-muted mb-3"></i>
                                    <h5 class="text-muted">Không có ảnh nào</h5>
                                    <p class="text-muted">Vui lòng thêm ảnh cho phòng này.</p>
                                </div>
                            </c:if>
                        </div>
                    </div>
                    
                    <!-- Rental History -->
                    <div class="card">
                        <div class="card-header bg-primary text-white">
                            <h5 class="mb-0">
                                <i class="fas fa-history me-2"></i>
                                Lịch sử thuê phòng (Top 5)
                            </h5>
                        </div>
                        <div class="card-body p-0">
                            <div class="table-responsive">
                                <table class="table table-hover mb-0">
                                    <thead>
                                        <tr>
                                            <th>Tên người thuê</th>
                                            <th>Ngày bắt đầu</th>
                                            <th>Ngày kết thúc</th>
                                            <th>Giá thuê (VNĐ/tháng)</th>
                                            <th>Ghi chú</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach var="history" items="${rentalHistory}">
                                            <tr>
                                                <td>${history.tenantName}</td>
                                                <td>${history.startDate}</td>
                                                <td>
                                                    <c:if test="${not empty history.endDate}">
                                                        ${history.endDate}
                                                    </c:if>
                                                    <c:if test="${empty history.endDate}">
                                                        <span class="text-muted">-</span>
                                                    </c:if>
                                                </td>
                                                <td>
                                                    <span class="fw-bold text-primary">
                                                        ${history.rentPrice}
                                                    </span>
                                                </td>
                                                <td>
                                                    <c:if test="${not empty history.notes}">
                                                        ${history.notes}
                                                    </c:if>
                                                    <c:if test="${empty history.notes}">
                                                        <span class="text-muted">-</span>
                                                    </c:if>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                            <c:if test="${empty rentalHistory}">
                                <div class="text-center py-5">
                                    <i class="fas fa-history fa-3x text-muted mb-3"></i>
                                    <h5 class="text-muted">Không có lịch sử thuê</h5>
                                    <p class="text-muted">Phòng này chưa có lịch sử thuê hoặc chưa được cập nhật.</p>
                                </div>
                            </c:if>
                        </div>
                    </div>
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