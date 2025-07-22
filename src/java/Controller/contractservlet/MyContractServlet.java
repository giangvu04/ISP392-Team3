package Controller.contractservlet;

import dal.DAOContract;
import model.Contracts;
import model.Users;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.ArrayList;

@WebServlet(name = "MyContractServlet", urlPatterns = {"/mycontract"})
public class MyContractServlet extends HttpServlet {

    private static final int CONTRACTS_PER_PAGE = 10;
    private final DAOContract contractDAO = DAOContract.INSTANCE;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        if (action == null) action = "list";

        try {
            switch (action) {
                case "list":
                    listMyContracts(request, response);
                    break;
                case "view":
                    viewMyContract(request, response);
                    break;
                case "search":
                    searchMyContracts(request, response);
                    break;
                case "status":
                    listMyContractsByStatus(request, response);
                    break;
                default:
                    listMyContracts(request, response);
            }
        } catch (Exception e) {
            handleError(request, response, "Lỗi xử lý yêu cầu: " + e.getMessage());
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }

    private void listMyContracts(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            HttpSession session = request.getSession();
            Users user = (Users) session.getAttribute("user");
            if (user == null) {
                response.sendRedirect("login");
                return;
            }
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
            ArrayList<Contracts> contracts = contractDAO.getContractsByPage2(page, CONTRACTS_PER_PAGE, user.getUserId());
            int totalContracts = contractDAO.getTotalContractsByTenant(user.getUserId());
            int totalPages = (int) Math.ceil((double) totalContracts / CONTRACTS_PER_PAGE);

            request.setAttribute("contracts", contracts);
            request.setAttribute("currentPage", page);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("totalContracts", totalContracts);
            request.setAttribute("contractsPerPage", CONTRACTS_PER_PAGE);

            request.getRequestDispatcher("/Contract/MyContracts.jsp").forward(request, response);
        } catch (Exception e) {
            handleError(request, response, "Lỗi khi tải danh sách hợp đồng: " + e.getMessage());
        }
    }

    private void listMyContractsByStatus(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            HttpSession session = request.getSession();
            Users user = (Users) session.getAttribute("user");
            if (user == null) {
                response.sendRedirect("login");
                return;
            }
            String statusStr = request.getParameter("status");
            int status = -1;
            try {
                status = Integer.parseInt(statusStr);
            } catch (Exception ignored) {}
            ArrayList<Contracts> contracts = contractDAO.getContractsByStatusAndTenant(status, user.getUserId());
            request.setAttribute("contracts", contracts);
            request.setAttribute("status", status);
            request.setAttribute("statusMode", true);
            request.getRequestDispatcher("/Contract/MyContracts.jsp").forward(request, response);
        } catch (Exception e) {
            handleError(request, response, "Lỗi khi lọc hợp đồng: " + e.getMessage());
        }
    }

    private void viewMyContract(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String contractIdStr = request.getParameter("id");
            if (contractIdStr == null || contractIdStr.isEmpty()) {
                setErrorMessage(request, "ID hợp đồng không hợp lệ");
                response.sendRedirect("mycontract?action=list");
                return;
            }
            int contractId = Integer.parseInt(contractIdStr);
            Contracts contract = contractDAO.getContractById(contractId);

            if (contract == null) {
                setErrorMessage(request, "Không tìm thấy hợp đồng với ID: " + contractId);
                response.sendRedirect("mycontract?action=list");
                return;
            }

            Users user = (Users) request.getSession().getAttribute("user");
            if (user == null || contract.getTenantsID() != user.getUserId()) {
                setErrorMessage(request, "Bạn không có quyền xem hợp đồng này");
                response.sendRedirect("mycontract?action=list");
                return;
            }

            request.setAttribute("contract", contract);
            request.getRequestDispatcher("/Contract/ViewContracts.jsp").forward(request, response);

        } catch (Exception e) {
            handleError(request, response, "Lỗi khi tải thông tin hợp đồng: " + e.getMessage());
        }
    }

    private void searchMyContracts(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String keyword = request.getParameter("keyword");
            HttpSession session = request.getSession();
            Users user = (Users) session.getAttribute("user");
            if (user == null) {
                response.sendRedirect("login");
                return;
            }
            if (keyword == null || keyword.trim().isEmpty()) {
                response.sendRedirect("mycontract?action=list");
                return;
            }
            ArrayList<Contracts> contracts = contractDAO.getContractsBySearchAndTenant(keyword.trim(), user.getUserId());
            request.setAttribute("contracts", contracts);
            request.setAttribute("keyword", keyword.trim());
            request.setAttribute("searchMode", true);

            request.getRequestDispatcher("/Contract/MyContracts.jsp").forward(request, response);
        } catch (Exception e) {
            handleError(request, response, "Lỗi khi tìm kiếm hợp đồng: " + e.getMessage());
        }
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
