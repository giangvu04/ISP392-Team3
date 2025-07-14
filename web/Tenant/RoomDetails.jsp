<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chi Tiết Phòng ${room.roomNumber} - Tenant Dashboard</title>
    <base href="${pageContext.request.contextPath}/">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/lightbox2/2.11.3/css/lightbox.min.css" rel="stylesheet">
    <link href="css/rooms.css" rel="stylesheet">
    <style>
        :root {
            --primary-gradient: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            --secondary-gradient: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
            --accent-gradient: linear-gradient(135deg, #fa709a 0%, #fee140 100%);
            --success-gradient: linear-gradient(135deg, #56ab2f 0%, #a8e6cf 100%);
            --danger-gradient: linear-gradient(135deg, #ff416c 0%, #ff4b2b 100%);
        }

        body {
            background: #f8f9fa;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

        .main-content {
            min-height: 100vh;
            padding: 2rem;
        }

        .page-header {
            background: var(--primary-gradient);
            color: white;
            padding: 2rem;
            border-radius: 20px;
            margin-bottom: 2rem;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
        }

        .breadcrumb {
            background: rgba(255,255,255,0.1);
            border-radius: 10px;
            padding: 0.5rem 1rem;
            margin-bottom: 1rem;
        }

        .breadcrumb-item a {
            color: white;
            text-decoration: none;
            opacity: 0.8;
        }

        .breadcrumb-item.active {
            color: white;
        }

        .room-gallery {
            background: white;
            border-radius: 20px;
            padding: 2rem;
            margin-bottom: 2rem;
            box-shadow: 0 8px 25px rgba(0,0,0,0.1);
        }

        .main-image {
            width: 100%;
            height: 400px;
            object-fit: cover;
            border-radius: 15px;
            cursor: pointer;
            transition: transform 0.3s ease;
        }

        .main-image:hover {
            transform: scale(1.02);
        }

        .thumbnail-container {
            margin-top: 1rem;
        }

        .thumbnail {
            width: 100px;
            height: 80px;
            object-fit: cover;
            border-radius: 10px;
            cursor: pointer;
            transition: all 0.3s ease;
            border: 3px solid transparent;
        }

        .thumbnail:hover {
            border-color: #667eea;
            transform: scale(1.05);
        }

        .thumbnail.active {
            border-color: #667eea;
        }

        .info-card {
            background: white;
            border-radius: 20px;
            padding: 2rem;
            margin-bottom: 2rem;
            box-shadow: 0 8px 25px rgba(0,0,0,0.1);
            border: none;
        }

        .status-badge {
            display: inline-flex;
            align-items: center;
            padding: 0.75rem 1.5rem;
            border-radius: 25px;
            font-weight: 600;
            font-size: 0.9rem;
            margin-bottom: 1rem;
        }

        .status-available {
            background: var(--success-gradient);
            color: white;
        }

        .status-occupied {
            background: var(--accent-gradient);
            color: white;
        }

        .status-maintenance {
            background: var(--danger-gradient);
            color: white;
        }

        .room-title {
            font-size: 2.5rem;
            font-weight: 700;
            color: #2c3e50;
            margin-bottom: 1rem;
        }

        .room-price {
            font-size: 2rem;
            font-weight: 700;
            color: #e74c3c;
            margin-bottom: 1.5rem;
        }

        .info-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            margin-bottom: 1.2rem;
        }

        .info-item {
            background: #f8f9fa;
            padding: 1.5rem;
            border-radius: 15px;
            text-align: center;
            transition: transform 0.3s ease;
        }

        .info-item:hover {
            transform: translateY(-5px);
        }

        .info-icon {
            font-size: 1.2rem;
            
        }

        .info-label {
            font-size: 0.9rem;
            color: #6c757d;
            margin-bottom: 0.5rem;
        }

        .info-value {
            font-size: 1.1rem;
            font-weight: 600;
            color: #2c3e50;
        }

        .section-title {
            font-size: 1.5rem;
            font-weight: 700;
            color: #2c3e50;
            margin-bottom: 1.5rem;
            display: flex;
            align-items: center;
        }

        .section-title i {
            margin-right: 0.5rem;
            color: #667eea;
        }

        .amenities-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 1rem;
        }

        .amenity-item {
            background: #f8f9fa;
            padding: 1rem;
            border-radius: 10px;
            display: flex;
            align-items: center;
            transition: all 0.3s ease;
        }

        .amenity-item:hover {
            background: #e9ecef;
            transform: translateY(-2px);
        }

        .amenity-icon {
            font-size: 1.5rem;
            margin-right: 1rem;
            color: #667eea;
        }

        .feedback-item {
            background: #f8f9fa;
            padding: 1.5rem;
            border-radius: 15px;
            margin-bottom: 1rem;
            border-left: 4px solid #667eea;
        }

        .feedback-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 1rem;
        }

        .feedback-author {
            font-weight: 600;
            color: #2c3e50;
        }

        .feedback-rating {
            color: #ffc107;
        }

        .feedback-date {
            color: #6c757d;
            font-size: 0.9rem;
        }

        .feedback-content {
            color: #495057;
            line-height: 1.6;
        }

        .map-container {
            background: white;
            border-radius: 20px;
            padding: 2rem;
            margin-top: 2rem;
            box-shadow: 0 8px 25px rgba(0,0,0,0.1);
        }

        .map-frame {
            width: 100%;
            height: 400px;
            border: none;
            border-radius: 15px;
        }

        .contact-buttons {
            display: flex;
            gap: 1rem;
            margin-top: 2rem;
        }

        .btn-contact {
            flex: 1;
            padding: 1rem;
            font-weight: 600;
            border-radius: 15px;
            border: none;
            transition: all 0.3s ease;
            text-decoration: none;
            text-align: center;
            display: inline-flex;
            align-items: center;
            justify-content: center;
        }

        .btn-primary-custom {
            background: var(--primary-gradient);
            color: white;
        }

        .btn-primary-custom:hover {
            transform: translateY(-3px);
            box-shadow: 0 10px 25px rgba(102, 126, 234, 0.4);
            color: white;
        }

        .btn-secondary-custom {
            background: var(--secondary-gradient);
            color: white;
        }

        .btn-secondary-custom:hover {
            transform: translateY(-3px);
            box-shadow: 0 10px 25px rgba(79, 172, 254, 0.4);
            color: white;
        }

        .description-box {
            background: #f8f9fa;
            padding: 2rem;
            border-radius: 15px;
            margin-bottom: 2rem;
        }

        .description-text {
            line-height: 1.8;
            color: #495057;
            font-size: 1.1rem;
        }

        .rating-summary {
            background: linear-gradient(135deg, #ffeaa7 0%, #fab1a0 100%);
            padding: 1.5rem;
            border-radius: 15px;
            margin-bottom: 2rem;
            text-align: center;
        }

        .rating-number {
            font-size: 3rem;
            font-weight: 700;
            color: white;
            margin-bottom: 0.5rem;
        }

        .rating-stars {
            font-size: 1.5rem;
            color: #ffc107;
            margin-bottom: 0.5rem;
        }

        .rating-text {
            color: white;
            font-weight: 600;
        }

        @media (max-width: 768px) {
            .room-title {
                font-size: 2rem;
            }

            .room-price {
                font-size: 1rem;
            }

            .info-grid {
                grid-template-columns: 1fr;
            }

            .contact-buttons {
                flex-direction: column;
            }

            .main-image {
                height: 250px;
            }

            .thumbnail {
                width: 80px;
                height: 60px;
            }
        }
    </style>
</head>
<body>
    <div class="container-fluid">
        <div class="row">
            <jsp:include page="../Sidebar/SideBarTelnant.jsp"/>
            <div class="col-md-9 col-lg-10">
                <div class="main-content">
                    <div class="page-header">
                        <nav aria-label="breadcrumb">
                            <ol class="breadcrumb">
                                <li class="breadcrumb-item"><a href="TenantHomepage">Dashboard</a></li>
                                <li class="breadcrumb-item"><a href="listRooms">Danh sách phòng</a></li>
                                <li class="breadcrumb-item active">Chi tiết phòng ${room.roomNumber}</li>
                            </ol>
                        </nav>
                        <h1 class="mb-2">🏠 Chi Tiết Phòng Trọ</h1>
                        <p class="mb-0 opacity-75">Thông tin chi tiết về phòng ${room.roomNumber}</p>
                    </div>

                    <div class="row">
                        <!-- Gallery Section -->
                        <div class="col-lg-8">
                            <div class="room-gallery">
                                <h3 class="section-title">
                                    <i class="fas fa-images"></i>
                                    Hình ảnh phòng
                                </h3>
                                <div class="main-image-container">
                                    <c:choose>
                                        <c:when test="${not empty room.imageUrl}">
                                            <img src="${room.imageUrl}" alt="Phòng ${room.roomNumber}" class="main-image" id="mainImage" data-lightbox="room-gallery">
                                        </c:when>
                                        <c:otherwise>
                                            <div class="main-image d-flex align-items-center justify-content-center" style="background: var(--primary-gradient); color: white;">
                                                <i class="fas fa-bed fa-5x"></i>
                                            </div>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                                
                                <div class="thumbnail-container">
                                    <div class="row">
                                        <c:forEach var="image" items="${image}" varStatus="status">
                                            <div class="col-auto">
                                                <img src="${image.urlImage}" alt="Ảnh ${status.index + 1}" class="thumbnail" onclick="changeMainImage('${image.urlImage}')" data-lightbox="room-gallery">
                                            </div>
                                        </c:forEach>
                                        <!-- Demo thumbnails if no images -->
                                        <c:if test="${empty image}">
                                            <div class="col-auto">
                                                <div class="thumbnail d-flex align-items-center justify-content-center" style="background: var(--primary-gradient); color: white;">
                                                    <i class="fas fa-bed"></i>
                                                </div>
                                            </div>
                                            <div class="col-auto">
                                                <div class="thumbnail d-flex align-items-center justify-content-center" style="background: var(--secondary-gradient); color: white;">
                                                    <i class="fas fa-bath"></i>
                                                </div>
                                            </div>
                                            <div class="col-auto">
                                                <div class="thumbnail d-flex align-items-center justify-content-center" style="background: var(--accent-gradient); color: white;">
                                                    <i class="fas fa-tv"></i>
                                                </div>
                                            </div>
                                        </c:if>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Room Info Section -->
                        <div class="col-lg-4">
                            <div class="info-card">
                                <c:choose>
                                    <c:when test="${room.status == 0}">
                                        <span class="status-badge status-available">
                                            <i class="fas fa-check-circle me-2"></i>
                                            Còn trống
                                        </span>
                                    </c:when>
                                    <c:when test="${room.status == 1}">
                                        <span class="status-badge status-occupied">
                                            <i class="fas fa-user me-2"></i>
                                            Đã thuê
                                        </span>
                                    </c:when>
                                    <c:when test="${room.status == 2}">
                                        <span class="status-badge status-maintenance">
                                            <i class="fas fa-tools me-2"></i>
                                            Bảo trì
                                        </span>
                                    </c:when>
                                </c:choose>

                                <h2 class="room-title">Phòng ${room.roomNumber}</h2>
                                <div style="font-size: 24px" class="room-price">💰 ${room.price} VNĐ/tháng</div>

                                <div class="info-grid">
                                    
                                        <div class="info-icon">
                                            <a style="font-size: 16px">* Diện tích: ${room.area} m²</a>
                                        </div>
                                        <div class="info-icon">
                                            <a style="font-size: 16px">* Khu vực: ${rentail.name}</a>
                                        </div>
                                        <div class="info-icon">
                                            <a style="font-size: 16px">* Địa chỉ: ${rentail.address}</a>
                                        </div>
                                        <div class="info-icon">
                                            <a style="font-size: 16px">* Số người ở tối đa: ${room.maxTenants} người</a>
                                        </div>
                                        
                                </div>

                                <div class="contact-buttons">
<c:if test="${room.status == 0}">
    <button type="button" class="btn-contact btn-primary-custom" data-bs-toggle="modal" data-bs-target="#rentModal">
        <i class="fas fa-calendar-check me-2"></i>
        Đặt phòng ngay
    </button>
</c:if>
                                    
                                </div>
                                        <div class="contact-buttons">
                                        <a href="tel:${manager.phoneNumber}" class="btn-contact btn-secondary-custom">
                                        <i class="fas fa-phone me-2"></i>
                                        Gọi điện
                                    </a></div>
                                        
                            </div>
                        </div>
                    </div>

                    <!-- Description Section -->
                    <div class="info-card">
                        <h3 class="section-title">
                            <i class="fas fa-info-circle"></i>
                            Mô tả chi tiết
                        </h3>
                        <div class="description-box">
                            <div class="description-text">
                                <c:choose>
                                    <c:when test="${not empty room.description}">
                                        ${room.description}
                                    </c:when>
                                    <c:otherwise>
                                        Phòng trọ chất lượng cao, đầy đủ tiện nghi, vị trí thuận lợi cho việc di chuyển và sinh hoạt hàng ngày. 
                                        Không gian thoáng mát, an ninh tốt, gần trung tâm thành phố. Phù hợp cho sinh viên và người đi làm.
                                        Có đầy đủ các tiện ích cần thiết, wifi miễn phí, điều hòa, tủ lạnh, máy giặt chung.
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </div>

                    <!-- Amenities Section -->
                    <div class="info-card">
                        <h3 class="section-title">
                            <i class="fas fa-star"></i>
                            Tiện ích
                        </h3>
                        <div class="amenities-grid">
                            <c:forEach var="amenity" items="${amenities}">
                                <div class="amenity-item">
                                    <div>${amenity.serviceName} - ${amenity.unitPrice}${amenity.unitName} </div>
                                </div>
                            </c:forEach>
                            
                            <!-- Demo amenities if none provided -->
                            <c:if test="${empty amenities}">
                                <div class="amenity-item">
                                    <div class="amenity-icon">
                                        <i class="fas fa-wifi"></i>
                                    </div>
                                    <div>Wifi miễn phí</div>
                                </div>
                                <div class="amenity-item">
                                    <div class="amenity-icon">
                                        <i class="fas fa-snowflake"></i>
                                    </div>
                                    <div>Điều hòa</div>
                                </div>
                                <div class="amenity-item">
                                    <div class="amenity-icon">
                                        <i class="fas fa-tv"></i>
                                    </div>
                                    <div>TV</div>
                                </div>
                                <div class="amenity-item">
                                    <div class="amenity-icon">
                                        <i class="fas fa-bed"></i>
                                    </div>
                                    <div>Giường ngủ</div>
                                </div>
                                <div class="amenity-item">
                                    <div class="amenity-icon">
                                        <i class="fas fa-couch"></i>
                                    </div>
                                    <div>Bàn ghế</div>
                                </div>
                                <div class="amenity-item">
                                    <div class="amenity-icon">
                                        <i class="fas fa-lightbulb"></i>
                                    </div>
                                    <div>Đèn điện</div>
                                </div>
                                <div class="amenity-item">
                                    <div class="amenity-icon">
                                        <i class="fas fa-lock"></i>
                                    </div>
                                    <div>An ninh 24/7</div>
                                </div>
                                <div class="amenity-item">
                                    <div class="amenity-icon">
                                        <i class="fas fa-car"></i>
                                    </div>
                                    <div>Chỗ đậu xe</div>
                                </div>
                            </c:if>
                        </div>
                    </div>
                    <div class="info-card">
                        <h3 class="section-title">
                            <i class="fas fa-star"></i>
                            Cơ sở vật chất
                        </h3>
                        <div class="amenities-grid">
                            <c:forEach var="di" items="${di}">
                                <div class="amenity-item">
                                    <div>${di.deviceName} - ${di.quantity} chiếc</div>
                                </div>
                            </c:forEach>
                            
                            <!-- Demo amenities if none provided -->
                            <c:if test="${empty amenities}">
                                <div class="amenity-item">
                                    <div class="amenity-icon">
                                        <i class="fas fa-wifi"></i>
                                    </div>
                                    <div>Wifi miễn phí</div>
                                </div>
                                <div class="amenity-item">
                                    <div class="amenity-icon">
                                        <i class="fas fa-snowflake"></i>
                                    </div>
                                    <div>Điều hòa</div>
                                </div>
                                <div class="amenity-item">
                                    <div class="amenity-icon">
                                        <i class="fas fa-tv"></i>
                                    </div>
                                    <div>TV</div>
                                </div>
                                <div class="amenity-item">
                                    <div class="amenity-icon">
                                        <i class="fas fa-bed"></i>
                                    </div>
                                    <div>Giường ngủ</div>
                                </div>
                                <div class="amenity-item">
                                    <div class="amenity-icon">
                                        <i class="fas fa-couch"></i>
                                    </div>
                                    <div>Bàn ghế</div>
                                </div>
                                <div class="amenity-item">
                                    <div class="amenity-icon">
                                        <i class="fas fa-lightbulb"></i>
                                    </div>
                                    <div>Đèn điện</div>
                                </div>
                                <div class="amenity-item">
                                    <div class="amenity-icon">
                                        <i class="fas fa-lock"></i>
                                    </div>
                                    <div>An ninh 24/7</div>
                                </div>
                                <div class="amenity-item">
                                    <div class="amenity-icon">
                                        <i class="fas fa-car"></i>
                                    </div>
                                    <div>Chỗ đậu xe</div>
                                </div>
                            </c:if>
                        </div>
                    </div>

                    <!-- Feedback Section -->
                    <div class="info-card">
                        <h3 class="section-title">
                            <i class="fas fa-comments"></i>
                            Đánh giá từ khách thuê
                        </h3>
                        
<!--                        <div class="rating-summary">
                            <div class="rating-number">4.5</div>
                            <div class="rating-stars">
                                <i class="fas fa-star"></i>
                                <i class="fas fa-star"></i>
                                <i class="fas fa-star"></i>
                                <i class="fas fa-star"></i>
                                <i class="fas fa-star-half-alt"></i>
                            </div>
                            <div class="rating-text">Dựa trên 24 đánh giá</div>
                        </div>-->

                        <c:forEach var="feedback" items="${feedback}">
                            <div class="feedback-item">
                                <div class="feedback-header">
                                    <div>
                                        <div class="feedback-author">${feedback.authorName}</div>
                                        <div class="feedback-rating">
                                            <c:forEach begin="1" end="${feedback.rating}">
                                                <i class="fas fa-star"></i>
                                            </c:forEach>
                                        </div>
                                    </div>
                                    <div class="feedback-date">${feedback.createdAt}</div>
                                </div>
                                <div class="feedback-content">
                                    ${feedback.content}
                                </div>
                            </div>
                        </c:forEach>

                        <!-- Demo feedback if none provided -->
                        <c:if test="${empty feedback}">
                            <div class="feedback-item">
                                <div class="feedback-header">
                                    <div>
                                        <div class="feedback-author">Nguyễn Văn A</div>
                                        <div class="feedback-rating">
                                            <i class="fas fa-star"></i>
                                            <i class="fas fa-star"></i>
                                            <i class="fas fa-star"></i>
                                            <i class="fas fa-star"></i>
                                            <i class="fas fa-star"></i>
                                        </div>
                                    </div>
                                    <div class="feedback-date">2 ngày trước</div>
                                </div>
                                <div class="feedback-content">
                                    Phòng rất tốt, sạch sẽ, chủ nhà thân thiện. Vị trí thuận lợi, gần trường học và chợ. 
                                    Giá cả hợp lý, tôi rất hài lòng với phòng này.
                                </div>
                            </div>
                            
                            <div class="feedback-item">
                                <div class="feedback-header">
                                    <div>
                                        <div class="feedback-author">Trần Thị B</div>
                                        <div class="feedback-rating">
                                            <i class="fas fa-star"></i>
                                            <i class="fas fa-star"></i>
                                            <i class="fas fa-star"></i>
                                            <i class="fas fa-star"></i>
                                            <i class="far fa-star"></i>
                                        </div>
                                    </div>
                                    <div class="feedback-date">1 tuần trước</div>
                                </div>
                                <div class="feedback-content">
                                    Phòng khá ok, có đầy đủ tiện nghi. Wifi nhanh, điều hòa mát. 
                                    Chỉ có điều hơi ồn vào buổi tối vì gần đường lớn.
                                </div>
                            </div>
                            
                            <div class="feedback-item">
                                <div class="feedback-header">
                                    <div>
                                        <div class="feedback-author">Lê Văn C</div>
                                        <div class="feedback-rating">
                                            <i class="fas fa-star"></i>
                                            <i class="fas fa-star"></i>
                                            <i class="fas fa-star"></i>
                                            <i class="fas fa-star"></i>
                                            <i class="fas fa-star"></i>
                                        </div>
                                    </div>
                                    <div class="feedback-date">2 tuần trước</div>
                                </div>
                                <div class="feedback-content">
                                    Tuyệt vời! Phòng mới, sạch sẽ, an ninh tốt. 
                                    Chủ nhà nhiệt tình, hỗ trợ tốt. Tôi sẽ giới thiệu cho bạn bè.
                                </div>
                            </div>
                        </c:if>
                    </div>

                    <!-- Map Section -->
                    <div class="map-container">
                        <h3 class="section-title">
                            <i class="fas fa-map-marked-alt"></i>
                            Vị trí trên bản đồ
                        </h3>
                        <div class="mb-3">
                            <i class="fas fa-map-marker-alt text-primary me-2"></i>
                            <strong>Địa chỉ:${rentail.address}</strong> 
                        </div>
                        <div id="map" style="height: 400px; border-radius: 15px; overflow: hidden;"></div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <jsp:include page="../Message.jsp"/>

    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/lightbox2/2.11.3/js/lightbox.min.js"></script>
    <!-- Google Maps API (replace YOUR_API_KEY with your actual key) -->
    <script src="https://maps.googleapis.com/maps/api/js?key=YOUR_API_KEY&callback=initMap" async defer></script>
    <script>
        // Gallery functionality
        function changeMainImage(imageSrc) {
            document.getElementById('mainImage').src = imageSrc;
            
            // Update active thumbnail
            document.querySelectorAll('.thumbnail').forEach(thumb => {
                thumb.classList.remove('active');
            });
            event.target.classList.add('active');
        }

        // Initialize map
        function initMap() {
            const address = '${rentail.address}';
            const roomLocation = { lat: 21.0285, lng: 105.8542 }; // Default Hanoi coordinates
            
            const map = new google.maps.Map(document.getElementById('map'), {
                zoom: 15,
                center: roomLocation,
                styles: [
                    {
                        "featureType": "all",
                        "elementType": "geometry.fill",
                        "stylers": [{"weight": "2.00"}]
                    },
                    {
                        "featureType": "all",
                        "elementType": "geometry.stroke",
                        "stylers": [{"color": "#9c9c9c"}]
                    },
                    {
                        "featureType": "all",
                        "elementType": "labels.text",
                        "stylers": [{"visibility": "on"}]
                    }
                ]
            });

            const marker = new google.maps.Marker({
                position: roomLocation,
                map: map,
                title: 'Phòng ${room.roomNumber}',
                icon: {
                    url: 'data:image/svg+xml;charset=UTF-8,' + encodeURIComponent(`
                        <svg xmlns="http://www.w3.org/2000/svg" width="40" height="40" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                            <path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z"></path>
                            <circle cx="12" cy="10" r="3"></circle>
                        </svg>
                    `),
                    scaledSize: new google.maps.Size(40, 40),
                    fillColor: '#667eea',
                    fillOpacity: 1,
                    strokeColor: '#ffffff',
                    strokeWeight: 2
                }
            });

            const infoWindow = new google.maps.InfoWindow({
                content: `
                    <div style="padding: 10px;">
                        <h5 style="margin: 0 0 10px 0; color: #2c3e50;">Phòng ${room.roomNumber}</h5>
                        <p style="margin: 0 0 5px 0; color: #6c757d;">
                            <i class="fas fa-map-marker-alt" style="color: #667eea;"></i>
                            ${address}
                        </p>
                        <p style="margin: 0; color: #e74c3c; font-weight: bold;">
                            💰 ${room.price} VNĐ/tháng
                        </p>
                    </div>
                `
            });

            marker.addListener('click', () => {
                infoWindow.open(map, marker);
            });

            // Try to geocode the address for more accurate positioning
            if (address && typeof google !== 'undefined' && google.maps && google.maps.Geocoder) {
                const geocoder = new google.maps.Geocoder();
                geocoder.geocode({ address: address }, (results, status) => {
                    if (status === 'OK' && results[0]) {
                        const location = results[0].geometry.location;
                        map.setCenter(location);
                        marker.setPosition(location);
                    }
                });
            }
        }

        // Initialize everything when page loads
        $(document).ready(function() {
            // Lightbox configuration
            lightbox.option({
                'resizeDuration': 200,
                'wrapAround': true,
                'albumLabel': 'Ảnh %1 / %2'
            });

            // Smooth scrolling for anchor links
            $('a[href^="#"]').on('click', function(event) {
                const target = $(this.getAttribute('href'));
                if (target.length) {
                    event.preventDefault();
                    $('html, body').stop().animate({
                        scrollTop: target.offset().top - 100
                    }, 1000);
                }
            });

            // Initialize first thumbnail as active
            $('.thumbnail').first().addClass('active');
        });

        // Google Maps fallback if API fails
        window.initMap = function() {
            try {
                // Nếu Google Maps không load được thì fallback
                if (typeof google === 'undefined' || !google.maps) {
                    createFallbackMap();
                } else {
                    // Gọi hàm initMap gốc
                    // ...existing code for initMap...
                    const address = '${rentail.address}';
                    const roomLocation = { lat: 21.0285, lng: 105.8542 };
                    const map = new google.maps.Map(document.getElementById('map'), {
                        zoom: 15,
                        center: roomLocation,
                        styles: [
                            {"featureType": "all", "elementType": "geometry.fill", "stylers": [{"weight": "2.00"}]},
                            {"featureType": "all", "elementType": "geometry.stroke", "stylers": [{"color": "#9c9c9c"}]},
                            {"featureType": "all", "elementType": "labels.text", "stylers": [{"visibility": "on"}]}
                        ]
                    });
                    const marker = new google.maps.Marker({
                        position: roomLocation,
                        map: map,
                        title: 'Phòng ${room.roomNumber}',
                        icon: {
                            url: 'data:image/svg+xml;charset=UTF-8,' + encodeURIComponent(`
                                <svg xmlns="http://www.w3.org/2000/svg" width="40" height="40" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round">
                                    <path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z"></path>
                                    <circle cx="12" cy="10" r="3"></circle>
                                </svg>
                            `),
                            scaledSize: new google.maps.Size(40, 40),
                            fillColor: '#667eea',
                            fillOpacity: 1,
                            strokeColor: '#ffffff',
                            strokeWeight: 2
                        }
                    });
                    const infoWindow = new google.maps.InfoWindow({
                        content: `
                            <div style="padding: 10px;">
                                <h5 style="margin: 0 0 10px 0; color: #2c3e50;">Phòng ${room.roomNumber}</h5>
                                <p style="margin: 0 0 5px 0; color: #6c757d;">
                                    <i class="fas fa-map-marker-alt" style="color: #667eea;"></i>
                                    ${address}
                                </p>
                                <p style="margin: 0; color: #e74c3c; font-weight: bold;">
                                    💰 ${room.price} VNĐ/tháng
                                </p>
                            </div>
                        `
                    });
                    marker.addListener('click', () => {
                        infoWindow.open(map, marker);
                    });
                    // Geocode address
                    if (address && typeof google !== 'undefined' && google.maps && google.maps.Geocoder) {
                        const geocoder = new google.maps.Geocoder();
                        geocoder.geocode({ address: address }, (results, status) => {
                            if (status === 'OK' && results[0]) {
                                const location = results[0].geometry.location;
                                map.setCenter(location);
                                marker.setPosition(location);
                            }
                        });
                    }
                }
            } catch (e) {
                createFallbackMap();
            }
        }

        // Fallback map function using OpenStreetMap
        function createFallbackMap() {
            const mapContainer = document.getElementById('map');
            mapContainer.innerHTML = `
                <iframe 
                    width="100%" 
                    height="400" 
                    style="border:0; border-radius: 15px;" 
                    loading="lazy" 
                    allowfullscreen 
                    referrerpolicy="no-referrer-when-downgrade"
                    src="https://www.openstreetmap.org/export/embed.html?bbox=105.8442%2C21.0185%2C105.8642%2C21.0385&amp;layer=mapnik&amp;marker=21.0285%2C105.8542">
                </iframe>
            `;
        }

        // Animation on scroll
        function animateOnScroll() {
            const observer = new IntersectionObserver((entries) => {
                entries.forEach(entry => {
                    if (entry.isIntersecting) {
                        entry.target.style.opacity = '1';
                        entry.target.style.transform = 'translateY(0)';
                    }
                });
            });

            document.querySelectorAll('.info-card, .room-gallery').forEach(el => {
                el.style.opacity = '0';
                el.style.transform = 'translateY(20px)';
                el.style.transition = 'all 0.6s ease';
                observer.observe(el);
            });
        }

        // Initialize animations
        document.addEventListener('DOMContentLoaded', animateOnScroll);

        // Phone number formatting
        function formatPhoneNumber(phoneNumber) {
            if (!phoneNumber) return '';
            
            // Remove all non-digit characters
            const cleaned = phoneNumber.replace(/\D/g, '');
            
            // Format as (XXX) XXX-XXXX
            const match = cleaned.match(/^(\d{3})(\d{3})(\d{4})$/);
            if (match) {
                return `(${match[1]}) ${match[2]}-${match[3]}`;
            }
            
            return phoneNumber;
        }

        // Contact button interactions
        $('.btn-contact').on('click', function() {
            $(this).addClass('clicked');
            setTimeout(() => {
                $(this).removeClass('clicked');
            }, 300);
        });

        // Add click animation styles
        const clickStyles = `
            .btn-contact.clicked {
                transform: scale(0.95) translateY(-1px) !important;
                transition: all 0.1s ease !important;
            }
        `;
        
        $('<style>').text(clickStyles).appendTo('head');
    </script>

</body>
</html>
<!-- Modal: Đăng ký thuê phòng -->
<div class="modal fade" id="rentModal" tabindex="-1" aria-labelledby="rentModalLabel" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <form action="booking" method="post">
        <div class="modal-header">
          <h5 class="modal-title" id="rentModalLabel">Đăng ký thuê phòng</h5>
          <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
        </div>
        <div class="modal-body">
          <div class="mb-3">
            <label for="fromDate" class="form-label">Ngày bắt đầu thuê</label>
            <input type="date" class="form-control" id="fromDate" name="fromDate" required>
          </div>
          <div class="mb-3">
            <label for="toDate" class="form-label">Ngày kết thúc (dự kiến)</label>
            <input type="date" class="form-control" id="toDate" name="toDate">
          </div>
          <div class="mb-3">
            <label for="note" class="form-label">Ghi chú</label>
            <textarea class="form-control" id="note" name="note" rows="3" placeholder="Nhập ghi chú nếu có..."></textarea>
          </div>
          <input type="hidden" name="roomId" value="${room.roomId}" />
          <input type="hidden" name="roomNumber" value="${room.roomNumber}"/>
          <input type="hidden" name="areaName" value="${rentail.name}"/>
          <input type="hidden" name="managerEmail" value="${manager.email}"/>
        </div>
        <div class="modal-footer">
          <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
          <button type="submit" class="btn btn-primary">Gửi yêu cầu</button>
        </div>
      </form>
    </div>
  </div>
</div>
