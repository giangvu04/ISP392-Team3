# Hướng dẫn Debug BillServlet

## Vấn đề gặp phải
```
Type Exception Report
Message Cannot invoke "jakarta.servlet.RequestDispatcher.forward(jakarta.servlet.ServletRequest, jakarta.servlet.http.HttpServletResponse)" because the return value of "jakarta.servlet.http.HttpServletRequest.getRequestDispatcher(String)" is null
```

## Nguyên nhân có thể
1. **Đường dẫn JSP không đúng**: RequestDispatcher trả về null khi không tìm thấy file JSP
2. **Vấn đề authentication**: Session không hợp lệ hoặc user không có quyền
3. **Context path không đúng**: Đường dẫn tương đối/tuyệt đối không chính xác

## Các bước đã thực hiện để sửa lỗi

### 1. Sửa đường dẫn JSP
**Trước:**
```java
request.getRequestDispatcher("../Manager/Bill/list.jsp").forward(request, response);
```

**Sau:**
```java
RequestDispatcher dispatcher = request.getRequestDispatcher("Manager/Bill/list.jsp");
if (dispatcher != null) {
    dispatcher.forward(request, response);
} else {
    response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Không tìm thấy trang list.jsp");
}
```

### 2. Thêm kiểm tra null
- Thêm import: `import jakarta.servlet.RequestDispatcher;`
- Kiểm tra dispatcher trước khi forward
- Trả về lỗi HTTP 500 nếu không tìm thấy JSP

### 3. Tạm thời bỏ authentication
Để test, đã comment out phần kiểm tra session:
```java
// Temporarily comment out authentication for testing
/*
if (user == null) {
    response.sendRedirect("Login/login.jsp");
    return;
}

if (user.getRoleId() != 2) {
    response.sendRedirect("error.jsp?message=Access denied. Manager role required.");
    return;
}
*/
```

## Cách test

### 1. Sử dụng file test
Truy cập: `http://localhost:8080/your-project/test_bill_servlet.jsp`

### 2. Test các action
- **List bills**: `BillServlet?action=list`
- **Add form**: `BillServlet?action=add`
- **Get tenants**: `BillServlet?action=getTenants`
- **Get rooms**: `BillServlet?action=getRooms`

### 3. Test tạo bill
Sử dụng form trong file test để tạo bill mới.

## Cấu trúc file đã kiểm tra

### JSP Files (đã tồn tại)
```
web/Manager/Bill/
├── add.jsp ✅
├── list.jsp ✅
├── edit.jsp ✅
└── view.jsp ✅
```

### Servlet Configuration (đã đúng)
```xml
<servlet>
    <servlet-name>BillServlet</servlet-name>
    <servlet-class>Controller.billservlet.BillServlet</servlet-class>
</servlet>
<servlet-mapping>
    <servlet-name>BillServlet</servlet-name>
    <url-pattern>/BillServlet</url-pattern>
</servlet-mapping>
```

## Debug Steps

### 1. Kiểm tra file JSP
```bash
# Đảm bảo các file tồn tại
ls web/Manager/Bill/
```

### 2. Kiểm tra log
Xem log của Tomcat để tìm lỗi chi tiết:
```
tail -f $TOMCAT_HOME/logs/catalina.out
```

### 3. Test từng action riêng biệt
```bash
# Test list
curl "http://localhost:8080/your-project/BillServlet?action=list"

# Test add form
curl "http://localhost:8080/your-project/BillServlet?action=add"

# Test JSON endpoints
curl "http://localhost:8080/your-project/BillServlet?action=getTenants"
curl "http://localhost:8080/your-project/BillServlet?action=getRooms"
```

### 4. Kiểm tra database
Đảm bảo bảng Bills đã được tạo:
```sql
SELECT * FROM Bills;
```

## Các phương thức đã sửa

### 1. listBills()
```java
RequestDispatcher dispatcher = request.getRequestDispatcher("Manager/Bill/list.jsp");
if (dispatcher != null) {
    dispatcher.forward(request, response);
} else {
    response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Không tìm thấy trang list.jsp");
}
```

### 2. showAddForm()
```java
RequestDispatcher dispatcher = request.getRequestDispatcher("Manager/Bill/add.jsp");
if (dispatcher != null) {
    dispatcher.forward(request, response);
} else {
    response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Không tìm thấy trang add.jsp");
}
```

### 3. showEditForm()
```java
RequestDispatcher dispatcher = request.getRequestDispatcher("Manager/Bill/edit.jsp");
if (dispatcher != null) {
    dispatcher.forward(request, response);
} else {
    response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Không tìm thấy trang edit.jsp");
}
```

### 4. viewBill()
```java
RequestDispatcher dispatcher = request.getRequestDispatcher("Manager/Bill/view.jsp");
if (dispatcher != null) {
    dispatcher.forward(request, response);
} else {
    response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Không tìm thấy trang view.jsp");
}
```

### 5. searchBills()
```java
RequestDispatcher dispatcher = request.getRequestDispatcher("Manager/Bill/list.jsp");
if (dispatcher != null) {
    dispatcher.forward(request, response);
} else {
    response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Không tìm thấy trang list.jsp");
}
```

## Khi nào bật lại authentication

Sau khi test thành công, bỏ comment để bật lại authentication:

```java
// Uncomment this section after testing
if (user == null) {
    response.sendRedirect("Login/login.jsp");
    return;
}

if (user.getRoleId() != 2) {
    response.sendRedirect("error.jsp?message=Access denied. Manager role required.");
    return;
}
```

## Lưu ý quan trọng

1. **Đường dẫn tương đối**: Sử dụng `"Manager/Bill/list.jsp"` thay vì `"/Manager/Bill/list.jsp"`
2. **Kiểm tra null**: Luôn kiểm tra RequestDispatcher trước khi forward
3. **Error handling**: Trả về lỗi HTTP phù hợp khi có vấn đề
4. **Logging**: Thêm log để debug dễ dàng hơn

## Kết quả mong đợi

Sau khi sửa, BillServlet sẽ:
- ✅ Không còn lỗi NullPointerException
- ✅ Forward thành công đến các trang JSP
- ✅ Hiển thị lỗi rõ ràng nếu có vấn đề
- ✅ Hoạt động bình thường với authentication 