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
            body {
                background: #f8f9fa;
            }
            .main-content {
                min-height: 100vh;
                padding: 2rem;
            }
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
            .form-label {
                font-weight: 600;
            }
            .cost-input {
                text-align: right;
            }
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
                                            <label for="rentalArea" class="form-label">Chọn khu trọ <span class="text-danger">*</span></label>
                                            <select class="form-select" id="rentalArea" name="rentalArea" required onchange="loadRoomsByArea()">
                                                <option value="">Chọn khu trọ</option>
                                                <c:forEach var="area" items="${rentalAreas}">
                                                    <option value="${area.rentalAreaId}">${area.name}</option>
                                                </c:forEach>
                                            </select>
                                        </div>
                                        <div class="mb-3">
                                            <label for="roomSelection" class="form-label">Chọn phòng <span class="text-danger">*</span></label>
                                            <select class="form-select" id="roomSelection" name="roomSelection" required disabled>
                                                <option value="">Vui lòng chọn khu trọ trước</option>
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
                                            <label for="roomCost" class="form-label">Tiền phòng (₫)</label>
                                            <input type="number" class="form-control cost-input" id="roomCost" name="roomCost" value="0" min="0" step="1000" onchange="calculateTotal()">
                                        </div>
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
                                        <div class="mb-3">
                                            <label for="otherServiceCost" class="form-label">Dịch vụ khác (₫)</label>
                                            <input type="number" class="form-control cost-input" id="otherServiceCost" name="otherServiceCost" value="0" min="0" step="1000" onchange="calculateTotal()">
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
                                                    const roomCost = parseFloat(document.getElementById('roomCost').value) || 0;
                                                    const electricity = parseFloat(document.getElementById('electricityCost').value) || 0;
                                                    const water = parseFloat(document.getElementById('waterCost').value) || 0;
                                                    const service = parseFloat(document.getElementById('serviceCost').value) || 0;
                                                    const otherService = parseFloat(document.getElementById('otherServiceCost').value) || 0;

                                                    const billType = document.getElementById('billType').value;
                                                    let total;

                                                    if (billType === 'Chi') {
                                                        // Đối với hóa đơn chi, chỉ tính tiền dịch vụ khác và làm âm
                                                        total = -Math.abs(otherService);
                                                    } else {
                                                        // Đối với hóa đơn thu, tính tổng tất cả
                                                        total = roomCost + electricity + water + service + otherService;
                                                    }

                                                    document.getElementById('totalAmount').textContent = total.toLocaleString('vi-VN') + ' ₫';
                                                }

                                                // Khóa/mở các ô chi phí theo loại hóa đơn
                                                function toggleCostInputs() {
                                                    const billType = document.getElementById('billType').value;
                                                    const disable = billType === 'Chi';

                                                    // Khóa các trường không cần thiết cho hóa đơn chi
                                                    document.getElementById('roomCost').disabled = disable;
                                                    document.getElementById('electricityCost').disabled = disable;
                                                    document.getElementById('waterCost').disabled = disable;
                                                    document.getElementById('serviceCost').disabled = disable;

                                                    // Dịch vụ khác luôn mở cho cả thu và chi
                                                    if (disable) {
                                                        document.getElementById('roomCost').value = 0;
                                                        document.getElementById('electricityCost').value = 0;
                                                        document.getElementById('waterCost').value = 0;
                                                        document.getElementById('serviceCost').value = 0;
                                                        // Set trạng thái là Đã thanh toán và khóa select
                                                        document.getElementById('status').value = 'Paid';
                                                        document.getElementById('status').disabled = true;
                                                        calculateTotal();
                                                    } else {
                                                        document.getElementById('status').disabled = false;
                                                    }
                                                }

                                                // Load phòng theo khu trọ
                                                // Load phòng theo khu trọ
// Load phòng theo khu trọ
function loadRoomsByArea() {
    const areaId = document.getElementById('rentalArea').value;
    const roomSelect = document.getElementById('roomSelection');

    if (!areaId) {
        roomSelect.innerHTML = '<option value="">Vui lòng chọn khu trọ trước</option>';
        roomSelect.disabled = true;
        return;
    }

    // Hiển thị loading
    roomSelect.innerHTML = '<option value="">Đang tải...</option>';
    roomSelect.disabled = false;

    // Gọi AJAX để lấy danh sách phòng
    console.log('Loading rooms for area:', areaId);
    fetch('BillServlet?action=getRoomsByArea&areaId=' + areaId)
        .then(response => {
            console.log('Response status:', response.status);
            console.log('Response ok:', response.ok);
            if (!response.ok) {
                throw new Error('Network response was not ok: ' + response.status);
            }
            return response.text();
        })
        .then(data => {
            console.log('Raw response:', data);
            if (!data || data.trim() === '') {
                throw new Error('Empty response');
            }

            try {
                const rooms = JSON.parse(data);
                console.log('Parsed rooms:', rooms);

                roomSelect.innerHTML = '<option value="">Chọn phòng</option>';

                if (Array.isArray(rooms) && rooms.length > 0) {
                    rooms.forEach(room => {
                        const option = document.createElement('option');

                        // Tạo value với format: roomId|tenantId|tenantEmail
                        const value = [
                            room.roomId ?? '',
                            room.tenantId ?? '',
                            room.tenantEmail ?? ''
                        ].join('|');

                        option.value = value;

                        // Tạo text hiển thị 
                        let displayText = '';
                        const roomNumber = room.roomNumber || room.roomId;
                        
                        // Debug log
                        console.log('Room data:', room);
                        console.log('tenantName length:', room.tenantName ? room.tenantName.length : 'null');
                        console.log('roomNumber length:', roomNumber ? roomNumber.toString().length : 'null');
                        console.log('tenantName:', room.tenantName, 'tenantId:', room.tenantId, 'roomNumber:', roomNumber);
                        
                        if (room.tenantName && room.tenantName.trim() !== '' && room.tenantId) {
                            // Có người thuê: "Tên người thuê (Phòng xxx)"
                            displayText = room.tenantName + ' (Phòng ' + roomNumber + ')';
                        } else {
                            // Phòng trống: "Phòng xxx (Trống)"
                            displayText = 'Phòng ' + roomNumber + ' (Trống)';
                        }
                        
                        console.log('Display text:', displayText);
                        option.textContent = displayText;
                        console.log('Option created:', option.value, option.textContent);
                        roomSelect.appendChild(option);
                        console.log('Option added to select:', roomSelect.options[roomSelect.options.length - 1].textContent);
                    });

                    console.log('Total options added:', rooms.length);
                } else {
                    roomSelect.innerHTML = '<option value="">Không có phòng nào</option>';
                    console.log('No rooms available for area:', areaId);
                }
            } catch (e) {
                console.error('JSON parse error:', e, data);
                roomSelect.innerHTML = '<option value="">Lỗi dữ liệu - không thể parse JSON</option>';
            }
        })
        .catch(error => {
            console.error('Fetch error:', error);
            roomSelect.innerHTML = '<option value="">Lỗi tải phòng: ' + error.message + '</option>';
        });
}

                                                document.addEventListener('DOMContentLoaded', function () {
                                                    console.log('DOM loaded, checking rental areas...');
                                                    const rentalAreaSelect = document.getElementById('rentalArea');
                                                    console.log('Rental area options:', rentalAreaSelect.options.length);
                                                    for (let i = 0; i < rentalAreaSelect.options.length; i++) {
                                                        console.log('Option ' + i + ':', rentalAreaSelect.options[i].value, rentalAreaSelect.options[i].text);
                                                    }

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