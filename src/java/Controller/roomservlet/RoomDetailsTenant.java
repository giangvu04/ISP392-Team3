/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package Controller.roomservlet;

import dal.DAODeviceInRoom;
import dal.DAOFeedBack;
import dal.DAORentalArea;
import dal.DAORooms;
import dal.DAOServices;
import dal.DAOUser;
import dal.ImageDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.ArrayList;
import java.util.List;
import model.DeviceInRoom;
import model.FeedBack;
import model.Image;
import model.RentalArea;
import model.Room;
import model.Rooms;
import model.Services;
import model.Users;

@WebServlet(name="RoomDetailsTenant", urlPatterns={"/detailRoom"})
public class RoomDetailsTenant extends HttpServlet {
   
    DAORooms dao = DAORooms.INSTANCE;
    DAOServices daos = DAOServices.INSTANCE;
    ImageDAO idao = ImageDAO.INSTANCE;
    DAOFeedBack fdao = DAOFeedBack.INSTANCE;
    DAORentalArea rdao = DAORentalArea.INSTANCE;
    DAOUser udao = DAOUser.INSTANCE;
    DAODeviceInRoom ddao = DAODeviceInRoom.INSTANCE;
    
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet RoomDetails</title>");  
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet RoomDetails at " + request.getContextPath () + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    } 

    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        String roomId = request.getParameter("id");
        try {
            int id = Integer.parseInt(roomId);
            Rooms room = dao.getRoomById(id);
            request.setAttribute("room", room);
            
            List<Services> amenities = daos.getServicesByRentalArea(room.getRentalAreaId());
            request.setAttribute("amenities", amenities);
            
            List<Image> image = idao.getImagesByRoom(id);
            request.setAttribute("image", image);
            
            List<FeedBack> feedback = fdao.getFeedBacksByRoom(id);
            request.setAttribute("feedback", feedback);
            
            RentalArea rentail = rdao.getRentalFromRoomID(id);
            request.setAttribute("rentail", rentail);
            
            Users manager = udao.getUserByID(rentail.getManagerId());
            request.setAttribute("manager", manager);
            
            ArrayList<DeviceInRoom> di = ddao.getDevicesByRoomId(id);
            request.setAttribute("di", di);
            
            System.out.println("Có tổng cộng" + image.size() +"cái ảnh");
            
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        
        
        request.getRequestDispatcher("Tenant/RoomDetails.jsp").forward(request, response);
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
