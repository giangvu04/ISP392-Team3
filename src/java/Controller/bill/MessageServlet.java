package Controller.bill;

import dal.DAOBill;
import model.Users;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import javax.mail.*;
import javax.mail.internet.*;
import java.util.Properties;

@WebServlet(name = "MessageServlet", urlPatterns = {"/sendMessage"})
public class MessageServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Users user = (Users) request.getSession().getAttribute("user");
        if (user == null || user.getRoleId() != 2) {
            response.setStatus(HttpServletResponse.SC_FORBIDDEN);
            response.getWriter().write("Bạn không có quyền gửi tin nhắn!");
            return;
        }
        String billId = request.getParameter("billId");
        String tenantEmail = request.getParameter("tenantEmail");
        String content = request.getParameter("content");
        String subject = "Thông báo hóa đơn từ quản lý";
        String htmlContent = "<html><body>" +
                "<h3>Thông báo hóa đơn</h3>" +
                "<p>" + content + "</p>" +
                "<p style='color: #888;'>Đây là email tự động, vui lòng không trả lời.</p>" +
                "</body></html>";
        try {
            boolean sent = Ultils.SendMail.sendHtmlMail(tenantEmail, subject, htmlContent);
            if (sent) {
                response.setStatus(HttpServletResponse.SC_OK);
                response.getWriter().write("Gửi tin nhắn thành công!");
            } else {
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                response.getWriter().write("Lỗi khi gửi email!");
            }
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("Lỗi khi gửi email!");
        }
    }
}
