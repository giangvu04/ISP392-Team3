<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Quản lý ảnh - Hệ thống quản lý nhà trọ</title>
    <base href="${pageContext.request.contextPath}/">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link href="css/homepage.css" rel="stylesheet">
    <style>
        .stats-card {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }
        .image-card {
            background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
            color: white;
            border-radius: 10px;
            overflow: hidden;
            position: relative;
            transition: transform 0.2s;
        }
        .image-card:hover {
            transform: scale(1.05);
        }
        .img-preview {
            max-width: 100%;
            max-height: 200px;
            object-fit: cover;
            border-radius: 10px 10px 0 0;
            display: block;
            margin: 0 auto;
        }
        #imagePreview {
            max-width: 100%;
            max-height: 300px;
            object-fit: contain;
            display: none;
            margin-top: 10px;
            border: 1px solid #ddd;
            border-radius: 5px;
        }
        .delete-btn {
            position: absolute;
            top: 5px;
            right: 5px;
            background: rgba(255, 0, 0, 0.7);
            border: none;
            color: white;
            border-radius: 50%;
            width: 25px;
            height: 25px;
            line-height: 25px;
            text-align: center;
            cursor: pointer;
            opacity: 0.9;
            transition: opacity 0.2s;
        }
        .delete-btn:hover {
            opacity: 1;
        }
        .card-body {
            padding: 15px;
            text-align: center;
        }
        .row {
            margin-bottom: 20px;
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
                <div class="card image-card mb-4">
                    <div class="card-body">
                        <h2 class="mb-2">
                            <i class="fas fa-image me-2"></i>Danh sách ảnh
                            <c:if test="${not empty houseID}">của nhà #${houseID}</c:if>
                            <c:if test="${not empty roomID}">của phòng #${roomID}</c:if>
                        </h2>
                        <p class="mb-0 fs-5">
                            Quản lý ảnh của
                            <c:if test="${not empty houseID}">nhà</c:if>
                            <c:if test="${not empty roomID}">phòng</c:if>
                        </p>
                    </div>
                </div>

                <!-- Alert Messages -->
                <c:if test="${not empty error}">
                    <div class="alert alert-danger alert-dismissible fade show" role="alert">
                        <i class="fas fa-exclamation-circle me-2"></i>${error}
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                </c:if>
                <c:if test="${not empty success}">
                    <div class="alert alert-success alert-dismissible fade show" role="alert">
                        <i class="fas fa-check-circle me-2"></i>${success}
                        <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                    </div>
                </c:if>

                <!-- Add Image Button -->
                <div class="mb-4">
                    <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#addImageModal">
                        <i class="fas fa-plus me-2"></i>Thêm ảnh
                    </button>
                </div>

                <!-- Image List -->
                <div class="row">
                    <c:forEach var="image" items="${imageList}">
                        <div class="col-md-3 mb-3">
                            <div class="card image-card">
                                <div class="card-body position-relative">
                                    <img src="${image.urlImage}" class="img-preview" width="170px" height="170px" alt="Image">
                                    <p class="mb-0 mt-2">Ảnh ID: ${image.imageId}</p>
                                    <form action="ImageList" method="post" style="display:inline;">
                                        <input type="hidden" name="action" value="delete">
                                        <input type="hidden" name="imageId" value="${image.imageId}">
                                        <input type="hidden" name="houseID" value="${houseID}">
                                        <input type="hidden" name="roomID" value="${roomID}">
                                        <button type="submit" class="delete-btn" onclick="return confirm('Bạn có chắc muốn xóa ảnh này?')">
                                            <i class="fas fa-times"></i>
                                        </button>
                                    </form>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                    <c:if test="${empty imageList}">
                        <div class="col-12">
                            <p class="text-muted">Không có ảnh nào để hiển thị.</p>
                        </div>
                    </c:if>
                </div>

                <!-- Add Image Modal -->
                <div class="modal fade" id="addImageModal" tabindex="-1" aria-labelledby="addImageModalLabel" aria-hidden="true">
                    <div class="modal-dialog">
                        <div class="modal-content">
                            <div class="modal-header">
                                <h5 class="modal-title" id="addImageModalLabel">Thêm ảnh mới</h5>
                                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                            </div>
                            <div class="modal-body">
                                <form id="uploadImageForm" action="ImageList" method="post" enctype="multipart/form-data">
                                    <input type="hidden" name="houseID" value="${houseID}">
                                    <input type="hidden" name="roomID" value="${roomID}">
                                    <input type="hidden" name="action" value="add"/>
                                    <div class="mb-3">
                                        <label for="imageFile" class="form-label">Chọn ảnh (png, jpeg, jpg, webp)</label>
                                        <input type="file" class="form-control" id="imageFile" name="imageFile" accept=".png,.jpeg,.jpg,.webp" required>
                                        <img id="imagePreview" class="img-fluid" alt="Image Preview">
                                    </div>
                                    <button type="submit" class="btn btn-primary w-100">Tải ảnh lên</button>
                                </form>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
<jsp:include page="../Message.jsp"/>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    // Auto-hide alerts after 5 seconds
    setTimeout(function () {
        const alerts = document.querySelectorAll('.alert');
        alerts.forEach(function (alert) {
            const bsAlert = new bootstrap.Alert(alert);
            bsAlert.close();
        });
    }, 5000);

    // Image preview in modal
    document.getElementById('imageFile').addEventListener('change', function (e) {
        const file = e.target.files[0];
        const imagePreview = document.getElementById('imagePreview');
        const validImageTypes = ['image/png', 'image/jpeg', 'image/jpg', 'image/webp'];

        if (file && validImageTypes.includes(file.type)) {
            const reader = new FileReader();
            reader.onload = function (e) {
                imagePreview.src = e.target.result;
                imagePreview.style.display = 'block';
            };
            reader.readAsDataURL(file);
        } else {
            imagePreview.style.display = 'none';
            if (file) {
                alert('Vui lòng chọn file ảnh định dạng png, jpeg, jpg hoặc webp.');
                e.target.value = '';
            }
        }
    });
</script>
</body>
</html>