<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="model.Rooms"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Cập nhật phòng</title>
        <base href="${pageContext.request.contextPath}/">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
        <link href="css/addUpdateRoom.css" rel="stylesheet">
    </head>
    <body>
        <div class="container-fluid">
            <div class="row">
                <!-- Sidebar -->
                <div class="col-md-3 col-lg-2 d-md-block sidebar">
                    <div class="position-sticky pt-3">
                        <ul class="nav flex-column">
                            <li class="nav-item">
                                <a class="navLink" href="ManagerHomepage">
                                    <i class="fas fa-tachometer-alt me-2"></i>Dashboard
                                </a>
                            </li>
                            <li class="nav-item">
                                <a class="navLink active" href="listrooms">
                                    <i class="fas fa-door-open me-2"></i>Quản lý Phòng
                                </a>
                            </li>
                            <li class="nav-item">
                                <a class="navLink" href="#">
                                    <i class="fas fa-users me-2"></i>Quản lý Người thuê
                                </a>
                            </li>
                        </ul>
                    </div>
                </div>

                <!-- Main content -->
                <main class="col-md-9 ms-sm-auto col-lg-10 px-md-4 mainContent">
                    <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
                        <h1 class="h2">Update Room</h1>
                        <div class="btn-toolbar mb-2 mb-md-0">
                            <a href="listrooms" class="btn btn-sm btn-outline-secondary">
                                <i class="fas fa-arrow-left me-1"></i> Back to Rooms
                            </a>
                        </div>
                    </div>

                    <%@include file="messages.jsp" %>

                    <div class="row">
                        <div class="col-lg-8 mx-auto">
                            <div class="formSection">
                                <% Rooms room = (Rooms) request.getAttribute("room"); %>
                                <% if (room != null) { %>
                                <div class="roomHeader">
                                    <h3 class="mb-0">Room #<%= room.getRoomNumber() %></h3>
                                    <small>ID: <%= room.getRoomId() %></small>
                                </div>

                                <form action="updateroom" method="POST">
                                    <input type="hidden" name="roomId" value="<%= room.getRoomId() %>">

                                    <div class="row mb-3">
                                        <div class="col-md-6">
                                            <label for="rentalAreaId" class="formLabel">Rental Area ID</label>
                                            <input type="number" class="form-control" id="rentalAreaId" name="rentalAreaId" 
                                                   value="<%= room.getRentalAreaId() %>" required>
                                        </div>
                                        <div class="col-md-6">
                                            <label for="roomNumber" class="formLabel">Room Number</label>
                                            <input type="text" class="form-control" id="roomNumber" name="roomNumber" 
                                                   value="<%= room.getRoomNumber() %>" required>
                                        </div>
                                    </div>

                                    <div class="row mb-3">
                                        <div class="col-md-6">
                                            <label for="area" class="formLabel">Area (sqm)</label>
                                            <input type="number" step="0.01" class="form-control" id="area" name="area" 
                                                   value="<%= room.getArea() %>" required>
                                        </div>
                                        <div class="col-md-6">
                                            <label for="price" class="formLabel">Price</label>
                                            <input type="number" step="0.01" class="form-control" id="price" name="price" 
                                                   value="<%= room.getPrice() %>" required>
                                        </div>
                                    </div>

                                    <div class="row mb-3">
                                        <div class="col-md-6">
                                            <label for="maxTenants" class="formLabel">Max Tenants</label>
                                            <input type="number" class="form-control" id="maxTenants" name="maxTenants" 
                                                   value="<%= room.getMaxTenants() %>" required>
                                        </div>
                                        <div class="col-md-6">
                                            <label for="status" class="formLabel">Status</label>
                                            <select class="form-select" id="status" name="status" required>
                                                <option value="0" <%= room.getStatus() == 0 ? "selected" : "" %>>Còn trống</option>
                                                <option value="1" <%= room.getStatus() == 1 ? "selected" : "" %>>Đã thuê</option>
                                                <option value="2" <%= room.getStatus() == 2 ? "selected" : "" %>>Bảo trì</option>
                                            </select>
                                        </div>
                                    </div>

                                    <div class="mb-3">
                                        <label for="description" class="formLabel">Description</label>
                                        <textarea class="form-control" id="description" name="description" rows="3"><%= room.getDescription() != null ? room.getDescription() : "" %></textarea>
                                    </div>

                                    <div class="d-grid gap-2 d-md-flex justify-content-md-end">
                                        <button type="reset" class="btn btn-outline-secondary me-md-2">
                                            <i class="fas fa-undo me-1"></i> Reset
                                        </button>
                                        <button type="submit" class="btn btnPrimary">
                                            <i class="fas fa-save me-1"></i> Update Room
                                        </button>
                                    </div>
                                </form>
                                <% } else { %>
                                <div class="alert alert-danger">
                                    Room information not found. Please select a room from the list.
                                </div>
                                <% } %>
                            </div>
                        </div>
                    </div>
                </main>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        <script src="https://kit.fontawesome.com/a076d05399.js" crossorigin="anonymous"></script>
    </body>
</html>
