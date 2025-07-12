/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Controller.forgetPassword;

import jakarta.mail.Message;
import jakarta.mail.MessagingException;
import jakarta.mail.PasswordAuthentication;
import jakarta.mail.Session;
import jakarta.mail.Transport;
import jakarta.mail.internet.AddressException;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeBodyPart;
import jakarta.mail.internet.MimeMessage;
import jakarta.mail.internet.MimeMultipart;
import jakarta.mail.internet.MimeUtility;
import java.io.UnsupportedEncodingException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.Locale;
import java.util.Properties;

public class SendMail {

    public static final String HOST_NAME = "smtp.gmail.com";

    public static final int TSL_PORT = 587;

    public static final String APP_EMAIL = "peguing6@gmail.com";

    public static final String APP_PASSWORD = "orxr enda bhsq cijf";

    public static boolean sendMailAsyncOTP(String email, String otp) {
        Thread thread = new Thread(() -> {
            try {
                SendMail.guiMailOTP(email, otp, getCurrentDateTime());
            } catch (Exception e) {
                e.printStackTrace();
            }
        });
        thread.start();

        return true;
    }

    public static boolean guiMailOTP(String email,  String otp, String createdDate)
            throws UnsupportedEncodingException, AddressException, MessagingException {
        Properties props = new Properties();
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.host", HOST_NAME);
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.port", TSL_PORT);
        Session session = Session.getInstance(props, new jakarta.mail.Authenticator() {
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(APP_EMAIL, APP_PASSWORD);
            }
        });
        session.setDebug(true);
        try {
            MimeMessage message = new MimeMessage(session);
            message.setFrom(new InternetAddress(APP_EMAIL));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(email));
            String subject = "Mã OTP xác thực tài khoản của bạn";

            String emailContent = "<!DOCTYPE html>"
                    + "<html lang=\"vi\">"
                    + "<head>"
                    + "  <meta charset=\"UTF-8\">"
                    + "  <style>"
                    + "    body { font-family: Arial, sans-serif; background: #f5f5f5; padding: 20px; }"
                    + "    .container { max-width: 500px; margin: auto; background: white; border-radius: 8px; padding: 30px; box-shadow: 0 0 10px rgba(0,0,0,0.1); }"
                    + "    h2 { color: #333; text-align: center; }"
                    + "    .otp-box { background: #f0f0f0; border-left: 5px solid #007bff; padding: 20px; font-size: 24px; text-align: center; font-weight: bold; letter-spacing: 6px; margin: 20px 0; }"
                    + "    p { font-size: 15px; color: #555; line-height: 1.6; }"
                    + "    .footer { font-size: 12px; color: #888; text-align: center; margin-top: 30px; }"
                    + "  </style>"
                    + "</head>"
                    + "<body>"
                    + "  <div class=\"container\">"
                    + "    <h2>Xác thực OTP</h2>"
                    + "    <p>Xin chào</p>"
                    + "    <p>Bạn hoặc ai đó đã yêu cầu xác thực tài khoản bằng email này.</p>"
                    + "    <p>Vui lòng sử dụng mã OTP sau để tiếp tục:</p>"
                    + "    <div class=\"otp-box\">" + otp + "</div>"
                    + "    <p>Mã OTP có hiệu lực trong <strong>03 phút</strong> kể từ: <strong>" + createdDate + "</strong>.</p>"
                    + "    <p style=\"color: #d9534f;\"><strong>Lưu ý:</strong> Không chia sẻ mã OTP với bất kỳ ai để bảo vệ tài khoản của bạn.</p>"
                    + "    <div class=\"footer\">Đây là email tự động. Vui lòng không trả lời email này.</div>"
                    + "  </div>"
                    + "</body>"
                    + "</html>";

            // Đặt tiêu đề với UTF-8
            message.setSubject(MimeUtility.encodeText(subject, "UTF-8", "B"));
            // Tạo MimeMultipart với subtype "alternative"
            MimeMultipart multipart = new MimeMultipart("alternative");
            // Tạo phần nội dung HTML
            MimeBodyPart htmlPart = new MimeBodyPart();
            htmlPart.setContent(emailContent, "text/html; charset=UTF-8");
            multipart.addBodyPart(htmlPart);
            // Gán multipart vào message
            message.setContent(multipart);
            // Gửi email
            Transport.send(message);
            System.out.println("Mail đã được gửi thành công tại: " + System.currentTimeMillis());
            return true;
        } catch (MessagingException e) {
            e.printStackTrace();
            return false;
        }
    }
    private static String getCurrentDateTime() {
        SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss"); // hoặc "yyyy-MM-dd HH:mm:ss"
        return sdf.format(new Date());
    }

}
