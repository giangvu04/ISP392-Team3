<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <title>Quản lý Hóa Đơn</title>
  <!-- Bootstrap 5 -->
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
  <!-- Font Awesome -->
  <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
  <style>
    body {
      background-color: #f1f3f5;
    }
    .header {
      background: #0056b3;
      color: #fff;
      padding: 1.5rem 0;
      margin-bottom: 1.5rem;
    }
    .header h1 {
      margin: 0;
      font-size: 2rem;
      font-weight: 500;
    }
    .card {
      border: none;
      border-radius: 0.75rem;
      box-shadow: 0 0.25rem 0.5rem rgba(0,0,0,0.1);
    }
    .form-section {
      background-color: #ffffff;
    }
    .table-responsive {
      background-color: #ffffff;
      border-radius: 0.75rem;
      box-shadow: 0 0.25rem 0.5rem rgba(0,0,0,0.1);
    }
  </style>
</head>
<body>

  <!-- Header -->
  <div class="header text-center">
    <h1><i class="fas fa-file-invoice-dollar"></i> Quản lý Hóa Đơn</h1>
  </div>

  <div class="container mb-5">

<!--     Form tạo hóa đơn 
    <div class="card form-section mb-4">
      <div class="card-body">
        <h5 class="card-title mb-4"><i class="fas fa-plus-circle text-primary"></i> Tạo hóa đơn mới</h5>
        <form action="Bill" method="POST" id="billForm">
          <div class="row g-3">
            <div class="col-md-6">
              <div class="form-floating">
                <input type="text" class="form-control" id="tenantName" name="tenantName" placeholder=" " required>
                <label for="tenantName">Tên khách thuê</label>
              </div>
            </div>
            <div class="col-md-6">
              <div class="form-floating">
                <input type="text" class="form-control" id="roomNumber" name="roomNumber" placeholder=" " required>
                <label for="roomNumber">Số phòng</label>
              </div>
            </div>

            <div class="col-md-3">
              <div class="form-floating">
                <input type="number" class="form-control" id="rentCost" name="rentCost" placeholder=" " required>
                <label for="rentCost">Tiền thuê phòng (VNĐ)</label>
              </div>
            </div>
            <div class="col-md-3">
              <div class="form-floating">
                <input type="number" class="form-control" id="electricityBill" name="electricityBill" placeholder=" " required>
                <label for="electricityBill">Tiền điện</label>
              </div>
            </div>
            <div class="col-md-3">
              <div class="form-floating">
                <input type="number" class="form-control" id="waterBill" name="waterBill" placeholder=" " required>
                <label for="waterBill">Tiền nước</label>
              </div>
            </div>
            <div class="col-md-3">
              <div class="form-floating">
                <input type="number" class="form-control" id="serviceBill" name="serviceBill" placeholder=" " required>
                <label for="serviceBill">Tiền dịch vụ</label>
              </div>
            </div>

            <div class="col-md-6">
              <div class="form-floating">
                <input type="date" class="form-control" id="dueDate" name="dueDate" placeholder=" " required>
                <label for="dueDate">Ngày đến hạn</label>
              </div>
            </div>
            <div class="col-md-6">
              <div class="form-floating">
                <input type="number" class="form-control" id="totalAmount" name="totalAmount" placeholder=" " readonly>
                <label for="totalAmount">Tổng tiền (Tự tính)</label>
              </div>
            </div>
          </div>

          <div class="mt-4 d-flex justify-content-end gap-2">
            <button type="reset" class="btn btn-outline-secondary"><i class="fas fa-eraser"></i> Xóa form</button>
            <button type="button" class="btn btn-warning" onclick="saveDraft()"><i class="fas fa-save"></i> Lưu tạm</button>
            <button type="submit" class="btn btn-primary"><i class="fas fa-paper-plane"></i> Lưu hóa đơn</button>
          </div>
        </form>
      </div>
    </div>-->

    <!-- Tìm kiếm và lọc -->
    <div class="row align-items-center mb-3">
      <div class="col-md-6">
        <input type="text" id="searchInput" class="form-control" placeholder="🔍 Tìm kiếm hóa đơn...">
      </div>
      <div class="col-md-3">
        <select id="filterStatus" class="form-select">
          <option value="all">Tất cả trạng thái</option>
          <option value="paid">Đã thanh toán</option>
          <option value="unpaid">Chưa thanh toán</option>
        </select>
      </div>
      <div class="col-md-3 text-end">
        <button class="btn btn-primary" onclick="searchInvoices()"><i class="fas fa-filter"></i> Lọc</button>
      </div>
    </div>

    <!-- Danh sách hóa đơn -->
    <div class="table-responsive">
      <table class="table table-hover align-middle">
        <thead class="table-dark">
          <tr>
            <th>ID</th>
            <th>Tên khách thuê</th>
            <th>Số phòng</th>
            <th>Tiền phòng</th>
            <th>Điện</th>
            <th>Nước</th>
            <th>Dịch vụ</th>
            <th>Tổng</th>
            <th>Ngày tạo</th>
            <th>Ngày đến hạn</th>
            <th>Trạng thái</th>
            <th>Hành động</th>
          </tr>
        </thead>
        <tbody id="billTableBody">
          <!-- Dữ liệu động -->
        </tbody>
      </table>
    </div>

  </div>

  <!-- JS -->
  <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
  <script>
            // Tính tổng tiền tự động
            function calculateTotal() {
                const electricity = parseFloat(document.getElementById('electricityBill').value) || 0;
                const water = parseFloat(document.getElementById('waterBill').value) || 0;
                const service = parseFloat(document.getElementById('serviceBill').value) || 0;
                const rent = parseFloat(document.getElementById('rentCost').value) || 0;
                const total = electricity + water + service + rent;
                document.getElementById('totalAmount').value = total.toFixed(2);
            }

            // Thêm event listeners cho các trường nhập liệu
            document.getElementById('electricityBill').addEventListener('input', calculateTotal);
            document.getElementById('waterBill').addEventListener('input', calculateTotal);
            document.getElementById('serviceBill').addEventListener('input', calculateTotal);

            // Lưu hóa đơn tạm thời
            function saveDraft() {
                const formData = new FormData(document.getElementById('billForm'));
                const draftData = {};
                formData.forEach((value, key) => {
                    draftData[key] = value;
                });
                localStorage.setItem('billDraft', JSON.stringify(draftData));
                alert('Đã lưu hóa đơn tạm thời!');
            }

            // Khôi phục hóa đơn tạm thời
            function loadDraft() {
                const draftData = localStorage.getItem('billDraft');
                if (draftData) {
                    const data = JSON.parse(draftData);
                    Object.keys(data).forEach(key => {
                        const input = document.getElementById(key);
                        if (input) {
                            input.value = data[key];
                        }
                    });
                    calculateTotal();
                }
            }

            // Xóa hóa đơn
            function deleteInvoice(id) {
                if (confirm('Bạn có chắc chắn muốn xóa hóa đơn này?')) {
                    // Gọi API xóa hóa đơn
                    fetch(`bill?id=${id}`, {
                        method: 'DELETE'
                    })
                    .then(response => response.json())
                    .then(data => {
                        if (data.success) {
                            alert('Xóa hóa đơn thành công!');
                            loadInvoices(); // Tải lại danh sách hóa đơn
                        } else {
                            alert('Có lỗi xảy ra khi xóa hóa đơn!');
                        }
                    });
                }
            }

            // Tải danh sách hóa đơn
            function loadInvoices() {
                fetch('bill')
                .then(response => response.json())
                .then(data => {
                    const tbody = document.getElementById('billTableBody');
                    tbody.innerHTML = '';
                    data.forEach(bill => {
                        const row = `
                            <tr>
                                <td>${bill.id}</td>
                                <td>${bill.tenantName}</td>
                                <td>${bill.roomNumber}</td>
                                <td>${bill.electricityBill}</td>
                                <td>${bill.waterBill}</td>
                                <td>${bill.serviceBill}</td>
                                <td>${bill.totalAmount}</td>
                               
                                <td>${bill.isPaid ? 'Đã thanh toán' : 'Chưa thanh toán'}</td>
                                <td>
                                    <div class="action-buttons">
                                        <button class="btn btn-sm btn-primary" onclick="editInvoice(${bill.id})">
                                            <i class="fas fa-edit"></i>
                                        </button>
                                        <button class="btn btn-sm btn-danger" onclick="deleteInvoice(${bill.id})">
                                            <i class="fas fa-trash"></i>
                                        </button>
                                    </div>
                                </td>
                            </tr>
                        `;
                        tbody.innerHTML += row;
                    });
                });
            }

            // Tìm kiếm hóa đơn
            function searchInvoices() {
                const searchTerm = document.getElementById('searchInput').value;
                const status = document.getElementById('filterStatus').value;
                
                fetch(`bill?search=${searchTerm}&status=${status}`)
                .then(response => response.json())
                .then(data => {
                    // Cập nhật bảng với kết quả tìm kiếm
                    const tbody = document.getElementById('billTableBody');
                    tbody.innerHTML = '';
                    data.forEach(bill => {
                        // Tương tự như trong hàm loadInvoices
                    });
                });
            }

            // Khởi tạo trang
            document.addEventListener('DOMContentLoaded', function() {
                loadInvoices();
                loadDraft();
            });
    </script>
</body>
</html>
</body>
</html>
