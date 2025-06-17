package Controller.billservlet;

import dal.DAOBill;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.ArrayList;
import model.Bill;
import model.Users;

@WebServlet(name="ListBillsServlet", urlPatterns={"/listbills"})
public class ListBillsServlet extends HttpServlet {
    
    private DAOBill daoBill = DAOBill.INSTANCE;
    
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        
        // Check if user is logged in and has manager role
        HttpSession session = request.getSession();
        Users user = (Users) session.getAttribute("user");
        
        if (user == null) {
            response.sendRedirect("Login/login.jsp");
            return;
        }
        
        if (user.getRoleId() != 2) { // Only managers (role 2) can access bills
            response.sendRedirect("error.jsp?message=Access denied. Manager role required.");
            return;
        }
        
        try {
            // Check if this is a search request
            String searchType = request.getParameter("searchType");
            String searchValue = request.getParameter("searchValue");
            
            ArrayList<Bill> bills = new ArrayList<>();
            
            if (searchValue != null && !searchValue.trim().isEmpty()) {
                // Handle search
                switch (searchType) {
                    case "tenantName":
                        bills = daoBill.searchBillsByTenantName(searchValue);
                        break;
                    case "roomNumber":
                        bills = daoBill.searchBillsByRoomNumber(searchValue);
                        break;
                    case "status":
                        bills = daoBill.getBillsByStatus(searchValue);
                        break;
                    default:
                        bills = daoBill.getAllBills();
                        break;
                }
                request.setAttribute("searchType", searchType);
                request.setAttribute("searchValue", searchValue);
            } else {
                // Get all bills
                bills = daoBill.getAllBills();
            }
            
            // Get statistics
            int totalBills = daoBill.getTotalBills();
            double totalRevenue = daoBill.getTotalRevenue();
            ArrayList<Bill> unpaidBills = daoBill.getUnpaidBills();
            
            request.setAttribute("bills", bills);
            request.setAttribute("totalBills", totalBills);
            request.setAttribute("totalRevenue", totalRevenue);
            request.setAttribute("unpaidCount", unpaidBills.size());
            
            // Forward to the manager bill list page
            request.getRequestDispatcher("Manager/Bill/list.jsp").forward(request, response);
            
        } catch (Exception e) {
            request.setAttribute("error", "Có lỗi xảy ra: " + e.getMessage());
            request.getRequestDispatcher("Manager/Bill/list.jsp").forward(request, response);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    public String getServletInfo() {
        return "List Bills Servlet for Managers";
    }
} 