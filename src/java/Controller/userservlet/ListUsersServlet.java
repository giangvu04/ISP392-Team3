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
        //ArrayList<Users> users = dao.getUsers();
        //.setAttribute("users", users);

        if (session.getAttribute("user") != null) {
            if (user.getRoleid() == 1) {

                // Lấy trang hiện tại từ tham số URL, mặc định là 1
                int currentPage = Integer.parseInt(request.getParameter("page") != null ? request.getParameter("page") : "1");
                int productsPerPage = 10; // Số sản phẩm trên mỗi trang

                // Lấy tổng số sản phẩm cho shop hiện tại
                int totalUser = dao.getTotalUsersById();
                int totalPages = (int) Math.ceil((double) totalUser / productsPerPage);

                // Lấy danh sách sản phẩm cho trang hiện tại
                ArrayList<Users> users = dao.getUsersByPageID(currentPage, productsPerPage);

                // Thiết lập các thuộc tính cho JSP
                request.setAttribute("users", users);
                request.setAttribute("currentPage", currentPage);
                request.setAttribute("totalPages", totalPages);

                RequestDispatcher requestDispatcher = request.getRequestDispatcher("UsersManager/ListUsers.jsp");
                requestDispatcher.forward(request, response);
                return;
            } else if (user.getRoleid() == 2) {
                // Lấy trang hiện tại từ tham số URL, mặc định là 1
                int currentPage = Integer.parseInt(request.getParameter("page") != null ? request.getParameter("page") : "1");
                int productsPerPage = 10; // Số sản phẩm trên mỗi trang

                // Lấy tổng số sản phẩm cho shop hiện tại
                int totalUser = dao.getTotalUsersByRentalAreaId(user.getRentalAreaID());
                int totalPages = (int) Math.ceil((double) totalUser / productsPerPage);

                // Lấy danh sách sản phẩm cho trang hiện tại
                ArrayList<Users> user1 = dao.getUsersByPage(currentPage, productsPerPage, user.getRentalAreaID());

                // Xử lý sắp xếp
                if (sortBy != null) {
                    switch (sortBy) {
                        case "name_asc":
                            user1.sort(Comparator.comparing(Users::getUsername));
                            break;
                        case "name_desc":
                            user1.sort(Comparator.comparing(Users::getUsername).reversed());
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
                RequestDispatcher requestDispatcher = request.getRequestDispatcher("userdetail?id=" + user.getID());
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
                int productsPerPage = 10;
                // Cập nhật currentPage và totalPages
                int totalUsers = users.size(); // Tổng sản phẩm tìm được
                int totalPages = (int) Math.ceil(totalUsers / productsPerPage); // Cập nhật với số sản phẩm mỗi trang

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
