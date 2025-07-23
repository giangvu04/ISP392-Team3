<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Tạo hợp đồng thuê phòng - Manager Dashboard</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="css/homepage.css" rel="stylesheet">
    <style>
        body {
            background-color: #f8f9fa;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        .content-area {
            flex: 1;
            padding: 30px;
        }
        .form-container {
            background: white;
            border-radius: 15px;
            padding: 30px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
            margin-bottom: 30px;
        }
        .section-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 15px 20px;
            border-radius: 10px;
            margin-bottom: 20px;
        }
        .info-card {
            background: #f8f9fa;
            border-radius: 10px;
            padding: 20px;
            margin-bottom: 20px;
            border-left: 4px solid #007bff;
        }
        .form-group {
            margin-bottom: 1.5rem;
        }
        .required {
            color: #dc3545;
        }
        .btn-container {
            text-align: center;
            margin-top: 30px;
        }
    </style>
</head>
<body>
    <div class="container-fluid">
        <div class="row">
            <!-- Sidebar -->
            <jsp:include page="../Sidebar/SideBarManager.jsp"/>

            <!-- Main Content -->
            <div class="content-area">
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <div>
                        <h1 class="h3 mb-2">Tạo hợp đồng thuê phòng</h1>
                        <p class="text-muted">Tạo hợp đồng thuê phòng cho khách thuê</p>
                    </div>
                    <div>
                        <a href="manageViewingRequests" class="btn btn-outline-secondary">
                            <i class="fas fa-arrow-left me-2"></i>Quay lại
                        </a>
                    </div>
                </div>

                <form method="post" action="createContract" id="contractForm">
                    <input type="hidden" name="postId" value="${postId}">
                    <input type="hidden" name="tenantId" value="${tenantId}">

                    <!-- Thông tin khách thuê -->
                    <div class="form-container">
                        <div class="section-header">
                            <h5 class="mb-0">
                                <i class="fas fa-user me-2"></i>
                                Thông tin khách thuê
                            </h5>
                        </div>
                        
                        <c:if test="${not empty tenant}">
                            <div class="row">
                                <div class="col-md-6">
                                    <div class="info-card">
                                        <p class="mb-2"><strong>Họ tên:</strong> ${tenant.fullName}</p>
                                        <p class="mb-2"><strong>Email:</strong> ${tenant.email}</p>
                                        <p class="mb-0"><strong>Số điện thoại:</strong> ${tenant.phone}</p>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="info-card">
                                        <p class="mb-2"><strong>Địa chỉ:</strong> ${tenant.address}</p>
                                        <p class="mb-2"><strong>CCCD:</strong> ${tenant.citizenId}</p>
                                        <p class="mb-0"><strong>Ngày đăng ký:</strong> 
                                            <fmt:formatDate value="${tenant.createdAt}" pattern="dd/MM/yyyy"/>
                                        </p>
                                    </div>
                                </div>
                            </div>
                        </c:if>
                        
                        <c:if test="${not empty viewingRequest}">
                            <div class="alert alert-info">
                                <h6><i class="fas fa-info-circle me-2"></i>Thông tin từ yêu cầu xem phòng</h6>
                                <p class="mb-2"><strong>Tin nhắn:</strong> ${viewingRequest.message}</p>
                                <c:if test="${not empty viewingRequest.preferredDate}">
                                    <p class="mb-0"><strong>Thời gian mong muốn xem:</strong> 
                                        <fmt:formatDate value="${viewingRequest.preferredDate}" pattern="dd/MM/yyyy HH:mm"/>
                                    </p>
                                </c:if>
                            </div>
                        </c:if>
                    </div>

                    <!-- Chi tiết hợp đồng -->
                    <div class="form-container">
                        <div class="section-header">
                            <h5 class="mb-0">
                                <i class="fas fa-file-contract me-2"></i>
                                Chi tiết hợp đồng
                            </h5>
                        </div>

                        <div class="row">
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label for="monthlyRent" class="form-label">
                                        Giá thuê hàng tháng <span class="required">*</span>
                                    </label>
                                    <div class="input-group">
                                        <input type="number" class="form-control" id="monthlyRent" name="monthlyRent" 
                                               required min="0" step="1000" placeholder="VD: 5000000">
                                        <span class="input-group-text">VND</span>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label for="deposit" class="form-label">
                                        Tiền đặt cọc <span class="required">*</span>
                                    </label>
                                    <div class="input-group">
                                        <input type="number" class="form-control" id="deposit" name="deposit" 
                                               required min="0" step="1000" placeholder="VD: 5000000">
                                        <span class="input-group-text">VND</span>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label for="startDate" class="form-label">
                                        Ngày bắt đầu <span class="required">*</span>
                                    </label>
                                    <input type="date" class="form-control" id="startDate" name="startDate" required>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label for="contractTerm" class="form-label">
                                        Thời hạn hợp đồng <span class="required">*</span>
                                    </label>
                                    <div class="input-group">
                                        <input type="number" class="form-control" id="contractTerm" name="contractTerm" 
                                               required min="1" max="24" value="12" placeholder="12">
                                        <span class="input-group-text">tháng</span>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="endDate" class="form-label">Ngày kết thúc (tự động tính)</label>
                            <input type="text" class="form-control" id="endDate" readonly 
                                   placeholder="Sẽ được tính tự động khi chọn ngày bắt đầu và thời hạn">
                        </div>

                        <div class="form-group">
                            <label for="terms" class="form-label">
                                Điều khoản và điều kiện <span class="required">*</span>
                            </label>
                            <textarea class="form-control" id="terms" name="terms" rows="6" required
                                      placeholder="Nhập các điều khoản của hợp đồng thuê phòng...">1. Khách thuê có trách nhiệm thanh toán tiền thuê đúng hạn vào ngày ${paymentDate} hàng tháng.

2. Tiền đặt cọc sẽ được hoàn trả khi kết thúc hợp đồng, trừ các khoản thiệt hại (nếu có).

3. Khách thuê không được chuyển nhượng, cho thuê lại phòng mà không có sự đồng ý bằng văn bản của chủ nhà.

4. Khách thuê có trách nhiệm giữ gìn vệ sinh, trật tự và an toàn trong khu vực thuê.

5. Việc sử dụng điện, nước, internet và các dịch vụ khác theo quy định của chủ nhà.

6. Thông báo trước 30 ngày nếu muốn chấm dứt hợp đồng sớm.</textarea>
                        </div>
                    </div>

                    <!-- Nút thao tác -->
                    <div class="btn-container">
                        <button type="button" class="btn btn-secondary me-3" onclick="window.history.back()">
                            <i class="fas fa-times me-2"></i>Hủy bỏ
                        </button>
                        <button type="submit" class="btn btn-primary btn-lg">
                            <i class="fas fa-save me-2"></i>Tạo hợp đồng
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- Scripts -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Set minimum date to today
        document.getElementById('startDate').min = new Date().toISOString().split('T')[0];
        
        // Auto calculate end date
        function calculateEndDate() {
            const startDate = document.getElementById('startDate').value;
            const contractTerm = document.getElementById('contractTerm').value;
            
            if (startDate && contractTerm) {
                const start = new Date(startDate);
                const end = new Date(start);
                end.setMonth(end.getMonth() + parseInt(contractTerm));
                
                const endDateStr = end.toLocaleDateString('vi-VN');
                document.getElementById('endDate').value = endDateStr;
            }
        }
        
        document.getElementById('startDate').addEventListener('change', calculateEndDate);
        document.getElementById('contractTerm').addEventListener('change', calculateEndDate);
        
        // Auto suggest deposit (usually 1 month rent)
        document.getElementById('monthlyRent').addEventListener('blur', function() {
            const monthlyRent = this.value;
            const depositField = document.getElementById('deposit');
            
            if (monthlyRent && !depositField.value) {
                depositField.value = monthlyRent; // Suggest 1 month deposit
            }
        });
        
        // Form validation
        document.getElementById('contractForm').addEventListener('submit', function(e) {
            const monthlyRent = parseFloat(document.getElementById('monthlyRent').value);
            const deposit = parseFloat(document.getElementById('deposit').value);
            const startDate = document.getElementById('startDate').value;
            const contractTerm = parseInt(document.getElementById('contractTerm').value);
            
            if (monthlyRent <= 0) {
                e.preventDefault();
                alert('Giá thuê phải lớn hơn 0');
                return;
            }
            
            if (deposit < 0) {
                e.preventDefault();
                alert('Tiền đặt cọc không được âm');
                return;
            }
            
            if (!startDate) {
                e.preventDefault();
                alert('Vui lòng chọn ngày bắt đầu');
                return;
            }
            
            if (contractTerm < 1 || contractTerm > 24) {
                e.preventDefault();
                alert('Thời hạn hợp đồng phải từ 1 đến 24 tháng');
                return;
            }
            
            if (confirm('Bạn có chắc chắn muốn tạo hợp đồng này?')) {
                // Submit form
                return true;
            } else {
                e.preventDefault();
            }
        });
        
        // Initialize
        calculateEndDate();
    </script>
</body>
</html>
