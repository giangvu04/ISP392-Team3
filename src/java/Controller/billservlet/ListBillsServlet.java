package Controller.billservlet;

import dal.DAOBill;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.ArrayList;
import model.Bill;
import model.Users;

@WebServlet(name = "ListBillsServlet", urlPatterns = {"/listbills"})
public class ListBillsServlet extends HttpServlet {
    
    private static final int BILLS_PER_PAGE = 5;  // số lượng bills trong trang
    private DAOBill dao = DAOBill.INSTANCE;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        Users user = (Users) session.getAttribute("user");
        if (user == null) {
            request.getSession().setAttribute("error", "Vui lòng đăng nhập để tiếp tục!");
            response.sendRedirect("login");
            return;
        }

        String action = request.getParameter("action");
        int page;
        try {
            page = request.getParameter("page") != null ? Integer.parseInt(request.getParameter("page")) : 1;
            if (page < 1) {
                page = 1; // Prevent negative or zero page numbers
            }
        } catch (NumberFormatException e) {
            page = 1; // Default to page 1 on invalid input
            request.setAttribute("error", "Số trang không hợp lệ, chuyển về trang 1.");
        }

        ArrayList<Bill> bills;
        int totalPages;

        if ("search".equals(action)) {
            String searchType = request.getParameter("searchType");
            String searchValue = request.getParameter("searchValue");
            if (searchType != null && searchValue != null && !searchValue.trim().isEmpty()) {
                switch (searchType) {
                    case "tenantName":
                        bills = dao.searchBillsByTenantName(searchValue, page, BILLS_PER_PAGE);
                        totalPages = calculateTotalPages(dao.searchBillsByTenantName(searchValue).size(), BILLS_PER_PAGE);
                        break;
                    case "roomNumber":
                        bills = dao.searchBillsByRoomNumber(searchValue, page, BILLS_PER_PAGE);
                        totalPages = calculateTotalPages(dao.searchBillsByRoomNumber(searchValue).size(), BILLS_PER_PAGE);
                        break;
                    case "status":
                        bills = dao.getBillsByStatus(user, searchValue, page, BILLS_PER_PAGE);
                        totalPages = calculateTotalPages(dao.getBillsByStatus(user, searchValue).size(), BILLS_PER_PAGE);
                        break;
                    default:
                        bills = dao.getBillsByPage(user, page, BILLS_PER_PAGE);
                        totalPages = dao.getTotalPages(user, BILLS_PER_PAGE);
                }
                request.setAttribute("searchType", searchType);
                request.setAttribute("searchValue", searchValue);
                // Preserve search parameters in pagination links
                request.setAttribute("searchQuery", "&action=search&searchType=" + searchType + "&searchValue=" + searchValue);
            } else {
                bills = dao.getBillsByPage(user, page, BILLS_PER_PAGE);
                totalPages = dao.getTotalPages(user, BILLS_PER_PAGE);
                request.setAttribute("searchQuery", "");
            }
        } else {
            bills = dao.getBillsByPage(user, page, BILLS_PER_PAGE);
            totalPages = dao.getTotalPages(user, BILLS_PER_PAGE);
            request.setAttribute("searchQuery", "");
        }

        // Set attributes for JSP
        request.setAttribute("bills", bills);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalBills", dao.getTotalBills(user));
        
            request.setAttribute("totalRevenue", dao.getTotalRevenue(user));
            request.setAttribute("unpaidCount", dao.getUnpaidBills(user).size());
        

        // Forward to JSP
        request.getRequestDispatcher("Manager/Bill/list.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        Users user = (Users) session.getAttribute("user");
        if (user == null) {
            request.getSession().setAttribute("error", "Vui lòng đăng nhập để tiếp tục!");
            response.sendRedirect("login");
            return;
        }

        String action = request.getParameter("action");
        if ("updateStatus".equals(action)) {
            try {
                int id = Integer.parseInt(request.getParameter("id"));
                String status = request.getParameter("status");
                dao.updateBillStatus(id, status);
                request.getSession().setAttribute("ms", "Cập nhật trạng thái hóa đơn thành công!");
            } catch (NumberFormatException e) {
                request.getSession().setAttribute("error", "ID hóa đơn không hợp lệ!");
            }
        } else if ("delete".equals(action)) {
            try {
                int id = Integer.parseInt(request.getParameter("id"));
                dao.deleteBill(id);
                request.getSession().setAttribute("ms", "Xóa hóa đơn thành công!");
            } catch (NumberFormatException e) {
                request.getSession().setAttribute("error", "ID hóa đơn không hợp lệ!");
            }
        } // Add handling for add/edit actions as neeFded

        response.sendRedirect("listbills"); // Refresh the list
    }

    // Helper method to calculate total pages for search results
    private int calculateTotalPages(int totalItems, int itemsPerPage) {
        return (int) Math.ceil((double) totalItems / itemsPerPage);
    }
}