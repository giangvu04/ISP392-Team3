<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
    <head>

        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Quản lý Báo cáo - Hệ thống Quản lý Ký túc xá</title>
        <base href="${pageContext.request.contextPath}/">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
        <link href="css/homepage.css" rel="stylesheet">
        <style>
            .report-card {
                border: none;
                box-shadow: 0 4px 12px rgba(0,0,0,0.1);
                border-radius: 12px;
                transition: transform 0.2s ease, box-shadow 0.2s ease;
            }

            .report-card:hover {
                transform: translateY(-2px);
                box-shadow: 0 8px 20px rgba(0,0,0,0.15);
            }

            .status-badge {
                font-size: 0.85em;
                padding: 6px 12px;
                border-radius: 20px;
                font-weight: 600;
            }

            .status-pending {
                background-color: #fff3cd;
                color: #856404;
                border: 1px solid #ffeaa7;
            }

            .status-confirmed {
                background-color: #d4edda;
                color: #155724;
                border: 1px solid #c3e6cb;
            }

            .status-done {
                background-color: #cce5ff;
                color: #004085;
                border: 1px solid #b8daff;
            }

            .status-rejected {
                background-color: #f8d7da;
                color: #721c24;
                border: 1px solid #f1aeb5;
            }

            .message-type-badge {
                font-size: 0.8em;
                padding: 4px 8px;
                border-radius: 15px;
                font-weight: 500;
            }

            .type-bill {
                background-color: #e7f3ff;
                color: #0056b3;
            }

            .type-contract {
                background-color: #fff2e7;
                color: #b8860b;
            }

            .type-general {
                background-color: #f0f8ff;
                color: #4682b4;
            }

            .maintenance-icon {
                width: 50px;
                height: 50px;
                border-radius: 50%;
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 1.5rem;
                color: white;
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            }

            .message-icon {
                width: 50px;
                height: 50px;
                border-radius: 50%;
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 1.5rem;
                color: white;
                background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
            }

            .nav-pills .nav-link {
                border-radius: 25px;
                padding: 10px 25px;
                font-weight: 600;
                margin-right: 10px;
            }

            .nav-pills .nav-link.active {
                background: linear-gradient(135deg, #28a745, #20c997);
            }

            .table-responsive {
                border-radius: 12px;
                overflow: hidden;
                box-shadow: 0 4px 12px rgba(0,0,0,0.1);
            }

            .btn-action {
                padding: 5px 15px;
                border-radius: 20px;
                font-size: 0.85em;
                font-weight: 600;
                border: none;
                transition: all 0.3s ease;
            }

            .btn-confirm {
                background-color: #28a745;
                color: white;
            }

            .btn-confirm:hover {
                background-color: #218838;
                color: white;
            }

            .btn-reject {
                background-color: #dc3545;
                color: white;
            }

            .btn-reject:hover {
                background-color: #c82333;
                color: white;
            }

            .btn-done {
                background-color: #007bff;
                color: white;
            }

            .btn-done:hover {
                background-color: #0056b3;
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
                                <h2 class="mb-1">
                                    <i class="fas fa-clipboard-list me-2 text-primary"></i>
                                    Quản lý Báo cáo
                                </h2>
                                <p class="text-muted mb-0">Xem và xử lý các báo cáo từ người thuê</p>
                            </div>
                            <div class="text-end">
                                <small class="text-muted">
                                    <i class="fas fa-clock me-1"></i>
                                    <fmt:formatDate value="<%= new java.util.Date() %>" pattern="dd/MM/yyyy HH:mm"/>
                                </small>
                            </div>
                        </div>

                        <!-- Success/Error Messages -->
                        <c:if test="${not empty successMessage}">
                            <div class="alert alert-success alert-dismissible fade show" role="alert">
                                <i class="fas fa-check-circle me-2"></i>
                                ${successMessage}
                                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                            </div>
                        </c:if>

                        <c:if test="${not empty errorMessage}">
                            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                                <i class="fas fa-times-circle me-2"></i>
                                ${errorMessage}
                                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                            </div>
                        </c:if>

                        <!-- Navigation Tabs -->
                        <ul class="nav nav-pills mb-4">
                            <li class="nav-item">
                                <a class="nav-link ${activeTab == 'all' or empty activeTab ? 'active' : ''}" 
                                   href="manageReports">
                                    <i class="fas fa-list me-2"></i>
                                    Tất cả
                                </a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link ${activeTab == 'maintenance' ? 'active' : ''}" 
                                   href="manageReports?type=maintenance">
                                    <i class="fas fa-tools me-2"></i>
                                    Bảo trì thiết bị
                                </a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link ${activeTab == 'messages' ? 'active' : ''}" 
                                   href="manageReports?type=messages">
                                    <i class="fas fa-comments me-2"></i>
                                    Thông báo khác
                                </a>
                            </li>
                        </ul>

                        <!-- Maintenance Reports Tab -->
                        <c:if test="${activeTab == 'all' or activeTab == 'maintenance' or empty activeTab}">
                            <div class="card report-card mb-4">
                                <div class="card-header text-dark py-3" style="background-color: #f8f9fa;">
                                    <h5 class="mb-0 text-dark">
                                        <i class="fas fa-tools me-2"></i>
                                        Báo cáo Bảo trì Thiết bị
                                    </h5>
                                </div>
                                <div class="card-body">
                                    <c:choose>
                                        <c:when test="${not empty maintenanceLogs}">
                                            <div class="table-responsive">
                                                <table class="table table-hover">
                                                    <thead class="table-light">
                                                        <tr>
                                                            <th>STT</th>
                                                            <th>Phòng</th>
                                                            <th>Người báo cáo</th>
                                                            <th>Thiết bị</th>
                                                            <th>Mô tả sự cố</th>
                                                            <th>Thời gian</th>
                                                            <th>Trạng thái</th>
                                                            <th>Thao tác</th>
                                                        </tr>
                                                    </thead>
                                                    <tbody>
                                                        <c:forEach var="log" items="${maintenanceLogs}" varStatus="status">
                                                            <tr>
                                                                <td>${status.count}</td>
                                                                <td>
                                                                    <strong>Phòng ${log.roomName}</strong><br>
                                                                    <small class="text-muted">${log.rentalAreaName}</small>
                                                                </td>
                                                                <td>
                                                                    <strong>${log.createdByName}</strong><br>
                                                                    <small class="text-muted">ID: ${log.createdBy}</small>
                                                                </td>
                                                                <td>
                                                                    <c:choose>
                                                                        <c:when test="${not empty log.deviceInfo and log.deviceInfo != 'Không xác định'}">
                                                                            <span class="badge bg-info text-wrap" style="max-width: 150px;">${log.deviceInfo}</span>
                                                                        </c:when>
                                                                        <c:otherwise>
                                                                            <span class="text-muted"><i>Chưa xác định</i></span>
                                                                        </c:otherwise>
                                                                    </c:choose>
                                                                </td>
                                                                <td style="max-width: 250px;">
                                                                    <div class="description-cell">
                                                                        <c:choose>
                                                                            <c:when test="${log.description.length() > 80}">
                                                                                <span class="description-short">${log.description.substring(0, 80)}...</span>
                                                                                <span class="description-full" style="display: none;">${log.description}</span>
                                                                                <br><a href="#" class="text-primary small toggle-description">
                                                                                    <i class="fas fa-eye"></i> Xem thêm
                                                                                </a>
                                                                            </c:when>
                                                                            <c:otherwise>
                                                                                ${log.description}
                                                                            </c:otherwise>
                                                                        </c:choose>
                                                                    </div>
                                                                </td>
                                                                <td>
                                                                    <fmt:formatDate value="${log.createdAt}" pattern="dd/MM/yyyy HH:mm"/>
                                                                </td>
                                                                <td>
                                                                    <c:choose>
                                                                        <c:when test="${log.status == 'pending'}">
                                                                            <span class="status-badge status-pending">
                                                                                <i class="fas fa-clock"></i> Chờ xử lý
                                                                            </span>
                                                                        </c:when>
                                                                        <c:when test="${log.status == 'confirmed'}">
                                                                            <span class="status-badge status-confirmed">
                                                                                <i class="fas fa-check"></i> Đã xác nhận
                                                                            </span>
                                                                        </c:when>
                                                                        <c:when test="${log.status == 'completed'}">
                                                                            <span class="status-badge status-done">
                                                                                <i class="fas fa-check-double"></i> Đã hoàn thành
                                                                            </span>
                                                                        </c:when>
                                                                        <c:when test="${log.status == 'rejected'}">
                                                                            <span class="status-badge status-rejected">
                                                                                <i class="fas fa-times"></i> Từ chối
                                                                            </span>
                                                                        </c:when>
                                                                    </c:choose>
                                                                </td>
                                                                <td>
                                                                    <c:choose>
                                                                        <c:when test="${log.status == 'pending'}">
                                                                            <button class="btn btn-confirm btn-action me-1 mb-1" 
                                                                                    onclick="updateMaintenanceStatus(${log.maintenanceId}, 'confirmed')">
                                                                                <i class="fas fa-check"></i> Xác nhận
                                                                            </button>
                                                                            <button class="btn btn-reject btn-action mb-1" 
                                                                                    onclick="updateMaintenanceStatus(${log.maintenanceId}, 'rejected')">
                                                                                <i class="fas fa-times"></i> Từ chối
                                                                            </button>
                                                                        </c:when>
                                                                        <c:when test="${log.status == 'confirmed'}">
                                                                            <button class="btn btn-done btn-action" 
                                                                                    onclick="completeMaintenance(${log.maintenanceId}, '${log.deviceInfo}', '${log.roomName}', ' ', ${log.createdBy})">
                                                                                <i class="fas fa-wrench"></i> Đã sửa xong
                                                                            </button>
                                                                        </c:when>
                                                                        <c:otherwise>
                                                                            <span class="text-muted small">
                                                                                <i class="fas fa-check"></i> Đã xử lý
                                                                            </span>
                                                                        </c:otherwise>
                                                                    </c:choose>
                                                                </td>
                                                            </tr>
                                                        </c:forEach>
                                                    </tbody>
                                                </table>
                                            </div>
                                        </c:when>
                                        <c:otherwise>
                                            <div class="text-center py-5">
                                                <i class="fas fa-tools fa-3x text-muted mb-3"></i>
                                                <h5 class="text-muted">Chưa có báo cáo bảo trì nào</h5>
                                            </div>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                        </c:if>

                        <!-- Messages Tab -->
                        <c:if test="${activeTab == 'all' or activeTab == 'messages' or empty activeTab}">
                            <div class="card report-card">
                                <div class="card-header text-dark py-3" style="background-color: #f8f9fa;">
                                    <h5 class="mb-0 text-dark">
                                        <i class="fas fa-comments me-2"></i>
                                        Thông báo & Thắc mắc
                                    </h5>
                                </div>
                                <div class="card-body">
                                    <c:choose>
                                        <c:when test="${not empty messages}">
                                            <div class="table-responsive">
                                                <table class="table table-hover">
                                                    <thead class="table-light">
                                                        <tr>
                                                            <th>ID</th>
                                                            <th>Loại</th>
                                                            <th>Người gửi</th>
                                                            <th>Nội dung</th>
                                                            <th>Ngày gửi</th>
                                                        </tr>
                                                    </thead>
                                                    <tbody>
                                                        <c:forEach var="message" items="${messages}">
                                                            <tr>
                                                                <td>
                                                                    <div class="message-icon">
                                                                        <i class="fas fa-envelope"></i>
                                                                    </div>
                                                                    <strong class="ms-2">#${message.messageId}</strong>
                                                                </td>
                                                                <td>
                                                                    <c:choose>
                                                                        <c:when test="${message.type == 'bill'}">
                                                                            <span class="message-type-badge type-bill">
                                                                                <i class="fas fa-receipt me-1"></i>Hóa đơn
                                                                            </span>
                                                                        </c:when>
                                                                        <c:when test="${message.type == 'contract'}">
                                                                            <span class="message-type-badge type-contract">
                                                                                <i class="fas fa-file-contract me-1"></i>Hợp đồng
                                                                            </span>
                                                                        </c:when>
                                                                        <c:otherwise>
                                                                            <span class="message-type-badge type-general">
                                                                                <i class="fas fa-comment me-1"></i>Thông báo
                                                                            </span>
                                                                        </c:otherwise>
                                                                    </c:choose>
                                                                </td>
                                                                <td>
                                                                    <strong>${message.userName}</strong>
                                                                </td>
                                                                <td style="max-width: 300px;">
                                                                    <div class="message-content-cell">
                                                                        <c:choose>
                                                                            <c:when test="${message.content.length() > 100}">
                                                                                <span class="content-short">${message.content.substring(0, 100)}...</span>
                                                                                <span class="content-full" style="display: none;">${message.content}</span>
                                                                                <br><a href="#" class="text-primary small toggle-content">
                                                                                    <i class="fas fa-eye"></i> Xem chi tiết
                                                                                </a>
                                                                            </c:when>
                                                                            <c:otherwise>
                                                                                <p class="mb-0">${message.content}</p>
                                                                            </c:otherwise>
                                                                        </c:choose>
                                                                    </div>
                                                                </td>
                                                                <td>
                                                                    <fmt:formatDate value="${message.createdAt}" pattern="dd/MM/yyyy HH:mm"/>
                                                                </td>
                                                            </tr>
                                                        </c:forEach>
                                                    </tbody>
                                                </table>
                                            </div>
                                        </c:when>
                                        <c:otherwise>
                                            <div class="text-center py-5">
                                                <i class="fas fa-comments fa-3x text-muted mb-3"></i>
                                                <h5 class="text-muted">Chưa có thông báo nào</h5>
                                            </div>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>
                        </c:if>
                    </div>
                </div>
            </div>
        </div>

        <!-- Complete Maintenance Modal -->
        <div class="modal fade" id="completeMaintenanceModal" tabindex="-1">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title">
                            <i class="fas fa-wrench me-2"></i>
                            Hoàn thành sửa chữa
                        </h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <form action="manageReports" method="post">
                        <div class="modal-body">
                            <input type="hidden" name="action" value="completeMaintenance">
                            <input type="hidden" name="maintenanceId" id="completeMaintenanceId">
                            <input type="hidden" name="tenantId" id="completeTenantId">

                            <div class="alert alert-info">
                                <i class="fas fa-info-circle me-2"></i>
                                <strong>Thiết bị:</strong> <span id="completeDeviceInfo"></span><br>
                                <strong>Phòng:</strong> <span id="completeRoomName"></span><br>
                                <strong>Người báo cáo:</strong> <span id="completeTenantName"></span>
                            </div>

                            <div class="mb-3">
                                <label for="repairCost" class="form-label">
                                    <i class="fas fa-dollar-sign me-2"></i>
                                    Chi phí sửa chữa (₫) <span class="text-danger">*</span>
                                </label>
                                <input type="number" class="form-control" id="repairCost" name="repairCost" 
                                       min="0" step="1000" required placeholder="Nhập chi phí sửa chữa">
                            </div>

                            <div class="mb-3">
                                <label for="repairNote" class="form-label">
                                    <i class="fas fa-comment me-2"></i>
                                    Ghi chú sửa chữa
                                </label>
                                <textarea class="form-control" id="repairNote" name="repairNote" rows="3" 
                                          placeholder="Mô tả chi tiết công việc sửa chữa đã thực hiện..."></textarea>
                            </div>

                            <div class="alert alert-warning">
                                <i class="fas fa-exclamation-triangle me-2"></i>
                                <strong>Lưu ý:</strong> Sau khi xác nhận, hệ thống sẽ tự động tạo hóa đơn chi phí sửa chữa và gửi email thông báo đến người thuê.
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                            <button type="submit" class="btn btn-success">
                                <i class="fas fa-check me-2"></i>
                                Hoàn thành & Tạo hóa đơn
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <!-- Update Status Modal -->
        <div class="modal fade" id="updateStatusModal" tabindex="-1">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="statusModalTitle">Cập nhật trạng thái</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <form action="manageReports" method="post">
                        <div class="modal-body">
                            <input type="hidden" name="action" value="updateMaintenance">
                            <input type="hidden" name="maintenanceId" id="maintenanceId">
                            <input type="hidden" name="status" id="statusValue">

                            <div class="mb-3">
                                <label for="ownerNote" class="form-label">Ghi chú phản hồi:</label>
                                <textarea class="form-control" id="ownerNote" name="ownerNote" rows="3" 
                                          placeholder="Nhập ghi chú phản hồi (không bắt buộc)"></textarea>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                            <button type="submit" class="btn btn-primary">Cập nhật</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <!-- Scripts -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        <script>
                                                                                        function updateMaintenanceStatus(maintenanceId, status) {
                                                                                            document.getElementById('maintenanceId').value = maintenanceId;
                                                                                            document.getElementById('statusValue').value = status;

                                                                                            let title = '';
                                                                                            switch (status) {
                                                                                                case 'confirmed':
                                                                                                    title = 'Xác nhận báo cáo';
                                                                                                    break;
                                                                                                case 'rejected':
                                                                                                    title = 'Từ chối báo cáo';
                                                                                                    break;
                                                                                            }

                                                                                            document.getElementById('statusModalTitle').textContent = title;

                                                                                            const modal = new bootstrap.Modal(document.getElementById('updateStatusModal'));
                                                                                            modal.show();
                                                                                        }

                                                                                        function completeMaintenance(maintenanceId, deviceInfo, roomName, tenantName, tenantId) {
                                                                                            document.getElementById('completeMaintenanceId').value = maintenanceId;
                                                                                            document.getElementById('completeTenantId').value = tenantId;
                                                                                            document.getElementById('completeDeviceInfo').textContent = deviceInfo || 'Không xác định';
                                                                                            document.getElementById('completeRoomName').textContent = roomName;
                                                                                            document.getElementById('completeTenantName').textContent = tenantName;

                                                                                            const modal = new bootstrap.Modal(document.getElementById('completeMaintenanceModal'));
                                                                                            modal.show();
                                                                                        }

                                                                                        // Toggle description visibility
                                                                                        document.addEventListener('DOMContentLoaded', function () {
                                                                                            // Toggle for maintenance description
                                                                                            const toggleButtons = document.querySelectorAll('.toggle-description');
                                                                                            toggleButtons.forEach(button => {
                                                                                                button.addEventListener('click', function (e) {
                                                                                                    e.preventDefault();
                                                                                                    const cell = this.closest('.description-cell');
                                                                                                    const shortText = cell.querySelector('.description-short');
                                                                                                    const fullText = cell.querySelector('.description-full');

                                                                                                    if (fullText.style.display === 'none') {
                                                                                                        shortText.style.display = 'none';
                                                                                                        fullText.style.display = 'block';
                                                                                                        this.innerHTML = '<i class="fas fa-eye-slash"></i> Thu gọn';
                                                                                                    } else {
                                                                                                        shortText.style.display = 'block';
                                                                                                        fullText.style.display = 'none';
                                                                                                        this.innerHTML = '<i class="fas fa-eye"></i> Xem thêm';
                                                                                                    }
                                                                                                });
                                                                                            });

                                                                                            // Toggle for message content
                                                                                            const toggleContentButtons = document.querySelectorAll('.toggle-content');
                                                                                            toggleContentButtons.forEach(button => {
                                                                                                button.addEventListener('click', function (e) {
                                                                                                    e.preventDefault();
                                                                                                    const cell = this.closest('.message-content-cell');
                                                                                                    const shortText = cell.querySelector('.content-short');
                                                                                                    const fullText = cell.querySelector('.content-full');

                                                                                                    if (fullText.style.display === 'none') {
                                                                                                        shortText.style.display = 'none';
                                                                                                        fullText.style.display = 'block';
                                                                                                        this.innerHTML = '<i class="fas fa-eye-slash"></i> Thu gọn';
                                                                                                    } else {
                                                                                                        shortText.style.display = 'block';
                                                                                                        fullText.style.display = 'none';
                                                                                                        this.innerHTML = '<i class="fas fa-eye"></i> Xem chi tiết';
                                                                                                    }
                                                                                                });
                                                                                            });
                                                                                        });                                                                        // Auto-dismiss alerts after 5 seconds
                                                                                        setTimeout(function () {
                                                                                            const alerts = document.querySelectorAll('.alert');
                                                                                            alerts.forEach(function (alert) {
                                                                                                const bsAlert = new bootstrap.Alert(alert);
                                                                                                bsAlert.close();
                                                                                            });
                                                                                        }, 5000);
        </script>
    </body>
</html>
