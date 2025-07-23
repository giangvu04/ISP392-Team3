package Controller.loginservlet;

import APIKEY.Google;
import Ultils.RandomStringGenerator;

import com.google.gson.Gson;
import com.google.gson.JsonObject;
import dal.DAOUser;
import java.io.IOException;
import java.nio.charset.StandardCharsets;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.ArrayList;
import java.util.List;
import model.GoogleAccount;
import model.Users;
import org.apache.hc.client5.http.ClientProtocolException;
import org.apache.hc.client5.http.classic.HttpClient;
import org.apache.hc.client5.http.classic.methods.HttpGet;
import org.apache.hc.client5.http.classic.methods.HttpPost;
import org.apache.hc.client5.http.entity.UrlEncodedFormEntity;
import org.apache.hc.client5.http.impl.classic.CloseableHttpResponse;
import org.apache.hc.client5.http.impl.classic.HttpClients;
import org.apache.hc.core5.http.NameValuePair;
import org.apache.hc.core5.http.message.BasicNameValuePair;

@WebServlet(name = "LoginGoogle", urlPatterns = {"/loginGG"})
public class LoginGoogle extends HttpServlet {

    DAOUser udao = DAOUser.INSTANCE;

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // ✅ Đảm bảo request và response dùng UTF-8
        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        HttpSession session = request.getSession();
        String ms = "";
        String error = "";
        Users users = null;

        try {
            String code = request.getParameter("code");
            if (code == null || code.isEmpty()) {
                error = "Mã ủy quyền không hợp lệ";
                session.setAttribute("error", error);
                response.sendRedirect("login");
                return;
            }

            String accessToken = getToken(code);
            GoogleAccount gg = getUserInfo(accessToken);

            System.out.println("🔹 Tên người dùng Google (gốc): " + gg.getName());
            System.out.println("🔹 Email: " + gg.getEmail());

            if (!udao.checkEmailExists(gg.getEmail())) {
                Users user = new Users();
                user.setFullName(gg.getName());
                user.setEmail(gg.getEmail());
                user.setPasswordHash(RandomStringGenerator.generateRandomString(8));
                user.setRoleId(3);
                user.setActive(true);

                if (udao.Register(user)) {
                    users = udao.getUserByEmail(gg.getEmail());
                    request.getSession().setAttribute("user", users);
                    response.sendRedirect("TenantHomepage");
                    return;
                } else {
                    error = "Đăng kí thất bại!";
                }
            } else {
                users = udao.getUserByEmail(gg.getEmail());
                if (users == null) {
                    error = "Không tìm thấy thông tin người dùng!";
                    session.setAttribute("error", error);
                    response.sendRedirect("login");
                    return;
                }

                System.out.println("🔹 User ID: " + users.getUserId());
                session.setAttribute("user", users);
                ms = "Đăng nhập thành công!";
                redirectToHomepage(users, response);
            }

        } catch (ClientProtocolException e) {
            error = "Lỗi giao thức HTTP: " + e.getMessage();
            System.err.println("HTTP Protocol Error: " + e.getMessage());
        } catch (IOException e) {
            error = "Lỗi khi đăng nhập bằng Google: " + e.getMessage();
            System.err.println("IO Error: " + e.getMessage());
        } catch (Exception e) {
            error = "Lỗi không xác định: " + e.getMessage();
            System.err.println("Unexpected Error: " + e.getMessage());
        }

        session.setAttribute("ms", ms);
        session.setAttribute("error", error);
    }

    private void redirectToHomepage(Users user, HttpServletResponse response) throws IOException {
        int roleId = user.getRoleId();
        switch (roleId) {
            case 1 -> response.sendRedirect("AdminHomepage");
            case 2 -> response.sendRedirect("ManagerHomepage");
            case 3 -> response.sendRedirect("TenantHomepage");
            default -> response.sendRedirect("login?error=invalid_role");
        }
    }

    private String getToken(String code) throws IOException {
        HttpClient client = HttpClients.createDefault();
        HttpPost post = new HttpPost(Google.GOOGLE_LINK_GET_TOKEN);

        List<NameValuePair> params = new ArrayList<>();
        params.add(new BasicNameValuePair("client_id", Google.GOOGLE_CLIENT_ID));
        params.add(new BasicNameValuePair("client_secret", Google.GOOGLE_CLIENT_SECRET));
        params.add(new BasicNameValuePair("redirect_uri", Google.GOOGLE_REDIRECT_URI));
        params.add(new BasicNameValuePair("code", code));
        params.add(new BasicNameValuePair("grant_type", Google.GOOGLE_GRANT_TYPE));

        post.setEntity(new UrlEncodedFormEntity(params));

        try (CloseableHttpResponse response = (CloseableHttpResponse) client.execute(post)) {
            byte[] bytes = response.getEntity().getContent().readAllBytes();
            String json = new String(bytes, StandardCharsets.UTF_8); // ✅ ép UTF-8
            JsonObject jobj = new Gson().fromJson(json, JsonObject.class);
            return jobj.get("access_token").getAsString();
        }
    }

    private GoogleAccount getUserInfo(String accessToken) throws IOException {
        HttpClient client = HttpClients.createDefault();
        HttpGet get = new HttpGet(Google.GOOGLE_LINK_GET_USER_INFO + accessToken);

        try (CloseableHttpResponse response = (CloseableHttpResponse) client.execute(get)) {
            byte[] bytes = response.getEntity().getContent().readAllBytes();
            String json = new String(bytes, StandardCharsets.UTF_8); // ✅ ép UTF-8
            return new Gson().fromJson(json, GoogleAccount.class);
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
        processRequest(request, response);
    }

    @Override
    public String getServletInfo() {
        return "Xử lý đăng nhập bằng Google OAuth";
    }
}
