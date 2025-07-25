<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chỉnh sửa tin đăng - ISP Management</title>
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
        .form-container {
            background: white;
            border-radius: 12px;
            padding: 30px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            margin-bottom: 20px;
        }
        .btn-save {
            background: linear-gradient(135deg, #28a745 0%, #20c997 100%);
            border: none;
            border-radius: 25px;
            padding: 10px 30px;
            color: white;
            font-weight: 500;
        }
        .btn-save:hover {
            transform: translateY(-1px);
            box-shadow: 0 5px 15px rgba(40, 167, 69, 0.4);
            color: white;
        }
        .btn-cancel {
            background: linear-gradient(135deg, #6c757d 0%, #495057 100%);
            border: none;
            border-radius: 25px;
            padding: 10px 30px;
            color: white;
            font-weight: 500;
        }
        .btn-cancel:hover {
            transform: translateY(-1px);
            box-shadow: 0 5px 15px rgba(108, 117, 125, 0.4);
            color: white;
        }
        .form-label {
            font-weight: 600;
            color: #495057;
        }
        .required {
            color: #dc3545;
        }
        .image-preview {
            max-width: 200px;
            max-height: 200px;
            border-radius: 8px;
            margin-top: 10px;
        }
        .ck-editor__editable {
            min-height: 300px;
        }
        .ck-content {
            font-size: 14px;
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
                    <h1><i class="fas fa-edit me-2"></i>Chỉnh sửa tin đăng</h1>
                    <a href="listPost" class="btn btn-outline-secondary">
                        <i class="fas fa-arrow-left me-2"></i>Quay lại danh sách
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

                <!-- Form Container -->
                <div class="form-container">
                    <form method="post" action="${pageContext.request.contextPath}/editPost" id="editPostForm">
                        <input type="hidden" name="postId" value="${rentalPost.postId}">
                        
                        <div class="row">
                            <div class="col-md-8">
                                <!-- Tiêu đề -->
                                <div class="mb-3">
                                    <label for="title" class="form-label">
                                        Tiêu đề tin đăng <span class="required">*</span>
                                    </label>
                                    <input type="text" class="form-control" id="title" name="title" 
                                           value="${rentalPost.title}" required maxlength="200"
                                           placeholder="Nhập tiêu đề hấp dẫn cho tin đăng...">
                                    <div class="form-text">Tối đa 200 ký tự</div>
                                </div>

                                <!-- Khu trọ -->
                                <div class="mb-3">
                                    <label for="areaId" class="form-label">
                                        Khu trọ <span class="required">*</span>
                                    </label>
                                    <select class="form-select" id="areaId" name="areaId" required>
                                        <option value="">Chọn khu trọ</option>
                                        <c:forEach var="area" items="${rentalAreas}">
                                            <option value="${area.rentalAreaId}" ${rentalPost.rentalAreaId == area.rentalAreaId ? 'selected' : ''}>
                                                ${area.name} - ${area.address}
                                            </option>
                                        </c:forEach>
                                    </select>
                                </div>

                                <!-- Mô tả -->
                                <div class="mb-3">
                                    <label for="description" class="form-label">
                                        Mô tả chi tiết <span class="required">*</span>
                                    </label>
                                    <textarea class="form-control" id="description" name="description" 
                                              required maxlength="5000"
                                              placeholder="Mô tả chi tiết về phòng trọ, tiện ích, vị trí, giá cả...">${rentalPost.description}</textarea>
                                    <div class="form-text">Sử dụng trình soạn thảo để tạo nội dung phong phú</div>
                                </div>

                                <!-- Thông tin liên hệ -->
                                <div class="mb-3">
                                    <label for="contactInfo" class="form-label">Thông tin liên hệ</label>
                                    <textarea class="form-control" id="contactInfo" name="contactInfo" 
                                              rows="3" maxlength="500"
                                              placeholder="Số điện thoại, email, địa chỉ liên hệ...">${rentalPost.contactInfo}</textarea>
                                    <div class="form-text">Tối đa 500 ký tự</div>
                                </div>
                            </div>

                            <div class="col-md-4">
                                <!-- Hình ảnh đại diện -->
                                <div class="mb-3">
                                    <label for="featuredImage" class="form-label">Hình ảnh đại diện</label>
                                    <input type="url" class="form-control" id="featuredImage" name="featuredImage" 
                                           value="${rentalPost.featuredImage}"
                                           placeholder="https://example.com/image.jpg"
                                           onchange="previewImage()">
                                    <div class="form-text">Nhập URL của hình ảnh</div>
                                    
                                    <!-- Image Preview -->
                                    <div id="imagePreview" class="mt-2">
                                        <c:if test="${not empty rentalPost.featuredImage}">
                                            <img src="${rentalPost.featuredImage}" class="image-preview" alt="Preview" id="previewImg">
                                        </c:if>
                                    </div>
                                </div>

                                <!-- Thông tin bài viết -->
                                <div class="card">
                                    <div class="card-header">
                                        <h6 class="mb-0"><i class="fas fa-info-circle me-1"></i>Thông tin bài viết</h6>
                                    </div>
                                    <div class="card-body">
                                        <div class="mb-2">
                                            <small class="text-muted">Trạng thái:</small>
                                            <span class="badge ${rentalPost.active ? 'bg-success' : 'bg-secondary'} ms-1">
                                                ${rentalPost.active ? 'Đang hoạt động' : 'Tạm dừng'}
                                            </span>
                                        </div>
                                        <c:if test="${rentalPost.featured}">
                                            <div class="mb-2">
                                                <small class="text-muted">Đặc biệt:</small>
                                                <span class="badge bg-warning text-dark ms-1">
                                                    <i class="fas fa-star me-1"></i>Tin nổi bật
                                                </span>
                                            </div>
                                        </c:if>
                                        <div class="mb-2">
                                            <small class="text-muted">Lượt xem:</small>
                                            <strong class="ms-1">${rentalPost.viewsCount}</strong>
                                        </div>
                                        <div class="mb-0">
                                            <small class="text-muted">Ngày tạo:</small>
                                            <br>
                                            <small class="ms-1">
                                                <fmt:formatDate value="${rentalPost.createdAt}" pattern="dd/MM/yyyy HH:mm"/>
                                            </small>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Action Buttons -->
                        <div class="row mt-4">
                            <div class="col-12">
                                <div class="d-flex justify-content-end gap-3">
                                    <a href="${pageContext.request.contextPath}/rental/listPost" class="btn btn-cancel">
                                        <i class="fas fa-times me-2"></i>Hủy bỏ
                                    </a>
                                    <button type="submit" class="btn btn-save">
                                        <i class="fas fa-save me-2"></i>Lưu thay đổi
                                    </button>
                                </div>
                            </div>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <!-- Use simpler CKEditor 5 build -->
    <script src="https://cdn.ckeditor.com/ckeditor5/40.2.0/classic/ckeditor.js"></script>
    <script>
        let editorInstance;
        
        // Wait for page to load completely
        document.addEventListener('DOMContentLoaded', function() {
            initializeCKEditor();
        });
        
        // Initialize CKEditor using the same working config as create.jsp
        function initializeCKEditor() {
            console.log('DOM loaded');
            
            // Check if CKEditor is available
            if (typeof ClassicEditor === 'undefined') {
                console.error('CKEditor not loaded!');
                showFallbackMessage();
                return;
            }
            
            console.log('CKEditor available, initializing...');
            
            // Use same simple config as create.jsp - no conflicting plugins
            let editorConfig = {
                toolbar: [
                    'heading', '|',
                    'bold', 'italic', 'link', '|',
                    'bulletedList', 'numberedList', '|',
                    'blockQuote', '|',
                    'undo', 'redo'
                ]
            };

            // Initialize CKEditor
            ClassicEditor
                .create(document.querySelector('#description'), editorConfig)
                .then(editor => {
                    console.log('✅ CKEditor initialized successfully');
                    editorInstance = editor;
                    
                    // Update character counter on change
                    editor.model.document.on('change:data', () => {
                        updateCharacterCount();
                    });
                    
                    // Set initial content and count
                    setTimeout(() => {
                        updateCharacterCount();
                    }, 100);
                })
                .catch(error => {
                    console.error('❌ CKEditor initialization failed:', error);
                    showFallbackMessage();
                });
        }
        
        function showFallbackMessage() {
            console.log('Using fallback textarea mode');
            const helpText = document.querySelector('#description').parentNode.querySelector('.form-text');
            if (helpText && !helpText.innerHTML.includes('ký tự')) {
                helpText.innerHTML = '📝 Đang sử dụng textarea thông thường. <small class="text-muted">Trình soạn thảo nâng cao không khả dụng.</small>';
                helpText.className = 'form-text text-info';
            }
        }
            
        // Character count function
        function updateCharacterCount() {
            if (editorInstance && typeof editorInstance.getData === 'function') {
                const data = editorInstance.getData();
                const plainText = data.replace(/<[^>]*>/g, ''); // Remove HTML tags for counting
                const current = plainText.length;
                const max = 5000;
                
                let formText = document.querySelector('#description').parentNode.querySelector('.form-text');
                if (!formText) {
                    formText = document.createElement('div');
                    formText.className = 'form-text';
                    document.querySelector('#description').parentNode.appendChild(formText);
                }
                
                // Only update if it's not a static message
                if (!formText.innerHTML.includes('Đang sử dụng textarea') && !formText.innerHTML.includes('soạn thảo')) {
                    formText.innerHTML = `📝 ${current}/${max} ký tự`;
                    
                    if (current > max * 0.9) {
                        formText.className = 'form-text text-warning';
                    } else if (current >= max) {
                        formText.className = 'form-text text-danger';
                    } else {
                        formText.className = 'form-text text-success';
                    }
                }
            }
        }
        
        // Debug function to check CKEditor status
        function checkCKEditorStatus() {
            console.log('🔍 CKEditor Status Check:');
            console.log('- ClassicEditor available:', typeof ClassicEditor !== 'undefined');
            console.log('- Description element:', !!document.querySelector('#description'));
            console.log('- Editor instance:', editorInstance ? '✅ Active' : '❌ Not loaded');
            
            if (editorInstance && typeof editorInstance.getData === 'function') {
                console.log('- Content preview:', editorInstance.getData().substring(0, 50) + '...');
            }
        }
        
        // Check status after initialization attempt
        setTimeout(() => {
            checkCKEditorStatus();
            if (!editorInstance) {
                console.log('⚠️ Using fallback textarea mode');
            }
        }, 3000);
        // Image preview function
        function previewImage() {
            const imageUrl = document.getElementById('featuredImage').value;
            const previewContainer = document.getElementById('imagePreview');
            
            if (imageUrl.trim() !== '') {
                // Remove existing preview
                const existingImg = document.getElementById('previewImg');
                if (existingImg) {
                    existingImg.remove();
                }
                
                // Create new image element
                const img = document.createElement('img');
                img.src = imageUrl;
                img.className = 'image-preview';
                img.alt = 'Preview';
                img.id = 'previewImg';
                
                // Handle image load error
                img.onerror = function() {
                    this.style.display = 'none';
                    const errorMsg = document.createElement('small');
                    errorMsg.className = 'text-danger';
                    errorMsg.textContent = 'Không thể tải hình ảnh';
                    previewContainer.appendChild(errorMsg);
                };
                
                previewContainer.appendChild(img);
            } else {
                previewContainer.innerHTML = '';
            }
        }

        // Form validation
        document.getElementById('editPostForm').addEventListener('submit', function(e) {
            const title = document.getElementById('title').value.trim();
            const areaId = document.getElementById('areaId').value;
            
            // Get content from CKEditor or textarea
            let description = '';
            if (editorInstance && typeof editorInstance.getData === 'function') {
                // CKEditor 5 is active
                description = editorInstance.getData().trim();
                document.getElementById('description').value = description;
                console.log('✅ Getting content from CKEditor 5');
            } else {
                // Plain textarea
                description = document.getElementById('description').value.trim();
                console.log('📝 Getting content from textarea');
            }
            
            if (!title || !description || !areaId) {
                e.preventDefault();
                alert('Vui lòng điền đầy đủ thông tin bắt buộc!');
                return false;
            }
            
            // Check if description is not just HTML tags
            const plainTextDescription = description.replace(/<[^>]*>/g, '').trim();
            if (plainTextDescription.length === 0) {
                e.preventDefault();
                alert('Vui lòng nhập nội dung mô tả!');
                return false;
            }
            
            console.log('📤 Form validation passed, submitting...');
            
            // Confirm save
            return confirm('Bạn có chắc muốn lưu các thay đổi này?');
        });

        // Character counter for textarea (always available as fallback)
        document.getElementById('description').addEventListener('input', function() {
            if (!editorInstance) { // Only if CKEditor is not initialized
                const current = this.value.length;
                const max = 5000;
                let formText = this.parentNode.querySelector('.form-text');
                if (!formText) {
                    formText = document.createElement('div');
                    formText.className = 'form-text';
                    this.parentNode.appendChild(formText);
                }
                formText.textContent = `${current}/${max} ký tự`;
                
                if (current > max * 0.9) {
                    formText.className = 'form-text text-warning';
                } else if (current >= max) {
                    formText.className = 'form-text text-danger';
                } else {
                    formText.className = 'form-text';
                }
            }
        });
        
        document.getElementById('title').addEventListener('input', function() {
            const current = this.value.length;
            const max = 200;
            const formText = this.nextElementSibling;
            formText.textContent = `${current}/${max} ký tự`;
            
            if (current > max * 0.9) {
                formText.className = 'form-text text-warning';
            } else if (current === max) {
                formText.className = 'form-text text-danger';
            } else {
                formText.className = 'form-text';
            }
        });
    </script>
</body>
</html>
