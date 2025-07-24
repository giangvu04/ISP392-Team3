<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.Contracts"%>
<%@page import="java.math.BigDecimal"%>
<%@page import="java.sql.Date"%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Update Contract</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link href="css/homepage.css" rel="stylesheet">
    <style>
        :root {
            --primary-gradient: linear-gradient(135deg, #6B73FF 0%, #000DFF 100%);
            --sidebar-bg: linear-gradient(135deg, #4e54c8 0%, #8f94fb 100%);
            --card-shadow: 0 6px 10px rgba(0,0,0,0.08);
        }
        
        .sidebar {
            min-height: 100vh;
            background: var(--sidebar-bg);
        }
        
        .sidebar .navLink {
            color: rgba(255,255,255,0.85);
            padding: 12px 20px;
            margin: 4px 0;
            border-radius: 8px;
            transition: all 0.3s ease;
        }
        
        .sidebar .navLink:hover, 
        .sidebar .navLink.active {
            background-color: rgba(255,255,255,0.15);
            color: white;
            transform: translateX(5px);
        }
        
        .mainContent {
            background-color: #f5f7ff;
            min-height: 100vh;
        }
        
        .card {
            border: none;
            border-radius: 12px;
            box-shadow: var(--card-shadow);
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }
        
        .card:hover {
            transform: translateY(-5px);
            box-shadow: 0 12px 20px rgba(0,0,0,0.1);
        }
        
        .formSection {
            background: white;
            border-radius: 12px;
            padding: 2rem;
            box-shadow: var(--card-shadow);
        }
        
        .btnPrimary {
            background: var(--primary-gradient);
            border: none;
            padding: 10px 25px;
            border-radius: 8px;
            color: white;
        }
        
        .btnPrimary:hover {
            opacity: 0.9;
            color: white;
        }
        
        .formLabel {
            font-weight: 500;
            color: #555;
        }
        
        .alert {
            border-radius: 8px;
        }
        
        .contractHeader {
            background: var(--primary-gradient);
            color: white;
            padding: 1rem;
            border-radius: 12px 12px 0 0;
            margin-bottom: 1.5rem;
        }
        
        .status-badge {
            padding: 4px 12px;
            border-radius: 20px;
            font-size: 0.85em;
            font-weight: 500;
        }
        
        .status-0 { background-color: #e3f2fd; color: #1976d2; }
        .status-1 { background-color: #e8f5e8; color: #2e7d32; }
        .status-2 { background-color: #fff3e0; color: #f57c00; }
        .status-3 { background-color: #ffebee; color: #d32f2f; }
        
        .date-preview {
            background-color: #e3f2fd;
            padding: 15px;
            border-radius: 8px;
            margin-top: 10px;
            transition: all 0.3s ease;
            border: 1px solid #bbdefb;
        }
        
        .date-preview i {
            color: #1976d2;
            margin-right: 8px;
        }
    </style>
</head>
<body>
    <div class="container-fluid">
        <div class="row">
            <!-- Sidebar -->
            <jsp:include page="../Sidebar/SideBarManager.jsp"/>

            <!-- Main content -->
            <main class="col-md-9 ms-sm-auto col-lg-10 px-md-4 mainContent">
                <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
                    <h1 class="h2">Update Contract</h1>
                    <div class="btn-toolbar mb-2 mb-md-0">
                        <a href="listcontracts?action=list" class="btn btn-sm btn-outline-secondary">
                            <i class="fas fa-arrow-left me-1"></i> Back to Contracts
                        </a>
                    </div>
                </div>

                <!-- Messages -->
                <%
                    String successMessage = (String) session.getAttribute("successMessage");
                    String errorMessage = (String) session.getAttribute("errorMessage");
                    
                    if (successMessage != null) {
                        session.removeAttribute("successMessage");
                %>
                    <div class="alert alert-success alert-dismissible fade show" role="alert">
                        <i class="fas fa-check-circle me-2"></i><%= successMessage %>
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                <%
                    }
                    
                    if (errorMessage != null) {
                        session.removeAttribute("errorMessage");
                %>
                    <div class="alert alert-danger alert-dismissible fade show" role="alert">
                        <i class="fas fa-exclamation-circle me-2"></i><%= errorMessage %>
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                <%
                    }
                %>

                <div class="row">
                    <div class="col-lg-10 mx-auto">
                        <div class="formSection">
                            <% Contracts contract = (Contracts) request.getAttribute("contract"); %>
                            <% if (contract != null) { %>
                            <div class="contractHeader">
                                <h3 class="mb-0">Contract #<%= contract.getContractId() %></h3>
                                <small>Room ID: <%= contract.getRoomID() %> | Tenant ID: <%= contract.getTenantsID() %></small>
                            </div>
                            
                            <form action="listcontracts" method="POST">
                                <input type="hidden" name="action" value="update">
                                <input type="hidden" name="contractId" value="<%= contract.getContractId() %>">
                                <div class="row mb-3">
                                    <div class="col-md-4">
                                        <label class="formLabel">Room ID *</label>
                                        <input type="number" name="roomId" class="form-control" value="<%= contract.getRoomID() %>" readonly>
                                    </div>
                                    <div class="col-md-4">
                                        <label class="formLabel">Tenant ID *</label>
                                        <input name="tenantId" type="number" class="form-control" value="<%= contract.getTenantsID() %>" readonly>
                                    </div>
                                    <div class="col-md-4">
                                        <label for="status" class="formLabel">Status *</label>
                                        <select class="form-select" id="status" name="status" required>
                                            <option value="1" <%= contract.getStatus() == 1 ? "selected" : "" %>>Đang hoạt động</option>
                                            <option value="3" <%= contract.getStatus() == 2 ? "selected" : "" %>>Đã kết thúc</option>
                                        </select>
                                    </div>
                                </div>
                                <div class="row mb-3">
                                    <div class="col-md-6">
                                        <label class="formLabel">Start Date *</label>
                                        <input type="date" name="startDate" class="form-control" value="<%= contract.getStartDate() != null ? contract.getStartDate().toString() : "" %>" readonly>
                                    </div>
                                    <div class="col-md-6">
                                        <label for="renewMonths" class="formLabel">Gia hạn thêm *</label>
                                        <select class="form-select" id="renewMonths" name="renewMonths" required>
                                            <option value="0">Không gia hạn</option>
                                            <option value="6">6 tháng</option>
                                            <option value="12">12 tháng</option>
                                        </select>
                                    </div>
                                </div>
                                <div class="row mb-3">
                                    <div class="col-md-6">
                                        <label class="formLabel">Rent Price (VND) *</label>
                                        <input name="rentPrice" type="number" step="0.01" class="form-control" value="<%= contract.getRentPrice() != null ? contract.getRentPrice().toString() : "" %>" readonly>
                                    </div>
                                    <div class="col-md-6">
                                        <label class="formLabel">Deposit Amount (VND)</label>
                                        <input name="depositAmount" type="number" step="0.01" class="form-control" value="<%= contract.getDepositAmount() != null ? contract.getDepositAmount().toString() : "" %>" readonly>
                                    </div>
                                </div>
                                <div class="mb-3">
                                    <label class="formLabel">Note</label>
                                    <textarea name="note" class="form-control" rows="3" readonly><%= contract.getNote() != null ? contract.getNote() : "" %></textarea>
                                </div>
                                <div class="mb-3">
                                    <label class="formLabel">Ngày kết thúc hiện tại</label>
                                    <input type="date" class="form-control" value="<%= contract.getEndDate() != null ? contract.getEndDate().toString() : "" %>" readonly>
                                </div>
                                <div class="mb-3">
                                    <label class="formLabel">Ngày kết thúc mới (dự kiến)</label>
                                    <div class="date-preview">
                                        <i class="fas fa-calendar-alt"></i>
                                        <span id="newEndDateText">Chọn thời gian gia hạn để xem ngày kết thúc mới</span>
                                    </div>
                                    <input type="hidden" id="newEndDate" name="newEndDate">
                                    <small class="text-muted">Giá trị gửi về DB: <span id="debugValue">chưa có</span></small>
                                </div>
                                <div class="d-grid gap-2 d-md-flex justify-content-md-end">
                                    <button type="submit" class="btn btnPrimary">
                                        <i class="fas fa-save me-1"></i> Gia hạn hợp đồng
                                    </button>
                                </div>
                            </form>
                            <% } else { %>
                            <div class="alert alert-danger">
                                <i class="fas fa-exclamation-triangle me-2"></i>
                                Contract information not found. Please select a contract from the list.
                            </div>
                            <% } %>
                        </div>
                    </div>
                </div>
            </main>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    
    <script>
    document.addEventListener('DOMContentLoaded', function() {
        var renewSelect = document.getElementById('renewMonths');
        var newEndDateInput = document.getElementById('newEndDate');
        var newEndDateText = document.getElementById('newEndDateText');
        var debugValue = document.getElementById('debugValue');
        var oldEndDateStr = '<%= contract.getEndDate() != null ? contract.getEndDate().toString() : "" %>';
        
        function formatDate(date) {
            if (!(date instanceof Date) || isNaN(date.getTime())) {
                return "Ngày không hợp lệ";
            }
            
            try {
                var yyyy = date.getFullYear();
                var mm = (date.getMonth() + 1).toString().padStart(2, '0');
                var dd = date.getDate().toString().padStart(2, '0');
                return yyyy + '-' + mm + '-' + dd;
            } catch (error) {
                console.error('Error formatting date:', error);
                return "Không thể định dạng ngày";
            }
        }

        function updateEndDate() {
            var months = parseInt(renewSelect.value);
            if (months === 0) {
                // Không gia hạn, gửi giá trị ngày kết thúc hiện tại
                var currentEndDate = oldEndDateStr ? new Date(oldEndDateStr) : new Date();
                if (isNaN(currentEndDate.getTime())) currentEndDate = new Date();
                var yyyy = currentEndDate.getFullYear();
                var mm = (currentEndDate.getMonth() + 1).toString().padStart(2, '0');
                var dd = currentEndDate.getDate().toString().padStart(2, '0');
                newEndDateInput.value = yyyy + '-' + mm + '-' + dd;
                debugValue.textContent = newEndDateInput.value;
                newEndDateText.innerHTML = '<span class="text-muted">Không gia hạn, giữ nguyên ngày kết thúc hiện tại: <strong>' + formatDate(currentEndDate) + '</strong></span>';
                newEndDateText.style.opacity = '0';
                setTimeout(function() { newEndDateText.style.opacity = '1'; }, 200);
                return;
            }
            var baseDate = oldEndDateStr ? new Date(oldEndDateStr) : new Date();
            if (isNaN(baseDate.getTime())) baseDate = new Date();
            baseDate.setMonth(baseDate.getMonth() + months);
            var yyyy = baseDate.getFullYear();
            var mm = (baseDate.getMonth() + 1).toString().padStart(2, '0');
            var dd = baseDate.getDate().toString().padStart(2, '0');
            if (!isNaN(baseDate.getTime())) {
                newEndDateInput.value = yyyy + '-' + mm + '-' + dd;
                debugValue.textContent = newEndDateInput.value;
                newEndDateText.innerHTML = "<strong>" + formatDate(baseDate) + "</strong>";
            } else {
                newEndDateInput.value = "";
                debugValue.textContent = "không có giá trị";
                newEndDateText.innerHTML = "Không thể tính ngày kết thúc (ngày hiện tại không hợp lệ)";
            }
            newEndDateText.style.opacity = '0';
            setTimeout(function() { newEndDateText.style.opacity = '1'; }, 200);
        }

        renewSelect.addEventListener('change', updateEndDate);
        updateEndDate();
    });
</script>
</body>
</html>