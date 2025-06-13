<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chỉnh sửa Hóa đơn</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        .form-container { max-width: 800px; margin: 0 auto; }
        .cost-input { text-align: right; }
        .total-section { background: #f8f9fa; padding: 20px; border-radius: 8px; margin-top: 20px; }
        .bill-info { background: #e9ecef; padding: 15px; border-radius: 8px; margin-bottom: 20px; }
    </style>
</head>
<body>
    <div class="container">
        <div class="form-container">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h2><i class="fas fa-edit"></i> Chỉnh sửa Hóa đơn #${bill.id}</h2>
                <a href="BillServlet?action=list" class="btn btn-secondary">
                    <i class="fas fa-arrow-left"></i> Quay lại
                </a>
            </div>

            <!-- Thông tin hóa đơn -->
            <div class="bill-info">
                <div class="row">
                    <div class="col-md-6">
                        <strong>Người thuê:</strong> ${bill.tenantName}<br>
                        <strong>Số phòng:</strong> ${bill.roomNumber}
                    </div>
                    <div class="col-md-6">
                        <strong>Ngày tạo:</strong> ${bill.createdDate}<br>
                        <strong>Trạng thái hiện tại:</strong> 
                        <c:choose>
                            <c:when test="${bill.status == 'Paid'}">
                                <span class="badge bg-success">Đã thanh toán</span>
                            </c:when>
                            <c:when test="${bill.status == 'Unpaid'}">
                                <span class="badge bg-danger">Chưa thanh toán</span>
                            </c:when>
                            <c:otherwise>
                                <span class="badge bg-warning">Đang xử lý</span>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
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
                
                <div class="row">
                    <!-- Thông tin cơ bản -->
                    <div class="col-md-6">
                        <div class="card">
                            <div class="card-header">
                                <h5><i class="fas fa-user"></i> Thông tin người thuê</h5>
                            </div>
                            <div class="card-body">
                                <div class="mb-3">
                                    <label for="tenantName" class="form-label">Tên người thuê <span class="text-danger">*</span></label>
                                    <input type="text" class="form-control" id="tenantName" name="tenantName" 
                                           value="${bill.tenantName}" required placeholder="Nhập tên người thuê">
                                </div>
                                <div class="mb-3">
                                    <label for="roomNumber" class="form-label">Số phòng <span class="text-danger">*</span></label>
                                    <input type="text" class="form-control" id="roomNumber" name="roomNumber" 
                                           value="${bill.roomNumber}" required placeholder="Ví dụ: A101">
                                </div>
                                <div class="mb-3">
                                    <label for="dueDate" class="form-label">Hạn thanh toán <span class="text-danger">*</span></label>
                                    <input type="date" class="form-control" id="dueDate" name="dueDate" 
                                           value="${bill.dueDate}" required>
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
                        </div>
                    </div>

                    <!-- Chi phí -->
                    <div class="col-md-6">
                        <div class="card">
                            <div class="card-header">
                                <h5><i class="fas fa-calculator"></i> Chi phí</h5>
                            </div>
                            <div class="card-body">
                                <div class="mb-3">
                                    <label for="electricityCost" class="form-label">Tiền điện (₫)</label>
                                    <input type="number" class="form-control cost-input" id="electricityCost" 
                                           name="electricityCost" value="${bill.electricityCost}" min="0" step="1000" 
                                           onchange="calculateTotal()">
                                </div>
                                <div class="mb-3">
                                    <label for="waterCost" class="form-label">Tiền nước (₫)</label>
                                    <input type="number" class="form-control cost-input" id="waterCost" 
                                           name="waterCost" value="${bill.waterCost}" min="0" step="1000" 
                                           onchange="calculateTotal()">
                                </div>
                                <div class="mb-3">
                                    <label for="serviceCost" class="form-label">Phí dịch vụ (₫)</label>
                                    <input type="number" class="form-control cost-input" id="serviceCost" 
                                           name="serviceCost" value="${bill.serviceCost}" min="0" step="1000" 
                                           onchange="calculateTotal()">
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Tổng tiền -->
                <div class="total-section">
                    <div class="row">
                        <div class="col-md-6">
                            <h4>Tổng tiền: <span id="totalAmount" class="text-success">
                                <fmt:formatNumber value="${bill.total}" type="currency" currencySymbol="₫"/>
                            </span></h4>
                        </div>
                        <div class="col-md-6 text-end">
                            <button type="submit" class="btn btn-primary btn-lg">
                                <i class="fas fa-save"></i> Cập nhật hóa đơn
                            </button>
                            <a href="BillServlet?action=list" class="btn btn-secondary btn-lg">
                                <i class="fas fa-times"></i> Hủy
                            </a>
                        </div>
                    </div>
                </div>
            </form>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
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