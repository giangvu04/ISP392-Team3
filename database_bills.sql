-- Script tạo bảng Bills cho hệ thống quản lý nhà trọ
-- Sử dụng cho SQL Server

USE HouseSharing;
GO

-- Tạo bảng Bills
CREATE TABLE Bills (
    ID INT PRIMARY KEY IDENTITY(1,1),
    TenantName NVARCHAR(100) NOT NULL,
    RoomNumber NVARCHAR(20) NOT NULL,
    ElectricityCost DECIMAL(10,2) DEFAULT 0,
    WaterCost DECIMAL(10,2) DEFAULT 0,
    ServiceCost DECIMAL(10,2) DEFAULT 0,
    Total DECIMAL(10,2) NOT NULL,
    DueDate NVARCHAR(20) NOT NULL,
    Status NVARCHAR(20) DEFAULT 'Unpaid',
    CreatedDate NVARCHAR(20) NOT NULL
);
GO

-- Tạo index để tối ưu hiệu suất tìm kiếm
CREATE INDEX IX_Bills_TenantName ON Bills(TenantName);
CREATE INDEX IX_Bills_RoomNumber ON Bills(RoomNumber);
CREATE INDEX IX_Bills_Status ON Bills(Status);
CREATE INDEX IX_Bills_CreatedDate ON Bills(CreatedDate);
GO

-- Thêm dữ liệu mẫu
INSERT INTO Bills (TenantName, RoomNumber, ElectricityCost, WaterCost, ServiceCost, Total, DueDate, Status, CreatedDate) VALUES
('Nguyễn Văn An', 'A101', 150000, 50000, 100000, 300000, '2024-01-15', 'Unpaid', '2024-01-01'),
('Trần Thị Bình', 'A102', 120000, 45000, 100000, 265000, '2024-01-15', 'Paid', '2024-01-01'),
('Lê Văn Cường', 'B201', 180000, 60000, 100000, 340000, '2024-01-15', 'Unpaid', '2024-01-01'),
('Phạm Thị Dung', 'B202', 90000, 40000, 100000, 230000, '2024-01-15', 'Pending', '2024-01-01'),
('Hoàng Văn Em', 'C301', 200000, 70000, 100000, 370000, '2024-01-15', 'Unpaid', '2024-01-01');
GO

-- Tạo view để xem thống kê hóa đơn
CREATE VIEW vw_BillStatistics AS
SELECT 
    COUNT(*) as TotalBills,
    SUM(CASE WHEN Status = 'Paid' THEN Total ELSE 0 END) as TotalRevenue,
    SUM(CASE WHEN Status = 'Unpaid' THEN Total ELSE 0 END) as UnpaidAmount,
    COUNT(CASE WHEN Status = 'Unpaid' THEN 1 END) as UnpaidCount,
    COUNT(CASE WHEN Status = 'Paid' THEN 1 END) as PaidCount,
    COUNT(CASE WHEN Status = 'Pending' THEN 1 END) as PendingCount
FROM Bills;
GO

-- Tạo stored procedure để lấy hóa đơn theo trạng thái
CREATE PROCEDURE sp_GetBillsByStatus
    @Status NVARCHAR(20)
AS
BEGIN
    SELECT * FROM Bills 
    WHERE Status = @Status 
    ORDER BY CreatedDate DESC;
END;
GO

-- Tạo stored procedure để tìm kiếm hóa đơn
CREATE PROCEDURE sp_SearchBills
    @SearchType NVARCHAR(20),
    @SearchValue NVARCHAR(100)
AS
BEGIN
    IF @SearchType = 'tenantName'
        SELECT * FROM Bills WHERE TenantName LIKE '%' + @SearchValue + '%' ORDER BY CreatedDate DESC;
    ELSE IF @SearchType = 'roomNumber'
        SELECT * FROM Bills WHERE RoomNumber LIKE '%' + @SearchValue + '%' ORDER BY CreatedDate DESC;
    ELSE IF @SearchType = 'status'
        SELECT * FROM Bills WHERE Status = @SearchValue ORDER BY CreatedDate DESC;
    ELSE
        SELECT * FROM Bills ORDER BY CreatedDate DESC;
END;
GO

-- Tạo stored procedure để cập nhật trạng thái hóa đơn
CREATE PROCEDURE sp_UpdateBillStatus
    @BillID INT,
    @Status NVARCHAR(20)
AS
BEGIN
    UPDATE Bills 
    SET Status = @Status 
    WHERE ID = @BillID;
    
    SELECT @@ROWCOUNT as RowsAffected;
END;
GO

-- Tạo trigger để tự động tính tổng tiền
CREATE TRIGGER tr_Bills_CalculateTotal
ON Bills
AFTER INSERT, UPDATE
AS
BEGIN
    UPDATE Bills 
    SET Total = ElectricityCost + WaterCost + ServiceCost
    WHERE ID IN (SELECT ID FROM inserted);
END;
GO

-- Kiểm tra dữ liệu đã được tạo
SELECT 'Bảng Bills đã được tạo thành công!' as Message;
SELECT COUNT(*) as TotalBills FROM Bills;
SELECT * FROM vw_BillStatistics;
GO

-- Hướng dẫn sử dụng
PRINT '=== HƯỚNG DẪN SỬ DỤNG ===';
PRINT '1. Xem tất cả hóa đơn: SELECT * FROM Bills ORDER BY CreatedDate DESC;';
PRINT '2. Xem thống kê: SELECT * FROM vw_BillStatistics;';
PRINT '3. Tìm hóa đơn theo trạng thái: EXEC sp_GetBillsByStatus @Status = ''Unpaid'';';
PRINT '4. Tìm kiếm hóa đơn: EXEC sp_SearchBills @SearchType = ''tenantName'', @SearchValue = ''Nguyễn'';';
PRINT '5. Cập nhật trạng thái: EXEC sp_UpdateBillStatus @BillID = 1, @Status = ''Paid'';';
PRINT '=== KẾT THÚC HƯỚNG DẪN ===';
GO 