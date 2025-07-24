<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <title>Manager Profile</title>
    <base href="${pageContext.request.contextPath}/">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
        <link href="css/homepage.css" rel="stylesheet">
    <style>
        body { background: #f5f6fa; }
        .profile-container { background: #fff; border-radius: 10px; box-shadow: 0 2px 8px rgba(0,0,0,0.05); padding: 32px; margin: 32px 0; }
        .profile-header { display: flex; align-items: center; gap: 24px; }
        .profile-avatar { width: 100px; height: 100px; border-radius: 50%; background: #e1e1e1; display: flex; align-items: center; justify-content: center; font-size: 48px; color: #888; }
        .profile-info { flex: 1; }
        .profile-info h2 { margin-bottom: 4px; }
        .profile-info .role { color: #6c757d; font-size: 15px; margin-bottom: 8px; }
        .profile-social { margin-top: 8px; }
        .profile-social a { color: #495057; margin-right: 10px; font-size: 20px; }
        .profile-details { margin-top: 32px; }
        .profile-details h4 { margin-bottom: 16px; }
        .profile-details .row { margin-bottom: 12px; }
        .profile-details .label { color: #6c757d; width: 140px; display: inline-block; }
        .profile-details .value { color: #212529; }
        
        /* Fixed Modal Styles */
        .custom-modal {
            display: none;
            position: fixed;
            z-index: 1050;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0, 0, 0, 0.5);
            backdrop-filter: blur(3px);
        }
        
        .custom-modal.show {
            display: flex;
            justify-content: center;
            align-items: center;
        }
        
        .modal-content {
            background: #fff;
            padding: 24px;
            border-radius: 12px;
            max-width: 500px;
            width: 90%;
            max-height: 90vh;
            overflow-y: auto;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.3);
            position: relative;
            animation: modalSlideIn 0.3s ease-out;
        }
        
        @keyframes modalSlideIn {
            from {
                opacity: 0;
                transform: translateY(-50px) scale(0.9);
            }
            to {
                opacity: 1;
                transform: translateY(0) scale(1);
            }
        }
        
        .btn-close {
            position: absolute;
            top: 15px;
            right: 20px;
            background: none;
            border: none;
            font-size: 24px;
            cursor: pointer;
            color: #6c757d;
            padding: 0;
            width: 30px;
            height: 30px;
            display: flex;
            align-items: center;
            justify-content: center;
            border-radius: 50%;
            transition: all 0.2s;
        }
        
        .btn-close:hover {
            background-color: #f8f9fa;
            color: #dc3545;
        }
        
        .modal-header {
            margin-bottom: 20px;
            padding-bottom: 15px;
            border-bottom: 1px solid #dee2e6;
        }
        
        .modal-header h5 {
            margin: 0;
            color: #212529;
            font-weight: 600;
        }
        
        .form-control:focus {
            border-color: #0d6efd;
            box-shadow: 0 0 0 0.2rem rgba(13, 110, 253, 0.25);
        }
        
        .alert {
            border-radius: 8px;
            border: none;
        }
        
        .alert-danger {
            background-color: #f8d7da;
            color: #721c24;
        }
    </style>
</head>
<body>
    <div class="container-fluid">
        <div class="row">
            <!-- Sidebar -->
            <%@include file="../Sidebar/SideBarManager.jsp" %>
            <!-- Main Content -->
            <div class="col-md-9 col-lg-10">
                <div class="main-content p-4">
                    <div class="card profile-container">
                        <div class="profile-header mb-4">
                            <div class="profile-avatar">
                                <img src="https://ui-avatars.com/api/?name=Manager&background=cccccc&color=555555&size=100" alt="Avatar" style="width:100px;height:100px;border-radius:50%;object-fit:cover;">
                            </div>
                            <div class="profile-info">
                                <h2>${user.fullName}</h2>
                                <div class="role">Quản lý | Manager</div>
                                <div class="profile-social">
                                    <a href="mailto:${user.email}" title="Email"><i class="fas fa-envelope"></i></a>
                                    <a href="tel:${user.phoneNumber}" title="Gọi"><i class="fas fa-phone"></i></a>
                                </div>
                            </div>
                        </div>
                        <div class="profile-details">
                            <h4>Thông tin chi tiết</h4>
                            <div class="row">
                                <div class="col-md-6 mb-2">
                                    <span class="label">Họ tên:</span>
                                    <span class="value">
                                        <c:choose>
                                            <c:when test="${not empty user.fullName}">${user.fullName}</c:when>
                                            <c:otherwise>Không có</c:otherwise>
                                        </c:choose>
                                    </span>
                                </div>
                                <div class="col-md-6 mb-2">
                                    <span class="label">Email:</span>
                                    <span class="value">
                                        <c:choose>
                                            <c:when test="${not empty user.email}">${user.email}</c:when>
                                            <c:otherwise>Không có</c:otherwise>
                                        </c:choose>
                                    </span>
                                </div>
                                <div class="col-md-6 mb-2">
                                    <span class="label">Số điện thoại:</span>
                                    <span class="value">
                                        <c:choose>
                                            <c:when test="${not empty user.phoneNumber}">${user.phoneNumber}</c:when>
                                            <c:otherwise>Không có</c:otherwise>
                                        </c:choose>
                                    </span>
                                </div>
                                <div class="col-md-6 mb-2">
                                    <span class="label">CMND/CCCD:</span>
                                    <span class="value">
                                        <c:choose>
                                            <c:when test="${not empty user.citizenId}">${user.citizenId}</c:when>
                                            <c:otherwise>Không có</c:otherwise>
                                        </c:choose>
                                    </span>
                                </div>
                                <div class="col-md-6 mb-2">
                                    <span class="label">Địa chỉ:</span>
                                    <span class="value">
                                        <c:choose>
                                            <c:when test="${not empty user.address}">${user.address}</c:when>
                                            <c:otherwise>Không có</c:otherwise>
                                        </c:choose>
                                    </span>
                                </div>
                                <div class="col-md-6 mb-2">
                                    <span class="label">Trạng thái:</span>
                                    <span class="value">
                                        <c:choose>
                                            <c:when test="${user.active}">Đang hoạt động</c:when>
                                            <c:otherwise>Đã khóa</c:otherwise>
                                        </c:choose>
                                    </span>
                                </div>
                                <div class="col-md-6 mb-2">
                                    <span class="label">Ngày tạo tài khoản:</span>
                                    <span class="value">
                                        <c:choose>
                                            <c:when test="${not empty user.createdAt}">
                                                <fmt:formatDate value="${user.createdAt}" pattern="dd/MM/yyyy HH:mm"/>
                                            </c:when>
                                            <c:otherwise>Không có</c:otherwise>
                                        </c:choose>
                                    </span>
                                </div>
                                <div class="col-md-6 mb-2">
                                    <span class="label">Ngày cập nhật:</span>
                                    <span class="value">
                                        <c:choose>
                                            <c:when test="${not empty user.updatedAt}">
                                                <fmt:formatDate value="${user.updatedAt}" pattern="dd/MM/yyyy HH:mm"/>
                                            </c:when>
                                            <c:otherwise>Không có</c:otherwise>
                                        </c:choose>
                                    </span>
                                </div>
                            </div>
                            <!-- ACTION BUTTONS -->
                            <div class="mt-4 d-flex gap-3">
                                <button class="btn btn-outline-primary" onclick="openModal('modalEditInfo')">
                                    <i class="fas fa-user-cog me-2"></i> Chỉnh sửa thông tin
                                </button>
                                <button class="btn btn-outline-success" onclick="openModal('modalChangePassword')">
                                    <i class="fas fa-key me-2"></i> Đổi mật khẩu
                                </button>
                            </div>
                        </div>
                    </div>

                    <!-- ========== MODAL EDIT INFO ========== -->
                    <div id="modalEditInfo" class="custom-modal">
                        <div class="modal-content">
                            <button class="btn-close" onclick="closeModal('modalEditInfo')">&times;</button>
                            <div class="modal-header">
                                <h5>Chỉnh sửa thông tin</h5>
                            </div>
                            <form action="editInfo" method="post">
                                <div class="mb-3">
                                    <label class="form-label">Họ tên</label>
                                    <input class="form-control" name="fullName" value="${user.fullName}" required>
                                </div>
                                <div class="mb-3">
                                    <label class="form-label">Email</label>
                                    <input class="form-control" name="email" value="${user.email}" required>
                                </div>
                                <div class="mb-3">
                                    <label class="form-label">Số điện thoại</label>
                                    <input class="form-control" name="phoneNumber" value="${user.phoneNumber}" required>
                                </div>
                                <div class="mb-3">
                                    <label class="form-label">CMND/CCCD</label>
                                    <input class="form-control" name="citizenId" value="${user.citizenId}">
                                </div>
                                <div class="mb-3">
                                    <label class="form-label">Địa chỉ</label>
                                    <input class="form-control" name="address" value="${user.address}">
                                </div>
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
                            <div class="modal-header">
                                <h5>Đổi mật khẩu</h5>
                            </div>
                            <form action="changePassword" method="post">
                                <c:if test="${not empty error}">
                                    <div class="alert alert-danger mb-3">${error}</div>
                                </c:if>
                                <div class="mb-3">
                                    <label class="form-label">Mật khẩu cũ</label>
                                    <input class="form-control" type="password" name="oldPassword" required>
                                </div>
                                <div class="mb-3">
                                    <label class="form-label">Mật khẩu mới</label>
                                    <input class="form-control" type="password" name="newPassword" required>
                                </div>
                                <div class="mb-3">
                                    <label class="form-label">Xác nhận mật khẩu mới</label>
                                    <input class="form-control" type="password" name="confirmPassword" required>
                                </div>
                                <div class="d-flex justify-content-end gap-2">
                                    <button type="button" class="btn btn-secondary" onclick="closeModal('modalChangePassword')">Hủy</button>
                                    <button type="submit" class="btn btn-success">Đổi</button>
                                </div>
                            </form>
                        </div>
                    </div>

                    <!-- Card: Top 5 hợp đồng mới nhất -->
                    <div class="card mt-4">
                        <div class="card-header bg-info text-white">
                            <h5 class="mb-0"><i class="fas fa-file-contract me-2"></i>Hợp đồng gần nhất</h5>
                        </div>
                        <div class="card-body p-0">
                            <c:choose>
                                <c:when test="${not empty topContracts}">
                                    <div class="table-responsive">
                                        <table class="table table-striped mb-0">
                                            <thead>
                                                <tr>
                                                    <th>#</th>
                                                    <th>Phòng</th>
                                                    <th>Người thuê</th>
                                                    <th>Ngày bắt đầu</th>
                                                    <th>Ngày kết thúc</th>
                                                    <th>Trạng thái</th>
                                                    <th>Chi tiết</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <c:forEach var="c" items="${topContracts}" varStatus="loop">
                                                    <tr>
                                                        <td>${loop.index + 1}</td>
                                                        <td>${c.roomID}</td>
                                                        <td>${c.tenantsID}</td>
                                                        <td><fmt:formatDate value="${c.startDate}" pattern="dd/MM/yyyy"/></td>
                                                        <td><fmt:formatDate value="${c.endDate}" pattern="dd/MM/yyyy"/></td>
                                                        <td>
                                                            <c:choose>
                                                                <c:when test="${c.status == 1}"><span class="badge bg-success">Hiệu lực</span></c:when>
                                                                <c:otherwise><span class="badge bg-secondary">Hết hạn</span></c:otherwise>
                                                            </c:choose>
                                                        </td>
                                                        <td>
                                                            <a href="listcontracts?action=view&amp;id=${c.contractId}" class="btn btn-sm btn-outline-primary" title="Xem chi tiết">
                                                                <i class="fas fa-eye"></i> Chi tiết
                                                            </a>
                                                        </td>
                                                    </tr>
                                                </c:forEach>
                                            </tbody>
                                        </table>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <div class="p-3 text-center text-muted">Không có hợp đồng nào gần đây.</div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script>
        function openModal(id) {
            const modal = document.getElementById(id);
            modal.classList.add('show');
            document.body.style.overflow = 'hidden'; // Prevent body scroll
        }
        
        function closeModal(id) {
            const modal = document.getElementById(id);
            modal.classList.remove('show');
            document.body.style.overflow = 'auto'; // Restore body scroll
        }
        
        // Close modal when clicking outside
        window.addEventListener('click', function(e) {
            document.querySelectorAll('.custom-modal').forEach(modal => {
                if (e.target === modal) {
                    closeModal(modal.id);
                }
            });
        });
        
        // Close modal with Escape key
        document.addEventListener('keydown', function(e) {
            if (e.key === 'Escape') {
                document.querySelectorAll('.custom-modal.show').forEach(modal => {
                    closeModal(modal.id);
                });
            }
        });
    </script>
</body>
</html>