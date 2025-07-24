<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Tạo tin đăng cho thuê - ISP Management</title>
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
            border-radius: 10px;
            box-shadow: 0 0 20px rgba(0,0,0,0.1);
            padding: 30px;
            margin-bottom: 20px;
        }
        .section-title {
            color: #2c3e50;
            border-bottom: 3px solid #3498db;
            padding-bottom: 10px;
            margin-bottom: 20px;
        }
        .image-preview {
            width: 100%;
            max-width: 300px;
            height: 200px;
            border: 2px dashed #ddd;
            border-radius: 8px;
            display: flex;
            align-items: center;
            justify-content: center;
            background-color: #f8f9fa;
            margin-top: 10px;
        }
        .image-preview img {
            max-width: 100%;
            max-height: 100%;
            border-radius: 8px;
        }
        .room-selection {
            background-color: #f8f9fa;
            border-radius: 8px;
            padding: 15px;
            margin-top: 15px;
        }
        .room-item {
            border: 1px solid #dee2e6;
            border-radius: 8px;
            padding: 10px;
            margin-bottom: 10px;
            background: white;
            cursor: pointer;
            transition: all 0.3s ease;
        }
        .room-item:hover {
            background-color: #f1f3f4;
            transform: translateY(-1px);
        }
        .room-item.selected {
            border-color: #3498db;
            background-color: #e3f2fd;
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
                <h1 class="mb-4"><i class="fas fa-plus-circle me-2"></i>Tạo tin đăng cho thuê</h1>
                
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
                    <form action="createPost" method="post" id="createPostForm" enctype="multipart/form-data">
                        <!-- Thông tin cơ bản -->
                        <div class="row">
                            <div class="col-lg-8">
                                <h4 class="section-title"><i class="fas fa-info-circle me-2"></i>Thông tin cơ bản</h4>
                                    
                                    <!-- Khu trọ -->
                                    <div class="mb-3">
                                        <label for="rentalAreaId" class="form-label">Khu trọ <span class="text-danger">*</span></label>
                                        <select class="form-select" id="rentalAreaId" name="rentalAreaId" required onchange="loadRooms()">
                                            <option value="">Chọn khu trọ</option>
                                            <c:forEach var="area" items="${rentalAreas}">
                                                <option value="${area.rentalAreaId}">${area.name} - ${area.address}</option>
                                            </c:forEach>
                                        </select>
                                       
                                    </div>

                                    <!-- Tiêu đề -->
                                    <div class="mb-3">
                                        <label for="title" class="form-label">Tiêu đề tin đăng <span class="text-danger">*</span></label>
                                        <input type="text" class="form-control" id="title" name="title" required maxlength="255" 
                                               placeholder="VD: Phòng trọ giá rẻ, tiện nghi đầy đủ...">
                                        <div class="form-text">Tiêu đề ngắn gọn, hấp dẫn để thu hút khách thuê</div>
                                    </div>

                                    <!-- Mô tả chi tiết -->
                                    <div class="mb-3">
                                        <label for="description" class="form-label">Mô tả chi tiết</label>
                                        <div id="editor" style="height: 300px;"></div>
                                        <textarea id="description" name="description" style="display: none;"></textarea>
                                        <div class="form-text">Mô tả càng chi tiết càng tốt để khách hàng hiểu rõ về phòng trọ</div>
                                    </div>

                                    <!-- Thông tin liên hệ -->
                                    <div class="mb-3">
                                        <label for="contactInfo" class="form-label">Thông tin liên hệ</label>
                                        <textarea class="form-control" id="contactInfo" name="contactInfo" rows="3" maxlength="500"
                                                placeholder="Số điện thoại, email, zalo, địa chỉ liên hệ..."></textarea>
                                    </div>
                                </div>

                                <!-- Ảnh đại diện -->
                                <div class="col-lg-4">
                                    <h4 class="section-title"><i class="fas fa-image me-2"></i>Ảnh đại diện</h4>
                                    
                                    <!-- File upload option -->
                                    <div class="mb-3">
                                        <label for="featuredImageFile" class="form-label">Upload ảnh từ máy tính</label>
                                        <input type="file" class="form-control" id="featuredImageFile" name="featuredImageFile" 
                                               accept="image/*" onchange="handleFilePreview()">
                                        <div class="form-text">Chọn file ảnh từ máy tính (JPG, PNG, GIF)</div>
                                    </div>

                                    <!-- URL option -->
                                    <div class="mb-3">
                                        <label for="featuredImage" class="form-label">Hoặc nhập URL ảnh</label>
                                        <input type="url" class="form-control" id="featuredImage" name="featuredImage" 
                                               placeholder="https://example.com/image.jpg" onchange="previewImage()">
                                        <div class="form-text">Nhập URL ảnh từ internet</div>
                                    </div>

                                    <div class="image-preview" id="imagePreview">
                                        <div class="text-center text-muted">
                                            <i class="fas fa-image fa-3x mb-2"></i>
                                            <p>Xem trước ảnh</p>
                                        </div>
                                    </div>

                                    <!-- Tin nổi bật -->
                                    <div class="form-check mt-3">
                                        <input class="form-check-input" type="checkbox" id="isFeatured" name="isFeatured">
                                        <label class="form-check-label" for="isFeatured">
                                            <i class="fas fa-star text-warning me-1"></i>Tin nổi bật
                                        </label>
                                        <div class="form-text">Tin nổi bật sẽ được hiển thị ở vị trí ưu tiên</div>
                                    </div>
                                </div>
                            </div>

                            <!-- Chọn phòng -->
                            <div class="room-selection" id="roomSelection" style="display: none;">
                                <h4 class="section-title"><i class="fas fa-bed me-2"></i>Chọn phòng cho tin đăng</h4>
                                <p class="text-muted">Chọn một phòng để đưa vào tin đăng này</p>
                                <div id="roomList">
                                    <!-- Rooms will be loaded here by AJAX -->
                                </div>
                            </div>

                            <!-- Buttons -->
                            <div class="row mt-4">
                                <div class="col-12">
                                    <hr>
                                    <div class="d-flex gap-2">
                                        <button type="submit" class="btn btn-create btn-lg">
                                            <i class="fas fa-save me-2"></i>Tạo tin đăng
                                        </button>
                                        <a href="listPost" class="btn btn-outline-secondary btn-lg">
                                            <i class="fas fa-arrow-left me-2"></i>Quay lại
                                        </a>
                                    </div>
                                </div>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdn.ckeditor.com/ckeditor5/40.0.0/classic/ckeditor.js"></script>
    <script src="${pageContext.request.contextPath}/js/ckeditor-upload-adapter.js"></script>
    <script>
        let editorInstance;

        // Wait for DOM and scripts to load
        document.addEventListener('DOMContentLoaded', function() {
            console.log('DOM loaded');
            
            // Check if CKEditor is available
            if (typeof ClassicEditor === 'undefined') {
                console.error('CKEditor not loaded!');
                // Fallback to regular textarea
                document.querySelector('#editor').style.display = 'none';
                const fallbackTextarea = document.createElement('textarea');
                fallbackTextarea.className = 'form-control';
                fallbackTextarea.id = 'descriptionFallback';
                fallbackTextarea.name = 'description';
                fallbackTextarea.rows = 6;
                fallbackTextarea.placeholder = 'Mô tả chi tiết về phòng trọ...';
                document.querySelector('#editor').parentNode.appendChild(fallbackTextarea);
                return;
            }
            
            console.log('CKEditor available, initializing...');
            
            // Check if upload adapter is available
            let editorConfig = {
                toolbar: [
                    'heading', '|',
                    'bold', 'italic', 'link', '|',
                    'bulletedList', 'numberedList', '|',
                    'blockQuote', '|',
                    'undo', 'redo'
                ]
            };
            
            // Add upload feature if adapter is available
            if (typeof CustomUploadAdapterPlugin !== 'undefined') {
                console.log('Upload adapter available');
                editorConfig.extraPlugins = [CustomUploadAdapterPlugin];
                editorConfig.toolbar.splice(6, 0, 'uploadImage');
            } else {
                console.log('Upload adapter not available');
            }

            // Initialize CKEditor
            ClassicEditor
                .create(document.querySelector('#editor'), editorConfig)
                .then(editor => {
                    console.log('CKEditor initialized successfully');
                    editorInstance = editor;
                    // Sync editor content with hidden textarea
                    editor.model.document.on('change:data', () => {
                        document.querySelector('#description').value = editor.getData();
                    });
                })
                .catch(error => {
                    console.error('CKEditor initialization failed:', error);
                    // Fallback to regular textarea
                    document.querySelector('#editor').style.display = 'none';
                    const fallbackTextarea = document.createElement('textarea');
                    fallbackTextarea.className = 'form-control';
                    fallbackTextarea.id = 'descriptionFallback';
                    fallbackTextarea.name = 'description';
                    fallbackTextarea.rows = 6;
                    fallbackTextarea.placeholder = 'Mô tả chi tiết về phòng trọ...';
                    document.querySelector('#editor').parentNode.appendChild(fallbackTextarea);
                });
        });

        // Handle file upload preview
        function handleFilePreview() {
            const fileInput = document.getElementById('featuredImageFile');
            const preview = document.getElementById('imagePreview');
            const urlInput = document.getElementById('featuredImage');
            
            if (fileInput.files && fileInput.files[0]) {
                const file = fileInput.files[0];
                
                // Check file size (limit to 5MB)
                if (file.size > 5 * 1024 * 1024) {
                    alert('File quá lớn! Vui lòng chọn file nhỏ hơn 5MB.');
                    fileInput.value = '';
                    return;
                }
                
                // Check file type
                if (!file.type.startsWith('image/')) {
                    alert('Vui lòng chọn file ảnh!');
                    fileInput.value = '';
                    return;
                }
                
                // Clear URL input when file is selected
                urlInput.value = '';
                
                // Create preview
                const reader = new FileReader();
                reader.onload = function(e) {
                    preview.innerHTML = '<img src="' + e.target.result + '" alt="Preview">';
                };
                reader.readAsDataURL(file);
            }
        }
        // Preview image function
        function previewImage() {
            const imageUrl = document.getElementById('featuredImage').value;
            const preview = document.getElementById('imagePreview');
            const fileInput = document.getElementById('featuredImageFile');
            
            if (imageUrl) {
                // Clear file input when URL is entered
                fileInput.value = '';
                preview.innerHTML = '<img src="' + imageUrl + '" alt="Preview" onerror="showImageError()">';
            } else {
                preview.innerHTML = '<div class="text-center text-muted"><i class="fas fa-image fa-3x mb-2"></i><p>Xem trước ảnh</p></div>';
            }
        }

        function showImageError() {
            document.getElementById('imagePreview').innerHTML = '<div class="text-center text-danger"><i class="fas fa-exclamation-triangle fa-2x mb-2"></i><p>Không thể tải ảnh</p></div>';
        }

        // Load rooms when rental area changes
        function loadRooms() {
            const rentalAreaId = document.getElementById('rentalAreaId').value;
            const roomSelection = document.getElementById('roomSelection');
            const roomList = document.getElementById('roomList');

            console.log('loadRooms called, rentalAreaId:', rentalAreaId); // Debug log

            if (rentalAreaId && rentalAreaId.trim() !== '') {
                roomSelection.style.display = 'block';
                roomList.innerHTML = '<div class="text-center"><i class="fas fa-spinner fa-spin"></i> Đang tải danh sách phòng...</div>';
                
                const apiUrl = 'getRoom?areaId=' + rentalAreaId;
                console.log('Making AJAX call to:', apiUrl); // Debug log
                
                // AJAX call to load rooms
                fetch(apiUrl)
                    .then(response => {
                        console.log('Response status:', response.status); // Debug log
                        if (!response.ok) {
                            throw new Error(`HTTP error! status: ${response.status}`);
                        }
                        return response.json();
                    })
                    .then(rooms => {
                        console.log('Rooms loaded:', rooms); // Debug log
                        if (rooms && rooms.length > 0) {
                            let roomHtml = '';
                            rooms.forEach(room => {
                                roomHtml += '<div class="room-item" onclick="selectRoom(this, ' + room.roomId + ')">';
                                roomHtml += '    <div class="form-check">';
                                roomHtml += '        <input class="form-check-input" type="radio" name="selectedRoom" value="' + room.roomId + '" id="room' + room.roomId + '">';
                                roomHtml += '        <label class="form-check-label" for="room' + room.roomId + '">';
                                roomHtml += '            <strong>Phòng ' + (room.roomNumber || 'N/A') + '</strong>';
                                roomHtml += '            <div class="text-muted">';
                                roomHtml += '                <i class="fas fa-dollar-sign"></i> ' + (room.price ? parseFloat(room.price).toLocaleString() : '0') + ' VNĐ/tháng |';
                                roomHtml += '                <i class="fas fa-expand-arrows-alt"></i> ' + (room.area || '0') + 'm² |';
                                roomHtml += '                <i class="fas fa-users"></i> ' + (room.maxTenants || '0') + ' người';
                                roomHtml += '            </div>';
                                if (room.description) {
                                    roomHtml += '            <div class="text-muted mt-1">' + room.description + '</div>';
                                }
                                roomHtml += '        </label>';
                                roomHtml += '    </div>';
                                roomHtml += '</div>';
                            });
                            roomList.innerHTML = roomHtml;
                        } else {
                            roomList.innerHTML = '<p class="text-muted text-center">Không có phòng nào trong khu trọ này.</p>';
                        }
                    })
                    .catch(error => {
                        console.error('Error loading rooms:', error);
                        roomList.innerHTML = '<p class="text-danger text-center">Có lỗi khi tải danh sách phòng. Vui lòng thử lại.</p>';
                    });
            } else {
                roomSelection.style.display = 'none';
            }
        }

        function selectRoom(element, roomId) {
            // Clear previous selections
            document.querySelectorAll('.room-item').forEach(item => {
                item.classList.remove('selected');
            });
            
            // Select current room
            const radio = element.querySelector('input[type="radio"]');
            radio.checked = true;
            element.classList.add('selected');
        }

        // Form validation
        document.getElementById('createPostForm').addEventListener('submit', function(e) {
            const title = document.getElementById('title').value.trim();
            const rentalAreaId = document.getElementById('rentalAreaId').value;
            const selectedRoom = document.querySelector('input[name="selectedRoom"]:checked');
            
            // Sync CKEditor content
            if (editorInstance) {
                document.getElementById('description').value = editorInstance.getData();
            }

            if (!title) {
                e.preventDefault();
                alert('Vui lòng nhập tiêu đề tin đăng!');
                document.getElementById('title').focus();
                return;
            }

            if (!rentalAreaId) {
                e.preventDefault();
                alert('Vui lòng chọn khu trọ!');
                document.getElementById('rentalAreaId').focus();
                return;
            }

            if (!selectedRoom) {
                e.preventDefault();
                alert('Vui lòng chọn một phòng cho tin đăng!');
                return;
            }
        });
    </script>
</body>
</html>
