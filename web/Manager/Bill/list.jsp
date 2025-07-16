<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Quản lý Hóa đơn - Manager Dashboard</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
        <style>
            .sidebar {
                min-height: 100vh;
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            }
            .sidebar .nav-link {
                color: rgba(255,255,255,0.8);
                padding: 12px 20px;
                margin: 4px 0;
                border-radius: 8px;
                transition: all 0.3s ease;
            }
            .sidebar .nav-link:hover, .sidebar .nav-link.active {
                color: white;
                background: rgba(255,255,255,0.1);
                transform: translateX(5px);
            }
            .main-content {
                background: #f8f9fa;
                min-height: 100vh;
            }
            .card {
                border: none;
                border-radius: 15px;
                box-shadow: 0 4px 6px rgba(0,0,0,0.1);
                transition: transform 0.3s ease;
            }
            .card:hover {
                transform: translateY(-5px);
            }
            .stats-card {
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                color: white;
            }
            .stats-card-2 {
                background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
                color: white;
            }
            .stats-card-3 {
                background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
                color: white;
            }
            .table {
                border-radius: 10px;
                overflow: hidden;
            }
            .btn-action {
                border-radius: 20px;
                padding: 8px 16px;
                font-size: 0.875rem;
                transition: all 0.3s ease;
            }
            .btn-action:hover {
                transform: translateY(-2px);
                box-shadow: 0 2px 5px rgba(0,0,0,0.2);
            }
            .search-box {
                border-radius: 25px;
                border: 2px solid #e9ecef;
                padding: 10px 20px;
            }
            .search-box:focus {
                border-color: #667eea;
                box-shadow: 0 0 0 0.2rem rgba(102, 126, 234, 0.25);
            }
            .status-paid {
                background: #d4edda !important;
                color: #155724 !important;
                font-weight: bold;
            }
            .status-unpaid {
                background: #f8d7da !important;
                color: #721c24 !important;
                font-weight: bold;
            }
            .status-pending {
                background: #fff3cd !important;
                color: #856404 !important;
                font-weight: bold;
            }
            .user-info {
                background: rgba(255,255,255,0.1);
                border-radius: 10px;
                padding: 15px;
                margin-bottom: 20px;
            }
            .pagination-section {
                margin-top: 20px;
                display: flex;
                justify-content: center;
                align-items: center;
            }
            .pagination-section .page-item .page-link {
                border-radius: 20px;
                margin: 0 5px;
                color: #667eea;
                background: #fff;
                border: 1px solid #e9ecef;
                transition: all 0.3s ease;
                padding: 8px 14px;
            }
            .pagination-section .page-item.active .page-link {
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                border-color: #667eea;
                color: white;
            }
            .pagination-section .page-item.disabled .page-link {
                color: #6c757d;
                background: #f8f9fa;
                border-color: #e9ecef;
                cursor: not-allowed;
            }
            .pagination-section .page-link:hover {
                background: #e9ecef;
                border-color: #667eea;
                color: #667eea;
            }
        </style>
    </head>
    <body>
        <div class="container-fluid">
            <div class="row">
                <!-- Sidebar -->
                <c:choose>
                    <c:when test="${user.roleId == 3}">
                        <jsp:include page="../../Sidebar/SideBarTelnant.jsp"/>
                    </c:when>
                    <c:otherwise>
                        <jsp:include page="../../Sidebar/SideBarManager.jsp"/>
                    </c:otherwise>
                </c:choose>

                <!-- Main Content -->
                <div class="col-md-9 col-lg-10">
                    <div class="main-content p-4">
                        <!-- Header -->
                        <div class="d-flex justify-content-between align-items-center mb-4">
                            <div>
                                <h2 class="mb-1"><i class="fas fa-receipt"></i> Quản lý Hóa đơn</h2>
                                <p class="text-muted mb-0">Quản lý và theo dõi hóa đơn của người thuê</p>
                            </div>
                            <c:if test="${user.roleId == 2}">
                                <a href="BillServlet?action=add" class="btn btn-primary btn-action">
                                    <i class="fas fa-plus me-2"></i>Thêm hóa đơn
                                </a>
                            </c:if>
                        </div>

                        <!-- Alert Messages -->
                        <c:if test="${not empty success}">
                            <div class="alert alert-success alert-dismissible fade show" role="alert">
                                <i class="fas fa-check-circle me-2"></i>${success}
                                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                            </div>
                        </c:if>
                        <c:if test="${not empty error}">
                            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                                <i class="fas fa-exclamation-circle me-2"></i>${error}
                                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                            </div>
                        </c:if>

                        <!-- Stats Cards -->
                        <div class="row mb-4">
                            <c:choose>
                                <c:when test="${user.roleId == 2}">
                                    <div class="col-md-4">
                                        <div class="card stats-card">
                                            <div class="card-body">
                                                <div class="d-flex justify-content-between">
                                                    <div>
                                                        <h6 class="card-title">Tổng hóa đơn</h6>
                                                        <h3 class="mb-0">${totalBills}</h3>
                                                    </div>
                                                    <div class="align-self-center">
                                                        <i class="fas fa-file-invoice fa-2x"></i>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-md-4">
                                        <div class="card stats-card-2">
                                            <div class="card-body">
                                                <div class="d-flex justify-content-between">
                                                    <div>
                                                        <h6 class="card-title">Doanh thu</h6>
                                                        <h3 class="mb-0"><fmt:formatNumber value="${totalRevenue}" type="currency" currencySymbol="₫"/></h3>
                                                    </div>
                                                    <div class="align-self-center">
                                                        <i class="fas fa-money-bill-wave fa-2x"></i>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-md-4">
                                        <div class="card stats-card-3">
                                            <div class="card-body">
                                                <div class="d-flex justify-content-between">
                                                    <div>
                                                        <h6 class="card-title">Chưa thanh toán</h6>
                                                        <h3 class="mb-0">${unpaidCount}</h3>
                                                    </div>
                                                    <div class="align-self-center">
                                                        <i class="fas fa-clock fa-2x"></i>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <div class="col-md-6">
                                        <div class="card stats-card">
                                            <div class="card-body">
                                                <div class="d-flex justify-content-between">
                                                    <div>
                                                        <h6 class="card-title">Tổng hóa đơn</h6>
                                                        <h3 class="mb-0">${totalBills}</h3>
                                                    </div>
                                                    <div class="align-self-center">
                                                        <i class="fas fa-file-invoice fa-2x"></i>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <div class="card stats-card-3">
                                            <div class="card-body">
                                                <div class="d-flex justify-content-between">
                                                    <div>
                                                        <h6 class="card-title">Chưa thanh toán</h6>
                                                        <h3 class="mb-0">${unpaidCount}</h3>
                                                    </div>
                                                    <div class="align-self-center">
                                                        <i class="fas fa-clock fa-2x"></i>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>

                        <!-- Search and Filter -->
                        <div class="card mb-4">
                            <div class="card-body">
                                <form action="listbills" method="GET" class="row g-3">
                                    <input type="hidden" name="action" value="search">
                                    <div class="col-md-3">
                                        <label for="searchType" class="form-label">Tìm kiếm theo:</label>
                                        <select class="form-select" id="searchType" name="searchType">
                                            <c:if test="${user.roleId ==2}">
                                            <option value="tenantName" ${searchType == 'tenantName' ? 'selected' : ''}>Tên người thuê</option>
                                            <option value="roomNumber" ${searchType == 'roomNumber' ? 'selected' : ''}>Số phòng</option></c:if>
                                            <option value="status" ${searchType == 'status' ? 'selected' : ''}>Trạng thái</option>
                                        </select>
                                    </div>
                                    <div class="col-md-6">
                                        <label for="searchValue" class="form-label">Giá trị tìm kiếm:</label>
                                        <input type="text" class="form-control search-box" id="searchValue" name="searchValue" 
                                               value="${searchValue}" placeholder="Nhập từ khóa tìm kiếm...">
                                    </div>
                                    <div class="col-md-3">
                                        <label class="form-label"> </label>
                                        <div>
                                            <button type="submit" class="btn btn-primary btn-action">
                                                <i class="fas fa-search me-2"></i>Tìm kiếm
                                            </button>
                                            <a href="listbills" class="btn btn-outline-secondary btn-action">
                                                <i class="fas fa-refresh me-2"></i>Làm mới
                                            </a>
                                        </div>
                                    </div>
                                </form>
                            </div>
                        </div>

                        <!-- Bills Table -->
                        <div class="card">
                            <div class="card-header bg-white">
                                <h5 class="mb-0"><i class="fas fa-list me-2"></i>Danh sách hóa đơn</h5>
                            </div>
                            <div class="card-body p-0">
                                <div class="table-responsive">
                                    <table class="table table-hover mb-0">
                                        <thead class="table-light">
                                            <tr>
                                                <th>ID</th>
                                                <th>Tên người thuê</th>
                                                <th>Số phòng</th>
                                                <th>Tiền điện</th>
                                                <th>Tiền nước</th>
                                                <th>Phí dịch vụ</th>
                                                <th>Tổng tiền</th>
                                                <th>Hạn thanh toán</th>
                                                <th>Trạng thái</th>
                                                <th>Ngày tạo</th>
                                                <th>Thao tác</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach var="bill" items="${bills}">
                                                <tr>
                                                    <td>${bill.id}</td>
                                                    <td>
                                                        <div class="fw-bold">${bill.tenantName}</div>
                                                    </td>
                                                    <td><span class="badge bg-info">${bill.roomNumber}</span></td>
                                                    <td><fmt:formatNumber value="${bill.electricityCost}" type="currency" currencySymbol="₫"/></td>
                                                    <td><fmt:formatNumber value="${bill.waterCost}" type="currency" currencySymbol="₫"/></td>
                                                    <td><fmt:formatNumber value="${bill.serviceCost}" type="currency" currencySymbol="₫"/></td>
                                                    <td><strong><fmt:formatNumber value="${bill.total}" type="currency" currencySymbol="₫"/></strong></td>
                                                    <td>${bill.dueDate}</td>
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${bill.status == 'Paid'}">
                                                                <span class="badge status-paid">Đã thanh toán</span>
                                                            </c:when>
                                                            <c:when test="${bill.status == 'Unpaid'}">
                                                                <span class="badge status-unpaid">Chưa thanh toán</span>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="badge status-pending">Đang xử lý</span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                    <td>${bill.createdDate}</td>
                                                    <td>
                                                        <div class="btn-group" role="group">
                                                            <a href="BillServlet?action=view&id=${bill.id}" 
                                                               class="btn btn-sm btn-outline-info btn-action" 
                                                               title="Xem chi tiết">
                                                                <i class="fas fa-eye"></i>
                                                            </a>
                                                            <a href="BillServlet?action=edit&id=${bill.id}" 
                                                               class="btn btn-sm btn-outline-warning btn-action" 
                                                               title="Sửa">
                                                                <i class="fas fa-edit"></i>
                                                            </a>
                                                            <c:if test="${user.roleId == 3}">
                                                                <button type="button" class="btn btn-sm btn-outline-primary btn-action" title="Đánh giá" onclick="openFeedbackModal('${bill.id}', '${bill.tenantName}')">
                                                                    <i class="fas fa-star"></i>
                                                                </button>
                                                            </c:if>
                                                            <c:if test="${user.roleId == 2}">
                                                                <button type="button" class="btn btn-sm btn-outline-success btn-action" title="Gửi tin nhắn" onclick="openMessageModal('${bill.id}', '${bill.tenantName}', '${bill.emailTelnant}')">
                                                                    <i class="fas fa-paper-plane"></i>
                                                                </button>
                                                            </c:if>
                                                            <c:if test="${bill.status == 'Unpaid'}">
                                                                <button type="button" 
                                                                        class="btn btn-sm btn-outline-success btn-action" 
                                                                        onclick="updateStatus('${bill.id}', 'Paid')"
                                                                        title="Đánh dấu đã thanh toán">
                                                                    <i class="fas fa-check"></i>
                                                                </button>
                                                            </c:if>
                                                        </div>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        </div>

                        <!-- Pagination -->
                        <c:if test="${not empty bills}">
                            <div class="pagination-section">
                                <nav aria-label="Page navigation">
                                    <ul class="pagination">
                                        <li class="page-item ${currentPage <= 1 ? 'disabled' : ''}">
                                            <a class="page-link" href="listbills?action=list&page=${currentPage - 1}" aria-label="Previous">
                                                <span aria-hidden="true">« Trước</span>
                                            </a>
                                        </li>
                                        <c:forEach begin="1" end="${totalPages}" var="i">
                                            <li class="page-item ${currentPage == i ? 'active' : ''}">
                                                <a class="page-link" href="listbills?action=list&page=${i}">${i}</a>
                                            </li>
                                        </c:forEach>
                                        <li class="page-item ${currentPage >= totalPages ? 'disabled' : ''}">
                                            <a class="page-link" href="listbills?action=list&page=${currentPage + 1}" aria-label="Next">
                                                <span aria-hidden="true">Tiếp »</span>
                                            </a>
                                        </li>
                                    </ul>
                                </nav>
                            </div>
                        </c:if>

                        <!-- Empty State -->
                        <c:if test="${empty bills}">
                            <div class="text-center mt-5">
                                <i class="fas fa-inbox fa-4x text-muted mb-3"></i>
                                <h4 class="text-muted">Không có hóa đơn nào</h4>
                                <p class="text-muted">Hãy thêm hóa đơn mới để bắt đầu</p>
                                <a href="BillServlet?action=add" class="btn btn-primary btn-action">
                                    <i class="fas fa-plus me-2"></i>Thêm hóa đơn đầu tiên
                                </a>
                            </div>
                        </c:if>
                    </div>
                </div>
            </div>
        </div>

        <!-- Feedback Modal -->
        <div class="modal fade" id="feedbackModal" tabindex="-1">
            <div class="modal-dialog">
                <div class="modal-content">
                    <form id="feedbackForm" action="feedback" method="post">
                        <div class="modal-header">
                            <h5 class="modal-title">Đánh giá hóa đơn cho <span id="feedbackTenantName"></span></h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                        </div>
                        <div class="modal-body">
                            <input type="hidden" id="feedbackRoomId" name="roomId" />
                            <div class="mb-3">
                                <label for="feedbackContent" class="form-label">Nội dung đánh giá</label>
                                <textarea class="form-control" id="feedbackContent" name="content" rows="3" required></textarea>
                            </div>
                            <div class="mb-3">
                                <label for="feedbackRating" class="form-label">Số sao</label>
                                <select class="form-select" id="feedbackRating" name="rating" required>
                                    <option value="">Chọn số sao</option>
                                    <option value="5">5 - Tuyệt vời</option>
                                    <option value="4">4 - Tốt</option>
                                    <option value="3">3 - Bình thường</option>
                                    <option value="2">2 - Kém</option>
                                    <option value="1">1 - Rất tệ</option>
                                </select>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                            <button type="submit" class="btn btn-primary">Gửi đánh giá</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <!-- Message Modal -->
        <div class="modal fade" id="messageModal" tabindex="-1">
            <div class="modal-dialog">
                <div class="modal-content">
                    <form id="messageForm" action="sendMessage" method="post">
                        <div class="modal-header">
                            <h5 class="modal-title">Gửi tin nhắn cho <span id="messageTenantName"></span></h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                        </div>
                        <div class="modal-body">
                            <input type="hidden" id="messageBillId" name="billId" />
                            <input type="hidden" id="messageTenantEmail" name="tenantEmail"/>
                            <div class="mb-3">
                                <label for="messageContent" class="form-label">Nội dung tin nhắn</label>
                                <textarea class="form-control" id="messageContent" name="content" rows="3" required></textarea>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                            <button type="submit" class="btn btn-success">Gửi tin nhắn</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
        <jsp:include page="../messages.jsp"/>
        <!-- Bootstrap JS -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

        <script>
            // Mở modal đánh giá
            function openFeedbackModal(billId, tenantName) {
                document.getElementById('feedbackRoomId').value = billId;
                document.getElementById('feedbackTenantName').innerText = tenantName;
                document.getElementById('feedbackContent').value = '';
                document.getElementById('feedbackRating').value = '';
                new bootstrap.Modal(document.getElementById('feedbackModal')).show();
            }

            // Mở modal gửi tin nhắn
            function openMessageModal(billId, tenantName, tenantEmail) {
                document.getElementById('messageBillId').value = billId;
                document.getElementById('messageTenantName').innerText = tenantName;
                document.getElementById('messageTenantEmail').value = tenantEmail;
                document.getElementById('messageContent').value = '';
                new bootstrap.Modal(document.getElementById('messageModal')).show();
            }

            function updateStatus(id, status) {
                if (confirm('Bạn có chắc chắn muốn cập nhật trạng thái hóa đơn này?')) {
                    window.location.href = 'BillServlet?action=updateStatus&id=' + id + '&status=' + status;
                }
            }

            // Auto-hide alerts after 5 seconds
            setTimeout(function () {
                const alerts = document.querySelectorAll('.alert');
                alerts.forEach(function (alert) {
                    const bsAlert = new bootstrap.Alert(alert);
                    bsAlert.close();
                });
            }, 5000);
        </script>
    </body>
</html>