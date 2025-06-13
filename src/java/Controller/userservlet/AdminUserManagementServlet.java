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
import java.util.ArrayList;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author ADMIN
 */
public class AdminUserManagementServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Users currentUser = (Users) session.getAttribute("user");
        
        // Check if user is logged in and is admin
        if (currentUser == null || currentUser.getRoleId() != 1) {
            response.sendRedirect("login");
            return;
        }

        DAOUser dao = new DAOUser();
        String action = request.getParameter("action");
        
        if (action == null) {
            action = "list";
        }

        try {
            switch (action) {
                case "list":
                    listUsers(request, response, dao);
                    break;
                case "create":
                    showCreateForm(request, response);
                    break;
                case "edit":
                    showEditForm(request, response, dao);
                    break;
                case "delete":
                    deleteUser(request, response, dao);
                    break;
                case "search":
                    searchUsers(request, response, dao);
                    break;
                default:
                    listUsers(request, response, dao);
                    break;
            }
        } catch (Exception ex) {
            Logger.getLogger(AdminUserManagementServlet.class.getName()).log(Level.SEVERE, null, ex);
            request.setAttribute("error", "Có lỗi xảy ra: " + ex.getMessage());
            listUsers(request, response, dao);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        Users currentUser = (Users) session.getAttribute("user");
        
        // Check if user is logged in and is admin
        if (currentUser == null || currentUser.getRoleId() != 1) {
            response.sendRedirect("login");
            return;
        }

        DAOUser dao = new DAOUser();
        String action = request.getParameter("action");

        try {
            switch (action) {
                case "create":
                    createUser(request, response, dao);
                    break;
                case "update":
                    updateUser(request, response, dao);
                    break;
                case "updateRole":
                    updateUserRole(request, response, dao);
                    break;
                default:
                    response.sendRedirect("adminusermanagement");
                    break;
            }
        } catch (Exception ex) {
            Logger.getLogger(AdminUserManagementServlet.class.getName()).log(Level.SEVERE, null, ex);
            request.setAttribute("error", "Có lỗi xảy ra: " + ex.getMessage());
            listUsers(request, response, dao);
        }
    }

    private void listUsers(HttpServletRequest request, HttpServletResponse response, DAOUser dao) throws ServletException, IOException {
        // Get pagination parameters
        int currentPage = Integer.parseInt(request.getParameter("page") != null ? request.getParameter("page") : "1");
        int usersPerPage = 10;

        // Get total count and calculate total pages
        int totalUsers = dao.getTotalManagerAndTenantUsers();
        int totalPages = (int) Math.ceil((double) totalUsers / usersPerPage);

        // Get users for current page
        ArrayList<Users> users = dao.getManagerAndTenantUsersByPage(currentPage, usersPerPage);

        // Set attributes for JSP
        request.setAttribute("users", users);
        request.setAttribute("currentPage", currentPage);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalUsers", totalUsers);
        request.setAttribute("usersPerPage", usersPerPage);

        // Get counts for dashboard
        int managerCount = dao.getTotalUsersByRole(2);
        int tenantCount = dao.getTotalUsersByRole(3);
        request.setAttribute("managerCount", managerCount);
        request.setAttribute("tenantCount", tenantCount);

        // Handle session messages
        HttpSession session = request.getSession();
        if (session.getAttribute("success") != null) {
            request.setAttribute("success", session.getAttribute("success"));
            session.removeAttribute("success");
        }
        if (session.getAttribute("error") != null) {
            request.setAttribute("error", session.getAttribute("error"));
            session.removeAttribute("error");
        }

        RequestDispatcher dispatcher = request.getRequestDispatcher("Admin/UserManagement.jsp");
        dispatcher.forward(request, response);
    }

    private void showCreateForm(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        RequestDispatcher dispatcher = request.getRequestDispatcher("Admin/CreateUser.jsp");
        dispatcher.forward(request, response);
    }

    private void showEditForm(HttpServletRequest request, HttpServletResponse response, DAOUser dao) throws Exception {
        int userId = Integer.parseInt(request.getParameter("id"));
        Users user = dao.getUserByID(userId);
        
        if (user != null && (user.getRoleId() == 2 || user.getRoleId() == 3)) {
            request.setAttribute("user", user);
            
            // Handle session messages
            HttpSession session = request.getSession();
            if (session.getAttribute("success") != null) {
                request.setAttribute("success", session.getAttribute("success"));
                session.removeAttribute("success");
            }
            if (session.getAttribute("error") != null) {
                request.setAttribute("error", session.getAttribute("error"));
                session.removeAttribute("error");
            }
            
            RequestDispatcher dispatcher = request.getRequestDispatcher("Admin/EditUser.jsp");
            dispatcher.forward(request, response);
        } else {
            request.setAttribute("error", "Không tìm thấy người dùng hoặc người dùng không hợp lệ!");
            response.sendRedirect("adminusermanagement");
        }
    }

    private void createUser(HttpServletRequest request, HttpServletResponse response, DAOUser dao) throws Exception {
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String fullName = request.getParameter("fullName");
        String phoneNumber = request.getParameter("phoneNumber");
        String citizenId = request.getParameter("citizenId");
        String address = request.getParameter("address");
        int roleId = Integer.parseInt(request.getParameter("roleId"));

        // Validate input
        if (email == null || email.trim().isEmpty() || 
            password == null || password.trim().isEmpty() ||
            fullName == null || fullName.trim().isEmpty() ||
            phoneNumber == null || phoneNumber.trim().isEmpty()) {
            request.setAttribute("error", "Vui lòng điền đầy đủ thông tin bắt buộc!");
            request.setAttribute("email", email);
            request.setAttribute("fullName", fullName);
            request.setAttribute("phoneNumber", phoneNumber);
            request.setAttribute("citizenId", citizenId);
            request.setAttribute("address", address);
            request.setAttribute("roleId", roleId);
            showCreateForm(request, response);
            return;
        }

        // Check if email already exists
        if (dao.checkEmailExists(email)) {
            request.setAttribute("error", "Email đã tồn tại!");
            request.setAttribute("email", email);
            request.setAttribute("fullName", fullName);
            request.setAttribute("phoneNumber", phoneNumber);
            request.setAttribute("citizenId", citizenId);
            request.setAttribute("address", address);
            request.setAttribute("roleId", roleId);
            showCreateForm(request, response);
            return;
        }

        // Check if phone number already exists
        if (dao.checkPhoneExists(phoneNumber)) {
            request.setAttribute("error", "Số điện thoại đã tồn tại!");
            request.setAttribute("email", email);
            request.setAttribute("fullName", fullName);
            request.setAttribute("phoneNumber", phoneNumber);
            request.setAttribute("citizenId", citizenId);
            request.setAttribute("address", address);
            request.setAttribute("roleId", roleId);
            showCreateForm(request, response);
            return;
        }

        // Create new user
        Users newUser = new Users();
        newUser.setEmail(email.trim());
        newUser.setPasswordHash(password);
        newUser.setFullName(fullName.trim());
        newUser.setPhoneNumber(phoneNumber.trim());
        
        // Handle optional fields - set to null if empty
        if (citizenId != null && !citizenId.trim().isEmpty()) {
            newUser.setCitizenId(citizenId.trim());
        } else {
            newUser.setCitizenId(null);
        }
        
        if (address != null && !address.trim().isEmpty()) {
            newUser.setAddress(address.trim());
        } else {
            newUser.setAddress(null);
        }
        
        newUser.setRoleId(roleId);
        newUser.setActive(true);

        try {
            dao.createUser(newUser);
            // Set success message in session
            request.getSession().setAttribute("success", "Tạo người dùng thành công!");
            response.sendRedirect("adminusermanagement");
        } catch (Exception e) {
            // Set error message in session
            request.getSession().setAttribute("error", "Lỗi khi tạo người dùng: " + e.getMessage());
            response.sendRedirect("adminusermanagement?action=create");
        }
    }

    private void updateUser(HttpServletRequest request, HttpServletResponse response, DAOUser dao) throws Exception {
        int userId = Integer.parseInt(request.getParameter("id"));
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
            email == null || email.trim().isEmpty() ||
            roleIdParam == null || roleIdParam.trim().isEmpty()) {
            request.getSession().setAttribute("error", "Vui lòng điền đầy đủ thông tin bắt buộc!");
            response.sendRedirect("adminusermanagement?action=edit&id=" + userId);
            return;
        }

        int roleId = Integer.parseInt(roleIdParam);
        if (roleId != 2 && roleId != 3) {
            request.getSession().setAttribute("error", "Vai trò không hợp lệ!");
            response.sendRedirect("adminusermanagement?action=edit&id=" + userId);
            return;
        }

        Users user = dao.getUserByID(userId);
        if (user == null || (user.getRoleId() != 2 && user.getRoleId() != 3)) {
            request.getSession().setAttribute("error", "Không tìm thấy người dùng hoặc người dùng không hợp lệ!");
            response.sendRedirect("adminusermanagement");
            return;
        }

        // Check if email already exists (if changed)
        if (!email.equals(user.getEmail()) && dao.checkEmailExists(email)) {
            request.getSession().setAttribute("error", "Email đã tồn tại!");
            response.sendRedirect("adminusermanagement?action=edit&id=" + userId);
            return;
        }

        // Check if phone number already exists (if changed)
        if (!phoneNumber.equals(user.getPhoneNumber()) && dao.checkPhoneExists(phoneNumber)) {
            request.getSession().setAttribute("error", "Số điện thoại đã tồn tại!");
            response.sendRedirect("adminusermanagement?action=edit&id=" + userId);
            return;
        }

        // Update user information
        user.setFullName(fullName.trim());
        user.setPhoneNumber(phoneNumber.trim());
        user.setEmail(email.trim());
        user.setRoleId(roleId);
        
        // Handle optional fields
        if (citizenId != null && !citizenId.trim().isEmpty()) {
            user.setCitizenId(citizenId.trim());
        } else {
            user.setCitizenId(null);
        }
        
        if (address != null && !address.trim().isEmpty()) {
            user.setAddress(address.trim());
        } else {
            user.setAddress(null);
        }
        
        // Only update password if provided
        if (password != null && !password.trim().isEmpty()) {
            if (password.length() < 6) {
                request.getSession().setAttribute("error", "Mật khẩu phải có ít nhất 6 ký tự!");
                response.sendRedirect("adminusermanagement?action=edit&id=" + userId);
                return;
            }
            user.setPasswordHash(password);
        }

        try {
            if (password != null && !password.trim().isEmpty()) {
                dao.updateUserWithPassword(user);
            } else {
                dao.updateUser(user);
            }
            request.getSession().setAttribute("success", "Cập nhật người dùng thành công!");
        } catch (Exception e) {
            request.getSession().setAttribute("error", "Lỗi khi cập nhật người dùng: " + e.getMessage());
        }
        
        response.sendRedirect("adminusermanagement");
    }

    private void updateUserRole(HttpServletRequest request, HttpServletResponse response, DAOUser dao) throws Exception {
        int userId = Integer.parseInt(request.getParameter("id"));
        int newRoleId = Integer.parseInt(request.getParameter("roleId"));

        Users user = dao.getUserByID(userId);
        if (user != null && (user.getRoleId() == 2 || user.getRoleId() == 3) && (newRoleId == 2 || newRoleId == 3)) {
            try {
                dao.updateUserRole(userId, newRoleId);
                request.getSession().setAttribute("success", "Cập nhật vai trò thành công!");
            } catch (Exception e) {
                request.getSession().setAttribute("error", "Lỗi khi cập nhật vai trò: " + e.getMessage());
            }
        } else {
            request.getSession().setAttribute("error", "Không thể cập nhật vai trò!");
        }
        
        response.sendRedirect("adminusermanagement");
    }

    private void deleteUser(HttpServletRequest request, HttpServletResponse response, DAOUser dao) throws Exception {
        int userId = Integer.parseInt(request.getParameter("id"));
        
        Users user = dao.getUserByID(userId);
        if (user != null && (user.getRoleId() == 2 || user.getRoleId() == 3)) {
            try {
                dao.deleteUser(userId);
                request.getSession().setAttribute("success", "Xóa người dùng thành công!");
            } catch (Exception e) {
                request.getSession().setAttribute("error", "Lỗi khi xóa người dùng: " + e.getMessage());
            }
        } else {
            request.getSession().setAttribute("error", "Không thể xóa người dùng!");
        }
        
        response.sendRedirect("adminusermanagement");
    }

    private void searchUsers(HttpServletRequest request, HttpServletResponse response, DAOUser dao) throws ServletException, IOException {
        String searchTerm = request.getParameter("searchTerm");
        
        if (searchTerm != null && !searchTerm.trim().isEmpty()) {
            ArrayList<Users> users = dao.searchManagerAndTenantUsers(searchTerm);
            request.setAttribute("users", users);
            request.setAttribute("searchTerm", searchTerm);
            request.setAttribute("totalUsers", users.size());
            
            // Get counts for dashboard
            int managerCount = dao.getTotalUsersByRole(2);
            int tenantCount = dao.getTotalUsersByRole(3);
            request.setAttribute("managerCount", managerCount);
            request.setAttribute("tenantCount", tenantCount);
        } else {
            listUsers(request, response, dao);
            return;
        }

        RequestDispatcher dispatcher = request.getRequestDispatcher("Admin/UserManagement.jsp");
        dispatcher.forward(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Admin User Management Servlet";
    }
} 