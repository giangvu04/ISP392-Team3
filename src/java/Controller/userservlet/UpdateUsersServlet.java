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
public class UpdateUsersServlet extends HttpServlet {

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
            Users userToUpdate = dao.getUserByID(userId);
            
            if (userToUpdate == null) {
                request.setAttribute("error", "Không tìm thấy người dùng!");
                response.sendRedirect("listusers");
                return;
            }

            // Check permissions based on roles
            int sessionRole = currentUser.getRoleId();
            int userRole = userToUpdate.getRoleId();
            
            // Admin can update anyone
            // Manager can only update tenants
            // Tenant can only update themselves
            if (sessionRole == 1 || 
                (sessionRole == 2 && userRole == 3) || 
                (sessionRole == 3 && currentUser.getUserId() == userId)) {
                
                request.setAttribute("user", userToUpdate);
                request.setAttribute("currentUser", currentUser);
                
                String jspPath;
                if (sessionRole == 1) {
                    jspPath = "Admin/EditUser.jsp";
                } else if (sessionRole == 2) {
                    jspPath = "Manager/EditTenant.jsp";
                } else {
                    jspPath = "Tenant/EditProfile.jsp";
                }
                
                RequestDispatcher dispatcher = request.getRequestDispatcher(jspPath);
                dispatcher.forward(request, response);
            } else {
                request.setAttribute("error", "Bạn không có quyền chỉnh sửa người dùng này!");
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
            Users userToUpdate = dao.getUserByID(userId);
            
            if (userToUpdate == null) {
                request.setAttribute("error", "Không tìm thấy người dùng!");
                response.sendRedirect("listusers");
                return;
            }

            // Check permissions
            int sessionRole = currentUser.getRoleId();
            int userRole = userToUpdate.getRoleId();
            
            if (!(sessionRole == 1 || 
                  (sessionRole == 2 && userRole == 3) || 
                  (sessionRole == 3 && currentUser.getUserId() == userId))) {
                request.setAttribute("error", "Bạn không có quyền chỉnh sửa người dùng này!");
                response.sendRedirect("listusers");
                return;
            }

            // Get form parameters
            String fullName = request.getParameter("fullName");
            String phoneNumber = request.getParameter("phoneNumber");
            String email = request.getParameter("email");
            String password = request.getParameter("password");
            String citizenId = request.getParameter("citizenId");
            String address = request.getParameter("address");
            String roleIdParam = request.getParameter("roleId");

            // Validate required fields
            if (fullName == null || fullName.trim().isEmpty() ||
                phoneNumber == null || phoneNumber.trim().isEmpty() ||
                email == null || email.trim().isEmpty()) {
                
                request.setAttribute("error", "Vui lòng điền đầy đủ thông tin bắt buộc!");
                request.setAttribute("user", userToUpdate);
                request.setAttribute("currentUser", currentUser);
                
                String jspPath = sessionRole == 1 ? "Admin/EditUser.jsp" : 
                               sessionRole == 2 ? "Manager/EditTenant.jsp" : "Tenant/EditProfile.jsp";
                RequestDispatcher dispatcher = request.getRequestDispatcher(jspPath);
                dispatcher.forward(request, response);
                return;
            }

            // Check if email already exists (if changed)
            if (!email.equals(userToUpdate.getEmail()) && dao.checkEmailExists(email)) {
                request.setAttribute("error", "Email đã tồn tại!");
                request.setAttribute("user", userToUpdate);
                request.setAttribute("currentUser", currentUser);
                
                String jspPath = sessionRole == 1 ? "Admin/EditUser.jsp" : 
                               sessionRole == 2 ? "Manager/EditTenant.jsp" : "Tenant/EditProfile.jsp";
                RequestDispatcher dispatcher = request.getRequestDispatcher(jspPath);
                dispatcher.forward(request, response);
                return;
            }

            // Check if phone number already exists (if changed)
            if (!phoneNumber.equals(userToUpdate.getPhoneNumber()) && dao.checkPhoneExists(phoneNumber)) {
                request.setAttribute("error", "Số điện thoại đã tồn tại!");
                request.setAttribute("user", userToUpdate);
                request.setAttribute("currentUser", currentUser);
                
                String jspPath = sessionRole == 1 ? "Admin/EditUser.jsp" : 
                               sessionRole == 2 ? "Manager/EditTenant.jsp" : "Tenant/EditProfile.jsp";
                RequestDispatcher dispatcher = request.getRequestDispatcher(jspPath);
                dispatcher.forward(request, response);
                return;
            }

            // Update user information
            userToUpdate.setFullName(fullName);
            userToUpdate.setPhoneNumber(phoneNumber);
            userToUpdate.setEmail(email);
            userToUpdate.setCitizenId(citizenId);
            userToUpdate.setAddress(address);
            
            // Only update password if provided
            if (password != null && !password.trim().isEmpty()) {
                if (password.length() < 6) {
                    request.setAttribute("error", "Mật khẩu phải có ít nhất 6 ký tự!");
                    request.setAttribute("user", userToUpdate);
                    request.setAttribute("currentUser", currentUser);
                    
                    String jspPath = sessionRole == 1 ? "Admin/EditUser.jsp" : 
                                   sessionRole == 2 ? "Manager/EditTenant.jsp" : "Tenant/EditProfile.jsp";
                    RequestDispatcher dispatcher = request.getRequestDispatcher(jspPath);
                    dispatcher.forward(request, response);
                    return;
                }
                userToUpdate.setPasswordHash(password);
            }

            // Only admin can change roles
            if (sessionRole == 1 && roleIdParam != null && !roleIdParam.trim().isEmpty()) {
                try {
                    int newRoleId = Integer.parseInt(roleIdParam);
                    if (newRoleId >= 1 && newRoleId <= 3) {
                        userToUpdate.setRoleId(newRoleId);
                    }
                } catch (NumberFormatException e) {
                    // Ignore invalid role ID
                }
            }

            // Update the user
            dao.updateUser(userToUpdate);
            
            // Update session if user is updating their own profile
            if (currentUser.getUserId() == userId) {
                session.setAttribute("user", userToUpdate);
            }
            
            request.setAttribute("success", "Cập nhật thông tin thành công!");
            response.sendRedirect("listusers");

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
    public String getServletInfo() {
        return "Update Users Servlet";
    }
}
