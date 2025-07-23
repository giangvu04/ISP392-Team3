package Controller.landingpage;

import Ultils.ReadFile;
import com.google.gson.Gson;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name="AddressAPI", urlPatterns={"/api/address"})
public class AddressAPI extends HttpServlet {
    
    private final Gson gson = new Gson();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        
        String type = request.getParameter("type");
        String province = request.getParameter("province");
        String district = request.getParameter("district");
        
        try {
            List<String> result = null;
            
            switch (type) {
                case "provinces":
                    result = ReadFile.loadAllProvinces(request);
                    break;
                case "districts":
                    if (province != null && !province.isEmpty()) {
                        result = ReadFile.loadDistrictsByProvince(request, province);
                    }
                    break;
                case "wards":
                    if (district != null && !district.isEmpty()) {
                        result = ReadFile.loadWardsByDistrict(request, district);
                    }
                    break;
                default:
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    response.getWriter().write("{\"error\": \"Invalid type parameter\"}");
                    return;
            }
            
            if (result != null) {
                response.getWriter().write(gson.toJson(result));
            } else {
                response.getWriter().write("[]");
            }
            
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\": \"" + e.getMessage() + "\"}");
            e.printStackTrace();
        }
    }
}
