<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Xem chi tiết thiết bị</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
        <link href="css/homepage.css" rel="stylesheet"><style>
            
            .device-detail-new {
                background: #fff;
                border-radius: 2rem;
                box-shadow: 0 8px 32px rgba(120,80,200,0.10);
                padding: 2.5rem 2rem 2rem 2rem;
                margin: 3rem auto;
                max-width: 700px;
                width: 100%;
            }
            .device-detail-title {
                color: #7c3aed;
                font-weight: 800;
                font-size: 2.1rem;
                margin-bottom: 1.2rem;
                letter-spacing: -1px;
                text-align: center;
            }
            .device-detail-icon {
                font-size: 2.5rem;
                color: #7c3aed;
                margin-bottom: 0.5rem;
                text-align: center;
            }
            .device-info-row {
                display: grid;
                grid-template-columns: 1fr 1fr;
                align-items: center;
                background: #f3f0fa;
                border-radius: 1rem;
                padding: 1rem 1.2rem;
                margin-bottom: 1rem;
                font-size: 1.08rem;
                gap: 0.5rem;
            }
            .device-info-label {
                color: #7c3aed;
                font-weight: 600;
                display: flex;
                align-items: center;
                gap: 0.5rem;
                justify-content: flex-start;
            }
            .device-info-value {
                color: #222;
                font-weight: 500;
                text-align: left;
                word-break: break-word;
            }
            @media (max-width: 900px) {
                .device-detail-new { max-width: 98vw; }
            }
            @media (max-width: 600px) {
                .device-detail-new { padding: 1.2rem 0.5rem; }
                .device-detail-title { font-size: 1.3rem; }
                .device-info-row { font-size: 0.98rem; padding: 0.7rem 0.5rem; grid-template-columns: 1fr; }
                .device-info-label, .device-info-value { text-align: left; }
            }
            .device-detail-btns {
                display: flex;
                justify-content: center;
                gap: 1rem;
                margin-bottom: 1.5rem;
            }
            .alert-info {
                border-radius: 1rem;
                background: #e0e7ff;
                color: #3730a3;
                border: none;
                text-align: center;
                font-size: 1rem;
            }
            @media (max-width: 600px) {
                .device-detail-new { padding: 1.2rem 0.5rem; }
                .device-detail-title { font-size: 1.3rem; }
                .device-info-row { font-size: 0.98rem; padding: 0.7rem 0.5rem; }
            }
        </style>
    </head>
<body>
    <div class="container-fluid">
        <div class="row">
            
                <jsp:include page="../Sidebar/SideBarManager.jsp"/>
            
            <div class="col-md-9 col-lg-10 p-0">
                <div class="main-content d-flex align-items-center justify-content-center">
                    <div class="device-detail-new">
                        <div class="device-detail-icon"><i class="fas fa-eye"></i></div>
                        <div class="device-detail-title">Chi tiết thiết bị</div>
                        <div class="device-detail-btns">
                            <a href="${pageContext.request.contextPath}/listdevices?action=list" class="btn btn-light btn-lg">
                                <i class="fas fa-arrow-left me-2"></i>Quay lại danh sách
                            </a>
                            <a href="${pageContext.request.contextPath}/listdevices?action=edit&id=${device.deviceId}" class="btn btn-gradient btn-lg">
                                <i class="fas fa-edit me-2"></i>Chỉnh sửa
                            </a>
                        </div>
                        <c:if test="${not empty errorMessage}">
                            <div class="alert alert-danger alert-dismissible fade show" role="alert" style="border-radius:1rem;">
                                <i class="fas fa-exclamation-triangle me-2"></i>
                                ${errorMessage}
                                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                            </div>
                        </c:if>
                        <div class="device-info-row">
                            <span class="device-info-label"><i class="fas fa-hashtag"></i> ID thiết bị:</span>
                            <span class="device-info-value">${device.deviceId}</span>
                        </div>
                        <div class="device-info-row">
                            <span class="device-info-label"><i class="fas fa-tag"></i> Tên thiết bị:</span>
                            <span class="device-info-value">${device.deviceName}</span>
                        </div>
                        <div class="device-info-row">
                            <span class="device-info-label"><i class="fas fa-barcode"></i> Mã Máy:</span>
                            <span class="device-info-value">${device.deviceCode}</span>
                        </div>
                        <div class="device-info-row">
                            <span class="device-info-label"><i class="fas fa-calendar-plus"></i> Ngày nhập:</span>
                            <span class="device-info-value">${device.purchaseDate}</span>
                        </div>
                        <div class="device-info-row">
                            <span class="device-info-label"><i class="fas fa-shield-alt"></i> Bảo hành gần nhất:</span>
                            <span class="device-info-value">${device.latestWarrantyDate}</span>
                        </div>
                        <div class="device-info-row">
                            <span class="device-info-label"><i class="fas fa-calendar-times"></i> Ngày hết hạn bảo hành:</span>
                            <span class="device-info-value">${device.warrantyExpiryDate}</span>
                        </div>
                        <div class="alert alert-info mt-4 mb-0">
                            <i class="fas fa-info-circle me-2"></i>Thông tin chỉ mang tính chất tham khảo. Để chỉnh sửa, vui lòng nhấp vào nút <b>Chỉnh sửa</b>.
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        setTimeout(() => {
            document.querySelectorAll('.alert-dismissible').forEach(alert => {
                new bootstrap.Alert(alert).close();
            });
        }, 5000);
    </script>
</body>
</html>
