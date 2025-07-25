<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chi tiết khu trọ</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link href="css/rooms.css" rel="stylesheet">
</head>
<body>
<div class="container-fluid">
    <div class="row">
        <jsp:include page="../Sidebar/SideBarManager.jsp"/>
        <div class="col-md-9 col-lg-10">
            <div class="main-content p-4">
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <h2 class="mb-1">Chi tiết khu trọ</h2>
                    <div>
                        <a href="listrentail" class="btn btn-outline-secondary me-2">
                            <i class="fas fa-arrow-left me-1"></i> Quay lại danh sách
                        </a>
                        <a href="editrentail?id=${rentalArea.rentalAreaId}" class="btn btn-primary">
                            <i class="fas fa-edit me-1"></i> Chỉnh sửa
                        </a>
                    </div>
                </div>
                <div class="card mb-4">
                    <div class="card-body">
                        <dl class="row mb-0" style="row-gap: 1.25rem;">
                            <dt class="col-sm-3 mb-3">Tên khu trọ</dt>
                            <dd class="col-sm-9 fw-bold mb-3">${rentalArea.name}</dd>

                            <dt class="col-sm-3 mb-3">Địa chỉ</dt>
                            <dd class="col-sm-9 mb-3">${rentalArea.address}</dd>

                            <dt class="col-sm-3 mb-3">Tỉnh/Thành phố</dt>
                            <dd class="col-sm-9 mb-3">${rentalArea.province}</dd>

                            <dt class="col-sm-3 mb-3">Quận/Huyện</dt>
                            <dd class="col-sm-9 mb-3">${rentalArea.district}</dd>

                            <dt class="col-sm-3 mb-3">Phường/Xã</dt>
                            <dd class="col-sm-9 mb-3">${rentalArea.ward}</dd>

                            <dt class="col-sm-3 mb-3">Đường/Số nhà</dt>
                            <dd class="col-sm-9 mb-3">${rentalArea.street}</dd>

                            <dt class="col-sm-3 mb-3">Chi tiết</dt>
                            <dd class="col-sm-9 mb-3">${rentalArea.detail}</dd>

                            <dt class="col-sm-3 mb-3">Số phòng</dt>
                            <dd class="col-sm-9 mb-3">${rentalArea.totalRooms}</dd>

                            <dt class="col-sm-3 mb-3">Ngày tạo</dt>
                            <dd class="col-sm-9 mb-3">${rentalArea.createdAt}</dd>

                            <dt class="col-sm-3 mb-3">Trạng thái</dt>
                            <dd class="col-sm-9 mb-3">
                                <c:choose>
                                    <c:when test="${rentalArea.status == 1}">
                                        <span class="badge status-active"><i class="fas fa-check-circle me-1"></i> Đang hoạt động</span>
                                    </c:when>
                                    <c:when test="${rentalArea.status == 0}">
                                        <span class="badge status-inactive"><i class="fas fa-times-circle me-1"></i> Ngừng hoạt động</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge bg-secondary">${rentalArea.status}</span>
                                    </c:otherwise>
                                </c:choose>
                            </dd>
                        </dl>
                    </div>
                </div>
                <!-- Danh sách phòng trong khu vực -->
                <div class="card">
                    <div class="card-header bg-info text-white">
                        <h5 class="mb-0"><i class="fas fa-bed me-2"></i> Danh sách phòng trong khu vực</h5>
                    </div>
                    <div class="card-body p-0">
                        <div class="table-responsive">
                            <table class="table table-hover mb-0">
                                <thead>
                                    <tr>
                                        <th>Số phòng</th>
                                        <th>Diện tích</th>
                                        <th>Giá (VNĐ/tháng)</th>
                                        <th>Trạng thái</th>
                                        <th>Thao tác</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="room" items="${rooms}">
                                        <tr>
                                            <td><strong>${room.roomNumber}</strong></td>
                                            <td>${room.area}</td>
                                            <td><span class="fw-bold text-primary">${room.price}</span></td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${room.status == 0}">
                                                        <span class="badge status-available"><i class="fas fa-check-circle me-1"></i> Còn trống</span>
                                                    </c:when>
                                                    <c:when test="${room.status == 1}">
                                                        <span class="badge status-occupied"><i class="fas fa-user me-1"></i> Đã thuê</span>
                                                    </c:when>
                                                    <c:when test="${room.status == 3}">
                                                        <span class="badge status-maintenance"><i class="fas fa-tools me-1"></i> Bảo trì</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge bg-secondary">${room.status}</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <a href="viewRoom?roomId=${room.roomId}" class="btn btn-sm btn-outline-info" title="Xem chi tiết">
                                                    <i class="fas fa-eye"></i>
                                                </a>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                        <c:if test="${empty rooms}">
                            <div class="text-center py-4">
                                <i class="fas fa-bed fa-2x text-muted mb-2"></i>
                                <h6 class="text-muted">Không có phòng nào trong khu vực này</h6>
                            </div>
                        </c:if>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
