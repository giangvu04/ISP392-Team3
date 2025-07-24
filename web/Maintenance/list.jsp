<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Lịch sử bảo trì & Báo lỗi</title>
    <link rel="stylesheet" href="css/contracts.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</head>
<body>
<div class="container-fluid">
    <div class="row">
        <!-- Sidebar -->
        <c:choose>
            <c:when test="${user.roleId == 3}">
                <jsp:include page="../Sidebar/SideBarTelnant.jsp"/>
            </c:when>
            <c:otherwise>
                <jsp:include page="../Sidebar/SideBarManager.jsp"/>
            </c:otherwise>
        </c:choose>
        <!-- Main Content -->
        <div class="col-md-9 col-lg-10">
            <div class="main-content p-4">
                <!-- Header -->
                
                <div class="d-flex justify-content-between align-items-center mb-3">
                    <h2 class="mb-1"><i class="fas fa-tools"></i> Lịch sử bảo trì & Báo lỗi</h2>
                    <button class="btn btn-danger" data-bs-toggle="modal" data-bs-target="#reportModal">
                        <i class="fas fa-plus"></i> Báo lỗi
                    </button>
                </div>
                <!-- Search/Filter Form -->
                <div class="card mb-4">
                    <div class="card-body">
                        <form action="maintenanceList" method="get" class="row g-3 align-items-end">
                            <div class="col-md-3">
                                <label for="startDate" class="form-label">Từ ngày</label>
                                <input type="date" class="form-control" id="startDate" name="startDate" value="${param.startDate}">
                            </div>
                            <div class="col-md-3">
                                <label for="endDate" class="form-label">Đến ngày</label>
                                <input type="date" class="form-control" id="endDate" name="endDate" value="${param.endDate}">
                            </div>
                            <div class="col-md-3">
                                <label for="type" class="form-label">Loại bảo trì</label>
                                <select class="form-select" id="type" name="type">
                                    <option value="">-- Tất cả --</option>
                                    <option value="repair" ${param.type == 'repair' ? 'selected' : ''}>Sửa chữa</option>
                                    <option value="cleaning" ${param.type == 'cleaning' ? 'selected' : ''}>Vệ sinh</option>
                                    <option value="other" ${param.type == 'other' ? 'selected' : ''}>Khác</option>
                                </select>
                            </div>
                            <div class="col-md-3">
                                <button type="submit" class="btn btn-primary w-100"><i class="fas fa-search me-2"></i>Tìm kiếm</button>
                            </div>
                        </form>
                    </div>
                </div>
                <div class="card">
                    <div class="card-body p-0">
                        <div class="table-responsive">
                            <table class="table table-bordered table-hover mb-0">
                                <thead class="table-light">
                                <tr>
                                    <th>#</th>
                                    <th>Tiêu đề</th>
                                    <th>Khu trọ</th>
                                    <th>Phòng</th>
                                    <th>Mô tả</th>
                                    <th>Ngày báo lỗi</th>
                                    <c:if test="${user.roleId != 3}">
                                        <th>Chi phí</th>
                                    </c:if>
                                    <th>Người tạo</th>
                                    <th>Ngày xác nhận</th>
                                    <th>Trạng thái</th>
                                    <th>Phản hồi chủ nhà</th>
                                </tr>
                                </thead>
                                <tbody>
                                <c:forEach var="log" items="${maintenanceLogs}">
                                    <tr>
                                        <td>${log.maintenanceId}</td>
                                        <td>${log.title}</td>
                                        <td>${log.rentalAreaName}</td>
                                        <td>${log.roomName}</td>
                                        <td>${log.description}</td>
                                        <td>${log.createdAt}</td>
                                        <c:if test="${user.roleId != 3}">
                                            <td>${log.cost}</td>
                                        </c:if>
                                        <td>${log.createdByName}</td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${log.status == '1' || log.status == '2'}">
                                                    ${log.maintenanceDate}
                                                </c:when>
                                                <c:otherwise>
                                                    --
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${log.status == '0'}">Chờ xác nhận</c:when>
                                                <c:when test="${log.status == '1'}">Đã xác nhận</c:when>
                                                <c:when test="${log.status == '2'}">Đã bảo trì</c:when>
                                                <c:otherwise>${log.status}</c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>${log.ownerNote}</td>
                                    </tr>
                                </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>

<!-- Modal for reporting an issue -->
<div class="modal fade" id="reportModal" tabindex="-1" aria-labelledby="reportModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <form action="maintenanceReport" method="post">
                <div class="modal-header">
                    <h5 class="modal-title" id="reportModalLabel">Báo lỗi/Báo hỏng thiết bị</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <div class="mb-3">
                        <label for="title" class="form-label">Tiêu đề</label>
                        <input type="text" class="form-control" id="title" name="title" required>
                    </div>
                    <div class="mb-3">
                        <label for="rentalAreaId" class="form-label">Khu trọ</label>
                        <select class="form-select" id="rentalAreaId" name="rentalAreaId" required>
                            <c:forEach var="area" items="${rentalAreas}">
                                <option value="${area.rentalAreaId}">${area.name}</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="mb-3">
                        <label for="roomId" class="form-label">Phòng (nếu có)</label>
                        <select class="form-select" id="roomId" name="roomId">
                            <option value="">-- Toàn khu --</option>
                            <c:forEach var="room" items="${rooms}">
                                <option value="${room.roomId}">${room.roomNumber} - ${room.rentalAreaName}</option>
                            </c:forEach>
                        </select>
                    </div>
                    <div class="mb-3">
                        <label for="description" class="form-label">Mô tả lỗi</label>
                        <textarea class="form-control" id="description" name="description" rows="3" required></textarea>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
                    <button type="submit" class="btn btn-danger">Gửi báo lỗi</button>
                </div>
            </form>
        </div>
    </div>
</div>
</body>
</html>

