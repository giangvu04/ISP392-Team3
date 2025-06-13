<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Lỗi</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        .error-container { 
            max-width: 600px; 
            margin: 100px auto; 
            text-align: center; 
        }
        .error-icon { 
            font-size: 5rem; 
            color: #dc3545; 
            margin-bottom: 20px; 
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="error-container">
            <div class="error-icon">
                <i class="fas fa-exclamation-triangle"></i>
            </div>
            <h1 class="text-danger">Đã xảy ra lỗi!</h1>
            <p class="lead">Rất tiếc, đã có lỗi xảy ra trong quá trình xử lý yêu cầu của bạn.</p>
            
            <c:if test="${not empty error}">
                <div class="alert alert-danger">
                    <strong>Chi tiết lỗi:</strong><br>
                    ${error}
                </div>
            </c:if>
            
            <div class="mt-4">
                <a href="javascript:history.back()" class="btn btn-secondary">
                    <i class="fas fa-arrow-left"></i> Quay lại
                </a>
                <a href="index.html" class="btn btn-primary">
                    <i class="fas fa-home"></i> Về trang chủ
                </a>
            </div>
        </div>
    </div>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html> 