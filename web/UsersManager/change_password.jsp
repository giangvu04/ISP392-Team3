<%-- 
    Document   : change_password
    Created on : Jun 1, 2025, 8:45:52 PM
    Author     : ADMIN
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Change Password</title>
        <style>
        body, html {
            margin: 0;
            padding: 0;
            height: 100%;
            font-family: Arial, sans-serif;
        }

        .container {
            background: url('<%= request.getContextPath() %>/Image/dai-ly-gao-1.jpg') no-repeat center center fixed;
            background-size: cover;
            height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
        }

        .login-box {
            background: white;
            padding: 25px;
            border-radius: 10px;
            box-shadow: 0px 4px 8px rgba(0, 0, 0, 0.2);
            text-align: center;
            width: 400px;
            position: absolute;
            left: 50%;
            top: 50%;
            transform: translate(-50%, -50%);
        }

        .login-box h2 {
            color: #003399;
            margin-bottom: 20px;
        }

        input[type="password"] {
            width: 100%;
            padding: 10px;
            margin: 10px 0;
            border: 1px solid #ccc;
            border-radius: 5px;
        }

        .search-button, .btn-secondary {
            width: 100%;
            padding: 10px;
            background-color: #007BFF;
            border: none;
            color: white;
            font-size: 16px;
            border-radius: 5px;
            cursor: pointer;
            margin-top: 10px;
        }

        .search-button:hover, .btn-secondary:hover {
            background-color: #0056b3;
        }

        .btn-secondary {
            background-color: #6c757d;
        }

        .btn-secondary:hover {
            background-color: #5a6268;
        }

        .toast-message {
            position: fixed;
            top: 20px;
            right: 20px;
            background: #dc3545;
            color: white;
            padding: 10px 20px;
            border-radius: 5px;
            font-size: 14px;
            opacity: 1;
            transition: opacity 0.5s ease-out;
            z-index: 1000;
            display: none;
        }
    </style>
    </head>
    <body>
        <div class="container">
        <div class="login-box">
            <h2>Đổi Mật Khẩu</h2>

            <%-- <c:if test="${not empty error}">
                <div class="toast-message" id="toast-message">${error}</div>
            </c:if> --%>

            <form action="${pageContext.request.contextPath}/user/change-password" method="post">
                <input type="password" name="currentPassword" placeholder="Mật khẩu hiện tại" required>
                <input type="password" name="newPassword" placeholder="Mật khẩu mới" required>
                <input type="password" name="confirmPassword" placeholder="Xác nhận mật khẩu mới" required>

                <input type="submit" class="search-button" value="Đổi Mật Khẩu">
                <a href="${pageContext.request.contextPath}/Login/login.jsp" class="btn-secondary">Quay lại Login</a>
            </form>
        </div>
    </div>

    <script>
        window.onload = function () {
            var toast = document.getElementById("toast-message");
            if (toast) {
                toast.style.display = "block";
                setTimeout(function () {
                    toast.style.opacity = "0";
                    setTimeout(() => toast.style.display = "none", 500);
                }, 3000);
            }
        };
    </script>
        
    </body>
</html>
