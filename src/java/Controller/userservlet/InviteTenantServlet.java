package Controller.userservlet;

import Ultils.InviteMailUtil;
import dal.DAOToken;
import dal.DAOUser;
import Ultils.SendMail;
import model.Users;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.BufferedReader;
import java.io.IOException;
import org.json.JSONObject;

@WebServlet(name = "InviteTenantServlet", urlPatterns = {"/inviteTenant"})
public class InviteTenantServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json;charset=UTF-8");
        StringBuilder sb = new StringBuilder();
        String line;
        try (BufferedReader reader = request.getReader()) {
            while ((line = reader.readLine()) != null) {
                sb.append(line);
            }
        }
        JSONObject json = new JSONObject(sb.toString());
        String email = json.optString("email");
        int roomId = json.optInt("roomId");
        int userId = json.has("userId") ? json.optInt("userId") : 0;
        // Lấy thông tin phòng (giá, hạn, deposit, maxTenant, số tenant hiện tại)
        dal.DAORooms daoRoom = new dal.DAORooms();
        model.Rooms room = daoRoom.getRoomById(roomId);
        if (room == null) {
            request.getSession().setAttribute("error", "Không tìm thấy thông tin phòng!");
            response.sendRedirect("listrooms");
            return;
        }
        int currentTenants = daoRoom.countActiveTenants(roomId);
        boolean isAjax = "XMLHttpRequest".equals(request.getHeader("X-Requested-With"));
        if (currentTenants >= room.getMaxTenants()) {
            if (isAjax) {
                response.setContentType("application/json;charset=UTF-8");
                response.getWriter().write("{\"success\":false,\"message\":\"Phòng đã đủ số lượng người thuê tối đa!\"}");
            } else {
                request.getSession().setAttribute("error", "Phòng đã đủ số lượng người thuê tối đa!");
                response.sendRedirect("listrooms");
            }
            return;
        }
        String roomInfo = "Phòng " + room.getRoomNumber() + " - " + room.getRentalAreaName();

        // Lấy thông tin hợp đồng active gần nhất của phòng (nếu có)
        dal.DAOContract daoContract = dal.DAOContract.INSTANCE;
        model.Contracts latestContract = daoContract.getLatestActiveContractByRoom(roomId);
        java.math.BigDecimal deposit = null;
        java.math.BigDecimal price = null;
        java.sql.Date startDate = new java.sql.Date(System.currentTimeMillis());
        java.sql.Date endDate = daoRoom.getDefaultContractEndDate();
        if (latestContract != null) {
            deposit = latestContract.getDepositAmount();
            price = latestContract.getRentPrice();
            if (latestContract.getStartDate() != null) startDate = latestContract.getStartDate();
            if (latestContract.getEndDate() != null) endDate = latestContract.getEndDate();
        }
        if (deposit == null || deposit.compareTo(java.math.BigDecimal.ZERO) == 0) {
            deposit = room.getPrice() != null ? room.getPrice() : java.math.BigDecimal.ZERO;
        }
        if (price == null || price.compareTo(java.math.BigDecimal.ZERO) == 0) {
            price = room.getPrice() != null ? room.getPrice() : java.math.BigDecimal.ZERO;
        }

        // isAjax đã được khai báo phía trên

        boolean contractCreated = DAOUser.INSTANCE.createInviteContract(
            userId > 0 ? userId : null,
            email,
            roomId,
            price,
            deposit,
            endDate
        );
        if (!contractCreated) {
            request.getSession().setAttribute("error", "Không thể tạo hợp đồng lời mời!");
            response.sendRedirect("listrooms");
            return;
        }
        // Tạo token
        String token = DAOToken.INSTANCE.createInviteToken(userId > 0 ? userId : null, email, roomId);
        if (token == null) {
            request.getSession().setAttribute("error", "Đã có lỗi xảy ra vui lòng thử lại sau !");
            response.sendRedirect("listrooms");
            return;
        }
        // Tạo link xác nhận
        String baseUrl = request.getRequestURL().toString().replace("/inviteTenant", "/acceptInvite");
        String inviteLink = InviteMailUtil.buildInviteLink(baseUrl, userId > 0 ? userId : null, roomId, token);
        // Gửi mail
        boolean sent = SendMail.sendInviteTenantMail(email, inviteLink, roomInfo);
        if (isAjax) {
            response.setContentType("application/json;charset=UTF-8");
            if (sent) {
                response.getWriter().write("{\"success\":true,\"message\":\"Đã gửi lời mời tới email: " + email + "\"}");
            } else {
                response.getWriter().write("{\"success\":false,\"message\":\"Gửi lời mời thất bại!\"}");
            }
        } else {
            if (sent) {
                request.getSession().setAttribute("ms", "Đã gửi lời mời tới email: " + email);
            } else {
                request.getSession().setAttribute("error", "Gửi lời mời thất bại!");
            }
            response.sendRedirect("listrooms");
        }
    }
}
