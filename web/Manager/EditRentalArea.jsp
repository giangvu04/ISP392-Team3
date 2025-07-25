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
    model.RentalArea rentalArea = (model.RentalArea) request.getAttribute("rentalArea");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Chỉnh sửa khu trọ</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link href="css/homepage.css" rel="stylesheet">
    <style>
        .main-content { margin-top: 40px; }
        .form-section { max-width: 700px; margin: 0 auto; background: #fff; padding: 32px; border-radius: 12px; box-shadow: 0 2px 8px rgba(0,0,0,0.08); }
        .form-title { margin-bottom: 24px; font-size: 1.5rem; font-weight: 600; }
        .btn-group { margin-top: 24px; }
    </style>
</head>
<body>
<div class="container-fluid">
    <div class="row">
        <!-- Sidebar -->
        <jsp:include page="../Sidebar/SideBarManager.jsp"/>
        <div class="col-md-9 col-lg-10">
            <div class="main-content">
                <div class="form-section">
                    <div class="form-title">Chỉnh sửa khu trọ</div>
                    <form action="editrentail" method="post">
                        <input type="hidden" name="rentalAreaId" value="${rentalArea.rentalAreaId}" />
                        <div class="mb-3">
                            <label class="form-label">Tên khu trọ</label>
                            <input type="text" class="form-control" name="name" value="${rentalArea.name}" required />
                        </div>
                        <div class="row mb-3">
                            <div class="col">
                                <label for="province" class="form-label">Tỉnh/Thành phố</label>
                                <select class="form-select" id="province" name="province" required>
                                    <option value="">-- Chọn tỉnh/thành phố --</option>
                                    <% for (String province : provinces) { %>
                                    <option value="<%= province %>" <%= province.equals(rentalArea.getProvince()) ? "selected" : "" %>><%= province %></option>
                                    <% } %>
                                </select>
                            </div>
                            <div class="col">
                                <label for="district" class="form-label">Quận/Huyện</label>
                                <select class="form-select" id="district" name="district" required>
                                    <option value="">-- Chọn quận/huyện --</option>
                                    <c:if test="${not empty rentalArea.district}">
                                        <option value="${rentalArea.district}" selected>${rentalArea.district}</option>
                                    </c:if>
                                </select>
                            </div>
                            <div class="col">
                                <label for="ward" class="form-label">Phường/Xã</label>
                                <select class="form-select" id="ward" name="ward" required>
                                    <option value="">-- Chọn phường/xã --</option>
                                    <c:if test="${not empty rentalArea.ward}">
                                        <option value="${rentalArea.ward}" selected>${rentalArea.ward}</option>
                                    </c:if>
                                </select>
                            </div>
                        </div>
                        <div class="mb-3">
                            <label for="street" class="form-label">Đường/Số nhà</label>
                            <input type="text" class="form-control" id="street" name="street" value="${rentalArea.street}" />
                        </div>
                        <div class="mb-3">
                            <label for="detail" class="form-label">Chi tiết (ngõ, hẻm...)</label>
                            <input type="text" class="form-control" id="detail" name="detail" value="${rentalArea.detail}" />
                        </div>
                        <div class="mb-3">
                            <label for="address" class="form-label">Địa chỉ đầy đủ</label>
                            <input type="text" class="form-control" id="address" name="address" value="${rentalArea.address}" readonly required />
                        </div>
                        <div class="btn-group">
                            <button type="submit" class="btn btn-primary">Lưu thay đổi</button>
                            <a href="RentalList.jsp" class="btn btn-secondary">Quay lại</a>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>
<script>
   $(document).ready(function () {
    function updateAddress() {
        const province = $('#province').val() || '';
        const district = $('#district').val() || '';
        const ward = $('#ward').val() || '';
        const street = $('#street').val() || '';
        const detail = $('#detail').val() || '';
        const addressParts = [detail, street, ward, district, province].filter(part => part.trim() !== '');
        const fullAddress = addressParts.join(', ');
        $('#address').val(fullAddress);
    }
    
    $('#province, #district, #ward').change(updateAddress);
    $('#street, #detail').on('input', updateAddress);
    
    // Load districts/wards if province/district is preselected
    const selectedProvince = "${rentalArea.province}";
    const selectedDistrict = "${rentalArea.district}";
    const selectedWard = "${rentalArea.ward}";
    
    console.log('Initial values:', { selectedProvince, selectedDistrict, selectedWard });
    
    if (selectedProvince) {
        $('#province').val(selectedProvince);
        loadDistricts(selectedProvince, selectedDistrict);
    }
    
    $('#province').change(function () {
        const province = $(this).val();
        $('#district').html('<option value="">-- Chọn quận/huyện --</option>').prop('disabled', true);
        $('#ward').html('<option value="">-- Chọn phường/xã --</option>').prop('disabled', true);
        if (province) {
            loadDistricts(province);
        }
        updateAddress();
    });
    
    $('#district').change(function () {
        const district = $(this).val();
        $('#ward').html('<option value="">-- Chọn phường/xã --</option>').prop('disabled', true);
        if (district) {
            loadWards(district);
        }
        updateAddress();
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
                console.log('Raw districts response:', response);
                console.log('Response type:', typeof response);
                console.log('Is array:', Array.isArray(response));
                
                // Xóa option "Đang tải..." và thêm option mặc định
                districtSelect.html('<option value="">-- Chọn quận/huyện --</option>');
                
                // Nếu response là string, parse JSON
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
                    // Lặp qua từng district và tạo option
                    for (let i = 0; i < districts.length; i++) {
                        const district = districts[i];
                        console.log(`District ${i}:`, district, typeof district);
                        
                        if (district && district !== null && district !== undefined && district !== '') {
                            // Vì district là string, lấy trực tiếp
                            const districtName = district.toString().trim();
                            const districtValue = district.toString().trim();
                            
                            console.log(`Creating district option: value="${districtValue}", text="${districtName}"`);
                            
                            if (districtName && districtValue) {
                                const selected = selectedDistrict === districtValue ? 'selected' : '';
                                
                                // Tạo option element trực tiếp thay vì dùng template string
                                const option = $('<option></option>');
                                option.attr('value', districtValue);
                                option.text(districtName);
                                if (selected) {
                                    option.attr('selected', 'selected');
                                }
                                districtSelect.append(option);
                                
                                console.log(`Added district option:`, option[0]);
                            }
                        }
                    }
                    
                    districtSelect.prop('disabled', false);
                    
                    // Nếu có selectedDistrict và selectedWard, load wards
                    if (selectedDistrict && selectedWard) {
                        loadWards(selectedDistrict, selectedWard);
                    }
                    
                    updateAddress();
                } else {
                    districtSelect.append('<option value="">Không có quận/huyện</option>');
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
                
                // Xóa option "Đang tải..." và thêm option mặc định
                wardSelect.html('<option value="">-- Chọn phường/xã --</option>');
                
                // Nếu response là string, parse JSON
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
                    // Lặp qua từng ward và tạo option
                    for (let i = 0; i < wards.length; i++) {
                        const ward = wards[i];
                        console.log(`Ward ${i}:`, ward, typeof ward);
                        
                        if (ward && ward !== null && ward !== undefined && ward !== '') {
                            // Vì ward là string, lấy trực tiếp  
                            const wardName = ward.toString().trim();
                            const wardValue = ward.toString().trim();
                            
                            console.log(`Creating ward option: value="${wardValue}", text="${wardName}"`);
                            
                            if (wardName && wardValue) {
                                const selected = selectedWard === wardValue ? 'selected' : '';
                                
                                // Tạo option element trực tiếp thay vì dùng template string
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
            }
        });
    }
});
</script>
</body>
</html>
