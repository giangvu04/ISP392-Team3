<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!doctype html>
<html lang="en">
    <head>
        <jsp:include page="Common/Css.jsp"/>
    </head>
    <body>
        <div id="siteLoader" class="site-loader">
            <div class="preloader-content">
                <img src="LandingPage/assets/images/loader1.gif" alt="">
            </div>
        </div>
        <div id="page" class="full-page">
            <jsp:include page="Common/Header.jsp"/>
            <main id="content" class="site-main">
                <!-- Inner Banner html start-->
                <section class="inner-banner-wrap">
                    <div class="inner-baner-container" style="background-image: url(Image/Location/binhduong.jpg);">
                        <div class="container">
                            <div class="inner-banner-content">
                                <h1 class="inner-title">Chi Tiết Phòng Trọ</h1>
                            </div>
                        </div>
                    </div>
                    <div class="inner-shape"></div>
                </section>
                <!-- Inner Banner html end-->
                <div class="single-tour-section">
                    <div class="container">
                        <div class="row">
                            <div class="col-lg-8">
                                <div class="single-tour-inner">
                                    <h2>${rentalPost.title}</h2>
                                    <figure class="feature-image">
                                       
                                        <div class="package-meta text-center">
                                            <ul>
                                                <li>
                                                    <i class="fas fa-eye"></i>
                                                    <fmt:formatNumber value="${rentalPost.viewsCount}" type="number"/> lượt xem
                                                </li>
                                                <li>
                                                    <i class="fas fa-map-marked-alt"></i>
                                                    ${rentalPost.rentalAreaName}
                                                </li>
                                                <li>
                                                    <i class="fas fa-calendar-alt"></i>
                                                    <fmt:formatDate value="${rentalPost.createdAt}" pattern="dd/MM/yyyy"/>
                                                </li>
                                            </ul>
                                        </div>
                                    </figure>
                                    <div class="tab-container">
                                        <ul class="nav nav-tabs" id="myTab" role="tablist">
                                            <li class="nav-item">
                                                <a class="nav-link active" id="overview-tab" data-toggle="tab" href="#overview" role="tab" aria-controls="overview" aria-selected="true">MÔ TẢ</a>
                                            </li>
                                            <li class="nav-item">
                                                <a class="nav-link" id="program-tab" data-toggle="tab" href="#program" role="tab" aria-controls="program" aria-selected="false">PHÒNG</a>
                                            </li>
                                            <li class="nav-item">
                                                <a class="nav-link" id="review-tab" data-toggle="tab" href="#review" role="tab" aria-controls="review" aria-selected="false">DỊCH VỤ</a>
                                            </li>
                                            <li class="nav-item">
                                                <a class="nav-link" id="map-tab" data-toggle="tab" href="#map" role="tab" aria-controls="map" aria-selected="false">ẢNH</a>
                                            </li>
                                        </ul>
                                        <div class="tab-content" id="myTabContent">
                                            <div class="tab-pane fade show active" id="overview" role="tabpanel" aria-labelledby="overview-tab">
                                                <div class="overview-content">
                                                    <p>${rentalPost.description}</p>
                                                    <h4>Thông tin khu trọ:</h4>
                                                    <ul>
                                                        <li>- Địa chỉ: ${rentalPost.rentalAreaAddress}</li>
                                                        <li>- Khu vực: ${rentalPost.rentalAreaName}</li>
                                                        <li>- Chủ nhà: ${manager.fullName}</li>
                                                        <li>- Liên hệ: ${manager.phone}</li>
                                                        <li>- Email: ${manager.email}</li>
                                                    </ul>
                                                </div>
                                            </div>
                                            <div class="tab-pane" id="program" role="tabpanel" aria-labelledby="program-tab">
                                                <div class="itinerary-content">
                                                    <h3>Danh sách phòng <span>( ${postRooms.size()} phòng )</span></h3>
                                                    <p>Thông tin chi tiết về các phòng trong bài đăng này</p>
                                                </div>
                                                <div class="itinerary-timeline-wrap">
                                                    <ul>
                                                        <c:forEach var="room" items="${postRooms}" varStatus="status">
                                                            <li>
                                                                <div class="timeline-content">
                                                                    <div class="day-count">Phòng <span>${room.roomNumber}</span></div>
                                                                    <h4>
                                                                        <fmt:formatNumber value="${room.roomPrice}" type="currency" 
                                                                                        currencySymbol="" pattern="#,###"/> VNĐ/tháng
                                                                    </h4>
                                                                    <p><strong>Diện tích:</strong> ${room.roomArea} m² | <strong>Tối đa:</strong> ${room.maxTenants} người</p>
                                                                    <c:if test="${not empty room.roomDescription}">
                                                                        <p>${room.roomDescription}</p>
                                                                    </c:if>
                                                                </div>
                                                            </li>
                                                        </c:forEach>
                                                    </ul>
                                                </div>
                                            </div>
                                            <div class="tab-pane" id="review" role="tabpanel" aria-labelledby="review-tab">
                                                <div class="summary-review">
                                                    <div>
                                                    <h3>Dịch vụ tiện ích</h3>
                                                    </div>
                                                    
                                                    
                                                </div>
                                                
                                                <div class="services-list">
                                                    <c:choose>
                                                        <c:when test="${not empty services}">
                                                            <c:forEach var="service" items="${services}">
                                                                <div style="border: 1px solid #ddd; margin: 10px 0; padding: 15px; border-radius: 8px;">
                                                                    <h4>${service.serviceName}</h4>
                                                                    <p><strong>Giá:</strong> 
                                                                        <fmt:formatNumber value="${service.unitPrice}" type="currency" 
                                                                                        currencySymbol="" pattern="#,###"/> VNĐ/${service.unitName}
                                                                    </p>
                                                                    <c:if test="${not empty service.description}">
                                                                        <p><strong>Mô tả:</strong> ${service.description}</p>
                                                                    </c:if>
                                                                </div>
                                                            </c:forEach>
                                                        </c:when>
                                                        <c:otherwise>
                                                            <p>Chưa có thông tin về dịch vụ tiện ích.</p>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </div>
                                            </div>
                                            <div class="tab-pane" id="map" role="tabpanel" aria-labelledby="map-tab">
                                                <div class="gallery-content">
                                                    <h3>Hình ảnh phòng</h3>
                                                    <c:choose>
                                                        <c:when test="${not empty images}">
                                                            <div class="row">
                                                                <c:forEach var="image" items="${images}">
                                                                    <div class="col-md-4 mb-3">
                                                                        <figure class="feature-image">
                                                                            <img src="${image.urlImage}" alt="Ảnh phòng" style="width: 100%; height: 200px; object-fit: cover; border-radius: 8px;">
                                                                        </figure>
                                                                    </div>
                                                                </c:forEach>
                                                            </div>
                                                        </c:when>
                                                        <c:otherwise>FLI
                                                            <p>Chưa có hình ảnh của phòng này.</p>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="col-lg-4">
                                <div class="sidebar">
                                    <div class="package-price">
                                        <!-- Debug info (remove in production) -->
                                        <!-- Rooms count: ${postRooms.size()}, First room price: ${postRooms[0].roomPrice} -->
                                        
                                        <h5 class="price">
                                            <c:choose>
                                                <c:when test="${not empty postRooms && postRooms.size() > 0 && postRooms[0].roomPrice > 0}">
                                                    <span><fmt:formatNumber value="${postRooms[0].roomPrice}" type="currency" 
                                                           currencySymbol="" pattern="#,###"/>đ</span> / tháng
                                                </c:when>
                                                <c:otherwise>
                                                    <span>Liên hệ</span> / tháng
                                                </c:otherwise>
                                            </c:choose>
                                        </h5>
                                        <div class="start-wrap">
                                            <div class="rating-start" title="Rated 5 out of 5">
                                                <span style="width: 100%"></span>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="widget-bg booking-form-wrap">
                                        <h4 class="bg-title">Liên hệ thuê phòng</h4>
                                        <c:choose>
                                            <c:when test="${not empty sessionScope.user}">
                                                <!-- User đã đăng nhập -->
                                                <form class="booking-form" action="submitViewingRequest" method="post">
                                                    <input type="hidden" name="postId" value="${rentalPost.postId}">
                                                    <div class="row">
                                                        <div class="col-sm-12">
                                                            <h5>Thông tin của bạn:</h5>
                                                            <p><strong>Họ tên:</strong> ${sessionScope.user.fullName}</p>
                                                            <p><strong>Email:</strong> ${sessionScope.user.email}</p>
                                                            <p><strong>SĐT:</strong> ${sessionScope.user.phone}</p>
                                                        </div>
                                                        <div class="col-sm-12">
                                                            <div class="form-group">
                                                                <label for="roomId">Chọn phòng muốn xem:</label>
                                                                <select name="roomId" id="roomId" class="form-control" required>
                                                                    <option value="">-- Chọn phòng --</option>
                                                                    <c:forEach var="room" items="${postRooms}">
                                                                        <option value="${room.roomId}">
                                                                            Phòng ${room.roomNumber} - 
                                                                            <fmt:formatNumber value="${room.roomPrice}" type="currency" 
                                                                                            currencySymbol="" pattern="#,###"/>đ/tháng
                                                                            (${room.roomArea} m²)
                                                                        </option>
                                                                    </c:forEach>
                                                                </select>
                                                            </div>
                                                        </div>
                                                        <div class="col-sm-12">
                                                            <div class="form-group">
                                                                <label for="preferredDate">Thời gian mong muốn xem phòng:</label>
                                                                <input name="preferredDate" type="datetime-local" class="form-control">
                                                            </div>
                                                        </div>
                                                        <div class="col-sm-12">
                                                            <div class="form-group">
                                                                <textarea name="message" rows="4" placeholder="Lời nhắn (tùy chọn)..." class="form-control"></textarea>
                                                            </div>
                                                        </div>
                                                        <div class="col-sm-12">
                                                            <div class="form-group submit-btn">
                                                                <input type="submit" name="submit" value="Gửi yêu cầu xem phòng" class="btn btn-primary btn-block">
                                                            </div>
                                                        </div>
                                                    </div>
                                                </form>
                                            </c:when>
                                            <c:otherwise>
                                                <!-- User chưa đăng nhập -->
                                                <div class="login-required">
                                                    <p class="text-center mb-3">
                                                        <i class="fas fa-lock" style="font-size: 2em; color: #007bff;"></i>
                                                    </p>
                                                    <p class="text-center mb-3">Bạn cần đăng nhập để gửi yêu cầu xem phòng</p>
                                                    <div class="text-center">
                                                        <a href="login?returnUrl=roomDetail?id=${rentalPost.postId}" class="btn btn-primary btn-block">Đăng nhập ngay</a>
                                                        <p class="mt-2">
                                                            Chưa có tài khoản? <a href="register">Đăng ký tại đây</a>
                                                        </p>
                                                    </div>
                                                </div>
                                            </c:otherwise>
                                        </c:choose>
                                        
                                        <!-- Thông tin liên hệ chủ nhà -->
                                        <div class="mt-4">
                                            <h4 class="">Thông tin chủ nhà</h4>
                                            <p><strong>Chủ nhà:</strong> ${manager.fullName}</p>
                                            <p><strong>SĐT:</strong> ${manager.phone}</p>
                                            <p><strong>Email:</strong> ${manager.email}</p>
                                        </div>
                                    </div>
                                    <div class="widget-bg information-content text-center">
                                        <h5>TƯ VẤN</h5>
                                        <h3>CẦN HỖ TRỢ TÌM PHÒNG TRỌ?</h3>
                                        <p>Chúng tôi sẵn sàng hỗ trợ bạn tìm kiếm và thuê phòng trọ phù hợp với nhu cầu của mình.</p>
                                        <a href="tel:${manager.phone}" class="button-primary">LIÊN HỆ NGAY</a>
                                    </div>
                                    <div class="travel-package-content text-center" style="background-image: url(LandingPage/assets/images/img11.jpg);">
                                        <h5>PHÒNG TRỌ KHÁC</h5>
                                        <h3>XEM THÊM PHÒNG TRỌ</h3>
                                        <p>Khám phá thêm các phòng trọ khác phù hợp với nhu cầu của bạn.</p>
                                        <ul>
                                            <li>
                                                <a href="trangchu"><i class="far fa-arrow-alt-circle-right"></i>Trang chủ</a>
                                            </li>
                                            <li>
                                                <a href="searchRooms"><i class="far fa-arrow-alt-circle-right"></i>Tìm kiếm phòng</a>
                                            </li>
                                            <li>
                                                <a href="searchRooms?province=Thành+phố+Hà+Nội"><i class="far fa-arrow-alt-circle-right"></i>Phòng tại Hà Nội</a>
                                            </li>
                                            <li>
                                                <a href="searchRooms?province=Thành+phố+Hồ+Chí+Minh"><i class="far fa-arrow-alt-circle-right"></i>Phòng tại HCM</a>
                                            </li>
                                        </ul>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </main>
            <jsp:include page="Common/Footer.jsp"/>
            <!-- header html end -->
        </div>

        <jsp:include page="Common/Js.jsp"/>
    </body>
</html>
