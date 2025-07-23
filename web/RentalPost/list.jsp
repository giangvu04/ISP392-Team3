<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý tin đăng - ISP Management</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="css/rooms.css" rel="stylesheet">
    <style>
        body {
            background-color: #f8f9fa;
        }
        .main-wrapper {
            display: flex;
            min-height: 100vh;
        }
        .content-area {
            flex: 1;
            padding: 20px;
        }
        .post-card {
            border: 1px solid #dee2e6;
            border-radius: 12px;
            transition: all 0.3s ease;
            background: white;
            overflow: hidden;
            height: 100%; /* Ensure equal height */
            display: flex;
            flex-direction: column;
        }
        .post-card:hover {
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
            transform: translateY(-2px);
        }
        .post-card .card-body {
            flex: 1;
            display: flex;
            flex-direction: column;
        }
        .post-image {
            width: 100%;
            height: 180px; /* Fixed height for consistency */
            object-fit: cover;
            background-color: #f8f9fa;
        }
        .post-image-placeholder {
            width: 100%;
            height: 180px; /* Fixed height for consistency */
            background-color: #f8f9fa;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #6c757d;
        }
        .card-title {
            height: 2.5rem; /* Fixed height for title */
            line-height: 1.25rem;
            overflow: hidden;
            display: -webkit-box;
            -webkit-line-clamp: 2;
            -webkit-box-orient: vertical;
        }
        .card-text {
            height: 3rem; /* Fixed height for description */
            line-height: 1rem;
            overflow: hidden;
            display: -webkit-box;
            -webkit-line-clamp: 3;
            -webkit-box-orient: vertical;
        }
        .card-actions {
            margin-top: auto; /* Push actions to bottom */
        }
        .featured-badge {
            background: linear-gradient(45deg, #ffd700, #ffed4e);
            color: #856404;
            padding: 2px 6px;
            border-radius: 8px;
            font-size: 0.7rem;
            font-weight: bold;
            white-space: nowrap;
        }
        .status-active {
            background-color: #d1edff;
            color: #0c63e4;
            padding: 2px 6px;
            border-radius: 8px;
            font-size: 0.7rem;
            white-space: nowrap;
        }
        .status-inactive {
            background-color: #f8d7da;
            color: #721c24;
            padding: 2px 6px;
            border-radius: 8px;
            font-size: 0.7rem;
            white-space: nowrap;
        }
        .search-controls {
            background: white;
            border-radius: 12px;
            padding: 20px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            margin-bottom: 20px;
        }
        .btn-create {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border: none;
            border-radius: 25px;
            padding: 10px 25px;
            color: white;
            font-weight: 500;
        }
        .btn-create:hover {
            transform: translateY(-1px);
            box-shadow: 0 5px 15px rgba(102, 126, 234, 0.4);
            color: white;
        }
    </style>
</head>
<body>
    <div class="main-wrapper">
        <!-- Include Sidebar -->
        <jsp:include page="../Sidebar/SideBarManager.jsp" />

        <div class="content-area">
            <div class="container-fluid">
                <div class="d-flex justify-content-between align-items-center mb-4">
                    <h1><i class="fas fa-newspaper me-2"></i>Quản lý tin đăng</h1>
                    <a href="createPost" class="btn btn-create">
                        <i class="fas fa-plus me-2"></i>Tạo tin đăng mới
                    </a>
                </div>
                
                <!-- Alert Messages -->
                <c:if test="${not empty successMessage}">
                    <div class="alert alert-success alert-dismissible fade show" role="alert">
                        <i class="fas fa-check-circle me-2"></i>${successMessage}
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                </c:if>
                
                <c:if test="${not empty errorMessage}">
                    <div class="alert alert-danger alert-dismissible fade show" role="alert">
                        <i class="fas fa-exclamation-circle me-2"></i>${errorMessage}
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                </c:if>

                    <!-- Search Controls -->
                    <div class="search-controls">
                        <form method="get" action="${pageContext.request.contextPath}/rental/listPost" id="searchForm">
                            <div class="row g-3">
                                <div class="col-md-4">
                                    <label class="form-label">Tìm kiếm</label>
                                    <input type="text" class="form-control" name="search" value="${searchQuery}" 
                                           placeholder="Nhập tiêu đề tin đăng...">
                                </div>
                                <div class="col-md-3">
                                    <label class="form-label">Khu trọ</label>
                                    <select class="form-select" name="areaId">
                                        <option value="">Tất cả khu trọ</option>
                                        <c:forEach var="area" items="${rentalAreas}">
                                            <option value="${area.rentalAreaId}" ${selectedAreaId == area.rentalAreaId ? 'selected' : ''}>
                                                ${area.name}
                                            </option>
                                        </c:forEach>
                                    </select>
                                </div>
                                <div class="col-md-2">
                                    <label class="form-label">Trạng thái</label>
                                    <select class="form-select" name="status">
                                        <option value="">Tất cả</option>
                                        <option value="active" ${selectedStatus == 'active' ? 'selected' : ''}>Đang hoạt động</option>
                                        <option value="inactive" ${selectedStatus == 'inactive' ? 'selected' : ''}>Tạm dừng</option>
                                    </select>
                                </div>
                                <div class="col-md-3 d-flex align-items-end gap-2">
                                    <button type="submit" class="btn btn-primary">
                                        <i class="fas fa-search me-1"></i>Tìm kiếm
                                    </button>
                                    <a href="${pageContext.request.contextPath}/rental/listPost" class="btn btn-outline-secondary">
                                        <i class="fas fa-refresh me-1"></i>Làm mới
                                    </a>
                                </div>
                            </div>
                        </form>
                    </div>

                    <!-- Statistics -->
                    <div class="row mb-4">
                        <div class="col-md-3">
                            <div class="card text-center border-primary">
                                <div class="card-body">
                                    <h5 class="text-primary">${totalPosts}</h5>
                                    <p class="card-text">Tổng tin đăng</p>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="card text-center border-success">
                                <div class="card-body">
                                    <h5 class="text-success">${activePosts}</h5>
                                    <p class="card-text">Đang hoạt động</p>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="card text-center border-info">
                                <div class="card-body">
                                    <h5 class="text-info">${featuredPosts}</h5>
                                    <p class="card-text">Tin nổi bật</p>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-3">
                            <div class="card text-center border-warning">
                                <div class="card-body">
                                    <h5 class="text-warning">${totalViews}</h5>
                                    <p class="card-text">Lượt xem</p>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Posts Grid -->
                    <c:choose>
                        <c:when test="${not empty rentalPosts}">
                            <div class="row">
                                <c:forEach var="post" items="${rentalPosts}">
                                    <div class="col-lg-6 col-xl-4 mb-4">
                                        <div class="post-card h-100">
                                            <!-- Image -->
                                            <c:choose>
                                                <c:when test="${not empty post.featuredImage}">
                                                    <img src="${post.featuredImage}" class="post-image" alt="${post.title}">
                                                </c:when>
                                                <c:otherwise>
                                                    <div class="post-image-placeholder">
                                                        <i class="fas fa-image fa-3x"></i>
                                                    </div>
                                                </c:otherwise>
                                            </c:choose>

                                            <div class="card-body p-3">
                                                <!-- Title and badges -->
                                                <div class="d-flex justify-content-between align-items-start mb-2">
                                                    <h5 class="card-title mb-0" title="${post.title}">
                                                        ${post.title}
                                                    </h5>
                                                    <div class="text-end flex-shrink-0 ms-2">
                                                        <c:if test="${post.featured}">
                                                            <div class="featured-badge mb-1">
                                                                <i class="fas fa-star me-1"></i>Nổi bật
                                                            </div>
                                                        </c:if>
                                                        <c:choose>
                                                            <c:when test="${post.active}">
                                                                <div class="status-active">Hoạt động</div>
                                                            </c:when>
                                                            <c:otherwise>
                                                                <div class="status-inactive">Tạm dừng</div>
                                                            </c:otherwise>
                                                        </c:choose>
                                                    </div>
                                                </div>

                                                <!-- Area and stats -->
                                                <div class="mb-2">
                                                    <small class="text-muted">
                                                        <i class="fas fa-map-marker-alt me-1"></i>${post.rentalAreaName}
                                                    </small>
                                                </div>

                                                <div class="row text-center mb-3">
                                                    <div class="col-6">
                                                        <small class="text-muted d-block">Lượt xem</small>
                                                        <strong>${post.viewsCount}</strong>
                                                    </div>
                                                    <div class="col-6">
                                                        <small class="text-muted d-block">Trạng thái</small>
                                                        <strong>${post.active ? 'Công khai' : 'Ẩn'}</strong>
                                                    </div>
                                                </div>

                                                

                                                <!-- Date -->
                                                <div class="text-muted small mb-3">
                                                    <i class="fas fa-calendar me-1"></i>
                                                    <fmt:formatDate value="${post.createdAt}" pattern="dd/MM/yyyy HH:mm"/>
                                                </div>

                                                <!-- Action buttons -->
                                                <div class="card-actions">
                                                    <div class="d-grid gap-1">
                                                        <!-- Row 1: View and Edit -->
                                                        <div class="d-flex gap-2">
                                                            <a href="${pageContext.request.contextPath}/rental/viewPost?id=${post.postId}" class="btn btn-outline-primary btn-sm flex-fill">
                                                                <i class="fas fa-eye me-1"></i>Xem
                                                            </a>
                                                            <a href="${pageContext.request.contextPath}/editPost?id=${post.postId}" class="btn btn-outline-warning btn-sm flex-fill">
                                                                <i class="fas fa-edit me-1"></i>Sửa
                                                            </a>
                                                        </div>
                                                        
                                                        <!-- Row 2: Toggle buttons -->
                                                        <div class="d-flex gap-2">
                                                            <!-- Toggle Status Button -->
                                                            <form method="post" action="${pageContext.request.contextPath}/rental/toggleStatus" class="flex-fill">
                                                                <input type="hidden" name="postId" value="${post.postId}">
                                                                <button type="submit" class="btn ${post.active ? 'btn-outline-success' : 'btn-outline-secondary'} btn-sm w-100"
                                                                        onclick="return confirm('Bạn có chắc muốn thay đổi trạng thái bài đăng này?')">
                                                                    <i class="fas ${post.active ? 'fa-eye-slash' : 'fa-eye'} me-1"></i>${post.active ? 'Ẩn' : 'Hiện'}
                                                                </button>
                                                            </form>
                                                            
                                                            <!-- Toggle Featured Button (Admin only) -->
                                                            <c:choose>
                                                                <c:when test="${userRole == 1}">
                                                                    <form method="post" action="${pageContext.request.contextPath}/rental/toggleFeatured" class="flex-fill">
                                                                        <input type="hidden" name="postId" value="${post.postId}">
                                                                        <button type="submit" class="btn ${post.featured ? 'btn-warning' : 'btn-outline-warning'} btn-sm w-100"
                                                                                onclick="return confirm('Bạn có chắc muốn thay đổi tình trạng nổi bật của bài đăng này?')">
                                                                            <i class="fas fa-star me-1"></i>${post.featured ? 'Bỏ NB' : 'Nổi bật'}
                                                                        </button>
                                                                    </form>
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <div class="flex-fill"></div>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>

                            <!-- Pagination -->
                            <c:if test="${totalPages > 0}">
                                <nav aria-label="Page navigation">
                                    <ul class="pagination justify-content-center">
                                        <c:if test="${currentPage > 1}">
                                            <li class="page-item">
                                                <a class="page-link" href="?page=${currentPage - 1}&search=${searchQuery}&areaId=${selectedAreaId}&status=${selectedStatus}">
                                                    <i class="fas fa-chevron-left"></i>
                                                </a>
                                            </li>
                                        </c:if>
                                        
                                        <c:forEach begin="1" end="${totalPages}" var="i">
                                            <li class="page-item ${currentPage == i ? 'active' : ''}">
                                                <a class="page-link" href="?page=${i}&search=${searchQuery}&areaId=${selectedAreaId}&status=${selectedStatus}">${i}</a>
                                            </li>
                                        </c:forEach>
                                        
                                        <c:if test="${currentPage < totalPages}">
                                            <li class="page-item">
                                                <a class="page-link" href="?page=${currentPage + 1}&search=${searchQuery}&areaId=${selectedAreaId}&status=${selectedStatus}">
                                                    <i class="fas fa-chevron-right"></i>
                                                </a>
                                            </li>
                                        </c:if>
                                    </ul>
                                </nav>
                            </c:if>
                        </c:when>
                        <c:otherwise>
                            <div class="text-center py-5">
                                <i class="fas fa-newspaper fa-5x text-muted mb-3"></i>
                                <h4 class="text-muted">Chưa có tin đăng nào</h4>
                                <p class="text-muted mb-4">Bắt đầu tạo tin đăng đầu tiên để cho thuê phòng trọ.</p>
                                <a href="createPost" class="btn btn-create">
                                    <i class="fas fa-plus me-2"></i>Tạo tin đăng đầu tiên
                                </a>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Auto submit search form on change
        document.querySelectorAll('select[name="areaId"], select[name="status"]').forEach(select => {
            select.addEventListener('change', function() {
                document.getElementById('searchForm').submit();
            });
        });
        
        // Handle search form submission with current page reset
        document.getElementById('searchForm').addEventListener('submit', function(e) {
            // Remove any existing page parameter when searching
            const pageInput = document.querySelector('input[name="page"]');
            if (pageInput) {
                pageInput.remove();
            }
        });
    </script>
</body>
</html>
