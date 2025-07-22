<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Chi tiết Hợp đồng #${contract.contractId} - Manager Dashboard</title>
        <base href="${pageContext.request.contextPath}/">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
        <link href="css/rooms.css" rel="stylesheet">
    </head>
    <body>
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
                <div class="col-md-9 col-lg-10">
                    <div class="main-content p-4">
                        <!-- Header -->
                        <div class="d-flex justify-content-between align-items-center mb-4">
                            <div>
                                <h2 class="mb-1">Chi tiết Hợp đồng #${contract.contractId}</h2>
                                <p class="text-muted mb-0">Thông tin chi tiết về hợp đồng</p>
                            </div>
                            <div>
                                <c:if test="${user.roleId == 2}">
                                    <a href="updatecontract?id=${contract.contractId}" class="btn btn-warning me-2">
                                        <i class="fas fa-edit me-2"></i>
                                        Chỉnh sửa
                                    </a>

                                    <a href="listcontracts" class="btn btn-outline-secondary">
                                        <i class="fas fa-arrow-left me-2"></i>
                                        Quay lại
                                    </a>
                                </c:if>
                                <c:if test="${user.roleId == 3}">
                                   
                                    <a href="mycontract" class="btn btn-outline-secondary">
                                        <i class="fas fa-arrow-left me-2"></i>
                                        Quay lại
                                    </a>
                                </c:if>
                            </div>
                        </div>

                        <!-- Error Message -->
                        <c:if test="${not empty error}">
                            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                                <i class="fas fa-exclamation-triangle me-2"></i>
                                ${error}
                                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                            </div>
                        </c:if>

                        <!-- Contract Details -->
                        <div class="card mb-4">
                            <div class="card-header bg-primary text-white">
                                <h5 class="mb-0">
                                    <i class="fas fa-info-circle me-2"></i>
                                    Thông tin hợp đồng
                                </h5>
                            </div>
                            <div class="card-body">
                                <c:if test="${not empty contract}">
                                    <div class="row">
                                        <div class="col-md-6">
                                            <h6 class="text-muted">Số phòng</h6>
                                            <p class="fw-bold">${contract.roomNumber}</p>
                                        </div>
                                        <div class="col-md-6">
                                            <h6 class="text-muted">Tên khu vực</h6>
                                            <p class="fw-bold">${contract.areaName}</p>
                                        </div>
                                        <div class="col-md-6">
                                            <h6 class="text-muted">Mã hợp đồng</h6>
                                            <p class="fw-bold">${contract.contractId}</p>
                                        </div>
                                        <div class="col-md-6">
                                            <h6 class="text-muted">Mã phòng</h6>
                                            <p>${contract.roomId}</p>
                                        </div>
                                        <div class="col-md-6">
                                            <h6 class="text-muted">Mã người thuê</h6>
                                            <p>${contract.tenantId}</p>
                                        </div>
                                        <div class="col-md-12">
                                            <h6 class="text-muted">Danh sách người thuê trong phòng</h6>
                                            <ul>
                                                <c:forEach var="tenant" items="${tenants}">
                                                    <li>${tenant.fullName} (${tenant.email})</li>
                                                    </c:forEach>
                                            </ul>
                                        </div>
                                        <div class="col-md-6">
                                            <h6 class="text-muted">Ngày bắt đầu</h6>
                                            <p>
                                                <fmt:formatDate value="${contract.startDate}" pattern="dd/MM/yyyy"/>
                                            </p>
                                        </div>
                                        <div class="col-md-6">
                                            <h6 class="text-muted">Ngày kết thúc</h6>
                                            <p>
                                                <c:if test="${not empty contract.endDate}">
                                                    <fmt:formatDate value="${contract.endDate}" pattern="dd/MM/yyyy"/>
                                                </c:if>
                                                <c:if test="${empty contract.endDate}">
                                                    <span class="text-muted">-</span>
                                                </c:if>
                                            </p>
                                        </div>
                                        <div class="col-md-6">
                                            <h6 class="text-muted">Giá thuê (VNĐ/tháng)</h6>
                                            <p class="fw-bold text-primary">
                                                <fmt:formatNumber value="${contract.rentPrice}" type="number" minFractionDigits="2" maxFractionDigits="2"/>
                                            </p>
                                        </div>
                                        <div class="col-md-6">
                                            <h6 class="text-muted">Tiền cọc (VNĐ)</h6>
                                            <p class="fw-bold text-primary">
                                                <fmt:formatNumber value="${contract.depositAmount}" type="number" minFractionDigits="2" maxFractionDigits="2"/>
                                            </p>
                                        </div>
                                        <div class="col-md-6">
                                            <h6 class="text-muted">Trạng thái</h6>
                                            <c:choose>
                                                <c:when test="${contract.status == 0}">
                                                    <span class="badge status-available">
                                                        <i class="fas fa-check-circle me-1"></i>
                                                        Chưa kích hoạt
                                                    </span>
                                                </c:when>
                                                <c:when test="${contract.status == 1}">
                                                    <span class="badge status-occupied">
                                                        <i class="fas fa-user me-1"></i>
                                                        Đang hoạt động
                                                    </span>
                                                </c:when>
                                                <c:when test="${contract.status == 2}">
                                                    <span class="badge status-maintenance">
                                                        <i class="fas fa-times-circle me-1"></i>
                                                        Đã kết thúc
                                                    </span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge bg-secondary">${contract.status}</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                        <div class="col-md-12">
                                            <h6 class="text-muted">Ghi chú</h6>
                                            <p>
                                                <c:if test="${not empty contract.note}">
                                                    ${contract.note}
                                                </c:if>
                                                <c:if test="${empty contract.note}">
                                                    <span class="text-muted">Không có ghi chú</span>
                                                </c:if>
                                            </p>
                                        </div>
                                    </div>
                                </c:if>
                                <c:if test="${empty contract}">
                                    <div class="text-center py-5">
                                        <i class="fas fa-file-contract fa-3x text-muted mb-3"></i>
                                        <h5 class="text-muted">Không tìm thấy hợp đồng</h5>
                                        <p class="text-muted">Hợp đồng không tồn tại hoặc đã bị xóa.</p>
                                    </div>
                                </c:if>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        <script>
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