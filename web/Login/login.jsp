<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Login Page</title>
        <style>
            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
            }

            body, html {
                height: 100%;
                font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', 'Roboto', sans-serif;
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                display: flex;
                justify-content: center;
                align-items: center;
                min-height: 100vh;
            }

            .container {
                display: flex;
                justify-content: center;
                align-items: center;
                min-height: 100vh;
                padding: 20px;
            }

            .login-box {
                background: rgba(255, 255, 255, 0.95);
                backdrop-filter: blur(10px);
                border-radius: 16px;
                box-shadow: 0 20px 40px rgba(0, 0, 0, 0.1);
                width: 100%;
                max-width: 900px;
                min-height: 500px;
                animation: slideUp 0.8s ease-out;
                position: relative;
                overflow: hidden;
                display: flex;
            }

            .login-box::before {
                content: '';
                position: absolute;
                top: 0;
                left: 0;
                right: 0;
                height: 4px;
                background: linear-gradient(90deg, #667eea, #764ba2);
            }

            @keyframes slideUp {
                0% { 
                    transform: translateY(30px); 
                    opacity: 0; 
                }
                100% { 
                    transform: translateY(0); 
                    opacity: 1; 
                }
            }

            .left-section {
                flex: 1;
                padding: 50px;
                display: flex;
                flex-direction: column;
                justify-content: center;
                border-right: 1px solid #e2e8f0;
            }

            .right-section {
                flex: 1;
                padding: 50px;
                display: flex;
                flex-direction: column;
                justify-content: center;
                align-items: center;
                background: linear-gradient(135deg, #f8fafc 0%, #e2e8f0 100%);
                text-align: center;
            }

            .logo-container {
                text-align: center;
            }

            .logo-container img {
                width: 150px;
                height: auto;
            }

            .login-title {
                color: #2d3748;
                margin-bottom: 8px;
                font-size: 28px;
                font-weight: 700;
                text-align: center;
            }

            .login-subtitle {
                color: #718096;
                font-size: 16px;
                margin-bottom: 32px;
                text-align: center;
            }

            .form-group {
                margin-bottom: 20px;
            }

            .form-group label {
                display: block;
                margin-bottom: 8px;
                color: #4a5568;
                font-weight: 500;
                font-size: 14px;
            }

            input[type="text"], input[type="password"] {
                width: 100%;
                padding: 16px;
                border: 2px solid #e2e8f0;
                border-radius: 12px;
                font-size: 16px;
                transition: all 0.3s ease;
                background: #f7fafc;
            }

            input[type="text"]:focus, input[type="password"]:focus {
                border-color: #667eea;
                outline: none;
                background: white;
                box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
                transform: translateY(-2px);
            }

            .btn-primary {
                width: 100%;
                padding: 16px;
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                border: none;
                color: white;
                font-size: 16px;
                font-weight: 600;
                border-radius: 12px;
                cursor: pointer;
                transition: all 0.3s ease;
                margin-top: 20px;
            }

            .btn-primary:hover {
                transform: translateY(-2px);
                box-shadow: 0 10px 20px rgba(102, 126, 234, 0.3);
            }

            .btn-primary:active {
                transform: translateY(0);
            }

            .forget-password {
                text-align: center;
                margin-top: 20px;
            }

            .forget-password a {
                color: #667eea;
                text-decoration: none;
                font-size: 14px;
                font-weight: 500;
            }

            .forget-password a:hover {
                color: #764ba2;
                text-decoration: underline;
            }

            .right-section h3 {
                color: #2d3748;
                font-size: 24px;
                font-weight: 700;
                margin-bottom: 24px;
            }

            .alternative-login {
                width: 100%;
                max-width: 300px;
            }

            .btn-google {
                width: 100%;
                padding: 16px;
                background: white;
                border: 2px solid #e2e8f0;
                color: #2d3748;
                font-size: 16px;
                font-weight: 500;
                border-radius: 12px;
                cursor: pointer;
                transition: all 0.3s ease;
                display: flex;
                align-items: center;
                justify-content: center;
                gap: 12px;
                margin-bottom: 20px;
            }

            .btn-google:hover {
                border-color: #cbd5e0;
                transform: translateY(-2px);
                box-shadow: 0 8px 16px rgba(0, 0, 0, 0.1);
            }

            .google-icon {
                width: 20px;
                height: 20px;
            }

            .divider {
                display: flex;
                align-items: center;
                margin: 24px 0;
                color: #a0aec0;
                font-size: 14px;
                width: 100%;
            }

            .divider::before,
            .divider::after {
                content: '';
                flex: 1;
                height: 1px;
                background: #cbd5e0;
            }

            .divider span {
                padding: 0 16px;
                background: transparent;
            }

            .register-section {
                width: 100%;
                max-width: 300px;
            }

            .btn-register {
                width: 100%;
                padding: 16px;
                background: linear-gradient(135deg, #48bb78 0%, #38a169 100%);
                border: none;
                color: white;
                font-size: 16px;
                font-weight: 600;
                border-radius: 12px;
                cursor: pointer;
                transition: all 0.3s ease;
                margin-bottom: 12px;
            }

            .btn-register:hover {
                transform: translateY(-2px);
                box-shadow: 0 10px 20px rgba(72, 187, 120, 0.3);
            }

            .btn-seller {
                width: 100%;
                padding: 16px;
                background: linear-gradient(135deg, #ed8936 0%, #dd6b20 100%);
                border: none;
                color: white;
                font-size: 16px;
                font-weight: 600;
                border-radius: 12px;
                cursor: pointer;
                transition: all 0.3s ease;
                position: relative;
                overflow: hidden;
            }

            .btn-seller:hover {
                transform: translateY(-2px);
                box-shadow: 0 10px 20px rgba(237, 137, 54, 0.3);
            }

            .btn-seller::before {
                content: '🏪';
                margin-right: 8px;
            }

            .support-info {
                margin-top: 30px;
                font-size: 14px;
                color: #718096;
            }

            .support-info a {
                color: #667eea;
                text-decoration: none;
                font-weight: 500;
            }

            .support-info a:hover {
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
                .login-box {
                    flex-direction: column;
                    max-width: 420px;
                    min-height: auto;
                }
                
                .left-section {
                    border-right: none;
                    border-bottom: 1px solid #e2e8f0;
                    padding: 40px 30px;
                }
                
                .right-section {
                    padding: 40px 30px;
                    background: white;
                }
                
                .login-title {
                    font-size: 24px;
                }
            }

            @media (max-width: 480px) {
                .container {
                    padding: 10px;
                }
                
                .left-section,
                .right-section {
                    padding: 30px 20px;
                }
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
                <!-- Left Section - Login Form -->
                <div class="left-section">
                    <div class="logo-container">
                        <img src="Image/logoHome.png" alt="DreamHouse Logo"/>
                    </div>
                    
                    <h2 class="login-title">Đăng nhập</h2>
                    <p class="login-subtitle">Chào mừng bạn trở lại DreamHouse</p>
                    
                    <form action="login" method="post">
                        <div class="form-group">
                            <label for="email">Địa chỉ email</label>
                            <input type="text" id="email" name="name" value="<%= name %>" placeholder="Nhập email của bạn" required>
                        </div>
                        
                        <div class="form-group">
                            <label for="password">Mật khẩu</label>
                            <input type="password" id="password" name="password" value="<%= password %>" placeholder="Nhập mật khẩu" required>
                        </div>
                        
                        <button type="submit" class="btn-primary">Đăng nhập</button>
                    </form>
                    
                    <div class="forget-password">
                        <a href="forgetPassword">Quên mật khẩu?</a>
                    </div>
                </div>
                
                <!-- Right Section - Alternative Options -->
                <div class="right-section">
                    <h3>Đăng nhập nhanh</h3>
                    
                    <div class="alternative-login">
                        <button type="button" class="btn-google" onclick="loginWithGoogle()">
                            <svg class="google-icon" viewBox="0 0 24 24">
                                <path fill="#4285F4" d="M22.56 12.25c0-.78-.07-1.53-.2-2.25H12v4.26h5.92c-.26 1.37-1.04 2.53-2.21 3.31v2.77h3.57c2.08-1.92 3.28-4.74 3.28-8.09z"/>
                                <path fill="#34A853" d="M12 23c2.97 0 5.46-.98 7.28-2.66l-3.57-2.77c-.98.66-2.23 1.06-3.71 1.06-2.86 0-5.29-1.93-6.16-4.53H2.18v2.84C3.99 20.53 7.7 23 12 23z"/>
                                <path fill="#FBBC05" d="M5.84 14.09c-.22-.66-.35-1.36-.35-2.09s.13-1.43.35-2.09V7.07H2.18C1.43 8.55 1 10.22 1 12s.43 3.45 1.18 4.93l2.85-2.22.81-.62z"/>
                                <path fill="#EA4335" d="M12 5.38c1.62 0 3.06.56 4.21 1.64l3.15-3.15C17.45 2.09 14.97 1 12 1 7.7 1 3.99 3.47 2.18 7.07l3.66 2.84c.87-2.6 3.3-4.53 6.16-4.53z"/>
                            </svg>
                            Đăng nhập với Google
                        </button>
                    </div>
                    
                    <div class="divider">
                        <span>hoặc</span>
                    </div>
                    
                    <div class="register-section">
                        <button type="button" class="btn-register" onclick="redirectToRegister()">
                            Đăng ký tài khoản mới
                        </button>
                        
                        <button type="button" class="btn-seller" onclick="redirectToSellerRegister()">
                            Đăng ký làm người bán
                        </button>
                        <button style="margin-top: 20px; width: 300px; height: 50px;
                                border-radius: 10px; background-color: white
                                ; border: none; font-size: 18px" type="button" class="btn-homepage" onclick="redirectToHomePage()">
                            Quay lại trang chủ
                        </button>
                    </div>
                    
                    <div class="support-info">
                        Cần hỗ trợ? <a href="tel:0388258116">0388258116</a>
                    </div>
                </div>
            </div>
            
                        <script>
               
                
                function loginWithGoogle() {
                    
                    window.location.href = "redirect_google";
                                  
                }
                
                function redirectToRegister() {
                    window.location.href = "registerr";
                }
                
                function redirectToSellerRegister() {
                    window.location.href = "registerManager";
                }
                function redirectToHomePage() {
                    window.location.href = "trangchu";
                }
                
                // Add some interactive effects
                document.querySelectorAll('input').forEach(input => {
                    input.addEventListener('focus', function() {
                        this.parentElement.style.transform = 'translateY(-2px)';
                    });
                    
                    input.addEventListener('blur', function() {
                        this.parentElement.style.transform = 'translateY(0)';
                    });
                });
            </script>
            <jsp:include page="../Message.jsp"/>
        </div>
    </body>
</html>