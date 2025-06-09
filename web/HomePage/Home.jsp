<%@page contentType="text/html" pageEncoding="UTF-8"%>
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
                <div class="navbar__info--wrapper">
                    <a href="login" class="navbar__info--item">Đăng nhập</a>
                </div>
            </div>
        </div>
    </div>

    <div class="body">
        <div class="body-container">
            <!-- Menu sidebar  -->
            <div class="mainmenu">
                <ul class="mainmenu-list row no-gutters">
                  
                </ul>
            </div>

            <!-- HomePage Body -->
            <div class="homepage-body">
                <div class="body-head">
                    <h3 class="body__head-title">Home Page</h3>
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