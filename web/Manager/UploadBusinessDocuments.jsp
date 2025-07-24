<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Upload Giấy Tờ Kinh Doanh - House Sharing</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        body {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            padding: 2rem 0;
        }
        .upload-container {
            background: white;
            border-radius: 20px;
            box-shadow: 0 20px 40px rgba(0,0,0,0.1);
            overflow: hidden;
            max-width: 900px;
            width: 100%;
        }
        .upload-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 2rem;
            text-align: center;
        }
        .upload-body {
            padding: 2rem;
        }
        .form-control {
            border-radius: 10px;
            border: 2px solid #e0e6ed;
            padding: 12px 15px;
            transition: all 0.3s;
        }
        .form-control:focus {
            border-color: #667eea;
            box-shadow: 0 0 0 0.2rem rgba(102, 126, 234, 0.25);
        }
        .btn-primary {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border: none;
            padding: 12px 30px;
            border-radius: 10px;
            font-weight: 600;
            transition: all 0.3s;
        }
        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 20px rgba(0,0,0,0.1);
        }
        .step-indicator {
            display: flex;
            justify-content: center;
            margin-bottom: 2rem;
        }
        .step {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 10px;
            font-weight: bold;
            position: relative;
        }
        .step.active {
            background: #667eea;
            color: white;
        }
        .step.completed {
            background: #28a745;
            color: white;
        }
        .step.inactive {
            background: #e0e6ed;
            color: #6c757d;
        }
        .step::after {
            content: '';
            position: absolute;
            top: 50%;
            left: 100%;
            width: 20px;
            height: 2px;
            background: #28a745;
            transform: translateY(-50%);
        }
        .step:last-child::after {
            display: none;
        }
        .step.inactive::after {
            background: #e0e6ed;
        }
        .file-upload {
            border: 3px dashed #e0e6ed;
            border-radius: 10px;
            padding: 2rem;
            text-align: center;
            transition: all 0.3s;
            cursor: pointer;
            position: relative;
            background: #f8f9fa;
        }
        .file-upload:hover {
            border-color: #667eea;
            background: #e8f2ff;
        }
        .file-upload.dragover {
            border-color: #667eea;
            background: #e8f2ff;
        }
        .file-upload input[type="file"] {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            opacity: 0;
            cursor: pointer;
        }
        .preview-container {
            margin-top: 1rem;
            text-align: center;
        }
        .preview-image {
            max-width: 200px;
            max-height: 200px;
            border-radius: 10px;
            box-shadow: 0 5px 15px rgba(0,0,0,0.1);
        }
        .required {
            color: #dc3545;
        }
        .form-section {
            background: #f8f9fa;
            border-radius: 15px;
            padding: 2rem;
            margin-bottom: 2rem;
            border-left: 4px solid #667eea;
        }
        .section-title {
            color: #667eea;
            font-size: 1.2rem;
            font-weight: 600;
            margin-bottom: 1rem;
            display: flex;
            align-items: center;
        }
        .section-title i {
            margin-right: 0.5rem;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="row justify-content-center">
            <div class="col-lg-10">
                <div class="upload-container">
                    <div class="upload-header">
                        <h2 class="mb-2">
                            <i class="fas fa-file-upload me-2"></i>
                            Upload Giấy Tờ Kinh Doanh
                        </h2>
                        <p class="mb-0">Chào ${managerName}, vui lòng cung cấp giấy tờ kinh doanh để xét duyệt</p>
                    </div>
                    
                    <div class="upload-body">
                        <!-- Step Indicator -->
                        <div class="step-indicator">
                            <div class="step completed">
                                <i class="fas fa-check"></i>
                            </div>
                            <div class="step active">
                                <span>2</span>
                            </div>
                        </div>
                        
                        <div class="text-center mb-4">
                            <h5>Bước 2: Upload giấy tờ kinh doanh</h5>
                            <p class="text-muted">Cung cấp đầy đủ giấy tờ để Super Admin có thể xét duyệt nhanh chóng</p>
                        </div>

                        <!-- Display Messages -->
                        <c:if test="${not empty sessionScope.error}">
                            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                                <i class="fas fa-exclamation-triangle me-2"></i>
                                ${sessionScope.error}
                                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                            </div>
                            <c:remove var="error" scope="session"/>
                        </c:if>

                        <form action="uploadBusinessDocuments" method="POST" enctype="multipart/form-data" id="uploadForm">
                            <input type="hidden" name="managerId" value="${managerId}">
                            
                            <!-- Thông tin doanh nghiệp -->
                            <div class="form-section">
                                <h6 class="section-title">
                                    <i class="fas fa-building"></i>
                                    Thông tin doanh nghiệp
                                </h6>
                                
                                <div class="row">
                                    <div class="col-md-6">
                                        <div class="mb-3">
                                            <label for="businessName" class="form-label">
                                                Tên doanh nghiệp <span class="required">*</span>
                                            </label>
                                            <input type="text" class="form-control" id="businessName" name="businessName" 
                                                   placeholder="Công ty TNHH ABC" required maxlength="200">
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <div class="mb-3">
                                            <label for="taxCode" class="form-label">
                                                Mã số thuế <span class="required">*</span>
                                            </label>
                                            <input type="text" class="form-control" id="taxCode" name="taxCode" 
                                                   placeholder="123456789" required maxlength="50" pattern="[0-9A-Z-]{8,15}">
                                        </div>
                                    </div>
                                </div>
                                
                                <div class="mb-3">
                                    <label for="businessAddress" class="form-label">
                                        Địa chỉ kinh doanh <span class="required">*</span>
                                    </label>
                                    <textarea class="form-control" id="businessAddress" name="businessAddress" rows="2" 
                                              placeholder="123 Nguyễn Văn A, Phường B, Quận C, TP.HCM" required maxlength="500"></textarea>
                                </div>
                            </div>

                            <!-- Thông tin người đại diện -->
                            <div class="form-section">
                                <h6 class="section-title">
                                    <i class="fas fa-user-tie"></i>
                                    Thông tin người đại diện pháp luật
                                </h6>
                                
                                <div class="row">
                                    <div class="col-md-6">
                                        <div class="mb-3">
                                            <label for="representativeName" class="form-label">
                                                Họ tên người đại diện <span class="required">*</span>
                                            </label>
                                            <input type="text" class="form-control" id="representativeName" name="representativeName" 
                                                   placeholder="Nguyễn Văn A" required maxlength="100">
                                        </div>
                                    </div>
                                    <div class="col-md-6">
                                        <div class="mb-3">
                                            <label for="representativeId" class="form-label">
                                                CMND/CCCD người đại diện <span class="required">*</span>
                                            </label>
                                            <input type="text" class="form-control" id="representativeId" name="representativeId" 
                                                   placeholder="123456789012" required maxlength="20" pattern="[0-9]{9,12}">
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- Upload files -->
                            <div class="form-section">
                                <h6 class="section-title">
                                    <i class="fas fa-cloud-upload-alt"></i>
                                    Tài liệu đính kèm
                                </h6>

                                <!-- Giấy phép kinh doanh -->
                                <div class="row">
                                    <div class="col-md-4">
                                        <div class="mb-3">
                                            <label class="form-label">
                                                Giấy phép kinh doanh <span class="required">*</span>
                                            </label>
                                            <div class="file-upload" onclick="document.getElementById('businessLicense').click()">
                                                <input type="file" id="businessLicense" name="businessLicense" 
                                                       accept="image/*,.pdf" required onchange="previewFile(this, 'businessLicensePreview')">
                                                <i class="fas fa-cloud-upload-alt fa-3x text-muted mb-3"></i>
                                                <p class="text-muted mb-0">Click để chọn file</p>
                                                <small class="text-muted">JPG, PNG, PDF (Max 10MB)</small>
                                            </div>
                                            <div id="businessLicensePreview" class="preview-container"></div>
                                        </div>
                                    </div>

                                    <!-- CMND mặt trước -->
                                    <div class="col-md-4">
                                        <div class="mb-3">
                                            <label class="form-label">
                                                CMND/CCCD mặt trước <span class="required">*</span>
                                            </label>
                                            <div class="file-upload" onclick="document.getElementById('idCardFront').click()">
                                                <input type="file" id="idCardFront" name="idCardFront" 
                                                       accept="image/*" required onchange="previewFile(this, 'idCardFrontPreview')">
                                                <i class="fas fa-id-card fa-3x text-muted mb-3"></i>
                                                <p class="text-muted mb-0">Click để chọn ảnh</p>
                                                <small class="text-muted">JPG, PNG (Max 10MB)</small>
                                            </div>
                                            <div id="idCardFrontPreview" class="preview-container"></div>
                                        </div>
                                    </div>

                                    <!-- CMND mặt sau -->
                                    <div class="col-md-4">
                                        <div class="mb-3">
                                            <label class="form-label">
                                                CMND/CCCD mặt sau <span class="required">*</span>
                                            </label>
                                            <div class="file-upload" onclick="document.getElementById('idCardBack').click()">
                                                <input type="file" id="idCardBack" name="idCardBack" 
                                                       accept="image/*" required onchange="previewFile(this, 'idCardBackPreview')">
                                                <i class="fas fa-id-card fa-3x text-muted mb-3"></i>
                                                <p class="text-muted mb-0">Click để chọn ảnh</p>
                                                <small class="text-muted">JPG, PNG (Max 10MB)</small>
                                            </div>
                                            <div id="idCardBackPreview" class="preview-container"></div>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <div class="alert alert-info" role="alert">
                                <h6 class="alert-heading"><i class="fas fa-info-circle me-2"></i>Lưu ý quan trọng</h6>
                                <ul class="mb-0">
                                    <li>Tất cả giấy tờ phải rõ ràng, đầy đủ thông tin</li>
                                    <li>Thông tin trên giấy tờ phải khớp với thông tin đã đăng ký</li>
                                    <li>Sau khi upload, Super Admin sẽ xem xét và phản hồi trong vòng 1-3 ngày làm việc</li>
                                    <li>Bạn sẽ nhận được email thông báo kết quả xét duyệt</li>
                                </ul>
                            </div>

                            <div class="d-grid gap-2">
                                <button type="submit" class="btn btn-primary btn-lg">
                                    <i class="fas fa-paper-plane me-2"></i>
                                    Gửi hồ sơ xét duyệt
                                </button>
                            </div>
                        </form>

                        <div class="text-center mt-4">
                            <p class="text-muted">
                                <a href="login" class="text-decoration-none">
                                    <i class="fas fa-arrow-left me-1"></i>
                                    Quay lại trang đăng nhập
                                </a>
                            </p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
        // Preview file function
        function previewFile(input, previewId) {
            const file = input.files[0];
            const preview = document.getElementById(previewId);
            
            if (file) {
                const reader = new FileReader();
                
                reader.onload = function(e) {
                    if (file.type.startsWith('image/')) {
                        preview.innerHTML = `
                            <img src="\${e.target.result}" class="preview-image" alt="Preview">
                            <p class="mt-2 mb-0 text-success">
                                <i class="fas fa-check-circle me-1"></i>
                                \${file.name} (\${(file.size / 1024 / 1024).toFixed(2)} MB)
                            </p>
                        `;
                    } else {
                        preview.innerHTML = `
                            <div class="alert alert-success p-2">
                                <i class="fas fa-file-pdf me-2"></i>
                                \${file.name} (\${(file.size / 1024 / 1024).toFixed(2)} MB)
                            </div>
                        `;
                    }
                }
                
                reader.readAsDataURL(file);
            } else {
                preview.innerHTML = '';
            }
        }

        // Form validation
        document.getElementById('uploadForm').addEventListener('submit', function(e) {
            const requiredFiles = ['businessLicense', 'idCardFront', 'idCardBack'];
            let valid = true;
            
            requiredFiles.forEach(fileId => {
                const fileInput = document.getElementById(fileId);
                if (!fileInput.files || !fileInput.files[0]) {
                    alert(`Vui lòng chọn file ${fileInput.previousElementSibling.textContent}`);
                    valid = false;
                    return;
                }
                
                const file = fileInput.files[0];
                if (file.size > 10 * 1024 * 1024) { // 10MB
                    alert(`File ${file.name} quá lớn. Vui lòng chọn file nhỏ hơn 10MB.`);
                    valid = false;
                    return;
                }
            });
            
            if (!valid) {
                e.preventDefault();
                return;
            }
            
            // Show loading state
            const submitBtn = this.querySelector('button[type="submit"]');
            submitBtn.innerHTML = '<span class="spinner-border spinner-border-sm me-2"></span>Đang upload...';
            submitBtn.disabled = true;
        });

        // Drag and drop support
        document.querySelectorAll('.file-upload').forEach(uploadArea => {
            uploadArea.addEventListener('dragover', function(e) {
                e.preventDefault();
                this.classList.add('dragover');
            });
            
            uploadArea.addEventListener('dragleave', function() {
                this.classList.remove('dragover');
            });
            
            uploadArea.addEventListener('drop', function(e) {
                e.preventDefault();
                this.classList.remove('dragover');
                
                const fileInput = this.querySelector('input[type="file"]');
                const files = e.dataTransfer.files;
                
                if (files.length > 0) {
                    fileInput.files = files;
                    const previewId = fileInput.getAttribute('onchange').match(/'([^']+)'/)[1];
                    previewFile(fileInput, previewId);
                }
            });
        });
    </script>
</body>
</html>
