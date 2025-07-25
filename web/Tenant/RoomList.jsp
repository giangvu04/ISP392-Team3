<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Danh sách Phòng - Tenant Dashboard</title>
    <base href="${pageContext.request.contextPath}/">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link href="css/rooms.css" rel="stylesheet">
    <style>
        .search-input-group .input-group-text {
            background: #f8f9fa;
            border: none;
            padding: 0.375rem 0.75rem;
            border-radius: 8px 0 0 8px;
        }
        .search-input-group .form-control {
            border: none;
            background: #f8f9fa;
            box-shadow: none;
            border-radius: 0 8px 8px 0;
        }
        .search-input-group .form-control:focus {
            box-shadow: 0 0 0 0.2rem rgba(0,123,255,.25);
            background: #ffffff;
        }
        .search-input-group .fas {
            color: #6c757d;
        }
        
        .room-card {
            display: flex;
            flex-direction: column;
            height: 100%;
            border: none;
            border-radius: 16px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.1);
            transition: all 0.3s ease;
            overflow: hidden;
        }
        
        .room-card:hover {
            transform: translateY(-8px);
            box-shadow: 0 8px 30px rgba(0,0,0,0.15);
        }
        
        .room-image-container {
            position: relative;
            height: 140px;
            overflow: hidden;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        }
        
        .room-image {
            width: 100%;
            height: 100%;
            object-fit: cover;
            transition: transform 0.3s ease;
        }
        
        .room-card:hover .room-image {
            transform: scale(1.05);
        }
        
        .room-status-badge {
            position: absolute;
            top: 8px;
            right: 8px;
            z-index: 2;
            border-radius: 12px;
            padding: 4px 8px;
            font-size: 0.65rem;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.3px;
        }
        
        .status-available {
            background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
            color: white;
        }
        
        .status-occupied {
            background: linear-gradient(135deg, #fa709a 0%, #fee140 100%);
            color: white;
        }
        
        .status-maintenance {
            background: linear-gradient(135deg, #ff9a9e 0%, #fecfef 100%);
            color: #333;
        }
        
        .room-card .card-body {
            display: flex;
            flex-direction: column;
            flex-grow: 1;
            padding: 1rem;
        }
        
        .room-title {
            font-size: 1.1rem;
            font-weight: 700;
            margin-bottom: 0.75rem;
            color: #2c3e50;
        }
        
        .room-info-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 0.5rem;
            padding: 0.5rem 0;
            border-bottom: 1px solid #f1f3f4;
        }
        
        .room-info-row:last-child {
            border-bottom: none;
        }
        
        .room-info-label {
            font-size: 0.85rem;
            color: #6c757d;
            font-weight: 500;
        }
        
        .room-info-value {
            font-size: 0.85rem;
            font-weight: 600;
            color: #2c3e50;
        }
        
        .room-price-value {
            font-size: 1.1rem;
            font-weight: 700;
            color: #e74c3c;
        }
        
        .description-block {
            background: #f8f9fa;
            padding: 0.75rem;
            border-radius: 6px;
            margin-bottom: 0.75rem;
            height: 60px;
            overflow: hidden;
            position: relative;
        }
        
        .description-text {
            font-size: 0.8rem;
            color: #6c757d;
            line-height: 1.3;
            display: -webkit-box;
            -webkit-line-clamp: 3;
            -webkit-box-orient: vertical;
            overflow: hidden;
            text-align: justify;
        }
        
        .description-text::after {
            content: "...";
            position: absolute;
            bottom: 0.75rem;
            right: 0.75rem;
            background: #f8f9fa;
            padding-left: 1rem;
        }
        
        .room-card .btn-primary {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border: none;
            border-radius: 8px;
            padding: 0.75rem 1.5rem;
            font-weight: 600;
            transition: all 0.3s ease;
        }
        
        .room-card .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 15px rgba(102, 126, 234, 0.4);
        }
        
        .room-card .btn-secondary {
            background: #e9ecef;
            border: none;
            border-radius: 8px;
            padding: 0.75rem 1.5rem;
            font-weight: 600;
            color: #6c757d;
        }
        
        .button-group .btn {
            flex: 1;
            margin-right: 0.5rem;
            border-radius: 8px;
            font-weight: 600;
            transition: all 0.3s ease;
        }
        
        .button-group .btn:last-child {
            margin-right: 0;
        }
        
        .button-group .btn-primary {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border: none;
        }
        
        .button-group .btn-outline-secondary {
            border: 2px solid #e9ecef;
            color: #6c757d;
        }
        
        .button-group .btn-outline-secondary:hover {
            background: #e9ecef;
            transform: translateY(-2px);
        }
        
        .form-select, .form-control {
            border-radius: 8px;
            border: 1px solid #dee2e6;
            padding: 0.75rem;
        }
        
        .form-select:focus, .form-control:focus {
            border-color: #667eea;
            box-shadow: 0 0 0 0.2rem rgba(102, 126, 234, 0.25);
        }
        
        .main-content {
            background: #f8f9fa;
            min-height: 100vh;
        }
        
        .page-header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 2rem;
            border-radius: 16px;
            margin-bottom: 2rem;
        }
        
        .search-card {
            border-radius: 16px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.1);
            border: none;
        }
        
        .no-rooms-container {
            text-align: center;
            padding: 4rem 2rem;
            background: white;
            border-radius: 16px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.1);
        }
        
        .pagination .page-link {
            border-radius: 8px;
            margin: 0 0.25rem;
            border: none;
            background: #f8f9fa;
            color: #6c757d;
        }
        
        .pagination .page-item.active .page-link {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }
        
        .image-placeholder {
            width: 100%;
            height: 100%;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 3rem;
        }
        
        @media (max-width: 768px) {
            .room-info-grid {
                grid-template-columns: 1fr;
            }
            
            .room-image-container {
                height: 180px;
            }
            
            .room-title {
                font-size: 1.2rem;
            }
            
            .room-price {
                font-size: 1.3rem;
            }
        }
    </style>
</head>
<body>
    <div class="container-fluid">
        <div class="row">
            <jsp:include page="../Sidebar/SideBarTelnant.jsp"/>
            <div class="col-md-9 col-lg-10">
                <div class="main-content p-4">
                    <div class="page-header">
                        <h2 class="mb-2">🏠 Danh sách Phòng Trọ</h2>
                        <p class="mb-0 opacity-75">Tìm kiếm và khám phá các phòng trọ tốt nhất cho bạn</p>
                    </div>
                    
                    <div class="card search-card mb-4">
                        <div class="card-body">
                            <form method="GET" action="listrooms" class="row g-3 align-items-center">
                                <div class="col-12 col-md-8">
                                    <div class="input-group search-input-group">
                                        <span class="input-group-text">
                                            <i class="fas fa-search"></i>
                                        </span>
                                        <input type="text" class="form-control" name="searchTerm" 
                                               placeholder="Tìm kiếm theo số phòng..." 
                                               value="${searchTerm}">
                                    </div>
                                </div>
                                <div class="col-12 col-md-2">
                                    <select class="form-select" name="sortBy">
                                        <option value="roomNumber" ${sortBy == 'roomNumber' ? 'selected' : ''}>Sắp xếp theo số phòng</option>
                                        <option value="price" ${sortBy == 'price' ? 'selected' : ''}>Sắp xếp theo giá</option>
                                        <option value="status" ${sortBy == 'status' ? 'selected' : ''}>Sắp xếp theo trạng thái</option>
                                    </select>
                                </div>
                                <div class="col-12 col-md-2">
                                    <select class="form-select" name="sortOrder">
                                        <option value="asc" ${sortOrder == 'asc' ? 'selected' : ''}>Tăng dần</option>
                                        <option value="desc" ${sortOrder == 'desc' ? 'selected' : ''}>Giảm dần</option>
                                    </select>
                                </div>
                                <div class="col-12 col-md-4">
                                    <select class="form-select" name="provinceId" id="provinceId">
                                        <option value="" ${empty provinceId ? 'selected' : ''}>📍 Chọn tỉnh/thành</option>
                                        <c:forEach var="provinces" items="${provinces}">
                                            <option value="${provinces}">${provinces}</option>
                                        </c:forEach>
                                    </select>
                                </div>
                                <div class="col-12 col-md-4">
                                    <select class="form-select" name="districtId" id="districtId" disabled>
                                        <option value="" ${empty districtId ? 'selected' : ''}>🏘️ Chọn quận/huyện</option>
                                    </select>
                                </div>
                                <div class="col-12 col-md-4">
                                    <select class="form-select" name="wardId" id="wardId" disabled>
                                        <option value="" ${empty wardId ? 'selected' : ''}>🏠 Chọn phường/xã</option>
                                    </select>
                                </div>
                                <div class="col-12 col-md-4 d-flex button-group">
                                    <button type="submit" class="btn btn-primary">
                                        <i class="fas fa-search me-2"></i>
                                        Tìm kiếm
                                    </button>
                                    <a href="listrooms" class="btn btn-outline-secondary">
                                        <i class="fas fa-refresh me-2"></i>
                                        Làm mới
                                    </a>
                                </div>
                            </form>
                        </div>
                    </div>
                    
                    <div class="row">
                        <c:forEach var="room" items="${rooms}">
                            <div class="col-md-6 col-lg-4 mb-4">
                                <div class="card room-card h-100">
                                    <div class="room-image-container">
                                        <c:choose>
                                            <c:when test="${not empty room.imageUrl}">
                                                <img src="${room.imageUrl}" alt="Phòng ${room.roomNumber}" class="room-image">
                                            </c:when>
                                            <c:otherwise>
                                                <div class="image-placeholder">
                                                    <i class="fas fa-bed"></i>
                                                </div>
                                            </c:otherwise>
                                        </c:choose>
                                        
                                        <c:choose>
                                            <c:when test="${room.status == 0}">
                                                <span class="room-status-badge status-available">
                                                    <i class="fas fa-check-circle me-1"></i>
                                                    Còn trống
                                                </span>
                                            </c:when>
                                            <c:when test="${room.status == 1}">
                                                <span class="room-status-badge status-occupied">
                                                    <i class="fas fa-user me-1"></i>
                                                    Đã thuê
                                                </span>
                                            </c:when>
                                            <c:when test="${room.status == 2}">
                                                <span class="room-status-badge status-maintenance">
                                                    <i class="fas fa-tools me-1"></i>
                                                    Bảo trì
                                                </span>
                                            </c:when>
                                        </c:choose>
                                    </div>
                                    
                                    <div class="card-body">
                                        <h5 class="room-title">🏠 Phòng ${room.roomNumber}</h5>
                                        
                                        <div class="room-info-grid">
                                            <div class="room-info-item">
                                                <div style="font-size: 16px; margin-bottom: 6px" class="room-info-label">Khu vực ${room.rentalAreaName}</div>
                                                
                                            </div>
                                            <div class="room-info-item">
                                                <div style="font-size: 16px ;margin-bottom: 6px" class="room-info-label">Diện tích ${room.area} m²</div>
                                                
                                            </div>
                                        </div>
                                        
                                                <div style="font-size: 16px ;margin-bottom: 16px" class="room-price">
                                            💰 ${room.price} VNĐ/tháng
                                        </div>
                                        
                                        <div class="description-block">
                                            <div class="description-text">
                                                <c:choose>
                                                    <c:when test="${not empty room.description}">
                                                        ${room.description}
                                                    </c:when>
                                                    <c:otherwise>
                                                        Phòng trọ chất lượng cao, đầy đủ tiện nghi, vị trí thuận lợi cho việc di chuyển và sinh hoạt hàng ngày.
                                                    </c:otherwise>
                                                </c:choose>
                                            </div>
                                        </div>
                                        
                                        <div class="d-grid mt-auto">
                                            <c:if test="${room.status == 0}">
                                                <a href="detailRoom?id=${room.roomId}" class="btn btn-primary">
                                                    <i class="fas fa-eye me-2"></i>
                                                    Xem chi tiết
                                                </a>
                                            </c:if>
                                            <c:if test="${room.status != 0}">
                                                <button class="btn btn-secondary" disabled>
                                                    <i class="fas fa-lock me-2"></i>
                                                    Không khả dụng
                                                </button>
                                            </c:if>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                    
                    <c:if test="${empty rooms}">
                        <div class="no-rooms-container">
                            <i class="fas fa-search fa-4x text-muted mb-4"></i>
                            <h4 class="text-muted mb-3">Không tìm thấy phòng trọ nào</h4>
                            <p class="text-muted mb-4">Hãy thử thay đổi tiêu chí tìm kiếm hoặc mở rộng khu vực tìm kiếm</p>
                            <a href="listrooms" class="btn btn-primary">
                                <i class="fas fa-refresh me-2"></i>
                                Xem tất cả phòng
                            </a>
                        </div>
                    </c:if>
                    
                    <c:if test="${totalPages > 1}">
                        <nav aria-label="Room pagination" class="mt-4">
                            <ul class="pagination justify-content-center">
                                <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                                    <a class="page-link" href="listrooms?page=${currentPage - 1}&sortBy=${sortBy}&sortOrder=${sortOrder}&searchTerm=${searchTerm}&provinceId=${provinceId}&districtId=${districtId}&wardId=${wardId}">
                                        <i class="fas fa-chevron-left"></i>
                                    </a>
                                </li>
                                <c:forEach begin="1" end="${totalPages}" var="i">
                                    <li class="page-item ${currentPage == i ? 'active' : ''}">
                                        <a class="page-link" href="listrooms?page=${i}&sortBy=${sortBy}&sortOrder=${sortOrder}&searchTerm=${searchTerm}&provinceId=${provinceId}&districtId=${districtId}&wardId=${wardId}">${i}</a>
                                    </li>
                                </c:forEach>
                                <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                                    <a class="page-link" href="listrooms?page=${currentPage + 1}&sortBy=${sortBy}&sortOrder=${sortOrder}&searchTerm=${searchTerm}&provinceId=${provinceId}&districtId=${districtId}&wardId=${wardId}">
                                        <i class="fas fa-chevron-right"></i>
                                    </a>
                                </li>
                            </ul>
                        </nav>
                    </c:if>
                </div>
            </div>
        </div>
        
        <jsp:include page="../Message.jsp"/>
        
        <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        <script>
$(document).ready(function() {
    // Load districts when province changes
    $('#provinceId').change(function() {
        const provinceId = $(this).val();
        loadDistricts(provinceId);
    });

    // Load wards when district changes
    $('#districtId').change(function() {
        const districtId = $(this).val();
        loadWards(districtId);
    });

    // Initialize districts and wards if provinceId or districtId are pre-selected
    if ($('#provinceId').val()) {
        loadDistricts($('#provinceId').val());
    }

    // Function to load districts
    function loadDistricts(provinceId) {
        console.log('Calling loadDistricts with provinceId:', provinceId);
        const districtSelect = $('#districtId');
        const wardSelect = $('#wardId');

        // Clear existing options except the first one
        districtSelect.empty().append('<option value="">🏘️ Chọn quận/huyện</option>');
        wardSelect.empty().append('<option value="">🏠 Chọn phường/xã</option>');
        districtSelect.prop('disabled', true);
        wardSelect.prop('disabled', true);

        if (!provinceId) {
            return;
        }

        $.ajax({
            url: '${pageContext.request.contextPath}/locations',
            method: 'POST',
            data: { type: 'district', province: provinceId },
            dataType: 'json',
            success: function(data) {
                console.log('Received districts:', data);
                if (!data || !Array.isArray(data) || data.length === 0) {
                    console.warn('Districts data is empty or invalid:', data);
                    return;
                }
                districtSelect.empty().append('<option value="">🏘️ Chọn quận/huyện</option>');
                $.each(data, function(index, district) {
                    districtSelect.append('<option value="' + district + '">' + district + '</option>');
                });
                districtSelect.prop('disabled', false);
                // Trigger ward loading if a district is pre-selected or selected
                const tempDistrict = districtSelect.val() || '${districtId}';
                if (tempDistrict) {
                    districtSelect.val(tempDistrict).trigger('change');
                }
            },
            error: function(xhr, status, error) {
                console.error('AJAX error in loadDistricts:', error, xhr.responseText);
            }
        });
    }

    // Function to load wards
    function loadWards(districtId) {
        console.log('Calling loadWards with districtId:', districtId);
        const wardSelect = $('#wardId');
        wardSelect.empty().append('<option value="">🏠 Chọn phường/xã</option>');
        wardSelect.prop('disabled', true);

        if (!districtId) {
            return;
        }

        $.ajax({
            url: '${pageContext.request.contextPath}/locations',
            method: 'POST',
            data: { type: 'ward', district: districtId },
            dataType: 'json',
            success: function(data) {
                console.log('Received wards:', data);
                if (!data || !Array.isArray(data) || data.length === 0) {
                    console.warn('Wards data is empty or invalid:', data);
                    return;
                }
                wardSelect.empty().append('<option value="">🏠 Chọn phường/xã</option>');
                $.each(data, function(index, ward) {
                    wardSelect.append('<option value="' + ward + '">' + ward + '</option>');
                });
                wardSelect.prop('disabled', false);
                // Set pre-selected ward if available
                if ('${wardId}') {
                    wardSelect.val('${wardId}');
                }
            },
            error: function(xhr, status, error) {
                console.error('AJAX error in loadWards:', error, xhr.responseText);
            }
        });
    }
});
        </script>
    </body>
</html>