-- Script tạo bảng tbBills cho hệ thống quản lý nhà trọ
-- Sử dụng cho SQL Server

USE HouseSharing;
GO

-- Tạo bảng tbBills
CREATE TABLE tbBills (
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
CREATE INDEX IX_tbBills_TenantName ON tbBills(TenantName);
CREATE INDEX IX_tbBills_RoomNumber ON tbBills(RoomNumber);
CREATE INDEX IX_tbBills_Status ON tbBills(Status);
CREATE INDEX IX_tbBills_CreatedDate ON tbBills(CreatedDate);
GO

-- Thêm dữ liệu mẫu
INSERT INTO tbBills (TenantName, RoomNumber, ElectricityCost, WaterCost, ServiceCost, Total, DueDate, Status, CreatedDate) VALUES
(N'Nguyễn Văn An', 'A101', 150000, 50000, 100000, 300000, '2024-01-15', 'Unpaid', '2024-01-01'),
(N'Trần Thị Bình', 'A102', 120000, 45000, 100000, 265000, '2024-01-15', 'Paid', '2024-01-01'),
(N'Lê Văn Cường', 'B201', 180000, 60000, 100000, 340000, '2024-01-15', 'Unpaid', '2024-01-01'),
(N'Phạm Thị Dung', 'B202', 90000, 40000, 100000, 230000, '2024-01-15', 'Pending', '2024-01-01'),
(N'Võ Hoàng Em', 'C301', 200000, 70000, 100000, 370000, '2024-01-15', 'Unpaid', '2024-01-01');
GO

-- Tạo view để xem thống kê hóa đơn
CREATE VIEW vw_tbBillStatistics AS
SELECT 
    COUNT(*) as TotalBills,
    SUM(CASE WHEN Status = 'Paid' THEN Total ELSE 0 END) as TotalRevenue,
    SUM(CASE WHEN Status = 'Unpaid' THEN Total ELSE 0 END) as UnpaidAmount,
    COUNT(CASE WHEN Status = 'Unpaid' THEN 1 END) as UnpaidCount,
    COUNT(CASE WHEN Status = 'Paid' THEN 1 END) as PaidCount,
    COUNT(CASE WHEN Status = 'Pending' THEN 1 END) as PendingCount
FROM tbBills;
GO

-- Tạo stored procedure để lấy hóa đơn theo trạng thái
CREATE PROCEDURE sp_Get_tbBillsByStatus
    @Status NVARCHAR(20)
AS
BEGIN
    SELECT * FROM tbBills 
    WHERE Status = @Status 
    ORDER BY CreatedDate DESC;
END;
GO

-- Tạo stored procedure để tìm kiếm hóa đơn
CREATE PROCEDURE sp_Search_tbBills
    @SearchType NVARCHAR(20),
    @SearchValue NVARCHAR(100)
AS
BEGIN
    IF @SearchType = 'tenantName'
        SELECT * FROM tbBills WHERE TenantName LIKE '%' + @SearchValue + '%' ORDER BY CreatedDate DESC;
    ELSE IF @SearchType = 'roomNumber'
        SELECT * FROM tbBills WHERE RoomNumber LIKE '%' + @SearchValue + '%' ORDER BY CreatedDate DESC;
    ELSE IF @SearchType = 'status'
        SELECT * FROM tbBills WHERE Status = @SearchValue ORDER BY CreatedDate DESC;
    ELSE
        SELECT * FROM tbBills ORDER BY CreatedDate DESC;
END;
GO

-- Tạo stored procedure để cập nhật trạng thái hóa đơn
CREATE PROCEDURE sp_Update_tbBillStatus
    @BillID INT,
    @Status NVARCHAR(20)
AS
BEGIN
    UPDATE tbBills 
    SET Status = @Status 
    WHERE ID = @BillID;
    
    SELECT @@ROWCOUNT as RowsAffected;
END;
GO

-- Tạo trigger để tự động tính tổng tiền
CREATE TRIGGER tr_tbBills_CalculateTotal
ON tbBills
AFTER INSERT, UPDATE
AS
BEGIN
    UPDATE tbBills 
    SET Total = ElectricityCost + WaterCost + ServiceCost
    WHERE ID IN (SELECT ID FROM inserted);
END;
GO

-- Kiểm tra dữ liệu đã được tạo
SELECT 'Bảng tbBills đã được tạo thành công!' as Message;
SELECT COUNT(*) as TotalBills FROM tbBills;
SELECT * FROM vw_tbBillStatistics;
GO

-- Hướng dẫn sử dụng
PRINT '=== HƯỚNG DẪN SỬ DỤNG ===';
PRINT '1. Xem tất cả hóa đơn: SELECT * FROM tbBills ORDER BY CreatedDate DESC;';
PRINT '2. Xem thống kê: SELECT * FROM vw_tbBillStatistics;';
PRINT '3. Tìm hóa đơn theo trạng thái: EXEC sp_Get_tbBillsByStatus @Status = ''Unpaid'';';
PRINT '4. Tìm kiếm hóa đơn: EXEC sp_Search_tbBills @SearchType = ''tenantName'', @SearchValue = ''Nguyễn'';';
PRINT '5. Cập nhật trạng thái: EXEC sp_Update_tbBillStatus @BillID = 1, @Status = ''Paid'';';
PRINT '=== KẾT THÚC HƯỚNG DẪN ===';
GO

CREATE TABLE tbOTP (
    id INT PRIMARY KEY IDENTITY(1,1),
    email VARCHAR(255) NOT NULL,
    otp VARCHAR(6) NOT NULL,
    created_at DATETIME NOT NULL DEFAULT GETDATE(),
    expires_at DATETIME NOT NULL,
    is_used BIT NOT NULL DEFAULT 0,
    CONSTRAINT chk_otp CHECK (LEN(otp) = 6)
);