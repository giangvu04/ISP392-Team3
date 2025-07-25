/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controller.loginservlet;

import dal.DAO;
import dal.DAOUser;
import model.Users;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.annotation.WebServlet;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.StringWriter;

/**
 *
 * @author ADMIN
 */
@WebServlet(name = "LoginServlet", urlPatterns = {"/login"})
public class LoginServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        
        if (session.getAttribute("user") != null) {
            Users user = (Users) session.getAttribute("user");
            // Redirect based on role to appropriate homepage
            redirectToHomepage(user, response);
        } else {
            // Kiểm tra có returnUrl parameter không
            String returnUrl = request.getParameter("returnUrl");
            if (returnUrl != null && !returnUrl.trim().isEmpty()) {
                // Lưu returnUrl vào session
                session.setAttribute("returnUrl", returnUrl);
            }
            
            request.setAttribute("ms", "");
            request.setAttribute("name", "");
            request.setAttribute("password", "");
            RequestDispatcher dispatcher = request.getRequestDispatcher("Login/login.jsp");
            dispatcher.forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String name = request.getParameter("name");
        String password = request.getParameter("password");
        HttpSession session = request.getSession();

        try {
            if (name != null && password != null) {
                DAOUser userDAO = new DAOUser();
                Users user = null;
                
                // Try to find user by email first, then by phone number
                user = userDAO.getUserByEmail(name);
                if (user == null) {
                    user = userDAO.getUserByPhone(name);
                }

                if (user != null && userDAO.authenticateUser(name, password) && user.isActive()) {
                    request.getSession().setAttribute("user", user);
                    session.setAttribute("user", user);
                    request.getSession().setAttribute("ms", "Đăng nhập thành công");
                    
                    // Kiểm tra có returnUrl không (từ các trang cần login)
                    String returnUrl = (String) session.getAttribute("returnUrl");
                    System.out.println("hehehe" +returnUrl);
                    if (returnUrl != null) {
                        // Xóa returnUrl khỏi session và redirect về trang đó
                        session.removeAttribute("returnUrl");
                        response.sendRedirect(returnUrl);
                    } else {
                        // Redirect về homepage theo role như bình thường
                        redirectToHomepage(user, response);
                    }
                } else {
                    request.getSession().setAttribute("error", "Hãy xem lại tài khoản và mật khẩu hoặc tài khoản đã bị vô hiệu hóa!");
                    request.setAttribute("name", name);
                    request.setAttribute("password", password);
                    response.sendRedirect("login");
                }
            } else {
                request.getSession().setAttribute("error", "Vui lòng nhập tài khoản và mật khẩu!");
                response.sendRedirect("login");
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("name", name);
            request.setAttribute("password", password);
            request.getSession().setAttribute("message", "Có lỗi xảy ra. Vui lòng thử lại!");
            request.getSession().setAttribute("error", "Vui lòng nhập tài khoản và mật khẩu!");
            response.sendRedirect("login");
        }
    }

    private void redirectToHomepage(Users user, HttpServletResponse response) throws IOException {
        int roleId = user.getRoleId();
        if (roleId == 1) {
            // Admin - redirect to admin homepage
            response.sendRedirect("AdminHomepage");
        } else if (roleId == 2) {
            // Manager - redirect to manager homepage or room list
            response.sendRedirect("ManagerHomepage");
        } else if (roleId == 3) {
            // Tenant - redirect to tenant homepage or room list
            response.sendRedirect("TenantHomepage");
        } else {
            // Invalid role - redirect to login with error
            response.sendRedirect("login?error=invalid_role");
        }
    }

    @Override
    public String getServletInfo() {
        return "Login Servlet";
    }
}
