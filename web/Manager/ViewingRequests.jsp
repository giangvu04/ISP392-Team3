<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Quản lý yêu cầu xem phòng - Manager Dashboard</title>
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
            .stats-card {
                background: white;
                border-radius: 15px;
                padding: 25px;
                box-shadow: 0 10px 30px rgba(0,0,0,0.1);
                border-left: 5px solid;
                margin-bottom: 20px;
            }
            .stats-pending {
                border-left-color: #ffc107;
            }
            .stats-accepted {
                border-left-color: #28a745;
            }
            .stats-rejected {
                border-left-color: #dc3545;
            }
            .stats-total {
                border-left-color: #007bff;
            }

            .request-card {
                background: white;
                border-radius: 10px;
                margin-bottom: 20px;
                box-shadow: 0 5px 15px rgba(0,0,0,0.08);
                transition: transform 0.2s;
            }
            .request-card:hover {
                transform: translateY(-2px);
            }
            .request-header {
                background: #f8f9fa;
                border-radius: 10px 10px 0 0;
                padding: 15px 20px;
                border-left: 4px solid #007bff;
            }
            .request-body {
                padding: 20px;
            }
            .status-badge {
                font-size: 12px;
                padding: 6px 12px;
                border-radius: 20px;
                font-weight: 500;
            }
            .status-pending {
                background-color: #fff3cd;
                color: #856404;
            }
            .status-accepted {
                background-color: #d1edff;
                color: #084298;
            }
            .status-contacted {
                background-color: #d4edda;
                color: #155724;
            }
            .status-rejected {
                background-color: #f8d7da;
                color: #721c24;
            }

            .action-buttons {
                display: flex;
                gap: 8px;
                flex-wrap: wrap;
            }
            .btn-sm {
                font-size: 12px;
                padding: 4px 8px;
            }
            .unread-indicator {
                position: absolute;
                top: 10px;
                right: 10px;
                width: 12px;
                height: 12px;
                background-color: #dc3545;
                border-radius: 50%;
                animation: pulse 2s infinite;
            }
            @keyframes pulse {
                0% {
                    opacity: 1;
                }
                50% {
                    opacity: 0.5;
                }
                100% {
                    opacity: 1;
                }
            }
            .filter-section {
                background: white;
                border-radius: 10px;
                padding: 20px;
                margin-bottom: 30px;
                box-shadow: 0 5px 15px rgba(0,0,0,0.08);
            }
        </style>
    </head>
    <body>
        <div class="container-fluid">
            <div class="row">

                <jsp:include page="../Sidebar/SideBarManager.jsp"/>

                <!-- Main Content -->
                <div class="content-area">
                    <div class="d-flex justify-content-between align-items-center mb-4">
                        <div>
                            <h1 class="h3 mb-2">Quản lý yêu cầu xem phòng</h1>
                            <p class="text-muted">Xem và xử lý các yêu cầu xem phòng từ khách thuê</p>
                        </div>
                        <div>
                            <button class="btn btn-outline-primary" onclick="window.location.reload()">
                                <i class="fas fa-sync-alt me-2"></i>Làm mới
                            </button>
                        </div>
                    </div>

                    <!-- Statistics Cards -->
                    <div class="row mb-4">
                        <div class="col-md-3">
                            <div class="stats-card stats-pending">
                                <div class="d-flex align-items-center">
                                    <div class="flex-grow-1">
                                        <h5 class="mb-1">${pendingCount}</h5>
                                        <p class="mb-0 text-muted">Đang chờ xử lý</p>
                                    </div>
                                    <div class="text-warning">
                                        <i class="fas fa-clock fa-2x"></i>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="stats-card stats-accepted">
                                <div class="d-flex align-items-center">
                                    <div class="flex-grow-1">
                                        <h5 class="mb-1">${acceptedCount}</h5>
                                        <p class="mb-0 text-muted">Đã chấp nhận</p>
                                    </div>
                                    <div class="text-success">
                                        <i class="fas fa-check-circle fa-2x"></i>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="stats-card stats-rejected">
                                <div class="d-flex align-items-center">
                                    <div class="flex-grow-1">
                                        <h5 class="mb-1">${rejectedCount}</h5>
                                        <p class="mb-0 text-muted">Đã từ chối</p>
                                    </div>
                                    <div class="text-danger">
                                        <i class="fas fa-times-circle fa-2x"></i>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="stats-card stats-total">
                                <div class="d-flex align-items-center">
                                    <div class="flex-grow-1">
                                        <h5 class="mb-1">${totalCount}</h5>
                                        <p class="mb-0 text-muted">Tổng yêu cầu</p>
                                    </div>
                                    <div class="text-primary">
                                        <i class="fas fa-list fa-2x"></i>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Filter Section -->
                    <div class="filter-section">
                        <div class="row align-items-center">
                            <div class="col-md-3">
                                <select class="form-select" id="statusFilter">
                                    <option value="">Tất cả trạng thái</option>
                                    <option value="0">Đang chờ</option>
                                    <option value="1">Đã chấp nhận</option>
                                    <option value="2">Đã từ chối</option>
                                </select>
                            </div>
                            <div class="col-md-4">
                                <input type="text" class="form-control" id="searchInput" placeholder="Tìm kiếm theo tên, phòng, khu trọ...">
                            </div>
                            <div class="col-md-3">
                                <select class="form-select" id="sortBy">
                                    <option value="newest">Mới nhất</option>
                                    <option value="oldest">Cũ nhất</option>
                                    <option value="pending">Chờ xử lý trước</option>
                                </select>
                            </div>
                            <div class="col-md-2">
                                <button class="btn btn-outline-secondary w-100" onclick="clearFilters()">
                                    <i class="fas fa-eraser me-1"></i>Xóa bộ lọc
                                </button>
                            </div>
                        </div>
                    </div>

                    <!-- Viewing Requests List -->
                    <c:choose>
                        <c:when test="${not empty viewingRequests}">
                            <div id="requestsList">
                                <c:forEach var="request" items="${viewingRequests}" varStatus="status">
                                    <div class="request-card position-relative" data-status="${request.status}">
                                        <!-- Unread indicator for pending requests -->
                                        <c:if test="${request.status == 0}">
                                            <div class="unread-indicator"></div>
                                        </c:if>

                                        <div class="request-header">
                                            <div class="row align-items-center">
                                                <div class="col-md-8">
                                                    <h6 class="mb-1">
                                                        <i class="fas fa-user me-2"></i>${request.fullName}
                                                        <small class="text-muted">(ID: #${request.requestId})</small>
                                                    </h6>
                                                    <div class="d-flex align-items-center">
                                                        <span class="me-3">
                                                            <i class="fas fa-envelope me-1"></i>${request.email}
                                                        </span>
                                                        <span>
                                                            <i class="fas fa-phone me-1"></i>${request.phone}
                                                        </span>
                                                    </div>
                                                </div>
                                                <div class="col-md-4 text-end">
                                                    <c:choose>
                                                        <c:when test="${request.status == 0}">
                                                            <span class="status-badge status-pending">Đang chờ xử lý</span>
                                                        </c:when>
                                                        <c:when test="${request.status == 1}">
                                                            <span class="status-badge status-accepted">Đã chấp nhận</span>
                                                        </c:when>
                                                        <c:when test="${request.status == 2}">
                                                            <span class="status-badge status-rejected">Đã từ chối</span>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <span class="status-badge status-contacted">Đã liên hệ</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </div>
                                            </div>
                                        </div>

                                        <div class="request-body">
                                            <div class="row">
                                                <div class="col-md-6">
                                                    <h6><i class="fas fa-home me-2 text-primary"></i>Thông tin phòng</h6>
                                                    <c:choose>
                                                        <c:when test="${not empty request.roomsInfo}">
                                                            <p class="mb-1"><strong>Phòng:</strong> ${request.roomsInfo}</p>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <p class="mb-1"><strong>Bài đăng:</strong> ${request.postTitle}</p>
                                                        </c:otherwise>
                                                    </c:choose>
                                                    <c:if test="${not empty request.rentalAreaName}">
                                                        <p class="mb-1"><strong>Khu trọ:</strong> ${request.rentalAreaName}</p>
                                                        <p class="mb-0 text-muted"><i class="fas fa-map-marker-alt me-1"></i>${request.rentalAreaAddress}</p>
                                                        </c:if>
                                                </div>
                                                <div class="col-md-6">
                                                    <h6><i class="fas fa-calendar me-2 text-info"></i>Thời gian</h6>
                                                    <p class="mb-1">
                                                        <strong>Ngày gửi:</strong> 
                                                        <fmt:formatDate value="${request.createdAt}" pattern="dd/MM/yyyy HH:mm"/>
                                                    </p>
                                                    <c:if test="${not empty request.preferredDate}">
                                                        <p class="mb-1">
                                                            <strong>Thời gian mong muốn:</strong>
                                                            <fmt:formatDate value="${request.preferredDate}" pattern="dd/MM/yyyy HH:mm"/>
                                                        </p>
                                                    </c:if>
                                                    <c:if test="${not empty request.responseDate}">
                                                        <p class="mb-0">
                                                            <strong>Đã xử lý:</strong>
                                                            <fmt:formatDate value="${request.responseDate}" pattern="dd/MM/yyyy HH:mm"/>
                                                        </p>
                                                    </c:if>
                                                </div>
                                            </div>

                                            <c:if test="${not empty request.message}">
                                                <hr class="my-3">
                                                <h6><i class="fas fa-comment me-2 text-success"></i>Lời nhắn từ khách thuê</h6>
                                                <p class="bg-light p-3 rounded">${request.message}</p>
                                            </c:if>

                                            <c:if test="${not empty request.adminNote}">
                                                <hr class="my-3">
                                                <h6><i class="fas fa-reply me-2 text-warning"></i>Phản hồi của bạn</h6>
                                                <p class="bg-warning bg-opacity-10 p-3 rounded">${request.adminNote}</p>
                                            </c:if>

                                            <hr class="my-3">
                                            <div class="d-flex justify-content-between align-items-center">
                                                <div class="action-buttons">
                                                    <c:if test="${request.status == 0}">
                                                        <!-- Pending requests actions -->
                                                        <button class="btn btn-success btn-sm" onclick="showActionModal('accept', '${request.requestId}')">
                                                            <i class="fas fa-check me-1"></i>Chấp nhận
                                                        </button>
                                                        <button class="btn btn-danger btn-sm" onclick="showActionModal('reject', '${request.requestId}')">
                                                            <i class="fas fa-times me-1"></i>Từ chối
                                                        </button>
                                                        <button class="btn btn-primary btn-sm" onclick="showActionModal('createContract', '${request.requestId}')">
                                                            <i class="fas fa-file-contract me-1"></i>Tạo hợp đồng
                                                        </button>
                                                        <button class="btn btn-outline-info btn-sm" onclick="markAsRead('${request.requestId}')">
                                                            <i class="fas fa-check-double me-1"></i>Đánh dấu đã xem
                                                        </button>
                                                    </c:if>
                                                    
                                                    <c:if test="${request.status == 1}">
                                                        <!-- Viewed requests - keep Create Contract and Reject -->
                                                        <button class="btn btn-primary btn-sm" onclick="showActionModal('createContract', '${request.requestId}')">
                                                            <i class="fas fa-file-contract me-1"></i>Tạo hợp đồng
                                                        </button>
                                                        <button class="btn btn-danger btn-sm" onclick="showActionModal('reject', '${request.requestId}')">
                                                            <i class="fas fa-times me-1"></i>Từ chối
                                                        </button>
                                                    </c:if>
                                                </div>
                                                <div>
                                                    <small class="text-muted">
                                                        <c:choose>
                                                            <c:when test="${request.status != 0}">
                                                                <i class="fas fa-check-double text-success me-1"></i>Đã xử lý
                                                            </c:when>
                                                            <c:otherwise>
                                                                <i class="fas fa-circle text-danger me-1"></i>Chờ xử lý
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </small>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="text-center py-5">
                                <i class="fas fa-inbox fa-4x text-muted mb-4"></i>
                                <h4 class="text-muted">Chưa có yêu cầu xem phòng nào</h4>
                                <p class="text-muted">Khi có yêu cầu mới, chúng sẽ xuất hiện ở đây.</p>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

            <!-- Action Modal -->
            <div class="modal fade" id="actionModal" tabindex="-1">
                <div class="modal-dialog">
                    <div class="modal-content">
                        <form id="actionForm" method="post" action="processViewingRequest">
                            <div class="modal-header">
                                <h5 class="modal-title" id="actionModalTitle">Xác nhận hành động</h5>
                                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                            </div>
                            <div class="modal-body">
                                <input type="hidden" id="actionType" name="action" value="">
                                <input type="hidden" id="requestId" name="requestId" value="">

                                <p id="actionMessage"></p>

                                <div class="mb-3">
                                    <label for="adminNote" class="form-label">Ghi chú cho khách thuê (tùy chọn)</label>
                                    <textarea class="form-control" id="adminNote" name="adminNote" rows="3" 
                                              placeholder="Nhập lời nhắn gửi đến khách thuê..."></textarea>
                                </div>
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                                <button type="submit" class="btn btn-primary" id="confirmActionBtn">Xác nhận</button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>

            <!-- Scripts -->
            <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
            <script>
                                                            function showActionModal(action, requestId) {
                                                                document.getElementById('actionType').value = action;
                                                                document.getElementById('requestId').value = requestId;

                                                                const modal = document.getElementById('actionModal');
                                                                const title = document.getElementById('actionModalTitle');
                                                                const message = document.getElementById('actionMessage');
                                                                const confirmBtn = document.getElementById('confirmActionBtn');

                                                                switch (action) {
                                                                    case 'accept':
                                                                        title.textContent = 'Chấp nhận yêu cầu';
                                                                        message.textContent = 'Bạn có chắc chắn muốn chấp nhận yêu cầu xem phòng này?';
                                                                        confirmBtn.textContent = 'Chấp nhận';
                                                                        confirmBtn.className = 'btn btn-success';
                                                                        break;
                                                                    case 'reject':
                                                                        title.textContent = 'Từ chối yêu cầu';
                                                                        message.textContent = 'Bạn có chắc chắn muốn từ chối yêu cầu xem phòng này?';
                                                                        confirmBtn.textContent = 'Từ chối';
                                                                        confirmBtn.className = 'btn btn-danger';
                                                                        break;
                                                                    case 'createContract':
                                                                        title.textContent = 'Chấp nhận và tạo hợp đồng';
                                                                        message.textContent = 'Chấp nhận yêu cầu và chuyển đến trang tạo hợp đồng?';
                                                                        confirmBtn.textContent = 'Tạo hợp đồng';
                                                                        confirmBtn.className = 'btn btn-primary';
                                                                        break;
                                                                }

                                                                new bootstrap.Modal(modal).show();
                                                            }

                                                            function markAsRead(requestId) {
                                                                if (confirm('Đánh dấu yêu cầu này đã được xem (chuyển sang trạng thái Đã xem)?')) {
                                                                    const form = document.createElement('form');
                                                                    form.method = 'post';
                                                                    form.action = 'processViewingRequest';
                                                                    form.innerHTML = `
                            <input type="hidden" name="action" value="markRead">
                            <input type="hidden" name="requestId" value="${requestId}">
                        `;
                                                                    document.body.appendChild(form);
                                                                    form.submit();
                                                                }
                                                            }

                                                            // Filter functions
                                                            function clearFilters() {
                                                                document.getElementById('statusFilter').value = '';
                                                                document.getElementById('searchInput').value = '';
                                                                document.getElementById('sortBy').value = 'newest';
                                                                filterRequests();
                                                            }

                                                            function filterRequests() {
                                                                const statusFilter = document.getElementById('statusFilter').value;
                                                                const searchText = document.getElementById('searchInput').value.toLowerCase();
                                                                const sortBy = document.getElementById('sortBy').value;

                                                                const cards = Array.from(document.querySelectorAll('.request-card'));

                                                                // Filter
                                                                cards.forEach(card => {
                                                                    const status = card.dataset.status;
                                                                    const text = card.textContent.toLowerCase();

                                                                    const statusMatch = !statusFilter || status === statusFilter;
                                                                    const textMatch = !searchText || text.includes(searchText);

                                                                    card.style.display = (statusMatch && textMatch) ? 'block' : 'none';
                                                                });

                                                                // Sort visible cards
                                                                const visibleCards = cards.filter(card => card.style.display !== 'none');
                                                                // Simple sorting implementation could be added here
                                                            }

                                                            // Event listeners
                                                            document.getElementById('statusFilter').addEventListener('change', filterRequests);
                                                            document.getElementById('searchInput').addEventListener('input', filterRequests);
                                                            document.getElementById('sortBy').addEventListener('change', filterRequests);

                                                            // Auto refresh every 5 minutes
                                                            setInterval(function () {
                                                                if (confirm('Có yêu cầu mới. Bạn có muốn làm mới trang?')) {
                                                                    window.location.reload();
                                                                }
                                                            }, 300000);
            </script>
    </body>
</html>
