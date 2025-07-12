USE HouseSharing;
GO

CREATE TABLE Images(
imageId INT IDENTITY(1,1),
roomId INT,
rentalId INT,
url_image NVARCHAR(255)
FOREIGN KEY(roomId) REFERENCES dbo.rooms(room_id),
FOREIGN KEY(rentalId) REFERENCES dbo.rental_areas(rental_area_id)
)

CREATE TABLE RentalHistory (
	RentailHistoryID INT IDENTITY(1,1) PRIMARY KEY,
    RentalID INT, -- ID duy nhất cho mỗi bản ghi
    RoomID INT NOT NULL,                    -- ID của phòng
    TenantID INT NOT NULL,                  -- ID của người thuê
    TenantName NVARCHAR(100) NOT NULL,       -- Tên người thuê
    StartDate NVARCHAR(255) NOT NULL,                -- Ngày bắt đầu thuê
    EndDate NVARCHAR(255),                           -- Ngày kết thúc thuê (NULL nếu chưa kết thúc)
    RentPrice DECIMAL(10, 2),               -- Giá thuê (ví dụ: 5000000.00)
    Notes TEXT,                             -- Ghi chú (nếu có)
    CreatedAt NVARCHAR(255), -- Thời gian tạo bản ghi
    FOREIGN KEY (RoomID) REFERENCES Rooms(room_id), -- Khóa ngoại liên kết với bảng Rooms
    FOREIGN KEY (TenantID) REFERENCES dbo.users(user_id), -- Khóa ngoại liên kết với bảng Tenants
	FOREIGN KEY(RentalID) REFERENCES dbo.rental_areas(rental_area_id)
	
);
