<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<div class="col-md-3 col-lg-2 px-0">
    <!-- Kiểm tra xem manager đã được kích hoạt chưa -->
    <c:choose>
        <c:when test="${user.isActive == true}">
            <!-- Sidebar đầy đủ cho manager đã được kích hoạt -->
            <div style="height: 100%" class="sidebar p-3">
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
                        <small class="text-white-50">Manager <span class="badge bg-success">Đã kích hoạt</span></small>
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
                    <a class="nav-link" href="listUser">
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
                        <a class="nav-link dropdown-toggle" href="#" id="equipmentDropdown" role="button" data-bs-toggle="collapse" data-bs-target="#postSubmenu" aria-expanded="false" aria-controls="equipmentSubmenu">
                            <i class="fas fa-paper-plane me-2"></i>
                            Bài đăng
                        </a>
                        <div class="collapse submenu" id="postSubmenu">
                            <a class="nav-link" href="listPost">                                  
                                Danh sách bài đăngs
                            </a>
                            <a class="nav-link" href="createPost">                                   
                                Tạo bài đăng mới
                            </a>
                        </div>
                    </div>
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
                    <a class="nav-link" href="manageReports">
                        <i class="fas fa-clipboard-list me-2"></i>
                        Báo cáo sự cố
                    </a>
                    <a class="nav-link" href="manageViewingRequests">
                        <i class="fas fa-building me-2"></i>
                        Yêu cầu thuê phòng
                    </a>
                    <a class="nav-link" href="trangchu">
                        <i class="fas fa-building me-2"></i>
                        Trang chủ
                    </a>
                    <hr class="text-white-50">
                    <a class="nav-link" href="profileManager">
                        <i class="fas fa-user-cog me-2"></i>
                        Hồ sơ cá nhân
                    </a>
                    <a class="nav-link" href="logout">
                        <i class="fas fa-sign-out-alt me-2"></i>
                        Đăng xuất
                    </a>
                </nav>
            </div>
        </c:when>
        <c:otherwise>
            <!-- Sidebar giới hạn cho manager chưa được kích hoạt -->
            <div style="height: 100%" class="sidebar p-3">
                <div class="text-center mb-4">
                    <h4 class="text-white mb-0">
                        <i class="fas fa-clock me-2"></i>
                        Chờ duyệt
                    </h4>
                </div>

                <!-- User Info -->
                <div class="user-info">
                    <div class="text-center">
                        <i class="fas fa-user-clock fa-3x text-warning mb-2"></i>
                        <h6 class="text-white mb-1">${user.fullName}</h6>
                        <small class="text-warning">Manager <span class="badge bg-warning text-dark">Chờ kích hoạt</span></small>
                    </div>
                </div>

                <!-- Thông báo -->
                <div class="alert alert-warning mt-3" role="alert">
                    <h6 class="alert-heading"><i class="fas fa-info-circle me-2"></i>Tài khoản chờ duyệt</h6>
                    <p class="mb-2">Tài khoản Manager của bạn đang chờ được kích hoạt bởi Super Admin.</p>
                    <small>Vui lòng cung cấp đầy đủ giấy tờ kinh doanh để được duyệt sớm nhất.</small>
                </div>

                <!-- Navigation giới hạn -->
                <nav class="nav flex-column">
                    <a class="nav-link" href="uploadBusinessDocuments">
                        <i class="fas fa-upload me-2"></i>
                        Upload giấy tờ kinh doanh
                    </a>
                    <a class="nav-link" href="checkDocumentStatus">
                        <i class="fas fa-search me-2"></i>
                        Kiểm tra trạng thái duyệt
                    </a>
                    <hr class="text-white-50">
                    <a class="nav-link" href="profileManager">
                        <i class="fas fa-user-cog me-2"></i>
                        Hồ sơ cá nhân
                    </a>
                    <a class="nav-link" href="trangchu">
                        <i class="fas fa-home me-2"></i>
                        Về trang chủ
                    </a>
                    <a class="nav-link" href="logout">
                        <i class="fas fa-sign-out-alt me-2"></i>
                        Đăng xuất
                    </a>
                </nav>
            </div>
        </c:otherwise>
    </c:choose>
</div>