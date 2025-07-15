<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý Thiết bị trong Phòng</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
        <link href="css/homepage.css" rel="stylesheet"><style>
        .device-card {
            transition: transform 0.2s, box-shadow 0.2s;
        }
        .device-card:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(0,0,0,0.15);
        }
        .search-box {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            padding: 2rem;
            border-radius: 15px;
            margin-bottom: 2rem;
        }
        .action-buttons .btn {
            margin: 0 2px;
        }
        .page-header {
            background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
            color: white;
            padding: 2rem 0;
            margin-bottom: 2rem;
        }
        .stats-card {
            background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
            color: white;
            border: none;
        }
        .btn-gradient {
            background: linear-gradient(45deg, #667eea, #764ba2);
            border: none;
            color: white;
        }
        .btn-gradient:hover {
            background: linear-gradient(45deg, #764ba2, #667eea);
            color: white;
        }
        .table-responsive {
            border-radius: 10px;
            overflow: hidden;
            box-shadow: 0 0 20px rgba(0,0,0,0.1);
        }
        .alert {
            border-radius: 10px;
        }
        .pagination .page-link {
            border: none;
            margin: 0 2px;
            border-radius: 8px;
        }
        .pagination .page-item.active .page-link {
            background: linear-gradient(45deg, #667eea, #764ba2);
            border: none;
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
                            <h2 class="mb-1">Quản lý Thiết bị trong Phòng</h2>
                            <p class="text-muted mb-0">Quản lý, tìm kiếm và thao tác với thiết bị trong từng phòng.</p>
                        </div>
                        <div class="text-end">
                            <a class="btn btn-light btn-lg" href="ManagerHomepage">Quay lại</a>
                        </div>
                    </div>
                    <!-- Statistics Cards (customized for device in room) -->
                    <div class="row mb-4">
                        <div class="col-md-4 mb-3">
                            <div class="card stats-card">
                                <div class="card-body text-center">
                                    <h6 class="card-title">Tổng số thiết bị</h6>
                                    <h3 class="mb-0">${totalDevices}</h3>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-4 mb-3">
                            <div class="card stat-card-3">
                                <div class="card-body text-center">
                                    <h6 class="card-title">Tổng số trang</h6>
                                    <h3 class="mb-0">${totalPages}</h3>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-4 mb-3">
                            <div class="card stat-card-2">
                                <div class="card-body text-center">
                                    <h6 class="card-title">Trang hiện tại</h6>
                                    <h3 class="mb-0">${currentPage}</h3>
                                </div>
                            </div>
                        </div>
                    </div>
                    <!-- Alert Messages -->
                    <c:if test="${not empty sessionScope.successMessage}">
                        <div class="alert alert-success alert-dismissible fade show" role="alert">
                            <i class="fas fa-check-circle me-2"></i>${sessionScope.successMessage}
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </div>
                        <c:remove var="successMessage" scope="session"/>
                    </c:if>
                    <c:if test="${not empty sessionScope.errorMessage}">
                        <div class="alert alert-danger alert-dismissible fade show" role="alert">
                            <i class="fas fa-exclamation-triangle me-2"></i>${sessionScope.errorMessage}
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </div>
                        <c:remove var="errorMessage" scope="session"/>
                    </c:if>
                    <!-- Search and Filter Box -->
                    <div class="search-box mb-4">
                        <form method="GET" action="${pageContext.request.contextPath}/deviceinroom" class="mb-0">
                            <input type="hidden" name="action" value="search">
                            <div class="row align-items-center">
                                <div class="col-md-8">
                                    <div class="input-group">
                                        <span class="input-group-text bg-white border-0">
                                            <i class="fas fa-search text-muted"></i>
                                        </span>
                                        <input type="text" class="form-control form-control-lg border-0" name="keyword" 
                                               placeholder="Tìm kiếm theo tên thiết bị..." value="${keyword}">
                                    </div>
                                </div>
                                <div class="col-md-4">
                                    <div class="d-grid gap-2 d-md-flex">
                                        <button type="submit" class="btn btn-light btn-lg me-2">
                                            <i class="fas fa-search me-2"></i>Tìm kiếm
                                        </button>
                                        <c:if test="${searchMode}">
                                            <a href="${pageContext.request.contextPath}/deviceinroom?action=list" 
                                               class="btn btn-outline-light btn-lg">
                                                <i class="fas fa-times me-2"></i>Hủy
                                            </a>
                                        </c:if>
                                    </div>
                                </div>
                            </div>
                        </form>
                    </div>
                    <!-- Device List Table -->
                    <div class="card">
                        <div class="card-header bg-white">
                            <div class="row align-items-center">
                                <div class="col">
                                    <h5 class="mb-0">
                                        <i class="fas fa-list me-2 text-primary"></i>
                                        <c:choose>
                                            <c:when test="${searchMode}">Kết quả tìm kiếm</c:when>
                                            <c:when test="${filterByRoom}">Thiết bị trong phòng ${roomId}</c:when>
                                            <c:otherwise>Danh sách thiết bị trong phòng</c:otherwise>
                                        </c:choose>
                                        <c:if test="${not empty currentPage and not empty totalPages and not searchMode and not filterByRoom}">
                                            (Trang ${currentPage}/${totalPages})
                                        </c:if>
                                    </h5>
                                </div>
                                <div class="col-auto">
                                    <a href="${pageContext.request.contextPath}/deviceinroom?action=add" class="btn btn-gradient">
                                        <i class="fas fa-plus me-2"></i>Thêm thiết bị vào phòng
                                    </a>
                                </div>
                            </div>
                        </div>
                        <div class="card-body p-0">
                            <c:choose>
                                <c:when test="${empty devicesInRooms}">
                                    <div class="text-center py-5">
                                        <i class="fas fa-inbox fa-3x text-muted mb-3"></i>
                                        <h5 class="text-muted">
                                            <c:choose>
                                                <c:when test="${searchMode}">
                                                    Không tìm thấy thiết bị nào với từ khóa "${keyword}"
                                                </c:when>
                                                <c:when test="${filterByRoom}">
                                                    Không có thiết bị nào trong phòng ${roomId}
                                                </c:when>
                                                <c:otherwise>
                                                    Chưa có thiết bị nào trong hệ thống
                                                </c:otherwise>
                                            </c:choose>
                                        </h5>
                                        <a href="${pageContext.request.contextPath}/deviceinroom?action=add" class="btn btn-gradient mt-3">
                                            <i class="fas fa-plus me-2"></i>Thêm thiết bị đầu tiên
                                        </a>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <div class="table-responsive">
                                        <table class="table table-hover mb-0">
                                            <thead class="table-dark">
                                                <tr>
                                                    <th class="text-center" style="width: 80px;">#</th>
                                                    <th>Phòng</th>
                                                    <th>Tên thiết bị</th>
                                                    <th>Số lượng</th>
                                                    <th>Trạng thái</th>
                                                    <th class="text-center" style="width: 200px;">Thao tác</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <c:forEach var="deviceInRoom" items="${devicesInRooms}" varStatus="status">
                                                    <tr>
                                                        <td class="text-center align-middle">
                                                            <span class="badge bg-primary rounded-pill">
                                                                <c:choose>
                                                                    <c:when test="${searchMode or filterByRoom}">
                                                                        ${status.index + 1}
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        ${(currentPage - 1) * devicesPerPage + status.index + 1}
                                                                    </c:otherwise>
                                                                </c:choose>
                                                            </span>
                                                        </td>
                                                        <td class="align-middle">${deviceInRoom.roomId}</td>
                                                        <td class="align-middle">${deviceInRoom.deviceName}</td>
                                                        <td class="align-middle">${deviceInRoom.quantity}</td>
                                                        <td class="align-middle">${deviceInRoom.status}</td>
                                                        <td class="text-center align-middle">
                                                            <div class="action-buttons">
                                                                <a href="${pageContext.request.contextPath}/deviceinroom?action=view&roomId=${deviceInRoom.roomId}&deviceId=${deviceInRoom.deviceId}" class="btn btn-sm btn-outline-info" title="Xem chi tiết">
                                                                    <i class="fas fa-eye"></i>
                                                                </a>
                                                                <button type="button" class="btn btn-sm btn-outline-danger" title="Xóa thiết bị" onclick="confirmDelete(${deviceInRoom.roomId}, ${deviceInRoom.deviceId}, '${deviceInRoom.deviceName}')">
                                                                    <i class="fas fa-trash"></i>
                                                                </button>
                                                            </div>
                                                        </td>
                                                    </tr>
                                                </c:forEach>
                                            </tbody>
                                        </table>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                    <!-- Pagination -->
                    <c:if test="${not searchMode and not filterByRoom and totalPages > 1}">
                        <div class="d-flex justify-content-center mt-4">
                            <nav aria-label="Phân trang thiết bị">
                                <ul class="pagination pagination-lg">
                                    <c:if test="${currentPage > 1}">
                                        <li class="page-item">
                                            <a class="page-link" href="${pageContext.request.contextPath}/deviceinroom?page=${currentPage - 1}">
                                                <i class="fas fa-chevron-left"></i>
                                            </a>
                                        </li>
                                    </c:if>
                                    <c:forEach begin="1" end="${totalPages}" var="pageNum">
                                        <li class="page-item ${pageNum == currentPage ? 'active' : ''}">
                                            <a class="page-link" href="${pageContext.request.contextPath}/deviceinroom?page=${pageNum}">${pageNum}</a>
                                        </li>
                                    </c:forEach>
                                    <c:if test="${currentPage < totalPages}">
                                        <li class="page-item">
                                            <a class="page-link" href="${pageContext.request.contextPath}/deviceinroom?page=${currentPage + 1}">
                                                <i class="fas fa-chevron-right"></i>
                                            </a>
                                        </li>
                                    </c:if>
                                </ul>
                            </nav>
                        </div>
                    </c:if>
                    <!-- Page Info -->
                    <c:if test="${not searchMode and not filterByRoom and not empty devicesInRooms}">
                        <div class="text-center mt-3">
                            <small class="text-muted">
                                Hiển thị ${(currentPage - 1) * devicesPerPage + 1} - 
                                ${(currentPage - 1) * devicesPerPage + devicesInRooms.size()} 
                                trong tổng số ${totalDevices} thiết bị
                            </small>
                        </div>
                    </c:if>
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