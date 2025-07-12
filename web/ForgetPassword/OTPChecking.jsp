<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
    String error = (String) request.getAttribute("error");
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Đăng Nhập - Nhập OTP</title>
    <link rel="stylesheet" href="css/forgetPassword.css">
</head>
<body>
    <div class="container">
        <!-- Progress Bar -->
        <div class="progress-bar">
            <div class="progress-fill" style="width: 100%"></div>
        </div>

        <!-- Page 3: Nhập OTP -->
        <form id="otpForm" action="otpchecking" method="post">
            <div class="page active">
                <div class="header">
                    <h1 class="title">Nhập mã xác thực</h1>
                    <p class="subtitle" id="otpSubtitle">Mã đã được gửi tới email của bạn</p>
                </div>

                <div class="otp-container">
                    <div class="otp-inputs">
                        <input type="text" class="otp-input" maxlength="1" data-index="0">
                        <input type="text" class="otp-input" maxlength="1" data-index="1">
                        <input type="text" class="otp-input" maxlength="1" data-index="2">
                        <input type="text" class="otp-input" maxlength="1" data-index="3">
                        <input type="text" class="otp-input" maxlength="1" data-index="4">
                        <input type="text" class="otp-input" maxlength="1" data-index="5">
                    </div>

                    <div class="timer" id="timer">
                        Mã có hiệu lực <span id="countdown">5:00</span>
                    </div>

                    <% if (error != null && !error.trim().isEmpty()) { %>
                        <span id="errorBox" style="background-color: rgba(255, 0, 0, 0.1); color: red; padding: 4px 8px; border-radius: 4px; font-size: 14px; display: inline-block; margin-top: 8px;">
                            ⚠ <%= error %>
                        </span>
                    <% } %>
                </div>

                <!-- Hidden field chứa mã OTP gộp -->
                <input type="hidden" name="otpValue" id="otpValue">

                <div class="button-group">
                    <button type="submit" class="btn" id="verifyBtn">Xác thực</button>
                    <button type="button" class="btn btn-back" onclick="goBack()">Quay lại</button>
                </div>

                <div class="resend-section">
                    <p>Không nhận được mã?</p>
                    <a href="resendOTP" id="resendLink">Gửi lại mã xác thực</a>
                </div>
            </div>
        </form>
    </div>

    <script>
        document.addEventListener("DOMContentLoaded", function () {
            const otpInputs = document.querySelectorAll(".otp-input");
            const verifyBtn = document.getElementById("verifyBtn");
            const otpForm = document.getElementById("otpForm");
            const otpValue = document.getElementById("otpValue");
            const resendLink = document.getElementById("resendLink");
            const countdown = document.getElementById("countdown");
            const messageBox = document.getElementById("errorBox");

            // Ẩn thông báo sau 5 giây hoặc khi nhập OTP
            function hideMessages() {
                if (messageBox) messageBox.style.display = "none";
            }
            if (messageBox) {
                setTimeout(hideMessages, 5000);
                otpInputs.forEach(input => input.addEventListener("input", hideMessages));
            }

            // Di chuyển con trỏ giữa các ô OTP
            otpInputs.forEach((input, index) => {
                input.addEventListener("input", (e) => {
                    if (e.target.value.length === 1 && index < otpInputs.length - 1) {
                        otpInputs[index + 1].focus();
                    }
                    if (e.target.value.length === 0 && index > 0) {
                        otpInputs[index - 1].focus();
                    }
                });
            });

            // Gộp OTP trước khi submit
            otpForm.addEventListener("submit", (e) => {
                let otp = "";
                otpInputs.forEach(input => otp += input.value.trim());
                if (otp.length !== 6) {
                    e.preventDefault();
                    alert("Vui lòng nhập đủ 6 chữ số OTP!");
                } else {
                    otpValue.value = otp;
                }
            });

            // Đếm ngược 5 phút
            let timeLeft = 5 * 60;
            function startCountdown() {
                const timer = setInterval(() => {
                    let minutes = Math.floor(timeLeft / 60);
                    let seconds = timeLeft % 60;
                    countdown.textContent = `${minutes}:${seconds < 10 ? "0" : ""}${seconds}`;
                    timeLeft--;
                    if (timeLeft < 0) {
                        clearInterval(timer);
                        countdown.textContent = "Hết hạn";
                        resendLink.style.display = "inline";
                    }
                }, 1000);
            }
            startCountdown();

            // Gửi lại OTP
            resendLink.addEventListener("click", (e) => {
                e.preventDefault();
                window.location.href = "resendOTP";
            });

            function goBack() {
                window.location.href = "verificationMethod";
            }
        });
    </script>
</body>
</html>
