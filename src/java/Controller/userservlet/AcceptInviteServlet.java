package Controller.userservlet;

import Ultils.InviteMailUtil;
import dal.DAOToken;
import dal.DAOUser;
import Ultils.SendMail;
import model.UserInviteToken;
import model.Users;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet(name = "AcceptInviteServlet", urlPatterns = {"/acceptInvite"})
public class AcceptInviteServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String tokenParam = request.getParameter("token");
        if (tokenParam == null || tokenParam.isEmpty()) {
            response.getWriter().write("Thiếu token!");
            return;
        }
        String[] arr = InviteMailUtil.parseInviteToken(tokenParam);
        if (arr == null) {
            response.getWriter().write("Token không hợp lệ!");
            return;
        }
        int userId = 0;
        int roomId = 0;
        String token = arr[2];
        try {
            userId = Integer.parseInt(arr[0]);
            roomId = Integer.parseInt(arr[1]);
        } catch (Exception e) {
            response.getWriter().write("Token không hợp lệ!");
            return;
        }
        // Kiểm tra token hợp lệ
        UserInviteToken inviteToken = DAOToken.INSTANCE.getValidToken(token);
        if (inviteToken == null || inviteToken.getRoomId() != roomId) {
            response.getWriter().write("Token đã hết hạn hoặc không hợp lệ!");
            return;
        }
        // Nếu userId > 0 thì cập nhật contract về trạng thái 1 (hoạt động)
        if (userId > 0) {
            // Tìm contract đang ở trạng thái 3 (lời mời) với userId, roomId
            boolean updated = DAOUser.INSTANCE.activateContract(userId, roomId);
            if (updated) {
                DAOToken.INSTANCE.markTokenUsed(token);
                request.getSession().setAttribute("ms","Xác nhận thành công! Hợp đồng đã được kích hoạt.");
                response.sendRedirect("login");
            } else {
                request.getSession().setAttribute("error","Không tìm thấy hợp đồng cần kích hoạt!");
                response.sendRedirect("login");
            }
        } else {
            response.getWriter().write("Bạn cần đăng ký tài khoản trước khi xác nhận lời mời!");
        }
    }
}
