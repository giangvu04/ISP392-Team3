<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    String error = (String) request.getAttribute("error");
%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Đăng Nhập - Nhập Email</title>
        <link rel="stylesheet" href="css/forgetPassword.css">
    </head>
    <body>
        <div class="container">
            <!-- Progress Bar -->
            <div class="progress-bar">
                <div class="progress-fill" style="width: 33.33%"></div>
            </div>

            <!-- Page 1: Nhập Email -->
            <div class="page active">
                <div class="header">

                    <h1 class="title">Chào mừng trở lại</h1>
                    <p class="subtitle">Nhập email để tìm lại tài khoản</p>
                </div>


                <form id="emailForm" method="post" action="forgetPassword">
                    <div class="form-group">
                        <label class="label" for="email">Địa chỉ email</label>
                        <input type="email" name="email" id="email" class="input" placeholder="example@company.com" required>
                        <% if (error != null && !error.trim().isEmpty()) { %>
                        <span id="errorBox" style="background-color: rgba(255, 0, 0, 0.1); color: red; padding: 4px 8px; border-radius: 4px; font-size: 14px; display: inline-block; margin-top: 8px;">
                            ⚠ <%= error %>
                        </span>
                        <% } %>
                    </div>

                    <button type="submit" class="btn">Tiếp tục</button>
                </form>

                <div class="footer-links">
                    <a href="login"> Quay lại</a>

                </div>
            </div>
        </div>

        <script>
            window.addEventListener("DOMContentLoaded", function () {
                const errorBox = document.getElementById("errorBox");
                if (errorBox) {
                    setTimeout(() => {
                        errorBox.style.display = "none";
                    }, 5000);
                }

// Nếu người dùng tương tác → ẩn ngay
                const form = document.querySelector("form");
                if (form && errorBox) {
                    form.addEventListener("input", () => {
                        errorBox.style.display = "none";
                    });
                }
            });

        </script>
    </body>
</html>