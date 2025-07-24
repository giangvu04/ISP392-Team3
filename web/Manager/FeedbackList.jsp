<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Quản lý Feedback - Manager Dashboard</title>
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
                max-width: 300px;
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
        </style>
    </head>
    <body>
        <div class="container-fluid">
            <div class="row">
                <!-- Sidebar -->
                <jsp:include page="../Sidebar/SideBarManager.jsp"/>

                <!-- Main Content -->
                <div class="col-md-9 col-lg-10">
                    <div class="main-content p-4">
                        <!-- Header -->
                        <div class="d-flex justify-content-between align-items-center mb-4">
                            <div>
                                <h2 class="mb-1"><i class="fas fa-comments"></i> Quản lý Feedback</h2>
                                <p class="text-muted mb-0">Xem và quản lý feedback từ người thuê về phòng</p>
                            </div>
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
                            <div class="col-md-4">
                                <div class="card stats-card">
                                    <div class="card-body">
                                        <div class="d-flex justify-content-between">
                                            <div>
                                                <h6 class="card-title mb-2">Tổng Feedback</h6>
                                                <h3 class="mb-0">${totalFeedbacks}</h3>
                                            </div>
                                            <div class="align-self-center">
                                                <i class="fas fa-comments fa-2x opacity-75"></i>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-4">
                                <div class="card stats-card-2">
                                    <div class="card-body">
                                        <div class="d-flex justify-content-between">
                                            <div>
                                                <h6 class="card-title mb-2">Đánh giá trung bình</h6>
                                                <h3 class="mb-0">
                                                    <fmt:formatNumber value="${averageRating}" maxFractionDigits="1"/>
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
                            <div class="col-md-4">
                                <div class="card stats-card-3">
                                    <div class="card-body">
                                        <div class="d-flex justify-content-between">
                                            <div>
                                                <h6 class="card-title mb-2">Feedback tháng này</h6>
                                                <h3 class="mb-0">${monthlyFeedbacks}</h3>
                                            </div>
                                            <div class="align-self-center">
                                                <i class="fas fa-calendar fa-2x opacity-75"></i>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Search and Filter -->
                        <div class="card mb-4">
                            <div class="card-body">
                                <form action="feedbacklist" method="GET" class="row g-3">
                                    <input type="hidden" name="action" value="search">
                                    <div class="col-md-3">
                                        <label for="searchType" class="form-label">Tìm kiếm theo:</label>
                                        <select class="form-select" id="searchType" name="searchType">
                                            <option value="content" ${searchType == 'content' ? 'selected' : ''}>Nội dung</option>
                                            <option value="authorName" ${searchType == 'authorName' ? 'selected' : ''}>Tên người gửi</option>
                                            <option value="roomId" ${searchType == 'roomId' ? 'selected' : ''}>ID Phòng</option>
                                        </select>
                                    </div>
                                    <div class="col-md-6">
                                        <label for="searchValue" class="form-label">Giá trị tìm kiếm:</label>
                                        <input type="text" class="form-control search-box" id="searchValue" name="searchValue" 
                                               value="${searchValue}" placeholder="Nhập từ khóa tìm kiếm...">
                                    </div>
                                    <div class="col-md-3">
                                        <label class="form-label"> </label>
                                        <div>
                                            <button type="submit" class="btn btn-primary btn-action">
                                                <i class="fas fa-search me-2"></i>Tìm kiếm
                                            </button>
                                            <a href="feedbacklist?action=list" class="btn btn-outline-secondary btn-action">
                                                <i class="fas fa-refresh me-2"></i>Làm mới
                                            </a>
                                        </div>
                                    </div>
                                </form>
                            </div>
                        </div>

                        <!-- Feedbacks Table -->
                        <div class="card">
                            <div class="card-header bg-white">
                                <h5 class="mb-0"><i class="fas fa-list me-2"></i>Danh sách Feedback</h5>
                            </div>
                            <div class="card-body p-0">
                                <div class="table-responsive">
                                    <table class="table table-hover mb-0">
                                        <thead class="table-light">
                                            <tr>
                                                <th>ID</th>
                                                <th>Phòng</th>
                                                <th>Người gửi</th>
                                                <th>Nội dung</th>
                                                <th>Đánh giá</th>
                                                <th>Ngày tạo</th>
                                                <th>Thao tác</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach var="feedback" items="${feedbacks}">
                                                <tr>
                                                    <td><strong>#${feedback.feedbackId}</strong></td>
                                                    <td>
                                                        <span class="badge bg-info">Phòng ${feedback.roomId}</span>
                                                    </td>
                                                    <td>
                                                        <div class="d-flex align-items-center">
                                                            <div class="avatar-sm bg-primary rounded-circle me-2 d-flex align-items-center justify-content-center">
                                                                <i class="fas fa-user text-white"></i>
                                                            </div>
                                                            <div>
                                                                <div class="fw-bold">${feedback.authorName}</div>
                                                                <small class="text-muted">ID: ${feedback.userId}</small>
                                                            </div>
                                                        </div>
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
                                                        <button type="button" class="btn btn-sm btn-outline-primary btn-action" 
                                                                onclick="viewFeedbackDetail('${feedback.feedbackId}', '${feedback.authorName}', `${feedback.content}`, '${feedback.rating}')">
                                                            <i class="fas fa-eye me-1"></i>Xem chi tiết
                                                        </button>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        </div>

                        <!-- Empty State -->
                        <c:if test="${empty feedbacks}">
                            <div class="text-center mt-5">
                                <i class="fas fa-comments fa-4x text-muted mb-3"></i>
                                <h4 class="text-muted">Chưa có feedback nào</h4>
                                <p class="text-muted">Feedback từ người thuê sẽ hiển thị tại đây</p>
                            </div>
                        </c:if>
                    </div>
                </div>
            </div>
        </div>

        <!-- Feedback Detail Modal -->
        <div class="modal fade" id="feedbackDetailModal" tabindex="-1">
            <div class="modal-dialog modal-lg">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title"><i class="fas fa-comments me-2"></i>Chi tiết Feedback</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                    </div>
                    <div class="modal-body">
                        <div class="row">
                            <div class="col-md-6">
                                <h6>Thông tin người gửi:</h6>
                                <p><strong>Tên:</strong> <span id="detailAuthorName"></span></p>
                                <p><strong>Ngày gửi:</strong> <span id="detailCreatedAt"></span></p>
                            </div>
                            <div class="col-md-6">
                                <h6>Đánh giá:</h6>
                                <div id="detailRating" class="rating-stars mb-3"></div>
                            </div>
                        </div>
                        <hr>
                        <h6>Nội dung:</h6>
                        <div id="detailContent" class="p-3 bg-light rounded"></div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
                    </div>
                </div>
            </div>
        </div>

        <!-- Bootstrap JS -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

        <script>
            // Xem chi tiết feedback
            function viewFeedbackDetail(id, authorName, content, rating) {
                document.getElementById('detailAuthorName').textContent = authorName;
                document.getElementById('detailContent').textContent = content;
                
                // Hiển thị rating
                const ratingDiv = document.getElementById('detailRating');
                if (rating) {
                    let stars = '';
                    for (let i = 1; i <= 5; i++) {
                        stars += `<i class="fas fa-star ${i <= rating ? '' : 'text-muted'}"></i>`;
                    }
                    ratingDiv.innerHTML = stars + ` <small class="text-muted ms-2">(${rating}/5)</small>`;
                } else {
                    ratingDiv.innerHTML = '<span class="text-muted">Không có đánh giá</span>';
                }
                
                new bootstrap.Modal(document.getElementById('feedbackDetailModal')).show();
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
