package Controller.contractservlet;

import dal.DAOContract;
import java.io.IOException;
import java.math.BigDecimal;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name = "UpdateContractServlet", urlPatterns = {"/updateContract"})
public class UpdateContractServlet extends HttpServlet {   
    @Override   
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int contractId = Integer.parseInt(request.getParameter("contractId"));
            int status = Integer.parseInt(request.getParameter("status"));
            BigDecimal depositAmount = new BigDecimal(request.getParameter("depositAmount"));
            
            boolean success = DAOContract.INSTANCE.updateContractStatusAndDeposit(contractId, status, depositAmount);
            if (success) {
                // Nếu trạng thái chuyển sang Đang hiệu lực (1), cập nhật luôn trạng thái phòng sang Occupied (1)
                if (status == 1) {
                    // Lấy contract để lấy roomId
                    model.Contracts contract = DAOContract.INSTANCE.getContractById(contractId);
                    if (contract != null) {
                        dal.DAORooms.INSTANCE.updateRoomStatus(contract.getRoomID(), 1);
                        // Gửi mail cho tenant báo phòng đã được duyệt (nếu cần)
                        // Lấy email tenant ở đây nếu có
                        String[] result = DAOContract.INSTANCE.getDataRoomFromContractID(contractId);
                        // Ví dụ: String email = ...;
                        Ultils.SendMail.sendRoomApprovedToTenantAsync(result[2], result[0] + result[1]);
                    }
                }
                request.getSession().setAttribute("ms", "Cập nhật hợp đồng thành công!");
            } else {
                request.getSession().setAttribute("error", "Cập nhật hợp đồng thất bại!");
            }
        } catch (Exception e) {
            request.getSession().setAttribute("error", "Lỗi: " + e.getMessage());
        }
        // Quay lại trang chi tiết phòng (có thể truyền lại roomId nếu cần)
        String referer = request.getHeader("referer");
        if (referer != null) {
            response.sendRedirect(referer);
        } else {
            response.sendRedirect("listrooms");
        }
    }
}
