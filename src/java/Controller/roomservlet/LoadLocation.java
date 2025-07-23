/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package Controller.roomservlet;

import Ultils.ReadFile;
import com.google.gson.Gson;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;

@WebServlet(name="LoadLocation", urlPatterns={"/locations"})
public class LoadLocation extends HttpServlet {
 
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet LoadLocation</title>");  
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet LoadLocation at " + request.getContextPath () + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    } 

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        processRequest(request, response);
    } 

  
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        String method = request.getParameter("type");
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        Gson gson = new Gson();

        if ("district".equals(method)) {     // lấy ra action ví dụ load tỉnh huyện xã
            String province = request.getParameter("province");   // lấy ra tên tỉnh 
            List<String> districts = ReadFile.loadDistrictsByProvince(request,province);  // trả 1 list huyện
            response.getWriter().write(gson.toJson(districts));
        } else if ("ward".equals(method)) {  // lấy cái tên huyện 
            String district = request.getParameter("district");
            List<String> wards = ReadFile.loadWardsByDistrict(request,district);  // trả 1 list xã
            response.getWriter().write(gson.toJson(wards));
        } else {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"error\":\"Invalid method\"}");
        }
    }

    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
