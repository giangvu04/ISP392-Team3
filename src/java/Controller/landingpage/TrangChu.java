/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package Controller.landingpage;

import dal.DAORentalPost;
import model.RentalPost;
import Ultils.ReadFile;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;


@WebServlet(name="TrangChu", urlPatterns={"/trangchu"})
public class TrangChu extends HttpServlet {
   
   
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet TrangChu</title>");  
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet TrangChu at " + request.getContextPath () + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    } 

   
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        try {
            // Lấy DAO instance
            DAORentalPost daoRentalPost = DAORentalPost.INSTANCE;
            
            // Lấy 3 bài đăng có view cao nhất trong tháng (featured posts)
            List<RentalPost> topViewedPosts = daoRentalPost.getTopViewedPostsThisMonth(3);
            
            // Lấy 4 bài đăng mới nhất
            List<RentalPost> recentPosts = daoRentalPost.getRecentPosts(4);
            
            // Load dữ liệu địa chỉ cho search form
            List<String> provinces = ReadFile.loadAllProvinces(request);
            
            // Truyền dữ liệu vào request
            request.setAttribute("topViewedPosts", topViewedPosts);
            request.setAttribute("recentPosts", recentPosts);
            request.setAttribute("provinces", provinces);
            
            // Debug log
            System.out.println("Top viewed posts: " + (topViewedPosts != null ? topViewedPosts.size() : 0));
            System.out.println("Recent posts: " + (recentPosts != null ? recentPosts.size() : 0));
            System.out.println("Provinces loaded: " + (provinces != null ? provinces.size() : 0));
            
        } catch (Exception e) {
            System.err.println("Error in TrangChu servlet: " + e.getMessage());
            e.printStackTrace();
        }
        
        // Forward to JSP
        request.getRequestDispatcher("/LandingPage/TrangChu.jsp").forward(request, response);
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
