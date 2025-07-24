/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package Controller.landingpage;

import dal.DAORentalPost;
import dal.DAOPostRoom;
import dal.ImageDAO;
import dal.DAOServices;
import dal.DAOUser;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;
import model.RentalPost;
import model.PostRoom;
import model.Image;
import model.Services;
import model.Users;


@WebServlet(name="RoomDetails", urlPatterns={"/roomDetail"})
public class RoomDetails extends HttpServlet {
   
    private final DAORentalPost rentalPostDAO = DAORentalPost.INSTANCE;
    private final DAOPostRoom postRoomDAO = DAOPostRoom.INSTANCE;
    private final ImageDAO imageDAO = ImageDAO.INSTANCE;
    private final DAOServices servicesDAO = DAOServices.INSTANCE;
    private final DAOUser userDAO = DAOUser.INSTANCE;
   
   
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
        String postIdParam = request.getParameter("id");
        
        if (postIdParam == null || postIdParam.trim().isEmpty()) {
            response.sendRedirect("./");
            return;
        }
        
        try {
            int postId = Integer.parseInt(postIdParam);
            
            // Lấy thông tin rental post
            RentalPost rentalPost = rentalPostDAO.getPostById(postId);
            if (rentalPost == null) {
                response.sendRedirect("./");
                return;
            }
            
            // Tăng view count
            rentalPostDAO.incrementViewCount(postId);
            
            // Lấy thông tin chủ nhà/manager
            Users manager = userDAO.getUserByID(rentalPost.getManagerId());
            
            // Lấy danh sách phòng của post này
            List<PostRoom> postRooms = postRoomDAO.getRoomsByPost(postId);
            System.out.println("Debug - Number of rooms found: " + (postRooms != null ? postRooms.size() : "null"));
            
            // Debug: in ra thông tin phòng và giá
            if (postRooms != null && !postRooms.isEmpty()) {
                for (PostRoom room : postRooms) {
                    System.out.println("Debug - Room " + room.getRoomNumber() + " - Price: " + room.getRoomPrice());
                }
            }
            
            // Lấy dịch vụ của khu trọ
            List<Services> services = servicesDAO.getServicesByRentalArea(rentalPost.getRentalAreaId());
            
            // Lấy ảnh phòng (từ phòng đầu tiên nếu có)
            List<Image> images = null;
            if (!postRooms.isEmpty()) {
                PostRoom firstRoom = postRooms.get(0);
                images = imageDAO.getImagesByRoom(firstRoom.getRoomId());
            }
            
            // Set attributes
            request.setAttribute("rentalPost", rentalPost);
            request.setAttribute("manager", manager);
            request.setAttribute("postRooms", postRooms);
            request.setAttribute("services", services);
            request.setAttribute("images", images);
            
        } catch (NumberFormatException e) {
            response.sendRedirect("./");
            return;
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        request.getRequestDispatcher("/LandingPage/RoomDetails.jsp").forward(request, response);
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
