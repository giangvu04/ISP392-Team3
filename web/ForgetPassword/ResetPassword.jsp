<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    String message = (String) request.getAttribute("message");
%>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Đăng Nhập - Đặt Lại Mật Khẩu</title>
        <style>
            .form-group {
                position: relative;
                margin-bottom: 20px;
            }

            .form-group input[type="password"],
            .form-group input[type="text"] {
                width: 100%;
                padding: 10px 40px 10px 12px;
                font-size: 16px;
                border: 1px solid #ccc;
                border-radius: 6px;
                outline: none;
                transition: border-color 0.3s ease;
            }

            .form-group input:focus {
                border-color: #007bff;
            }

            .form-group .toggle-password {
                position: absolute;
                top: 65%;
                right: 12px;
                transform: translateY(-50%);
                cursor: pointer;
                font-size: 18px;
                color: #888;
                user-select: none;
            }

            .form-group .toggle-password:hover {
                color: #007bff;
            }
        </style>

        <link rel="stylesheet" href="css/forgetPassword.css">
    </head>
    <body>
        <div class="container">
            <!-- Progress Bar -->
            <div class="progress-bar">
                <div class="progress-fill" style="width: 100%"></div>
            </div>

            <!-- Page 4: Đặt Lại Mật Khẩu -->
            <div class="page active">
                <div class="header">
                    <h1 class="title">Đặt lại mật khẩu</h1>
                    <p class="subtitle">Nhập mật khẩu mới cho tài khoản <%= session.getAttribute("email") != null ? session.getAttribute("email") : "của bạn" %></p>
                    <% if (message != null) { %>
                    <p class="success" id="messageBox"><%= message %></p>
                    <% } %>
                </div>

                <form action="resetPassword" method="POST" id="resetPasswordForm">
                    <div class="form-group">
                        <label for="password">Mật khẩu mới</label>
                        <input type="password" id="password" name="password" required>
                        <span class="toggle-password" onclick="togglePassword('password', this)">👁</span>
                    </div>

                    <div class="form-group">
                        <label for="confirmPassword">Xác nhận mật khẩu</label>
                        <input type="password" id="confirmPassword" name="confirmPassword" required>
                        <span class="toggle-password" onclick="togglePassword('confirmPassword', this)">👁</span>
                    </div>

                    <div class="button-group">
                        <button type="submit" class="btn">Xác nhận</button>
                        <button type="button" class="btn btn-back" onclick="goBack()">Quay lại</button>
                    </div>
                </form>

            </div>
        </div>
        <script>
            function togglePassword(fieldId, iconElement) {
                const input = document.getElementById(fieldId);
                if (input.type === "password") {
                    input.type = "text";
                    iconElement.textContent = "🙈";
                } else {
                    input.type = "password";
                    iconElement.textContent = "👁";
                }
            }

            document.addEventListener("DOMContentLoaded", function () {
                const messageBox = document.getElementById("messageBox");
                const passwordInput = document.getElementById("password");
                const confirmPasswordInput = document.getElementById("confirmPassword");

// Ẩn thông báo sau 5 giây hoặc khi nhập
                function hideMessages() {
                    if (messageBox)
                        messageBox.style.display = "none";
                }

                if (messageBox) {
                    setTimeout(hideMessages, 5000);
                    passwordInput.addEventListener("input", hideMessages);
                    confirmPasswordInput.addEventListener("input", hideMessages);
                }

                window.goBack = function () {
                    window.location.href = "otpchecking";
                };
            });
        </script>


    </body>
</html>