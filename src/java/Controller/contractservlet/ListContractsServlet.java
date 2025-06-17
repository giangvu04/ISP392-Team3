package Controller.contractservlet;

import dal.DAOContract;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.math.BigDecimal;
import java.sql.Date;
import java.util.ArrayList;
import model.Contracts;

/**
 * Servlet for managing contracts
 * @author ADMIN
 */
@WebServlet(name="ListContractsServlet", urlPatterns={"/listcontracts"})
public class ListContractsServlet extends HttpServlet {
    
    private final DAOContract contractDAO = DAOContract.INSTANCE;
    private static final int CONTRACTS_PER_PAGE = 10;
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String action = request.getParameter("action");
        if (action == null) {
            action = "list";
        }
        
        try {
            switch (action) {
                case "list":
                    listContracts(request, response);
                    break;
                case "search":
                    searchContracts(request, response);
                    break;
                case "add":
                    showAddForm(request, response);
                    break;
                case "edit":
                    showEditForm(request, response);
                    break;
                case "delete":
                    deleteContract(request, response);
                    break;
                case "view":
                    viewContract(request, response);
                    break;
                case "tenant":
                    listContractsByTenant(request, response);
                    break;
                case "status":
                    listContractsByStatus(request, response);
                    break;
                default:
                    listContracts(request, response);
                    break;
            }
        } catch (Exception e) {
            handleError(request, response, "Lỗi xử lý yêu cầu: " + e.getMessage());
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");
        
        try {
            switch (action) {
                case "add":
                    addContract(request, response);
                    break;
                case "update":
                    updateContract(request, response);
                    break;
                default:
                    response.sendRedirect("listcontracts?action=list");
                    break;
            }
        } catch (Exception e) {
            handleError(request, response, "Lỗi xử lý yêu cầu: " + e.getMessage());
        }
    }
    
    private void listContracts(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            // Xử lý phân trang
            int page = 1;
            String pageStr = request.getParameter("page");
            if (pageStr != null && !pageStr.isEmpty()) {
                try {
                    page = Integer.parseInt(pageStr);
                    if (page < 1) page = 1;
                } catch (NumberFormatException e) {
                    page = 1;
                }
            }
            
            // Lấy danh sách hợp đồng theo trang
            ArrayList<Contracts> contracts = contractDAO.getContractsByPage(page, CONTRACTS_PER_PAGE);
            int totalContracts = contractDAO.getTotalContracts();
            int totalPages = (int) Math.ceil((double) totalContracts / CONTRACTS_PER_PAGE);
            
            // Set attributes
            request.setAttribute("contracts", contracts);
            request.setAttribute("currentPage", page);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("totalContracts", totalContracts);
            request.setAttribute("contractsPerPage", CONTRACTS_PER_PAGE);
            
            // Forward đến JSP
            request.getRequestDispatcher("/Contract/LIstContractsForManager.jsp").forward(request, response);
            
        } catch (Exception e) {
            handleError(request, response, "Lỗi khi tải danh sách hợp đồng: " + e.getMessage());
        }
    }
    
    private void listContractsByTenant(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            String tenantIdStr = request.getParameter("tenantId");
            if (tenantIdStr == null || tenantIdStr.isEmpty()) {
                setErrorMessage(request, "ID người thuê không hợp lệ");
                response.sendRedirect("listcontracts?action=list");
                return;
            }
            
            int tenantId = Integer.parseInt(tenantIdStr);
            
            // Xử lý phân trang
            int page = 1;
            String pageStr = request.getParameter("page");
            if (pageStr != null && !pageStr.isEmpty()) {
                try {
                    page = Integer.parseInt(pageStr);
                    if (page < 1) page = 1;
                } catch (NumberFormatException e) {
                    page = 1;
                }
            }
            
            ArrayList<Contracts> contracts = contractDAO.getContractsByPage2(page, CONTRACTS_PER_PAGE, tenantId);
            int totalContracts = contractDAO.getTotalContractsByTenant(tenantId);
            int totalPages = (int) Math.ceil((double) totalContracts / CONTRACTS_PER_PAGE);
            
            request.setAttribute("contracts", contracts);
            request.setAttribute("currentPage", page);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("totalContracts", totalContracts);
            request.setAttribute("contractsPerPage", CONTRACTS_PER_PAGE);
            request.setAttribute("tenantId", tenantId);
            request.setAttribute("tenantMode", true);
            
            request.getRequestDispatcher("/Contract/LIstContractsForManager.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            setErrorMessage(request, "ID người thuê không hợp lệ");
            response.sendRedirect("listcontracts?action=list");
        } catch (Exception e) {
            handleError(request, response, "Lỗi khi tải danh sách hợp đồng theo người thuê: " + e.getMessage());
        }
    }
    
    private void listContractsByStatus(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            String statusStr = request.getParameter("status");
            if (statusStr == null || statusStr.isEmpty()) {
                setErrorMessage(request, "Trạng thái không hợp lệ");
                response.sendRedirect("listcontracts?action=list");
                return;
            }
            
            int status = Integer.parseInt(statusStr);
            ArrayList<Contracts> contracts = contractDAO.getContractsByStatus(status);
            
            request.setAttribute("contracts", contracts);
            request.setAttribute("status", status);
            request.setAttribute("statusMode", true);
            
            request.getRequestDispatcher("/Contract/list.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            setErrorMessage(request, "Trạng thái không hợp lệ");
            response.sendRedirect("listcontracts?action=list");
        } catch (Exception e) {
            handleError(request, response, "Lỗi khi tải danh sách hợp đồng theo trạng thái: " + e.getMessage());
        }
    }
    
    private void searchContracts(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            String keyword = request.getParameter("keyword");
            String tenantIdStr = request.getParameter("tenantId");
            
            if (keyword == null || keyword.trim().isEmpty()) {
                response.sendRedirect("listcontracts?action=list");
                return;
            }
            
            ArrayList<Contracts> contracts;
            
            // Nếu có tenantId thì tìm kiếm theo tenant cụ thể
            if (tenantIdStr != null && !tenantIdStr.isEmpty()) {
                try {
                    int tenantId = Integer.parseInt(tenantIdStr);
                    contracts = contractDAO.getContractsBySearchAndTenant(keyword.trim(), tenantId);
                    request.setAttribute("tenantId", tenantId);
                    request.setAttribute("tenantMode", true);
                } catch (NumberFormatException e) {
                    contracts = contractDAO.getContractsBySearch(keyword.trim());
                }
            } else {
                contracts = contractDAO.getContractsBySearch(keyword.trim());
            }
            
            request.setAttribute("contracts", contracts);
            request.setAttribute("keyword", keyword.trim());
            request.setAttribute("searchMode", true);
            
            request.getRequestDispatcher("/Contract/LIstContractsForManager.jsp").forward(request, response);
            
        } catch (Exception e) {
            handleError(request, response, "Lỗi khi tìm kiếm hợp đồng: " + e.getMessage());
        }
    }
    
    private void showAddForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        request.getRequestDispatcher("/Contract/AddListContracts.jsp").forward(request, response);
    }
    
    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            String contractIdStr = request.getParameter("id");
            if (contractIdStr == null || contractIdStr.isEmpty()) {
                setErrorMessage(request, "ID hợp đồng không hợp lệ");
                response.sendRedirect("listcontracts?action=list");
                return;
            }
            
            int contractId = Integer.parseInt(contractIdStr);
            Contracts contract = contractDAO.getContractById(contractId);
            
            if (contract == null) {
                setErrorMessage(request, "Không tìm thấy hợp đồng với ID: " + contractId);
                response.sendRedirect("listcontracts?action=list");
                return;
            }
            
            request.setAttribute("contract", contract);
            request.getRequestDispatcher("/views/contract/edit.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            setErrorMessage(request, "ID hợp đồng không hợp lệ");
            response.sendRedirect("listcontracts?action=list");
        } catch (Exception e) {
            handleError(request, response, "Lỗi khi tải thông tin hợp đồng: " + e.getMessage());
        }
    }
    
    private void viewContract(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            String contractIdStr = request.getParameter("id");
            if (contractIdStr == null || contractIdStr.isEmpty()) {
                setErrorMessage(request, "ID hợp đồng không hợp lệ");
                response.sendRedirect("listcontracts?action=list");
                return;
            }
            
            int contractId = Integer.parseInt(contractIdStr);
            Contracts contract = contractDAO.getContractById(contractId);
            
            if (contract == null) {
                setErrorMessage(request, "Không tìm thấy hợp đồng với ID: " + contractId);
                response.sendRedirect("listcontracts?action=list");
                return;
            }
            
            request.setAttribute("contract", contract);
            request.getRequestDispatcher("/views/contract/view.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            setErrorMessage(request, "ID hợp đồng không hợp lệ");
            response.sendRedirect("listcontracts?action=list");
        } catch (Exception e) {
            handleError(request, response, "Lỗi khi tải thông tin hợp đồng: " + e.getMessage());
        }
    }
    
    private void addContract(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
    
    try {
        // Lấy các tham số từ form
        String contractIdStr = request.getParameter("contractId"); // THÊM DÒNG NÀY
        String roomIdStr = request.getParameter("roomId");
        String tenantIdStr = request.getParameter("tenantId");
        String startDateStr = request.getParameter("startDate");
        String endDateStr = request.getParameter("endDate");
        String rentPriceStr = request.getParameter("rentPrice");
        String depositAmountStr = request.getParameter("depositAmount");
        String statusStr = request.getParameter("status");
        String note = request.getParameter("note");
        
        // Validation cơ bản
        if (roomIdStr == null || roomIdStr.trim().isEmpty()) {
            setErrorMessage(request, "ID phòng không được để trống");
            preserveFormData(request, contractIdStr, roomIdStr, tenantIdStr, startDateStr, endDateStr, 
                           rentPriceStr, depositAmountStr, statusStr, note);
            request.getRequestDispatcher("/Contract/AddListContracts.jsp").forward(request, response);
            return;
        }
        
        if (tenantIdStr == null || tenantIdStr.trim().isEmpty()) {
            setErrorMessage(request, "ID người thuê không được để trống");
            preserveFormData(request, contractIdStr, roomIdStr, tenantIdStr, startDateStr, endDateStr, 
                           rentPriceStr, depositAmountStr, statusStr, note);
            request.getRequestDispatcher("/Contract/AddListContracts.jsp").forward(request, response);
            return;
        }
        
        if (startDateStr == null || startDateStr.trim().isEmpty()) {
            setErrorMessage(request, "Ngày bắt đầu không được để trống");
            preserveFormData(request, contractIdStr, roomIdStr, tenantIdStr, startDateStr, endDateStr, 
                           rentPriceStr, depositAmountStr, statusStr, note);
            request.getRequestDispatcher("/Contract/AddListContracts.jsp").forward(request, response);
            return;
        }
        
        if (rentPriceStr == null || rentPriceStr.trim().isEmpty()) {
            setErrorMessage(request, "Giá thuê không được để trống");
            preserveFormData(request, contractIdStr, roomIdStr, tenantIdStr, startDateStr, endDateStr, 
                           rentPriceStr, depositAmountStr, statusStr, note);
            request.getRequestDispatcher("/Contract/AddListContracts.jsp").forward(request, response);
            return;
        }
        
        // Parse dữ liệu
        int roomId = Integer.parseInt(roomIdStr);
        int tenantId = Integer.parseInt(tenantIdStr);
        Date startDate = Date.valueOf(startDateStr);
        Date endDate = endDateStr != null && !endDateStr.trim().isEmpty() ? Date.valueOf(endDateStr) : null;
        BigDecimal rentPrice = new BigDecimal(rentPriceStr);
        BigDecimal depositAmount = depositAmountStr != null && !depositAmountStr.trim().isEmpty() ? 
                                 new BigDecimal(depositAmountStr) : BigDecimal.ZERO;
        int status = statusStr != null && !statusStr.trim().isEmpty() ? Integer.parseInt(statusStr) : 1;
        
        // XỬ LÝ CONTRACT ID
        Integer contractId = null;
        if (contractIdStr != null && !contractIdStr.trim().isEmpty()) {
            try {
                contractId = Integer.parseInt(contractIdStr.trim());
                if (contractId <= 0) {
                    setErrorMessage(request, "ID hợp đồng phải là số dương");
                    preserveFormData(request, contractIdStr, roomIdStr, tenantIdStr, startDateStr, endDateStr, 
                                   rentPriceStr, depositAmountStr, statusStr, note);
                    request.getRequestDispatcher("/Contract/AddListContracts.jsp").forward(request, response);
                    return;
                }
                
                // Kiểm tra xem contract ID đã tồn tại chưa
                if (contractDAO.getContractById(contractId) != null) {
                    setErrorMessage(request, "ID hợp đồng " + contractId + " đã tồn tại");
                    preserveFormData(request, contractIdStr, roomIdStr, tenantIdStr, startDateStr, endDateStr, 
                                   rentPriceStr, depositAmountStr, statusStr, note);
                    request.getRequestDispatcher("/Contract/AddListContracts.jsp").forward(request, response);
                    return;
                }
            } catch (NumberFormatException e) {
                setErrorMessage(request, "ID hợp đồng phải là số nguyên hợp lệ");
                preserveFormData(request, contractIdStr, roomIdStr, tenantIdStr, startDateStr, endDateStr, 
                               rentPriceStr, depositAmountStr, statusStr, note);
                request.getRequestDispatcher("/Contract/AddListContracts.jsp").forward(request, response);
                return;
            }
        }
        
        // Kiểm tra hợp đồng ĐANG HOẠT ĐỘNG cho phòng này
        if (contractDAO.hasActiveContract(roomId)) {
            setErrorMessage(request, "Phòng này đã có hợp đồng đang hoạt động");
            preserveFormData(request, contractIdStr, roomIdStr, tenantIdStr, startDateStr, endDateStr, 
                           rentPriceStr, depositAmountStr, statusStr, note);
            request.getRequestDispatcher("/Contract/AddListContracts.jsp").forward(request, response);
            return;
        }
        
        // Tạo hợp đồng mới
        Contracts contract = new Contracts();
        
        // SET CONTRACT ID NẾU CÓ
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
        
        // Xử lý note
        if (note != null && !note.trim().isEmpty()) {
            contract.setNote(note.trim());
        } else {
            contract.setNote(null);
        }
        
        int newContractId = contractDAO.addContract(contract);
        
        if (newContractId > 0) {
            setSuccessMessage(request, "Thêm hợp đồng thành công với ID: " + newContractId);
            response.sendRedirect("listcontracts?action=list");
        } else {
            setErrorMessage(request, "Lỗi khi thêm hợp đồng");
            preserveFormData(request, contractIdStr, roomIdStr, tenantIdStr, startDateStr, endDateStr, 
                           rentPriceStr, depositAmountStr, statusStr, note);
            request.getRequestDispatcher("/Contract/AddListContracts.jsp").forward(request, response);
        }
        
    } catch (NumberFormatException e) {
        setErrorMessage(request, "Dữ liệu nhập không hợp lệ: " + e.getMessage());
        String contractIdStr = request.getParameter("contractId");
        String roomIdStr = request.getParameter("roomId");
        String tenantIdStr = request.getParameter("tenantId");
        String startDateStr = request.getParameter("startDate");
        String endDateStr = request.getParameter("endDate");
        String rentPriceStr = request.getParameter("rentPrice");
        String depositAmountStr = request.getParameter("depositAmount");
        String statusStr = request.getParameter("status");
        String note = request.getParameter("note");
        
        preserveFormData(request, contractIdStr, roomIdStr, tenantIdStr, startDateStr, endDateStr, 
                       rentPriceStr, depositAmountStr, statusStr, note);
        request.getRequestDispatcher("/Contract/AddListContracts.jsp").forward(request, response);
    } catch (IllegalArgumentException e) {
        setErrorMessage(request, e.getMessage());
        String contractIdStr = request.getParameter("contractId");
        String roomIdStr = request.getParameter("roomId");
        String tenantIdStr = request.getParameter("tenantId");
        String startDateStr = request.getParameter("startDate");
        String endDateStr = request.getParameter("endDate");
        String rentPriceStr = request.getParameter("rentPrice");
        String depositAmountStr = request.getParameter("depositAmount");
        String statusStr = request.getParameter("status");
        String note = request.getParameter("note");
        
        preserveFormData(request, contractIdStr, roomIdStr, tenantIdStr, startDateStr, endDateStr, 
                       rentPriceStr, depositAmountStr, statusStr, note);
        request.getRequestDispatcher("/Contract/AddListContracts.jsp").forward(request, response);
    } catch (Exception e) {
        handleError(request, response, "Lỗi khi thêm hợp đồng: " + e.getMessage());
    }
}
    
    private void updateContract(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            String contractIdStr = request.getParameter("contractId");
            String roomIdStr = request.getParameter("roomId");
            String tenantIdStr = request.getParameter("tenantId");
            String startDateStr = request.getParameter("startDate");
            String endDateStr = request.getParameter("endDate");
            String rentPriceStr = request.getParameter("rentPrice");
            String depositAmountStr = request.getParameter("depositAmount");
            String statusStr = request.getParameter("status");
            String note = request.getParameter("note");
            
            if (contractIdStr == null || contractIdStr.isEmpty()) {
                setErrorMessage(request, "ID hợp đồng không hợp lệ");
                response.sendRedirect("listcontracts?action=list");
                return;
            }
            
            int contractId = Integer.parseInt(contractIdStr);
            
            // Validation
            if (roomIdStr == null || roomIdStr.trim().isEmpty()) {
                setErrorMessage(request, "ID phòng không được để trống");
                response.sendRedirect("listcontracts?action=edit&id=" + contractId);
                return;
            }
            
            if (tenantIdStr == null || tenantIdStr.trim().isEmpty()) {
                setErrorMessage(request, "ID người thuê không được để trống");
                response.sendRedirect("listcontracts?action=edit&id=" + contractId);
                return;
            }
            
            int roomId = Integer.parseInt(roomIdStr);
            int tenantId = Integer.parseInt(tenantIdStr);
            Date startDate = Date.valueOf(startDateStr);
            Date endDate = endDateStr != null && !endDateStr.trim().isEmpty() ? Date.valueOf(endDateStr) : null;
            BigDecimal rentPrice = new BigDecimal(rentPriceStr);
            BigDecimal depositAmount = depositAmountStr != null && !depositAmountStr.trim().isEmpty() ? 
                                     new BigDecimal(depositAmountStr) : BigDecimal.ZERO;
            int status = statusStr != null && !statusStr.trim().isEmpty() ? Integer.parseInt(statusStr) : 1;
            
            // Cập nhật hợp đồng
            Contracts contract = new Contracts();
            contract.setContractId(contractId);
            contract.setRoomID(roomId);
            contract.setTenantsID(tenantId);
            contract.setStartDate(startDate);
            contract.setEndDate(endDate);
            contract.setRentPrice(rentPrice);
            contract.setDepositAmount(depositAmount);
            contract.setStatus(status);

            // SỬA XỬ LÝ NOTE: Trả về null nếu rỗng
            if (note != null && !note.trim().isEmpty()) {
                contract.setNote(note.trim());
            } else {
            contract.setNote(null); // Trả về null thay vì chuỗi rỗng
            }

            contractDAO.updateContract(contract);

            setSuccessMessage(request, "Cập nhật hợp đồng thành công!");
            response.sendRedirect("listcontracts?action=list");
            
        } catch (NumberFormatException e) {
            setErrorMessage(request, "Dữ liệu nhập không hợp lệ");
            String contractIdStr = request.getParameter("contractId");
            response.sendRedirect("listcontracts?action=edit&id=" + contractIdStr);
        } catch (IllegalArgumentException e) {
            setErrorMessage(request, e.getMessage());
            String contractIdStr = request.getParameter("contractId");
            response.sendRedirect("listcontracts?action=edit&id=" + contractIdStr);
        } catch (Exception e) {
            handleError(request, response, "Lỗi khi cập nhật hợp đồng: " + e.getMessage());
        }
    }
    
    private void deleteContract(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        try {
            String contractIdStr = request.getParameter("id");
            if (contractIdStr == null || contractIdStr.isEmpty()) {
                setErrorMessage(request, "ID hợp đồng không hợp lệ");
                response.sendRedirect("listcontracts?action=list");
                return;
            }
            
            int contractId = Integer.parseInt(contractIdStr);
            
            contractDAO.deleteContract(contractId);
            
            setSuccessMessage(request, "Xóa hợp đồng thành công!");
            response.sendRedirect("listcontracts?action=list");
            
        } catch (NumberFormatException e) {
            setErrorMessage(request, "ID hợp đồng không hợp lệ");
            response.sendRedirect("listcontracts?action=list");
        } catch (RuntimeException e) {
            setErrorMessage(request, e.getMessage());
            response.sendRedirect("listcontracts?action=list");
        } catch (Exception e) {
            handleError(request, response, "Lỗi khi xóa hợp đồng: " + e.getMessage());
        }
    }
    
    // Utility methods
    private void preserveFormData(HttpServletRequest request, String contractId, String roomId, String tenantId, 
                            String startDate, String endDate, String rentPrice, 
                            String depositAmount, String status, String note) {
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
    
    private void setSuccessMessage(HttpServletRequest request, String message) {
        HttpSession session = request.getSession();
        session.setAttribute("successMessage", message);
    }
    
    private void setErrorMessage(HttpServletRequest request, String message) {
        HttpSession session = request.getSession();
        session.setAttribute("errorMessage", message);
    }
    
    private void handleError(HttpServletRequest request, HttpServletResponse response, String errorMessage)
            throws ServletException, IOException {
        request.setAttribute("errorMessage", errorMessage);
        request.getRequestDispatcher("/error.jsp").forward(request, response);
    }
}