<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chi tiết yêu cầu xem phòng - ISP Management</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="css/rooms.css" rel="stylesheet">
    <style>
        body {
            background-color: #f8f9fa;
        }
        .main-wrapper {
            display: flex;
            min-height: 100vh;
        }
        .content-area {
            flex: 1;
            padding: 20px;
        }
        .detail-container {
            background: white;
            border-radius: 10px;
            box-shadow: 0 0 20px rgba(0,0,0,0.1);
            padding: 30px;
            margin-bottom: 20px;
        }
        .section-title {
            color: #2c3e50;
            border-bottom: 3px solid #3498db;
            padding-bottom: 10px;
            margin-bottom: 20px;
        }
        .info-card {
            background: #f8f9fa;
            border-radius: 8px;
            padding: 20px;
            margin-bottom: 20px;
            border-left: 4px solid #3498db;
        }
        .status-badge {
            font-size: 14px;
            padding: 8px 16px;
            border-radius: 20px;
            font-weight: 500;
        }
        .status-pending {
            background-color: #fff3cd;
            color: #856404;
            border: 1px solid #ffeaa7;
        }
        .status-viewed {
            background-color: #d1ecf1;
            color: #0c5460;
            border: 1px solid #bee5eb;
        }
        .status-contacted {
            background-color: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }
        .status-rejected {
            background-color: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }
        .btn-back {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border: none;
            border-radius: 25px;
            padding: 10px 25px;
            color: white;
            font-weight: 500;
        }
        .btn-back:hover {
            transform: translateY(-1px);
            box-shadow: 0 5px 15px rgba(102, 126, 234, 0.4);
            color: white;
        }
        .timeline-item {
            border-left: 2px solid #3498db;
            padding-left: 20px;
            margin-bottom: 20px;
            position: relative;
        }
        .timeline-item::before {
            content: '';
            position: absolute;
            left: -6px;
            top: 0;
            width: 10px;
            height: 10px;
            border-radius: 50%;
            background-color: #3498db;
        }
        .admin-response {
            background: linear-gradient(135deg, #e3f2fd 0%, #f3e5f5 100%);
            border-radius: 10px;
            padding: 20px;
            margin-top: 15px;
            border-left: 4px solid #9c27b0;
        }
    </style>
</head>
<body>
    <div class="main-wrapper">
        <!-- Include Sidebar -->
        <jsp:include page="../Sidebar/SideBarTelnant.jsp" />

        <div class="content-area">
            <div class="container-fluid">
                <!-- Header -->
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <h1><i class="fas fa-eye me-2"></i>Chi tiết yêu cầu xem phòng</h1>
                    <a href="myViewingRequests" class="btn btn-back">
                        <i class="fas fa-arrow-left me-2"></i>Quay lại danh sách
                    </a>
                </div>
                
                <!-- Alert Messages -->
                <c:if test="${not empty sessionScope.error}">
                    <div class="alert alert-danger alert-dismissible fade show" role="alert">
                        <i class="fas fa-exclamation-circle me-2"></i>${sessionScope.error}
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                    <c:remove var="error" scope="session" />
                </c:if>
                
                <c:if test="${not empty sessionScope.success}">
                    <div class="alert alert-success alert-dismissible fade show" role="alert">
                        <i class="fas fa-check-circle me-2"></i>${sessionScope.success}
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                    <c:remove var="success" scope="session" />
                </c:if>

                <!-- Detail Container -->
                <div class="detail-container">
                    <div class="row">
                        <!-- Thông tin bài đăng -->
                        <div class="col-lg-8">
                            <h4 class="section-title"><i class="fas fa-home me-2"></i>Thông tin bài đăng</h4>
                            
                            <div class="info-card">
                                <h5><strong>${viewingRequest.postTitle}</strong></h5>
                                <div class="row mt-3">
                                    <div class="col-md-6">
                                        <p><i class="fas fa-bed me-2"></i><strong>Phòng:</strong> 
                                            <c:choose>
                                                <c:when test="${not empty viewingRequest.roomsInfo}">
                                                    ${viewingRequest.roomsInfo}
                                                </c:when>
                                                <c:otherwise>
                                                    Thông tin đang cập nhật
                                                </c:otherwise>
                                            </c:choose>
                                        </p>
                                        <p><i class="fas fa-building me-2"></i><strong>Khu trọ:</strong> ${viewingRequest.rentalAreaName}</p>
                                    </div>
                                    <div class="col-md-6">
                                        <p><i class="fas fa-map-marker-alt me-2"></i><strong>Địa chỉ:</strong> ${viewingRequest.rentalAreaAddress}</p>
                                        <p><i class="fas fa-calendar me-2"></i><strong>Ngày đăng yêu cầu:</strong> 
                                            <fmt:formatDate value="${viewingRequest.createdAt}" pattern="dd/MM/yyyy HH:mm"/>
                                        </p>
                                    </div>
                                </div>
                            </div>

                            <!-- Thông tin yêu cầu -->
                            <h4 class="section-title"><i class="fas fa-file-alt me-2"></i>Chi tiết yêu cầu</h4>
                            
                            <div class="info-card">
                                <div class="row">
                                    <div class="col-md-6">
                                        <p><i class="fas fa-user me-2"></i><strong>Họ tên:</strong> ${viewingRequest.fullName}</p>
                                        <p><i class="fas fa-phone me-2"></i><strong>Số điện thoại:</strong> ${viewingRequest.phone}</p>
                                        <p><i class="fas fa-envelope me-2"></i><strong>Email:</strong> ${viewingRequest.email}</p>
                                    </div>
                                    <div class="col-md-6">
                                        <p><i class="fas fa-clock me-2"></i><strong>Thời gian mong muốn:</strong> 
                                            <c:choose>
                                                <c:when test="${not empty viewingRequest.preferredDate}">
                                                    <fmt:formatDate value="${viewingRequest.preferredDate}" pattern="dd/MM/yyyy HH:mm"/>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="text-muted">Không chỉ định</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </p>
                                        <p><i class="fas fa-info-circle me-2"></i><strong>Trạng thái:</strong>
                                            <c:choose>
                                                <c:when test="${viewingRequest.status == 0}">
                                                    <span class="status-badge status-pending">Đang chờ</span>
                                                </c:when>
                                                <c:when test="${viewingRequest.status == 1}">
                                                    <span class="status-badge status-viewed">Đã xem</span>
                                                </c:when>
                                                <c:when test="${viewingRequest.status == 2}">
                                                    <span class="status-badge status-contacted">Đã liên hệ</span>
                                                </c:when>
                                                <c:when test="${viewingRequest.status == 3}">
                                                    <span class="status-badge status-rejected">Từ chối</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="status-badge">Không xác định</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </p>
                                    </div>
                                </div>
                                
                                <c:if test="${not empty viewingRequest.message}">
                                    <hr>
                                    <div>
                                        <p><i class="fas fa-comment me-2"></i><strong>Lời nhắn:</strong></p>
                                        <div class="p-3 bg-light rounded">
                                            ${viewingRequest.message}
                                        </div>
                                    </div>
                                </c:if>
                            </div>
                        </div>

                        <!-- Timeline và phản hồi -->
                        <div class="col-lg-4">
                            <h4 class="section-title"><i class="fas fa-history me-2"></i>Lịch sử xử lý</h4>
                            
                            <div class="timeline-item">
                                <h6><i class="fas fa-plus-circle me-1"></i>Gửi yêu cầu</h6>
                                <small class="text-muted">
                                    <fmt:formatDate value="${viewingRequest.createdAt}" pattern="dd/MM/yyyy HH:mm"/>
                                </small>
                                <p class="text-muted">Yêu cầu xem phòng đã được gửi đến chủ nhà</p>
                            </div>
                            
                            <c:if test="${viewingRequest.status > 0}">
                                <div class="timeline-item">
                                    <h6>
                                        <c:choose>
                                            <c:when test="${viewingRequest.status == 1}">
                                                <i class="fas fa-eye me-1"></i>Đã xem
                                            </c:when>
                                            <c:when test="${viewingRequest.status == 2}">
                                                <i class="fas fa-phone me-1"></i>Đã liên hệ
                                            </c:when>
                                            <c:when test="${viewingRequest.status == 3}">
                                                <i class="fas fa-times-circle me-1"></i>Từ chối
                                            </c:when>
                                        </c:choose>
                                    </h6>
                                    <c:if test="${not empty viewingRequest.responseDate}">
                                        <small class="text-muted">
                                            <fmt:formatDate value="${viewingRequest.responseDate}" pattern="dd/MM/yyyy HH:mm"/>
                                        </small>
                                    </c:if>
                                    <p class="text-muted">Chủ nhà đã cập nhật trạng thái yêu cầu</p>
                                </div>
                            </c:if>
                            
                            <!-- Phản hồi từ admin/chủ nhà -->
                            <c:if test="${not empty viewingRequest.adminNote}">
                                <div class="admin-response">
                                    <h6><i class="fas fa-reply me-2"></i>Phản hồi từ chủ nhà</h6>
                                    <c:if test="${not empty viewingRequest.responseDate}">
                                        <small class="text-muted d-block mb-2">
                                            <fmt:formatDate value="${viewingRequest.responseDate}" pattern="dd/MM/yyyy HH:mm"/>
                                        </small>
                                    </c:if>
                                    <div class="p-2 bg-white rounded">
                                        ${viewingRequest.adminNote}
                                    </div>
                                </div>
                            </c:if>
                            
                            <!-- Hướng dẫn tiếp theo -->
                            <div class="mt-4 p-3 bg-info bg-opacity-10 rounded">
                                <h6><i class="fas fa-info-circle me-2"></i>Hướng dẫn</h6>
                                <c:choose>
                                    <c:when test="${viewingRequest.status == 0}">
                                        <p class="mb-0 small">Yêu cầu của bạn đang được xử lý. Chủ nhà sẽ liên hệ trong thời gian sớm nhất.</p>
                                    </c:when>
                                    <c:when test="${viewingRequest.status == 1}">
                                        <p class="mb-0 small">Chủ nhà đã xem yêu cầu của bạn. Hãy chờ phản hồi hoặc liên hệ trực tiếp.</p>
                                    </c:when>
                                    <c:when test="${viewingRequest.status == 2}">
                                        <p class="mb-0 small">Tuyệt vời! Chủ nhà đã liên hệ với bạn. Hãy kiểm tra email/điện thoại.</p>
                                    </c:when>
                                    <c:when test="${viewingRequest.status == 3}">
                                        <p class="mb-0 small">Rất tiếc, yêu cầu không được chấp nhận. Bạn có thể tìm phòng khác phù hợp.</p>
                                    </c:when>
                                </c:choose>
                            </div>

                            <!-- Action buttons -->
                            <div class="mt-4">
                                <c:if test="${viewingRequest.status == 0}">
                                    <button class="btn btn-outline-danger btn-sm w-100 mb-2" onclick="cancelRequest(${viewingRequest.requestId})">
                                        <i class="fas fa-times me-1"></i>Hủy yêu cầu
                                    </button>
                                </c:if>
                                <a href="myViewingRequests" class="btn btn-outline-secondary btn-sm w-100">
                                    <i class="fas fa-list me-1"></i>Xem tất cả yêu cầu
                                </a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function cancelRequest(requestId) {
            if (confirm('Bạn có chắc chắn muốn hủy yêu cầu này?')) {
                // Implement cancel functionality
                window.location.href = 'cancelViewingRequest?id=' + requestId;
            }
        }
    </script>
</body>
</html>
