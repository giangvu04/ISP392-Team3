<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.util.ArrayList" %>
<%@ page import="model.Rooms" %>
<%@ page import="model.Users" %>
<%@ page import="dal.DAORooms" %>
<%@ page import="dal.DAOUser" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Locale" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Danh sách phòng</title>
        <base href="${pageContext.request.contextPath}/">
        <link rel="stylesheet" href="css/product.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.7.2/css/all.min.css">
    </head>

    <body>
        <%
            DAOUser dao = new DAOUser();
            Users u = (Users) request.getAttribute("user");
            ArrayList<Rooms> rooms = (ArrayList<Rooms>) request.getAttribute("rooms");
            NumberFormat currencyFormat = NumberFormat.getInstance(new Locale("vi", "VN"));
        %>
        <%
            Integer currentPage = (Integer) request.getAttribute("currentPage");
            Integer totalPages = (Integer) request.getAttribute("totalPages");

            // Kiểm tra xem các biến có được nhận hay không
            if (currentPage == null || totalPages == null) {
                out.println("<script>alert('Không thể nhận được currentPage hoặc totalPages.');</script>");
            }
        %>

        <!-- Header -->
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
                <!-- Menu Sidebar -->
                <jsp:include page="../Sidebar/SideBarTelnant.jsp"/>

                <!-- Main Content -->
                <div class="homepage-body">
                    <div class="body-head">
                        <h3 class="body__head-title">Danh sách phòng</h3>
                        <div class="search-container">
                            <!-- Search Form -->
                            <form action="listrooms" method="post">
                                <input type="text" id="information" name="information" 
                                       placeholder="Tìm kiếm phòng..." class="search-input">
                                <input type="submit" class="search-button" value="Tìm kiếm">
                            </form>

                            <% if (message != null && !message.isEmpty()) { %>
                            <div id="toast-message" class="toast-message"><%= message %></div>
                            <% } %>

                            <!-- Sort Dropdown -->
                            <form action="listrooms" method="get">
                                <select name="sortBy" class="sort-dropdown" onchange="this.form.submit()">
                                    <option value="" disabled selected>Sắp xếp theo</option>
                                    <option value="price_asc">Giá tăng dần</option>
                                    <option value="price_desc">Giá giảm dần</option>
                                    <option value="status_asc">Trạng thái (trống trước)</option>
                                    <option value="status_desc">Trạng thái (đã thuê trước)</option>
                                    <option value="address_asc">Địa chỉ A-Z</option>
                                    <option value="address_desc">Địa chỉ Z-A</option>
                                    <option value="type_asc">Loại phòng A-Z</option>
                                    <option value="type_desc">Loại phòng Z-A</option>
                                </select>
                            </form>
                        </div>
                    </div>

                    <!-- Rooms Table -->
                    <div class="table-container">
                        <table class="product-table">
                            <thead>
                                <tr class="table-header">
                                    <th class="table-header-item">Hình ảnh</th>
                                    <th class="table-header-item">Mã phòng</th>
                                    <th class="table-header-item">Địa chỉ</th>
                                    <th class="table-header-item">Giá thuê</th>
                                    <th class="table-header-item">Loại phòng</th>
                                    <th class="table-header-item">Mô tả</th>
                                    <th class="table-header-item">Trạng thái</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% for (Rooms room : rooms) { %>
                                <tr class="table-row">
                                    <td class="table-cell">
                                        <img src="<%= room.getImageLink() != null ? room.getImageLink() : "Image/default-room.jpg" %>" 
                                             alt="<%= room.getAddress() %>" class="product-image">
                                    </td>
                                    <td class="table-cell"><%= room.getRoomID() %></td>
                                    <td class="table-cell"><%= room.getAddress() %></td>
                                    <td class="table-cell"><%= currencyFormat.format(room.getPrice()) %> VND/tháng</td>
                                    <td class="table-cell"><%= room.getRoomType() %></td>
                                    <td class="table-cell description"><%= room.getDescription() %></td>
                                    <td class="table-cell">
                                        <span class="status-badge <%= room.isStatus() ? "status-occupied" : "status-available" %>">
                                            <%= room.isStatus() ? "Đã thuê" : "Trống" %>
                                        </span>
                                    </td>
                                </tr>
                                <% } %>
                            </tbody>
                        </table>
                    </div>

                    <!-- Pagination -->
                    <div class="pagination">
                        <div class="pagination-controls">
                            <button class="pagination-button" 
                                    <% if (currentPage <= 1) { %> disabled <% } %>
                                    onclick="window.location.href = 'listrooms?page=<%= currentPage - 1 %>'">
                                Trước
                            </button>

                            <span class="pagination-info">Trang <%= currentPage %> / <%= totalPages %></span>

                            <button class="pagination-button" 
                                    <% if (currentPage >= totalPages) { %> disabled <% } %>
                                    onclick="window.location.href = 'listrooms?page=<%= currentPage + 1 %>'">
                                Sau
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Footer -->
        <div class="footer">
            <div class="container">
                <p>&copy; 2025 Công ty TNHH G3. Tất cả quyền được bảo lưu.</p>
            </div>
        </div>

        <!-- Toast Message Script -->
        <script>
            window.onload = function () {
                var toast = document.getElementById("toast-message");
                if (toast) {
                    toast.style.display = "block";
                    setTimeout(function () {
                        toast.style.opacity = "0";
                        setTimeout(() => toast.style.display = "none", 500);
                    }, 3000);
                }
            };
        </script>
    </body>
</html>
