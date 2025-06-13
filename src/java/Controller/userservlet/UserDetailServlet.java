package Controller.userservlet;

import dal.DAOUser;
import model.Users;
import jakarta.servlet.RequestDispatcher;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 *
 * @author ADMIN
 */
public class UserDetailServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Users currentUser = (Users) session.getAttribute("user");
        
        if (currentUser == null) {
            response.sendRedirect("login");
            return;
        }

        String userIdParam = request.getParameter("id");
        if (userIdParam == null || userIdParam.trim().isEmpty()) {
            request.setAttribute("error", "ID người dùng không hợp lệ!");
            response.sendRedirect("listusers");
            return;
        }

        try {
            int userId = Integer.parseInt(userIdParam);
            DAOUser dao = new DAOUser();
            Users userDetail = dao.getUserByID(userId);
            
            if (userDetail == null) {
                request.setAttribute("error", "Không tìm thấy người dùng!");
                response.sendRedirect("listusers");
                return;
            }

            // Check permissions based on roles
            int sessionRole = currentUser.getRoleId();
            int userRole = userDetail.getRoleId();
            
            // Admin can view anyone
            // Manager can view tenants
            // Tenant can only view themselves
            if (sessionRole == 1 || 
                (sessionRole == 2 && userRole == 3) || 
                (sessionRole == 3 && currentUser.getUserId() == userId)) {
                
                request.setAttribute("userDetail", userDetail);
                request.setAttribute("currentUser", currentUser);
                
                String jspPath;
                if (sessionRole == 1) {
                    jspPath = "Admin/UserDetail.jsp";
                } else if (sessionRole == 2) {
                    jspPath = "Manager/TenantDetail.jsp";
                } else {
                    jspPath = "Tenant/Profile.jsp";
                }
                
                RequestDispatcher dispatcher = request.getRequestDispatcher(jspPath);
                dispatcher.forward(request, response);
            } else {
                request.setAttribute("error", "Bạn không có quyền xem thông tin người dùng này!");
                response.sendRedirect("listusers");
            }

        } catch (NumberFormatException e) {
            request.setAttribute("error", "ID người dùng không hợp lệ!");
            response.sendRedirect("listusers");
        } catch (Exception e) {
            request.setAttribute("error", "Có lỗi xảy ra: " + e.getMessage());
            e.printStackTrace();
            response.sendRedirect("listusers");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }

    @Override
    public String getServletInfo() {
        return "User Detail Servlet";
    }
}
