<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý Dịch vụ - Danh sách</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        .page-header { background: linear-gradient(135deg, #43e97b 0%, #38f9d7 100%); color: white; padding: 2rem 0; margin-bottom: 2rem; }
        .btn-gradient { background: linear-gradient(45deg, #43e97b, #38f9d7); border: none; color: white; }
        .btn-gradient:hover { background: linear-gradient(45deg, #38f9d7, #43e97b); color: white; }
        .table-responsive { border-radius: 10px; overflow: hidden; box-shadow: 0 0 20px rgba(0,0,0,0.1); }
        .pagination .page-link { border: none; margin: 0 2px; border-radius: 8px; }
        .pagination .page-item.active .page-link { background: linear-gradient(45deg, #43e97b, #38f9d7); border: none; }
    </style>
</head>
<body class="bg-light">
    <div class="page-header">
        <div class="container">
            <div class="row align-items-center">
                <div class="col-md-8">
                    <h1 class="mb-0">
                        <i class="fas fa-concierge-bell me-3"></i>Danh sách dịch vụ cung cấp
                    </h1>                    
                </div>
                <div class="col-md-4 text-end">
                    <p><a class="btn btn-light btn-lg" href="ManagerHomepage">Quay lại</a></p>
                </div>
            </div>
        </div>
    </div>

    <div class="container">
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

        <div class="search-box mb-4">
            <form method="GET" action="listservices">
                <input type="hidden" name="action" value="search">
                <div class="input-group">
                    <input type="text" name="keyword" class="form-control" placeholder="Nhập tên dịch vụ..." value="${keyword}" required>
                    <button class="btn btn-gradient" type="submit"><i class="fas fa-search me-1"></i> Tìm kiếm</button>
                    <c:if test="${searchMode}">
                        <a href="listservices" class="btn btn-outline-secondary ms-2">Hủy</a>
                    </c:if>
                </div>
            </form>
        </div>

        <div class="card">
            <div class="card-header d-flex justify-content-between align-items-center">
                <h5 class="mb-0">
                    <i class="fas fa-list me-2 text-success"></i>
                    <c:choose>
                        <c:when test="${searchMode}">Kết quả tìm kiếm</c:when>
                        <c:otherwise>Danh sách dịch vụ</c:otherwise>
                    </c:choose>
                </h5>
                <a href="listservices?action=add" class="btn btn-gradient">
                    <i class="fas fa-plus me-1"></i> Thêm mới
                </a>
            </div>
            <div class="card-body p-0">
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
                                <thead class="table-dark">
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
                                                <a href="listservices?action=view&id=${s.serviceId}" class="btn btn-sm btn-outline-info"><i class="fas fa-eye"></i></a>
                                                <a href="listservices?action=edit&id=${s.serviceId}" class="btn btn-sm btn-outline-warning"><i class="fas fa-edit"></i></a>
                                                <a href="listservices?action=delete&id=${s.serviceId}" class="btn btn-sm btn-outline-danger" onclick="return confirm('Xác nhận xóa dịch vụ?')"><i class="fas fa-trash"></i></a>
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

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
