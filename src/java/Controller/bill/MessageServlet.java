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
        System.out.println("billId: " + billId);
        System.out.println("tenantEmail: " + tenantEmail);
        System.out.println("content: " + content);
        String subject = "Thông báo hóa đơn từ quản lý";
        String htmlContent = "<html><body>" +
                "<h3>Thông báo hóa đơn</h3>" +
                "<p>" + content + "</p>" +
                "<p style='color: #888;'>Đây là email tự động, vui lòng không trả lời.</p>" +
                "</body></html>";
        // Lưu message vào DB
        try {
            // Gửi mail
            Ultils.SendMail.sendHtmlMailAsync(tenantEmail, subject, htmlContent);
            // Lưu vào bảng messages
            dal.DBContext dbContext = new dal.DBContext();
            java.sql.Connection conn = dbContext.getConnection();
            String insertSql = "INSERT INTO messages (user_id, bill_id, type, content, created_at) VALUES (?, ?, ?, ?, GETDATE())";
            try (java.sql.PreparedStatement ps = conn.prepareStatement(insertSql)) {
                ps.setInt(1, user.getUserId());
                ps.setInt(2, Integer.parseInt(billId));
                ps.setString(3, "bill");
                ps.setString(4, content);
                ps.executeUpdate();
            }
            request.getSession().setAttribute("ms", "Đã gửi lời nhắc thành công!");
            response.sendRedirect("listbills");
        } catch (Exception e) {
            request.getSession().setAttribute("error", "Gửi lời nhắc không thành công!");
            response.sendRedirect("listbills");
            e.printStackTrace();
        }
    }
}