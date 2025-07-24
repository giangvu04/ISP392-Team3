<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản Lý Bài Đăng</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        .stats-card {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border-radius: 15px;
            padding: 20px;
            margin-bottom: 20px;
        }
        .stats-number {
            font-size: 2.5rem;
            font-weight: bold;
        }
        .post-table {
            background: white;
            border-radius: 15px;
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            overflow: hidden;
        }
        .status-badge {
            padding: 5px 12px;
            border-radius: 20px;
            font-size: 0.85rem;
        }
        .status-active {
            background: #d4edda;
            color: #155724;
        }
        .status-inactive {
            background: #f8d7da;
            color: #721c24;
        }
        .featured-badge {
            background: #fff3cd;
            color: #856404;
        }
        .page-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 2rem 0;
            margin-bottom: 2rem;
            border-radius: 0 0 20px 20px;
        }
        .action-btn {
            margin: 2px;
            padding: 6px 12px;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            transition: all 0.3s;
        }
        .btn-toggle-status {
            background: #17a2b8;
            color: white;
        }
        .btn-toggle-featured {
            background: #ffc107;
            color: #212529;
        }
        .btn-delete {
            background: #dc3545;
            color: white;
        }
        .action-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(0,0,0,0.2);
        }
    </style>
</head>
<body class="bg-light">
    
    <div class="page-header">
        <div class="container">
            <div class="row align-items-center">
                <div class="col-md-8">
                    <h1 class="mb-0">
                        <i class="fas fa-home me-3"></i>
                        Quản Lý Bài Đăng Cho Thuê
                    </h1>
                    <c:choose>
                        <c:when test="${userRole == 1}">
                            <p class="mb-0 mt-2">Quản trị viên - Xem tất cả bài đăng</p>
                        </c:when>
                        <c:otherwise>
                            <p class="mb-0 mt-2">Quản lý - Bài đăng của bạn</p>
                        </c:otherwise>
                    </c:choose>
                </div>
                <div class="col-md-4 text-end">
                    <a href="${pageContext.request.contextPath}/Manager/create.jsp" 
                       class="btn btn-light btn-lg">
                        <i class="fas fa-plus me-2"></i>Tạo Bài Đăng Mới
                    </a>
                </div>
            </div>
        </div>
    </div>

    <div class="container">
        <!-- Error Message -->
        <c:if test="${not empty errorMessage}">
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                <i class="fas fa-exclamation-triangle me-2"></i>
                ${errorMessage}
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            </div>
        </c:if>

        <!-- Thống kê -->
        <div class="row mb-4">
            <div class="col-md-3">
                <div class="stats-card text-center">
                    <div class="stats-number">${totalPosts}</div>
                    <div class="stats-label">Tổng Bài Đăng</div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="stats-card text-center">
                    <div class="stats-number">${publicPosts}</div>
                    <div class="stats-label">Đang Công Khai</div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="stats-card text-center">
                    <div class="stats-number">${privatePosts}</div>
                    <div class="stats-label">Đang Ẩn</div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="stats-card text-center">
                    <div class="stats-number">${totalViews}</div>
                    <div class="stats-label">Tổng Lượt Xem</div>
                </div>
            </div>
        </div>

        <!-- Bảng danh sách bài đăng -->
        <div class="post-table">
            <div class="table-responsive">
                <table class="table table-hover mb-0">
                    <thead class="table-primary">
                        <tr>
                            <th>ID</th>
                            <th>Tiêu Đề</th>
                            <th>Khu Vực</th>
                            <c:if test="${userRole == 1}">
                                <th>Quản Lý</th>
                            </c:if>
                            <th>Giá</th>
                            <th>Trạng Thái</th>
                            <th>Nổi Bật</th>
                            <th>Lượt Xem</th>
                            <th>Ngày Tạo</th>
                            <th>Thao Tác</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="post" items="${rentalPosts}">
                            <tr>
                                <td class="fw-bold">${post.postId}</td>
                                <td>
                                    <div class="fw-semibold">${post.title}</div>
                                    <small class="text-muted">
                                        <c:choose>
                                            <c:when test="${post.description.length() > 50}">
                                                ${post.description.substring(0, 50)}...
                                            </c:when>
                                            <c:otherwise>
                                                ${post.description}
                                            </c:otherwise>
                                        </c:choose>
                                    </small>
                                </td>
                                <td>
                                    <div class="fw-semibold">${post.rentalAreaName}</div>
                                    <small class="text-muted">${post.rentalAreaAddress}</small>
                                </td>
                                <c:if test="${userRole == 1}">
                                    <td>${post.managerName}</td>
                                </c:if>
                                <td class="fw-bold text-success">
                                    <fmt:formatNumber value="${post.price}" type="currency" 
                                                    currencyCode="VND" pattern="#,##0 VND"/>
                                </td>
                                <td>
                                    <span class="status-badge ${post.active ? 'status-active' : 'status-inactive'}">
                                        <i class="fas ${post.active ? 'fa-check-circle' : 'fa-times-circle'} me-1"></i>
                                        ${post.active ? 'Công Khai' : 'Ẩn'}
                                    </span>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${post.featured}">
                                            <span class="status-badge featured-badge">
                                                <i class="fas fa-star me-1"></i>Nổi Bật
                                            </span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="text-muted">Thường</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <span class="badge bg-info">${post.viewsCount}</span>
                                </td>
                                <td>
                                    <fmt:formatDate value="${post.createdAt}" pattern="dd/MM/yyyy"/>
                                </td>
                                <td>
                                    <div class="d-flex flex-column gap-1">
                                        <!-- Toggle Active Status -->
                                        <form method="post" action="${pageContext.request.contextPath}/rental/management">
                                            <input type="hidden" name="action" value="toggleStatus">
                                            <input type="hidden" name="postId" value="${post.postId}">
                                            <button type="submit" class="action-btn btn-toggle-status btn-sm" 
                                                    title="${post.active ? 'Ẩn bài đăng' : 'Công khai bài đăng'}">
                                                <i class="fas ${post.active ? 'fa-eye-slash' : 'fa-eye'}"></i>
                                            </button>
                                        </form>
                                        
                                        <!-- Toggle Featured Status -->
                                        <form method="post" action="${pageContext.request.contextPath}/rental/management">
                                            <input type="hidden" name="action" value="toggleFeatured">
                                            <input type="hidden" name="postId" value="${post.postId}">
                                            <button type="submit" class="action-btn btn-toggle-featured btn-sm" 
                                                    title="${post.featured ? 'Bỏ nổi bật' : 'Đặt nổi bật'}">
                                                <i class="fas ${post.featured ? 'fa-star-half-alt' : 'fa-star'}"></i>
                                            </button>
                                        </form>
                                        
                                        <!-- Edit Post -->
                                        <a href="${pageContext.request.contextPath}/Manager/edit.jsp?id=${post.postId}" 
                                           class="action-btn btn-sm" style="background: #28a745; color: white; text-decoration: none; text-align: center;"
                                           title="Chỉnh sửa">
                                            <i class="fas fa-edit"></i>
                                        </a>
                                        
                                        <!-- Delete Post -->
                                        <form method="post" action="${pageContext.request.contextPath}/rental/management"
                                              onsubmit="return confirm('Bạn có chắc muốn xóa bài đăng này?')">
                                            <input type="hidden" name="action" value="delete">
                                            <input type="hidden" name="postId" value="${post.postId}">
                                            <button type="submit" class="action-btn btn-delete btn-sm" 
                                                    title="Xóa bài đăng">
                                                <i class="fas fa-trash"></i>
                                            </button>
                                        </form>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                        <c:if test="${empty rentalPosts}">
                            <tr>
                                <td colspan="${userRole == 1 ? '10' : '9'}" class="text-center py-5">
                                    <div class="text-muted">
                                        <i class="fas fa-inbox fa-3x mb-3"></i>
                                        <h5>Chưa có bài đăng nào</h5>
                                        <p>
                                            <a href="${pageContext.request.contextPath}/Manager/create.jsp" 
                                               class="btn btn-primary">
                                                <i class="fas fa-plus me-2"></i>Tạo Bài Đăng Đầu Tiên
                                            </a>
                                        </p>
                                    </div>
                                </td>
                            </tr>
                        </c:if>
                    </tbody>
                </table>
            </div>
        </div>
        
        <!-- Back to Dashboard -->
        <div class="text-center mt-4">
            <c:choose>
                <c:when test="${userRole == 1}">
                    <a href="${pageContext.request.contextPath}/Admin/AdminHomepage.jsp" 
                       class="btn btn-outline-primary btn-lg">
                        <i class="fas fa-arrow-left me-2"></i>Quay Về Dashboard Admin
                    </a>
                </c:when>
                <c:otherwise>
                    <a href="${pageContext.request.contextPath}/Manager/manager_homepage.jsp" 
                       class="btn btn-outline-primary btn-lg">
                        <i class="fas fa-arrow-left me-2"></i>Quay Về Dashboard Manager
                    </a>
                </c:otherwise>
            </c:choose>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    
    <!-- Success/Error Messages -->
    <c:if test="${not empty sessionScope.successMessage}">
        <script>
            setTimeout(() => {
                alert('${sessionScope.successMessage}');
            }, 100);
        </script>
        <c:remove var="successMessage" scope="session" />
    </c:if>
    
    <c:if test="${not empty sessionScope.errorMessage}">
        <script>
            setTimeout(() => {
                alert('Lỗi: ${sessionScope.errorMessage}');
            }, 100);
        </script>
        <c:remove var="errorMessage" scope="session" />
    </c:if>

</body>
</html>
