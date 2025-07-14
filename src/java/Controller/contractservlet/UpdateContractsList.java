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

//@WebServlet(name = "UpdateContractServlet", urlPatterns = {"/updatecontract"})
public class UpdateContractsList extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String idParam = request.getParameter("id");
            if (idParam == null || idParam.trim().isEmpty()) {
                setErrorMessage(request, "Contract ID is required!");
                response.sendRedirect("listcontracts");
                return;
            }

            int contractId = Integer.parseInt(idParam);
            Contracts contract = DAOContract.INSTANCE.getContractById(contractId);
            
            if (contract != null) {
                request.setAttribute("contract", contract);
                request.getRequestDispatcher("Contract/UpdateListContracts.jsp").forward(request, response);
            } else {
                setErrorMessage(request, "Contract not found!");
                response.sendRedirect("listcontracts");
            }
        } catch (NumberFormatException e) {
            setErrorMessage(request, "Invalid contract ID format!");
            response.sendRedirect("listcontracts");
        } catch (Exception e) {
            e.printStackTrace();
            setErrorMessage(request, "An error occurred while loading contract: " + e.getMessage());
            response.sendRedirect("listcontracts");
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Validate required parameters
            if (!validateRequiredParameters(request)) {
                setErrorMessage(request, "Missing required parameters!");
                response.sendRedirect("listcontracts");
                return;
            }

            // Get and validate parameters
            int contractId = Integer.parseInt(request.getParameter("contractId"));
            int roomId = Integer.parseInt(request.getParameter("roomId"));
            int tenantId = Integer.parseInt(request.getParameter("tenantId"));
            
            // Validate date parameters
            Date startDate = parseDate(request.getParameter("startDate"));
            Date endDate = parseDate(request.getParameter("endDate"));
            
            if (startDate == null) {
                setErrorMessage(request, "Start date is required and must be valid!");
                response.sendRedirect("updatecontract?id=" + contractId);
                return;
            }
            
            // Validate date logic
            if (endDate != null && !endDate.after(startDate)) {
                setErrorMessage(request, "End date must be after start date!");
                response.sendRedirect("updatecontract?id=" + contractId);
                return;
            }
            
            // Validate and parse financial data
            BigDecimal rentPrice = parseBigDecimal(request.getParameter("rentPrice"));
            BigDecimal depositAmount = parseBigDecimal(request.getParameter("depositAmount"));
            
            if (rentPrice == null || rentPrice.compareTo(BigDecimal.ZERO) <= 0) {
                setErrorMessage(request, "Rent price must be greater than 0!");
                response.sendRedirect("updatecontract?id=" + contractId);
                return;
            }
            
            if (depositAmount != null && depositAmount.compareTo(BigDecimal.ZERO) < 0) {
                setErrorMessage(request, "Deposit amount cannot be negative!");
                response.sendRedirect("updatecontract?id=" + contractId);
                return;
            }
            
            int status = Integer.parseInt(request.getParameter("status"));
            String note = request.getParameter("note");
            
            // Validate status
            if (status < 0 || status > 3) {
                setErrorMessage(request, "Invalid contract status!");
                response.sendRedirect("updatecontract?id=" + contractId);
                return;
            }
            
            // Check if contract exists
            Contracts existingContract = DAOContract.INSTANCE.getContractById(contractId);
            if (existingContract == null) {
                setErrorMessage(request, "Contract not found!");
                response.sendRedirect("listcontracts");
                return;
            }
            
            // Create updated contract object
            Contracts contract = new Contracts();
            contract.setContractId(contractId);
            contract.setRoomID(roomId);
            contract.setTenantsID(tenantId);
            contract.setStartDate(startDate);
            contract.setEndDate(endDate);
            contract.setRentPrice(rentPrice);
            contract.setDepositAmount(depositAmount);
            contract.setStatus(status);
            contract.setNote(note != null ? note.trim() : null);
            
            // Business logic validations
            if (!validateBusinessRules(contract, existingContract)) {
                setErrorMessage(request, "Business rule validation failed!");
                response.sendRedirect("updatecontract?id=" + contractId);
                return;
            }
            
            // Update the contract in the database
            DAOContract.INSTANCE.updateContract(contract);
            
            setSuccessMessage(request, "Contract updated successfully!");
            response.sendRedirect("listcontracts");
            
        } catch (NumberFormatException e) {
            e.printStackTrace();
            setErrorMessage(request, "Invalid number format. Please check your input.");
            response.sendRedirect("listcontracts");
        } catch (IllegalArgumentException e) {
            e.printStackTrace();
            setErrorMessage(request, "Invalid date format. Please use YYYY-MM-DD format.");
            response.sendRedirect("listcontracts");
        } catch (Exception e) {
            e.printStackTrace();
            setErrorMessage(request, "An error occurred while updating contract: " + e.getMessage());
            response.sendRedirect("listcontracts");
        }
    }
    
    /**
     * Validate required parameters
     */
    private boolean validateRequiredParameters(HttpServletRequest request) {
        String[] requiredParams = {"contractId", "roomId", "tenantId", "startDate", "rentPrice", "status"};
        
        for (String param : requiredParams) {
            String value = request.getParameter(param);
            if (value == null || value.trim().isEmpty()) {
                return false;
            }
        }
        return true;
    }
    
    /**
     * Parse date string to Date object
     */
    private Date parseDate(String dateStr) {
        if (dateStr == null || dateStr.trim().isEmpty()) {
            return null;
        }
        try {
            return Date.valueOf(dateStr.trim());
        } catch (IllegalArgumentException e) {
            return null;
        }
    }
    
    /**
     * Parse string to BigDecimal
     */
    private BigDecimal parseBigDecimal(String value) {
        if (value == null || value.trim().isEmpty()) {
            return null;
        }
        try {
            return new BigDecimal(value.trim());
        } catch (NumberFormatException e) {
            return null;
        }
    }
    
    /**
     * Validate business rules
     */
    private boolean validateBusinessRules(Contracts contract, Contracts existingContract) {
        // Check if status change is valid
        if (existingContract.getStatus() == 3 && contract.getStatus() != 3) {
            // Cannot reactivate terminated contracts
            return false;
        }
        
        // If changing to active status, check for conflicts
        if (contract.getStatus() == 1) {
            // Check if room already has active contract (excluding current contract)
            if (DAOContract.INSTANCE.hasActiveContract(contract.getRoomID())) {
                // Additional check: is this the same contract being updated?
                Contracts activeContract = DAOContract.INSTANCE.getLatestActiveContractByRoom(contract.getRoomID());
                if (activeContract != null && activeContract.getContractId() != contract.getContractId()) {
                    return false;
                }
            }
        }
        
        return true;
    }
    
    /**
     * Set error message in session
     */
    private void setErrorMessage(HttpServletRequest request, String message) {
        HttpSession session = request.getSession();
        session.setAttribute("errorMessage", message);
        session.setAttribute("messageType", "danger");
    }
    
    /**
     * Set success message in session
     */
    private void setSuccessMessage(HttpServletRequest request, String message) {
        HttpSession session = request.getSession();
        session.setAttribute("successMessage", message);
        session.setAttribute("messageType", "success");
    }
}