<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Quản lý Khu trọ - Manager Dashboard</title>
        <base href="${pageContext.request.contextPath}/">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
        <link href="css/rooms.css" rel="stylesheet">
    </head>
    <body>
        <div class="container-fluid">
            <div class="row">
                <!-- Sidebar -->
                <jsp:include page="../Sidebar/SideBarManager.jsp"/>

                <!-- Main Content -->
                <div class="col-md-9 col-lg-10">
                    <div class="main-content p-4">
                        <!-- Header -->
                        <div class="d-flex justify-content-between align-items-center mb-4">
                            <div>
                                <h2 class="mb-1">Quản lý Khu trọ</h2>
                                <p class="text-muted mb-0">Quản lý tất cả khu trọ bạn quản lý</p>
                            </div>
                            <div>
                                <a href="add_rentail" class="btn btn-primary">
                                    <i class="fas fa-plus me-2"></i>
                                    Thêm khu trọ mới
                                </a>
                            </div>
                        </div>

                        <!-- Search and Filter -->
                        <div class="card mb-4">
                            <div class="card-body">
                                <form method="GET" action="listrentail" class="row g-3">
                                    <div class="col-md-4">
                                        <div class="search-box" style="display: flex; align-items: center;">
                                            <i class="fas fa-search text-muted me-2" style="font-size: 16px;"></i>
                                            <input type="text" class="form-control border-0 py-0" name="searchTerm" 
                                                   placeholder="Tìm kiếm theo tên khu trọ..." 
                                                   value="${searchTerm}">
                                        </div>
                                    </div>


                                    <div class="col-md-4">
                                        <select class="form-select" name="sortBy">
                                            <option value="name" ${sortBy == 'name' ? 'selected' : ''}>Sắp xếp theo tên</option>
                                            <option value="address" ${sortBy == 'address' ? 'selected' : ''}>Sắp xếp theo địa chỉ</option>
                                            <option value="totalRooms" ${sortBy == 'totalRooms' ? 'selected' : ''}>Sắp xếp theo số phòng</option>
                                        </select>
                                    </div>
                                    <div class="col-md-4">
                                        <select class="form-select" name="sortOrder">
                                            <option value="asc" ${sortOrder == 'asc' ? 'selected' : ''}>Tăng dần</option>
                                            <option value="desc" ${sortOrder == 'desc' ? 'selected' : ''}>Giảm dần</option>
                                        </select>
                                    </div>
                                    <div class="col-md-4">
                                        <select class="form-select" id="province" name="province">
                                            <option value="">-- Tỉnh/Thành phố --</option>
                                            <c:forEach var="province" items="${provinces}">
                                                <option value="${province}" ${province == selectedProvince ? 'selected' : ''}>${province}</option>
                                            </c:forEach>
                                        </select>
                                    </div>
                                    <div class="col-md-4">
                                        <select class="form-select" id="district" name="district" disabled>
                                            <option value="">-- Quận/Huyện --</option>
                                        </select>
                                    </div>
                                    <div class="col-md-4">
                                        <select class="form-select" id="ward" name="ward" disabled>
                                            <option value="">-- Phường/Xã --</option>
                                        </select>
                                    </div>
                                    <div class="col-md-3">
                                        <button style="width: 100%" type="submit" class="btn btn-primary me-2">
                                            <i class="fas fa-search me-1"></i>
                                            Tìm kiếm
                                        </button>
                                    </div>
                                    <div class="col-md-3">
                                        <a style="width: 100%" href="listrentail" class="btn btn-outline-secondary">
                                            <i class="fas fa-refresh me-1"></i>
                                            Làm mới
                                        </a>
                                    </div>     
                                </form>
                            </div>
                        </div>

                        <!-- Error Message -->
                        <c:if test="${not empty error}">
                            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                                <i class="fas fa-exclamation-triangle me-2"></i>
                                ${error}
                                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                            </div>
                        </c:if>

                        <!-- Rental Areas Table -->
                        <div class="card">
                            <div class="card-header bg-primary text-white">
                                <h5 class="mb-0">
                                    <i class="fas fa-list me-2"></i>
                                    Danh sách khu trọ (${totalRentail} khu trọ)
                                </h5>
                            </div>
                            <div class="card-body p-0">
                                <div class="table-responsive">
                                    <table class="table table-hover mb-0">
                                        <thead>
                                            <tr>
                                                <th>Tên khu trọ</th>
                                                <th>Địa chỉ</th>
                                                <th>Số phòng</th>
                                                <th>Trạng thái</th>
                                                <th>Thao tác</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach var="rentail" items="${rentails}">
                                                <tr>
                                                    <td><strong>${rentail.name}</strong></td>
                                                    <td>${rentail.address}</td>
                                                    <td>${rentail.totalRooms}</td>
                                                    <td >
                                                        ${rentail.createdAt}
                                                    </td>
                                                    <td>
                                                        <div class="btn-group" role="group">
                                                            <a href="detailrentail?id=${rentail.rentalAreaId}" class="btn btn-sm btn-outline-info" title="Xem chi tiết">
                                                                <i class="fas fa-eye"></i>
                                                            </a>
                                                            <a href="editrentail?id=${rentail.rentalAreaId}" class="btn btn-sm btn-outline-warning" title="Chỉnh sửa">
                                                                <i class="fas fa-edit"></i>
                                                            </a>
                                                        </div>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </div>

                                <!-- Empty State -->
                                <c:if test="${empty rentails}">
                                    <div class="text-center py-5">
                                        <i class="fas fa-building fa-3x text-muted mb-3"></i>
                                        <h5 class="text-muted">Không tìm thấy khu trọ nào</h5>
                                        <p class="text-muted">Thử thay đổi tiêu chí tìm kiếm hoặc thêm khu trọ mới.</p>
                                    </div>
                                </c:if>
                            </div>
                        </div>

                        <!-- Pagination -->
                        <c:if test="${totalPages > 1}">
                            <nav aria-label="Rental pagination" class="mt-4">
                                <ul class="pagination justify-content-center">
                                    <li class="page-item ${currentPage == 1 ? 'disabled' : ''}">
                                        <a class="page-link" href="listrentail?page=${currentPage - 1}&sortBy=${sortBy}&sortOrder=${sortOrder}&searchTerm=${searchTerm}&province=${selectedProvince}&district=${selectedDistrict}&ward=${selectedWard}">
                                            <i class="fas fa-chevron-left"></i>
                                        </a>
                                    </li>

                                    <c:forEach begin="1" end="${totalPages}" var="i">
                                        <li class="page-item ${currentPage == i ? 'active' : ''}">
                                            <a class="page-link" href="listrentail?page=${i}&sortBy=${sortBy}&sortOrder=${sortOrder}&searchTerm=${searchTerm}&province=${selectedProvince}&district=${selectedDistrict}&ward=${selectedWard}">${i}</a>
                                        </li>
                                    </c:forEach>

                                    <li class="page-item ${currentPage == totalPages ? 'disabled' : ''}">
                                        <a class="page-link" href="listrentail?page=${currentPage + 1}&sortBy=${sortBy}&sortOrder=${sortOrder}&searchTerm=${searchTerm}&province=${selectedProvince}&district=${selectedDistrict}&ward=${selectedWard}">
                                            <i class="fas fa-chevron-right"></i>
                                        </a>
                                    </li>
                                </ul>
                            </nav>
                        </c:if>
                    </div>
                </div>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        <jsp:include page="../Message.jsp"/>
        <script>
            // JS filter địa chỉ dùng lại từ AddRentalArea.jsp
            $(document).ready(function () {
                function loadDistricts(province, selectedDistrict = null) {
                    const districtSelect = $('#district');
                    $.ajax({
                        url: 'api/address',
                        method: 'GET',
                        data: {type: 'districts', province: province},
                        dataType: 'json',
                        beforeSend: function () {
                            districtSelect.prop('disabled', true);
                            districtSelect.html('<option value="">Đang tải...</option>');
                        },
                        success: function (response) {
                            districtSelect.html('<option value="">-- Quận/Huyện --</option>');
                            let districts;
                            if (typeof response === 'string') {
                                try {
                                    districts = JSON.parse(response);
                                } catch (e) {
                                    districts = [];
                                }
                            } else {
                                districts = Array.isArray(response) ? response : (response.data || response.districts || []);
                            }
                            if (districts && districts.length > 0) {
                                for (let i = 0; i < districts.length; i++) {
                                    const district = districts[i];
                                    if (district) {
                                        const districtName = district.toString().trim();
                                        const districtValue = district.toString().trim();
                                        const selected = selectedDistrict === districtValue ? 'selected' : '';
                                        const option = $('<option></option>');
                                        option.attr('value', districtValue);
                                        option.text(districtName);
                                        if (selected)
                                            option.attr('selected', 'selected');
                                        districtSelect.append(option);
                                    }
                                }
                                districtSelect.prop('disabled', false);
                            } else {
                                districtSelect.append('<option value="">Không có quận/huyện</option>');
                            }
                        },
                        error: function () {
                            districtSelect.html('<option value="">-- Chọn quận/huyện --</option>');
                            districtSelect.append('<option value="">Lỗi tải quận/huyện</option>');
                        }
                    });
                }
                function loadWards(district, selectedWard = null) {
                    const wardSelect = $('#ward');
                    $.ajax({
                        url: 'api/address',
                        method: 'GET',
                        data: {type: 'wards', district: district},
                        dataType: 'json',
                        beforeSend: function () {
                            wardSelect.prop('disabled', true);
                            wardSelect.html('<option value="">Đang tải...</option>');
                        },
                        success: function (response) {
                            wardSelect.html('<option value="">-- Phường/Xã --</option>');
                            let wards;
                            if (typeof response === 'string') {
                                try {
                                    wards = JSON.parse(response);
                                } catch (e) {
                                    wards = [];
                                }
                            } else {
                                wards = Array.isArray(response) ? response : (response.data || response.wards || []);
                            }
                            if (wards && wards.length > 0) {
                                for (let i = 0; i < wards.length; i++) {
                                    const ward = wards[i];
                                    if (ward) {
                                        const wardName = ward.toString().trim();
                                        const wardValue = ward.toString().trim();
                                        const selected = selectedWard === wardValue ? 'selected' : '';
                                        const option = $('<option></option>');
                                        option.attr('value', wardValue);
                                        option.text(wardName);
                                        if (selected)
                                            option.attr('selected', 'selected');
                                        wardSelect.append(option);
                                    }
                                }
                                wardSelect.prop('disabled', false);
                            } else {
                                wardSelect.append('<option value="">Không có phường/xã</option>');
                            }
                        },
                        error: function () {
                            wardSelect.html('<option value="">-- Chọn phường/xã --</option>');
                            wardSelect.append('<option value="">Lỗi tải phường/xã</option>');
                        }
                    });
                }
                $('#province').change(function () {
                    const province = $(this).val();
                    const districtSelect = $('#district');
                    const wardSelect = $('#ward');
                    districtSelect.html('<option value="">-- Chọn quận/huyện --</option>').prop('disabled', true);
                    wardSelect.html('<option value="">-- Chọn phường/xã --</option>').prop('disabled', true);
                    if (province)
                        loadDistricts(province);
                });
                $('#district').change(function () {
                    const district = $(this).val();
                    const wardSelect = $('#ward');
                    wardSelect.html('<option value="">-- Chọn phường/xã --</option>').prop('disabled', true);
                    if (district)
                        loadWards(district);
                });
            });
        </script>
        <script>
            document.addEventListener('DOMContentLoaded', function () {
                const currentPath = window.location.pathname;
                const navLinks = document.querySelectorAll('.nav-link');
                navLinks.forEach(link => {
                    if (link.getAttribute('href') && currentPath.includes(link.getAttribute('href'))) {
                        link.classList.add('active');
                    }
                });
            });
        </script>
    </body>
</html>
