<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>
<%
    model.Users user = (model.Users) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("login");
        return;
    }
    Integer managerId = user.getUserId();
    java.util.List<String> provinces = Ultils.ReadFile.loadAllProvinces(request);
%>
<!DOCTYPE html>
<html>
    <head>
        <title>Thêm khu trọ mới</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
        <link href="css/homepage.css" rel="stylesheet">
    </head>
    <body>
        <div class="container-fluid">
            <div class="row">
                <!-- Sidebar -->
                <jsp:include page="../Sidebar/SideBarManager.jsp"/>
                <div class="col-md-9 col-lg-10">
                    <div class="main-content mt-5">
                        <h2 class="mb-4">Thêm khu trọ mới</h2>
                        <% String message = (String) request.getAttribute("message"); %>
                        <% String error = (String) request.getAttribute("error"); %>
                        <% if (message != null) { %>
                            <div class="alert alert-success alert-dismissible fade show mt-3" role="alert">
                                <i class="fas fa-check-circle me-2"></i> <%= message %>
                                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                            </div>
                        <% } %>
                        <% if (error != null) { %>
                            <div class="alert alert-danger alert-dismissible fade show mt-3" role="alert">
                                <i class="fas fa-exclamation-circle me-2"></i> <%= error %>
                                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                            </div>
                        <% } %>
                        <form action="add_rentail" method="POST">
                            <input type="hidden" name="user_id" value="<%= managerId %>">
                            <div class="mb-3">
                                <label for="name" class="form-label">Tên khu trọ</label>
                                <input type="text" class="form-control" id="name" name="name" required>
                            </div>
                            <div class="row mb-3">
                                <div class="col">
                                    <label for="province" class="form-label">Tỉnh/Thành phố</label>
                                    <select class="form-select" id="province" name="province" required>
                                        <option value="">-- Chọn tỉnh/thành phố --</option>
                                        <% for (String province : provinces) { %>
                                        <option value="<%= province %>"><%= province %></option>
                                        <% } %>
                                    </select>
                                </div>
                                <div class="col">
                                    <label for="district" class="form-label">Quận/Huyện</label>
                                    <select class="form-select" id="district" name="district" required disabled>
                                        <option value="">-- Chọn quận/huyện --</option>
                                    </select>
                                </div>
                                <div class="col">
                                    <label for="ward" class="form-label">Phường/Xã</label>
                                    <select class="form-select" id="ward" name="ward" required disabled>
                                        <option value="">-- Chọn phường/xã --</option>
                                    </select>
                                </div>
                            </div>
                            <div class="mb-3">
                                <label for="street" class="form-label">Đường/Số nhà</label>
                                <input type="text" class="form-control" id="street" name="street">
                            </div>
                            <div class="mb-3">
                                <label for="detail" class="form-label">Chi tiết (ngõ, hẻm...)</label>
                                <input type="text" class="form-control" id="detail" name="detail">
                            </div>
                            <div class="mb-3">
                                <label for="address" class="form-label">Địa chỉ đầy đủ</label>
                                <input type="text" class="form-control" id="address" name="address" readonly required>
                            </div>
                            <button type="submit" class="btn btn-primary">Thêm khu trọ</button>
                        </form>
                    </div>
                </div>
            </div>
        </div>
        <script>
            $(document).ready(function () {
                // Function to update address field
                function updateAddress() {
                    const province = $('#province').val() || '';
                    const district = $('#district').val() || '';
                    const ward = $('#ward').val() || '';
                    const street = $('#street').val() || '';
                    const detail = $('#detail').val() || '';

                    const addressParts = [detail, street, ward, district, province].filter(part => part.trim() !== '');
                    const fullAddress = addressParts.join(', ');
                    $('#address').val(fullAddress);

                    console.log('Updated address:', fullAddress);
                }

                // Bind updateAddress to input and change events
                $('#province, #district, #ward').change(updateAddress);
                $('#street, #detail').on('input', updateAddress);

                // Initialize address for search values
                const searchProvince = '<%= request.getAttribute("searchProvince") != null ? request.getAttribute("searchProvince") : "" %>';
                const searchDistrict = '<%= request.getAttribute("searchDistrict") != null ? request.getAttribute("searchDistrict") : "" %>';
                const searchWard = '<%= request.getAttribute("searchWard") != null ? request.getAttribute("searchWard") : "" %>';

                console.log('Search values:', {searchProvince, searchDistrict, searchWard});

                if (searchProvince) {
                    $('#province').val(searchProvince);
                    updateAddress();
                }

                // Original code unchanged below
                if (searchProvince) {
                    $('#province').val(searchProvince);
                    if (searchProvince) {
                        loadDistricts(searchProvince, searchDistrict);
                    } else {
                        toastr.warning('Giá trị tỉnh/thành phố không hợp lệ!');
                    }
                }

                // Handle province change
                $('#province').change(function () {
                    const province = $(this).val();
                    const districtSelect = $('#district');
                    const wardSelect = $('#ward');

                    districtSelect.html('<option value="">-- Chọn quận/huyện --</option>').prop('disabled', true);
                    wardSelect.html('<option value="">-- Chọn phường/xã --</option>').prop('disabled', true);

                    if (province) {
                        loadDistricts(province);
                    }
                });

                // Handle district change
                $('#district').change(function () {
                    const district = $(this).val();
                    const wardSelect = $('#ward');

                    wardSelect.html('<option value="">-- Chọn phường/xã --</option>').prop('disabled', true);

                    if (district) {
                        loadWards(district);
                    }
                });

                // Form validation
                $('form').submit(function (e) {
                    if (!$('#province').val() || !$('#district').val() || !$('#ward').val()) {
                        e.preventDefault();
                        toastr.error('Vui lòng chọn đầy đủ tỉnh, quận/huyện và phường/xã!');
                    }
                });

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
                            console.log('Raw response:', response);
                            console.log('Response type:', typeof response);
                            console.log('Is array:', Array.isArray(response));

                            districtSelect.html('<option value="">-- Chọn quận/huyện --</option>');

                            let districts;
                            if (typeof response === 'string') {
                                try {
                                    districts = JSON.parse(response);
                                } catch (e) {
                                    console.error('JSON parse error:', e);
                                    districts = [];
                                }
                            } else {
                                districts = Array.isArray(response) ? response : (response.data || response.districts || []);
                            }

                            console.log('Processed districts:', districts);

                            if (districts && districts.length > 0) {
                                for (let i = 0; i < districts.length; i++) {
                                    const district = districts[i];
                                    console.log(`District ${i}:`, district, typeof district);

                                    if (district && district !== null && district !== undefined && district !== '') {
                                        const districtName = district.toString().trim();
                                        const districtValue = district.toString().trim();

                                        console.log(`Creating option: value="${districtValue}", text="${districtName}"`);

                                        if (districtName && districtValue) {
                                            const selected = selectedDistrict === districtValue ? 'selected' : '';

                                            const option = $('<option></option>');
                                            option.attr('value', districtValue);
                                            option.text(districtName);
                                            if (selected) {
                                                option.attr('selected', 'selected');
                                            }
                                            districtSelect.append(option);

                                            console.log(`Added option:`, option[0]);
                                        }
                                    }
                                }

                                districtSelect.prop('disabled', false);
                                updateAddress();

                                if (selectedDistrict && searchWard) {
                                    loadWards(selectedDistrict, searchWard);
                                }
                            } else {
                                districtSelect.append('<option value="">Không có quận/huyện</option>');
                                toastr.warning(`Không tìm thấy quận/huyện cho tỉnh ${province}`);
                                console.warn('Empty or invalid districts response:', response);
                            }
                        },
                        error: function (xhr, status, error) {
                            console.error('Error loading districts for province', province, ':', {
                                status: status,
                                error: error,
                                responseText: xhr.responseText,
                                responseJSON: xhr.responseJSON
                            });

                            districtSelect.html('<option value="">-- Chọn quận/huyện --</option>');
                            districtSelect.append('<option value="">Lỗi tải quận/huyện</option>');
                            toastr.error('Không thể tải danh sách quận/huyện. Vui lòng thử lại.');
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
                            console.log('Raw wards response:', response);
                            console.log('Response type:', typeof response);
                            console.log('Is array:', Array.isArray(response));

                            wardSelect.html('<option value="">-- Chọn phường/xã --</option>');

                            let wards;
                            if (typeof response === 'string') {
                                try {
                                    wards = JSON.parse(response);
                                } catch (e) {
                                    console.error('JSON parse error:', e);
                                    wards = [];
                                }
                            } else {
                                wards = Array.isArray(response) ? response : (response.data || response.wards || []);
                            }

                            console.log('Processed wards:', wards);

                            if (wards && wards.length > 0) {
                                for (let i = 0; i < wards.length; i++) {
                                    const ward = wards[i];
                                    console.log(`Ward ${i}:`, ward, typeof ward);

                                    if (ward && ward !== null && ward !== undefined && ward !== '') {
                                        const wardName = ward.toString().trim();
                                        const wardValue = ward.toString().trim();

                                        console.log(`Creating ward option: value="${wardValue}", text="${wardName}"`);

                                        if (wardName && wardValue) {
                                            const selected = selectedWard === wardValue ? 'selected' : '';

                                            const option = $('<option></option>');
                                            option.attr('value', wardValue);
                                            option.text(wardName);
                                            if (selected) {
                                                option.attr('selected', 'selected');
                                            }
                                            wardSelect.append(option);

                                            console.log(`Added ward option:`, option[0]);
                                        }
                                    }
                                }

                                wardSelect.prop('disabled', false);
                                updateAddress();
                            } else {
                                wardSelect.append('<option value="">Không có phường/xã</option>');
                                toastr.warning(`Không tìm thấy phường/xã cho quận/huyện ${district}`);
                                console.warn('Empty or invalid wards response:', response);
                            }
                        },
                        error: function (xhr, status, error) {
                            console.error('Error loading wards for district', district, ':', {
                                status: status,
                                error: error,
                                responseText: xhr.responseText,
                                responseJSON: xhr.responseJSON
                            });

                            wardSelect.html('<option value="">-- Chọn phường/xã --</option>');
                            wardSelect.append('<option value="">Lỗi tải phường/xã</option>');
                            toastr.error('Không thể tải danh sách phường/xã. Vui lòng thử lại.');
                        }
                    });
                }
            });
        </script>
    </body>
</html>
