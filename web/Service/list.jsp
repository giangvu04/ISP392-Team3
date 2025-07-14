
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý Dịch vụ - Hệ thống Quản lý Ký túc xá</title>
    <base href="${pageContext.request.contextPath}/">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <link rel="stylesheet" href="css/homepage.css"/>
    <style>
        body{
            overflow-y: hidden;
        }
        /* Sidebar styles */
        .sidebar { 
            min-height: 100vh; 
            background: linear-gradient(180deg, #667eea 0%, #764ba2 100%);
            color: white;
            position: fixed;
            width: 250px;
        }
        .sidebar .nav-link {
            color: rgba(255,255,255,0.8);
            border-radius: 8px;
            margin: 5px 10px;
            padding: 10px 15px;
        }
        .sidebar .nav-link:hover, .sidebar .nav-link.active {
            background: rgba(255,255,255,0.1);
            color: white;
        }

        /* Main content styles */
        .main-content { margin-left: 250px; padding: 20px; }
        
        /* Card styles */
        .stat-card {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border: none;
            border-radius: 12px;
            transition: transform 0.2s;
        }
        .stat-card:hover { transform: translateY(-5px); }
        
        /* Button gradient styles */
        .btn-gradient {
            background: linear-gradient(45deg, #43e97b, #38f9d7);
            border: none;
            color: white;
            border-radius: 8px;
        }
        .btn-gradient:hover {
            background: linear-gradient(45deg, #38f9d7, #43e97b);
            color: white;
        }
        
        /* Table styles */
        .table-responsive {
            border-radius: 10px;
            overflow: hidden;
            box-shadow: 0 0 20px rgba(0,0,0,0.1);
        }
        .table thead { background: #343a40; color: white; }
        
        /* Pagination styles */
        .pagination .page-link {
            border: none;
            margin: 0 2px;
            border-radius: 8px;
        }
        .pagination .page-item.active .page-link {
            background: linear-gradient(45deg, #43e97b, #38f9d7);
            border: none;
        }
        
        /* Modal styles */
        .modal-header {
            background: linear-gradient(45deg, #43e97b, #38f9d7);
            color: white;
            border-radius: 10px 10px 0 0;
        }
        .error-message {
            color: red;
            font-size: 0.9em;
            display: none;
        }
    </style>
</head>
<body>
    <div class="container-fluid">
        <div class="row">

                <jsp:include page="../Sidebar/SideBarManager.jsp"/>

            <!-- Main Content -->
            <div class="col-md-9 col-lg-10 main-content">
                <!-- Header -->
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <div>
                        <h2 class="mb-1">Quản lý Dịch vụ</h2>
                        <p class="text-muted mb-0">Chào mừng trở lại, ${user.fullName}!</p>
                    </div>
                    <div class="text-end">
                        <small class="text-muted">Hôm nay: <span id="current-date"></span></small>
                    </div>
                </div>

                <!-- Statistics Cards -->
                <div class="row mb-4">
                    <div class="col-md-3 mb-3">
                        <div class="card stat-card">
                            <div class="card-body">
                                <div class="d-flex justify-content-between">
                                    <div>
                                        <h6 class="card-title">Tổng số dịch vụ</h6>
                                        <h3 class="mb-0">${totalServices}</h3>
                                    </div>
                                    <div class="align-self-center">
                                        <i class="fas fa-concierge-bell fa-2x"></i>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-3 mb-3">
                        <div class="card stat-card">
                            <div class="card-body">
                                <div class="d-flex justify-content-between">
                                    <div>
                                        <h6 class="card-title">Khu vực hoạt động</h6>
                                        <c:set var="areaCount" value="0"/>
                                        <c:forEach var="area" items="${retalArea}">
                                            <c:set var="areaCount" value="${areaCount + 1}"/>
                                        </c:forEach>
                                        <h3 class="mb-0">${areaCount}</h3>
                                    </div>
                                    <div class="align-self-center">
                                        <i class="fas fa-map-marker-alt fa-2x"></i>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-3 mb-3">
                        <div class="card stat-card">
                            <div class="card-body">
                                <div class="d-flex justify-content-between">
                                    <div>
                                        <h6 class="card-title">Doanh thu dịch vụ</h6>
                                        <h3 class="mb-0">45.2M VNĐ</h3>
                                    </div>
                                    <div class="align-self-center">
                                        <i class="fas fa-money-bill-wave fa-2x"></i>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-3 mb-3">
                        <div class="card stat-card">
                            <div class="card-body">
                                <div class="d-flex justify-content-between">
                                    <div>
                                        <h6 class="card-title">Dịch vụ mới</h6>
                                        <h3 class="mb-0">3</h3>
                                    </div>
                                    <div class="align-self-center">
                                        <i class="fas fa-plus-circle fa-2x"></i>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Search and Table -->
                <div class="card">
                    <div class="card-header d-flex justify-content-between align-items-center">
                        <h5 class="mb-0">
                            <i class="fas fa-list me-2 text-success"></i>
                            <c:choose>
                                <c:when test="${searchMode}">Kết quả tìm kiếm</c:when>
                                <c:otherwise>Danh sách dịch vụ</c:otherwise>
                            </c:choose>
                        </h5>
                        <div>
                            <form method="GET" action="listservices" class="d-inline-block">
                                <input type="hidden" name="action" value="search">
                                <div class="input-group">
                                    <input type="text" name="keyword" class="form-control" placeholder="Nhập tên dịch vụ..." value="${keyword}">
                                    <button class="btn btn-gradient" type="submit"><i class="fas fa-search me-1"></i></button>
                                    <c:if test="${searchMode}">
                                        <a href="listservices" class="btn btn-outline-secondary ms-2"><i class="fas fa-times"></i></a>
                                    </c:if>
                                </div>
                            </form>
                            <button class="btn btn-gradient ms-2" data-bs-toggle="modal" data-bs-target="#addServiceModal">
                                <i class="fas fa-plus me-1"></i> Thêm mới
                            </button>
                        </div>
                    </div>
                    <div class="card-body p-0">
                        <c:if test="${not empty sessionScope.successMessage}">
                            <div class="alert alert-success alert-dismissible fade show" role="alert">
                                <i class="fas fa-check-circle me-2"></i>
                                ${sessionScope.successMessage}
                                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                            </div>
                            <c:remove var="successMessage" scope="session"/>
                        </c:if>
                        <c:if test="${not empty sessionScope.errorMessage}">
                            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                                <i class="fas fa-exclamation-triangle me-2"></i>
                                ${sessionScope.errorMessage}
                                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                            </div>
                            <c:remove var="errorMessage" scope="session"/>
                        </c:if>

                        <c:choose>
                            <c:when test="${empty services}">
                                <div class="text-center py-5">
                                    <i class="fas fa-inbox fa-3x text-muted mb-3"></i>
                                    <h5 class="text-muted">Không có dịch vụ nào</h5>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="table-responsive">
                                    <table class="table table-striped mb-0">
                                        <thead>
                                            <tr>
                                                <th>#</th>
                                                <th>Tên dịch vụ</th>
                                                <th>Khu thuê</th>
                                                <th>Giá</th>
                                                <th>Đơn vị</th>
                                                <th>Phương thức</th>
                                                <th class="text-center">Thao tác</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach var="s" items="${services}" varStatus="status">
                                                <tr>
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${searchMode}">
                                                                ${status.index + 1}
                                                            </c:when>
                                                            <c:otherwise>
                                                                ${(currentPage - 1) * servicesPerPage + status.index + 1}
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                    <td>${s.serviceName}</td>
                                                    <td>${s.rentalAreaId}</td>
                                                    <td><fmt:formatNumber value="${s.unitPrice}" type="currency" currencySymbol=""/></td>
                                                    <td>${s.unitName}</td>
                                                    <td><c:out value="${s.calculationMethod == 1 ? 'Theo đơn giá' : 'Tính theo mới'}"/></td>
                                                    <td class="text-center">
                                                        <button class="btn btn-sm btn-outline-info view-service-btn" 
                                                                data-bs-toggle="modal" 
                                                                data-bs-target="#viewServiceModal"
                                                                data-service-id="${s.serviceId}"
                                                                data-service-name="${s.serviceName}"
                                                                data-rental-area="${s.rentalAreaId}"
                                                                data-unit-price="${s.unitPrice}"
                                                                data-unit-name="${s.unitName}"
                                                                data-calc-method="${s.calculationMethod == 1 ? 'Theo đơn giá' : 'Tính theo mới'}">
                                                            <i class="fas fa-eye"></i>
                                                        </button>
                                                        <button class="btn btn-sm btn-outline-warning edit-service-btn" 
                                                                data-bs-toggle="modal" 
                                                                data-bs-target="#editServiceModal"
                                                                data-service-id="${s.serviceId}"
                                                                data-service-name="${s.serviceName}"
                                                                data-rental-area="${s.rentalAreaId}"
                                                                data-unit-price="${s.unitPrice}"
                                                                data-unit-name="${s.unitName}"
                                                                data-calc-method="${s.calculationMethod}">
                                                            <i class="fas fa-edit"></i>
                                                        </button>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>

                <!-- Pagination -->
                <c:if test="${not searchMode and totalPages > 1}">
                    <div class="d-flex justify-content-center mt-4">
                        <ul class="pagination">
                            <c:forEach begin="1" end="${totalPages}" var="p">
                                <li class="page-item ${p == currentPage ? 'active' : ''}">
                                    <a class="page-link" href="listservices?page=${p}">${p}</a>
                                </li>
                            </c:forEach>
                        </ul>
                    </div>
                </c:if>

                <c:if test="${not searchMode and not empty services}">
                    <div class="text-center mt-3">
                        <small class="text-muted">
                            Hiển thị ${(currentPage - 1) * servicesPerPage + 1} - 
                            ${(currentPage - 1) * servicesPerPage + services.size()} 
                            trong tổng số ${totalServices} dịch vụ
                        </small>
                    </div>
                </c:if>
            </div>
        </div>
    </div>

    <!-- Add Service Modal -->
    <div class="modal fade" id="addServiceModal" tabindex="-1" aria-labelledby="addServiceModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="addServiceModalLabel">
                        <i class="fas fa-plus me-2"></i>Thêm dịch vụ mới
                    </h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <form id="addServiceForm" action="listservices" method="POST">
                    <input type="hidden" name="action" value="add">
                    <div class="modal-body">
                        <div id="addServiceError" class="alert alert-danger d-none"></div>
                        <div class="mb-3">
                            <label for="addServiceName" class="form-label fw-bold">Tên dịch vụ:</label>
                            <input type="text" class="form-control" id="addServiceName" name="serviceName" required>
                            <div id="addServiceNameError" class="error-message"></div>
                        </div>
                        <div class="mb-3">
                            <label for="addRentalArea" class="form-label fw-bold">Khu thuê:</label>
                            <select class="form-select" id="addRentalArea" name="addRentalArea" required>
                                <option value="" disabled selected>Chọn khu vực</option>
                                <c:forEach var="retalArea" items="${retalArea}">
                                    <option value="${retalArea.rentalAreaId}">Khu ${retalArea.name}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="mb-3">
                            <label for="addUnitPrice" class="form-label fw-bold">Giá:</label>
                            <input type="number" step="0.01" class="form-control" id="addUnitPrice" name="unitPrice" required>
                            <div id="addUnitPriceError" class="error-message"></div>
                        </div>
                        <div class="mb-3">
                            <label for="addUnitName" class="form-label fw-bold">Đơn vị:</label>
                            <input type="text" class="form-control" id="addUnitName" name="unitName" required>
                            <div id="addUnitNameError" class="error-message"></div>
                        </div>
                        <div class="mb-3">
                            <label for="addCalcMethod" class="form-label fw-bold">Phương thức tính:</label>
                            <select class="form-select" id="addCalcMethod" name="calculationMethod" required>
                                <option value="" disabled selected>Chọn phương thức</option>
                                <option value="1">Theo đơn giá</option>
                                <option value="2">Tính theo mới</option>
                            </select>
                            <div id="addCalcMethodError" class="error-message"></div>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                        <button type="submit" class="btn btn-gradient">Thêm dịch vụ</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- View Service Modal -->
    <div class="modal fade" id="viewServiceModal" tabindex="-1" aria-labelledby="viewServiceModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="viewServiceModalLabel">
                        <i class="fas fa-info-circle me-2"></i>Chi tiết dịch vụ
                    </h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <div class="mb-3">
                        <label class="form-label fw-bold">Mã dịch vụ:</label>
                        <span id="viewServiceId"></span>
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-bold">Tên dịch vụ:</label>
                        <span id="viewServiceName"></span>
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-bold">Khu thuê:</label>
                        <span id="viewRentalArea"></span>
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-bold">Giá:</label>
                        <span id="viewUnitPrice"></span>
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-bold">Đơn vị:</label>
                        <span id="viewUnitName"></span>
                    </div>
                    <div class="mb-3">
                        <label class="form-label fw-bold">Phương thức tính:</label>
                        <span id="viewCalcMethod"></span>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
                </div>
            </div>
        </div>
    </div>

    <!-- Edit Service Modal -->
    <div class="modal fade" id="editServiceModal" tabindex="-1" aria-labelledby="editServiceModalLabel" aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="editServiceModalLabel">
                        <i class="fas fa-edit me-2"></i>Sửa dịch vụ
                    </h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <form id="editServiceForm" action="listservices" method="POST">
                    <input type="hidden" name="action" value="update">
                    <input type="hidden" name="serviceId" id="editServiceId">
                    <div class="modal-body">
                        <div id="editServiceError" class="alert alert-danger d-none"></div>
                        <div class="mb-3">
                            <label for="editServiceName" class="form-label fw-bold">Tên dịch vụ:</label>
                            <input type="text" class="form-control" id="editServiceName" name="serviceName" required>
                            <div id="editServiceNameError" class="error-message"></div>
                        </div>
                        <div class="mb-3">
                            <label for="editRentalArea" class="form-label fw-bold">Khu thuê:</label>
                            <select class="form-select" id="editRentalArea" name="rentalAreaId" required>
                                <option value="" disabled>Chọn khu vực</option>
                                <c:forEach var="retalArea" items="${retalArea}">
                                    <option value="${retalArea.rentalAreaId}">Khu ${retalArea.name}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="mb-3">
                            <label for="editUnitPrice" class="form-label fw-bold">Giá:</label>
                            <input type="number" step="0.01" class="form-control" id="editUnitPrice" name="unitPrice" required>
                            <div id="editUnitPriceError" class="error-message"></div>
                        </div>
                        <div class="mb-3">
                            <label for="editUnitName" class="form-label fw-bold">Đơn vị:</label>
                            <input type="text" class="form-control" id="editUnitName" name="unitName" required>
                            <div id="editUnitNameError" class="error-message"></div>
                        </div>
                        <div class="mb-3">
                            <label for="editCalcMethod" class="form-label fw-bold">Phương thức tính:</label>
                            <select class="form-select" id="editCalcMethod" name="calculationMethod" required>
                                <option value="" disabled>Chọn phương thức</option>
                                <option value="1">Theo đơn giá</option>
                                <option value="2">Tính theo mới</option>
                            </select>
                            <div id="editCalcMethodError" class="error-message"></div>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                        <button type="submit" class="btn btn-gradient">Lưu thay đổi</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <script>
        $(document).ready(function() {
            // Set current date
            $('#current-date').text(new Date().toLocaleDateString('vi-VN'));

            // Auto-show View Modal if service data is available
            <c:if test="${not empty service and showViewModal}">
                $('#viewServiceId').text('${service.serviceId}');
                $('#viewServiceName').text('${service.serviceName}');
                $('#viewRentalArea').text('${service.rentalAreaId}');
                $('#viewUnitPrice').text(parseFloat('${service.unitPrice}').toLocaleString('vi-VN'));
                $('#viewUnitName').text('${service.unitName}');
                $('#viewCalcMethod').text('${service.calculationMethod == 1 ? "Theo đơn giá" : "Tính theo mới"}');
                $('#viewServiceModal').modal('show');
            </c:if>

            // Auto-show Edit Modal if service data is available
            <c:if test="${not empty service and not showViewModal}">
                $('#editServiceId').val('${service.serviceId}');
                $('#editServiceName').val('${service.serviceName}');
                $('#editRentalArea').val('${service.rentalAreaId}');
                $('#editUnitPrice').val('${service.unitPrice}');
                $('#editUnitName').val('${service.unitName}');
                $('#editCalcMethod').val('${service.calculationMethod}');
                $('#editServiceModal').modal('show');
            </c:if>

            // Client-side Validation for Add Form
            $('#addServiceForm').submit(function(event) {
                let isValid = true;
                $('.error-message').text('').hide();

                const serviceName = $('#addServiceName').val().trim();
                const rentalArea = $('#addRentalArea').val();
                const unitPrice = $('#addUnitPrice').val().trim();
                const unitName = $('#addUnitName').val().trim();
                const calcMethod = $('#addCalcMethod').val();

                if (serviceName === '') {
                    $('#addServiceNameError').text('Tên dịch vụ không được để trống').show();
                    isValid = false;
                } else if (serviceName.length > 100) {
                    $('#addServiceNameError').text('Tên dịch vụ không được vượt quá 100 ký tự').show();
                    isValid = false;
                }

                if (!rentalArea) {
                    $('#addRentalAreaError').text('Vui lòng chọn khu vực').show();
                    isValid = false;
                }

                if (unitPrice === '' || isNaN(unitPrice) || parseFloat(unitPrice) <= 0) {
                    $('#addUnitPriceError').text('Giá phải là số dương').show();
                    isValid = false;
                }

                if (unitName === '') {
                    $('#addUnitNameError').text('Đơn vị không được để trống').show();
                    isValid = false;
                } else if (unitName.length > 50) {
                    $('#addUnitNameError').text('Đơn vị không được vượt quá 50 ký tự').show();
                    isValid = false;
                }

                if (!calcMethod) {
                    $('#addCalcMethodError').text('Vui lòng chọn phương thức tính').show();
                    isValid = false;
                }

                if (!isValid) {
                    event.preventDefault();
                }
            });

            // Client-side Validation for Edit Form
            $('#editServiceForm').submit(function(event) {
                let isValid = true;
                $('.error-message').text('').hide();

                const serviceName = $('#editServiceName').val().trim();
                const rentalArea = $('#editRentalArea').val();
                const unitPrice = $('#editUnitPrice').val().trim();
                const unitName = $('#editUnitName').val().trim();
                const calcMethod = $('#editCalcMethod').val();

                if (serviceName === '') {
                    $('#editServiceNameError').text('Tên dịch vụ không được để trống').show();
                    isValid = false;
                } else if (serviceName.length > 100) {
                    $('#editServiceNameError').text('Tên dịch vụ không được vượt quá 100 ký tự').show();
                    isValid = false;
                }

                if (!rentalArea) {
                    $('#editRentalAreaError').text('Vui lòng chọn khu vực').show();
                    isValid = false;
                }

                if (unitPrice === '' || isNaN(unitPrice) || parseFloat(unitPrice) <= 0) {
                    $('#editUnitPriceError').text('Giá phải là số dương').show();
                    isValid = false;
                }

                if (unitName === '') {
                    $('#editUnitNameError').text('Đơn vị không được để trống').show();
                    isValid = false;
                } else if (unitName.length > 50) {
                    $('#editUnitNameError').text('Đơn vị không được vượt quá 50 ký tự').show();
                    isValid = false;
                }

                if (!calcMethod) {
                    $('#editCalcMethodError').text('Vui lòng chọn phương thức tính').show();
                    isValid = false;
                }

                if (!isValid) {
                    event.preventDefault();
                }
            });

            // Populate View Modal
            $('.view-service-btn').click(function() {
                const serviceId = $(this).data('service-id');
                const serviceName = $(this).data('service-name');
                const rentalArea = $(this).data('rental-area');
                const unitPrice = $(this).data('unit-price');
                const unitName = $(this).data('unit-name');
                const calcMethod = $(this).data('calc-method');

                $('#viewServiceId').text(serviceId);
                $('#viewServiceName').text(serviceName);
                $('#viewRentalArea').text(rentalArea);
                $('#viewUnitPrice').text(parseFloat(unitPrice).toLocaleString('vi-VN'));
                $('#viewUnitName').text(unitName);
                $('#viewCalcMethod').text(calcMethod);
            });

            // Populate Edit Modal
            $('.edit-service-btn').click(function() {
                const serviceId = $(this).data('service-id');
                const serviceName = $(this).data('service-name');
                const rentalArea = $(this).data('rental-area');
                const unitPrice = $(this).data('unit-price');
                const unitName = $(this).data('unit-name');
                const calcMethod = $(this).data('calc-method');

                $('#editServiceId').val(serviceId);
                $('#editServiceName').val(serviceName);
                $('#editRentalArea').val(rentalArea);
                $('#editUnitPrice').val(unitPrice);
                $('#editUnitName').val(unitName);
                $('#editCalcMethod').val(calcMethod);
            });

            // Add active class to current nav item
            const currentPath = window.location.pathname;
            $('.nav-link').each(function() {
                if ($(this).attr('href') && currentPath.includes($(this).attr('href'))) {
                    $(this).addClass('active');
                }
            });
        });
    </script>
</body>
</html>
