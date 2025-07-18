USE [master]
GO
/****** Object:  Database [HouseSharing]    Script Date: 7/3/2025 9:43:19 PM ******/
CREATE DATABASE [HouseSharing]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'HouseSharing', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.LUONG\MSSQL\DATA\HouseSharing.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'HouseSharing_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.LUONG\MSSQL\DATA\HouseSharing_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT
GO
ALTER DATABASE [HouseSharing] SET COMPATIBILITY_LEVEL = 150
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [HouseSharing].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [HouseSharing] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [HouseSharing] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [HouseSharing] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [HouseSharing] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [HouseSharing] SET ARITHABORT OFF 
GO
ALTER DATABASE [HouseSharing] SET AUTO_CLOSE ON 
GO
ALTER DATABASE [HouseSharing] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [HouseSharing] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [HouseSharing] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [HouseSharing] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [HouseSharing] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [HouseSharing] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [HouseSharing] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [HouseSharing] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [HouseSharing] SET  ENABLE_BROKER 
GO
ALTER DATABASE [HouseSharing] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [HouseSharing] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [HouseSharing] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [HouseSharing] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [HouseSharing] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [HouseSharing] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [HouseSharing] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [HouseSharing] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [HouseSharing] SET  MULTI_USER 
GO
ALTER DATABASE [HouseSharing] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [HouseSharing] SET DB_CHAINING OFF 
GO
ALTER DATABASE [HouseSharing] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [HouseSharing] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [HouseSharing] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [HouseSharing] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
ALTER DATABASE [HouseSharing] SET QUERY_STORE = OFF
GO
USE [HouseSharing]
GO
/****** Object:  Table [dbo].[tbBills]    Script Date: 7/3/2025 9:43:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbBills](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[TenantName] [nvarchar](100) NOT NULL,
	[RoomNumber] [nvarchar](20) NOT NULL,
	[ElectricityCost] [decimal](10, 2) NULL,
	[WaterCost] [decimal](10, 2) NULL,
	[ServiceCost] [decimal](10, 2) NULL,
	[Total] [decimal](10, 2) NOT NULL,
	[DueDate] [nvarchar](20) NOT NULL,
	[Status] [nvarchar](20) NULL,
	[CreatedDate] [nvarchar](20) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[vw_tbBillStatistics]    Script Date: 7/3/2025 9:43:20 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- Tạo view để xem thống kê hóa đơn
CREATE VIEW [dbo].[vw_tbBillStatistics] AS
SELECT 
    COUNT(*) as TotalBills,
    SUM(CASE WHEN Status = 'Paid' THEN Total ELSE 0 END) as TotalRevenue,
    SUM(CASE WHEN Status = 'Unpaid' THEN Total ELSE 0 END) as UnpaidAmount,
    COUNT(CASE WHEN Status = 'Unpaid' THEN 1 END) as UnpaidCount,
    COUNT(CASE WHEN Status = 'Paid' THEN 1 END) as PaidCount,
    COUNT(CASE WHEN Status = 'Pending' THEN 1 END) as PendingCount
FROM tbBills;
GO
/****** Object:  Table [dbo].[bill_details]    Script Date: 7/3/2025 9:43:20 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[bill_details](
	[bill_detail_id] [int] IDENTITY(1,1) NOT NULL,
	[bill_id] [int] NOT NULL,
	[service_id] [int] NOT NULL,
	[old_reading] [int] NULL,
	[new_reading] [int] NULL,
	[quantity] [int] NOT NULL,
	[unit_price] [decimal](18, 2) NOT NULL,
	[amount] [decimal](18, 2) NOT NULL,
 CONSTRAINT [PK_bill_details] PRIMARY KEY CLUSTERED 
(
	[bill_detail_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[bills]    Script Date: 7/3/2025 9:43:20 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[bills](
	[bill_id] [int] IDENTITY(1,1) NOT NULL,
	[contract_id] [int] NOT NULL,
	[billing_date] [date] NOT NULL,
	[due_date] [date] NOT NULL,
	[total_amount] [decimal](18, 2) NOT NULL,
	[status] [tinyint] NOT NULL,
	[note] [nvarchar](500) NULL,
	[created_at] [datetime] NOT NULL,
 CONSTRAINT [PK_bills] PRIMARY KEY CLUSTERED 
(
	[bill_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[contracts]    Script Date: 7/3/2025 9:43:20 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[contracts](
	[contract_id] [int] IDENTITY(1,1) NOT NULL,
	[room_id] [int] NOT NULL,
	[tenant_id] [int] NOT NULL,
	[start_date] [date] NOT NULL,
	[end_date] [date] NULL,
	[rent_price] [decimal](18, 2) NOT NULL,
	[deposit_amount] [decimal](18, 2) NOT NULL,
	[status] [tinyint] NOT NULL,
	[note] [nvarchar](500) NULL,
 CONSTRAINT [PK_contracts] PRIMARY KEY CLUSTERED 
(
	[contract_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[devices]    Script Date: 7/3/2025 9:43:20 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[devices](
	[device_id] [int] IDENTITY(1,1) NOT NULL,
	[device_name] [nvarchar](100) NOT NULL,
	[deviceCode] [varchar](50) NULL,
	[latestWarrantyDate] [varchar](50) NULL,
	[purchaseDate] [varchar](50) NULL,
	[warrantyExpiryDate] [varchar](50) NULL,
 CONSTRAINT [PK_devices] PRIMARY KEY CLUSTERED 
(
	[device_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[devices_in_room]    Script Date: 7/3/2025 9:43:20 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[devices_in_room](
	[room_id] [int] NOT NULL,
	[device_id] [int] NOT NULL,
	[quantity] [int] NOT NULL,
	[status] [nvarchar](100) NULL,
 CONSTRAINT [PK_devices_in_room] PRIMARY KEY CLUSTERED 
(
	[room_id] ASC,
	[device_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Images]    Script Date: 7/3/2025 9:43:20 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Images](
	[roomId] [int] NULL,
	[rentalId] [int] NULL,
	[url_image] [nvarchar](255) NULL,
	[imageId] [int] IDENTITY(1,1) NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[rental_areas]    Script Date: 7/3/2025 9:43:20 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[rental_areas](
	[rental_area_id] [int] IDENTITY(1,1) NOT NULL,
	[manager_id] [int] NOT NULL,
	[name] [nvarchar](100) NOT NULL,
	[address] [nvarchar](255) NOT NULL,
	[qr_for_bill] [varchar](500) NULL,
	[created_at] [datetime] NOT NULL,
 CONSTRAINT [PK_rental_areas] PRIMARY KEY CLUSTERED 
(
	[rental_area_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[RentalHistory]    Script Date: 7/3/2025 9:43:20 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[RentalHistory](
	[RentailHistoryID] [int] IDENTITY(1,1) NOT NULL,
	[RentalID] [int] NULL,
	[RoomID] [int] NOT NULL,
	[TenantID] [int] NOT NULL,
	[TenantName] [nvarchar](100) NOT NULL,
	[StartDate] [nvarchar](255) NOT NULL,
	[EndDate] [nvarchar](255) NULL,
	[RentPrice] [decimal](10, 2) NULL,
	[Notes] [text] NULL,
	[CreatedAt] [nvarchar](255) NULL,
PRIMARY KEY CLUSTERED 
(
	[RentailHistoryID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[roles]    Script Date: 7/3/2025 9:43:20 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[roles](
	[role_id] [int] IDENTITY(1,1) NOT NULL,
	[role_name] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_roles] PRIMARY KEY CLUSTERED 
(
	[role_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[rooms]    Script Date: 7/3/2025 9:43:20 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[rooms](
	[room_id] [int] IDENTITY(1,1) NOT NULL,
	[rental_area_id] [int] NOT NULL,
	[room_number] [nvarchar](20) NOT NULL,
	[area] [decimal](5, 2) NULL,
	[price] [decimal](18, 2) NOT NULL,
	[max_tenants] [int] NOT NULL,
	[status] [tinyint] NOT NULL,
	[description] [nvarchar](500) NULL,
 CONSTRAINT [PK_rooms] PRIMARY KEY CLUSTERED 
(
	[room_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
 CONSTRAINT [UK_rooms_area_number] UNIQUE NONCLUSTERED 
(
	[rental_area_id] ASC,
	[room_number] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[services]    Script Date: 7/3/2025 9:43:20 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[services](
	[service_id] [int] IDENTITY(1,1) NOT NULL,
	[rental_area_id] [int] NOT NULL,
	[service_name] [nvarchar](100) NOT NULL,
	[unit_price] [decimal](18, 2) NOT NULL,
	[unit_name] [nvarchar](20) NOT NULL,
	[calculation_method] [tinyint] NOT NULL,
 CONSTRAINT [PK_services] PRIMARY KEY CLUSTERED 
(
	[service_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tbOTP]    Script Date: 7/3/2025 9:43:20 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbOTP](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[email] [varchar](255) NOT NULL,
	[otp] [varchar](6) NOT NULL,
	[created_at] [datetime] NOT NULL,
	[expires_at] [datetime] NOT NULL,
	[is_used] [bit] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[users]    Script Date: 7/3/2025 9:43:20 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[users](
	[user_id] [int] IDENTITY(1,1) NOT NULL,
	[role_id] [int] NOT NULL,
	[full_name] [nvarchar](100) NOT NULL,
	[phone_number] [varchar](20) NOT NULL,
	[email] [varchar](100) NULL,
	[password_hash] [nvarchar](255) NOT NULL,
	[citizen_id] [varchar](20) NULL,
	[address] [nvarchar](255) NULL,
	[is_active] [bit] NOT NULL,
	[created_at] [datetime] NOT NULL,
	[updated_at] [datetime] NULL,
 CONSTRAINT [PK_users] PRIMARY KEY CLUSTERED 
(
	[user_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[phone_number] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[email] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[citizen_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_tbBills_CreatedDate]    Script Date: 7/3/2025 9:43:20 PM ******/
CREATE NONCLUSTERED INDEX [IX_tbBills_CreatedDate] ON [dbo].[tbBills]
(
	[CreatedDate] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_tbBills_RoomNumber]    Script Date: 7/3/2025 9:43:20 PM ******/
CREATE NONCLUSTERED INDEX [IX_tbBills_RoomNumber] ON [dbo].[tbBills]
(
	[RoomNumber] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_tbBills_Status]    Script Date: 7/3/2025 9:43:20 PM ******/
CREATE NONCLUSTERED INDEX [IX_tbBills_Status] ON [dbo].[tbBills]
(
	[Status] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_tbBills_TenantName]    Script Date: 7/3/2025 9:43:20 PM ******/
CREATE NONCLUSTERED INDEX [IX_tbBills_TenantName] ON [dbo].[tbBills]
(
	[TenantName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
ALTER TABLE [dbo].[bills] ADD  DEFAULT ((0)) FOR [status]
GO
ALTER TABLE [dbo].[bills] ADD  DEFAULT (getdate()) FOR [created_at]
GO
ALTER TABLE [dbo].[contracts] ADD  DEFAULT ((1)) FOR [status]
GO
ALTER TABLE [dbo].[devices_in_room] ADD  DEFAULT ((1)) FOR [quantity]
GO
ALTER TABLE [dbo].[rental_areas] ADD  DEFAULT (getdate()) FOR [created_at]
GO
ALTER TABLE [dbo].[rooms] ADD  DEFAULT ((1)) FOR [max_tenants]
GO
ALTER TABLE [dbo].[rooms] ADD  DEFAULT ((0)) FOR [status]
GO
ALTER TABLE [dbo].[tbBills] ADD  DEFAULT ((0)) FOR [ElectricityCost]
GO
ALTER TABLE [dbo].[tbBills] ADD  DEFAULT ((0)) FOR [WaterCost]
GO
ALTER TABLE [dbo].[tbBills] ADD  DEFAULT ((0)) FOR [ServiceCost]
GO
ALTER TABLE [dbo].[tbBills] ADD  DEFAULT ('Unpaid') FOR [Status]
GO
ALTER TABLE [dbo].[tbOTP] ADD  DEFAULT (getdate()) FOR [created_at]
GO
ALTER TABLE [dbo].[tbOTP] ADD  DEFAULT ((0)) FOR [is_used]
GO
ALTER TABLE [dbo].[users] ADD  DEFAULT ((1)) FOR [is_active]
GO
ALTER TABLE [dbo].[users] ADD  DEFAULT (getdate()) FOR [created_at]
GO
ALTER TABLE [dbo].[bill_details]  WITH CHECK ADD  CONSTRAINT [FK_bill_details_bills] FOREIGN KEY([bill_id])
REFERENCES [dbo].[bills] ([bill_id])
GO
ALTER TABLE [dbo].[bill_details] CHECK CONSTRAINT [FK_bill_details_bills]
GO
ALTER TABLE [dbo].[bill_details]  WITH CHECK ADD  CONSTRAINT [FK_bill_details_services] FOREIGN KEY([service_id])
REFERENCES [dbo].[services] ([service_id])
GO
ALTER TABLE [dbo].[bill_details] CHECK CONSTRAINT [FK_bill_details_services]
GO
ALTER TABLE [dbo].[bills]  WITH CHECK ADD  CONSTRAINT [FK_bills_contracts] FOREIGN KEY([contract_id])
REFERENCES [dbo].[contracts] ([contract_id])
GO
ALTER TABLE [dbo].[bills] CHECK CONSTRAINT [FK_bills_contracts]
GO
ALTER TABLE [dbo].[contracts]  WITH CHECK ADD  CONSTRAINT [FK_contracts_rooms] FOREIGN KEY([room_id])
REFERENCES [dbo].[rooms] ([room_id])
GO
ALTER TABLE [dbo].[contracts] CHECK CONSTRAINT [FK_contracts_rooms]
GO
ALTER TABLE [dbo].[contracts]  WITH CHECK ADD  CONSTRAINT [FK_contracts_users] FOREIGN KEY([tenant_id])
REFERENCES [dbo].[users] ([user_id])
GO
ALTER TABLE [dbo].[contracts] CHECK CONSTRAINT [FK_contracts_users]
GO
ALTER TABLE [dbo].[devices_in_room]  WITH CHECK ADD  CONSTRAINT [FK_devices_in_room_devices] FOREIGN KEY([device_id])
REFERENCES [dbo].[devices] ([device_id])
GO
ALTER TABLE [dbo].[devices_in_room] CHECK CONSTRAINT [FK_devices_in_room_devices]
GO
ALTER TABLE [dbo].[devices_in_room]  WITH CHECK ADD  CONSTRAINT [FK_devices_in_room_rooms] FOREIGN KEY([room_id])
REFERENCES [dbo].[rooms] ([room_id])
GO
ALTER TABLE [dbo].[devices_in_room] CHECK CONSTRAINT [FK_devices_in_room_rooms]
GO
ALTER TABLE [dbo].[Images]  WITH CHECK ADD FOREIGN KEY([rentalId])
REFERENCES [dbo].[rental_areas] ([rental_area_id])
GO
ALTER TABLE [dbo].[Images]  WITH CHECK ADD FOREIGN KEY([roomId])
REFERENCES [dbo].[rooms] ([room_id])
GO
ALTER TABLE [dbo].[rental_areas]  WITH CHECK ADD  CONSTRAINT [FK_rental_areas_users] FOREIGN KEY([manager_id])
REFERENCES [dbo].[users] ([user_id])
GO
ALTER TABLE [dbo].[rental_areas] CHECK CONSTRAINT [FK_rental_areas_users]
GO
ALTER TABLE [dbo].[RentalHistory]  WITH CHECK ADD FOREIGN KEY([RentalID])
REFERENCES [dbo].[rental_areas] ([rental_area_id])
GO
ALTER TABLE [dbo].[RentalHistory]  WITH CHECK ADD FOREIGN KEY([RoomID])
REFERENCES [dbo].[rooms] ([room_id])
GO
ALTER TABLE [dbo].[RentalHistory]  WITH CHECK ADD FOREIGN KEY([TenantID])
REFERENCES [dbo].[users] ([user_id])
GO
ALTER TABLE [dbo].[rooms]  WITH CHECK ADD  CONSTRAINT [FK_rooms_rental_areas] FOREIGN KEY([rental_area_id])
REFERENCES [dbo].[rental_areas] ([rental_area_id])
GO
ALTER TABLE [dbo].[rooms] CHECK CONSTRAINT [FK_rooms_rental_areas]
GO
ALTER TABLE [dbo].[services]  WITH CHECK ADD  CONSTRAINT [FK_services_rental_areas] FOREIGN KEY([rental_area_id])
REFERENCES [dbo].[rental_areas] ([rental_area_id])
GO
ALTER TABLE [dbo].[services] CHECK CONSTRAINT [FK_services_rental_areas]
GO
ALTER TABLE [dbo].[users]  WITH CHECK ADD  CONSTRAINT [FK_users_roles] FOREIGN KEY([role_id])
REFERENCES [dbo].[roles] ([role_id])
GO
ALTER TABLE [dbo].[users] CHECK CONSTRAINT [FK_users_roles]
GO
ALTER TABLE [dbo].[tbOTP]  WITH CHECK ADD  CONSTRAINT [chk_otp] CHECK  ((len([otp])=(6)))
GO
ALTER TABLE [dbo].[tbOTP] CHECK CONSTRAINT [chk_otp]
GO
/****** Object:  StoredProcedure [dbo].[sp_Get_tbBillsByStatus]    Script Date: 7/3/2025 9:43:20 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- Tạo stored procedure để lấy hóa đơn theo trạng thái
CREATE PROCEDURE [dbo].[sp_Get_tbBillsByStatus]
    @Status NVARCHAR(20)
AS
BEGIN
    SELECT * FROM tbBills 
    WHERE Status = @Status 
    ORDER BY CreatedDate DESC;
END;
GO
/****** Object:  StoredProcedure [dbo].[sp_Search_tbBills]    Script Date: 7/3/2025 9:43:20 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- Tạo stored procedure để tìm kiếm hóa đơn
CREATE PROCEDURE [dbo].[sp_Search_tbBills]
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
/****** Object:  StoredProcedure [dbo].[sp_Update_tbBillStatus]    Script Date: 7/3/2025 9:43:20 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- Tạo stored procedure để cập nhật trạng thái hóa đơn
CREATE PROCEDURE [dbo].[sp_Update_tbBillStatus]
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
USE [master]
GO
ALTER DATABASE [HouseSharing] SET  READ_WRITE 
GO
