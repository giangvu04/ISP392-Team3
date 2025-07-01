/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package Controller.contractservlet;

import dal.DAOContract;
import java.io.IOException;
import java.math.BigDecimal;
import java.sql.Date;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Contracts;


/**
 *
 * @author ADMIN
 */

public class AddContractsList extends HttpServlet {
   
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Forward to the add contract JSP
        request.getRequestDispatcher("Contract/AddListContracts.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        
        // Get all parameters from the request
        String contractIdStr = request.getParameter("contractId");
        String roomIdStr = request.getParameter("roomId");
        String tenantIdStr = request.getParameter("tenantId");
        String startDateStr = request.getParameter("startDate");
        String endDateStr = request.getParameter("endDate");
        String rentPriceStr = request.getParameter("rentPrice");
        String depositAmountStr = request.getParameter("depositAmount");
        String statusStr = request.getParameter("status");
        String note = request.getParameter("note");

        // Clear previous errors
        clearFormErrors(request);
        
        try {
            // Validate required fields
            if (roomIdStr == null || roomIdStr.trim().isEmpty()) {
                request.setAttribute("roomIdError", "Room ID là bắt buộc");
            }
            if (tenantIdStr == null || tenantIdStr.trim().isEmpty()) {
                request.setAttribute("tenantIdError", "Tenant ID là bắt buộc");
            }
            if (startDateStr == null || startDateStr.trim().isEmpty()) {
                request.setAttribute("startDateError", "Start Date là bắt buộc");
            }
            if (rentPriceStr == null || rentPriceStr.trim().isEmpty()) {
                request.setAttribute("rentPriceError", "Rent Price là bắt buộc");
            }

            // Parse and validate parameters
            Integer contractId = null;
            if (contractIdStr != null && !contractIdStr.trim().isEmpty()) {
                try {
                    contractId = Integer.parseInt(contractIdStr.trim());
                    if (contractId <= 0) {
                        request.setAttribute("contractIdError", "Contract ID phải là số dương");
                    }
                } catch (NumberFormatException e) {
                    request.setAttribute("contractIdError", "Contract ID phải là số nguyên hợp lệ");
                }
            }

            int roomId = 0;
            if (roomIdStr != null && !roomIdStr.trim().isEmpty()) {
                try {
                    roomId = Integer.parseInt(roomIdStr.trim());
                    if (roomId <= 0) {
                        request.setAttribute("roomIdError", "Room ID phải là số dương");
                    }
                } catch (NumberFormatException e) {
                    request.setAttribute("roomIdError", "Room ID phải là số nguyên hợp lệ");
                }
            }

            int tenantId = 0;
            if (tenantIdStr != null && !tenantIdStr.trim().isEmpty()) {
                try {
                    tenantId = Integer.parseInt(tenantIdStr.trim());
                    if (tenantId <= 0) {
                        request.setAttribute("tenantIdError", "Tenant ID phải là số dương");
                    }
                } catch (NumberFormatException e) {
                    request.setAttribute("tenantIdError", "Tenant ID phải là số nguyên hợp lệ");
                }
            }

            Date startDate = null;
            if (startDateStr != null && !startDateStr.trim().isEmpty()) {
                try {
                    startDate = Date.valueOf(startDateStr.trim());
                } catch (IllegalArgumentException e) {
                    request.setAttribute("startDateError", "Start Date không hợp lệ");
                }
            }

            Date endDate = null;
            if (endDateStr != null && !endDateStr.trim().isEmpty()) {
                try {
                    endDate = Date.valueOf(endDateStr.trim());
                    // Validate end date is after start date
                    if (startDate != null && endDate.before(startDate)) {
                        request.setAttribute("endDateError", "End Date phải sau Start Date");
                    }
                } catch (IllegalArgumentException e) {
                    request.setAttribute("endDateError", "End Date không hợp lệ");
                }
            }

            BigDecimal rentPrice = null;
            if (rentPriceStr != null && !rentPriceStr.trim().isEmpty()) {
                try {
                    rentPrice = new BigDecimal(rentPriceStr.trim());
                    if (rentPrice.compareTo(BigDecimal.ZERO) <= 0) {
                        request.setAttribute("rentPriceError", "Rent Price phải lớn hơn 0");
                    }
                } catch (NumberFormatException e) {
                    request.setAttribute("rentPriceError", "Rent Price phải là số hợp lệ");
                }
            }

            BigDecimal depositAmount = BigDecimal.ZERO;
            if (depositAmountStr != null && !depositAmountStr.trim().isEmpty()) {
                try {
                    depositAmount = new BigDecimal(depositAmountStr.trim());
                    if (depositAmount.compareTo(BigDecimal.ZERO) < 0) {
                        request.setAttribute("depositAmountError", "Deposit Amount không được âm");
                    }
                } catch (NumberFormatException e) {
                    request.setAttribute("depositAmountError", "Deposit Amount phải là số hợp lệ");
                }
            }

            int status = 1; // Default to active
            if (statusStr != null && !statusStr.trim().isEmpty()) {
                try {
                    status = Integer.parseInt(statusStr.trim());
                } catch (NumberFormatException e) {
                    // Use default value
                }
            }

            // Check if there are any validation errors
            if (hasValidationErrors(request)) {
                // Preserve form data
                preserveFormData(request, contractIdStr, roomIdStr, tenantIdStr, 
                               startDateStr, endDateStr, rentPriceStr, depositAmountStr, 
                               statusStr, note);
                
                // Forward back to form with errors
                request.getRequestDispatcher("Contract/AddListContracts.jsp").forward(request, response);
                return;
            }

            // Check if room already has an active contract
            if (DAOContract.INSTANCE.hasActiveContract(roomId)) {
                request.setAttribute("roomIdError", "Phòng này đã có hợp đồng đang hoạt động");
                preserveFormData(request, contractIdStr, roomIdStr, tenantIdStr, 
                               startDateStr, endDateStr, rentPriceStr, depositAmountStr, 
                               statusStr, note);
                request.getRequestDispatcher("Contract/AddListContracts.jsp").forward(request, response);
                return;
            }

            // Create contract object
            Contracts contract = new Contracts();
            if (contractId != null) {
                contract.setContractId(contractId);
            }
            contract.setRoomID(roomId);
            contract.setTenantsID(tenantId);
            contract.setStartDate(startDate);
            contract.setEndDate(endDate);
            contract.setRentPrice(rentPrice);
            contract.setDepositAmount(depositAmount);
            contract.setStatus(status);
            contract.setNote(note != null ? note.trim() : "");

            // Attempt to add the contract
            int newContractId = DAOContract.INSTANCE.addContract(contract);
            
            if (newContractId > 0) {
                // Success
                session.setAttribute("successMessage", 
                    "Hợp đồng đã được tạo thành công với ID: " + newContractId);
                response.sendRedirect("listcontracts");
                return;
            } else {
                session.setAttribute("errorMessage", "Không thể tạo hợp đồng. Vui lòng thử lại.");
            }

        } catch (Exception e) {
            // Log the error for debugging
            e.printStackTrace();
            session.setAttribute("errorMessage", 
                "Đã xảy ra lỗi không mong muốn: " + e.getMessage());
        }

        // If we get here, there was an error
        // Preserve form data and forward back to form
        preserveFormData(request, contractIdStr, roomIdStr, tenantIdStr, 
                        startDateStr, endDateStr, rentPriceStr, depositAmountStr, 
                        statusStr, note);
        
        request.getRequestDispatcher("Contract/AddListContracts.jsp").forward(request, response);
    }

    private void clearFormErrors(HttpServletRequest request) {
        request.removeAttribute("contractIdError");
        request.removeAttribute("roomIdError");
        request.removeAttribute("tenantIdError");
        request.removeAttribute("startDateError");
        request.removeAttribute("endDateError");
        request.removeAttribute("rentPriceError");
        request.removeAttribute("depositAmountError");
    }

    private boolean hasValidationErrors(HttpServletRequest request) {
        return request.getAttribute("contractIdError") != null ||
               request.getAttribute("roomIdError") != null ||
               request.getAttribute("tenantIdError") != null ||
               request.getAttribute("startDateError") != null ||
               request.getAttribute("endDateError") != null ||
               request.getAttribute("rentPriceError") != null ||
               request.getAttribute("depositAmountError") != null;
    }

    private void preserveFormData(HttpServletRequest request, String contractId, String roomId, 
                                String tenantId, String startDate, String endDate, 
                                String rentPrice, String depositAmount, String status, String note) {
        request.setAttribute("contractId", contractId);
        request.setAttribute("roomId", roomId);
        request.setAttribute("tenantId", tenantId);
        request.setAttribute("startDate", startDate);
        request.setAttribute("endDate", endDate);
        request.setAttribute("rentPrice", rentPrice);
        request.setAttribute("depositAmount", depositAmount);
        request.setAttribute("status", status);
        request.setAttribute("note", note);
    }
}
