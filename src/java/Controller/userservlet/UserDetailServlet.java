package Controller.userservlet;

import dal.DAOUser;
import jakarta.servlet.RequestDispatcher;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.ArrayList;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.Users;

/**
 *
 * @author ADMIN
 */
public class UserDetailServlet extends HttpServlet {

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        DAOUser dao = new DAOUser();
        HttpSession session = request.getSession();
        request.setAttribute("message", "");
        Users user = (Users) session.getAttribute("user");
        int userid = Integer.parseInt(request.getParameter("id"));
        request.setAttribute("user", user);
        Users users = new Users();
        try {
            users = dao.getUserByID(userid);
            int sessionRole = user.getRoleid(); // Role của người đang thao tác
                int userRole = users.getRoleid(); // Role của người bị chỉnh sửa
                int rentalid = dao.getUserByID(userid).getRentalAreaID(); // Khu vực của người bị chỉnh sửa
                int rentalid2 = user.getRentalAreaID(); // Khu vực của người thao tác

                    // Nếu người thao tác không phải là role 1, thì kiểm tra các điều kiện
                if (sessionRole != 1) {
                    // Role 3 chỉ có thể sửa người có role 3 cùng shopID
                    if (sessionRole == 3) {
                        if (userRole != 3 || rentalid != rentalid2) {
                            request.getRequestDispatcher("logout").forward(request, response);
                            return;
                        }
                    }

                    // Role 2 chỉ có thể sửa role 2 hoặc 3 cùng shopID, không sửa được role 1
                    if (sessionRole == 2) {
                        if (userRole == 1 || rentalid != rentalid2) {
                            request.getRequestDispatcher("logout").forward(request, response);
                            return;
                        }
                    }
                }
            request.setAttribute("users", users);
        } catch (Exception ex) {
            Logger.getLogger(UserDetailServlet.class.getName()).log(Level.SEVERE, null, ex);
        }
        RequestDispatcher requestDispatcher = request.getRequestDispatcher("UsersManager/UserDetails.jsp");
        requestDispatcher.forward(request, response);
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

    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
