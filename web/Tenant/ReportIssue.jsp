<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Báo cáo sự cố - Hệ thống Quản lý Ký túc xá</title>
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
        
        .form-check-input:checked {
            background-color: #28a745;
            border-color: #28a745;
        }
        
        .issue-type-card {
            border: 2px solid #e9ecef;
            border-radius: 10px;
            padding: 20px;
            margin-bottom: 15px;
            cursor: pointer;
            transition: all 0.3s ease;
        }
        
        .issue-type-card:hover {
            border-color: #007bff;
            background-color: #f8f9fa;
        }
        
        .issue-type-card.selected {
            border-color: #28a745;
            background-color: #e8f5e8;
        }
        
        .device-select {
            display: none;
        }
        
        .device-select.show {
            display: block;
            animation: slideDown 0.3s ease;
        }
        
        @keyframes slideDown {
            from { opacity: 0; transform: translateY(-10px); }
            to { opacity: 1; transform: translateY(0); }
        }
        
        .alert-custom {
            border-radius: 10px;
            border: none;
            font-weight: 500;
        }
        
        .btn-submit {
            background: linear-gradient(135deg, #28a745, #20c997);
            border: none;
            border-radius: 8px;
            padding: 12px 30px;
            font-weight: 600;
            color: white;
            transition: all 0.3s ease;
        }
        
        .btn-submit:hover {
            background: linear-gradient(135deg, #218838, #1ea085);
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(40, 167, 69, 0.3);
        }
        
        .form-control, .form-select {
            border-radius: 8px;
            border: 2px solid #e9ecef;
            padding: 12px 15px;
            transition: all 0.3s ease;
        }
        
        .form-control:focus, .form-select:focus {
            border-color: #28a745;
            box-shadow: 0 0 0 0.2rem rgba(40, 167, 69, 0.25);
        }
    </style>
</head>
<body>
    <div class="container-fluid">
        <div class="row">
            <!-- Sidebar -->
            <jsp:include page="../Sidebar/SideBarTelnant.jsp"/>

            <!-- Main Content -->
            <div class="col-md-9 col-lg-10">
                <div class="main-content p-4">
                    <!-- Header -->
                    <div class="d-flex justify-content-between align-items-center mb-4">
                        <div>
                            <h2 class="mb-1">
                                <i class="fas fa-exclamation-triangle me-2 text-warning"></i>
                                Báo cáo sự cố
                            </h2>
                            <p class="text-muted mb-0">Báo cáo các vấn đề về thiết bị, hóa đơn, hợp đồng hoặc khác</p>
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
                        <div class="alert alert-success alert-dismissible fade show alert-custom" role="alert">
                            <i class="fas fa-check-circle me-2"></i>
                            ${successMessage}
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </div>
                    </c:if>
                    
                    <c:if test="${not empty errorMessage}">
                        <div class="alert alert-danger alert-dismissible fade show alert-custom" role="alert">
                            <i class="fas fa-times-circle me-2"></i>
                            ${errorMessage}
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </div>
                    </c:if>

                    <!-- Report Form -->
                    <div class="row justify-content-center">
                        <div class="col-lg-8">
                            <div class="card report-card">
                                <div class="card-header bg-gradient-primary text-white py-3">
                                    <h5 class="mb-0">
                                        <i class="fas fa-edit me-2"></i>
                                        Tạo báo cáo mới
                                    </h5>
                                </div>
                                <div class="card-body p-4">
                                    <form action="${pageContext.request.contextPath}/reportIssue" method="post">
                                        
                                        <!-- Issue Type Selection -->
                                        <div class="mb-4">
                                            <label class="form-label fw-bold mb-3">
                                                <i class="fas fa-list me-2"></i>
                                                Loại sự cố cần báo cáo:
                                            </label>
                                            
                                            <!-- Maintenance Issue -->
                                            <div class="issue-type-card" onclick="selectIssueType('maintenance')">
                                                <div class="form-check">
                                                    <input class="form-check-input" type="radio" name="issueType" id="maintenance" value="maintenance">
                                                    <label class="form-check-label ms-2" for="maintenance">
                                                        <div class="d-flex align-items-center">
                                                            <i class="fas fa-tools text-primary me-3 fa-lg"></i>
                                                            <div>
                                                                <strong>Bảo trì thiết bị</strong>
                                                                <p class="text-muted mb-0 small">Báo cáo sự cố thiết bị trong phòng cần sửa chữa</p>
                                                            </div>
                                                        </div>
                                                    </label>
                                                </div>
                                            </div>
                                            
                                            <!-- Bill Issue -->
                                            <div class="issue-type-card" onclick="selectIssueType('bill')">
                                                <div class="form-check">
                                                    <input class="form-check-input" type="radio" name="issueType" id="bill" value="bill">
                                                    <label class="form-check-label ms-2" for="bill">
                                                        <div class="d-flex align-items-center">
                                                            <i class="fas fa-receipt text-success me-3 fa-lg"></i>
                                                            <div>
                                                                <strong>Thắc mắc về hóa đơn</strong>
                                                                <p class="text-muted mb-0 small">Câu hỏi liên quan đến chi phí, thanh toán</p>
                                                            </div>
                                                        </div>
                                                    </label>
                                                </div>
                                            </div>
                                            
                                            <!-- Contract Issue -->
                                            <div class="issue-type-card" onclick="selectIssueType('contract')">
                                                <div class="form-check">
                                                    <input class="form-check-input" type="radio" name="issueType" id="contract" value="contract">
                                                    <label class="form-check-label ms-2" for="contract">
                                                        <div class="d-flex align-items-center">
                                                            <i class="fas fa-file-contract text-warning me-3 fa-lg"></i>
                                                            <div>
                                                                <strong>Thắc mắc về hợp đồng</strong>
                                                                <p class="text-muted mb-0 small">Câu hỏi về điều khoản, thời hạn hợp đồng</p>
                                                            </div>
                                                        </div>
                                                    </label>
                                                </div>
                                            </div>
                                            
                                            <!-- Other Issue -->
                                            <div class="issue-type-card" onclick="selectIssueType('general')">
                                                <div class="form-check">
                                                    <input class="form-check-input" type="radio" name="issueType" id="general" value="general">
                                                    <label class="form-check-label ms-2" for="general">
                                                        <div class="d-flex align-items-center">
                                                            <i class="fas fa-comment text-info me-3 fa-lg"></i>
                                                            <div>
                                                                <strong>Thông báo khác</strong>
                                                                <p class="text-muted mb-0 small">Các vấn đề khác cần thông báo</p>
                                                            </div>
                                                        </div>
                                                    </label>
                                                </div>
                                            </div>
                                        </div>

                                        <!-- Device Selection (only show for maintenance) -->
                                        <div id="deviceSelection" class="device-select mb-4">
                                            <label class="form-label fw-bold">
                                                <i class="fas fa-cog me-2"></i>
                                                Chọn thiết bị gặp sự cố:
                                            </label>
                                            <c:if test="${not empty currentRoom}">
                                                <div class="alert alert-info">
                                                    <i class="fas fa-home me-2"></i>
                                                    <strong>Phòng hiện tại:</strong> ${currentRoom.roomNumber}
                                                    <input type="hidden" name="roomId" value="${currentRoom.roomId}">
                                                </div>
                                                
                                                <c:choose>
                                                    <c:when test="${not empty devicesInRoom}">
                                                        <select class="form-select" name="deviceInfo" id="deviceInfo">
                                                            <option value="">-- Chọn thiết bị --</option>
                                                            <c:forEach var="device" items="${devicesInRoom}">
                                                                <option value="${device.deviceName} (SL: ${device.quantity})">
                                                                    ${device.deviceName} - Số lượng: ${device.quantity} - Trạng thái: ${device.status}
                                                                </option>
                                                            </c:forEach>
                                                        </select>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <div class="alert alert-warning">
                                                            <i class="fas fa-info-circle me-2"></i>
                                                            Không có thiết bị nào trong phòng của bạn.
                                                        </div>
                                                        <input type="text" class="form-control" name="deviceInfo" placeholder="Mô tả thiết bị gặp sự cố">
                                                    </c:otherwise>
                                                </c:choose>
                                            </c:if>
                                            <c:if test="${empty currentRoom}">
                                                <div class="alert alert-warning">
                                                    <i class="fas fa-exclamation-triangle me-2"></i>
                                                    Bạn chưa có phòng nào được gán. Vui lòng liên hệ quản lý.
                                                </div>
                                            </c:if>
                                        </div>

                                        <!-- Description -->
                                        <div class="mb-4">
                                            <label for="description" class="form-label fw-bold">
                                                <i class="fas fa-comment-dots me-2"></i>
                                                Mô tả chi tiết:
                                            </label>
                                            <textarea class="form-control" id="description" name="description" rows="5" 
                                                      placeholder="Mô tả chi tiết về sự cố, vấn đề cần báo cáo..." required></textarea>
                                            <div class="form-text">
                                                <i class="fas fa-lightbulb me-1"></i>
                                                Mô tả càng chi tiết sẽ giúp chúng tôi xử lý nhanh chóng hơn
                                            </div>
                                        </div>

                                        <!-- Submit Button -->
                                        <div class="text-center">
                                            <button type="submit" class="btn btn-submit btn-lg px-5">
                                                <i class="fas fa-paper-plane me-2"></i>
                                                Gửi báo cáo
                                            </button>
                                        </div>
                                    </form>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Info Cards -->
                    <div class="row mt-4">
                        <div class="col-md-4">
                            <div class="card border-0 shadow-sm">
                                <div class="card-body text-center">
                                    <i class="fas fa-clock fa-2x text-primary mb-3"></i>
                                    <h6>Thời gian xử lý</h6>
                                    <p class="text-muted small mb-0">Thông thường trong vòng 24-48h</p>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="card border-0 shadow-sm">
                                <div class="card-body text-center">
                                    <i class="fas fa-bell fa-2x text-success mb-3"></i>
                                    <h6>Thông báo</h6>
                                    <p class="text-muted small mb-0">Bạn sẽ nhận được cập nhật qua email</p>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="card border-0 shadow-sm">
                                <div class="card-body text-center">
                                    <i class="fas fa-headset fa-2x text-info mb-3"></i>
                                    <h6>Hỗ trợ</h6>
                                    <p class="text-muted small mb-0">Liên hệ hotline nếu cần hỗ trợ gấp</p>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Scripts -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function selectIssueType(type) {
            // Remove selected class from all cards
            document.querySelectorAll('.issue-type-card').forEach(card => {
                card.classList.remove('selected');
            });
            
            // Add selected class to clicked card
            event.currentTarget.classList.add('selected');
            
            // Check the radio button
            document.getElementById(type).checked = true;
            
            // Show/hide device selection
            const deviceSelection = document.getElementById('deviceSelection');
            if (type === 'maintenance') {
                deviceSelection.classList.add('show');
                // Make device selection required for maintenance
                const deviceInfo = document.getElementById('deviceInfo');
                if (deviceInfo) {
                    deviceInfo.setAttribute('required', 'required');
                }
            } else {
                deviceSelection.classList.remove('show');
                // Remove required attribute for non-maintenance
                const deviceInfo = document.getElementById('deviceInfo');
                if (deviceInfo) {
                    deviceInfo.removeAttribute('required');
                }
            }
        }
        
        // Auto-dismiss alerts after 5 seconds
        setTimeout(function() {
            const alerts = document.querySelectorAll('.alert');
            alerts.forEach(function(alert) {
                const bsAlert = new bootstrap.Alert(alert);
                bsAlert.close();
            });
        }, 5000);
    </script>
</body>
</html>
