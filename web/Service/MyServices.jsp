<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dịch vụ của tôi</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link href="css/contracts.css" rel="stylesheet">
    <style>
        .service-card {
            transition: transform 0.2s, box-shadow 0.2s;
            border: none;
            border-radius: 15px;
            overflow: hidden;
        }
        .service-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 25px rgba(0,0,0,0.15);
        }
        .empty-state {
            padding: 4rem 2rem;
            text-align: center;
            background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
            border-radius: 20px;
            margin: 2rem 0;
        }
        .empty-icon {
            font-size: 4rem;
            color: #adb5bd;
            margin-bottom: 1rem;
        }
        .stats-card {
            background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
            color: white;
            border: none;
            border-radius: 15px;
            overflow: hidden;
        }
        .btn-gradient {
            background: linear-gradient(45deg, #667eea, #764ba2);
            border: none;
            color: white;
            border-radius: 25px;
            padding: 0.5rem 1.5rem;
            transition: all 0.3s ease;
        }
        .btn-gradient:hover {
            background: linear-gradient(45deg, #764ba2, #667eea);
            color: white;
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(0,0,0,0.2);
        }
        .info-label {
            font-size: 0.85rem;
            color: #6c757d;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        .info-value {
            font-size: 1.1rem;
            font-weight: 700;
            color: #495057;
            margin-top: 0.2rem;
        }
    </style>
</head>
<body class="bg-light">
<div class="container-fluid">
    <div class="row">
        <!-- Sidebar -->
        <c:if test="${user.roleId == 3}">
            <jsp:include page="../Sidebar/SideBarTelnant.jsp"/>
        </c:if>
        <c:if test="${user.roleId == 2}">
            <jsp:include page="../Sidebar/SideBarManager.jsp"/>
        </c:if>
        <!-- Main Content -->
        <main class="col-md-10 ms-sm-auto px-4 py-4">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <div>
                    <h2 class="mb-1"><i class="fas fa-concierge-bell me-2"></i>Dịch vụ đã chọn</h2>
                    <p class="text-muted mb-0">Xem và quản lý các dịch vụ bạn đang sử dụng</p>
                </div>
                <a class="btn btn-light btn-lg" href="TenantHomepage">
                    <i class="fas fa-home me-2"></i>Trang chủ
                </a>
            </div>
            <!-- Stats Section -->
            <div class="row mb-4">
                <div class="col-md-4">
                    <div class="stats-card p-4 text-center">
                        <small class="d-block">Tổng dịch vụ</small>
                        <h3 class="mb-0">${myServices.size()}</h3>
                    </div>
                </div>
            </div>
            <!-- Service List -->
            <div class="row">
                <c:choose>
                    <c:when test="${empty myServices}">
                        <div class="empty-state bg-white rounded-3 shadow-sm p-5 text-center mt-4">
                            <div class="empty-icon mb-3">
                                <i class="fas fa-concierge-bell fa-3x"></i>
                            </div>
                            <h3 class="text-muted mb-3">Bạn chưa đăng ký dịch vụ nào</h3>
                            <p class="text-muted">Hãy liên hệ quản lý để đăng ký sử dụng dịch vụ</p>
                        </div>
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="service" items="${myServices}">
                            <div class="col-lg-6 col-xl-4 mb-4">
                                <div class="card service-card h-100">
                                    <div class="card-header bg-primary text-white">
                                        <div class="d-flex align-items-center">
                                            <i class="fas fa-cogs fa-2x me-3"></i>
                                            <div>
                                                <h5 class="mb-0">${service.serviceName}</h5>
                                                <small>${service.unitName} - ${service.calculationMethod}</small>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="card-body">
                                        <div class="info-label">Giá dịch vụ</div>
                                        <div class="info-value mb-2">
                                            <fmt:formatNumber value="${service.unitPrice}" type="currency" currencySymbol="₫"/>
                                        </div>
                                        <div class="info-label">Khu trọ</div>
                                        <div class="info-value mb-2">${service.rentalAreaName}</div>
                                        <c:if test="${not empty service.description}">
                                            <div class="info-label">Mô tả</div>
                                            <div class="info-value mb-2">${service.description}</div>
                                        </c:if>
                                    </div>
                                    <div class="card-footer bg-light">
                                        <div class="d-flex justify-content-between align-items-center">
                                            <small class="text-muted">ID: ${service.serviceId}</small>
                                            <c:if test="${user.roleId == 2}">
                                                <a href="editService?id=${service.serviceId}" class="btn btn-gradient btn-sm">Chỉnh sửa</a>
                                            </c:if>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </div>
        </main>
    </div>
</div>
<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
