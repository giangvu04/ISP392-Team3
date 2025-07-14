<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Danh sách phòng</title>
        <base href="${pageContext.request.contextPath}/">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
        <link href="css/homepage.css" rel="stylesheet">
        <style>
            .search-card {
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                color: white;
            }
            .room-card {
                transition: transform 0.2s;
                border: 1px solid #dee2e6;
            }
            .room-card:hover {
                transform: translateY(-2px);
                box-shadow: 0 4px 12px rgba(0,0,0,0.1);
            }
            .room-status {
                border-radius: 15px;
                padding: 4px 12px;
                font-size: 0.8em;
                font-weight: 500;
            }
            .status-available {
                background-color: #d4edda;
                color: #155724;
            }
            .status-occupied {
                background-color: #f8d7da;
                color: #721c24;
            }
            .status-maintenance {
                background-color: #fff3cd;
                color: #856404;
            }
            .filter-btn {
                margin-right: 10px;
                margin-bottom: 10px;
            }
            .pagination-custom {
                background: #f8f9fa;
                border-radius: 10px;
                padding: 15px;
            }
            .room-price {
                font-size: 1.2em;
                font-weight: bold;
                color: #28a745;
            }
            .room-capacity {
                color: #6c757d;
            }
        </style>
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
                                <h2 class="mb-1">Danh sách phòng</h2>
                                <p class="text-muted mb-0">Quản lý thông tin phòng ký túc xá</p>
                            </div>
                            <div>
                                <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#addRoomModal">
                                    <i class="fas fa-plus me-2"></i>
                                    Thêm phòng mới
                                </button>
                            </div>
                        </div>

                        <!-- Search and Filter Section -->
                        <div class="card search-card mb-4">
                            <div class="card-body">
                                <div class="row">
                                    <div class="col-md-6 mb-3">
                                        <label class="form-label">Tìm kiếm</label>
                                        <div class="input-group">
                                            <input type="text" class="form-control" id="searchInput" placeholder="Nhập tên phòng hoặc mã phòng...">
                                            <button class="btn btn-light" type="button" id="searchBtn">
                                                <i class="fas fa-search"></i>
                                            </button>
                                        </div>
                                    </div>
                                    <div class="col-md-3 mb-3">
                                        <label class="form-label">Trạng thái</label>
                                        <select class="form-select" id="statusFilter">
                                            <option value="">Tất cả</option>
                                            <option value="available">Phòng trống</option>
                                            <option value="occupied">Đã thuê</option>
                                            <option value="maintenance">Bảo trì</option>
                                        </select>
                                    </div>
                                    <div class="col-md-3 mb-3">
                                        <label class="form-label">Loại phòng</label>
                                        <select class="form-select" id="typeFilter">
                                            <option value="">Tất cả</option>
                                            <option value="single">Phòng đơn</option>
                                            <option value="double">Phòng đôi</option>
                                            <option value="quad">Phòng 4 người</option>
                                        </select>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Quick Filter Buttons -->
                        <div class="mb-4">
                            <button class="btn btn-outline-primary filter-btn" data-filter="all">
                                <i class="fas fa-list me-1"></i>
                                Tất cả (25)
                            </button>
                            <button class="btn btn-outline-success filter-btn" data-filter="available">
                                <i class="fas fa-door-open me-1"></i>
                                Phòng trống (7)
                            </button>
                            <button class="btn btn-outline-danger filter-btn" data-filter="occupied">
                                <i class="fas fa-user-check me-1"></i>
                                Đã thuê (16)
                            </button>
                            <button class="btn btn-outline-warning filter-btn" data-filter="maintenance">
                                <i class="fas fa-tools me-1"></i>
                                Bảo trì (2)
                            </button>
                        </div>

                        <!-- Rooms Grid -->
                        <div class="row" id="roomsList">
                            <!-- Room Card 1 -->
                            <div class="col-md-4 mb-4 room-item" data-status="available" data-type="single">
                                <div class="card room-card">
                                    <img src="https://via.placeholder.com/400x250/e9ecef/6c757d?text=Phòng+A101" class="card-img-top" alt="Phòng A101">
                                    <div class="card-body">
                                        <div class="d-flex justify-content-between align-items-start mb-2">
                                            <h5 class="card-title mb-0">Phòng A101</h5>
                                            <span class="room-status status-available">Trống</span>
                                        </div>
                                        <p class="card-text room-capacity">
                                            <i class="fas fa-users me-1"></i>
                                            Phòng đơn • 1 người
                                        </p>
                                        <p class="room-price">2.500.000 VNĐ/tháng</p>
                                        <div class="d-flex gap-2">
                                            <button class="btn btn-primary btn-sm flex-fill">
                                                <i class="fas fa-eye me-1"></i>
                                                Xem
                                            </button>
                                            <button class="btn btn-outline-secondary btn-sm">
                                                <i class="fas fa-edit"></i>
                                            </button>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- Room Card 2 -->
                            <div class="col-md-4 mb-4 room-item" data-status="occupied" data-type="double">
                                <div class="card room-card">
                                    <img src="https://via.placeholder.com/400x250/e9ecef/6c757d?text=Phòng+A102" class="card-img-top" alt="Phòng A102">
                                    <div class="card-body">
                                        <div class="d-flex justify-content-between align-items-start mb-2">
                                            <h5 class="card-title mb-0">Phòng A102</h5>
                                            <span class="room-status status-occupied">Đã thuê</span>
                                        </div>
                                        <p class="card-text room-capacity">
                                            <i class="fas fa-users me-1"></i>
                                            Phòng đôi • 2 người
                                        </p>
                                        <p class="room-price">3.200.000 VNĐ/tháng</p>
                                        <div class="d-flex gap-2">
                                            <button class="btn btn-primary btn-sm flex-fill">
                                                <i class="fas fa-eye me-1"></i>
                                                Xem
                                            </button>
                                            <button class="btn btn-outline-secondary btn-sm">
                                                <i class="fas fa-edit"></i>
                                            </button>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- Room Card 3 -->
                            <div class="col-md-4 mb-4 room-item" data-status="available" data-type="quad">
                                <div class="card room-card">
                                    <img src="https://via.placeholder.com/400x250/e9ecef/6c757d?text=Phòng+A103" class="card-img-top" alt="Phòng A103">
                                    <div class="card-body">
                                        <div class="d-flex justify-content-between align-items-start mb-2">
                                            <h5 class="card-title mb-0">Phòng A103</h5>
                                            <span class="room-status status-available">Trống</span>
                                        </div>
                                        <p class="card-text room-capacity">
                                            <i class="fas fa-users me-1"></i>
                                            Phòng 4 người • 4 người
                                        </p>
                                        <p class="room-price">4.800.000 VNĐ/tháng</p>
                                        <div class="d-flex gap-2">
                                            <button class="btn btn-primary btn-sm flex-fill">
                                                <i class="fas fa-eye me-1"></i>
                                                Xem
                                            </button>
                                            <button class="btn btn-outline-secondary btn-sm">
                                                <i class="fas fa-edit"></i>
                                            </button>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- Room Card 4 -->
                            <div class="col-md-4 mb-4 room-item" data-status="maintenance" data-type="single">
                                <div class="card room-card">
                                    <img src="https://via.placeholder.com/400x250/e9ecef/6c757d?text=Phòng+A104" class="card-img-top" alt="Phòng A104">
                                    <div class="card-body">
                                        <div class="d-flex justify-content-between align-items-start mb-2">
                                            <h5 class="card-title mb-0">Phòng A104</h5>
                                            <span class="room-status status-maintenance">Bảo trì</span>
                                        </div>
                                        <p class="card-text room-capacity">
                                            <i class="fas fa-users me-1"></i>
                                            Phòng đơn • 1 người
                                        </p>
                                        <p class="room-price">2.500.000 VNĐ/tháng</p>
                                        <div class="d-flex gap-2">
                                            <button class="btn btn-primary btn-sm flex-fill">
                                                <i class="fas fa-eye me-1"></i>
                                                Xem
                                            </button>
                                            <button class="btn btn-outline-secondary btn-sm">
                                                <i class="fas fa-edit"></i>
                                            </button>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- Room Card 5 -->
                            <div class="col-md-4 mb-4 room-item" data-status="occupied" data-type="single">
                                <div class="card room-card">
                                    <img src="https://via.placeholder.com/400x250/e9ecef/6c757d?text=Phòng+A105" class="card-img-top" alt="Phòng A105">
                                    <div class="card-body">
                                        <div class="d-flex justify-content-between align-items-start mb-2">
                                            <h5 class="card-title mb-0">Phòng A105</h5>
                                            <span class="room-status status-occupied">Đã thuê</span>
                                        </div>
                                        <p class="card-text room-capacity">
                                            <i class="fas fa-users me-1"></i>
                                            Phòng đơn • 1 người
                                        </p>
                                        <p class="room-price">2.500.000 VNĐ/tháng</p>
                                        <div class="d-flex gap-2">
                                            <button class="btn btn-primary btn-sm flex-fill">
                                                <i class="fas fa-eye me-1"></i>
                                                Xem
                                            </button>
                                            <button class="btn btn-outline-secondary btn-sm">
                                                <i class="fas fa-edit"></i>
                                            </button>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- Room Card 6 -->
                            <div class="col-md-4 mb-4 room-item" data-status="available" data-type="double">
                                <div class="card room-card">
                                    <img src="https://via.placeholder.com/400x250/e9ecef/6c757d?text=Phòng+A106" class="card-img-top" alt="Phòng A106">
                                    <div class="card-body">
                                        <div class="d-flex justify-content-between align-items-start mb-2">
                                            <h5 class="card-title mb-0">Phòng A106</h5>
                                            <span class="room-status status-available">Trống</span>
                                        </div>
                                        <p class="card-text room-capacity">
                                            <i class="fas fa-users me-1"></i>
                                            Phòng đôi • 2 người
                                        </p>
                                        <p class="room-price">3.200.000 VNĐ/tháng</p>
                                        <div class="d-flex gap-2">
                                            <button class="btn btn-primary btn-sm flex-fill">
                                                <i class="fas fa-eye me-1"></i>
                                                Xem
                                            </button>
                                            <button class="btn btn-outline-secondary btn-sm">
                                                <i class="fas fa-edit"></i>
                                            </button>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Pagination -->
                        <div class="pagination-custom">
                            <div class="d-flex justify-content-between align-items-center">
                                <div class="text-muted">
                                    Hiển thị <span id="showingFrom">1</span> - <span id="showingTo">6</span> trong tổng số <span id="totalRooms">25</span> phòng
                                </div>
                                <nav aria-label="Page navigation">
                                    <ul class="pagination mb-0">
                                        <li class="page-item">
                                            <a class="page-link" href="#" aria-label="Previous">
                                                <span aria-hidden="true">&laquo;</span>
                                            </a>
                                        </li>
                                        <li class="page-item active"><a class="page-link" href="#">1</a></li>
                                        <li class="page-item"><a class="page-link" href="#">2</a></li>
                                        <li class="page-item"><a class="page-link" href="#">3</a></li>
                                        <li class="page-item"><a class="page-link" href="#">4</a></li>
                                        <li class="page-item"><a class="page-link" href="#">5</a></li>
                                        <li class="page-item">
                                            <a class="page-link" href="#" aria-label="Next">
                                                <span aria-hidden="true">&raquo;</span>
                                            </a>
                                        </li>
                                    </ul>
                                </nav>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Add Room Modal -->
        <div class="modal fade" id="addRoomModal" tabindex="-1" aria-labelledby="addRoomModalLabel" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="addRoomModalLabel">Thêm phòng mới</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <form>
                            <div class="mb-3">
                                <label for="roomName" class="form-label">Tên phòng</label>
                                <input type="text" class="form-control" id="roomName" required>
                            </div>
                            <div class="mb-3">
                                <label for="roomType" class="form-label">Loại phòng</label>
                                <select class="form-select" id="roomType" required>
                                    <option value="">Chọn loại phòng</option>
                                    <option value="single">Phòng đơn</option>
                                    <option value="double">Phòng đôi</option>
                                    <option value="quad">Phòng 4 người</option>
                                </select>
                            </div>
                            <div class="mb-3">
                                <label for="roomPrice" class="form-label">Giá thuê (VNĐ/tháng)</label>
                                <input type="number" class="form-control" id="roomPrice" required>
                            </div>
                            <div class="mb-3">
                                <label for="roomCapacity" class="form-label">Sức chứa</label>
                                <input type="number" class="form-control" id="roomCapacity" required>
                            </div>
                            <div class="mb-3">
                                <label for="roomDescription" class="form-label">Mô tả</label>
                                <textarea class="form-control" id="roomDescription" rows="3"></textarea>
                            </div>
                        </form>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Hủy</button>
                        <button type="button" class="btn btn-primary">Thêm phòng</button>
                    </div>
                </div>
            </div>
        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        <script>
            // Search functionality
            document.getElementById('searchBtn').addEventListener('click', performSearch);
            document.getElementById('searchInput').addEventListener('keyup', function(e) {
                if (e.key === 'Enter') {
                    performSearch();
                }
            });

            function performSearch() {
                const searchTerm = document.getElementById('searchInput').value.toLowerCase();
                const roomItems = document.querySelectorAll('.room-item');
                
                roomItems.forEach(item => {
                    const roomName = item.querySelector('.card-title').textContent.toLowerCase();
                    if (roomName.includes(searchTerm)) {
                        item.style.display = 'block';
                    } else {
                        item.style.display = 'none';
                    }
                });
            }

            // Filter functionality
            document.getElementById('statusFilter').addEventListener('change', function() {
                filterRooms();
            });

            document.getElementById('typeFilter').addEventListener('change', function() {
                filterRooms();
            });

            function filterRooms() {
                const statusFilter = document.getElementById('statusFilter').value;
                const typeFilter = document.getElementById('typeFilter').value;
                const roomItems = document.querySelectorAll('.room-item');
                
                roomItems.forEach(item => {
                    const roomStatus = item.dataset.status;
                    const roomType = item.dataset.type;
                    
                    let showItem = true;
                    
                    if (statusFilter && roomStatus !== statusFilter) {
                        showItem = false;
                    }
                    
                    if (typeFilter && roomType !== typeFilter) {
                        showItem = false;
                    }
                    
                    item.style.display = showItem ? 'block' : 'none';
                });
            }

            // Quick filter buttons
            document.querySelectorAll('.filter-btn').forEach(btn => {
                btn.addEventListener('click', function() {
                    const filter = this.dataset.filter;
                    const roomItems = document.querySelectorAll('.room-item');
                    
                    // Remove active class from all buttons
                    document.querySelectorAll('.filter-btn').forEach(b => b.classList.remove('active'));
                    // Add active class to clicked button
                    this.classList.add('active');
                    
                    roomItems.forEach(item => {
                        if (filter === 'all') {
                            item.style.display = 'block';
                        } else {
                            const roomStatus = item.dataset.status;
                            item.style.display = roomStatus === filter ? 'block' : 'none';
                        }
                    });
                });
            });

            // Add active class to current nav item
            document.addEventListener('DOMContentLoaded', function () {
                const currentPath = window.location.pathname;
                const navLinks = document.querySelectorAll('.nav-link');

                navLinks.forEach(link => {
                    if (link.getAttribute('href') && currentPath.includes(link.getAttribute('href'))) {
                        link.classList.add('active');
                    }
                });
            });

            // Pagination functionality
            document.querySelectorAll('.page-link').forEach(link => {
                link.addEventListener('click', function(e) {
                    e.preventDefault();
                    
                    // Remove active class from all page items
                    document.querySelectorAll('.page-item').forEach(item => item.classList.remove('active'));
                    
                    // Add active class to clicked page item
                    this.parentElement.classList.add('active');
                    
                    // Here you would typically load new data based on the page number
                    console.log('Loading page:', this.textContent);
                });
            });
        </script>
    </body>
</html>