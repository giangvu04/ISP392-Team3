package Controller.rental;

import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import dal.DAORooms;
import model.Users;
import com.google.gson.Gson;
import jakarta.servlet.annotation.WebServlet;
@WebServlet(name="GetRoomsByAreaServlet", urlPatterns={"/getRoom"})
public class GetRoomsByAreaServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        HttpSession session = request.getSession();
        Users user = (Users) session.getAttribute("user");
        
        // Kiểm tra đăng nhập và quyền manager
        if (user == null || user.getRoleId()!= 2) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            return;
        }
        
        try {
            String areaIdStr = request.getParameter("areaId");
            if (areaIdStr == null || areaIdStr.trim().isEmpty()) {
                response.getWriter().write("[]");
                return;
            }
            
            int areaId = Integer.parseInt(areaIdStr);
            
            DAORooms roomDAO = new DAORooms();
            // Lấy danh sách phòng trống trong khu trọ
            var rooms = roomDAO.getRoomsByArea(areaId);
            
            Gson gson = new Gson();
            String jsonRooms = gson.toJson(rooms);
            
            PrintWriter out = response.getWriter();
            out.print(jsonRooms);
            out.flush();
            
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\": \"" + e.getMessage() + "\"}");
        }
    }
}
