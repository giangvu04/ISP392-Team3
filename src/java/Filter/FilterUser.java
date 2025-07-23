/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Filter.java to edit this template
 */
package Filter;

import java.io.IOException;
import java.io.PrintStream;
import java.io.PrintWriter;
import java.io.StringWriter;
import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.Users;


@WebFilter(filterName = "FilterUser", urlPatterns = {"/abc"})
public class FilterUser implements Filter {
  @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // Optional: Khởi tạo nếu cần
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;
        HttpSession session = req.getSession();
        String path = req.getRequestURI().substring(req.getContextPath().length());

        // Bỏ qua filter cho các đường dẫn login, static resource
        if (path.startsWith("/login") || path.startsWith("/Login") || 
                path.startsWith("/css") || path.startsWith("/js")
                || path.startsWith("/images") || path.endsWith(".css") 
                || path.endsWith(".js") || path.endsWith(".png") 
                || path.endsWith(".jpg") || path.endsWith(".jpeg") 
                || path.endsWith(".ico")|| path.startsWith("/registerr")
                || path.startsWith("/redirect_google") || path.startsWith("/loginGG")) {
            chain.doFilter(request, response);
            return;
        }

        Users user = (session != null) ? (Users) session.getAttribute("user") : null;
        if (user == null) {
            // Chưa đăng nhập, chuyển về trang login
            session.setAttribute("error", "Vui lòng login");
            res.sendRedirect(req.getContextPath() + "/login");
        } else {
            // Đã đăng nhập, cho đi tiếp
            chain.doFilter(request, response);
        }
    }

    @Override
    public void destroy() {
        // Optional: Dọn tài nguyên nếu cần
    }
}
