<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Thêm Hóa đơn Mới</title>
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
        .cost-input { text-align: right; }
        .total-section {
            background: #f8f9fa;
            padding: 1.5rem 2rem;
            border-radius: 15px;
            margin-top: 2rem;
            box-shadow: 0 2px 8px rgba(102,126,234,0.08);
        }
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
    </style>
</head>
<body>
    <div class="container-fluid">
        <div class="row">
            <jsp:include page="../Sidebar/SideBarManager.jsp"/>
            <div class="col-md-9 col-lg-10">
                <div class="main-content">
                    <div class="page-header d-flex justify-content-between align-items-center mb-4">
                        <div>
                            <h2 class="mb-1"><i class="fas fa-plus-circle"></i> Thêm Hóa đơn Mới</h2>
                            <p class="text-light mb-0">Tạo hóa đơn cho người thuê phòng</p>
                        </div>
                        <a href="listbills" class="btn btn-secondary btn-action">
                            <i class="fas fa-arrow-left"></i> Quay lại
                        </a>
                    </div>

                    <!-- Thông báo lỗi -->
                    <c:if test="${not empty error}">
                        <div class="alert alert-danger alert-dismissible fade show" role="alert">
                            <i class="fas fa-exclamation-circle"></i> ${error}
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </div>
                    </c:if>

                    <form action="BillServlet" method="POST" id="billForm">
                        <input type="hidden" name="action" value="add">
                        <div class="row g-4">
                            <!-- Thông tin người thuê -->
                            <div class="col-md-6">
                                <div class="form-card">
                                    <h5 class="mb-3"><i class="fas fa-user"></i> Thông tin người thuê</h5>
                                    <div class="mb-3">
                                        <label for="billType" class="form-label">Loại hóa đơn <span class="text-danger">*</span></label>
                                        <select class="form-select" id="billType" name="billType" required>
                                            <option value="">Chọn loại</option>
                                            <option value="Thu">Thu</option>
                                            <option value="Chi">Chi</option>
                                        </select>
                                    </div>
                                    <div class="mb-3">
                                        <label for="tenantRoom" class="form-label">Chọn người thuê - phòng - khu trọ <span class="text-danger">*</span></label>
                                        <select class="form-select" id="tenantRoom" name="tenantRoom" required>
                                            <option value="">Chọn người thuê/phòng/khu trọ</option>
                                            <c:forEach var="tenant" items="${tenants}">
                                                <option value="${tenant.userId},${tenant.roomId},${tenant.rentalAreaId},${tenant.email}">
                                                    ${tenant.fullName} - Phòng: ${tenant.roomNumber} - Khu: ${tenant.rentalAreaName}
                                                </option>
                                            </c:forEach>
                                        </select>
                                    </div>
                                    <div class="mb-3">
                                        <label for="dueDate" class="form-label">Hạn thanh toán <span class="text-danger">*</span></label>
                                        <input type="date" class="form-control" id="dueDate" name="dueDate" required>
                                    </div>
                                    <div class="mb-3">
                                        <label for="status" class="form-label">Trạng thái <span class="text-danger">*</span></label>
                                        <select class="form-select" id="status" name="status" required>
                                            <option value="">Chọn trạng thái</option>
                                            <option value="Unpaid">Chưa thanh toán</option>
                                            <option value="Paid">Đã thanh toán</option>
                                            <option value="Pending">Đang xử lý</option>
                                        </select>
                                    </div>
                                    <div class="mb-3">
                                        <label for="note" class="form-label">Ghi chú</label>
                                        <textarea class="form-control" id="note" name="note" rows="2" placeholder="Nhập ghi chú (nếu có)"></textarea>
                                    </div>
                                </div>
                            </div>
                            <!-- Chi phí -->
                            <div class="col-md-6">
                                <div class="form-card">
                                    <h5 class="mb-3"><i class="fas fa-calculator"></i> Chi phí</h5>
                                    <div class="mb-3">
                                        <label for="electricityCost" class="form-label">Tiền điện (₫)</label>
                                        <input type="number" class="form-control cost-input" id="electricityCost" name="electricityCost" value="0" min="0" step="1000" onchange="calculateTotal()">
                                    </div>
                                    <div class="mb-3">
                                        <label for="waterCost" class="form-label">Tiền nước (₫)</label>
                                        <input type="number" class="form-control cost-input" id="waterCost" name="waterCost" value="0" min="0" step="1000" onchange="calculateTotal()">
                                    </div>
                                    <div class="mb-3">
                                        <label for="serviceCost" class="form-label">Phí dịch vụ (₫)</label>
                                        <input type="number" class="form-control cost-input" id="serviceCost" name="serviceCost" value="0" min="0" step="1000" onchange="calculateTotal()">
                                    </div>
                                </div>
                            </div>
                        </div>
                        <!-- Tổng tiền -->
                        <div class="total-section mt-4">
                            <div class="row align-items-center">
                                <div class="col-md-6">
                                    <h4 class="mb-0">Tổng tiền: <span id="totalAmount" class="text-success">0 ₫</span></h4>
                                </div>
                                <div class="col-md-6 text-end">
                                    <button type="submit" class="btn btn-success btn-action">
                                        <i class="fas fa-save"></i> Lưu hóa đơn
                                    </button>
                                    <a href="listbills" class="btn btn-outline-secondary btn-action ms-2">
                                        <i class="fas fa-times"></i> Hủy
                                    </a>
                                </div>
                            </div>
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

        // Khóa/mở các ô chi phí theo loại hóa đơn
        function toggleCostInputs() {
            const billType = document.getElementById('billType').value;
            const disable = billType === 'Chi';
            document.getElementById('electricityCost').disabled = disable;
            document.getElementById('waterCost').disabled = disable;
            // Phí dịch vụ luôn mở
            if (disable) {
                document.getElementById('electricityCost').value = 0;
                document.getElementById('waterCost').value = 0;
                calculateTotal();
            } else {
                document.getElementById('status').disabled = false;
            }
        }

        document.addEventListener('DOMContentLoaded', function() {
            const today = new Date();
            const dueDate = new Date(today.getTime() + (15 * 24 * 60 * 60 * 1000)); // 15 ngày sau
            document.getElementById('dueDate').value = dueDate.toISOString().split('T')[0];
            calculateTotal();
            // Gắn sự kiện cho billType
            document.getElementById('billType').addEventListener('change', toggleCostInputs);
            // Gọi lần đầu để set đúng trạng thái
            toggleCostInputs();
        });
    </script>
</body>
</html>