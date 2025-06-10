<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.util.ArrayList" %>
<%@ page import="model.Users" %>
<%@ page import="dal.DAOUser" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Quản lý Admin</title>
        <link rel="stylesheet" href="css/product.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.7.2/css/all.min.css" integrity="sha512-Evv84Mr4kqVGRNSgIGL/F/aIDqQb7xQ2vcrdIwxfjThSH8CSR7PBEakCr51Ck+w+/U6swU2Im1vVX0SVk9ABhg==" crossorigin="anonymous" referrerpolicy="no-referrer" />
    </head>
    <body>
        <%
                DAOUser dao = new DAOUser();
                Users u = (Users) request.getAttribute("user");
                ArrayList<Users> users = (ArrayList<Users>) request.getAttribute("users");
        %>
        <%
            Integer currentPage = (Integer) request.getAttribute("currentPage");
            Integer totalPages = (Integer) request.getAttribute("totalPages");

            // Kiểm tra xem các biến có được nhận hay không
            if (currentPage == null || totalPages == null) {
                out.println("<script>alert('Không thể nhận được currentPage hoặc totalPages.');</script>");
            }
        %>

        <div class="header">
            <div class="container">
                <img src="Image/logo.png" alt="logo" class="home-logo">
            </div>
            <div class="header__navbar-item navbar__user">
                <span class="navbar__user--name">
                    <%= u.getFullName()%>
                </span>
                <div class="navbar__user--info">
                    <div class="navbar__info--wrapper">
                        <a href="userdetail?id=<%= u.getID()%>" class="navbar__info--item">Tài khoản của tôi</a>
                    </div>
                    <div class="navbar__info--wrapper">
                        <a href="logout" class="navbar__info--item">Đăng xuất</a>
                    </div>
                </div>
            </div>
        </div>

        <div class="body">
            <div class="body-container">
                <div class="mainmenu">
                    <ul class="mainmenu-list row no-gutters">
                        <li class="mainmenu__list-item"><a href="listusers"><i class="fa-solid fa-user list-item-icon"></i>Tài Khoản</a></li>
                    </ul>
                </div>

                <div class="homepage-body">
                    <div class="body-head">
                        <h3 class="body__head-title">Thông tin tài khoản</h3>
                        <div class="search-container">
                            <form action="listusers" method="post">
                                <input type="text" id="information" name="information" placeholder="Tìm kiếm người dùng..." class="search-input">
                                <button type="submit" class="search-button">Search</button>
                            </form>
                            <% String message = (String) request.getAttribute("message"); %>
                            <% if (message != null && !message.isEmpty()) { %>
                            <div id="toast-message" class="toast-message"><%= message %></div>
                            <% } %>

                            <script>
                                window.onload = function () {
                                    var toast = document.getElementById("toast-message");
                                    if (toast) {
                                        toast.style.display = "block"; // Hiển thị thông báo
                                        setTimeout(function () {
                                            toast.style.opacity = "0";
                                            setTimeout(() => toast.style.display = "none", 500);
                                        }, 3000);
                                    }
                                };
                            </script>
                            <form action="listusers" method="get">
                                <select name="sortBy" class="sort-dropdown" onchange="this.form.submit()">
                                    <option class="dropdown-default" value="" disabled selected>Sắp xếp theo</option>
                                    <option class="dropdown-value" value="name_asc">Tên A → Z</option>
                                    <option class="dropdown-value" value="name_desc">Tên Z → A</option>
                                </select>
                            </form>
                            <a href="register" class="add-product-button">Thêm tài khoản</a>
                        </div>
                    </div>
                    <div class="table-container">
                        <table class="product-table">
                            <thead>
                                <tr class="table-header">
                                    <th class="table-header-item">ID</th>
                                    <th class="table-header-item">Tài khoản</th>
                                    <th class="table-header-item">Vai trò</th>
                                    <th class="table-header-item">Tên</th>
                                    <th class="table-header-item">Hành động</th>
                                </tr>
                            </thead>
                            <tbody>
                                <%
                                    for (Users user : users) {
                                %>
                                <tr class="table-row">
                                    <td class="table-cell"><%= user.getID() %></td>
                                    <td class="table-cell"><%= user.getUsername() %></td>
                                    <td class="table-cell"><% 
                                                                if (user.getRoleid() == 1) {
                                                                    out.print("Admin");
                                                                } else if (user.getRoleid() == 2) {
                                                                    out.print("Quản Lý");
                                                                } else {
                                                                    out.print("Người thuê nhà");
                                                                }
                                       
                                        %></td>
                                    <td class="table-cell"><%= user.getFullName() %></td>
                                    <td class="table-cell">
                                        <button class="action-button" onclick="window.location.href = 'userdetail?id=<%= user.getID() %>'">Thông tin chi tiết</button>
                                        <button class="action-button" onclick="window.location.href = 'updateuser?id=<%= user.getID() %>'">Chỉnh sửa</button>
                                        <% if(u.getRoleid() < user.getRoleid()){ %>
                                        <button class="action-button" onclick="if (confirm('Bạn có chắc chắn muốn xóa?')) {
                                                    window.location.href = 'deleteuser?deleteid=<%= user.getID() %>&userid=<%= u.getID() %>';
                                                }">Xóa</button>  
                                        <button class="action-button" onclick="if (confirm('Bạn có muốn đặt lại mật khẩu thành : 12345678 ?')) {
                                                    window.location.href = 'resetpassword?resetid=<%= user.getID() %>';
                                                }">Đặt lại mật khẩu</button> 

                                        <%
                                            }
                                        %>

                                    </td>
                                </tr>
                                <% 
                                        
                                    }
                                %>
                            </tbody>
                        </table>
                    </div>

                    <!-- Pagination -->

                    <div class="pagination">
                        <div class="pagination-controls">
                            <button 
                                class="pagination-button" 
                                <% if (currentPage <= 1) { %> disabled <% }%> 
                                onclick="window.location.href = 'listusers?page=<%= currentPage - 1%>'">Trước</button>

                            <span class="pagination-info">Trang <%= currentPage%> / <%= totalPages%></span>

                            <button 
                                class="pagination-button" 
                                <% if (currentPage >= totalPages) { %> disabled <% }%> 
                                onclick="window.location.href = 'listusers?page=<%= currentPage + 1%>'">Sau</button>
                        </div>
                    </div>

                </div>
            </div>
        </div>


        <div class="footer">
            <div class="container">
                <p>&copy; 2025 Công ty TNHH G3. Tất cả quyền được bảo lưu.</p>
            </div>
        </div>
    </body>
</html>
