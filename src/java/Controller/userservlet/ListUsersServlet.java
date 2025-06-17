package Controller.userservlet;

import dal.DAOUser;
import model.Users;
import jakarta.servlet.RequestDispatcher;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author ADMIN
 */
public class ListUsersServlet extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet ListUsersServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet ListUsersServlet at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        DAOUser dao = new DAOUser();
        HttpSession session = request.getSession();
        request.setAttribute("message", "");
        Users user = (Users) session.getAttribute("user");
        request.setAttribute("user", user);
        String sortBy = request.getParameter("sortBy");

        if (session.getAttribute("user") != null) {
            if (user.getRoleId() == 1) {
                // Lấy trang hiện tại từ tham số URL, mặc định là 1
                int currentPage = Integer.parseInt(request.getParameter("page") != null ? request.getParameter("page") : "1");
                int usersPerPage = 10; // Số người dùng trên mỗi trang

                // Lấy tổng số người dùng
                int totalUser = dao.getTotalManagerAndTenantUsers();
                int totalPages = (int) Math.ceil((double) totalUser / usersPerPage);

                // Lấy danh sách người dùng cho trang hiện tại
                ArrayList<Users> users = dao.getManagerAndTenantUsersByPage(currentPage, usersPerPage);

                // Thiết lập các thuộc tính cho JSP
                request.setAttribute("users", users);
                request.setAttribute("currentPage", currentPage);
                request.setAttribute("totalPages", totalPages);

                RequestDispatcher requestDispatcher = request.getRequestDispatcher("UsersManager/ListUsers.jsp");
                requestDispatcher.forward(request, response);
                return;
            } else if (user.getRoleId() == 2) {
                // Lấy trang hiện tại từ tham số URL, mặc định là 1
                int currentPage = Integer.parseInt(request.getParameter("page") != null ? request.getParameter("page") : "1");
                int usersPerPage = 10; // Số người dùng trên mỗi trang

                // Lấy tổng số người dùng cho role 3 (tenant)
                int totalUser = dao.getTotalUsersByRole(3);
                int totalPages = (int) Math.ceil((double) totalUser / usersPerPage);

                // Lấy danh sách người dùng cho trang hiện tại (chỉ role 3 - tenant)
                ArrayList<Users> user1 = dao.getUsersByRole(3);

                // Xử lý sắp xếp
                if (sortBy != null) {
                    switch (sortBy) {
                        case "name_asc":
                            user1.sort(Comparator.comparing(Users::getFullName));
                            break;
                        case "name_desc":
                            user1.sort(Comparator.comparing(Users::getFullName).reversed());
                            break;
                    }
                }

                // Thiết lập các thuộc tính cho JSP
                request.setAttribute("users", user1);
                request.setAttribute("currentPage", currentPage);
                request.setAttribute("totalPages", totalPages);
                request.setAttribute("sortBy", sortBy);
                RequestDispatcher requestDispatcher = request.getRequestDispatcher("UsersManager/ListUsersForAdmin.jsp");
                requestDispatcher.forward(request, response);
                return;
            } else {
                RequestDispatcher requestDispatcher = request.getRequestDispatcher("userdetail?id=" + user.getUserId());
                requestDispatcher.forward(request, response);
                return;
            }
        }
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        String information = request.getParameter("information");

        DAOUser dao = new DAOUser();
        HttpSession session = request.getSession();
        Users user = (Users) session.getAttribute("user");
        request.setAttribute("user", user);
        if (information.equals("")) {
            RequestDispatcher requestDispatcher = request.getRequestDispatcher("listusers");
            requestDispatcher.forward(request, response);
            return;
        }
        ArrayList<Users> users = new ArrayList<>(); // Tránh lỗi null

        if (!information.equals("")) {
            try {
                users = dao.getUsersBySearch(information);
                if (users == null || users.isEmpty()) {
                    request.setAttribute("message", "Không tìm thấy kết quả nào.");
                } else {
                    request.setAttribute("message", "Kết quả tìm kiếm cho: " + information);
                }
                int usersPerPage = 10;
                // Cập nhật currentPage và totalPages
                int totalUsers = users.size(); // Tổng người dùng tìm được
                int totalPages = (int) Math.ceil((double) totalUsers / usersPerPage); // Cập nhật với số người dùng mỗi trang

                // Thiết lập các thuộc tính cho JSP
                request.setAttribute("users", users);
                request.setAttribute("currentPage", 1); // Đặt lại về trang đầu tiên
                request.setAttribute("totalPages", totalPages);

            } catch (Exception ex) {
                Logger.getLogger(ListUsersServlet.class.getName()).log(Level.SEVERE, null, ex);
            }
        }

        RequestDispatcher requestDispatcher = request.getRequestDispatcher("UsersManager/ListUsers.jsp");
        requestDispatcher.forward(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
