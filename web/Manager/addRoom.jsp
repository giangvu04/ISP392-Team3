<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Add New Room</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <style>
            :root {
                --primary-gradient: linear-gradient(135deg, #6B73FF 0%, #000DFF 100%);
                --sidebar-bg: linear-gradient(135deg, #4e54c8 0%, #8f94fb 100%);
                --card-shadow: 0 6px 10px rgba(0,0,0,0.08);
            }

            .sidebar {
                min-height: 100vh;
                background: var(--sidebar-bg);
            }

            .sidebar .navLink {
                color: rgba(255,255,255,0.85);
                padding: 12px 20px;
                margin: 4px 0;
                border-radius: 8px;
                transition: all 0.3s ease;
            }

            .sidebar .navLink:hover,
            .sidebar .navLink.active {
                background-color: rgba(255,255,255,0.15);
                color: white;
                transform: translateX(5px);
            }

            .mainContent {
                background-color: #f5f7ff;
                min-height: 100vh;
            }

            .card {
                border: none;
                border-radius: 12px;
                box-shadow: var(--card-shadow);
                transition: transform 0.3s ease, box-shadow 0.3s ease;
            }

            .card:hover {
                transform: translateY(-5px);
                box-shadow: 0 12px 20px rgba(0,0,0,0.1);
            }

            .formSection {
                background: white;
                border-radius: 12px;
                padding: 2rem;
                box-shadow: var(--card-shadow);
            }

            .btnPrimary {
                background: var(--primary-gradient);
                border: none;
                padding: 10px 25px;
                border-radius: 8px;
            }

            .formLabel {
                font-weight: 500;
                color: #555;
            }

            .alert {
                border-radius: 8px;
            }
        </style>
    </head>
    <body>
        <div class="container-fluid">
            <div class="row">
                <!-- Sidebar -->
                <div class="col-md-3 col-lg-2 d-md-block sidebar collapse" style="background: var(--sidebar-bg);">
                    <div class="position-sticky pt-3">
                        <ul class="nav flex-column">
                            <li class="navItem">
                                <a class="navLink" href="ManagerHomepage">
                                    <i class="fas fa-tachometer-alt me-2"></i>Dashboard
                                </a>
                            </li>
                            <li class="navItem">
                                <a class="navLink active" href="listrooms">
                                    <i class="fas fa-door-open me-2"></i>Quản lý Phòng
                                </a>
                            </li>
                            <li class="navItem">
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
                        <h1 class="h2">Add New Room</h1>
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
                                <form action="addroom" method="POST">
                                    <div class="row mb-3">
                                        <div class="col-md-6">
                                            <label for="rentalAreaId" class="formLabel">Rental Area ID</label>
                                            <input type="number" class="form-control" id="rentalAreaId" name="rentalAreaId" required>
                                        </div>
                                        <div class="col-md-6">
                                            <label for="roomNumber" class="formLabel">Room Number</label>
                                            <input type="text" class="form-control" id="roomNumber" name="roomNumber" required>
                                        </div>
                                    </div>

                                    <div class="row mb-3">
                                        <div class="col-md-6">
                                            <label for="area" class="formLabel">Area (sqm)</label>
                                            <input type="number" step="0.01" class="form-control" id="area" name="area" required>
                                        </div>
                                        <div class="col-md-6">
                                            <label for="price" class="formLabel">Price</label>
                                            <input type="number" step="0.01" class="form-control" id="price" name="price" required>
                                        </div>
                                    </div>

                                    <div class="row mb-3">
                                        <div class="col-md-6">
                                            <label for="maxTenants" class="formLabel">Max Tenants</label>
                                            <input type="number" class="form-control" id="maxTenants" name="maxTenants" required>
                                        </div>
                                        <div class="col-md-6">
                                            <label for="status" class="formLabel">Status</label>
                                            <select class="form-select" id="status" name="status" required>
                                                <option value="0">Còn trống</option>
                                                <option value="1">Đã thuê</option>
                                                <option value="2">Bảo trì</option>
                                            </select>
                                        </div>
                                    </div>

                                    <div class="mb-3">
                                        <label for="description" class="formLabel">Description</label>
                                        <textarea class="form-control" id="description" name="description" rows="3"></textarea>
                                    </div>

                                    <div class="d-grid gap-2 d-md-flex justify-content-md-end">
                                        <button type="reset" class="btn btn-outline-secondary me-md-2">
                                            <i class="fas fa-undo me-1"></i> Reset
                                        </button>
                                        <button type="submit" class="btn btnPrimary">
                                            <i class="fas fa-save me-1"></i> Save Room
                                        </button>
                                    </div>
                                </form>
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
