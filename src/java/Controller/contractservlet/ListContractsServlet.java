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

            // Get rental area ID based on user role
            int rentalAreaId = 0; // Default to 0 (all areas) for admin and tenant
            ArrayList<Contracts> contracts = new ArrayList<>(); // Initialize empty list

            if (user.getRoleId() == 2) { // Manager
                RentalArea rentalArea = daoRentalArea.getRentalAreaByManagerId(user.getUserId());
                if (rentalArea != null) {
                    rentalAreaId = rentalArea.getRentalAreaId();
                }
            } else if (user.getRoleId() == 3) { // Tenant
                RentalArea rentalArea = daoRentalArea.getRentalAreaByTenantId(user.getUserId());
                if (rentalArea != null) {
                    rentalAreaId = rentalArea.getRentalAreaId();
                }
            }

            // Get contracts based on search or all contracts
            if (searchTerm != null && !searchTerm.isEmpty()) {
                if (user.getRoleId() == 3) { // Tenant
                    contracts = dao.getContractsBySearchAndTenant(searchTerm, user.getUserId());
                } else {
                    contracts = dao.getContractsBySearch(searchTerm);
                }
            } else {
                // For tenants, only show their contracts
                if (user.getRoleId() == 3) {
                    contracts = dao.getContractsByTenant(user.getUserId());
                } else {
                    contracts = dao.getContractsByPage(currentPage, contractsPerPage);
                }
            }

            // Handle case where tenant has no rental area assigned
            if (user.getRoleId() == 3 && rentalAreaId == 0) {
                request.setAttribute("error", "Bạn chưa được gán vào khu thuê nhà nào");
            }

            // Get total contracts and total pages
            int totalContracts;
            if (user.getRoleId() == 3) {
                totalContracts = dao.getTotalContractsByTenant(user.getUserId());
            } else {
                totalContracts = dao.getTotalContracts();
            }
            int totalPages = (int) Math.ceil((double) totalContracts / contractsPerPage);

            // Handle sorting
            if (sortBy != null && sortOrder != null) {
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

    @Override
    public String getServletInfo() {
        return "Servlet for contract management";
    }
}