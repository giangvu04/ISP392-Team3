<%-- 
    Document   : ListContracts
    Created on : Jun 7, 2025, 10:15:02 PM
    Author     : ADMIN
--%>
<%@ page import="model.Rooms" %>
<%@ page import="dal.DAOContract" %>
<%@ page import="model.Contracts" %>
<%@ page import="model.Users" %>
<%@ page import="java.util.ArrayList" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Danh sách Hợp Đồng</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/product.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.7.2/css/all.min.css" crossorigin="anonymous" />
</head>
<body>

<%
    //Users user = (Users) session.getAttribute("user");
    ArrayList<Contracts> contracts = (ArrayList<Contracts>) request.getAttribute("contracts");
    Integer currentPage = (Integer) request.getAttribute("currentPage");
    Integer totalPages = (Integer) request.getAttribute("totalPages");
    //int roleId = user.getRoleid(); // 1: Admin, 2: House Manager, 3: Tenant
    SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy");
%>

<!-- Header -->
<div class="header">
    <div class="container">
        <a href="home"><img src="images/logo.png" alt="logo" class="home-logo"></a>
    </div>
    <div class="header__navbar-item navbar__user">
        <span class="navbar__user--name"><%= user.getFullName() %></span>
        <div class="navbar__user--info">
            <div class="navbar__info--wrapper">
                <a href="userdetail?id=<%= user.getID() %>" class="navbar__info--item">Tài khoản của tôi</a>
            </div>
            <div class="navbar__info--wrapper">
                <a href="logout" class="navbar__info--item">Đăng xuất</a>
            </div>
        </div>
    </div>
</div>

<!-- Main Body -->
<div class="body">
    <div class="body-container">
        <!-- Sidebar -->
        <div class="mainmenu">
            <ul class="mainmenu-list row no-gutters">
                <li class="mainmenu__list-item"><a href="listrooms"><i class="fa-solid fa-door-closed list-item-icon"></i>Phòng</a></li>
                <li class="mainmenu__list-item"><a href="listservices"><i class="fa-solid fa-bell-concierge list-item-icon"></i>Dịch vụ</a></li>
                <li class="mainmenu__list-item"><a href="listcontracts"><i class="fa-solid fa-file-contract list-item-icon"></i>Hợp Đồng</a></li>
                <li class="mainmenu__list-item"><a href="listinvoices"><i class="fa-solid fa-receipt list-item-icon"></i>Hóa đơn</a></li>
                <!-- Thêm các mục khác nếu cần -->
            </ul>
        </div>

        <!-- Content Area -->
        <div class="homepage-body">
            <div class="body-head">
                <h5 class="body__head-title">Danh sách hợp đồng</h5>
                <div class="search-container">
                    <form action="listcontracts" method="post">
                        <input type="text" name="information" placeholder="Tìm kiếm theo tên hoặc ID..." class="search-input">
                        <input type="submit" value="Tìm Kiếm" class="search-button">
                    </form>

                    <% String message = (String) request.getAttribute("message"); %>
                    <% if (message != null && !message.isEmpty()) { %>
                        <div id="toast-message" class="toast-message"><%= message %></div>
                    <% } %>

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
                </div>
            </div>

            <!-- Contract Table -->
<div class="table-container">
    <table class="product-table">
        <thead>
            <tr class="table-header">
                <th class="table-header-item">ID</th>
                <th class="table-header-item">Người Thuê</th>
                <th class="table-header-item">Phòng</th>
                <th class="table-header-item">Ngày Bắt Đầu</th>
                <th class="table-header-item">Ngày Kết Thúc</th>
                <th class="table-header-item">Tình Trạng</th>
                <%--<% if (roleId == 2) { %>
                    <th class="table-header-item">Hành Động</th>
                <% } %> --%>
            </tr>
        </thead>
        <tbody>
            <% if (contracts != null && !contracts.isEmpty()) {
                for (Contracts contract : contracts) { %>
                    <tr class="table-row">
                        <td class="table-cell"><%= contract.getContractId() %></td>
                        <td class="table-cell"><%= contract.getTenantsID() %></td> <%-- Hoặc hiển thị tên nếu có --%>
                        <td class="table-cell"><%= contract.getRoomID() %></td>
                        <td class="table-cell"><%= dateFormat.format(contract.getStartDate()) %></td>
                        <td class="table-cell"><%= dateFormat.format(contract.getEndDate()) %></td>
                        <td class="table-cell"><%= contract.getNote() %></td>
                        <%--<% if (roleId == 2) { %>
                            <td class="table-cell">
                                <a href="updatecontract?id=<%= contract.ContractId() %>" class="action-button">Sửa</a>
                                <button class="action-button" onclick="if(confirm('Xác nhận kết thúc hợp đồng này?')) { window.location.href='endcontract?id=<%= contract.getId() %>'; }">Kết thúc</button>
                            </td>
                        <% } %> --%>
                    </tr>
            <% } 
            } else { %>
                <tr><td colspan="7" class="table-cell">Không có hợp đồng nào.</td></tr>
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
        <p>&copy; 2025 Công ty TNHH G5. Tất cả quyền được bảo lưu.</p>
    </div>
</div>

</body>
</html>

