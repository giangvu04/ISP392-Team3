<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Login Page</title>
        <style>
            body, html {
                margin: 0;
                padding: 0;
                height: 100%;
                font-family: Arial, sans-serif;
                background: linear-gradient(135deg, #6b48ff, #a856ff);
                display: flex;
                justify-content: center;
                align-items: center;
            }

            .container {
                height: 100vh;
                display: flex;
                justify-content: center;
                align-items: center;
            }

            .login-box {
                background: white;
                padding: 25px;
        border-radius: 15px;
                box-shadow: 0px 8px 16px rgba(0, 0, 0, 0.2);
                text-align: center;
                width: 350px;
                animation: bounceIn 1s ease-out;
            }

            @keyframes bounceIn {
                0% { transform: scale(0.5); opacity: 0; }
                60% { transform: scale(1.1); opacity: 1; }
                100% { transform: scale(1); }
            }

            .login-box h2 {
                color: #6b48ff;
                margin-bottom: 20px;
                font-size: 24px;
            }

            .logo-placeholder {
                width: 100px;
                height: 100px;
                background: #f0f0f0;
                margin: 0 auto 20px;
                border-radius: 50%;
                display: flex;
                align-items: center;
                justify-content: center;
                font-size: 18px;
                color: #666;
            }

            input[type="text"], input[type="password"] {
                width: 80%;
                padding: 12px;
                margin: 10px 0;
                border: 1px solid #ddd;
                border-radius: 8px;
                font-size: 14px;
                transition: border-color 0.3s ease;
            }

            input[type="text"]:focus, input[type="password"]:focus {
                border-color: #6b48ff;
                outline: none;
                animation: bounce 0.3s ease;
            }

            @keyframes bounce {
                0%, 100% { transform: translateY(0); }
                50% { transform: translateY(-5px); }
            }

            button {
                width: 90%;
                padding: 12px;
                background: linear-gradient(135deg, #6b48ff, #a856ff);
                border: none;
                color: white;
                font-size: 16px;
                border-radius: 8px;
                cursor: pointer;
                transition: transform 0.3s ease, background 0.3s ease;
            }

            button:hover {
                background: linear-gradient(135deg, #5a3de6, #934be6);
                transform: translateY(-2px);
            }

            .support {
                margin-top: 15px;
                font-size: 14px;
                color: #666;
            }

            .forget {
                margin-top: 10px;
            }

            .forget a, .support a {
                color: #6b48ff;
                text-decoration: none;
            }

            .forget a:hover, .support a:hover {
                text-decoration: underline;
            }

            .toast-message {
                position: fixed;
                top: 20px;
                right: 20px;
                background: #dc3545;
                color: white;
                padding: 10px 20px;
                border-radius: 5px;
                box-shadow: 0px 0px 10px rgba(0, 0, 0, 0.1);
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
            <%  String name = (String) request.getAttribute("name"); 
                String password = (String) request.getAttribute("password"); 
                if (name == null || password == null) {
                    name = "";
                    password = "";
                }
            %>
            <div class="login-box">
                <img src="Image/logoHome.png" alt="alt" style="width: 180px"/>
                <h2>Chào mừng bạn tới với DreamHouse</h2>
                <form action="login" method="post">
                    <input type="text" name="name" value="<%= name %>" placeholder="Địa chỉ email" required>
                    <input type="password" name="password" value="<%= password %>" placeholder="Mật khẩu" required>
                    <button type="submit">Tiếp tục</button>
                </form>
                <div class="support">
                    Hỗ trợ: <a href="tel:0388258116">0388258116</a>
                </div>
                <div class="forget">
                    <a href="forgetPassword">Quên mật khẩu</a>
                </div>
            </div>
            <% String message = (String) request.getAttribute("message"); %>
            <% if (message != null && !message.isEmpty()) { %>
            <div id="toast-message" class="toast-message"><%= message %></div>
            <% } %>
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
        </div>
    </body>
</html>
