<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Tenant Dashboard - Hệ thống Quản lý Ký túc xá</title>
        <base href="${pageContext.request.contextPath}/">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
        <link href="css/homepage.css" rel="stylesheet">
        <style>
            /* Tenant-specific styles (same as Manager in this case) */
            .stat-card, .stat-card-2, .stat-card-3, .stat-card-4 {
                min-height: 100px;
                height: 100px;
                display: flex;
                align-items: stretch;
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                color: white;
            }
            .stat-card-2 {
                background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
            }
            .stat-card-3 {
                background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
            }
            .stat-card-4 {
                background: linear-gradient(135deg, #43e97b 0%, #38f9d7 100%);
            }
        </style>
    </head>
    <body>
        <div class="container-fluid">
            <div class="row">
                <!-- Sidebar -->
                <jsp:include page="../Sidebar/SideBarTelnant.jsp"/>

                <!-- Main Content -->
                <div class="col-md-9 col-lg-10">
                    <div class="main-content p-4">
                        <!-- Header -->
                        <div class="d-flex justify-content-between align-items-center mb-4">
                            <div>
                                <h2 class="mb-1">Dashboard</h2>
                                <p class="text-muted mb-0">Chào mừng trở lại, ${user.fullName}!</p>
                            </div>
                            <div class="text-end">
                                <small class="text-muted">Hôm nay: <span id="current-date"></span></small>
                            </div>
                        </div>

                        <!-- Statistics Cards -->
                        <div class="row mb-4">
                            <div class="col-md-3 mb-3">
                                <div class="card stat-card">
                                    <div class="card-body">
                                        <div class="d-flex justify-content-between">
                                            <div>
                                                <h6 class="card-title">Phòng hiện tại</h6>
                                                <c:choose>
                                                    <c:when test="${currentRoom != null}">
                                                        <h3 class="mb-0">${currentRoom.roomNumber}</h3>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <h3 style="font-size: 14px" class="mb-0 text-warning">Bạn chưa thuê phòng nào</h3>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                            <div class="align-self-center">
                                                <i class="fas fa-bed fa-2x"></i>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-3 mb-3">
                                <div class="card stat-card-2">
                                    <div class="card-body">
                                        <div class="d-flex justify-content-between">
                                            <div>
                                                <h6 class="card-title">Hóa đơn chưa thanh toán</h6>
                                                <h3 class="mb-0">${unpaidBills.size()}</h3>
                                            </div>
                                            <div class="align-self-center">
                                                <i class="fas fa-exclamation-triangle fa-2x"></i>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-3 mb-3">
                                <div class="card stat-card-3">
                                    <div class="card-body">
                                        <div class="d-flex justify-content-between">
                                            <div>
                                                <h6 class="card-title">Dịch vụ đang sử dụng</h6>
                                                <h3 class="mb-0">${currentServices.size()}</h3>
                                            </div>
                                            <div class="align-self-center">
                                                <i class="fas fa-concierge-bell fa-2x"></i>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-3 mb-3">
                                <div class="card stat-card-4">
                                    <div class="card-body">
                                        <div class="d-flex justify-content-between">
                                            <div>
                                                <h6 class="card-title">Ngày còn lại</h6>
                                                <c:choose>
                                                    <c:when test="${daysLeft != -1}">
                                                        <h3 class="mb-0">${daysLeft}</h3>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <h3 style="font-size: 14px" class="mb-0 text-warning">Không có</h3>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                            <div class="align-self-center">
                                                <i class="fas fa-calendar-alt fa-2x"></i>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Quick Actions -->
                        <div class="row">
                            <div class="col-md-6 mb-4 d-flex align-items-stretch">
                                <div class="card flex-fill">
                                    <div class="card-header bg-primary text-white">
                                        <h5 class="mb-0">
                                            <i class="fas fa-bolt me-2"></i>
                                            Thao tác nhanh
                                        </h5>
                                    </div>
                                    <div class="card-body">
                                        <div class="row">
                                            <div class="col-6 mb-3">
                                                <a href="mycontract" class="btn btn-outline-primary w-100">
                                                    <i class="fas fa-file-contract me-2"></i>
                                                    Xem hợp đồng
                                                </a>
                                            </div>
                                            <div class="col-6 mb-3">
                                                <a href="listbills" class="btn btn-outline-success w-100">
                                                    <i class="fas fa-receipt me-2"></i>
                                                    Thanh toán
                                                </a>
                                            </div>
                                            <div class="col-6 mb-3">
                                                <a href="maintenanceList" class="btn btn-outline-info w-100">
                                                    <i class="fas fa-tools me-2"></i>
                                                    Báo sửa chữa
                                                </a>
                                            </div>
                                            <div class="col-6 mb-3">
                                                <a href="myservices" class="btn btn-outline-warning w-100">
                                                    <i class="fas fa-concierge-bell me-2"></i>
                                                    Dịch vụ
                                                </a>
                                            </div>
                                            <div class="col-6 mb-3">
                                                <a href="feedbacklist" class="btn btn-outline-secondary w-100">
                                                    <i class="fas fa-history me-2"></i>
                                                    Lịch sử feedback
                                                </a>
                                            </div>
                                            <!-- Nút gửi phản hồi/báo lỗi/hóa đơn riêng -->
                                            <div class="col-6 mb-3">
                                                <c:choose>
                                                    <c:when test="${currentRoom != null}">
                                                        <button type="button" class="btn btn-outline-danger w-100" 
                                                                data-bs-toggle="modal" data-bs-target="#feedbackModal"
                                                                onclick="prepareFeedbackModal('${currentRoom.roomId}', '${currentRoom.roomNumber}')">
                                                            <i class="fas fa-comment-dots me-2"></i>
                                                            Gửi phản hồi
                                                        </button>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <button type="button" class="btn btn-outline-danger w-100" disabled 
                                                                title="Bạn chưa có phòng để gửi feedback">
                                                            <i class="fas fa-comment-dots me-2"></i>
                                                            Gửi phản hồi
                                                        </button>
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                
                            </div>

                            <div class="col-md-6 mb-4">
                                <c:choose>
                                    <c:when test="${currentRoom != null}">
                                        <div class="card">
                                            <div class="card-header bg-success text-white">
                                                <h5 class="mb-0">
                                                    <i class="fas fa-info-circle me-2"></i>
                                                    Thông tin phòng
                                                </h5>
                                            </div>
                                            <div class="card-body">
                                                <div class="mb-3">
                                                    <div class="d-flex justify-content-between">
                                                        <span>Phòng số:</span>
                                                        <span class="fw-bold">${currentRoom.roomNumber}</span>
                                                    </div>
                                                </div>
                                                <div class="mb-3">
                                                    <div class="d-flex justify-content-between">
                                                        <span>Khu vực:</span>
                                                        <span class="fw-bold">${currentRoom.rentalAreaName}</span>
                                                    </div>
                                                </div>
                                                <div class="mb-3">
                                                    <div class="d-flex justify-content-between">
                                                        <span>Tiền phòng:</span>
                                                        <span class="fw-bold">
                                                            <c:choose>
                                                                <c:when test="${currentRoom.price != null}">
                                                                    <fmt:formatNumber value="${currentRoom.price}" type="number" groupingUsed="true" /> VNĐ/tháng
                                                                </c:when>
                                                                <c:otherwise>
                                                                    Không có
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </span>
                                                    </div>
                                                </div>
                                                
                                                <div class="mb-3">
                                                    <div class="d-flex justify-content-between">
                                                        <span>Ngày còn lại:</span>
                                                        <c:choose>
                                                            <c:when test="${daysLeft != -1}">
                                                                <span class="fw-bold">${daysLeft}</span>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="fw-bold text-warning">Không có</span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="card">
                                            <div class="card-header bg-warning text-dark">
                                                <h5 class="mb-0">
                                                    <i class="fas fa-info-circle me-2"></i>
                                                    Chưa có thông tin phòng
                                                </h5>
                                            </div>
                                            <div class="card-body">
                                                <div class="mb-3 text-center">
                                                    <span class="fw-bold text-warning">Bạn chưa thuê phòng nào. Vui lòng liên hệ quản lý để đăng ký phòng.</span>
                                                </div>
                                            </div>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>

                        <!-- Recent Activities -->
<!--                        <div class="row">
                            <div class="col-12">
                                <div class="card">
                                    <div class="card-header bg-info text-white">
                                        <h5 class="mb-0">
                                            <i class="fas fa-history me-2"></i>
                                            Hoạt động gần đây
                                        </h5>
                                    </div>
                                    <div class="card-body">
                                        <div class="list-group list-group-flush">
                                            <div class="list-group-item d-flex justify-content-between align-items-center">
                                                <div>
                                                    <i class="fas fa-receipt text-primary me-2"></i>
                                                    <span>Hóa đơn tháng 12/2024 đã được tạo</span>
                                                </div>
                                                <small class="text-muted">2 ngày trước</small>
                                            </div>
                                            <div class="list-group-item d-flex justify-content-between align-items-center">
                                                <div>
                                                    <i class="fas fa-check-circle text-success me-2"></i>
                                                    <span>Thanh toán hóa đơn tháng 11/2024</span>
                                                </div>
                                                <small class="text-muted">1 tuần trước</small>
                                            </div>
                                            <div class="list-group-item d-flex justify-content-between align-items-center">
                                                <div>
                                                    <i class="fas fa-tools text-warning me-2"></i>
                                                    <span>Yêu cầu sửa chữa đã được xử lý</span>
                                                </div>
                                                <small class="text-muted">2 tuần trước</small>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>-->
                    </div>
                </div>
            </div>
        </div>
                                <jsp:include page="../Message.jsp"/>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        <script>
            // Set current date
            document.getElementById('current-date').textContent = new Date().toLocaleDateString('vi-VN');

            // Add active class to current nav item
            document.addEventListener('DOMContentLoaded', function () {
                const currentPath = window.location.pathname;
                const navLinks = document.querySelectorAll('.nav-link');

                navLinks.forEach(link => {
                    if (link.getAttribute('href') && currentPath.includes(link.getAttribute('href'))) {
                        link.classList.add('active');
                    }
                });
            });
        </script>
                <!-- Feedback Modal -->
        <div class="modal fade" id="feedbackModal" tabindex="-1">
            <div class="modal-dialog">
                <div class="modal-content">
                    <form id="feedbackForm" action="feedback" method="post">
                        <div class="modal-header">
                            <h5 class="modal-title">Gửi feedback cho phòng <span id="feedbackRoomNumber"></span></h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                        </div>
                        <div class="modal-body">
                            <input type="hidden" id="feedbackRoomId" name="roomId" />
                            
                            <div class="mb-3">
                                <label for="feedbackContent" class="form-label">Nội dung phản hồi</label>
                                <textarea class="form-control" id="feedbackContent" name="content" 
                                          rows="4" placeholder="Chia sẻ trải nghiệm của bạn về phòng..." required></textarea>
                            </div>
                            
                            <div class="mb-3">
                                <label class="form-label">Đánh giá</label>
                                <div class="rating-input mb-2">
                                    <input type="radio" name="rating" value="5" id="star5" />
                                    <label for="star5" class="star">★</label>
                                    <input type="radio" name="rating" value="4" id="star4" />
                                    <label for="star4" class="star">★</label>
                                    <input type="radio" name="rating" value="3" id="star3" />
                                    <label for="star3" class="star">★</label>
                                    <input type="radio" name="rating" value="2" id="star2" />
                                    <label for="star2" class="star">★</label>
                                    <input type="radio" name="rating" value="1" id="star1" />
                                    <label for="star1" class="star">★</label>
                                </div>
                                <small class="text-muted">Chọn số sao để đánh giá (tùy chọn)</small>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                            <button type="submit" class="btn btn-primary">
                                <i class="fas fa-paper-plane me-2"></i>Gửi feedback
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
        
        <!-- CSS for star rating -->
        <style>
            .rating-input {
                display: flex;
                flex-direction: row-reverse;
                justify-content: flex-end;
            }
            
            .rating-input input[type="radio"] {
                display: none;
            }
            
            .rating-input .star {
                font-size: 2rem;
                color: #ddd;
                cursor: pointer;
                transition: color 0.2s;
                margin-right: 5px;
            }
            
            .rating-input input[type="radio"]:checked ~ .star,
            .rating-input .star:hover,
            .rating-input .star:hover ~ .star {
                color: #ffc107;
            }
        </style>
        
        <!-- JavaScript for modal -->
        <script>
            function prepareFeedbackModal(roomId, roomNumber) {
                document.getElementById('feedbackRoomId').value = roomId;
                document.getElementById('feedbackRoomNumber').textContent = roomNumber;
                
                // Reset form
                document.getElementById('feedbackForm').reset();
                
                // Clear star selection
                document.querySelectorAll('input[name="rating"]').forEach(radio => {
                    radio.checked = false;
                });
            }
        </script>
    </body>
</html> 