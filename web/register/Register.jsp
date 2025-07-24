<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Đăng ký tài khoản mới</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body, html {
            height: 100%;
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', 'Roboto', sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
            margin: 0;
        }
        .register-box {
            background: rgba(255, 255, 255, 0.97);
            border-radius: 16px;
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.1);
            max-width: 700px;
            padding: 40px;
            animation: slideUp 0.8s ease-out;
        }
        @keyframes slideUp {
            0% { transform: translateY(30px); opacity: 0; }
            100% { transform: translateY(0); opacity: 1; }
        }
        .register-title {
            color: #2d3748;
            font-size: 28px;
            font-weight: 700;
            text-align: center;
            margin-bottom: 8px;
        }
        .register-subtitle {
            color: #718096;
            font-size: 16px;
            text-align: center;
            margin-bottom: 32px;
        }
        .form-label {
            color: #4a5568;
            font-weight: 500;
            font-size: 14px;
        }
        .form-control {
            padding: 14px;
            border: 2px solid #e2e8f0;
            border-radius: 12px;
            background: #f7fafc;
            transition: all 0.3s ease;
        }
        .form-control:focus {
            border-color: #667eea;
            background: white;
            box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
        }
        .btn-primary {
            width: 100%;
            padding: 14px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            border: none;
            font-size: 16px;
            font-weight: 600;
            border-radius: 12px;
            transition: all 0.3s ease;
        }
        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 20px rgba(102, 126, 234, 0.3);
        }
        .login-link {
            text-align: center;
            margin-top: 18px;
        }
        .login-link a {
            color: #667eea;
            text-decoration: none;
            font-weight: 500;
        }
        .login-link a:hover {
            color: #764ba2;
            text-decoration: underline;
        }
        .custom-toast-message {
            position: fixed;
            top: 20px;
            right: 20px;
            background: #f56565;
            color: white;
            padding: 16px 20px;
            border-radius: 12px;
            box-shadow: 0 10px 20px rgba(245, 101, 101, 0.3);
            font-size: 14px;
            font-weight: 500;
            opacity: 1;
            transition: all 0.5s ease-out;
            z-index: 9999;
            display: none;
            max-width: 300px;
        }
        @media (max-width: 768px) {
            .register-box {
                max-width: 90%;
                padding: 30px 20px;
            }
        }
    </style>
</head>
<body>
    <div class="register-box">
        <% 
            String message = (String) session.getAttribute("ms");
            String error = (String) session.getAttribute("error");
            String fullName = (String) session.getAttribute("fullName");
            String phone = (String) session.getAttribute("phone");
            String password = (String) session.getAttribute("password");
            String confirmPassword = (String) session.getAttribute("confirmPassword");
        %>
        <% if (message != null && !message.isEmpty()) { %>
        <div id="custom-toast-message" class="custom-toast-message"><%= message %></div>
        <script>
            window.onload = function () {
                var toast = document.getElementById("custom-toast-message");
                if (toast) {
                    toast.style.display = "block";
                    setTimeout(function () {
                        toast.style.opacity = "0";
                        setTimeout(() => toast.style.display = "none", 500);
                    }, 3000);
                }
            };
        </script>
        <% session.removeAttribute("ms"); %>
        <% } %>
        <% if (error != null && !error.isEmpty()) { %>
        <div id="custom-toast-message" class="custom-toast-message"><%= error %></div>
        <script>
            window.onload = function () {
                var toast = document.getElementById("custom-toast-message");
                if (toast) {
                    toast.style.display = "block";
                    setTimeout(function () {
                        toast.style.opacity = "0";
                        setTimeout(() => toast.style.display = "none", 500);
                    }, 3000);
                }
            };
        </script>
        <% } %>
        <h2 class="register-title">Đăng ký tài khoản mới</h2>
        <p class="register-subtitle">Tạo tài khoản để sử dụng DreamHouse</p>
        <form action="registerr" method="post">
            <div class="row g-3">
                <div class="col-md-6">
                    <div class="mb-3">
                        <label for="fullName" class="form-label">Họ và tên</label>
                        <input type="text" id="fullName" name="fullName" class="form-control" 
                               placeholder="Nhập họ và tên" value="<%= fullName != null ? fullName : "" %>" required>
                    </div>
                </div>
                <div class="col-md-6">
                    <div class="mb-3">
                        <label for="email" class="form-label">Email</label>
                        <input type="email" id="email" name="email" class="form-control" 
                               placeholder="Nhập email" value="" required>
                    </div>
                </div>
                <div class="col-md-6">
                    <div class="mb-3">
                        <label for="phone" class="form-label">Số điện thoại</label>
                        <input type="text" id="phone" name="phone" class="form-control" 
                               placeholder="Nhập số điện thoại" value="<%= phone != null ? phone : "" %>" required>
                    </div>
                </div>
                <div class="col-md-6">
                    <div class="mb-3">
                        <label for="password" class="form-label">Mật khẩu</label>
                        <input type="password" id="password" name="password" class="form-control" 
                               placeholder="Nhập mật khẩu" value="<%= password != null ? password : "" %>" required>
                    </div>
                </div>
                <div class="col-12">
                    <div class="mb-3">
                        <label for="confirmPassword" class="form-label">Nhập lại mật khẩu</label>
                        <input type="password" id="confirmPassword" name="confirmPassword" class="form-control" 
                               placeholder="Nhập lại mật khẩu" value="<%= confirmPassword != null ? confirmPassword : "" %>" required>
                    </div>
                </div>
                <div class="col-12">
                    <button type="submit" class="btn-primary">Đăng ký</button>
                </div>
            </div>
        </form>
        <div class="login-link">
            Đã có tài khoản? <a href="login">Đăng nhập</a>
        </div>
        <% 
            // Clear session attributes after displaying to prevent persistent data
            session.removeAttribute("error");
            session.removeAttribute("fullName");
            session.removeAttribute("phone");
            session.removeAttribute("password");
            session.removeAttribute("confirmPassword");
        %>
    </div>
    <jsp:include page="../Message.jsp"/>
</body>
</html>