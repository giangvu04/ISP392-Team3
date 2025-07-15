<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"  %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <title>Tenant Profile</title>
    <base href="${pageContext.request.contextPath}/">

    <!-- chỉ lấy CSS của Bootstrap để tận dụng lớp btn / alert … -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link href="css/homepage.css" rel="stylesheet">

    <!-- ===== STYLE CHÍNH ===== -->
    <style>
        body{background:#f5f6fa}
        .profile-container{background:#fff;border-radius:10px;box-shadow:0 2px 8px rgba(0,0,0,.05);padding:32px;margin:32px 0}
        .profile-header{display:flex;align-items:center;gap:24px}
        .profile-avatar{width:100px;height:100px;border-radius:50%;background:#e1e1e1;display:flex;align-items:center;justify-content:center;font-size:48px;color:#888}
        .profile-info{flex:1}
        .profile-info h2{margin-bottom:4px}
        .profile-info .role{color:#6c757d;font-size:15px;margin-bottom:8px}
        .profile-social a{color:#495057;margin-right:10px;font-size:20px}
        .profile-details{margin-top:32px}
        .profile-details .row{margin-bottom:12px}
        .profile-details .label{color:#6c757d;width:140px;display:inline-block}
        .profile-details .value{color:#212529}

        /* ===== MODAL tuỳ chỉnh (không Bootstrap JS) ===== */
        .custom-modal{display:none;position:fixed;z-index:1050;inset:0;width:100vw;height:100vh;background:rgba(0,0,0,.5);justify-content:center;align-items:center}
        .custom-modal.show{display:flex}
        .custom-modal .modal-content{background:#fff;padding:24px;border-radius:8px;max-width:500px;width:100%;box-shadow:0 2px 10px rgba(0,0,0,.2);position:relative}
        .custom-modal .modal-header h5{margin:0}
        .custom-modal .btn-close{position:absolute;right:16px;top:16px;background:none;border:none;font-size:20px;cursor:pointer}
    </style>

    <!-- ===== JS thuần để mở / đóng modal ===== -->
    <script>
      function openModal(id){ document.getElementById(id).classList.add('show'); }
      function closeModal(id){ document.getElementById(id).classList.remove('show'); }

      /* đóng khi click ra nền mờ */
      window.addEventListener('click', e=>{
        document.querySelectorAll('.custom-modal').forEach(m=>{
          if(e.target===m) m.classList.remove('show');
        });
      });
    </script>
</head>
<body>
<div class="container-fluid">
  <div class="row">
    <!-- Sidebar -->
    <jsp:include page="../Sidebar/SideBarTelnant.jsp"/>

    <!-- Main -->
    <div class="col-md-9 col-lg-10">
      <div class="main-content p-4">
        <div class="card profile-container">

          <!-- HEADER -->
          <div class="profile-header mb-4">
            <div class="profile-avatar">
              <img src="https://ui-avatars.com/api/?name=User&background=cccccc&color=555555&size=100"
                   alt="Avatar" style="width:100px;height:100px;border-radius:50%;object-fit:cover;">
            </div>
            <div class="profile-info">
              <h2>${user.fullName}</h2>
              <div class="role">Mã số: ${user.username}</div>
              <div class="profile-social">
                <a href="mailto:${user.email}" title="Email"><i class="fas fa-envelope"></i></a>
                <a href="tel:${user.phoneNumber}" title="Gọi"><i class="fas fa-phone"></i></a>
              </div>
            </div>
          </div>

          <!-- DETAILS -->
          <div class="profile-details">
            <h4>Thông tin chi tiết</h4>
            <div class="row">
              <div class="col-md-6 mb-2"><span class="label">Họ tên:</span><span class="value">${not empty user.fullName?user.fullName:'Không có'}</span></div>
              <div class="col-md-6 mb-2"><span class="label">Email:</span><span class="value">${not empty user.email?user.email:'Không có'}</span></div>
              <div class="col-md-6 mb-2"><span class="label">Số điện thoại:</span><span class="value">${not empty user.phoneNumber?user.phoneNumber:'Không có'}</span></div>
              <div class="col-md-6 mb-2"><span class="label">CMND/CCCD:</span><span class="value">${not empty user.citizenId?user.citizenId:'Không có'}</span></div>
              <div class="col-md-6 mb-2"><span class="label">Địa chỉ:</span><span class="value">${not empty user.address?user.address:'Không có'}</span></div>
              <div class="col-md-6 mb-2"><span class="label">Trạng thái:</span><span class="value">${user.active?'Đang hoạt động':'Đã khóa'}</span></div>
              <div class="col-md-6 mb-2"><span class="label">Ngày tạo TK:</span><span class="value"><c:choose><c:when test="${not empty user.createdAt}"><fmt:formatDate value="${user.createdAt}" pattern="dd/MM/yyyy HH:mm"/></c:when><c:otherwise>Không có</c:otherwise></c:choose></span></div>
              <div class="col-md-6 mb-2"><span class="label">Ngày cập nhật:</span><span class="value"><c:choose><c:when test="${not empty user.updatedAt}"><fmt:formatDate value="${user.updatedAt}" pattern="dd/MM/yyyy HH:mm"/></c:when><c:otherwise>Không có</c:otherwise></c:choose></span></div>
            </div>

            <!-- ACTION BUTTONS -->
            <div class="mt-4 d-flex gap-3">
              <button class="btn btn-outline-primary"  onclick="openModal('modalEditInfo')"><i class="fas fa-user-cog me-2"></i> Chỉnh sửa thông tin</button>
              <button class="btn btn-outline-success" onclick="openModal('modalChangePassword')"><i class="fas fa-key me-2"></i> Đổi mật khẩu</button>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</div>

<!-- ========== MODAL EDIT INFO ========== -->
<div id="modalEditInfo" class="custom-modal">
  <div class="modal-content">
    <button class="btn-close" onclick="closeModal('modalEditInfo')">&times;</button>
    <div class="modal-header"><h5>Chỉnh sửa thông tin</h5></div>
    <form action="user/editInfo" method="post">
      <div class="mb-3"><label>Họ tên</label><input class="form-control" name="fullName"   value="${user.fullName}"   required></div>
      <div class="mb-3"><label>Email</label><input class="form-control" name="email"      value="${user.email}"      required></div>
      <div class="mb-3"><label>Số điện thoại</label><input class="form-control" name="phoneNumber" value="${user.phoneNumber}" required></div>
      <div class="mb-3"><label>CMND/CCCD</label><input class="form-control" name="citizenId" value="${user.citizenId}"></div>
      <div class="mb-3"><label>Địa chỉ</label><input class="form-control" name="address"   value="${user.address}"></div>
      <div class="d-flex justify-content-end gap-2">
        <button type="button" class="btn btn-secondary" onclick="closeModal('modalEditInfo')">Hủy</button>
        <button type="submit" class="btn btn-primary">Lưu</button>
      </div>
    </form>
  </div>
</div>

<!-- ========== MODAL CHANGE PASSWORD ========== -->
<div id="modalChangePassword" class="custom-modal">
  <div class="modal-content">
    <button class="btn-close" onclick="closeModal('modalChangePassword')">&times;</button>
    <div class="modal-header"><h5>Đổi mật khẩu</h5></div>
    <form action="user/changePassword" method="post">
      <c:if test="${not empty error}">
        <div class="alert alert-danger mb-2">${error}</div>
      </c:if>
      <div class="mb-3"><label>Mật khẩu cũ</label><input class="form-control" type="password" name="oldPassword"     required></div>
      <div class="mb-3"><label>Mật khẩu mới</label><input class="form-control" type="password" name="newPassword"     required></div>
      <div class="mb-3"><label>Xác nhận mật khẩu mới</label><input class="form-control" type="password" name="confirmPassword" required></div>
      <div class="d-flex justify-content-end gap-2">
        <button type="button" class="btn btn-secondary" onclick="closeModal('modalChangePassword')">Hủy</button>
        <button type="submit" class="btn btn-success">Đổi</button>
      </div>
    </form>
  </div>
</div>

</body>
</html>
