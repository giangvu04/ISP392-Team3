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
import model.Contracts;

public class UpdateContractsList extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int contractId = Integer.parseInt(request.getParameter("id"));
            Contracts contract = DAOContract.INSTANCE.getContractById(contractId);
            
            if (contract != null) {
                request.setAttribute("contract", contract);
                request.getRequestDispatcher("Contract/UpdateListContracts.jsp").forward(request, response);
            } else {
                request.getSession().setAttribute("message", "Contract not found!");
                request.getSession().setAttribute("messageType", "danger");
                response.sendRedirect("listcontracts");
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("message", "An error occurred: " + e.getMessage());
            request.getSession().setAttribute("messageType", "danger");
            response.sendRedirect("listcontracts");
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Get parameters from the form
            int contractId = Integer.parseInt(request.getParameter("contractId"));
            int roomId = Integer.parseInt(request.getParameter("roomId"));
            int tenantId = Integer.parseInt(request.getParameter("tenantId"));
            Date startDate = Date.valueOf(request.getParameter("startDate"));
            Date endDate = null;
            
            // Handle end date (can be null)
            String endDateStr = request.getParameter("endDate");
            if (endDateStr != null && !endDateStr.trim().isEmpty()) {
                endDate = Date.valueOf(endDateStr);
            }
            
            BigDecimal rentPrice = new BigDecimal(request.getParameter("rentPrice"));
            BigDecimal depositAmount = new BigDecimal(request.getParameter("depositAmount"));
            int status = Integer.parseInt(request.getParameter("status"));
            String note = request.getParameter("note");
            
            // Create a contract object with updated information
            Contracts contract = new Contracts();
            contract.setContractId(contractId);
            contract.setRoomID(roomId);
            contract.setTenantsID(tenantId);
            contract.setStartDate(startDate);
            contract.setEndDate(endDate);
            contract.setRentPrice(rentPrice);
            contract.setDepositAmount(depositAmount);
            contract.setStatus(status);
            contract.setNote(note);
            
            // Validate contract data
            if (!DAOContract.INSTANCE.isValidContract(contract)) {
                request.getSession().setAttribute("message", "Invalid contract data. Please check all fields.");
                request.getSession().setAttribute("messageType", "danger");
                response.sendRedirect("updatecontract?id=" + contractId);
                return;
            }
            
            // Update the contract in the database
            DAOContract.INSTANCE.updateContract(contract);
            
            request.getSession().setAttribute("message", "Contract updated successfully!");
            request.getSession().setAttribute("messageType", "success");
            
            response.sendRedirect("listcontracts");
            
        } catch (NumberFormatException e) {
            e.printStackTrace();
            request.getSession().setAttribute("message", "Invalid number format. Please check your input.");
            request.getSession().setAttribute("messageType", "danger");
            response.sendRedirect("listcontracts");
        } catch (IllegalArgumentException e) {
            e.printStackTrace();
            request.getSession().setAttribute("message", "Invalid date format. Please use YYYY-MM-DD format.");
            request.getSession().setAttribute("messageType", "danger");
            response.sendRedirect("listcontracts");
        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("message", "An error occurred: " + e.getMessage());
            request.getSession().setAttribute("messageType", "danger");
            response.sendRedirect("listcontracts");
        }
    }
}