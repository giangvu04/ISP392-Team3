package Controller.contractservlet;

import dal.DAOContract;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet(name="DeleteContractsServlet", urlPatterns={"/deletecontract"})
public class DeleteContractsServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String deleteIdParam = request.getParameter("deleteid");
            
            // Validate contract ID parameter
            if (deleteIdParam == null || deleteIdParam.trim().isEmpty()) {
                setErrorMessage(request, "ID hợp đồng không được để trống!");
                response.sendRedirect("listcontracts");
                return;
            }
            
            int deleteId = Integer.parseInt(deleteIdParam);
            
            // Optional: Get user ID if needed for logging/authorization
            String userIdParam = request.getParameter("userid");
            int userId = 0;
            if (userIdParam != null && !userIdParam.trim().isEmpty()) {
                try {
                    userId = Integer.parseInt(userIdParam);
                } catch (NumberFormatException e) {
                    // User ID is optional, continue without it
                }
            }
            
            // Check if contract exists before deleting
            if (DAOContract.INSTANCE.getContractById(deleteId) == null) {
                setErrorMessage(request, "Hợp đồng không tồn tại hoặc đã bị xóa!");
                response.sendRedirect("listcontracts");
                return;
            }
            
            // Delete the contract
            boolean success = DAOContract.INSTANCE.deleteContract(deleteId);
            
            if (success) {
                // Set success message
                setSuccessMessage(request, "Xóa hợp đồng thành công!");
            } else {
                setErrorMessage(request, "Không thể xóa hợp đồng. Vui lòng thử lại!");
            }
            
            response.sendRedirect("listcontracts"); // Redirect to contract list
            
        } catch (NumberFormatException e) {
            e.printStackTrace();
            setErrorMessage(request, "ID hợp đồng không hợp lệ. Vui lòng kiểm tra lại!");
            response.sendRedirect("listcontracts");
        } catch (RuntimeException e) {
            e.printStackTrace();
            setErrorMessage(request, "Lỗi nghiệp vụ: " + e.getMessage());
            response.sendRedirect("listcontracts");
        } catch (Exception e) {
            e.printStackTrace();
            setErrorMessage(request, "Đã xảy ra lỗi khi xóa hợp đồng: " + e.getMessage());
            response.sendRedirect("listcontracts");
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Support POST method as well for form submissions
        doGet(request, response);
    }
    
    /**
     * Set success message in session
     */
    private void setSuccessMessage(HttpServletRequest request, String message) {
        HttpSession session = request.getSession();
        session.setAttribute("message", message);
        session.setAttribute("messageType", "success");
    }
    
    /**
     * Set error message in session
     */
    private void setErrorMessage(HttpServletRequest request, String message) {
        HttpSession session = request.getSession();
        session.setAttribute("message", message);
        session.setAttribute("messageType", "danger");
    }
    
    @Override
    public String getServletInfo() {
        return "Servlet for managing contract deletion with proper validation and error handling";
    }
}