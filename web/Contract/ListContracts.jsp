<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="java.util.ArrayList" %>
<%@ page import="model.Contracts" %>
<%@ page import="model.Users" %>
<%@ page import="dal.DAOContract" %>
<%@ page import="dal.DAOUser" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Locale" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Danh sách hợp đồng</title>
        <base href="${pageContext.request.contextPath}/">
        <link rel="stylesheet" href="css/product.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.7.2/css/all.min.css">
    </head>

    <body>
        <%
            DAOUser dao = new DAOUser();
            Users u = (Users) request.getAttribute("user");
            ArrayList<Contracts> contracts = (ArrayList<Contracts>) request.getAttribute("contracts");
            NumberFormat currencyFormat = NumberFormat.getInstance(new Locale("vi", "VN"));
            SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy");
        %>
        <%
            Integer currentPage = (Integer) request.getAttribute("currentPage");
            Integer totalPages = (Integer) request.getAttribute("totalPages");
            String message = (String) request.getAttribute("message");

            // Kiểm tra xem các biến có được nhận hay không
            if (currentPage == null || totalPages == null) {
                out.println("<script>alert('Không thể nhận được currentPage hoặc totalPages.');</script>");
            }
        %>

        <!-- Header -->
        <%--<div class="header">
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
        </div>--%>

        <div class="body">
            <div class="body-container">
                <!-- Menu Sidebar -->
                <div class="mainmenu">
                    <ul class="mainmenu-list row no-gutters">
                        <li class="mainmenu__list-item"><a href="listrooms"><i class="fa-solid fa-door-closed list-item-icon"></i>Phòng</a></li>
                        <li class="mainmenu__list-item"><a href="listservices"><i class="fa-solid fa-bell-concierge list-item-icon"></i>Dịch vụ</a></li>
                        <li class="mainmenu__list-item"><a href="listcontracts"><i class="fa-solid fa-file-signature list-item-icon"></i>Hợp đồng</a></li>
                        <li class="mainmenu__list-item"><a href="listinvoices"><i class="fa-solid fa-receipt list-item-icon"></i>Hóa đơn</a></li>
                    </ul>
                </div>

                <!-- Main Content -->
                <div class="homepage-body">
                    <div class="body-head">
                        <h3 class="body__head-title">Danh sách hợp đồng</h3>
                        <div class="search-container">
                            <!-- Search Form -->
                            <form action="listcontracts" method="post">
                                <input type="text" id="information" name="information" 
                                       placeholder="Tìm kiếm hợp đồng..." class="search-input">
                                <input type="submit" class="search-button" value="Tìm kiếm">
                            </form>

                            <% if (message != null && !message.isEmpty()) { %>
                            <div id="toast-message" class="toast-message"><%= message %></div>
                            <% } %>

                            <!-- Sort Dropdown -->
                            <form action="listcontracts" method="get">
                                <select name="sortBy" class="sort-dropdown" onchange="this.form.submit()">
                                    <option value="" disabled selected>Sắp xếp theo</option>
                                    <option value="start_date_asc">Ngày bắt đầu tăng dần</option>
                                    <option value="start_date_desc">Ngày bắt đầu giảm dần</option>
                                    <option value="end_date_asc">Ngày kết thúc tăng dần</option>
                                    <option value="end_date_desc">Ngày kết thúc giảm dần</option>
                                    <option value="price_asc">Giá thuê tăng dần</option>
                                    <option value="price_desc">Giá thuê giảm dần</option>
                                    <option value="room_asc">Phòng A-Z</option>
                                    <option value="room_desc">Phòng Z-A</option>
                                </select>
                            </form>
                        </div>
                    </div>

                    <!-- Contracts Table -->
                    <div class="table-container">
                        <table class="product-table">
                            <thead>
                                <tr class="table-header">
                                    <th class="table-header-item">Mã hợp đồng</th>
                                    <th class="table-header-item">Phòng</th>
                                    <th class="table-header-item">Giá thuê</th>
                                    <th class="table-header-item">Ngày bắt đầu</th>
                                    <th class="table-header-item">Ngày kết thúc</th>
                                    <th class="table-header-item">Tiền cọc</th>
                                    <th class="table-header-item">Số người thuê</th>
                                    <th class="table-header-item">Ghi chú</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% if (contracts != null && !contracts.isEmpty()) {
                                    for (Contracts contract : contracts) { %>
                                <tr class="table-row">
                                    <td class="table-cell"><%= contract.getContractId() %></td>
                                    <td class="table-cell">Phòng <%= contract.getRoomID() %></td>
                                    <td class="table-cell"><%= currencyFormat.format(contract.getDealPrice()) %> VND/tháng</td>
                                    <td class="table-cell"><%= dateFormat.format(contract.getStartDate()) %></td>
                                    <td class="table-cell"><%= dateFormat.format(contract.getEndDate()) %></td>
                                    <td class="table-cell"><%= currencyFormat.format(contract.getDepositAmount()) %> VND</td>
                                    <td class="table-cell"><%= contract.getTenantCount() %> người</td>
                                    <td class="table-cell description"><%= contract.getNote() != null ? contract.getNote() : "Không có ghi chú" %></td>
                                </tr>
                                <% }
                                } else { %>
                                <tr>
                                    <td colspan="8" class="table-cell" style="text-align: center;">Không có hợp đồng nào.</td>
                                </tr>
                                <% } %>
                            </tbody>
                        </table>
                    </div>

                    <!-- Pagination -->
                    <%--<div class="pagination">
                        <div class="pagination-controls">
                            <button class="pagination-button" 
                                    <% if (currentPage <= 1) { %> disabled <% } %>
                                    onclick="window.location.href = 'listcontracts?page=<%= currentPage - 1 %>'">
                                Trước
                            </button>

                            <span class="pagination-info">Trang <%= currentPage %> / <%= totalPages %></span>

                            <button class="pagination-button" 
                                    <% if (currentPage >= totalPages) { %> disabled <% } %>
                                    onclick="window.location.href = 'listcontracts?page=<%= currentPage + 1 %>'">
                                Sau
                            </button>
                        </div>
                    </div>--%>
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