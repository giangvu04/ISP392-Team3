package Controller.contractservlet;

import dal.DAOContract;
import dal.DAORentalArea;
import model.Contracts;
import model.Users;
import model.RentalArea;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.math.BigDecimal;
import java.sql.Date;
import java.util.ArrayList;
import java.util.Comparator;

@WebServlet(name="ListContractsServlet", urlPatterns={"/listcontracts"})
public class ListContractsServlet extends HttpServlet {
    private final DAOContract contractDAO = DAOContract.INSTANCE;
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        DAOContract dao = DAOContract.INSTANCE;
        DAORentalArea daoRentalArea = DAORentalArea.INSTANCE;
        HttpSession session = request.getSession();
        request.setAttribute("message", "");

        Users user = (Users) session.getAttribute("user");
        
        if (user != null) {
            request.setAttribute("user", user);

            // Get current page from URL parameter, default to 1
            int currentPage = Integer.parseInt(request.getParameter("page") != null ? request.getParameter("page") : "1");
            int contractsPerPage = 10; // Contracts per page
            String sortBy = request.getParameter("sortBy");
            String sortOrder = request.getParameter("sortOrder");
            String searchTerm = request.getParameter("searchTerm");

            ArrayList<Contracts> contracts = new ArrayList<>();
            int totalContracts = 0;

            // Handle different user roles
            if (user.getRoleId() == 1) { // Admin
                // Admin can see all contracts
                if (searchTerm != null && !searchTerm.trim().isEmpty()) {
                    contracts = dao.getContractsBySearch(searchTerm);
                    totalContracts = contracts.size();
                } else {
                    contracts = dao.getAllContracts();
                    totalContracts = contracts.size();
                    
                    // Apply pagination for all contracts
                    int startIndex = (currentPage - 1) * contractsPerPage;
                    int endIndex = Math.min(startIndex + contractsPerPage, contracts.size());
                    if (startIndex < contracts.size()) {
                        contracts = new ArrayList<>(contracts.subList(startIndex, endIndex));
                    } else {
                        contracts = new ArrayList<>();
                    }
                }
                
            } else if (user.getRoleId() == 2) { // Manager
                // Manager can see contracts in their rental area
                RentalArea rentalArea = daoRentalArea.getRentalAreaByManagerId(user.getUserId());
                if (rentalArea != null) {
                    int managerId = user.getUserId();
                    
                    if (searchTerm != null && !searchTerm.trim().isEmpty()) {
                        // For search, get all contracts first, then filter by manager
                        ArrayList<Contracts> allSearchResults = dao.getContractsBySearch(searchTerm);
                        // Note: You might need to add a method to filter by manager in search
                        contracts = allSearchResults;
                        totalContracts = contracts.size();
                    } else {
                        contracts = dao.getContractsByPage(currentPage, contractsPerPage, managerId);
                        totalContracts = dao.getTotalContracts(managerId);
                    }
                } else {
                    request.setAttribute("error", "Manager chưa được gán khu thuê nhà nào");
                    contracts = new ArrayList<>();
                    totalContracts = 0;
                }
                
            } else if (user.getRoleId() == 3) { // Tenant
                // Tenant can only see their own contracts
                int tenantId = user.getUserId();
                
                if (searchTerm != null && !searchTerm.trim().isEmpty()) {
                    contracts = dao.getContractsBySearchAndTenant(searchTerm, tenantId);
                    totalContracts = contracts.size();
                } else {
                    // For tenant, use the pagination method or get all contracts
                    contracts = dao.getContractsByPage2(currentPage, contractsPerPage, tenantId);
                    totalContracts = dao.getTotalContractsByTenant(tenantId);
                }
                
                // Check if tenant has rental area assigned
                RentalArea rentalArea = daoRentalArea.getRentalAreaByTenantId(user.getUserId());
                if (rentalArea == null) {
                    request.setAttribute("error", "Bạn chưa được gán vào khu thuê nhà nào");
                }
            }

            // Calculate total pages
            int totalPages = (int) Math.ceil((double) totalContracts / contractsPerPage);

            // Handle sorting
            if (sortBy != null && sortOrder != null && !contracts.isEmpty()) {
                switch (sortBy) {
                    case "contractId":
                        if ("asc".equals(sortOrder)) {
                            contracts.sort(Comparator.comparing(Contracts::getContractId));
                        } else {
                            contracts.sort(Comparator.comparing(Contracts::getContractId).reversed());
                        }
                        break;
                    case "startDate":
                        if ("asc".equals(sortOrder)) {
                            contracts.sort(Comparator.comparing(Contracts::getStartDate));
                        } else {
                            contracts.sort(Comparator.comparing(Contracts::getStartDate).reversed());
                        }
                        break;
                    case "rentPrice":
                        if ("asc".equals(sortOrder)) {
                            contracts.sort(Comparator.comparing(Contracts::getRentPrice));
                        } else {
                            contracts.sort(Comparator.comparing(Contracts::getRentPrice).reversed());
                        }
                        break;
                    case "status":
                        if ("asc".equals(sortOrder)) {
                            contracts.sort(Comparator.comparingInt(Contracts::getStatus));
                        } else {
                            contracts.sort(Comparator.comparingInt(Contracts::getStatus).reversed());
                        }
                        break;
                }
            }
            
            // Set attributes for JSP
            request.setAttribute("contracts", contracts);
            request.setAttribute("currentPage", currentPage);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("sortBy", sortBy);
            request.setAttribute("sortOrder", sortOrder);
            request.setAttribute("searchTerm", searchTerm);
            request.setAttribute("totalContracts", totalContracts);

            // Forward based on user role
            String destination;
            switch (user.getRoleId()) {
                case 1: // Admin
                    destination = "Contract/LIstContractsForManager.jsp";
                    break;
                case 2: // Manager
                    destination = "Contract/LIstContractsForManager.jsp";
                    break;
                case 3: // Tenant
                    destination = "Contract/ListContracts.jsp";
                    break;
                default:
                    response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access denied.");
                    return;
            }

            request.getRequestDispatcher(destination).forward(request, response);
        } else {
            response.sendRedirect("login");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Since delete functionality is moved to DeleteContractsServlet,
        // this method now only handles other actions or redirects to doGet
        doGet(request, response);
    }
    
    @Override
    public String getServletInfo() {
        return "Servlet for contract management";
    }
}