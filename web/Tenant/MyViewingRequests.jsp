<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Lịch sử yêu cầu xem phòng</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
        <link href="css/homepage.css" rel="stylesheet">
        <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    </head>
    <body>
        <div class="container-fluid">
            <div class="row">
                <!-- Sidebar -->
                <jsp:include page="../Sidebar/SideBarTelnant.jsp"/>

                <!-- Main content -->
                <div class="col-md-10">
                    <div class="content">
                        <h1>Lịch sử yêu cầu xem phòng</h1>
                        <p class="text-muted">Xem tình trạng các yêu cầu xem phòng trọ của bạn</p>

                        <!-- Filter và Search -->
                        <div class="row mb-4">
                            <div class="col-md-6">
                                <div class="form-group">
                                    <select  class="form-control" id="statusFilter">
                                        <option value="">Tất cả trạng thái</option>
                                        <option value="0">Đang chờ</option>
                                        <option value="1">Đã xem</option>
                                        <option value="2">Từ chối</option>
                                        <option value="3">Đã liên hệ</option>
                                    </select>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="input-group">
                                    <input type="text" class="form-control" placeholder="Tìm kiếm theo tiêu đề phòng..." id="searchInput">
                                    <div class="input-group-append">
                                        <button class="btn btn-outline-secondary" type="button">
                                            <i class="fas fa-search"></i>
                                        </button>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Viewing Requests Table -->
                        <div class="card">
                            <div class="card-header">
                                <h5 class="mb-0">
                                    <i class="fas fa-eye mr-2"></i>
                                    Danh sách yêu cầu xem phòng
                                    <span class="badge badge-info ml-2">${viewingRequests.size()} yêu cầu</span>
                                </h5>
                            </div>
                            <div class="card-body">
                                <c:choose>
                                    <c:when test="${not empty viewingRequests}">
                                        <div class="table-responsive">
                                            <table class="table table-striped table-hover">
                                                <thead class="thead-light">
                                                    <tr>
                                                        <th>STT</th>
                                                        <th>Thông tin phòng</th>
                                                        <th>Thời gian mong muốn</th>
                                                        <th>Lời nhắn</th>
                                                        <th>Ngày gửi</th>
                                                        <th>Trạng thái</th>
                                                        <th>Phản hồi</th>
                                                        <th>Thao tác</th>
                                                    </tr>
                                                </thead>
                                                <tbody>
                                                    <c:forEach var="request" items="${viewingRequests}" varStatus="status">
                                                        <tr>
                                                            <td>${status.index + 1}</td>
                                                            <td>
                                                                <c:choose>
                                                                    <c:when test="${not empty request.roomsInfo}">
                                                                        <div>
                                                                            <strong>${request.roomsInfo}</strong><br>
                                                                            <small class="text-muted">${request.rentalAreaName}</small><br>
                                                                            <small class="text-info">${request.rentalAreaAddress}</small>
                                                                        </div>
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        <div>
                                                                            <strong>${request.postTitle}</strong><br>
                                                                            <small class="text-muted">Thông tin phòng đang cập nhật</small>
                                                                        </div>
                                                                    </c:otherwise>
                                                                </c:choose>
                                                            </td>
                                                            <td>
                                                                <c:choose>
                                                                    <c:when test="${not empty request.preferredDate}">
                                                                        <fmt:formatDate value="${request.preferredDate}" pattern="dd/MM/yyyy HH:mm"/>
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        <span class="text-muted">Chưa chỉ định</span>
                                                                    </c:otherwise>
                                                                </c:choose>
                                                            </td>
                                                            <td>
                                                                <c:choose>
                                                                    <c:when test="${not empty request.message}">
                                                                        <span class="text-truncate d-inline-block" style="max-width: 200px;" title="${request.message}">
                                                                            ${request.message}
                                                                        </span>
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        <span class="text-muted">Không có</span>
                                                                    </c:otherwise>
                                                                </c:choose>
                                                            </td>
                                                            <td>
                                                                <fmt:formatDate value="${request.createdAt}" pattern="dd/MM/yyyy"/>
                                                            </td>
                                                            <td >
                                                                <c:choose>
                                                                    <c:when test="${request.status == 0}">
                                                                        <span style="color: black" class="badge badge-warning">Đang chờ</span>
                                                                    </c:when>
                                                                    <c:when test="${request.status == 1}">
                                                                        <span style="color: black" class="badge badge-info">Đã xem</span>
                                                                    </c:when>
                                                                    <c:when test="${request.status == 2}">
                                                                        <span style="color: black" class="badge badge-danger">Từ chối</span>
                                                                    </c:when>
                                                                    <c:when test="${request.status == 3}">
                                                                        <span style="color: black" class="badge badge-success">Đã liên hệ</span>
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        <span style="color: black" class="badge badge-secondary">Không xác định</span>
                                                                    </c:otherwise>
                                                                </c:choose>
                                                            </td>
                                                            <td>
                                                                <c:choose>
                                                                    <c:when test="${not empty request.adminNote}">
                                                                        <button class="btn btn-sm btn-outline-info" onclick="showAdminNote('${request.adminNote}')" title="Xem phản hồi">
                                                                            <i class="fas fa-comment"></i>
                                                                        </button>
                                                                    </c:when>
                                                                    <c:otherwise>
                                                                        <span class="text-muted">Chưa có</span>
                                                                    </c:otherwise>
                                                                </c:choose>
                                                            </td>
                                                            <td>
                                                                <div class="btn-group btn-group-sm" role="group">
                                                                    <button class="btn btn-outline-primary" onclick="viewDetails('${request.requestId}')" title="Chi tiết">
                                                                        <i class="fas fa-eye"></i>
                                                                    </button>
                                                                    <c:if test="${request.status == 0}">
                                                                        <button class="btn btn-outline-secondary" onclick="cancelRequest('${request.requestId}')" title="Hủy yêu cầu">
                                                                            <i class="fas fa-times"></i>
                                                                        </button>
                                                                    </c:if>
                                                                </div>
                                                            </td>
                                                        </tr>
                                                    </c:forEach>
                                                </tbody>
                                            </table>
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <div class="text-center py-5">
                                            <i class="fas fa-inbox fa-3x text-muted mb-3"></i>
                                            <h5 class="text-muted">Chưa có yêu cầu xem phòng nào</h5>
                                            <p class="text-muted">Bắt đầu tìm kiếm và gửi yêu cầu xem các phòng trọ bạn quan tâm.</p>
                                            <a href="listrooms" class="btn btn-primary">
                                                <i class="fas fa-search mr-2"></i>
                                                Tìm phòng trọ
                                            </a>
                                        </div>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

    <!-- Modal for Admin Note -->
    <div class="modal fade" id="adminNoteModal" tabindex="-1" role="dialog">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Phản hồi từ chủ nhà</h5>
                    <button type="button" class="close" data-dismiss="modal">
                        <span>&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <p id="adminNoteContent"></p>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-dismiss="modal">Đóng</button>
                </div>
            </div>
        </div>
    </div>

    <!-- Modal for Request Details -->
    <div class="modal fade" id="requestDetailModal" tabindex="-1" role="dialog">
        <div class="modal-dialog modal-lg" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Chi tiết yêu cầu xem phòng</h5>
                    <button type="button" class="close" data-dismiss="modal">
                        <span>&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <div class="row">
                        <div class="col-md-6">
                            <h6><i class="fas fa-home mr-2"></i>Thông tin phòng</h6>
                            <p><strong>Phòng:</strong> <span id="detailRoomsInfo"></span></p>
                            <p><strong>Khu trọ:</strong> <span id="detailAreaName"></span></p>
                            <p><strong>Địa chỉ:</strong> <span id="detailAreaAddress"></span></p>
                        </div>
                        <div class="col-md-6">
                            <h6><i class="fas fa-user mr-2"></i>Thông tin liên hệ</h6>
                            <p><strong>Họ tên:</strong> <span id="detailFullName"></span></p>
                            <p><strong>Email:</strong> <span id="detailEmail"></span></p>
                            <p><strong>SĐT:</strong> <span id="detailPhone"></span></p>
                        </div>
                    </div>
                    <hr>
                    <div class="row">
                        <div class="col-md-6">
                            <h6><i class="fas fa-calendar mr-2"></i>Thời gian</h6>
                            <p><strong>Ngày gửi:</strong> <span id="detailCreatedAt"></span></p>
                            <p><strong>Thời gian mong muốn:</strong> <span id="detailPreferredDate"></span></p>
                        </div>
                        <div class="col-md-6">
                            <h6><i class="fas fa-info-circle mr-2"></i>Trạng thái</h6>
                            <p><strong>Hiện tại:</strong> <span id="detailStatus"></span></p>
                            <p><strong>Phản hồi lúc:</strong> <span id="detailResponseDate"></span></p>
                        </div>
                    </div>
                    <hr>
                    <div class="row">
                        <div class="col-12">
                            <h6><i class="fas fa-comment mr-2"></i>Lời nhắn</h6>
                            <p id="detailMessage" class="border p-3 bg-light"></p>
                        </div>
                    </div>
                    <div class="row" id="adminNoteSection" style="display: none;">
                        <div class="col-12">
                            <h6><i class="fas fa-reply mr-2"></i>Phản hồi từ chủ nhà</h6>
                            <p id="detailAdminNote" class="border p-3 bg-info text-white"></p>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-dismiss="modal">Đóng</button>
                </div>
            </div>
        </div>
    </div>        <script>
            function showAdminNote(note) {
                document.getElementById('adminNoteContent').textContent = note;
                $('#adminNoteModal').modal('show');
            }

            function viewDetails(requestId) {
                // Chuyển đến trang chi tiết yêu cầu
                window.location.href = 'viewingRequestDetail?id=' + requestId;
            }

            function cancelRequest(requestId) {
                if (confirm('Bạn có chắc chắn muốn hủy yêu cầu này?')) {
                    // Implement cancel functionality
                    window.location.href = 'cancelViewingRequest?id=' + requestId;
                }
            }

            // Filter functionality
            document.getElementById('statusFilter').addEventListener('change', function () {
                // Implement filter functionality
                filterTable();
            });

            document.getElementById('searchInput').addEventListener('input', function () {
                // Implement search functionality
                filterTable();
            });

            function filterTable() {
                // Simple client-side filtering
                var statusFilter = document.getElementById('statusFilter').value;
                var searchText = document.getElementById('searchInput').value.toLowerCase();
                var rows = document.querySelectorAll('tbody tr');

                rows.forEach(function (row) {
                    var statusCell = row.cells[5];
                    var titleCell = row.cells[1];

                    var statusMatch = !statusFilter || statusCell.querySelector('.badge').textContent.includes(getStatusText(statusFilter));
                    var textMatch = !searchText || titleCell.textContent.toLowerCase().includes(searchText);

                    row.style.display = (statusMatch && textMatch) ? '' : 'none';
                });
            }

            function getStatusText(status) {
                switch (status) {
                    case '0':
                        return 'Đang chờ';
                    case '1':
                        return 'Đã xem';
                    case '2':
                        return 'Từ chối';
                    case '3':
                        return 'Đã liên hệ';
                    default:
                        return '';
                }
            }
        </script>
    </body>
</html>
