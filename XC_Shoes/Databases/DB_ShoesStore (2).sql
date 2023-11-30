CREATE DATABASE DB_1990s_Shoes_Store

USE DB_1990s_Shoes_Store

--CREATE TABLE

CREATE TABLE Users (
	ID INT IDENTITY(1,1),
    UserID AS CAST((LEFT('US' + RIGHT(CAST(ID AS VARCHAR(5)), 3),15)) AS VARCHAR(10)) PERSISTED NOT NULL,
    UserName NVARCHAR(155) UNIQUE,
	Gender NVARCHAR(10),
	Email NVARCHAR(155) UNIQUE,
	Password  NVARCHAR(155),
    PhoneNumber VARCHAR(12) UNIQUE,
	Image VARCHAR(50) DEFAULT 'User.jpg',
	Role INT DEFAULT 0,
	CONSTRAINT PK_Users PRIMARY KEY (UserID),
	CONSTRAINT CK_Gender_Type CHECK (Gender IN (N'Nam', 'Nữ')),
	CONSTRAINT CK_Role CHECK (Role IN (0,1, 2, 3))
);
CREATE TABLE Shop_Branchs (
	ID INT IDENTITY(1,1),
	ShopID AS CAST((LEFT('Shop' + RIGHT(CAST(ID AS VARCHAR(5)), 3),15)) AS VARCHAR(10)) PERSISTED NOT NULL,
    ShopBranchAddress NVARCHAR(155),
	BranchManagement VARCHAR(10),
	CONSTRAINT PK_Shop_Branchs PRIMARY KEY (ShopID),
);
CREATE TABLE Related_staff (
	ID INT IDENTITY(1,1),
	EmployeeID AS CAST((LEFT('Emp' + RIGHT(CAST(ID AS VARCHAR(5)), 3),15)) AS VARCHAR(10)) PERSISTED NOT NULL,
	UserID VARCHAR(10),
	ShopBranchs VARCHAR(10) NOT NULL,
    Address NVARCHAR(255),
    StartDate DATE,
    EmploymentStatus NVARCHAR(50),
	CONSTRAINT PK_Related_staff PRIMARY KEY (EmployeeID),
	CONSTRAINT FK_Related_staff_ShopBranchsID FOREIGN KEY (ShopBranchs) REFERENCES Shop_Branchs(ShopID),
	CONSTRAINT FK_Related_staff_UserID FOREIGN KEY (UserID) REFERENCES Users(UserID),
);
CREATE TABLE Users_ShipmentDetails (
	UserID VARCHAR(10) NOT NULL,
    Name NVARCHAR(55),
    PhoneNumber NVARCHAR(12),
    SpecificAddress NVARCHAR(125),
    AdministrativeBoundaries NVARCHAR(125),
    IsDefault bit,
	CONSTRAINT PK_Users_ShipmentDetails PRIMARY KEY (UserID,Name,PhoneNumber,SpecificAddress,AdministrativeBoundaries),
	CONSTRAINT FK_Users_ShipmentDetails_ID FOREIGN KEY (UserID) REFERENCES Users(UserID),
);
CREATE TABLE Shopping_Cart (
	CartID INT IDENTITY(1,1) NOT NULL,
	UserID VARCHAR(10) UNIQUE,
    Subtotal DECIMAL(18, 2) DEFAULT 0,
	CONSTRAINT PK_Cart PRIMARY KEY (CartID),
	CONSTRAINT FK_Cart_UserID FOREIGN KEY (UserID) REFERENCES Users(UserID),
);
CREATE TABLE Favorites (
	FavoriteID INT IDENTITY(1,1) NOT NULL,
	UserID VARCHAR(10) UNIQUE,
	CONSTRAINT PK_Favorites PRIMARY KEY (FavoriteID),
	CONSTRAINT FK_Favorites_UserID FOREIGN KEY (UserID) REFERENCES Users(UserID),
);
CREATE TABLE Colours (
    ColourID INT IDENTITY(1,1) NOT NULL,
    Name NVARCHAR(255) NOT NULL,
	CONSTRAINT PK_Colours PRIMARY KEY (ColourID),
);
CREATE TABLE Icons (
    IconID VARCHAR(4),
    Name NVARCHAR(155) UNIQUE,
	Quantity INT DEFAULT 0,
	CONSTRAINT PK_Icons PRIMARY KEY (IconID),
);
CREATE TABLE Shoes (
	ID INT DEFAULT 1,
	IconID VARCHAR(4),
    ShoesID VARCHAR(10) NOT NULL,
    StyleType NVARCHAR(20),
	Price DECIMAL(10, 2),
    Discount DECIMAL(5, 2) DEFAULT 0,
	CONSTRAINT PK_Shoes PRIMARY KEY (ShoesID),
	CONSTRAINT FK_Shoes_Details_IconID FOREIGN KEY (IconID) REFERENCES Icons(IconID),
);

CREATE TABLE Sale(
	SaleID INT IDENTITY(1,1) NOT NULL,
	ShoesID VARCHAR(10),
    StartDate DATE,
    EndDate DATE,
    Quantity DECIMAL(5, 2),
	EmployeeID VARCHAR(10),
	CONSTRAINT PK_Sale PRIMARY KEY (SaleID),
    CONSTRAINT FK_Sale_ShoesID FOREIGN KEY (ShoesID) REFERENCES Shoes(ShoesID),
	CONSTRAINT FK_Sale_EmployeeID FOREIGN KEY (EmployeeID) REFERENCES Related_staff(EmployeeID)
);
CREATE TABLE Type_Shoes (
    TypeShoesID INT IDENTITY(1,1) NOT NULL,
    Name NVARCHAR(255) UNIQUE,
	CONSTRAINT PK_Type_Shoes PRIMARY KEY (TypeShoesID),
);
CREATE TABLE Shoes_Details (
	ShoesDetailsID INT IDENTITY(1,1) NOT NULL,
    ShoesID VARCHAR(10) UNIQUE,
    Name NVARCHAR(255),
	TypeShoesID INT,
	CONSTRAINT PK_Shoes_Details PRIMARY KEY (ShoesDetailsID),
    CONSTRAINT FK_Shoes_Details_ID FOREIGN KEY (ShoesID) REFERENCES Shoes(ShoesID),
	CONSTRAINT FK_Shoes_Details_TypeShoesID FOREIGN KEY (TypeShoesID) REFERENCES Type_Shoes(TypeShoesID),

);
CREATE TABLE Comments (
    CommentID INT IDENTITY(1,1) NOT NULL,
    Content NVARCHAR(555),
    StarRating INT,
	ShoesDetailsID int,
	UserID VARCHAR(10),
	CONSTRAINT PK_Comments PRIMARY KEY (CommentID),
    CONSTRAINT FK_Comments_ShoesDetailsID FOREIGN KEY (ShoesDetailsID) REFERENCES Shoes_Details(ShoesDetailsID),
	CONSTRAINT FK_Comments_UserID FOREIGN KEY (UserID) REFERENCES Users(UserID),
	CONSTRAINT CK_Comments_StarRating CHECK(StarRating > 0)
);
CREATE TABLE Orders (
    OrderID INT IDENTITY(1,1) NOT NULL,
	UserID VARCHAR(10) NOT NULL,
    PaymentInfo NVARCHAR(255) DEFAULT N'Thanh Toán Bằng Tiền Mặt',
    EstimatedDeliveryHandlingFee DECIMAL(10, 2),
	Email NVARCHAR(100) NOT NULL,
    Total DECIMAL(10, 2),
    PaymentStatus NVARCHAR(50) DEFAULT N'False',
    RecipientAddress NVARCHAR(255),
    RecipientName NVARCHAR(100),
    RecipientPhoneNumber VARCHAR(20),
	CONSTRAINT PK_Orders PRIMARY KEY (OrderID),
    CONSTRAINT FK_Orders_UserID FOREIGN KEY (UserID) REFERENCES Users(UserID),

);
CREATE TABLE Order_Detail(
	OrderID INT NOT NULL,
	ShoesID VARCHAR(10),
	Quantity INT,
	Ordertime DATETIME,
	CONSTRAINT PK_Orders PRIMARY KEY (OrderID,ShoesID),
	CONSTRAINT FK_Order_Detai_OrderID FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
	CONSTRAINT FK_Order_Detai_ShoesID FOREIGN KEY (ShoesID) REFERENCES Shoes(ShoesID),
);
CREATE TABLE OrderSystem (
    OrderSystemID INT IDENTITY(1,1) NOT NULL,
	OrderID INT NOT NULL,
	EmployeeID VARCHAR(10) DEFAULT '',
    OrderDate DATE DEFAULT GETDATE(),
    Status NVARCHAR(50) DEFAULT N'Chưa Xác Nhận',
	CONSTRAINT PK_OrderSystem PRIMARY KEY (OrderSystemID),
    CONSTRAINT FK_OrderSystem_OrderID FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
	CONSTRAINT FK_OrderSystem_EmployeeID FOREIGN KEY (EmployeeID) REFERENCES Related_staff(EmployeeID),
);
CREATE TABLE List_Products_At_Shop (
	ShopID VARCHAR(10) NOT NULL,
	ShoesID VARCHAR(10) NOT NULL,
	Size VARCHAR(10),
	Quantity INT DEFAULT 0,
	CONSTRAINT PK_List_Products_At_Shop PRIMARY KEY (ShopID,ShoesID),
	CONSTRAINT FK_List_Products_At_Shop_ShopID FOREIGN KEY (ShopID) REFERENCES Shop_Branchs(ShopID),
	CONSTRAINT FK_List_Products_At_Shop_ShoesID FOREIGN KEY (ShoesID) REFERENCES Shoes(ShoesID),
);
CREATE TABLE Cart_Detail (
	CartID INT NOT NULL,
	ShoesID VARCHAR(10) NOT NULL,
	StyleType NVARCHAR(20),
	ColourID INT,
	Size INT,
	Price DECIMAL(10, 2),
	Quantity INT,
    BuyingSelection_Status BIT DEFAULT 0,
	CONSTRAINT PK_Cart_Detail PRIMARY KEY (CartID,ShoesID,ColourID,StyleType,Size),
	CONSTRAINT FK_Cart_Detail_CartID FOREIGN KEY (CartID) REFERENCES Shopping_Cart(CartID),
	CONSTRAINT FK_Cart_Detail_ShoesID FOREIGN KEY (ShoesID) REFERENCES Shoes(ShoesID),
);
CREATE TABLE Colour_Detail(
	ColourID INT NOT NULL,
	ShoesID VARCHAR(10) NOT NULL,
	CONSTRAINT PK_Colour_Detail PRIMARY KEY (ShoesID,ColourID),
	CONSTRAINT FK_Colour_Detail_ColourID FOREIGN KEY (ColourID) REFERENCES Colours(ColourID),
	CONSTRAINT FK_Colour_Detail_ShoesID FOREIGN KEY (ShoesID) REFERENCES Shoes(ShoesID),
);
CREATE TABLE Images(
	ImageID INT IDENTITY(1,1) NOT NULL,
	ShoesID VARCHAR(10),
	ColourID INT,
	Name NVARCHAR(100),
	Url NVARCHAR(100),
	CONSTRAINT PK_Images PRIMARY KEY (ImageID,ShoesID),
	CONSTRAINT FK_Images_ShoesID FOREIGN KEY (ShoesID) REFERENCES Shoes(ShoesID),
	CONSTRAINT FK_Images_ColourID FOREIGN KEY (ColourID) REFERENCES Colours(ColourID),
);
CREATE TABLE Favorite_Detaill (
	FavoriteID INT NOT NULL,
	ShoesID VARCHAR(10) NOT NULL,
	ColourID INT NOT NULL,
	StyleType NVARCHAR(20),
	CONSTRAINT PK_Favorite_Detail PRIMARY KEY (FavoriteID,ShoesID,ColourID,StyleType),
	CONSTRAINT FK_Favorite_Detail_FavoriteID FOREIGN KEY (FavoriteID) REFERENCES Favorites(FavoriteID),
	CONSTRAINT FK_Favorite_Detail_ShoesID FOREIGN KEY (ShoesID) REFERENCES Shoes(ShoesID),
);
GO
CREATE TABLE size(
	sizeID INT NOT NULL,
	CONSTRAINT PK_size PRIMARY KEY (sizeID),
);
CREATE TABLE size_Detail(
	sizeID INT NOT NULL,
	ColourID INT NOT NULL,
	shoesID VARCHAR(10) NOT NULL,
	CONSTRAINT PK_size_Detail PRIMARY KEY (sizeID,ColourID,shoesID),
	CONSTRAINT FK_size_Detail_sizeID  FOREIGN KEY (sizeID) REFERENCES size(sizeID),
	CONSTRAINT FK_size_Detail_ColourID FOREIGN KEY (ColourID) REFERENCES Colours(ColourID),
	CONSTRAINT FK_size_Detail_ShoesID FOREIGN KEY (ShoesID) REFERENCES Shoes(ShoesID),
);
GO
DROP TABLE size_Detail
-- Trigger 
CREATE TRIGGER UPDATE_Quantity_ShoesIcon
ON Shoes
AFTER INSERT
AS
BEGIN
	UPDATE Icons
	Set Quantity += 1
	WHERE Icons.IconID = (SELECT IconID FROM INSERTED)
END
GO

--
CREATE TRIGGER TRIGGER_Create_ShoesID
ON Shoes
INSTEAD OF INSERT
AS
BEGIN
    SET NOCOUNT ON;

    -- Lưu các dòng được chèn vào một bảng tạm
    DECLARE @InsertedData TABLE (
        ID INT,
        IconID VARCHAR(4),
		ShoesID AS CAST((LEFT(IconID + RIGHT(CAST(ID AS VARCHAR(5)), 3),15)) AS VARCHAR(10)) PERSISTED,
        StyleType NVARCHAR(20),
		Price DECIMAL(10, 2),
        Discount DECIMAL(5, 2) DEFAULT 0
    );

    -- Chèn dữ liệu từ bảng inserted vào bảng tạm
    INSERT INTO @InsertedData (IconID, StyleType,Price)
    SELECT IconID, StyleType,Price
    FROM inserted;

    -- Cập nhật ID dựa trên giá trị Quantity từ bảng Icons
    UPDATE @InsertedData
    SET ID = Quantity+1
    FROM @InsertedData i
    INNER JOIN Icons ON i.IconID = Icons.IconID;

    -- Chèn dữ liệu từ bảng tạm vào bảng Shoes
    INSERT INTO Shoes (ID, IconID,ShoesID, StyleType,Price, Discount)
    SELECT ID, IconID,ShoesID, StyleType,Price, Discount
    FROM @InsertedData;
END;

GO
-- Store proceduce
CREATE PROCEDURE InsertUser 
@UserName NVARCHAR(155), @Gender NVARCHAR(10), @Email NVARCHAR(155), @Password  NVARCHAR(155), @PhoneNumber VARCHAR(12), @Role INT
AS
BEGIN
	INSERT INTO Users(UserName, Gender, Email, Password, PhoneNumber, Role)
	VALUES(@UserName, @Gender, @Email, @Password, @PhoneNumber, @Role);
	DECLARE @User_ID VARCHAR(10);
	SET @User_ID = (SELECT UserID FROM Users WHERE Email = @Email)
	INSERT INTO Shopping_Cart (UserID)
	VALUES (@User_ID);
	INSERT INTO Favorites(UserID)
	VALUES (@User_ID);
	END
GO
exec dbo.InsertUser N'Trương Quốc Huy', N'Nam', N'huyngao@gmail.com', N'612233', '03157839578', 0
-- Update User
CREATE PROCEDURE UpdateUser
	@UserID VARCHAR(10),
	@UserName NVARCHAR(155)  = NULL,
	@Gender NVARCHAR(10) = NULL,
	@Email NVARCHAR(155) = NULL,
	@Password  NVARCHAR(155) = NULL,
	@PhoneNumber VARCHAR(12) = NULL,
	@Role INT = NULL
AS
BEGIN
    UPDATE Users
    SET 
        UserName = ISNULL(@UserName,UserName),
        Gender = ISNULL(@Gender, Gender),
		Email = ISNULL(@Email, Email),
        Password = ISNULL(@Password, Password),
		PhoneNumber = ISNULL(@PhoneNumber, PhoneNumber),
        Role = ISNULL(@Role, Role)
    WHERE UserID = @UserID;
END
GO
--Delete User
CREATE PROCEDURE deleteUser
    @UserID VARCHAR(10)
AS
BEGIN
    DELETE FROM Users_ShipmentDetails
    WHERE UserID = @UserID;

	DELETE FROM Shopping_Cart
    WHERE UserID = @UserID;

	DELETE FROM Favorites
    WHERE UserID = @UserID;
	
	DELETE FROM Comments
    WHERE UserID = @UserID;
    -- Xóa user từ bảng Users
    DELETE FROM Users
    WHERE UserID = @UserID;
END
GO
--
CREATE PROCEDURE AddNewShoes
    @IconID VARCHAR(4),
    @TypeShoesID INT,
    @Name NVARCHAR(255),
    @Price DECIMAL(10, 2),
    @StyleType NVARCHAR(20),
    @Image NVARCHAR(100)
AS
BEGIN
    DECLARE @ShoesID VARCHAR(10);

    -- Thêm mới vào bảng Shoes và lấy ShoesID vừa thêm
    INSERT INTO Shoes (IconID, Price, StyleType)
    VALUES (@IconID, @Price, @StyleType);

	SET  @ShoesID = (SELECT TOP(1) ShoesID FROM Shoes WHERE IconID = @IconID ORDER BY ID DESC) 

    -- Thêm mới vào bảng Shoes_Details
    INSERT INTO Shoes_Details (Name, ShoesID, TypeShoesID)
    VALUES (@Name, @ShoesID, @TypeShoesID);

	INSERT INTO Images(ShoesID,Name, Url)
	VALUES(@ShoesID,@Name,@Image)
END
GO
--EXEC dbo.AddNewShoes 'SP',5,N'Nike Spoting 28',6200000,N'Nam','Sport.jpg'
-- Insert dữ liệu vào bảng Shop_Branchs
INSERT INTO size
VALUES(36),(37),(38),(39),(40),(41),(42);
INSERT INTO size_Detail
VALUES(38,2,'AF1'),(37,2,'AF1'),(39,2,'AF1'),(42,2,'AF2')
INSERT INTO Shop_Branchs (ShopBranchAddress, BranchManagement)
VALUES ('Aeon Mall Tân Phú', 'Emp1')
-- Insert dữ liệu vào bảng Users
INSERT INTO Users (UserName, Gender, Email, Password, PhoneNumber, Role)
VALUES (N'Nguyễn Huy Hoàng', N'Nam', N'hoang2011@gmail.com', N'123456', '09123461711', 1),
	(N'Nguyễn Minh Thư', N'Nam', N'minhthu21@gmail.com', N'141222', '03989212641', 0),
	 (N'Vương Kim Dinh', N'Nam', N'dinh0212@gmail.com', N'111111', '03412578891', 0);
 --   (N'Trương Quốc Huy', N'Nam', N'huyngao@gmail.com', N'612233', '03157839578', 0),
	--(N'Trương Ngọc Sơn', N'Nam', N'Sontruong22@gmail.com', N'111233', '03415781234', 0),
	--(N'Trương Quốc Hoàng', N'Nam', N'Hoangtruong20@gmail.com', N'251233', '09236512481', 0),
	--(N'Nguyễn Ngọc Lan', N'Nữ', N'ngoclan13@gmail.com', N'771233', '09856325124', 1),
	--(N'Trương Kim Thư', N'Nam', N'Thutruong95@gmail.com', N'681243', '03245136242', 0),
	--(N'Nguyễn Mộng Mơ', N'Nữ', N'Monguyen75@gmail.com', N'111442', '07658954236', 0),
	--(N'Trương Huy Sơn', N'Nam', N'HuySon00@gmail.com', N'100233', '0785469236', 1);
-- Insert dữ liệu vào bảng Related_staff
INSERT INTO Related_staff (UserID, ShopBranchs, Address, StartDate, EmploymentStatus)
VALUES ('US1', 'Shop1', N'140 Lê Trọng Tấn', '2022-04-01', N'Active'),
    ('US2', 'Shop1', N'153 Nguyễn Chí Thanh', '2021-05-21', N'Inactive'),
	('US3', 'Shop1', N'15 Nguyễn Chí Thanh','2019-05-20', N'Inactive');
 --   ('US1', 'Shop1', N'44 Lê Trọng Tấn','2022-02-18', N'Active'),
	--('US4', 'Shop2', N'256 Bùi Tư Toàn','2021-03-20', N'Active'),
	--('US2', 'Shop2', N'123 Quốc Lộ 1A','2020-10-30', N'Active'),	
	--('US5', 'Shop2', N'23 Nguyễn Hữu Thọ','2021-05-31', N'Active'),
	--('US6', 'Shop1', N'120 Tân Kỳ Tân Quý','2021-07-30', N'Inactive');
-- Insert dữ liệu vào bảng Users_ShipmentDetails
Insert into Users_ShipmentDetails(UserID,Name,PhoneNumber,SpecificAddress,AdministrativeBoundaries,IsDefault)
VALUES('US1',N'Nguyễn Văn Hoàng',N'0124516363',N'Thành phố Hồ Chí Minh',N'140 Lê Trọng Tấn',1),
	  ('US2',N'Nguyễn Văn Thống',N'0956324851',N'Thành phố Hồ Chí Minh',N'13 Nam Kì Khởi Nghĩa',1),
	  --('US004',N'Trần Minh Huy',N'032562958',N'Thành phố Hồ Chí Minh',N'215 Gò Dầu',1),
	  --('US005',N'Phan Ngọc Trinh',N'098547216',N'Thành phố Hồ Chí Minh',N'14 Tú Xương',0),
	  --('US006',N'Nguyễn Ngọc Minh',N'075632140',N'Thành phố Hồ Chí Minh',N'512 3 tháng 2',1);
-- Insert dữ liệu vào bảng Shopping_Cart
--INSERT INTO Shopping_Cart (UserID)
--VALUES 
 --   ('US3'),
 --   ('US4'),
	--('US1'),
	--('US2'),
	--('US5'),
	--('US6'),
	--('US7');
-- Insert dữ liệu vào bảng Favorites
--INSERT INTO Favorites (UserID)
--VALUES 
 --   ('US3'),
 --   ('US4'),
	--('US1'),
	--('US2'),
	--('US5'),
	--('US6'),
	--('US7');
-- Insert dữ liệu vào bảng Colours
INSERT INTO Colours (Name)
VALUES 
    ('Red'),
    ('White'),
	('Black'),
	('Beige'),
	('Gray'),
	('Pink'),
	('White Blue'),
    ('Green'),
	('Brown'),
	('Purple'),
	('Blue'),
	('Olive Green');
-- Insert dữ liệu vào bảng Icons
INSERT INTO Icons (IconID, Name)
VALUES 
    ('AF', 'Air Force 1'),
    ('JD', 'Jordan'),
	('AM', 'Air Max'),
	('DK', 'Dunk'),
	('CT', 'CorTez'),
	('BZ', 'Blazer'),
	('PG', 'Pegasus'),
	('SP', 'Sport');
-- Insert dữ liệu vào bảng Shoes
INSERT INTO Shoes (IconID,Price, StyleType)
VALUES 
    ('AF',2500000 ,'Men');
INSERT INTO Shoes (IconID,Price, StyleType)
VALUES 
	('AF',2700000, 'Men')
INSERT INTO Shoes (IconID,Price, StyleType)
VALUES 
	('AF',3700000, 'Men');
INSERT INTO Shoes (IconID,Price, StyleType)
VALUES
	('AF',4700000, 'Men');
INSERT INTO Shoes (IconID,Price, StyleType)
VALUES
	('AF',2800000, 'Men');
INSERT INTO Shoes (IconID,Price, StyleType)
VALUES
	('AF',3300000, 'Men');
INSERT INTO Shoes (IconID,Price, StyleType)
VALUES
	('AF',2890000, 'Women');
INSERT INTO Shoes (IconID,Price, StyleType)
VALUES
	('AF',3700000, 'Women');
INSERT INTO Shoes (IconID,Price, StyleType)
VALUES
	('AF',3600000, 'Women');
INSERT INTO Shoes(IconID,Price, StyleType)
VALUES 
	('AM',4700000, 'Men');
INSERT INTO Shoes (IconID,Price, StyleType)
VALUES 
	('AM',3700000, 'Men');
INSERT INTO Shoes (IconID, Price, StyleType)
VALUES
	('AM',2600000, 'Men')
INSERT INTO Shoes (IconID,Price, StyleType)
VALUES
	('AM',3700000, 'Men')
INSERT INTO Shoes (IconID,Price, StyleType)
VALUES
	('AM',2700000, 'Men')
INSERT INTO Shoes (IconID,Price, StyleType)
VALUES
	('AM',3100000, 'Men')
INSERT INTO Shoes (IconID,Price, StyleType)
VALUES
	('AM',4700000, 'Women')
INSERT INTO Shoes (IconID,Price, StyleType)
VALUES
	('AM',2500000, 'Women')
INSERT INTO Shoes (IconID,Price, StyleType)
VALUES
	('AM',2600000, 'Women');
INSERT INTO Shoes (IconID,Price, StyleType)
VALUES
	('JD',2300000, 'Men')
INSERT INTO Shoes (IconID,Price, StyleType)
VALUES
	('JD',3050000, 'Men')
INSERT INTO Shoes (IconID,Price, StyleType)
VALUES
	('JD',2900000, 'Men')
INSERT INTO Shoes (IconID,Price, StyleType)
VALUES
	('JD',2500000, 'Men')
INSERT INTO Shoes (IconID,Price, StyleType)
VALUES
	('JD',3200000, 'Men')
INSERT INTO Shoes (IconID,Price, StyleType)
VALUES
	('JD',2200000, 'Women')
INSERT INTO Shoes (IconID,Price, StyleType)
VALUES
	('JD',3900000, 'Women')
INSERT INTO Shoes (IconID,Price, StyleType)
VALUES
	('JD',3700000, 'Women')
INSERT INTO Shoes (IconID,Price, StyleType)
VALUES
	('SP',2700000, 'Men')
INSERT INTO Shoes (IconID,Price, StyleType)
VALUES
	('SP',3400000, 'Men')
INSERT INTO Shoes (IconID,Price, StyleType)
VALUES
	('SP',2700000, 'Men');
INSERT INTO Shoes (IconID,Price, StyleType)
VALUES
	('SP',1900000, 'Men')
INSERT INTO Shoes (IconID,Price, StyleType)
VALUES
	('SP',3800000, 'Men')
INSERT INTO Shoes (IconID,Price, StyleType)
VALUES
	('SP',3750000, 'Men')
INSERT INTO Shoes (IconID,Price, StyleType)
VALUES
	('SP',4700000, 'Women')
INSERT INTO Shoes (IconID,Price, StyleType)
VALUES
	('SP',5200000, 'Women')
INSERT INTO Shoes (IconID,Price, StyleType)
VALUES
	('SP',5700000, 'Women');
-- Insert dữ liệu vào bảng Images
INSERT INTO Images (ShoesID,Name, Url)
VALUES 
    ('AF1', 'Nike Air Force 1  Low ', 'AF1-MenShoes-2-Nike Air Force 07'),
	('AF1', 'Nike Air Force 1  Low ', 'AF1-MenShoes-3-Nike Air Force 07'),
	('AF1', 'Nike Air Force 1  Low ', 'AF1-MenShoes-4-Nike Air Force 07'),
	('AF2', 'Nike Air Force 1  Mid ', 'AF2-MenShoes-1-Nike Air Force 1  Mid'),
	('AF2', 'Nike Air Force 1  Mid ', 'AF2-MenShoes-2-Nike Air Force 1  Mid'),
	('AF2', 'Nike Air Force 1  Mid ', 'AF2-MenShoes-5-Nike Air Force 1  Mid'),
	('AF3', 'Nike Air Force 1  Low ', 'AF3-WomenShoes-4-Nike Air Force 1  Low'),
	('AF3', 'Nike Air Force 1  Low ', 'AF3-WomenShoes-6-Nike Air Force 1  Low'),
	('AF3', 'Nike Air Force 1  Low ', 'AF3-WomenShoes-7-Nike Air Force 1  Low'),
	('AM1', 'Nike Air Max 97 ', 'AM1-MenShoes-2-Nike Air Max 97'),
	('AM1', 'Nike Air Max 97 ', 'AM1-MenShoes-5-Nike Air Max 97'),
	('AM1', 'Nike Air Max 97 ', 'AM1-MenShoes-7-Nike Air Max 97'),
	('AM2', 'Nike Air Max 90 ', 'AM2-MenShoes-1-Nike Air Max 90'),
	('AM2', 'Nike Air Max 90 ', 'AM2-MenShoes-2-Nike Air Max 90'),
	('AM2', 'Nike Air Max 90 ', 'AM2-MenShoes-3-Nike Air Max 90'),
	('AM3','-Nike Air Max 90 Futura ', 'AM3-WomenShoes-5-Nike Air Max 90 Futura'),
	('AM3', 'Nike Air Max 90 Futura ', 'AM3-WomenShoes-6-Nike Air Max 90 Futura'),
	('AM3', 'Nike Air Max 90 Futura ', 'AM3-WomenShoes-12-Nike Air Max 90 Futura'),
	('JD1', 'Air Jordan 1 Low ', 'JD1-MenShoes-2-Air Jordan 1 Low'),
	('JD1', 'Air Jordan 1 Low ', 'JD1-MenShoes-3-Air Jordan 1 Low'),
	('JD2', 'Air Jordan 1 Mid ', 'JD2-MenShoes-2-Air Jordan 1 Mid'),
	('JD2', 'Air Jordan 1 Mid ', 'JD2-MenShoes-6-Air Jordan 1 Mid'),
	('JD2', 'Air Jordan 1 Mid ', 'JD2-MenShoes-7-Air Jordan 1 Mid'),
	('JD3', 'Air Jordan 1 Mid ', 'JD3-WomenShoes-4-Air Jordan 1 Mid'),
	('JD3', 'Air Jordan 1 Mid ', 'JD3-WomenShoes-6-Air Jordan 1 Mid'),
	('JD3','Air Jordan 1 Mid ', 'JD3-WomenShoes-10-Air Jordan 1 Mid'),
	('SP1','Nike Pegasus 40 ', 'SP1-MenShoes-1-Nike Pegasus 40'),
	('SP1','Nike Pegasus 40 ', 'SP1-MenShoes-2-Nike Pegasus 40'),
	('SP1','Nike Pegasus 40 ', 'SP1-MenShoes-3-Nike Pegasus 40'),
	('SP2','Nike Structure 25 ', 'SP2-MenShoes-2-Nike Structure 25'),
	('SP2','Nike Structure 25 ', 'SP2-MenShoes-4-Nike Structure 25'),
	('SP2','Nike Structure 25 ', 'SP2-MenShoes-8-Nike Structure 25'),
	('SP3','Nike Infinity 4 ', 'SP3-WomenShoes-2-Nike Infinity 4'),
	('SP3', 'Nike Infinity 4 ', 'SP3-WomenShoes-3-Nike Infinity 4'),
	('SP3','Nike Infinity 4 ', 'SP3-WomenShoes-6-Nike Infinity 4');
-- Insert dữ liệu vào bảng Sale
INSERT INTO Sale (ShoesID, StartDate, EndDate, Quantity, EmployeeID)
VALUES 
    ('AF1', '2023-01-01', '2023-01-10', 10.5, 'Emp1'),
	('AF2', '2023-02-02', '2023-02-12', 9.0, 'Emp2')
	--('AF3', '2022-05-20', '2022-05-25', 20.5, 'Emp3'),
	--('AM1', '2022-06-21', '2022-06-26', 12.5, 'Emp4'),
	--('AM2', '2022-10-09', '2022-10-14', 10.5, 'Emp5'),
	--('AM3', '2022-01-22', '2022-01-27', 11.5, 'Emp1'),
	--('JD1', '2022-02-12', '2022-02-22', 15.5, 'Emp2'),
	--('JD2', '2021-07-13', '2021-07-18', 8.5, 'Emp4'),
	--('JD3', '2020-05-13', '2020-05-18', 7.5, 'Emp5'),
	--('SP1', '2021-11-12', '2021-11-17', 19.5, 'Emp1'),
	--('SP2', '2023-10-05', '2023-10-10', 14.5, 'Emp2'),
	--('SP3', '2021-10-20', '2021-10-25', 11.5, 'Emp3');
-- Insert dữ liệu vào bảng Type_Shoes
INSERT INTO Type_Shoes (Name)
VALUES 
	('Customise'),
    ('Running Shoes'),
	('Basketball Shoes'),
	('Football Shoes'),
	('Golf Shoes'),
    ('Casual Shoes');
-- Insert dữ liệu vào bảng Shoes_Details
INSERT INTO Shoes_Details (Name, ShoesID, TypeShoesID)
VALUES 
    ('-Nike Air Force 1  Low ', 'AF1', 1),
	('-Nike Air Force 1  Mid ', 'AF2', 1),
	('-Nike Air Force 1  Low ', 'AF3', 1),
	('-Nike Air Max 97 ',  'AM1', 6),
	('-Nike Air Max 90 ', 'AM2', 6),
	('-Nike Air Max 90 Futura ',  'AM3', 6),
	('-Air Jordan 1 Low ', 'JD1', 3),
	('-Air Jordan 1 Mid ',  'JD2', 3),
	('-Air Jordan 1 Mid ', 'JD3', 3),
	('-Nike Pegasus 40 ', 'SP1', 5),
	('-Nike Structure 25 ',  'SP2', 2),
	('-Nike Infinity 4 ', 'SP3', 4);
-- Insert dữ liệu vào bảng Comments
INSERT INTO Comments (Content, StarRating, ShoesDetailsID, UserID)
VALUES 
	('The shoe color is very beautiful!', 5, 5, 'US1'),
	('The shoes are very nice!', 5, 4, 'US2')
 --   ('Great shoes!', 5, 1, 'US4'),
 --   ('Comfortable and stylish.', 4, 2, 'US5'),
 --   ('Not bad, but a bit tight.', 4, 3, 'US3'),
	--('Stability Shoe.', 4, 2, 'US7'),
	--('Good quality and beautiful shoes!', 5, 1, 'US6'),
	--('Shoes are very satisfactory!', 5, 6, 'US5');
-- Insert dữ liệu vào bảng Orders
--INSERT INTO Orders (UserID, CartID, EstimatedDeliveryHandlingFee, Email, Total, RecipientAddress, RecipientName, RecipientPhoneNumber)
--VALUES 
--    ('US3', 1, 30000, N'dinh0212@gmail.com', 2730000, N'40a BuSan Korea', N'Vương Kim Dinh', '03412578891'),
--    ('US4', 2, 20000,  N'huyngao@gmail.com', 2520000, N'140 Lê Trong Tấn TP Hồ Chí Minh', N'Huy Trương',  '03157839578');
--	('US1', 3, 25000,  N'thu13@gmail.com', 89.99, N'140 Lê Trong Tấn TP Hồ Chí Minh', N'Huy Trương',  '03157839578'),
--	('US2', 4, 32000,  N'hoangnguyen123@gmail.com', 89.99, N'140 Lê Trong Tấn TP Hồ Chí Minh', N'Huy Trương',  '03157839578'),
--	('US5', 5, 20000,  N'huytruong20@gmail.com', 89.99, N'140 Lê Trong Tấn TP Hồ Chí Minh', N'Huy Trương',  '03157839578'),
--	('US6', 6, 33000,  N'vinhnguyen3@gmail.com', 89.99, N'140 Lê Trong Tấn TP Hồ Chí Minh', N'Huy Trương',  '03157839578'),
--	('US7', 7, 40000,  N'kimdinh72@gmail.com', 89.99, N'140 Lê Trong Tấn TP Hồ Chí Minh', N'Huy Trương',  '03157839578');

-- Insert dữ liệu vào bảng OrderSystem
--INSERT INTO OrderSystem (OrderID, OrderDate, Status)
--VALUES 
--    (1, '2023-02-20', 'Chưa Xác Nhận'),
--	  (2, '2023-02-20', 'Chưa Xác Nhận'),

-- Insert dữ liệu vào bảng Cart_Detail
INSERT INTO Cart_Detail (CartID, ShoesID, StyleType, ColourID, Size, Price, Quantity, BuyingSelection_Status)
VALUES 
    (1, 'AF2', 'Men', 2, 39, 79.99, 1, 0);
-- Insert dữ liệu vào bảng Color_Detail
INSERT INTO Colour_Detail (ColourID, ShoesID)
VALUES 
    (2, 'AF1'),
	(3, 'AF1'),
	(4, 'AF1'),
    (1, 'AF2'),
	(2, 'AF2'),
	(5, 'AF2'),
	(4, 'AF3'),
	(6, 'AF3'),
	(7, 'AF3'),
	(2, 'AM1'),
	(5, 'AM1'),
	(7, 'AM1'),
	(1, 'AM2'),
	(2, 'AM2'),
	(3, 'AM2'),
	(5, 'AM3'),
	(6, 'AM3'),
	(12, 'AM3'),
	(2, 'JD1'),
	(3, 'JD1'),
	(2, 'JD2'),
	(6, 'JD2'),
	(7, 'JD2'),
	(4, 'JD3'),
	(6, 'JD3'),
	(10, 'JD3'),
	(1, 'SP1'),
	(2, 'SP1'),
	(3, 'SP1'),
	(3, 'SP2'),
	(4, 'SP2'),
	(8, 'SP2'),
	(2, 'SP3'),
	(3, 'SP3'),
	(6, 'SP3');
-- Insert dữ liệu vào bảng Favorite_Detail
--INSERT INTO Favorite_Detaill (FavoriteID, ShoesID, ColourID, StyleType)
--VALUES 
--    (1, 'AF2', 1, 'Women'),
--    (2, 'AF2', 2, 'Men');
--ShowShoesPage--
select sh.ShoesID , shd.Name,ts.Name, sh.StyleType, count(cl.ColourID) as 'Number_Colour', Price, img.Url
from Shoes sh, Shoes_Details shd, Colours cl, Colour_Detail cld, Type_Shoes ts,Images img
where sh.ShoesID = shd.ShoesID and cl.ColourID = cld.ColourID and cld.ShoesID = sh.ShoesID and img.ShoesID = sh.ShoesID
and shd.TypeShoesID = ts.TypeShoesID and sh.StyleType = 'Women'
group by sh.ShoesID , shd.Name,ts.Name, sh.StyleType, Price, img.Url
-----------------------------
select * from Type_Shoes
--ShowShoesDetails--
select shd.Name, sh.StyleType, sh.Price, img.Url
from Shoes_Details shd, Shoes sh, Images img
where shd.ShoesID = sh.ShoesID and img.ShoesID = sh.ShoesID
-----------------------------
--ShowHomePage--
select img.Url, shd.TypeShoesID, ts.Name
from Images img, Shoes_Details shd,Type_Shoes ts
where img.ShoesID = shd.ShoesID and shd.TypeShoesID = ts.TypeShoesID
-------------------
--ShowBagShoes--
select shd.Name,sh.StyleType,cl.Name,sh.Price,cd.Size,img.Url,cd.Quantity,sh.Discount
from Cart_Detail cd, Shopping_Cart sc, Shoes sh, Shoes_Details shd,Images img, Colours cl
where cd.CartID = sc.CartID and cd.ShoesID = sh.ShoesID and sh.ShoesID = shd.ShoesID
and img.ShoesID = sh.ShoesID and cl.ColourID = cd.ColourID and img.ColourID = cl.ColourID
--
select *
from Colours cl, Cart_Detail cd
where cl.ColourID = cd.ColourID
SELECT * FROM Users
SELECT *FROM Shop_Branchs
SELECT *FROM Shoes
SELECT*FROM Shoes_Details
SELECT*FROM Images
SELECT *FROM Icons
SELECT *FROM Related_staff
SELECT * FROM Users_ShipmentDetails
Drop table Users
Drop table Icons
Drop table Users_ShipmentDetails
drop table Colours
drop table Shoes
