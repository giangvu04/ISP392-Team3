package Controller.booking;

import Const.ContractStatus;
import Ultils.SendMail;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import model.Users;

@WebServlet(name="Booking", urlPatterns={"/booking"})
public class Booking extends HttpServlet {
   

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        // Lấy dữ liệu từ form modal
        String fromDateStr = request.getParameter("fromDate");
        String toDateStr = request.getParameter("toDate");
        String note = request.getParameter("note");
        String roomIdStr = request.getParameter("roomId");
        String roomNumber = request.getParameter("roomNumber");
        String area = request.getParameter("areaName");
        String emailManager = request.getParameter("managerEmail");
        // Lấy user từ session (giả sử đã đăng nhập)
        Users user = (Users) request.getSession().getAttribute("user");
        Integer tenantId = user.getUserId();

        if (fromDateStr == null || roomIdStr == null || tenantId == null) {
            request.getSession().setAttribute("error", "Vui lòng nhập đủ thông tin");
            response.sendRedirect("roomDetails?id="+roomIdStr);
            return;
        }

        java.sql.Date fromDate = java.sql.Date.valueOf(fromDateStr);
        java.sql.Date toDate = null;
        if (toDateStr != null && !toDateStr.isEmpty()) {
            toDate = java.sql.Date.valueOf(toDateStr);
        }

        int roomId = Integer.parseInt(roomIdStr);

        // Kiểm tra phòng đã có hợp đồng active chưa
        if (dal.DAOContract.INSTANCE.hasActiveContract(roomId)) {
            request.getSession().setAttribute("error", "Phòng đã được thuê");
            response.sendRedirect("roomDetails?id="+roomIdStr);
            return;
        }

        // Lấy giá phòng từ DB
        java.math.BigDecimal rentPrice = java.math.BigDecimal.ZERO;
        java.math.BigDecimal depositAmount = java.math.BigDecimal.ZERO;
        try {
            dal.DAORooms daoRooms = new dal.DAORooms();
            model.Rooms room = daoRooms.getRoomById(roomId);
            if (room != null) {
                rentPrice = room.getPrice();
                depositAmount = rentPrice; // Tiền cọc mặc định = 1 tháng tiền phòng
            }
        } catch (Exception ex) {
            request.getSession().setAttribute("error", "Giá tiền phòng không đúng");
            response.sendRedirect("roomDetails?id="+roomIdStr);
            return;
        }

        int status = ContractStatus.CHO_DUYET; // 1 = active 0=inactive

        // Tạo đối tượng Contracts
        model.Contracts contract = new model.Contracts();
        contract.setRoomID(roomId);
        contract.setTenantsID(tenantId);
        contract.setStartDate(fromDate);
        contract.setEndDate(toDate);
        contract.setRentPrice(rentPrice);
        contract.setDepositAmount(depositAmount);
        contract.setStatus(status);
        contract.setNote(note);

        // Thêm hợp đồng vào DB
        int contractId = dal.DAOContract.INSTANCE.addContract(contract);

        if (contractId > 0) {
            String roomIdStrr = roomNumber + " - " + area;
            // Thành công, chuyển về trang chi tiết phòng với thông báo
            SendMail.sendBookingConfirmationToTenantAsync(user.getEmail(), roomIdStrr);
            SendMail.sendNewContractToManagerAsync(emailManager,user.getFullName(), roomIdStrr);
            request.getSession().setAttribute("ms", "Yêu cầu của bạn đã được gửi về quản lí");
            response.sendRedirect("listrooms");
        } else {
            // Thất bại
            request.getSession().setAttribute("error", "Đặt phòng thất bại vui lòng thử lại!");
            response.sendRedirect("roomDetails?id="+roomIdStr);
        }
    }

    @Override
    public String getServletInfo() {
        return "Short description";
    }

}
