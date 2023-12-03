USE DB_XC_Shoes_Store

--ShowShoesPage--
select shd.Name,ts.Name, sh.StyleType, count(cl.ColourID) as 'Number_Colour', Price, img.Url
from Shoes sh, Shoes_Details shd, Colours cl, Colour_Detail cld, Type_Shoes ts,Images img
where sh.ShoesID = shd.ShoesID and cl.ColourID = cld.ColourID and cld.ShoesID = sh.ShoesID and img.ShoesID = sh.ShoesID
and shd.TypeShoesID = ts.TypeShoesID and sh.StyleType = 'Men'
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

--ShowFavoritePage--
select shd.Name,ts.Name, count(cl.ColourID) as 'Number_Colour', Price, img.Url
from Shoes sh, Shoes_Details shd, Colours cl, Colour_Detail cld, Type_Shoes ts,Images img,Favorites f,Favorite_Detaill fd,Users u
where sh.ShoesID = shd.ShoesID and cl.ColourID = fd.ColourID and cld.ShoesID = sh.ShoesID and img.ShoesID = sh.ShoesID
and shd.TypeShoesID = ts.TypeShoesID and f.UserID = u.UserID and fd.FavoriteID = f.FavoriteID and fd.ShoesID = sh.ShoesID
and  u.UserID = 'US3'
group by sh.ShoesID , shd.Name,ts.Name, Price, img.Url

--ShowFavoritePage--Hi hòn
SELECT SD.Name,TS.Name, count(FD.ColourID) as 'Number_Colour',S.Price,Im.Url
FROM Favorites f, Favorite_Detaill FD,Shoes S,Shoes_Details SD,Type_Shoes TS,Colour_Detail CD,Images Im
WHERE f.FavoriteID = FD.FavoriteID AND FD.ShoesID = S.ShoesID AND SD.ShoesID = S.ShoesID AND TS.TypeShoesID = SD.TypeShoesID AND CD.ColourID = FD.ColourID 
AND Im.ColourID = Fd.ColourID AND F.UserID = 'US3'
GROUP BY SD.Name,TS.Name,S.Price,Im.Url

---UserProfile---
--Lay chuoi truoc @--
SELECT dbo.GetBeforeMailString(u.Email) as  'NameTag', u.UserName
from Users u
where u.UserID='US1'

--Purchased
SELECT SD.Name,SD.TypeShoesID,OD.ColourID,OD.size
FROM Order_Detail OD,Shoes S,Shoes_Details SD
WHERE OD.ShoesID = S.ShoesID AND s.ShoesID = SD.TypeShoesID

--Account
SELECT *
FROM Users
WHERE UserID = 'US1';

--Delivery
SELECT *
FROM Users_ShipmentDetails
WHERE UserID = 'US1';

--Manager Admin
SELECT Image,UserName,UserID,Email,PhoneNumber
FROM Users
Where Role= 1

--Manager Admin
SELECT Image,UserName,UserID,Email,PhoneNumber
FROM Users
Where Role= 0

--Manage Products
SELECT sh.ShoesID,img.url,shd.Name,tps.Name,count(DISTINCT cl.Name) as 'Number_Colour',Price
FROM Images img , Shoes sh,Type_Shoes tps,Colour_Detail cld,Shoes_Details shd,Colours cl
Where sh.ShoesID = shd.ShoesID and cl.ColourID = cld.ColourID and cld.ShoesID = sh.ShoesID and img.ShoesID = shd.ShoesID 
and shd.TypeShoesID = tps.TypeShoesID and sh.ShoesID = 'AF1'
Group by sh.ShoesID,img.url,shd.Name,tps.Name,Price

--Manage Orders
SELECT O.OrderID, 
O.UserID, 
O.PaymentInfo, 
O.EstimatedDeliveryHandlingFee, 
O.Email, 
O.Total, 
O.PaymentStatus, 
O.RecipientAddress, 
O.RecipientName,
O.RecipientPhoneNumber,
O.OrderDate,
OS.EmployeeID,
OS.Status
FROM ORDERS O
JOIN OrderSystem OS ON O.OrderID = OS.OrderID
Where OS.Status like N'Wait for confirmation'
--And (O.RecipientName like N'%03157839578%' Or O.Email like N'%03157839578%' Or O.RecipientPhoneNumber like '%03157839578%')
Order by O.OrderID ASC

Select 
OrderID, 
OD.ShoesID, 
Quantity, 
Size, 
StyleType, 
OD.ColourID, 
Price,
SD.Name,
C.Name
from Order_Detail OD 
join Shoes_Details SD ON OD.ShoesID = SD.ShoesID
join Colours C ON OD.ColourID = C.ColourID
Where OD.OrderID = 'Order1'

SELECT * FROM ORDERSYSTEM
SELECT * FROM Order_Detail

SELECT O.ORDERID, OS.ORDERDATE, O.TOTAL, OS.STATUS
FROM ORDERS O, ORDERSYSTEM OS
WHERE O.ORDERID = OS.ORDERID

SELECT us.UserName,od.RecipientPhoneNumber,od.Email,od.RecipientAddress
FROM Orders od,Users us
WHERE OD.UserID = US.UserID

SELECT odd.ShoesID,img.url,img.Name,tps.Name,cl.Name,ODD.Quantity,ODD.Price
FROM Images img , Type_Shoes tps,Colour_Detail cld,Shoes_Details shd,Colours cl,Order_Detail ODD
Where img.ShoesID = odd.ShoesID and shd.ShoesID = odd.ShoesID and tps.TypeShoesID = shd.TypeShoesID and cl.ColourID = odd.ColourID
Group by odd.ShoesID,img.url,img.Name,tps.Name,cl.Name,ODD.Quantity,ODD.Price

SELECT Quantity*Price
FROM Order_Detail

--My Account
--XEM
SELECT UserID,Email,Password,PhoneNumber
FROM USERS

--Sửa
Update USERS
SET UserID='',Email='',Password='',PhoneNumber=''

--Xóa 
Delete from USERS
WHere UserName= '';

--View
SELECT img.url,shd.Name,cl.Name,sum(DISTINCT od.Quantity) AS 'Quantity Sold'
FROM Images img,Shoes_Details shd,Order_Detail od,Colour_Detail cld,Colours cl
where shd.ShoesID = cld.ShoesID AND cl.ColourID = cld.ColourID AND shd.ShoesID = img.ShoesID AND shd.ShoesID = od.ShoesID AND od.ShoesID='JD1'
Group by img.url,shd.Name,cl.Name

--Thong tin giay da dat--

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