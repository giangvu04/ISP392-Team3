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
                                        <label for="roomId" class="formLabel">Room ID *</label>
                                        <input type="number" class="form-control" id="roomId" name="roomId" 
                                               value="<%= contract.getRoomID() %>" required>
                                    </div>
                                    <div class="col-md-4">
                                        <label for="tenantId" class="formLabel">Tenant ID *</label>
                                        <input type="number" class="form-control" id="tenantId" name="tenantId" 
                                               value="<%= contract.getTenantsID() %>" required>
                                    </div>
                                    <div class="col-md-4">
                                        <label for="status" class="formLabel">Status *</label>
                                        <select class="form-select" id="status" name="status" required>
                                            <option value="0" <%= contract.getStatus() == 0 ? "selected" : "" %>>Chờ ký</option>
                                            <option value="1" <%= contract.getStatus() == 1 ? "selected" : "" %>>Đang hoạt động</option>
                                            <option value="2" <%= contract.getStatus() == 2 ? "selected" : "" %>>Tạm dừng</option>
                                            <option value="3" <%= contract.getStatus() == 3 ? "selected" : "" %>>Đã kết thúc</option>
                                        </select>
                                    </div>
                                </div>
                                
                                <div class="row mb-3">
                                    <div class="col-md-6">
                                        <label for="startDate" class="formLabel">Start Date *</label>
                                        <input type="date" class="form-control" id="startDate" name="startDate" 
                                               value="<%= contract.getStartDate() != null ? contract.getStartDate().toString() : "" %>" required>
                                    </div>
                                    <div class="col-md-6">
                                        <label for="endDate" class="formLabel">End Date</label>
                                        <input type="date" class="form-control" id="endDate" name="endDate" 
                                               value="<%= contract.getEndDate() != null ? contract.getEndDate().toString() : "" %>">
                                    </div>
                                </div>
                                
                                <div class="row mb-3">
                                    <div class="col-md-6">
                                        <label for="rentPrice" class="formLabel">Rent Price (VND) *</label>
                                        <input type="number" step="0.01" class="form-control" id="rentPrice" name="rentPrice" 
                                               value="<%= contract.getRentPrice() != null ? contract.getRentPrice().toString() : "" %>" required>
                                    </div>
                                    <div class="col-md-6">
                                        <label for="depositAmount" class="formLabel">Deposit Amount (VND)</label>
                                        <input type="number" step="0.01" class="form-control" id="depositAmount" name="depositAmount" 
                                               value="<%= contract.getDepositAmount() != null ? contract.getDepositAmount().toString() : "" %>">
                                    </div>
                                </div>
                                
                                <div class="mb-3">
                                    <label for="note" class="formLabel">Note</label>
                                    <textarea class="form-control" id="note" name="note" rows="3" placeholder="Additional notes or terms..."><%= contract.getNote() != null ? contract.getNote() : "" %></textarea>
                                </div>
                                
                                <div class="d-grid gap-2 d-md-flex justify-content-md-end">
                                    <button type="reset" class="btn btn-outline-secondary me-md-2">
                                        <i class="fas fa-undo me-1"></i> Reset
                                    </button>
                                    <button type="submit" class="btn btnPrimary">
                                        <i class="fas fa-save me-1"></i> Update Contract
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
    <script src="https://kit.fontawesome.com/a076d05399.js" crossorigin="anonymous"></script>
    
    <script>
        // Validation cho form
        document.querySelector('form').addEventListener('submit', function(e) {
            const startDate = document.getElementById('startDate').value;
            const endDate = document.getElementById('endDate').value;
            
            if (startDate && endDate) {
                const start = new Date(startDate);
                const end = new Date(endDate);
                
                if (end <= start) {
                    e.preventDefault();
                    alert('Ngày kết thúc phải sau ngày bắt đầu!');
                    return false;
                }
            }
            
            const rentPrice = parseFloat(document.getElementById('rentPrice').value);
            if (rentPrice <= 0) {
                e.preventDefault();
                alert('Giá thuê phải lớn hơn 0!');
                return false;
            }
            
            const depositAmount = parseFloat(document.getElementById('depositAmount').value);
            if (depositAmount < 0) {
                e.preventDefault();
                alert('Tiền đặt cọc không được âm!');
                return false;
            }
        });
    </script>
</body>
</html>