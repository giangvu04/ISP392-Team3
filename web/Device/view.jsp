<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Xem chi tiết thiết bị</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
</head>
<body>
    <div class="container mt-4">
        <div class="row justify-content-center">
            <div class="col-md-8">
                <div class="card shadow">
                    <div class="card-header bg-info text-white">
                        <h4 class="mb-0">
                            <i class="fas fa-eye me-2"></i>
                            Xem chi tiết thiết bị
                        </h4>
                    </div>
                    <div class="card-body">
                        <!-- Hiển thị thông báo lỗi -->
                        <c:if test="${not empty errorMessage}">
                            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                                <i class="fas fa-exclamation-triangle me-2"></i>
                                ${errorMessage}
                                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                            </div>
                        </c:if>

                        <!-- Thông tin thiết bị -->
                        <div class="mb-3">
                            <label class="form-label">
                                <i class="fas fa-hashtag me-1"></i>
                                ID thiết bị
                            </label>
                            <input type="text" class="form-control" value="${device.deviceId}" readonly>
                        </div>

                        <div class="mb-3">
                            <label class="form-label">
                                <i class="fas fa-tag me-1"></i>
                                Tên thiết bị
                            </label>
                            <input type="text" class="form-control" value="${device.deviceName}" readonly>
                        </div>

                        <div class="d-flex justify-content-between">
                            <a href="${pageContext.request.contextPath}/listdevices?action=list" class="btn btn-secondary">
                                <i class="fas fa-arrow-left me-2"></i>
                                Quay lại danh sách
                            </a>
                            <div>
                                <a href="${pageContext.request.contextPath}/listdevices?action=edit&id=${device.deviceId}" class="btn btn-primary">
                                    <i class="fas fa-edit me-2"></i>
                                    Chỉnh sửa
                                </a>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Thông tin bổ sung -->
                <div class="card mt-3">
                    <div class="card-body">
                        <h6 class="card-title">
                            <i class="fas fa-info-circle me-2"></i>
                            Lưu ý
                        </h6>
                        <ul class="mb-0">
                            <li>Thông tin hiển thị ở đây chỉ mang tính chất tham khảo.</li>
                            <li>Để chỉnh sửa, vui lòng nhấp vào nút "Chỉnh sửa".</li>
                        </ul>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>

    <!-- Tự động ẩn alert sau 5 giây -->
    <script>
        setTimeout(function() {
            var alerts = document.querySelectorAll('.alert');
            alerts.forEach(function(alert) {
                var bsAlert = new bootstrap.Alert(alert);
                bsAlert.close();
            });
        }, 5000);
    </script>
</body>
</html>