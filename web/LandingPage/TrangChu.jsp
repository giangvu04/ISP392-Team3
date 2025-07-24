<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!doctype html>
<html lang="en">
    <head>
        <jsp:include page="Common/Css.jsp"/>
        <style>
            .trip-search-section select.form-control {
                width: 100%;
                padding: 12px 15px;
                border: 2px solid #e5e5e5;
                border-radius: 5px;
                font-size: 14px;
                color: #666;
                background-color: #fff;
                transition: border-color 0.3s ease;
            }

            .trip-search-section select.form-control:focus {
                border-color: #ff6b35;
                outline: none;
            }

            .trip-search-section select.form-control:disabled {
                background-color: #f5f5f5;
                color: #999;
                cursor: not-allowed;
            }
        </style>
    </head>
    <body class="home">
        <div id="siteLoader" class="site-loader">
            <div class="preloader-content">
                <img src="LandingPage/assets/images/loader1.gif" alt="">
            </div>
        </div>
        <div id="page" class="full-page">
            <jsp:include page="Common/Header.jsp"/>
            <main id="content" class="site-main">
                <!-- Home slider html start -->
                <section class="home-slider-section">
                    <div class="home-slider">
                        <div class="home-banner-items">
                            <div class="banner-inner-wrap" style="background-image: url(Image/Banner/banner1.jpg);"></div>
                            <div class="banner-content-wrap">
                                <div class="container">
                                    <div class="banner-content text-center">
                                        <h2 class="banner-title">DREAM HOUSE    - NGÔI NHÀ CỦA BẠN</h2>
                                        <p>Trọ là nhà, về là mơ, từng giấc ngủ đều bình yên như ở chính tổ ấm của mình</p>
                                        <a href="searchRooms" class="button-primary">TÌM PHÒNG NGAY</a>
                                    </div>
                                </div>
                            </div>
                            <div class="overlay"></div>
                        </div>
                        <div class="home-banner-items">
                            <div class="banner-inner-wrap" style="background-image: url(Image/Banner/banner2.jpg);"></div>
                            <div class="banner-content-wrap">
                                <div class="container">
                                    <div class="banner-content text-center">
                                        <h2 class="banner-title">DREAM HOUSE    - NGÔI NHÀ CỦA BẠN</h2>
                                        <p>Trọ là nhà, về là mơ, mỗi căn phòng là một góc an yên giữa thành phố vội.</p>
                                        <a href="searchRooms" class="button-primary">TÌM PHÒNG NGAY</a>
                                    </div>
                                </div>
                            </div>
                            <div class="overlay"></div>
                        </div>
                    </div>
                </section>
                <!-- slider html start -->
                <!-- Home search field html start -->
                <div class="trip-search-section shape-search-section">
                    <div class="slider-shape"></div>
                    <div class="container">
                        <div class="row trip-search-inner white-bg d-flex">

                            <div class="col-md-3 input-group">
                                <label style="padding-top: 10px; margin-right: 10px"> Tỉnh* </label>
                                <select id="province-select" name="province" class="form-control">
                                    <option value="">Chọn tỉnh</option>
                                    <c:forEach var="province" items="${provinces}">
                                        <option value="${province}">${province}</option>
                                    </c:forEach>
                                </select>
                            </div>
                            <div class="col-md-3 input-group">
                                <label style="padding-top: 10px; margin-right: 10px"> Quận,Huyện* </label>
                                <select id="district-select" name="district" class="form-control" disabled>
                                    <option value="">Chọn quận/huyện</option>
                                </select>
                            </div>
                            <div class="col-md-3 input-group">
                                <label style="padding-top: 10px; margin-right: 10px"> Phường, Xã* </label>
                                <select id="ward-select" name="ward" class="form-control" disabled>
                                    <option value="">Chọn phường/xã</option>
                                </select>
                            </div>

                            <div class="input-group width-col-3">
                                <label class="screen-reader-text"> Tìm kiếm</label>
                                <input type="button" name="travel-search" value="BẮT ĐẦU" onclick="performSearch()">
                            </div>
                        </div>
                    </div>
                </div>
                <!-- search search field html end -->
                <!--                <section class="destination-section">
                                    <div class="container">
                                        <div class="section-heading">
                                            <div class="row align-items-end">
                                                <div class="col-lg-7">
                                                    <h5 class="dash-style">POPULAR DESTINATION</h5>
                                                    <h2>TOP NOTCH DESTINATION</h2>
                                                </div>
                                                <div class="col-lg-5">
                                                    <div class="section-disc">
                                                        Aperiam sociosqu urna praesent, tristique, corrupti condimentum asperiores platea ipsum ad arcu. Nostrud. Aut nostrum, ornare quas provident laoreet nesciunt.
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="destination-inner destination-three-column">
                                            <div class="row">
                                                <div class="col-lg-7">
                                                    <div class="row">
                                                        <div class="col-sm-6">
                                                            <div class="desti-item overlay-desti-item">
                                                                <figure class="desti-image">
                                                                    <img src="LandingPage/assets/images/img1.jpg" alt="">
                                                                </figure>
                                                                <div class="meta-cat bg-meta-cat">
                                                                    <a href="#">THAILAND</a>
                                                                </div>
                                                                <div class="desti-content">
                                                                    <h3>
                                                                        <a href="#">Disney Land</a>
                                                                    </h3>
                                                                    <div class="rating-start" title="Rated 5 out of 4">
                                                                        <span style="width: 53%"></span>
                                                                    </div>
                                                                </div>
                                                            </div>
                                                        </div>
                                                        <div class="col-sm-6">
                                                            <div class="desti-item overlay-desti-item">
                                                                <figure class="desti-image">
                                                                    <img src="LandingPage/assets/images/img2.jpg" alt="">
                                                                </figure>
                                                                <div class="meta-cat bg-meta-cat">
                                                                    <a href="#">NORWAY</a>
                                                                </div>
                                                                <div class="desti-content">
                                                                    <h3>
                                                                        <a href="#">Besseggen Ridge</a>
                                                                    </h3>
                                                                    <div class="rating-start" title="Rated 5 out of 5">
                                                                        <span style="width: 100%"></span>
                                                                    </div>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                                <div class="col-lg-5">
                                                    <div class="row">
                                                        <div class="col-md-6 col-xl-12">
                                                            <div class="desti-item overlay-desti-item">
                                                                <figure class="desti-image">
                                                                    <img src="LandingPage/assets/images/img3.jpg" alt="">
                                                                </figure>
                                                                <div class="meta-cat bg-meta-cat">
                                                                    <a href="#">NEW ZEALAND</a>
                                                                </div>
                                                                <div class="desti-content">
                                                                    <h3>
                                                                        <a href="#">Oxolotan City</a>
                                                                    </h3>
                                                                    <div class="rating-start" title="Rated 5 out of 5">
                                                                        <span style="width: 100%"></span>
                                                                    </div>
                                                                </div>
                                                            </div>
                                                        </div>
                                                        <div class="col-md-6 col-xl-12">
                                                            <div class="desti-item overlay-desti-item">
                                                                <figure class="desti-image">
                                                                    <img src="LandingPage/assets/images/img4.jpg" alt="">
                                                                </figure>
                                                                <div class="meta-cat bg-meta-cat">
                                                                    <a href="#">SINGAPORE</a>
                                                                </div>
                                                                <div class="desti-content">
                                                                    <h3>
                                                                        <a href="#">Marina Bay Sand City</a>
                                                                    </h3>
                                                                    <div class="rating-start" title="Rated 5 out of 4">
                                                                        <span style="width: 60%"></span>
                                                                    </div>
                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="btn-wrap text-center">
                                                <a href="#" class="button-primary">MORE DESTINATION</a>
                                            </div>
                                        </div>
                                    </div>
                                </section>-->
                <!-- Home packages section html start -->
                <section class="package-section">
                    <div class="container">
                        <div class="section-heading text-center">
                            <div class="row">
                                <div class="col-lg-8 offset-lg-2">
                                    <h5 class="dash-style">PHÒNG TRỌ HOT</h5>
                                    <h2>XEM NHIỀU NHẤT</h2>
                                    <p>Phòng trọ giá rẻ, tốt nhất trong thời gian gần đây</p>
                                </div>
                            </div>
                        </div>
                        <div class="package-inner">
                            <div class="row">
                                <!-- Top Viewed Posts -->
                                <c:choose>
                                    <c:when test="${not empty topViewedPosts}">
                                        <c:forEach var="post" items="${topViewedPosts}" varStatus="status">
                                            <c:if test="${status.index < 3}">
                                                <div class="col-lg-4 col-md-6">
                                                    <div class="package-wrap">
                                                        <figure class="feature-image">
                                                            <a href="#">
                                                                <c:choose>
                                                                    <c:when test="${not empty post.featuredImage}">
                                                                        <img src="${post.featuredImage}" alt="${post.title}"
                                                                             style="width: 100%; height: 300px; object-fit: cover;">
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        <img src="LandingPage/assets/images/img5.jpg" alt="Default"
                                                                             style="width: 100%; height: 300px; object-fit: cover;">
                                                                    </c:otherwise>
                                                                </c:choose>
                                                            </a>
                                                        </figure>

                                                        <div class="package-price">
                                                            <h6><span>
                                                                    <c:choose>
                                                                        <c:when test="${post.roomPrice > 0}">
                                                                            <fmt:formatNumber value="${post.roomPrice}" type="number" maxFractionDigits="0"/>đ/tháng
                                                                        </c:when>
                                                                        <c:otherwise>
                                                                            Liên hệ
                                                                        </c:otherwise>
                                                                    </c:choose>
                                                                </span></h6>
                                                        </div>
                                                        <div class="package-content-wrap">
                                                            <div class="package-meta text-center">
                                                                <ul>
                                                                    <li>
                                                                        <i class="fas fa-map-marker-alt"></i>
                                                                        ${post.rentalAreaName}
                                                                    </li>
                                                                    <li>
                                                                        <i class="fas fa-eye"></i>
                                                                        ${post.viewsCount} lượt xem
                                                                    </li>

                                                                </ul>
                                                            </div>
                                                            <div class="package-content">
                                                                <h3>
                                                                    <a href="#">${post.title}</a>
                                                                </h3>
                                                                <div class="review-area">
                                                                    <!--                                                                    <span class="review-text">(Hot post)</span>-->
                                                                    <div class="rating-start" title="Rated 5 out of 5">
                                                                        <span style="width: 100%"></span>
                                                                    </div>
                                                                </div>
                                                                <div style="display: flex; justify-content: space-between">
                                                                    <a>
                                                                        <i class="fas fa-user"></i>
                                                                        ${post.managerName}
                                                                    </a>
                                                                    <a>
                                                                        <i class="fas fa-phone"></i>
                                                                        <c:choose>
                                                                            <c:when test="${not empty post.contactInfo}">
                                                                                ${post.contactInfo}
                                                                            </c:when>
                                                                            <c:otherwise>
                                                                                Liên hệ
                                                                            </c:otherwise>
                                                                        </c:choose>
                                                                    </a>
                                                                </div>
                                                                <div style="display: flex; margin-top: 10px; justify-content: space-between;">
                                                                    <a style="
                                                                       display: inline-block;
                                                                       max-width: 100%;
                                                                       white-space: nowrap;
                                                                       overflow: hidden;
                                                                       text-overflow: ellipsis;
                                                                       max-width: 600px;">
                                                                        <i class="fas fa-map-marker-alt"></i>
                                                                        ${post.rentalAreaAddress}
                                                                    </a>
                                                                </div>

                                                                <div class="btn-wrap">
                                                                    <a href="roomDetail?id=${post.postId}" class="button-text width-12">Xem chi tiết<i class="fas fa-arrow-right"></i></a>

                                                                </div>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </c:if>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <!-- Default content when no posts -->
                                        <div class="col-lg-4 col-md-6">
                                            <div class="package-wrap">
                                                <figure class="feature-image">
                                                    <a href="#">
                                                        <img src="LandingPage/assets/images/img5.jpg" alt="No posts">
                                                    </a>
                                                </figure>
                                                <div class="package-price">
                                                    <h6><span>0 lượt xem</span></h6>
                                                </div>
                                                <div class="package-content-wrap">
                                                    <div class="package-content">
                                                        <h3><a href="#">Chưa có tin đăng</a></h3>
                                                        <p>Hiện tại chưa có bài đăng nào được đăng tải.</p>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                            <div class="btn-wrap text-center">
                                <a href="search" class="button-primary">Xem thêm</a>
                            </div>
                        </div>
                    </div>
                </section>
                <!-- packages html end -->
                <!-- Home callback section html start -->
                <section class="callback-section">
                    <div class="container">
                        <div class="row no-gutters align-items-center">
                            <div class="col-lg-5">
                                <div class="callback-img" style="background-image: url(Image/Location/hanoi.jpg);">
                                    <div class="video-button">
                                        <a id="video-container" data-video-id="IUN664s7N-c">
                                            <i class="fas fa-play"></i>
                                        </a>
                                    </div>
                                </div>
                            </div>
                            <div class="col-lg-7">
                                <div class="callback-inner">
                                    <div class="section-heading section-heading-white">
                                        <h5 class="dash-style">HOUSE SHARING</h5>
                                        <h2>DREAM HOUSE chúng tôi cam kết</h2>
                                        <p>Với 10 năm kinh nghiệm trong giới bất động sản, chúng tôi tự tin có thể tìm được phòng theo ý muốn của bạn</p>
                                    </div>
                                    <div class="callback-counter-wrap">
                                        <div class="counter-item">
                                            <div class="counter-icon">
                                                <img src="LandingPage/assets/images/icon1.png" alt="">
                                            </div>
                                            <div class="counter-content">
                                                <span class="counter-no">
                                                    <span class="counter">500</span>K+
                                                </span>
                                                <span class="counter-text">
                                                    Người dùng 
                                                </span>
                                            </div>
                                        </div>
                                        <div class="counter-item">
                                            <div class="counter-icon">
                                                <img src="LandingPage/assets/images/icon2.png" alt="">
                                            </div>
                                            <div class="counter-content">
                                                <span class="counter-no">
                                                    <span class="counter">250</span>K+
                                                </span>
                                                <span class="counter-text">
                                                    Nhà đã cho thuê
                                                </span>
                                            </div>
                                        </div>
                                        <div class="counter-item">
                                            <div class="counter-icon">
                                                <img src="LandingPage/assets/images/icon3.png" alt="">
                                            </div>
                                            <div class="counter-content">
                                                <span class="counter-no">
                                                    <span class="counter">15</span>K+
                                                </span>
                                                <span class="counter-text">
                                                    Phản hồi từ người dùng
                                                </span>
                                            </div>
                                        </div>
                                        <div class="counter-item">
                                            <div class="counter-icon">
                                                <img src="LandingPage/assets/images/icon4.png" alt="">
                                            </div>
                                            <div class="counter-content">
                                                <span class="counter-no">
                                                    <span class="counter">10</span>K+
                                                </span>
                                                <span class="counter-text">
                                                    Đánh giá cao sản phẩm 
                                                </span>
                                            </div>
                                        </div>
                                    </div>
                                    <!--                                    <div class="support-area">
                                                                            <div class="support-icon">
                                                                                <img src="LandingPage/assets/images/icon5.png" alt="">
                                                                            </div>
                                                                            <div class="support-content">
                                                                                <h4>Our 24/7 Emergency Phone Services</h4>
                                                                                <h3>
                                                                                    <a href="#">Call: 123-456-7890</a>
                                                                                </h3>
                                                                            </div>
                                                                        </div>-->
                                </div>
                            </div>
                        </div>
                    </div>
                </section>
                <!-- callback html end -->
                <!-- Home activity section html start -->
                <!--                <section class="activity-section">
                                    <div class="container">
                                        <div class="section-heading text-center">
                                            <div class="row">
                                                <div class="col-lg-8 offset-lg-2">
                                                    <h5 class="dash-style">TRAVEL BY ACTIVITY</h5>
                                                    <h2>ADVENTURE & ACTIVITY</h2>
                                                    <p>Mollit voluptatem perspiciatis convallis elementum corporis quo veritatis aliquid blandit, blandit torquent, odit placeat. Adipiscing repudiandae eius cursus? Nostrum magnis maxime curae placeat.</p>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="activity-inner row">
                                            <div class="col-lg-2 col-md-4 col-sm-6">
                                                <div class="activity-item">
                                                    <div class="activity-icon">
                                                        <a href="#">
                                                            <img src="LandingPage/assets/images/icon6.png" alt="">
                                                        </a>
                                                    </div>
                                                    <div class="activity-content">
                                                        <h4>
                                                            <a href="#">Adventure</a>
                                                        </h4>
                                                        <p>15 Destination</p>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="col-lg-2 col-md-4 col-sm-6">
                                                <div class="activity-item">
                                                    <div class="activity-icon">
                                                        <a href="#">
                                                            <img src="LandingPage/assets/images/icon10.png" alt="">
                                                        </a>
                                                    </div>
                                                    <div class="activity-content">
                                                        <h4>
                                                            <a href="#">Trekking</a>
                                                        </h4>
                                                        <p>12 Destination</p>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="col-lg-2 col-md-4 col-sm-6">
                                                <div class="activity-item">
                                                    <div class="activity-icon">
                                                        <a href="#">
                                                            <img src="LandingPage/assets/images/icon9.png" alt="">
                                                        </a>
                                                    </div>
                                                    <div class="activity-content">
                                                        <h4>
                                                            <a href="#">Camp Fire</a>
                                                        </h4>
                                                        <p>7 Destination</p>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="col-lg-2 col-md-4 col-sm-6">
                                                <div class="activity-item">
                                                    <div class="activity-icon">
                                                        <a href="#">
                                                            <img src="LandingPage/assets/images/icon8.png" alt="">
                                                        </a>
                                                    </div>
                                                    <div class="activity-content">
                                                        <h4>
                                                            <a href="#">Off Road</a>
                                                        </h4>
                                                        <p>15 Destination</p>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="col-lg-2 col-md-4 col-sm-6">
                                                <div class="activity-item">
                                                    <div class="activity-icon">
                                                        <a href="#">
                                                            <img src="LandingPage/assets/images/icon7.png" alt="">
                                                        </a>
                                                    </div>
                                                    <div class="activity-content">
                                                        <h4>
                                                            <a href="#">Camping</a>
                                                        </h4>
                                                        <p>13 Destination</p>
                                                    </div>
                                                </div>
                                            </div>
                                            <div class="col-lg-2 col-md-4 col-sm-6">
                                                <div class="activity-item">
                                                    <div class="activity-icon">
                                                        <a href="#">
                                                            <img src="LandingPage/assets/images/icon11.png" alt="">
                                                        </a>
                                                    </div>
                                                    <div class="activity-content">
                                                        <h4>
                                                            <a href="#">Exploring</a>
                                                        </h4>
                                                        <p>25 Destination</p>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </section>-->
                <section class="package-section bg-light-grey">
                    <div class="container">
                        <div class="section-heading text-center">
                            <div class="row">
                                <div class="col-lg-8 offset-lg-2">
                                    <!--                           <h5>BÀI ĐĂNG GẦN ĐÂY</h5>-->
                                    <h2>BÀI ĐĂNG GẦN ĐÂY</h2>
                                    <div class="title-icon-divider"><i class="fas fa-suitcase-rolling"></i></div>
                                </div>
                            </div>
                        </div>
                        <div class="package-inner package-inner-list">
                            <div class="row">
                                <!-- Recent Posts -->
                                <c:choose>
                                    <c:when test="${not empty recentPosts}">
                                        <c:forEach var="post" items="${recentPosts}" varStatus="status">
                                            <c:if test="${status.index < 4}">
                                                <div class="col-lg-6">
                                                    <div class="package-wrap package-wrap-list">
                                                        <figure class="feature-image">
                                                            <a href="#">
                                                                <c:choose>
                                                                    <c:when test="${not empty post.featuredImage}">
                                                                        <img src="${post.featuredImage}" alt="${post.title}">
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        <img src="assets/images/img9.jpg" alt="Default">
                                                                    </c:otherwise>
                                                                </c:choose>
                                                            </a>
                                                            <div class="package-price">
                                                                <h6>
                                                                    <span>
                                                                        <c:choose>
                                                                            <c:when test="${post.roomPrice > 0}">
                                                                                <fmt:formatNumber value="${post.roomPrice}" type="number" maxFractionDigits="0"/>đ/tháng
                                                                            </c:when>
                                                                            <c:otherwise>
                                                                                Liên hệ
                                                                            </c:otherwise>
                                                                        </c:choose>
                                                                    </span>
                                                                </h6>
                                                            </div>
                                                            <div class="package-meta text-center">
                                                                <ul>
                                                                    <li>
                                                                        <i class="fas fa-map-marker-alt"></i>
                                                                        ${post.rentalAreaName}
                                                                    </li>
                                                                    <li>
                                                                        <i class="fas fa-eye"></i>
                                                                        ${post.viewsCount} lượt xem
                                                                    </li>

                                                                </ul>
                                                            </div>
                                                        </figure>
                                                        <div class="package-content">
                                                            <h3>
                                                                <a href="#">${post.title}</a>
                                                            </h3>
                                                            <div class="review-area">
                                                                <span class="review-text">(Bài đăng mới)</span>
                                                                <div class="rating-start" title="Rated 5 out of 5">
                                                                    <span style="width: 100%"></span>
                                                                </div>
                                                            </div>

                                                            <p>Bài đăng mới được đăng tải gần đây.</p>
                                                            <div>
                                                                <a>
                                                                    <i class="fas fa-user"></i>
                                                                    ${post.managerName}
                                                                </a>

                                                            </div>
                                                            <div style="margin-top: 10px">
                                                                <a>
                                                                    <i class="fas fa-phone"></i>
                                                                    <c:choose>
                                                                        <c:when test="${not empty post.contactInfo}">
                                                                            ${post.contactInfo}
                                                                        </c:when>
                                                                        <c:otherwise>
                                                                            Liên hệ
                                                                        </c:otherwise>
                                                                    </c:choose>
                                                                </a>
                                                            </div>
                                                            <div class="btn-wrap">
                                                                <a href="roomDetail?id=${post.postId}" class="button-text width-12">Xem chi tiết<i class="fas fa-arrow-right"></i></a>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </c:if>
                                        </c:forEach>
                                    </c:when>
                                    <c:otherwise>
                                        <!-- Default content when no recent posts -->
                                        <div class="col-lg-6">
                                            <div class="package-wrap package-wrap-list">
                                                <figure class="feature-image">
                                                    <img src="assets/images/img9.jpg" alt="No posts">
                                                    <div class="package-price">
                                                        <h6><span>Không có dữ liệu</span></h6>
                                                    </div>
                                                </figure>
                                                <div class="package-content">
                                                    <h3><a href="#">Chưa có bài đăng mới</a></h3>
                                                    <p>Hiện tại chưa có bài đăng mới nào được đăng tải.</p>
                                                </div>
                                            </div>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                            <div class="btn-wrap text-center">
                                <a href="#" class="button-primary">Xem thêm</a>
                            </div>
                        </div>
                    </div>
                </section>
                <!-- activity html end -->
                <section class="destination-section destination-page">
                    <div class="container"> 
                        <div style="margin-top:30px" class="section-heading text-center">
                            <div class="row">
                                <div class="col-lg-8 offset-lg-2">
                                    <!--                           <h5>BÀI ĐĂNG GẦN ĐÂY</h5>-->
                                    <h2>THEO ĐỊA ĐIỂM</h2>
                                    <div class="title-icon-divider"><i class="fas fa-suitcase-rolling"></i></div>
                                </div>
                            </div>
                        </div>
                        <div class="destination-inner destination-three-column">
                            <div class="row">
                                <div class="col-lg-7">
                                    <div class="row">
                                        <div class="col-sm-6">
                                            <div class="desti-item overlay-desti-item">
                                                <figure style="width: 307px;
                                                        height: 525px" class="desti-image">
                                                    <img style="width: 100%;
                                                         height: 100%;
                                                         object-fit: cover;" src="Image/Location/hanoi.jpg" alt="">
                                                </figure>
                                                <div class="meta-cat bg-meta-cat">
                                                    <a href="searchRooms?province=Thành+phố+Hà+Nội">HÀ NỘI</a>
                                                </div>
                                                <div class="desti-content">
                                                    <h3>
                                                        <a href="searchRooms?province=Thành+phố+Hà+Nội">Hà Nội</a>
                                                    </h3>

                                                </div>
                                            </div>
                                        </div>
                                        <div class="col-sm-6">
                                            <div class="desti-item overlay-desti-item">
                                                <figure style="width: 307px;
                                                        height: 525px" class="desti-image">
                                                    <img style="width: 100%;
                                                         height: 100%;
                                                         object-fit: cover;" src="Image/Location/hcm.jpg" alt="">
                                                </figure>
                                                <div class="meta-cat bg-meta-cat">
                                                    <a href="searchRooms?province=Thành+phố+Hồ+Chí+Minh">TP HỒ CHÍ MINH</a>
                                                </div>
                                                <div class="desti-content">
                                                    <h3>
                                                        <a href="searchRooms?province=Thành+phố+Hồ+Chí+Minh">TP Hồ Chí Minh</a>
                                                    </h3>

                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-lg-5">
                                    <div class="row">
                                        <div class="col-md-6 col-xl-12">
                                            <div class="desti-item overlay-desti-item">

                                                <figure style="width: 450px;
                                                        height: 245px" class="desti-image">
                                                    <img style="width: 100%;
                                                         height: 100%;
                                                         object-fit: cover;" src="Image/Location/danang.webp" alt="">
                                                </figure>
                                                <div class="meta-cat bg-meta-cat">
                                                    <a href="province=Thành+phố+Đà+Nẵng">ĐÀ NẴNG</a>
                                                </div>
                                                <div class="desti-content">
                                                    <h3>
                                                        <a href="province=Thành+phố+Đà+Nẵng">Đà Nẵng</a>
                                                    </h3>

                                                </div>
                                            </div>
                                        </div>
                                        <div class="col-md-6 col-xl-12">
                                            <div class="desti-item overlay-desti-item">
                                                <figure style="width: 450px;
                                                        height: 245px" class="desti-image">
                                                    <img style="width: 100%;
                                                         height: 100%;
                                                         object-fit: cover;" src="Image/Location/binhduong.jpg" alt="">
                                                </figure>
                                                <div class="meta-cat bg-meta-cat">
                                                    <a href="searchRooms?province=Tỉnh+Bình+Dương">BÌNH DƯƠNG</a>
                                                </div>
                                                <div class="desti-content">
                                                    <h3>
                                                        <a href="searchRooms?province=Tỉnh+Bình+Dương">Bình Dương</a>
                                                    </h3>

                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>

                        </div>
                    </div>
                </section>
                <!-- testimonial html end -->
                <!-- Home contact details section html start -->
                <section class="contact-section">
                    <div class="container">
                        <div class="row">
                            <div class="col-lg-4">
                                <div class="contact-img" style="background-image: url(LandingPage/assets/images/img24.jpg);">
                                </div>
                            </div>
                            <div class="col-lg-8">
                                <div class="contact-details-wrap">
                                    <div class="row">
                                        <div class="col-sm-4">
                                            <div class="contact-details">
                                                <div class="contact-icon">
                                                    <img src="LandingPage/assets/images/icon12.png" alt="">
                                                </div>
                                                <ul>
                                                    <li>
                                                        <a href="#">support@gmail.com</a>
                                                    </li>
                                                    <li>
                                                        <a href="#">info@domain.com</a>
                                                    </li>
                                                    <li>
                                                        <a href="#">name@company.com</a>
                                                    </li>
                                                </ul>
                                            </div>
                                        </div>
                                        <div class="col-sm-4">
                                            <div class="contact-details">
                                                <div class="contact-icon">
                                                    <img src="LandingPage/assets/images/icon13.png" alt="">
                                                </div>
                                                <ul>
                                                    <li>
                                                        <a href="#">+132 (599) 254 669</a>
                                                    </li>
                                                    <li>
                                                        <a href="#">+123 (669) 255 587</a>
                                                    </li>
                                                    <li>
                                                        <a href="#">+01 (977) 2599 12</a>
                                                    </li>
                                                </ul>
                                            </div>
                                        </div>
                                        <div class="col-sm-4">
                                            <div class="contact-details">
                                                <div class="contact-icon">
                                                    <img src="LandingPage/assets/images/icon14.png" alt="">
                                                </div>
                                                <ul>
                                                    <li>
                                                        3146 Koontz, California
                                                    </li>
                                                    <li>
                                                        Quze.24 Second floor
                                                    </li>
                                                    <li>
                                                        36 Street, Melbourne
                                                    </li>
                                                </ul>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="contact-btn-wrap">
                                    <h3>LET'S JOIN US FOR MORE UPDATE !!</h3>
                                    <a href="#" class="button-primary">LEARN MORE</a>
                                </div>
                            </div>
                        </div>
                    </div>
                </section>
                <!--  contact details html end -->
            </main>
            <jsp:include page="Common/Footer.jsp"/>
            <!-- header html end -->
        </div>
        <jsp:include page="Common/Js.jsp"/>
        <script>
            $(document).ready(function () {
                // Handle province change
                $('#province-select').change(function () {
                    const province = $(this).val();
                    const districtSelect = $('#district-select');
                    const wardSelect = $('#ward-select');

                    // Reset district and ward
                    districtSelect.html('<option value="">Chọn quận/huyện</option>').prop('disabled', true);
                    wardSelect.html('<option value="">Chọn phường/xã</option>').prop('disabled', true);

                    if (province) {
                        // Load districts for selected province
                        $.ajax({
                            url: 'api/address',
                            method: 'GET',
                            data: {
                                type: 'districts',
                                province: province
                            },
                            dataType: 'json',
                            success: function (districts) {
                                if (districts && districts.length > 0) {
                                    districts.forEach(function (district) {
                                        districtSelect.append('<option value="' + district + '">' + district + '</option>');
                                    });
                                    districtSelect.prop('disabled', false);
                                }
                            },
                            error: function () {
                                console.error('Error loading districts');
                            }
                        });
                    }
                });

                // Handle district change
                $('#district-select').change(function () {
                    const district = $(this).val();
                    const wardSelect = $('#ward-select');

                    // Reset ward
                    wardSelect.html('<option value="">Chọn phường/xã</option>').prop('disabled', true);

                    if (district) {
                        // Load wards for selected district
                        $.ajax({
                            url: 'api/address',
                            method: 'GET',
                            data: {
                                type: 'wards',
                                district: district
                            },
                            dataType: 'json',
                            success: function (wards) {
                                if (wards && wards.length > 0) {
                                    wards.forEach(function (ward) {
                                        wardSelect.append('<option value="' + ward + '">' + ward + '</option>');
                                    });
                                    wardSelect.prop('disabled', false);
                                }
                            },
                            error: function () {
                                console.error('Error loading wards');
                            }
                        });
                    }
                });
            });

            function performSearch() {
                const province = $('#province-select').val();
                const district = $('#district-select').val();
                const ward = $('#ward-select').val();

                // Build search URL
                let searchUrl = 'searchRooms?';
                const params = new URLSearchParams();

                if (province)
                    params.append('province', province);
                if (district)
                    params.append('district', district);
                if (ward)
                    params.append('ward', ward);

                window.location.href = searchUrl + params.toString();
            }
        </script>
    </body>
</html>