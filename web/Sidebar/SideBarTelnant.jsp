<%@page contentType="text/html" pageEncoding="UTF-8"%>
<div class="col-md-3 col-lg-2 px-0">
    <div  style="height: 100%" class="sidebar p-3">
        <div class="text-center mb-4">
            <h4 class="text-white mb-0">
                <i class="fas fa-home me-2"></i>
                Tenant Panel
            </h4>
        </div>

        <!-- User Info -->
        <div class="user-info">
            <div class="text-center">
                <i class="fas fa-user-circle fa-3x text-white mb-2"></i>
                <h6 class="text-white mb-1">${user.fullName}</h6>
                <small class="text-white-50">Người thuê</small>
            </div>
        </div>

        <!-- Navigation -->
        <nav class="nav flex-column">
            <a class="nav-link active" href="TenantHomepage">
                <i class="fas fa-tachometer-alt me-2"></i>
                Dashboard
            </a>
            <a class="nav-link" href="listrooms">
                <i class="fas fa-bed me-2"></i>
                Xem phòng
            </a>
            <a class="nav-link" href="mycontract">
                <i class="fas fa-file-contract me-2"></i>
                Hợp đồng của tôi
            </a>
            <a class="nav-link" href="listbills">
                <i class="fas fa-receipt me-2"></i>
                Hóa đơn của tôi
            </a>
            <a class="nav-link" href="myservices">
                <i class="fas fa-concierge-bell me-2"></i>
                Dịch vụ đã đăng ký
            </a>
            <a class="nav-link" href="maintenanceList">
                <i class="fas fa-tools me-2"></i>
                Báo sửa chữa
            </a>
            <a class="nav-link" href="reportIssue">
                <i class="fas fa-exclamation-triangle me-2"></i>
                Báo cáo sự cố
            </a>
            <a class="nav-link" href="myViewingRequests">
                <i class="fas fa-user-cog me-2"></i>
                Danh sách yêu cầu
            </a>
            <hr class="text-white-50">
            <a class="nav-link" href="profileTelnant">
                <i class="fas fa-user-cog me-2"></i>
                Hồ sơ cá nhân
            </a>
            <a class="nav-link" href="trangchu">
                <i class="fas fa-user-cog me-2"></i>
                Trang chủ
            </a>
            <a class="nav-link" href="logout">
                <i class="fas fa-sign-out-alt me-2"></i>
                Đăng xuất
            </a>
        </nav>
    </div>
</div>
