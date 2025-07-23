<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!doctype html>
<html lang="en">
    <head>
        <jsp:include page="Common/Css.jsp"/>
        <style>
            .search-form-section {
                background: #f8f9fa;
                padding: 40px 0;
                margin-bottom: 40px;
            }

            .search-form-card {
                background: white;
                border-radius: 10px;
                padding: 30px;
                box-shadow: 0 5px 15px rgba(0,0,0,0.1);
            }

            .search-form-section select.form-control, .search-form-section input.form-control {
                width: 100%;
                padding: 12px 15px;
                border: 2px solid #e5e5e5;
                border-radius: 5px;
                font-size: 14px;
                color: #666;
                background-color: #fff;
                transition: border-color 0.3s ease;
                margin-bottom: 15px;
            }

            .search-form-section select.form-control:focus, .search-form-section input.form-control:focus {
                border-color: #ff6b35;
                outline: none;
            }

            .search-form-section select.form-control:disabled {
                background-color: #f5f5f5;
                color: #999;
                cursor: not-allowed;
            }

            .price-range-inputs {
                display: flex;
                gap: 10px;
                align-items: center;
            }

            .price-range-inputs input {
                flex: 1;
            }

            .price-separator {
                color: #666;
                font-weight: bold;
            }

            .search-results-header {
                border-bottom: 2px solid #ff6b35;
                padding-bottom: 15px;
                margin-bottom: 30px;
            }

            .pagination-section {
                margin-top: 40px;
                text-align: center;
            }

            .pagination {
                display: inline-flex;
                list-style: none;
                padding: 0;
                margin: 0;
                border-radius: 5px;
            }

            .pagination li {
                margin: 0 2px;
            }

            .pagination li a {
                display: block;
                padding: 10px 15px;
                text-decoration: none;
                background: #fff;
                border: 1px solid #ddd;
                color: #333;
                transition: all 0.3s ease;
            }

            .pagination li.active a {
                background: #ff6b35;
                border-color: #ff6b35;
                color: white;
            }

            .pagination li a:hover:not(.active) {
                background: #f8f9fa;
            }

            .no-results {
                text-align: center;
                padding: 60px 20px;
                color: #666;
            }

            .no-results i {
                font-size: 48px;
                margin-bottom: 20px;
                color: #ccc;
            }
        </style>
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
                                <h1 class="inner-title">Tìm Kiếm Phòng Trọ</h1>
                                <p>Tìm phòng trọ phù hợp với nhu cầu của bạn</p>
                            </div>
                        </div>
                    </div>
                    <div class="inner-shape"></div>
                </section>
                <!-- Inner Banner html end-->

                <!-- Search Form Section -->
                <section class="search-form-section">
                    <div class="container">
                        <div class="search-form-card">
                            <h3 class="mb-4">Tìm Kiếm Nâng Cao</h3>
                            <form method="GET" action="searchRooms">
                                <div class="row">
                                    <div class="col-md-6">
                                        <label>Từ khóa</label>
                                        <input type="text" name="keyword" class="form-control" 
                                               placeholder="Nhập từ khóa tìm kiếm..." 
                                               value="${searchKeyword}">
                                    </div>

                                    <div class="col-md-6">
                                        <label>Khoảng giá (VND)</label>
                                        <div class="price-range-inputs">
                                            <input type="number" name="minPrice" class="form-control" 
                                                   placeholder="Từ" value="${searchMinPrice}" min="0">
                                            <span class="price-separator">-</span>
                                            <input type="number" name="maxPrice" class="form-control" 
                                                   placeholder="Đến" value="${searchMaxPrice}" min="0">
                                        </div>
                                    </div>
                                    <div class="col-md-4">
                                        <label>Tỉnh/Thành phố</label>
                                        <select style="height: 48px" id="province-select" name="province" class="form-control">
                                            <option value="">Chọn tỉnh</option>
                                            <c:forEach var="province" items="${provinces}">
                                                <option value="${province}" ${searchProvince == province ? 'selected' : ''}>${province}</option>
                                            </c:forEach>
                                        </select>
                                    </div>
                                    <div class="col-md-4">
                                        <label>Quận/Huyện</label>
                                        <select style="height: 48px" id="district-select" name="district" class="form-control" ${empty searchProvince ? 'disabled' : ''}>
                                            <option value="">Chọn quận/huyện</option>
                                            <c:if test="${not empty searchDistrict}">
                                                <option value="${searchDistrict}" selected>${searchDistrict}</option>
                                            </c:if>
                                        </select>
                                    </div>
                                    <div class="col-md-4">
                                        <label>Phường/Xã</label>
                                        <select style="height: 48px" id="ward-select" name="ward" class="form-control" ${empty searchDistrict ? 'disabled' : ''}>
                                            <option value="">Chọn phường/xã</option>
                                            <c:if test="${not empty searchWard}">
                                                <option value="${searchWard}" selected>${searchWard}</option>
                                            </c:if>
                                        </select>
                                    </div>
                                </div>
                                <div class="row mt-3">
                                    <div class="col-12 text-center">
                                        <button type="submit" style="font-size: 16px" class="btn btn-primary btn-lg px-5">
                                            <i class="fas fa-search mr-2"></i> Tìm Kiếm
                                        </button>
                                        <a href="searchRooms" style="font-size: 16px" class="btn btn-secondary btn-lg px-4 ml-2">
                                            <i class="fas fa-times mr-2"></i> Xóa Bộ Lọc
                                        </a>
                                    </div>
                                </div>
                            </form>
                        </div>
                    </div>
                </section>

                <!-- Search Results Section -->
                <div class="package-section">
                    <div class="container">
                        <div class="search-results-header">
                            <h2 style="font-size: 18px">Kết Quả Tìm Kiếm</h2>
                            <p class="mb-0">
                                <c:choose>
                                    <c:when test="${totalResults > 0}">
                                        Tìm thấy <strong>${totalResults}</strong> kết quả
                                        <c:if test="${totalPages > 1}">
                                            - Trang ${currentPage} / ${totalPages}
                                        </c:if>
                                    </c:when>
                                    <c:otherwise>
                                        Không tìm thấy kết quả nào
                                    </c:otherwise>
                                </c:choose>
                            </p>
                        </div>

                        <div class="package-inner">
                            <c:choose>
                                <c:when test="${not empty searchResults}">
                                    <div class="row">
                                        <c:forEach var="post" items="${searchResults}">
                                            <div class="col-lg-4 col-md-6">
                                                <div class="package-wrap">
                                                    <figure class="feature-image">
                                                        <a href="roomDetail?id=${post.postId}">
                                                            <c:choose>
                                                                <c:when test="${not empty post.featuredImage}">
                                                                    <img src="${post.featuredImage}" alt="${post.title}" 
                                                                         style="width: 100%; height: 200px; object-fit: cover;">
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <img src="LandingPage/assets/images/img5.jpg" alt="${post.title}" 
                                                                         style="width: 100%; height: 200px; object-fit: cover;">
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </a>
                                                    </figure>

                                                    <div class="package-price">
                                                        <h6 >
                                                            <c:choose>
                                                                <c:when test="${post.roomPrice > 0}">
                                                                    <span style="font-size: 14px"><fmt:formatNumber value="${post.roomPrice}" type="currency" currencySymbol="" maxFractionDigits="0"/> VND</span> / tháng
                                                                </c:when>
                                                                <c:otherwise>
                                                                    <span>Liên hệ</span>
                                                                </c:otherwise>
                                                            </c:choose>
                                                        </h6>
                                                    </div>
                                                    <div class="package-content-wrap">
                                                        <div class="package-meta text-center">
                                                            <ul>
                                                                <li>
                                                                    <i class="far fa-eye"></i>
                                                                    ${post.viewsCount} lượt xem
                                                                </li>
                                                                <c:if test="${not empty post.managerPhone}">
                                                                    <li>
                                                                        <i class="fas fa-map-marker-alt"></i>
                                                                        ${post.rentalAreaName}
                                                                    </li>
                                                                </c:if>
                                                            </ul>
                                                        </div>
                                                        <div class="package-content">
                                                            <h3>
                                                                <a href="roomDetail?id=${post.postId}">${post.title}</a>
                                                            </h3>
                                                            <div style="display: flex; justify-content: space-between; margin-bottom: 20px">
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
                                                                    <div style="text-align: center" class="btn-wrap">
                                                                <a href="roomDetail?id=${post.postId}" class="button-text width-6">Xem Chi Tiết<i class="fa fa-angle-right"></i></a>
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>
                                            </div>
                                        </c:forEach>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <div class="no-results">
                                        <i class="fas fa-search"></i>
                                        <h3>Không tìm thấy kết quả</h3>
                                        <p>Vui lòng thử lại với từ khóa hoặc bộ lọc khác.</p>
                                        <a href="searchRooms" class="btn btn-primary">Tìm kiếm lại</a>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>

                        <!-- Pagination -->
                        <c:if test="${totalPages > 1}">
                            <div class="pagination-section">
                                <ul class="pagination">
                                    <!-- Previous page -->
                                    <c:if test="${currentPage > 1}">
                                        <li>
                                            <a href="searchRooms?${requestScope.searchParams}&page=${currentPage - 1}">
                                                <i class="fas fa-chevron-left"></i> Trước
                                            </a>
                                        </li>
                                    </c:if>

                                    <!-- Page numbers -->
                                    <c:choose>
                                        <c:when test="${totalPages <= 7}">
                                            <!-- Show all pages if total <= 7 -->
                                            <c:forEach begin="1" end="${totalPages}" var="pageNum">
                                                <li class="${currentPage == pageNum ? 'active' : ''}">
                                                    <a href="searchRooms?${requestScope.searchParams}&page=${pageNum}">${pageNum}</a>
                                                </li>
                                            </c:forEach>
                                        </c:when>
                                        <c:otherwise>
                                            <!-- Show abbreviated pagination -->
                                            <c:if test="${currentPage > 3}">
                                                <li><a href="searchRooms?${requestScope.searchParams}&page=1">1</a></li>
                                                    <c:if test="${currentPage > 4}">
                                                    <li><span>...</span></li>
                                                    </c:if>
                                                </c:if>

                                            <c:forEach begin="${currentPage > 3 ? currentPage - 2 : 1}" 
                                                       end="${currentPage < totalPages - 2 ? currentPage + 2 : totalPages}" 
                                                       var="pageNum">
                                                <li class="${currentPage == pageNum ? 'active' : ''}">
                                                    <a href="searchRooms?${requestScope.searchParams}&page=${pageNum}">${pageNum}</a>
                                                </li>
                                            </c:forEach>

                                            <c:if test="${currentPage < totalPages - 2}">
                                                <c:if test="${currentPage < totalPages - 3}">
                                                    <li><span>...</span></li>
                                                    </c:if>
                                                <li><a href="searchRooms?${requestScope.searchParams}&page=${totalPages}">${totalPages}</a></li>
                                                </c:if>
                                            </c:otherwise>
                                        </c:choose>

                                    <!-- Next page -->
                                    <c:if test="${currentPage < totalPages}">
                                        <li>
                                            <a href="searchRooms?${requestScope.searchParams}&page=${currentPage + 1}">
                                                Sau <i class="fas fa-chevron-right"></i>
                                            </a>
                                        </li>
                                    </c:if>
                                </ul>
                            </div>
                        </c:if>
                    </div>
                </div>
            </main>
            <jsp:include page="Common/Footer.jsp"/>
        </div>

        <jsp:include page="Common/Js.jsp"/>
        <script>
            $(document).ready(function () {
                // Initialize district and ward if we have search values
                const searchProvince = '${searchProvince}';
                const searchDistrict = '${searchDistrict}';
                const searchWard = '${searchWard}';

                if (searchProvince && searchDistrict) {
                    loadDistricts(searchProvince, searchDistrict);
                }

                if (searchDistrict && searchWard) {
                    loadWards(searchDistrict, searchWard);
                }

                // Handle province change
                $('#province-select').change(function () {
                    const province = $(this).val();
                    const districtSelect = $('#district-select');
                    const wardSelect = $('#ward-select');

                    // Reset district and ward
                    districtSelect.html('<option value="">Chọn quận/huyện</option>').prop('disabled', true);
                    wardSelect.html('<option value="">Chọn phường/xã</option>').prop('disabled', true);

                    if (province) {
                        loadDistricts(province);
                    }
                });

                // Handle district change
                $('#district-select').change(function () {
                    const district = $(this).val();
                    const wardSelect = $('#ward-select');

                    // Reset ward
                    wardSelect.html('<option value="">Chọn phường/xã</option>').prop('disabled', true);

                    if (district) {
                        loadWards(district);
                    }
                });

                function loadDistricts(province, selectedDistrict = null) {
                    const districtSelect = $('#district-select');

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
                                    const selected = selectedDistrict && district === selectedDistrict ? 'selected' : '';
                                    districtSelect.append('<option value="' + district + '" ' + selected + '>' + district + '</option>');
                                });
                                districtSelect.prop('disabled', false);
                            }
                        },
                        error: function () {
                            console.error('Error loading districts');
                        }
                    });
                }

                function loadWards(district, selectedWard = null) {
                    const wardSelect = $('#ward-select');

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
                                    const selected = selectedWard && ward === selectedWard ? 'selected' : '';
                                    wardSelect.append('<option value="' + ward + '" ' + selected + '>' + ward + '</option>');
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
        </script>
    </body>
</html>
<li>
    <i class="far fa-clock"></i>
    7D/6N
</li>
<li>
    <i class="fas fa-user-friends"></i>
    People: 5
</li>
<li>
    <i class="fas fa-map-marker-alt"></i>
    Malaysia
</li>
</ul>
</div>
<div class="package-content">
    <h3>
        <a href="#">Sunset view of beautiful lakeside resident</a>
    </h3>
    <div class="review-area">
        <span class="review-text">(25 reviews)</span>
        <div class="rating-start" title="Rated 5 out of 5">
            <span style="width: 60%"></span>
        </div>
    </div>
    <p>Lorem ipsum dolor sit amet, consectetur adipiscing elit luctus nec ullam. Ut elit tellus, luctus nec ullam elit tellpus.</p>
    <div class="btn-wrap">
        <a href="#" class="button-text width-6">Book Now<i class="fas fa-arrow-right"></i></a>
        <a href="#" class="button-text width-6">Wish List<i class="far fa-heart"></i></a>
    </div>
</div>
</div>
</div>
</div>
<div class="col-lg-4 col-md-6">
    <div class="package-wrap">
        <figure class="feature-image">
            <a href="#">
                <img src="LandingPage/assets/images/img6.jpg" alt="">
            </a>
        </figure>
        <div class="package-price">
            <h6>
                <span>$1,230 </span> / per person
            </h6>
        </div>
        <div class="package-content-wrap">
            <div class="package-meta text-center">
                <ul>
                    <li>
                        <i class="far fa-clock"></i>
                        5D/4N
                    </li>
                    <li>
                        <i class="fas fa-user-friends"></i>
                        People: 8
                    </li>
                    <li>
                        <i class="fas fa-map-marker-alt"></i>
                        Canada
                    </li>
                </ul>
            </div>
            <div class="package-content">
                <h3>
                    <a href="#">Experience the natural beauty of island</a>
                </h3>
                <div class="review-area">
                    <span class="review-text">(17 reviews)</span>
                    <div class="rating-start" title="Rated 5 out of 5">
                        <span style="width: 100%"></span>
                    </div>
                </div>
                <p>Lorem ipsum dolor sit amet, consectetur adipiscing elit luctus nec ullam. Ut elit tellus, luctus nec ullam elit tellpus.</p>
                <div class="btn-wrap">
                    <a href="#" class="button-text width-6">Book Now<i class="fas fa-arrow-right"></i></a>
                    <a href="#" class="button-text width-6">Wish List<i class="far fa-heart"></i></a>
                </div>
            </div>
        </div>
    </div>
</div>
<div class="col-lg-4 col-md-6">
    <div class="package-wrap">
        <figure class="feature-image">
            <a href="#">
                <img src="LandingPage/assets/images/img7.jpg" alt="">
            </a>
        </figure>
        <div class="package-price">
            <h6>
                <span>$2,000 </span> / per person
            </h6>
        </div>
        <div class="package-content-wrap">
            <div class="package-meta text-center">
                <ul>
                    <li>
                        <i class="far fa-clock"></i>
                        6D/5N
                    </li>
                    <li>
                        <i class="fas fa-user-friends"></i>
                        People: 6
                    </li>
                    <li>
                        <i class="fas fa-map-marker-alt"></i>
                        Portugal
                    </li>
                </ul>
            </div>
            <div class="package-content">
                <h3>
                    <a href="#">Vacation to the water city of Portugal</a>
                </h3>
                <div class="review-area">
                    <span class="review-text">(22 reviews)</span>
                    <div class="rating-start" title="Rated 5 out of 5">
                        <span style="width: 80%"></span>
                    </div>
                </div>
                <p>Lorem ipsum dolor sit amet, consectetur adipiscing elit luctus nec ullam. Ut elit tellus, luctus nec ullam elit tellpus.</p>
                <div class="btn-wrap">
                    <a href="#" class="button-text width-6">Book Now<i class="fas fa-arrow-right"></i></a>
                    <a href="#" class="button-text width-6">Wish List<i class="far fa-heart"></i></a>
                </div>
            </div>
        </div>
    </div>
</div>
<div class="col-lg-4 col-md-6">
    <div class="package-wrap">
        <figure class="feature-image">
            <a href="#">
                <img src="LandingPage/assets/images/img7.jpg" alt="">
            </a>
        </figure>
        <div class="package-price">
            <h6>
                <span>$2,000 </span> / per person
            </h6>
        </div>
        <div class="package-content-wrap">
            <div class="package-meta text-center">
                <ul>
                    <li>
                        <i class="far fa-clock"></i>
                        6D/5N
                    </li>
                    <li>
                        <i class="fas fa-user-friends"></i>
                        People: 6
                    </li>
                    <li>
                        <i class="fas fa-map-marker-alt"></i>
                        Portugal
                    </li>
                </ul>
            </div>
            <div class="package-content">
                <h3>
                    <a href="#">Trekking to the base camp of mountain</a>
                </h3>
                <div class="review-area">
                    <span class="review-text">(22 reviews)</span>
                    <div class="rating-start" title="Rated 5 out of 5">
                        <span style="width: 80%"></span>
                    </div>
                </div>
                <p>Lorem ipsum dolor sit amet, consectetur adipiscing elit luctus nec ullam. Ut elit tellus, luctus nec ullam elit tellpus.</p>
                <div class="btn-wrap">
                    <a href="#" class="button-text width-6">Book Now<i class="fas fa-arrow-right"></i></a>
                    <a href="#" class="button-text width-6">Wish List<i class="far fa-heart"></i></a>
                </div>
            </div>
        </div>
    </div>
</div>
<div class="col-lg-4 col-md-6">
    <div class="package-wrap">
        <figure class="feature-image">
            <a href="#">
                <img src="LandingPage/assets/images/img7.jpg" alt="">
            </a>
        </figure>
        <div class="package-price">
            <h6>
                <span>$2,000 </span> / per person
            </h6>
        </div>
        <div class="package-content-wrap">
            <div class="package-meta text-center">
                <ul>
                    <li>
                        <i class="far fa-clock"></i>
                        6D/5N
                    </li>
                    <li>
                        <i class="fas fa-user-friends"></i>
                        People: 6
                    </li>
                    <li>
                        <i class="fas fa-map-marker-alt"></i>
                        Portugal
                    </li>
                </ul>
            </div>
            <div class="package-content">
                <h3>
                    <a href="#">Beautiful season of the rural village</a>
                </h3>
                <div class="review-area">
                    <span class="review-text">(22 reviews)</span>
                    <div class="rating-start" title="Rated 5 out of 5">
                        <span style="width: 80%"></span>
                    </div>
                </div>
                <p>Lorem ipsum dolor sit amet, consectetur adipiscing elit luctus nec ullam. Ut elit tellus, luctus nec ullam elit tellpus.</p>
                <div class="btn-wrap">
                    <a href="#" class="button-text width-6">Book Now<i class="fas fa-arrow-right"></i></a>
                    <a href="#" class="button-text width-6">Wish List<i class="far fa-heart"></i></a>
                </div>
            </div>
        </div>
    </div>
</div>
<div class="col-lg-4 col-md-6">
    <div class="package-wrap">
        <figure class="feature-image">
            <a href="#">
                <img src="LandingPage/assets/images/img7.jpg" alt="">
            </a>
        </figure>
        <div class="package-price">
            <h6>
                <span>$2,000 </span> / per person
            </h6>
        </div>
        <div class="package-content-wrap">
            <div class="package-meta text-center">
                <ul>
                    <li>
                        <i class="far fa-clock"></i>
                        6D/5N
                    </li>
                    <li>
                        <i class="fas fa-user-friends"></i>
                        People: 6
                    </li>
                    <li>
                        <i class="fas fa-map-marker-alt"></i>
                        Portugal
                    </li>
                </ul>
            </div>
            <div class="package-content">
                <h3>
                    <a href="#">Summer holiday to the Oxolotan River</a>
                </h3>
                <div class="review-area">
                    <span class="review-text">(22 reviews)</span>
                    <div class="rating-start" title="Rated 5 out of 5">
                        <span style="width: 80%"></span>
                    </div>
                </div>
                <p>Lorem ipsum dolor sit amet, consectetur adipiscing elit luctus nec ullam. Ut elit tellus, luctus nec ullam elit tellpus.</p>
                <div class="btn-wrap">
                    <a href="#" class="button-text width-6">Book Now<i class="fas fa-arrow-right"></i></a>
                    <a href="#" class="button-text width-6">Wish List<i class="far fa-heart"></i></a>
                </div>
            </div>
        </div>
    </div>
</div>
</div>
</div>
</div>
</div>
<!-- packages html end -->
<!-- Home activity section html start -->
<!--            <section class="activity-section">
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
<!-- activity html end -->
</main>
<jsp:include page="Common/Footer.jsp"/>
<!-- header html end -->
</div>

<jsp:include page="Common/Js.jsp"/>
</body>
</html>