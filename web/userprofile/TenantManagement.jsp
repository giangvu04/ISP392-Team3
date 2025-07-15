<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý người thuê - Manager Dashboard</title>
    <base href="${pageContext.request.contextPath}/">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link href="css/rooms.css" rel="stylesheet">
</head>
<body>
    <div class="container-fluid">
        <div class="row">
            <!-- Sidebar -->
            <jsp:include page="../Sidebar/SideBarManager.jsp"/>
            <!-- Main Content -->
            <div class="col-md-9 col-lg-10">
                <div style="min-height: 0vh;" class="main-content p-4">
                    <div class="mb-4">
                        <h2 class="mb-1">Quản lý người thuê</h2>
                        <p class="text-muted mb-0">Danh sách người thuê hiện tại thuộc các phòng bạn quản lý</p>
                    </div>
                    <div class="card mb-4">
                        <div class="card-header bg-light">
                            <h6 class="mb-0"><i class="fas fa-search me-2"></i>Tìm kiếm người thuê</h6>
                        </div>
                        <div class="card-body pb-1">
                            <form method="get" action="listUser">
                                <div class="row g-3 align-items-end">
                                    <div class="col-md-4">
                                        <label class="form-label">Tên người thuê</label>
                                        <input class="form-control" type="text" name="name" placeholder="Nhập tên..." value="${param.name}" />
                                    </div>
                                    <div class="col-md-4">
                                        <label class="form-label">Số điện thoại</label>
                                        <input class="form-control" type="text" name="phone" placeholder="Nhập SĐT..." value="${param.phone}" />
                                    </div>
                                    <div class="col-md-4">
                                        <label class="form-label">Email</label>
                                        <input class="form-control" type="text" name="email" placeholder="Nhập email..." value="${param.email}" />
                                    </div>
                                </div>
                                <div class="row mt-3">
                                    <div class="col-md-3">
                                        <button class="btn btn-outline-primary w-100" type="submit"><i class="fas fa-search"></i> Tìm kiếm</button>
                                    </div>
                                    <div class="col-md-3">
                                        <a href="listUser" class="btn btn-outline-secondary w-100" title="Làm mới"><i class="fas fa-sync-alt"></i> Làm mới</a>
                                    </div>
                                </div>
                            </form>
                        </div>
                    </div>
                    </div>
                    <c:choose>
                        <c:when test="${not empty search}">
                            <div class="card border-info mb-4">
                                
                                <div class="card-body p-0">
                                    <div class="table-responsive">
                                        <table class="table table-hover mb-0">
                                            <thead>
                                                <tr>
                                                    <th>Họ tên</th>
                                                    <th>Email</th>
                                                    <th>Số điện thoại</th>
                                                    <th>Phòng</th>
                                                    <th>Khu trọ</th>
                                                    <th>Thao tác</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <c:forEach var="u" items="${tenants}">
                                                    <tr>
                                                        <td>${u.fullName}</td>
                                                        <td>${u.email}</td>
                                                        <td>${u.phoneNumber}</td>
                                                        <td>${u.roomNumber}</td>
                                                        <td>${u.rentalAreaName}</td>
                                                        <td>
                                                            <a href="BillServlet?action=add" class="btn btn-sm btn-success mb-1" title="Tạo hóa đơn">
                                                                <i class="fas fa-file-invoice"></i> Tạo hóa đơn
                                                            </a>
                                                            <form method="post" action="kickTenant" style="display:inline;">
                                                                <input type="hidden" name="tenantId" value="${u.userId}" />
                                                                <input type="hidden" name="roomId" value="${u.roomId}" />
                                                                <button type="submit" class="btn btn-sm btn-danger" onclick="return confirm('Bạn có chắc muốn kích người này khỏi phòng?');">
                                                                    <i class="fas fa-user-slash"></i> Kích khỏi phòng
                                                                </button>
                                                            </form>
                                                        </td>
                                                    </tr>
                                                </c:forEach>
                                            </tbody>
                                        </table>
                                    </div>
                                    <c:if test="${empty tenants}">
                                        <div class="text-center py-5">
                                            <i class="fas fa-users fa-3x text-muted mb-3"></i>
                                            <h5 class="text-muted">Không có kết quả phù hợp</h5>
                                            <p class="text-muted">Không tìm thấy người thuê phù hợp với tiêu chí tìm kiếm.</p>
                                        </div>
                                    </c:if>
                                </div>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="card">
                                <div class="card-header bg-primary text-white">
                                    <h5 class="mb-0"><i class="fas fa-users me-2"></i>Danh sách người thuê</h5>
                                </div>
                                <div class="card-body p-0">
                                    <div class="table-responsive">
                                        <table class="table table-hover mb-0">
                                            <thead>
                                                <tr>
                                                    <th>Họ tên</th>
                                                    <th>Email</th>
                                                    <th>Số điện thoại</th>
                                                    <th>Phòng</th>
                                                    <th>Khu trọ</th>
                                                    <th>Thao tác</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <c:forEach var="u" items="${tenants}">
                                                    <tr>
                                                        <td>${u.fullName}</td>
                                                        <td>${u.email}</td>
                                                        <td>${u.phoneNumber}</td>
                                                        <td>${u.roomNumber}</td>
                                                        <td>${u.rentalAreaName}</td>
                                                        <td>
                                                            <a href="BillServlet?action=add" class="btn btn-sm btn-success mb-1" title="Tạo hóa đơn">
                                                                <i class="fas fa-file-invoice"></i> Tạo hóa đơn
                                                            </a>
                                                            <form method="post" action="kickTenant" style="display:inline;">
                                                                <input type="hidden" name="tenantId" value="${u.userId}" />
                                                                <input type="hidden" name="roomId" value="${u.roomId}" />
                                                                <button type="submit" class="btn btn-sm btn-danger" onclick="return confirm('Bạn có chắc muốn kích người này khỏi phòng?');">
                                                                    <i class="fas fa-user-slash"></i> Kích khỏi phòng
                                                                </button>
                                                            </form>
                                                        </td>
                                                    </tr>
                                                </c:forEach>
                                            </tbody>
                                        </table>
                                    </div>
                                    <c:if test="${empty tenants}">
                                        <div class="text-center py-5">
                                            <i class="fas fa-users fa-3x text-muted mb-3"></i>
                                            <h5 class="text-muted">Không có người thuê nào</h5>
                                            <p class="text-muted">Không tìm thấy người thuê phù hợp với tiêu chí tìm kiếm.</p>
                                        </div>
                                    </c:if>
                                </div>
                            </div>
                        </c:otherwise>
                    </c:choose>
                    <!-- Pagination -->
                    <nav class="mt-4">
                        <ul class="pagination justify-content-center">
                            <c:forEach var="i" begin="1" end="${totalPages}">
                                <li class="page-item ${i == page ? 'active' : ''}">
                                    <a class="page-link" href="listUser?managerId=${managerId}&amp;page=${i}&amp;search=${search}">${i}</a>
                                </li>
                            </c:forEach>
                        </ul>
                    </nav>
                </div>
            </div>
        </div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
