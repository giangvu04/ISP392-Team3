package Controller.userservlet;

import dal.DAOUser;
import model.Users;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import com.google.gson.Gson;

@WebServlet(name = "searchUserByEmail", urlPatterns = {"/searchUserByEmail"})
public class searchUserByEmail extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String email = request.getParameter("email");
        ArrayList<Users> users = new ArrayList<>();
        if (email != null && !email.trim().isEmpty()) {
            try {
                users = DAOUser.INSTANCE.searchUsersByEmail(email.trim(), 10);
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        response.setContentType("application/json;charset=UTF-8");
        PrintWriter out = response.getWriter();
        Gson gson = new Gson();
        out.print(gson.toJson(users));
        out.flush();
    }
}
