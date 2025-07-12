<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chi tiết Hóa đơn #${bill.id}</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        .bill-container { max-width: 800px; margin: 0 auto; }
        .bill-header { background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: white; padding: 30px; border-radius: 10px; margin-bottom: 30px; }
        .bill-details { background: #f8f9fa; padding: 25px; border-radius: 10px; margin-bottom: 20px; }
        .cost-item { background: white; padding: 15px; border-radius: 8px; margin-bottom: 10px; border-left: 4px solid #007bff; }
        .total-section { background: #e9ecef; padding: 20px; border-radius: 10px; border: 2px solid #28a745; }
        .status-badge { font-size: 1.1em; padding: 8px 16px; }
        .action-buttons { margin-top: 20px; }
    </style>
</head>
<body>
    <div class="container">
        <div class="bill-container">
            <!-- Header -->
            <div class="bill-header text-center">
                <h1><i class="fas fa-file-invoice"></i> HÓA ĐƠN</h1>
                <h3>Số hóa đơn: #${bill.id}</h3>
                <p class="mb-0">Ngày tạo: ${bill.createdDate}</p>
            </div>

            <!-- Thông báo -->
            <c:if test="${not empty success}">
                <div class="alert alert-success alert-dismissible fade show" role="alert">
                    <i class="fas fa-check-circle"></i> ${success}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>
            <c:if test="${not empty error}">
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                    <i class="fas fa-exclamation-circle"></i> ${error}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>

            <!-- Thông tin cơ bản -->
            <div class="bill-details">
                <div class="row">
                    <div class="col-md-6">
                        <h5><i class="fas fa-user"></i> Thông tin người thuê</h5>
                        <hr>
                        <p><strong>Tên người thuê:</strong> ${bill.tenantName}</p>
                        <p><strong>Số phòng:</strong> <span class="badge bg-info">${bill.roomNumber}</span></p>
                    </div>
                    <div class="col-md-6">
                        <h5><i class="fas fa-calendar"></i> Thông tin thanh toán</h5>
                        <hr>
                        <p><strong>Hạn thanh toán:</strong> ${bill.dueDate}</p>
                        <p><strong>Trạng thái:</strong> 
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

            <!-- Chi tiết chi phí -->
            <div class="bill-details">
                <h5><i class="fas fa-list"></i> Chi tiết chi phí</h5>
                <hr>
                
                <div class="cost-item">
                    <div class="row">
                        <div class="col-md-8">
                            <h6><i class="fas fa-bolt"></i> Tiền điện</h6>
                            <small class="text-muted">Chi phí sử dụng điện trong tháng</small>
                        </div>
                        <div class="col-md-4 text-end">
                            <h5><fmt:formatNumber value="${bill.electricityCost}" type="currency" currencySymbol="₫"/></h5>
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
                            <h5><fmt:formatNumber value="${bill.waterCost}" type="currency" currencySymbol="₫"/></h5>
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
                            <h5><fmt:formatNumber value="${bill.serviceCost}" type="currency" currencySymbol="₫"/></h5>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Tổng tiền -->
            <div class="total-section">
                <div class="row">
                    <div class="col-md-6">
                        <h3><i class="fas fa-calculator"></i> Tổng cộng:</h3>
                    </div>
                    <div class="col-md-6 text-end">
                        <h2 class="text-success">
                            <fmt:formatNumber value="${bill.total}" type="currency" currencySymbol="₫"/>
                        </h2>
                    </div>
                </div>
            </div>

            <!-- Nút thao tác -->
            <div class="action-buttons text-center">
                <c:if test="${bill.status == 'Unpaid'}">
                    <button type="button" class="btn btn-success btn-lg" onclick="updateStatus(${bill.id}, 'Paid')">
                        <i class="fas fa-check"></i> Đánh dấu đã thanh toán
                    </button>
                </c:if>
                
                <a href="BillServlet?action=edit&id=${bill.id}" class="btn btn-warning btn-lg">
                    <i class="fas fa-edit"></i> Chỉnh sửa
                </a>
                
                <button type="button" class="btn btn-info btn-lg" onclick="printBill()">
                    <i class="fas fa-print"></i> In hóa đơn
                </button>
                
                <a href="BillServlet?action=list" class="btn btn-secondary btn-lg">
                    <i class="fas fa-arrow-left"></i> Quay lại
                </a>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        function updateStatus(id, status) {
            if (confirm('Bạn có chắc chắn muốn cập nhật trạng thái hóa đơn?')) {
                window.location.href = 'BillServlet?action=updateStatus&id=' + id + '&status=' + status;
            }
        }

        function printBill() {
            window.print();
        }

        // Auto-hide alerts after 5 seconds
        setTimeout(function() {
            const alerts = document.querySelectorAll('.alert');
            alerts.forEach(function(alert) {
                new bootstrap.Alert(alert).close();
            });
        }, 5000);
    </script>
</body>
</html> 