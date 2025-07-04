<%@page contentType="text/html" pageEncoding="UTF-8"%>

                <div class="col-md-3 col-lg-2 px-0">
                    <div class="sidebar p-3">
                        <div class="text-center mb-4">
                            <h4 class="text-white mb-0">
                                <i class="fas fa-building me-2"></i>
                                Manager Panel
                            </h4>
                        </div>

                        <!-- User Info -->
                        <div class="user-info">
                            <div class="text-center">
                                <i class="fas fa-user-circle fa-3x text-white mb-2"></i>
                                <h6 class="text-white mb-1">${user.fullName}</h6>
                                <small class="text-white-50">Manager</small>
                            </div>
                        </div>

                        <!-- Navigation -->
                        <nav class="nav flex-column">
                            <a class="nav-link active" href="ManagerHomepage">
                                <i class="fas fa-tachometer-alt me-2"></i>
                                Dashboard
                            </a>
                            <a class="nav-link" href="listrooms">
                                <i class="fas fa-bed me-2"></i>
                                Quản lý Phòng
                            </a>
                            <a class="nav-link" href="listusers?role=3">
                                <i class="fas fa-users me-2"></i>
                                Quản lý Người thuê
                            </a>
                            <a class="nav-link" href="listcontracts">
                                <i class="fas fa-file-contract me-2"></i>
                                Hợp đồng
                            </a>
                            <a class="nav-link" href="listbills">
                                <i class="fas fa-receipt me-2"></i>
                                Hóa đơn
                            </a>
                            <div class="nav-item dropdown">
                            <a class="nav-link dropdown-toggle" href="#" id="equipmentDropdown" role="button" data-bs-toggle="collapse" data-bs-target="#equipmentSubmenu" aria-expanded="false" aria-controls="equipmentSubmenu">
                                <i class="fas fa-tools me-2"></i>
                                Thiết bị
                            </a>
                            <div class="collapse submenu" id="equipmentSubmenu">
                                <a class="nav-link" href="listdevices">                                  
                                    Danh sách thiết bị
                                </a>
                                <a class="nav-link" href="deviceinroom">                                   
                                    Thiết bị trong phòng
                                </a>
                            </div>
                        </div>
                            <a class="nav-link" href="listservices">
                                <i class="fas fa-concierge-bell me-2"></i>
                                Dịch vụ
                            </a>
                            <hr class="text-white-50">
                            <a class="nav-link" href="profile">
                                <i class="fas fa-user-cog me-2"></i>
                                Hồ sơ cá nhân
                            </a>
                            <a class="nav-link" href="logout">
                                <i class="fas fa-sign-out-alt me-2"></i>
                                Đăng xuất
                            </a>
                        </nav>
                    </div>
                </div>