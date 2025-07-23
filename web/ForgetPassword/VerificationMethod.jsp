<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    String error = (String) request.getAttribute("error");
%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Đăng Nhập - Chọn Phương Thức</title>
        <link rel="stylesheet" href="css/forgetPassword.css">
        <style>
            .method-option {
                display: flex;
                align-items: center;
                border: 1px solid #ccc;
                padding: 12px;
                margin-bottom: 10px;
                border-radius: 8px;
                cursor: pointer;
            }
            .method-option input[type="radio"] {
                margin-right: 12px;
            }
            .method-option.active {
                border-color: #007bff;
                background-color: #f0f8ff;
            }
        </style>
    </head>
    <body>
        <div class="container">
            <!-- Progress Bar -->
            <div class="progress-bar">
                <div class="progress-fill" style="width: 66.66%"></div>
            </div>

            <!-- Page 2: Chọn Phương Thức -->
            <form action="verificationMethod" method="post">
                <div class="page active">
                    <div class="header">

                        <h1 class="title">Chọn phương thức xác thực</h1>
                        <p class="subtitle">Chúng tôi sẽ gửi mã xác thực cho bạn</p>
                    </div>

                    <label class="method-option">
                        <input type="radio" name="method" value="email" onchange="enableContinueBtn()">
                        <div class="method-icon">📧</div>
                        <div class="method-text">
                            <h3>Gửi qua Email</h3>
                            <p id="emailPreview">${email}</p>
                        </div>
                    </label>
                    <% if (error != null && !error.trim().isEmpty()) { %>
                    <span id="errorBox" style="background-color: rgba(255, 0, 0, 0.1); color: red; padding: 4px 8px; border-radius: 4px; font-size: 14px; display: inline-block; margin-top: 8px;">
                        ⚠ <%= error %>
                    </span>
                    <% } %>

                    <!-- (Bạn có thể thêm các phương thức khác như SMS, App tại đây) -->

                    <div class="button-group">
                        <button type="submit" class="btn" id="continueBtn">Tiếp tục</button>
                        <button type="button" class="btn btn-back" onclick="goBack()">Quay lại</button>
                    </div>
                </div>
            </form>
        </div>
        <script>
            function goBack() {
                window.location.href = "forgetPassword";
            }

            // Ẩn lỗi sau 5 giây nếu tồn tại
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
