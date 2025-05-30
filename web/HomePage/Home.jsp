<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%= "DEBUG: Home.jsp is running!" %>  <!-- Add this line -->
<%@ page import="java.util.ArrayList" %>
<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Trang chủ Quản lý</title>
    <base href="${pageContext.request.contextPath}/">
    <link rel="stylesheet" href="css/product.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.7.2/css/all.min.css"
          integrity="sha512-Evv84Mr4kqVGRNSgIGL/F/aIDqQb7xQ2vcrdIwxfjThSH8CSR7PBEakCr51Ck+w+/U6swU2Im1vVX0SVk9ABhg=="
          crossorigin="anonymous" referrerpolicy="no-referrer" />
</head>

<body><!-- Homepage Header -->
    <div class="header">
        <div class="container">
            <img src="Image/logo.png" alt="logo" class="home-logo">
        </div>
        <div class="header__navbar-item navbar__user">
            <span class="navbar__user--name">
                GiangNT
            </span>
            <div class="navbar__user--info">
                <div class="navbar__info--wrapper">
                    <a href="" class="navbar__info--item">Tài khoản của tôi</a>
                </div>
                <div class="navbar__info--wrapper">
                    <a href="" class="navbar__info--item">Đăng xuất</a>
                </div>
            </div>
        </div>
    </div>

    <div class="body">
        <div class="body-container">
            <!-- Menu sidebar  -->
            <div class="mainmenu">
                <ul class="mainmenu-list row no-gutters">
                    <li class="mainmenu__list-item">
                        <a href="">
                            <i class="fa-solid fa-bowl-rice list-item-icon"></i>
                            Phòng
                        </a>
                    </li>
                    <li class="mainmenu__list-item">
                        <a href="">
                            <i class="fa-solid fa-box list-item-icon"></i>
                            Dịch vụ
                        </a>
                    </li>
                    <li class="mainmenu__list-item">
                        <a href="">
                            <i class="fa-solid fa-dollar-sign list-item-icon"></i>
                            Hợp đồng
                        </a>
                    </li>
                    <li class="mainmenu__list-item">
                        <a href="">
                            <i class="fa-solid fa-person list-item-icon"></i>
                            Khách Hàng
                        </a>
                    </li>
                    <li class="mainmenu__list-item">
                        <a href="">
                            <i class="fa-solid fa-wallet list-item-icon"></i>
                            Hóa đơn
                        </a>
                    </li>
                    <li class="mainmenu__list-item">
                        <a href="">
                            <i class="fa-solid fa-user list-item-icon"></i>
                            Tài Khoản
                        </a>
                    </li>
                </ul>
            </div>

            <!-- HomePage Body -->
            <div class="homepage-body">
                <div class="body-head">
                    <h3 class="body__head-title">Thông tin Phòng</h3>
                    <div class="search-container">
                        <form action="listrooms" method="post">
                            <input type="text" id="information" name="information" placeholder="Tìm kiếm phòng..." class="search-input">
                            <input class="Search-btn" type="submit" value="Search">
                        </form>
                    </div>
                </div>
                <!-- Room List -->
                <div class="table-container">
                    <table class="product-table">
                        <thead>
                            <tr class="table-header">
                                <th class="table-header-item">Hình ảnh</th>
                                <th class="table-header-item">Mã phòng</th>
                                <th class="table-header-item">địa chỉ</th>
                                <th class="table-header-item">Giá tiền thuê</th>
                                <th class="table-header-item">Mô tả</th>
                                <th class="table-header-item">Hành động</th>
                                <th class="table-header-item">Trạng thái</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr class="table-row">
                                <td class="table-cell"><img src="Image/room1.jpg" alt="room1"
                                                            class="product-image"></td>
                                <td class="table-cell">1</td>
                                <td class="table-cell">192 Đội Cấn, Ba Đình</td>
                                <td class="table-cell">1.5 triệu đồng</td>
                                <td class="table-cell description">Căn hộ cho thuê tiện nghi, rộng rãi và thoáng mát, nằm tại trung tâm thành phố. Diện tích 70m² với 2 phòng ngủ, 1 phòng tắm hiện đại và bếp được trang bị đầy đủ. Không gian sống được thiết kế hiện đại, phù hợp cho gia đình hoặc người đi làm. Gần các tiện ích như siêu thị, trường học và giao thông công cộng.</td>
                                <td class="table-cell">
                                    <a href="" class="action-button">Sửa</a>
                                </td>
                                <td class="table-cell">
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>

    <!-- Modal -->

    <!-- Footer -->
    <div class="footer">
        <div class="container">
            <p>&copy; 2025 Công ty TNHH G3. Tất cả quyền được bảo lưu.</p>
        </div>
    </div>
</body>
</html>