<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Feedback của tôi - Tenant Dashboard</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
        <style>
            .sidebar {
                min-height: 100vh;
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            }
            .sidebar .nav-link {
                color: rgba(255,255,255,0.8);
                padding: 12px 20px;
                margin: 4px 0;
                border-radius: 8px;
                transition: all 0.3s ease;
            }
            .sidebar .nav-link:hover, .sidebar .nav-link.active {
                color: white;
                background: rgba(255,255,255,0.1);
                transform: translateX(5px);
            }
            .main-content {
                background: #f8f9fa;
                min-height: 100vh;
            }
            .card {
                border: none;
                border-radius: 15px;
                box-shadow: 0 4px 6px rgba(0,0,0,0.1);
                transition: transform 0.3s ease;
            }
            .card:hover {
                transform: translateY(-5px);
            }
            .stats-card {
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                color: white;
            }
            .stats-card-2 {
                background: linear-gradient(135deg, #f093fb 0%, #f5576c 100%);
                color: white;
            }
            .stats-card-3 {
                background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
                color: white;
            }
            .table {
                border-radius: 10px;
                overflow: hidden;
            }
            .btn-action {
                border-radius: 20px;
                padding: 8px 16px;
                font-size: 0.875rem;
                transition: all 0.3s ease;
            }
            .btn-action:hover {
                transform: translateY(-2px);
                box-shadow: 0 2px 5px rgba(0,0,0,0.2);
            }
            .search-box {
                border-radius: 25px;
                border: 2px solid #e9ecef;
                padding: 10px 20px;
            }
            .search-box:focus {
                border-color: #667eea;
                box-shadow: 0 0 0 0.2rem rgba(102, 126, 234, 0.25);
            }
            .rating-stars {
                color: #ffc107;
                font-size: 1.2rem;
            }
            .feedback-content {
                max-width: 250px;
                overflow: hidden;
                text-overflow: ellipsis;
                white-space: nowrap;
            }
            .feedback-content:hover {
                white-space: normal;
                overflow: visible;
                text-overflow: none;
            }
            .user-info {
                background: rgba(255,255,255,0.1);
                border-radius: 10px;
                padding: 15px;
                margin-bottom: 20px;
            }
            .pagination-section {
                margin-top: 20px;
                display: flex;
                justify-content: center;
                align-items: center;
            }
            .pagination-section .page-item .page-link {
                border-radius: 20px;
                margin: 0 5px;
                color: #667eea;
                background: #fff;
                border: 1px solid #e9ecef;
                transition: all 0.3s ease;
                padding: 8px 14px;
            }
            .pagination-section .page-item.active .page-link {
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                border-color: #667eea;
                color: white;
            }
            .pagination-section .page-item.disabled .page-link {
                color: #6c757d;
                background: #f8f9fa;
                border-color: #e9ecef;
                cursor: not-allowed;
            }
            .pagination-section .page-link:hover {
                background: #e9ecef;
                border-color: #667eea;
                color: #667eea;
            }
            .rating-input {
                display: flex;
                gap: 5px;
                font-size: 1.5rem;
            }
            .rating-input .star {
                cursor: pointer;
                color: #ddd;
                transition: color 0.2s ease;
            }
            .rating-input .star:hover,
            .rating-input .star.active {
                color: #ffc107;
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
                                <h2 class="mb-1"><i class="fas fa-comments"></i> Feedback của tôi</h2>
                                <p class="text-muted mb-0">Quản lý feedback và đánh giá của bạn về phòng</p>
                            </div>
                            <button type="button" class="btn btn-primary btn-action" onclick="showAddFeedbackModal()">
                                <i class="fas fa-plus me-2"></i>Thêm feedback
                            </button>
                        </div>

                        <!-- Alert Messages -->
                        <c:if test="${not empty success}">
                            <div class="alert alert-success alert-dismissible fade show" role="alert">
                                <i class="fas fa-check-circle me-2"></i>${success}
                                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                            </div>
                        </c:if>
                        <c:if test="${not empty error}">
                            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                                <i class="fas fa-exclamation-circle me-2"></i>${error}
                                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                            </div>
                        </c:if>

                        <!-- Stats Cards -->
                        <div class="row mb-4">
                            <div class="col-md-6">
                                <div class="card stats-card">
                                    <div class="card-body">
                                        <div class="d-flex justify-content-between">
                                            <div>
                                                <h6 class="card-title mb-2">Tổng Feedback của bạn</h6>
                                                <h3 class="mb-0">${totalMyFeedbacks}</h3>
                                            </div>
                                            <div class="align-self-center">
                                                <i class="fas fa-comments fa-2x opacity-75"></i>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="card stats-card-3">
                                    <div class="card-body">
                                        <div class="d-flex justify-content-between">
                                            <div>
                                                <h6 class="card-title mb-2">Đánh giá trung bình</h6>
                                                <h3 class="mb-0">
                                                    <fmt:formatNumber value="${myAverageRating}" maxFractionDigits="1"/>
                                                    <i class="fas fa-star rating-stars ms-1"></i>
                                                </h3>
                                            </div>
                                            <div class="align-self-center">
                                                <i class="fas fa-star fa-2x opacity-75"></i>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- My Feedbacks Table -->
                        <div class="card">
                            <div class="card-header bg-white">
                                <h5 class="mb-0"><i class="fas fa-list me-2"></i>Lịch sử Feedback của bạn</h5>
                            </div>
                            <div class="card-body p-0">
                                <div class="table-responsive">
                                    <table class="table table-hover mb-0">
                                        <thead class="table-light">
                                            <tr>
                                                <th>ID</th>
                                                <th>Phòng</th>
                                                <th>Nội dung</th>
                                                <th>Đánh giá</th>
                                                <th>Ngày tạo</th>
                                                <th>Thao tác</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach var="feedback" items="${myFeedbacks}">
                                                <tr>
                                                    <td><strong>#${feedback.feedbackId}</strong></td>
                                                    <td>
                                                        <span class="badge bg-info">Phòng ${feedback.roomId}</span>
                                                    </td>
                                                    <td>
                                                        <div class="feedback-content" title="${feedback.content}">
                                                            ${feedback.content}
                                                        </div>
                                                    </td>
                                                    <td>
                                                        <c:choose>
                                                            <c:when test="${feedback.rating != null}">
                                                                <div class="rating-stars">
                                                                    <c:forEach begin="1" end="5" var="i">
                                                                        <i class="fas fa-star ${i <= feedback.rating ? '' : 'text-muted'}"></i>
                                                                    </c:forEach>
                                                                </div>
                                                                <small class="text-muted">(${feedback.rating}/5)</small>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <span class="text-muted">Không có đánh giá</span>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                    <td>
                                                        <fmt:formatDate value="${feedback.createdAt}" pattern="dd/MM/yyyy HH:mm"/>
                                                    </td>
                                                    <td>
                                                        <div class="btn-group" role="group">
                                                            <button type="button" class="btn btn-sm btn-outline-warning btn-action" 
                                                                    onclick="editFeedback('${feedback.feedbackId}', '${feedback.content}', '${feedback.rating}', '${feedback.roomId}')">
                                                                <i class="fas fa-edit me-1"></i>Sửa
                                                            </button>
                                                            <button type="button" class="btn btn-sm btn-outline-danger btn-action" 
                                                                    onclick="deleteFeedback('${feedback.feedbackId}')">
                                                                <i class="fas fa-trash me-1"></i>Xóa
                                                            </button>
                                                        </div>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        </div>

                        <!-- Empty State -->
                        <c:if test="${empty myFeedbacks}">
                            <div class="text-center mt-5">
                                <i class="fas fa-comments fa-4x text-muted mb-3"></i>
                                <h4 class="text-muted">Bạn chưa có feedback nào</h4>
                                <p class="text-muted">Hãy thêm feedback đầu tiên để đánh giá phòng của bạn</p>
                                <button type="button" class="btn btn-primary btn-action" onclick="showAddFeedbackModal()">
                                    <i class="fas fa-plus me-2"></i>Thêm feedback đầu tiên
                                </button>
                            </div>
                        </c:if>
                    </div>
                </div>
            </div>
        </div>

        <!-- Add/Edit Feedback Modal -->
        <div class="modal fade" id="feedbackModal" tabindex="-1">
            <div class="modal-dialog modal-lg">
                <div class="modal-content">
                    <form id="feedbackForm" action="" method="post">
                        <div class="modal-header">
                            <h5 class="modal-title" id="feedbackModalTitle"><i class="fas fa-comments me-2"></i>Thêm Feedback</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                        </div>
                        <div class="modal-body">
                            <input type="hidden" id="feedbackId" name="feedbackId" value="">
                            <input type="hidden" id="action" name="action" value="add">
                            
                            <div class="mb-3">
                                <label for="roomId" class="form-label">Phòng <span class="text-danger">*</span></label>
                                <select class="form-select" id="roomId" name="roomId" required>
                                    <option value="">-- Chọn phòng --</option>
                                    <c:forEach var="room" items="${availableRooms}">
                                        <option value="${room.roomId}">Phòng ${room.roomNumber} - ${room.rentalAreaName}</option>
                                    </c:forEach>
                                </select>
                            </div>
                            
                            <div class="mb-3">
                                <label for="content" class="form-label">Nội dung feedback <span class="text-danger">*</span></label>
                                <textarea class="form-control" id="content" name="content" rows="4" 
                                          placeholder="Nhập nội dung feedback của bạn về phòng..." required></textarea>
                            </div>
                            
                            <div class="mb-3">
                                <label class="form-label">Đánh giá (tùy chọn)</label>
                                <div class="rating-input" id="ratingInput">
                                    <i class="fas fa-star star" data-rating="1"></i>
                                    <i class="fas fa-star star" data-rating="2"></i>
                                    <i class="fas fa-star star" data-rating="3"></i>
                                    <i class="fas fa-star star" data-rating="4"></i>
                                    <i class="fas fa-star star" data-rating="5"></i>
                                </div>
                                <input type="hidden" id="rating" name="rating" value="">
                                <small class="form-text text-muted">Nhấp vào sao để đánh giá (1-5 sao)</small>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                            <button type="submit" class="btn btn-success" id="submitBtn">
                                <i class="fas fa-save me-2"></i>Lưu feedback
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <!-- Delete Confirmation Modal -->
        <div class="modal fade" id="deleteModal" tabindex="-1">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title"><i class="fas fa-exclamation-triangle text-danger me-2"></i>Xác nhận xóa</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body">
                        <p>Bạn có chắc chắn muốn xóa feedback này không?</p>
                        <p class="text-muted"><small>Hành động này không thể hoàn tác.</small></p>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                        <form id="deleteForm" action="" method="post" style="display: inline;">
                            <input type="hidden" name="action" value="delete">
                            <input type="hidden" id="deleteId" name="feedbackId" value="">
                            <button type="submit" class="btn btn-danger">
                                <i class="fas fa-trash me-2"></i>Xóa
                            </button>
                        </form>
                    </div>
                </div>
            </div>
        </div>

        <!-- Bootstrap JS -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

        <script>
            let selectedRating = 0;

            // Khởi tạo rating input
            document.addEventListener('DOMContentLoaded', function() {
                const stars = document.querySelectorAll('.star');
                
                stars.forEach(star => {
                    star.addEventListener('click', function() {
                        selectedRating = parseInt(this.dataset.rating);
                        document.getElementById('rating').value = selectedRating;
                        updateStars();
                    });
                    
                    star.addEventListener('mouseover', function() {
                        const hoverRating = parseInt(this.dataset.rating);
                        highlightStars(hoverRating);
                    });
                });
                
                document.getElementById('ratingInput').addEventListener('mouseleave', function() {
                    updateStars();
                });
            });

            function highlightStars(rating) {
                const stars = document.querySelectorAll('.star');
                stars.forEach((star, index) => {
                    if (index < rating) {
                        star.classList.add('active');
                    } else {
                        star.classList.remove('active');
                    }
                });
            }

            function updateStars() {
                highlightStars(selectedRating);
            }

            // Hiển thị modal thêm feedback
            function showAddFeedbackModal() {
                document.getElementById('feedbackModalTitle').innerHTML = '<i class="fas fa-plus me-2"></i>Thêm Feedback';
                document.getElementById('feedbackForm').action = 'feedback';
                document.getElementById('feedbackId').value = '';
                document.getElementById('action').value = 'add';
                document.getElementById('roomId').value = '';
                document.getElementById('content').value = '';
                document.getElementById('rating').value = '';
                selectedRating = 0;
                updateStars();
                document.getElementById('submitBtn').innerHTML = '<i class="fas fa-save me-2"></i>Lưu feedback';
                
                new bootstrap.Modal(document.getElementById('feedbackModal')).show();
            }

            // Sửa feedback
            function editFeedback(id, content, rating, roomId) {
                document.getElementById('feedbackModalTitle').innerHTML = '<i class="fas fa-edit me-2"></i>Sửa Feedback';
                document.getElementById('feedbackForm').action = 'feedbacklist';
                document.getElementById('feedbackId').value = id;
                document.getElementById('action').value = 'update';
                document.getElementById('roomId').value = roomId;
                document.getElementById('content').value = content;
                document.getElementById('rating').value = rating || '';
                selectedRating = rating ? parseInt(rating) : 0;
                updateStars();
                document.getElementById('submitBtn').innerHTML = '<i class="fas fa-save me-2"></i>Cập nhật feedback';
                
                new bootstrap.Modal(document.getElementById('feedbackModal')).show();
            }

            // Xóa feedback
            function deleteFeedback(id) {
                document.getElementById('deleteId').value = id;
                document.getElementById('deleteForm').action = 'feedbacklist';
                new bootstrap.Modal(document.getElementById('deleteModal')).show();
            }

            // Auto-hide alerts after 5 seconds
            setTimeout(function () {
                const alerts = document.querySelectorAll('.alert');
                alerts.forEach(function (alert) {
                    const bsAlert = new bootstrap.Alert(alert);
                    bsAlert.close();
                });
            }, 5000);
        </script>
    </body>
</html>
