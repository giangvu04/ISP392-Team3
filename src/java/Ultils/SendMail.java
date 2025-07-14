
package Ultils;

import Controller.forgetPassword.*;
import APIKey.Gmail;
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
    // Gửi mail HTML bất đồng bộ (đa luồng)
    public static void sendHtmlMailAsync(String to, String subject, String htmlContent) {
        Thread thread = new Thread(() -> {
            try {
                sendHtmlMail(to, subject, htmlContent);
            } catch (Exception e) {
                e.printStackTrace();
            }
        });
        thread.start();
    }
   
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
        props.put("mail.smtp.host", Gmail.HOST_NAME);
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.port", Gmail.TSL_PORT);
        Session session = Session.getInstance(props, new jakarta.mail.Authenticator() {
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(Gmail.APP_EMAIL, Gmail.APP_PASSWORD);
            }
        });
        session.setDebug(true);
        try {
            MimeMessage message = new MimeMessage(session);
            message.setFrom(new InternetAddress(Gmail.APP_EMAIL));
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
        /**
     * Gửi mail mời tenant vào phòng với link xác nhận
     * @param email email người nhận
     * @param inviteLink link xác nhận (chứa token)
     * @param roomInfo thông tin phòng
     * @return true nếu gửi thành công
     */
    public static boolean sendInviteTenantMail(String email, String inviteLink, String roomInfo) {
        Thread thread = new Thread(() -> {
            try {
                String subject = "Lời mời tham gia phòng trọ";
                String content = "<html><body>"
                        + "<h2>Lời mời tham gia phòng trọ</h2>"
                        + "<p>Bạn nhận được lời mời tham gia phòng: <b>" + roomInfo + "</b></p>"
                        + "<p>Vui lòng nhấn vào liên kết dưới đây để xác nhận tham gia phòng:</p>"
                        + "<p><a href='" + inviteLink + "' style='color: #007bff; font-weight: bold;'>Xác nhận tham gia phòng</a></p>"
                        + "<p style='color: #888;'>Nếu bạn không thực hiện yêu cầu này, vui lòng bỏ qua email này.</p>"
                        + "<p style='color: #888;'>Đây là email tự động, vui lòng không trả lời.</p>"
                        + "</body></html>";
                sendHtmlMail(email, subject, content);
            } catch (Exception e) {
                e.printStackTrace();
            }
        });
        thread.start();
        return true;
    }
    private static String getCurrentDateTime() {
        SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss"); // hoặc "yyyy-MM-dd HH:mm:ss"
        return sdf.format(new Date());
    }

    /**
     * Gửi mail xác nhận cho người thuê khi đặt phòng thành công
     * @param email email người thuê
     * @param roomInfo thông tin phòng (tên phòng, địa chỉ...)
     * @param contractId mã hợp đồng
     * @return true nếu gửi thành công
     */
    public static boolean sendBookingConfirmationToTenant(String email, String roomInfo) {
        try {
            String subject = "Xác nhận đặt phòng thành công";
            String content = "<html><body>"
                    + "<h2>Đặt phòng thành công!</h2>"
                    + "<p>Bạn đã gửi yêu cầu thuê phòng: <b>" + roomInfo + "</b></p>"
                    + "<p>Hợp đồng của bạn đã được chuyển tới quản lí</p>"
                    + "<p>Quản lý sẽ liên hệ bạn để xác nhận hợp đồng trong thời gian sớm nhất.</p>"
                    + "<p style='color: #888;'>Đây là email tự động, vui lòng không trả lời.</p>"
                    + "</body></html>";
            return sendHtmlMail(email, subject, content);
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Gửi mail thông báo cho quản lý/khu trọ khi có hợp đồng mới
     * @param email email quản lý
     * @param tenantName tên người thuê
     * @param roomInfo thông tin phòng
     * @param contractId mã hợp đồng
     * @return true nếu gửi thành công
     */
    public static boolean sendNewContractToManager(String email, String tenantName, String roomInfo) {
        try {
            String subject = "Có hợp đồng mới cần xử lý";
            String content = "<html><body>"
                    + "<h2>Thông báo hợp đồng mới</h2>"
                    + "<p>Khách thuê <b>" + tenantName + "</b> vừa gửi yêu cầu thuê phòng: <b>" + roomInfo + "</b></p>"
                    + "<p>Vui lòng đăng nhập hệ thống để xác nhận và xử lý hợp đồng.</p>"
                    + "<p style='color: #888;'>Đây là email tự động, vui lòng không trả lời.</p>"
                    + "</body></html>";
            return sendHtmlMail(email, subject, content);
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    /**
     * Gửi mail xác nhận cho người thuê khi đặt phòng thành công (bất đồng bộ)
     */
    public static boolean sendBookingConfirmationToTenantAsync(String email, String roomInfo) {
        Thread thread = new Thread(() -> {
            try {
                sendBookingConfirmationToTenant(email, roomInfo);
            } catch (Exception e) {
                e.printStackTrace();
            }
        });
        thread.start();
        return true;
    }

    /**
     * Gửi mail thông báo cho quản lý/khu trọ khi có hợp đồng mới (bất đồng bộ)
     */
    public static boolean sendNewContractToManagerAsync(String email, String tenantName, String roomInfo) {
        Thread thread = new Thread(() -> {
            try {
                sendNewContractToManager(email, tenantName, roomInfo);
            } catch (Exception e) {
                e.printStackTrace();
            }
        });
        thread.start();
        return true;
    }

    /**
     * Gửi mail thông báo cho người thuê khi hợp đồng đã được duyệt (phòng đã được xác nhận)
     */
    public static boolean sendRoomApprovedToTenantAsync(String email, String roomInfo) {
        Thread thread = new Thread(() -> {
            try {
                String subject = "Phòng của bạn đã được duyệt!";
                String content = "<html><body>"
                        + "<h2>Chúc mừng!</h2>"
                        + "<p>Yêu cầu thuê phòng <b>" + roomInfo + "</b> của bạn đã được quản lý xác nhận.</p>"
                        + "<p>Bạn có thể liên hệ quản lý để hoàn tất thủ tục nhận phòng.</p>"
                        + "<p style='color: #888;'>Đây là email tự động, vui lòng không trả lời.</p>"
                        + "</body></html>";
                sendHtmlMail(email, subject, content);
            } catch (Exception e) {
                e.printStackTrace();
            }
        });
        thread.start();
        return true;
    }

    // Hàm gửi mail HTML chung
    public static boolean sendHtmlMail(String to, String subject, String htmlContent)
            throws UnsupportedEncodingException, AddressException, MessagingException {
        Properties props = new Properties();
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.host", Gmail.HOST_NAME);
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.port", Gmail.TSL_PORT);
        Session session = Session.getInstance(props, new jakarta.mail.Authenticator() {
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(Gmail.APP_EMAIL, Gmail.APP_PASSWORD);
            }
        });
        session.setDebug(true);
        try {
            MimeMessage message = new MimeMessage(session);
            message.setFrom(new InternetAddress(Gmail.APP_EMAIL));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(to));
            message.setSubject(MimeUtility.encodeText(subject, "UTF-8", "B"));
            MimeMultipart multipart = new MimeMultipart("alternative");
            MimeBodyPart htmlPart = new MimeBodyPart();
            htmlPart.setContent(htmlContent, "text/html; charset=UTF-8");
            multipart.addBodyPart(htmlPart);
            message.setContent(multipart);
            Transport.send(message);
            return true;
        } catch (MessagingException e) {
            e.printStackTrace();
            return false;
        }
    }

}
