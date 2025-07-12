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
            <h3 class="text-info mb-4">
                <i class="fas fa-eye me-2"></i>Xem chi tiết thiết bị
            </h3>

            <c:if test="${not empty errorMessage}">
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                    <i class="fas fa-exclamation-triangle me-2"></i>
                    ${errorMessage}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>

            <div class="mb-3 row">
                <label class="col-sm-2 col-form-label">
                    <i class="fas fa-hashtag me-1"></i>ID thiết bị:
                </label>
                <div class="col-sm-10">
                    <input type="text" readonly class="form-control-plaintext" value="${device.deviceId}">
                </div>
            </div>

            <div class="mb-3 row">
                <label class="col-sm-2 col-form-label">
                    <i class="fas fa-tag me-1"></i>Tên thiết bị:
                </label>
                <div class="col-sm-10">
                    <input type="text" readonly class="form-control-plaintext" value="${device.deviceName}">
                </div>
            </div>
            <div class="mb-3 row">
                <label class="col-sm-2 col-form-label">
                    <i class="fas fa-tag me-1"></i>Mã Máy:
                </label>
                <div class="col-sm-10">
                    <input type="text" readonly class="form-control-plaintext" value="${device.deviceCode}">
                </div>
            </div>
            <div class="mb-3 row">
                <label class="col-sm-2 col-form-label">
                    <i class="fas fa-tag me-1"></i>Ngày nhập:
                </label>
                <div class="col-sm-10">
                    <input type="text" readonly class="form-control-plaintext" value="${device.purchaseDate}">
                </div>
            </div><div class="mb-3 row">
                <label class="col-sm-2 col-form-label">
                    <i class="fas fa-tag me-1"></i>Bảo hành gần nhất:
                </label>
                <div class="col-sm-10">
                    <input type="text" readonly class="form-control-plaintext" value="${device.latestWarrantyDate}">
                </div>
            </div>

            <div class="mb-3 row">
                <label class="col-sm-2 col-form-label">
                    <i class="fas fa-tag me-1"></i>Ngày hết hạn bảo hành:
                </label>
                <div class="col-sm-10">
                    <input type="text" readonly class="form-control-plaintext" value="${device.warrantyExpiryDate}">
                </div>
            </div>


            <div class="d-flex justify-content-between mt-4">
                <a href="${pageContext.request.contextPath}/listdevices?action=list" class="btn btn-outline-secondary">
                    <i class="fas fa-arrow-left me-2"></i>Quay lại danh sách
                </a>
                <a href="${pageContext.request.contextPath}/listdevices?action=edit&id=${device.deviceId}" class="btn btn-outline-primary">
                    <i class="fas fa-edit me-2"></i>Chỉnh sửa
                </a>
            </div>

            <div class="mt-4">
                <h6><i class="fas fa-info-circle me-2"></i>Lưu ý</h6>
                <ul>
                    <li>Thông tin chỉ mang tính chất tham khảo.</li>
                    <li>Để chỉnh sửa, vui lòng nhấp vào nút "Chỉnh sửa".</li>
                </ul>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
        <script>
            setTimeout(() => {
                document.querySelectorAll('.alert').forEach(alert => {
                    new bootstrap.Alert(alert).close();
                });
            }, 5000);
        </script>
    </body>
</html>
