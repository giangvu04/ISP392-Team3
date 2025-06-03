/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controller.loginservlet;

import dal.DAO;
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
import java.io.StringWriter;

/**
 *
 * @author ADMIN
 */
public class LoginServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();

        if (session.getAttribute("user") != null) {
            response.sendRedirect("listrooms");
        } else {
            request.setAttribute("message", "");
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
                Users user = userDAO.getUserByName(name);

                if (user != null && (userDAO.authenticateUser(name, password) && user.getIsDelete() == 0)) {
                    if (user.getIsDelete() != 0) {
                        request.setAttribute("message", "Hãy xem lại tài khoản và mật khẩu!");
                        request.setAttribute("name", name);
                        request.setAttribute("password", password);
                        RequestDispatcher dispatcher = request.getRequestDispatcher("Login/login.jsp");
                        dispatcher.forward(request, response);
                        return;
                    } else {
                        session.setAttribute("user", user);
                        
                    }
                } else {
                    request.setAttribute("message", "Hãy xem lại tài khoản và mật khẩu!");
                    request.setAttribute("name", name);
                    request.setAttribute("password", password);
                    RequestDispatcher dispatcher = request.getRequestDispatcher("Login/login.jsp");
                    dispatcher.forward(request, response);
                }
            } else {
                response.sendRedirect("Login/login.jsp");
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("name", name);
            request.setAttribute("password", password);
            request.setAttribute("message", "Something went wrong. Please try again.");
            RequestDispatcher dispatcher = request.getRequestDispatcher("Login/login.jsp");
            dispatcher.forward(request, response);
        }

    }

    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
