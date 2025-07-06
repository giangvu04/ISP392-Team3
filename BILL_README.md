# Hướng dẫn sử dụng chức năng Tạo Bill

## Tổng quan
Chức năng tạo bill mới cho phép Manager tạo hóa đơn cho người thuê với các thông tin chi tiết về tiền điện, nước, dịch vụ và các thông tin khác.

## Cách truy cập
1. Đăng nhập với tài khoản Manager
2. Vào menu "Hóa đơn" trong sidebar
3. Click nút "Thêm hóa đơn" ở góc phải trên

## Các trường thông tin

### Thông tin cơ bản
- **Tên người thuê** (bắt buộc): Tên đầy đủ của người thuê
  - Có tính năng auto-complete từ danh sách người thuê đã có
  - Hỗ trợ tìm kiếm theo tên

- **Số phòng** (bắt buộc): Số phòng của người thuê
  - Có tính năng auto-complete từ danh sách phòng đã có
  - Định dạng: A101, B201, C301, v.v.

### Chi phí
- **Tiền điện** (bắt buộc): Số tiền điện tháng này
  - Nhập số dương, không được âm
  - Đơn vị: VNĐ

- **Tiền nước** (bắt buộc): Số tiền nước tháng này
  - Nhập số dương, không được âm
  - Đơn vị: VNĐ

- **Phí dịch vụ** (bắt buộc): Phí dịch vụ, internet, vệ sinh, v.v.
  - Nhập số dương, không được âm
  - Đơn vị: VNĐ

### Thông tin khác
- **Hạn thanh toán** (bắt buộc): Ngày hạn chót thanh toán
  - Mặc định: 30 ngày từ ngày tạo
  - Có thể thay đổi theo nhu cầu

- **Trạng thái** (bắt buộc): Trạng thái hiện tại của hóa đơn
  - Chưa thanh toán (Unpaid) - mặc định
  - Đã thanh toán (Paid)
  - Đang xử lý (Pending)

## Tính năng đặc biệt

### Auto-complete
- **Tên người thuê**: Gợi ý từ danh sách người thuê đã có trong hệ thống
- **Số phòng**: Gợi ý từ danh sách phòng đã có trong hệ thống

### Tính toán tự động
- **Tổng tiền**: Tự động tính tổng từ tiền điện + nước + dịch vụ
- **Hiển thị chi tiết**: Hiển thị breakdown chi tiết các khoản phí

### Validation
- **Validation real-time**: Kiểm tra lỗi ngay khi nhập
- **Validation khi submit**: Kiểm tra đầy đủ trước khi lưu
- **Thông báo lỗi chi tiết**: Hiển thị lỗi cụ thể cho từng trường

## Quy trình tạo bill

1. **Điền thông tin cơ bản**
   - Nhập tên người thuê (có thể sử dụng auto-complete)
   - Nhập số phòng (có thể sử dụng auto-complete)

2. **Nhập các khoản phí**
   - Nhập tiền điện
   - Nhập tiền nước
   - Nhập phí dịch vụ
   - Hệ thống tự động tính tổng

3. **Thiết lập thông tin khác**
   - Chọn hạn thanh toán
   - Chọn trạng thái

4. **Lưu hóa đơn**
   - Click "Lưu hóa đơn"
   - Hệ thống kiểm tra và lưu vào database
   - Hiển thị thông báo thành công với chi tiết

## Thông báo kết quả

### Thành công
```
✅ Thêm hóa đơn thành công!
📋 Chi tiết:
• Người thuê: [Tên người thuê]
• Phòng: [Số phòng]
• Tổng tiền: [Số tiền] ₫
• Hạn thanh toán: [Ngày]
• Trạng thái: [Trạng thái]
```

### Lỗi
- Hiển thị thông báo lỗi cụ thể cho từng trường
- Tự động focus vào trường có lỗi
- Hướng dẫn cách sửa lỗi

## Lưu ý quan trọng

1. **Quyền truy cập**: Chỉ Manager mới có thể tạo bill
2. **Dữ liệu bắt buộc**: Tất cả các trường đều bắt buộc
3. **Validation**: Hệ thống kiểm tra nghiêm ngặt dữ liệu đầu vào
4. **Auto-complete**: Dữ liệu được lấy từ database thực tế
5. **Tính toán**: Tổng tiền được tính tự động, không thể chỉnh sửa trực tiếp

## Troubleshooting

### Lỗi thường gặp
1. **"Tên người thuê không được để trống"**
   - Giải pháp: Nhập tên người thuê

2. **"Tiền điện phải là số hợp lệ"**
   - Giải pháp: Nhập số dương, không nhập ký tự đặc biệt

3. **"Tổng tiền phải lớn hơn 0"**
   - Giải pháp: Đảm bảo ít nhất một khoản phí > 0

4. **Auto-complete không hoạt động**
   - Giải pháp: Kiểm tra kết nối mạng, refresh trang

### Liên hệ hỗ trợ
Nếu gặp vấn đề khác, vui lòng liên hệ admin hoặc developer để được hỗ trợ. 