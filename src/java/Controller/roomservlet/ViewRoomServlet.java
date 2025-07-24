/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package Controller.roomservlet;

import dal.DAORooms;
import dal.ImageDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;
import model.Image;
import model.RentalHistory;
import model.Rooms;
import model.Users;

@WebServlet(name = "ViewRoomServlet", urlPatterns = {"/viewRoom"})
public class ViewRoomServlet extends HttpServlet {

    private DAORooms dao = DAORooms.INSTANCE;
    private ImageDAO idao = ImageDAO.INSTANCE;

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet ViewRoomServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet ViewRoomServlet at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String roomID = request.getParameter("roomId");
        Users user = (Users) request.getSession().getAttribute("user");
        if (roomID == null || roomID.isEmpty()) {
            request.getSession().setAttribute("erorr", "Vui lòng chọn phòng");
            response.sendRedirect("listrooms");
            return;
        }
        if (user == null) {
            request.getSession().setAttribute("error", "Phiên đã hết hạn vui lòng login lại!");
            response.sendRedirect("login");
            return;
        }
        try {
            int roomIDnew = Integer.parseInt(roomID);
            boolean isOke = dao.checkExistRoomForManager(roomIDnew, user.getUserId());
            if (!isOke) {
                request.getSession().setAttribute("error", "Phòng này không phải phòng của bạn!");
                response.sendRedirect("listrooms");
                return;
            } else {
                Rooms rooms = dao.getRoomById(roomIDnew);
                List<Image> image = idao.getImagesByRoom(roomIDnew);
                // Lấy 5 hợp đồng gần nhất của phòng
                List<model.Contracts> contracts = dal.DAOContract.INSTANCE.getTop5ContractsByRoom(roomIDnew);
                request.setAttribute("contracts", contracts);
                request.setAttribute("image", image);
                request.setAttribute("rooms", rooms);
                request.getRequestDispatcher("RoomsManager/ViewRoom.jsp").forward(request, response);
            }
        } catch (Exception e) {
        }

    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
