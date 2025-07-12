<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chỉnh sửa Hóa đơn #${bill.id}</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link href="css/rooms.css" rel="stylesheet">
    <style>
        body { background: #f8f9fa; }
        .main-content { min-height: 100vh; padding: 2rem; }
        .page-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 2rem;
            border-radius: 20px;
            margin-bottom: 2rem;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
        }
        .form-card {
            background: white;
            border-radius: 20px;
            box-shadow: 0 8px 25px rgba(0,0,0,0.1);
            padding: 2rem;
            margin-bottom: 2rem;
            border: none;
        }
        .form-label { font-weight: 600; }
        .cost-item { background: #f8f9fa; padding: 1.2rem; border-radius: 12px; margin-bottom: 1rem; border-left: 4px solid #667eea; }
        .total-section {
            background: #f8f9fa;
            padding: 1.5rem 2rem;
            border-radius: 15px;
            margin-top: 2rem;
            box-shadow: 0 2px 8px rgba(102,126,234,0.08);
        }
        .status-badge { font-size: 1.1em; padding: 8px 16px; }
        .btn-action {
            border-radius: 12px;
            padding: 0.75rem 1.5rem;
            font-weight: 600;
            font-size: 1rem;
            transition: all 0.3s ease;
        }
        .btn-action:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 15px rgba(102, 126, 234, 0.2);
        }
        .cost-input { text-align: right; }
    </style>
</head>
<body>
    <div class="container-fluid">
        <div class="row">
            <jsp:include page="../Sidebar/SideBarManager.jsp"/>
            <div class="col-md-9 col-lg-10">
                <div class="main-content">
                    <div class="page-header text-center mb-4">
                        <h1 class="mb-2"><i class="fas fa-edit"></i> CHỈNH SỬA HÓA ĐƠN</h1>
                        <h3 class="mb-1">Số hóa đơn: #${bill.id}</h3>
                        <p class="mb-0">Ngày tạo: ${bill.createdDate}</p>
                    </div>

                    <!-- Thông báo lỗi -->
                    <c:if test="${not empty error}">
                        <div class="alert alert-danger alert-dismissible fade show" role="alert">
                            <i class="fas fa-exclamation-circle"></i> ${error}
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </div>
                    </c:if>

                    <form action="BillServlet" method="POST" id="billForm">
                        <input type="hidden" name="action" value="update">
                        <input type="hidden" name="id" value="${bill.id}">
                        <div class="form-card">
                            <div class="row">
                                <div class="col-md-6">
                                    <h5 class="mb-3"><i class="fas fa-user"></i> Thông tin người thuê</h5>
                                    <div class="mb-3">
                                        <label for="tenantName" class="form-label">Tên người thuê <span class="text-danger">*</span></label>
                                        <input type="text" class="form-control" id="tenantName" name="tenantName" value="${bill.tenantName}" required placeholder="Nhập tên người thuê">
                                    </div>
                                    <div class="mb-3">
                                        <label for="roomNumber" class="form-label">Số phòng <span class="text-danger">*</span></label>
                                        <input type="text" class="form-control" id="roomNumber" name="roomNumber" value="${bill.roomNumber}" required placeholder="Ví dụ: A101">
                                    </div>
                                    <div class="mb-3">
                                        <label for="dueDate" class="form-label">Hạn thanh toán <span class="text-danger">*</span></label>
                                        <input type="date" class="form-control" id="dueDate" name="dueDate" value="${bill.dueDate}" required>
                                    </div>
                                    <div class="mb-3">
                                        <label for="status" class="form-label">Trạng thái <span class="text-danger">*</span></label>
                                        <select class="form-select" id="status" name="status" required>
                                            <option value="">Chọn trạng thái</option>
                                            <option value="Unpaid" ${bill.status == 'Unpaid' ? 'selected' : ''}>Chưa thanh toán</option>
                                            <option value="Paid" ${bill.status == 'Paid' ? 'selected' : ''}>Đã thanh toán</option>
                                            <option value="Pending" ${bill.status == 'Pending' ? 'selected' : ''}>Đang xử lý</option>
                                        </select>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <h5 class="mb-3"><i class="fas fa-calendar"></i> Thông tin thanh toán</h5>
                                    <p><strong>Trạng thái hiện tại:</strong> 
                                        <c:choose>
                                            <c:when test="${bill.status == 'Paid'}">
                                                <span class="badge bg-success status-badge">Đã thanh toán</span>
                                            </c:when>
                                            <c:when test="${bill.status == 'Unpaid'}">
                                                <span class="badge bg-danger status-badge">Chưa thanh toán</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge bg-warning status-badge">Đang xử lý</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </p>
                                </div>
                            </div>
                        </div>

                        <div class="form-card">
                            <h5 class="mb-3"><i class="fas fa-list"></i> Chi tiết chi phí</h5>
                            <div class="cost-item">
                                <div class="row">
                                    <div class="col-md-8">
                                        <h6><i class="fas fa-bolt"></i> Tiền điện</h6>
                                        <small class="text-muted">Chi phí sử dụng điện trong tháng</small>
                                    </div>
                                    <div class="col-md-4 text-end">
                                        <input type="number" class="form-control cost-input" id="electricityCost" name="electricityCost" value="${bill.electricityCost}" min="0" step="1000" onchange="calculateTotal()">
                                    </div>
                                </div>
                            </div>
                            <div class="cost-item">
                                <div class="row">
                                    <div class="col-md-8">
                                        <h6><i class="fas fa-tint"></i> Tiền nước</h6>
                                        <small class="text-muted">Chi phí sử dụng nước trong tháng</small>
                                    </div>
                                    <div class="col-md-4 text-end">
                                        <input type="number" class="form-control cost-input" id="waterCost" name="waterCost" value="${bill.waterCost}" min="0" step="1000" onchange="calculateTotal()">
                                    </div>
                                </div>
                            </div>
                            <div class="cost-item">
                                <div class="row">
                                    <div class="col-md-8">
                                        <h6><i class="fas fa-tools"></i> Phí dịch vụ</h6>
                                        <small class="text-muted">Phí dịch vụ và bảo trì</small>
                                    </div>
                                    <div class="col-md-4 text-end">
                                        <input type="number" class="form-control cost-input" id="serviceCost" name="serviceCost" value="${bill.serviceCost}" min="0" step="1000" onchange="calculateTotal()">
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="total-section">
                            <div class="row align-items-center">
                                <div class="col-md-6">
                                    <h3 class="mb-0"><i class="fas fa-calculator"></i> Tổng cộng:</h3>
                                </div>
                                <div class="col-md-6 text-end">
                                    <h2 class="text-success mb-0">
                                        <span id="totalAmount"><fmt:formatNumber value="${bill.total}" type="currency" currencySymbol="₫"/></span>
                                    </h2>
                                </div>
                            </div>
                        </div>

                        <div class="text-center mt-4">
                            <button type="submit" class="btn btn-primary btn-action btn-lg me-2">
                                <i class="fas fa-save"></i> Cập nhật hóa đơn
                            </button>
                            <a href="listbills" class="btn btn-outline-secondary btn-action btn-lg">
                                <i class="fas fa-times"></i> Hủy
                            </a>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Tính tổng tiền
        function calculateTotal() {
            const electricity = parseFloat(document.getElementById('electricityCost').value) || 0;
            const water = parseFloat(document.getElementById('waterCost').value) || 0;
            const service = parseFloat(document.getElementById('serviceCost').value) || 0;
            const total = electricity + water + service;
            document.getElementById('totalAmount').textContent = total.toLocaleString('vi-VN') + ' ₫';
        }

        // Khởi tạo khi trang load
        document.addEventListener('DOMContentLoaded', function() {
            calculateTotal();
        });

        // Validate form
        document.getElementById('billForm').addEventListener('submit', function(e) {
            const tenantName = document.getElementById('tenantName').value.trim();
            const roomNumber = document.getElementById('roomNumber').value.trim();
            if (!tenantName) {
                e.preventDefault();
                alert('Vui lòng nhập tên người thuê!');
                document.getElementById('tenantName').focus();
                return false;
            }
            if (!roomNumber) {
                e.preventDefault();
                alert('Vui lòng nhập số phòng!');
                document.getElementById('roomNumber').focus();
                return false;
            }
        });
    </script>
</body>
</html>