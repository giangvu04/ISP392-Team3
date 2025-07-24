<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <body>

        <script>
            // Configs
            let liveChatBaseUrl = document.location.protocol + '//' + 'livechat.fpt.ai/v36/src'
            let LiveChatSocketUrl = 'livechat.fpt.ai:443'
            let FptAppCode = 'e006dce062785608c41f7f926571c049'
            let FptAppName = 'Dream House'
            // Define custom styles
            let CustomStyles = {
                // header
                headerBackground: 'linear-gradient(86.7deg, #3353a2ff 0.85%, #31b7b7ff 98.94%)',
                headerTextColor: '#ffffffff',
                headerLogoEnable: false,
                headerLogoLink: 'https://chatbot-tools.fpt.ai/livechat-builder/img/Icon-fpt-ai.png',
                headerText: 'Dream House',
                // main
                primaryColor: '#6d9ccbff',
                secondaryColor: '#ecececff',
                primaryTextColor: '#ffffffff',
                secondaryTextColor: '#000000DE',
                buttonColor: '#b4b4b4ff',
                buttonTextColor: '#ffffffff',
                bodyBackgroundEnable: false,
                bodyBackgroundLink: '',
                avatarBot: 'https://res.cloudinary.com/dcdwqd5up/image/upload/v1752891501/1752891499013_image-removebg-preview.png',
                sendMessagePlaceholder: 'Nhập tin nhắn vào đây',
                // float button
                floatButtonLogo: 'https://res.cloudinary.com/dcdwqd5up/image/upload/v1752891501/1752891499013_image-removebg-preview.png',
                floatButtonTooltip: 'Tôi có thể giúp gì cho bạn',
                floatButtonTooltipEnable: true,
                // start screen
                customerLogo: 'https://res.cloudinary.com/dcdwqd5up/image/upload/v1752891501/1752891499013_image-removebg-preview.png',
                customerWelcomeText: 'Vui lòng nhập tên của bạn',
                customerButtonText: 'Bắt đầu',
                prefixEnable: false,
                prefixType: 'radio',
                prefixOptions: ["Anh", "Chị"],
                prefixPlaceholder: 'Danh xưng',
                // custom css
                css: ''
            }
            // Get bot code from url if FptAppCode is empty
            if (!FptAppCode) {
                let appCodeFromHash = window.location.hash.substr(1)
                if (appCodeFromHash.length === 32) {
                    FptAppCode = appCodeFromHash
                }
            }
            // Set Configs
            let FptLiveChatConfigs = {
                appName: FptAppName,
                appCode: FptAppCode,
                themes: '',
                styles: CustomStyles
            }
            // Append Script
            let FptLiveChatScript = document.createElement('script')
            FptLiveChatScript.id = 'fpt_ai_livechat_script'
            FptLiveChatScript.src = liveChatBaseUrl + '/static/fptai-livechat.js'
            document.body.appendChild(FptLiveChatScript)
            // Append Stylesheet
            let FptLiveChatStyles = document.createElement('link')
            FptLiveChatStyles.id = 'fpt_ai_livechat_script'
            FptLiveChatStyles.rel = 'stylesheet'
            FptLiveChatStyles.href = liveChatBaseUrl + '/static/fptai-livechat.css'
            document.body.appendChild(FptLiveChatStyles)
            // Init
            FptLiveChatScript.onload = function () {
                fpt_ai_render_chatbox(FptLiveChatConfigs, liveChatBaseUrl, LiveChatSocketUrl)
            }
        </script>

    </body>
</html>
