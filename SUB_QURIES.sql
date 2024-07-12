--------------
--SUB-QUERIES
---------------


--FROM, WHERE, HAVING, SELECT
--SINGLE ROW = , > , <
SELECT *
FROM Products
WHERE UnitPrice < (SELECT UnitPrice FROM Products WHERE ProductID=1)

-- MULTIPLE ROWS
-- IN , NOT IN 
SELECT *
FROM Products
WHERE UnitPrice NOT IN (
	SELECT UnitPrice
	FROM Products
	WHERE CategoryID=2) 

--ALL, ANY
SELECT ProductName, UnitPrice
FROM Products
WHERE UnitPrice <ALL (
	SELECT UnitPrice
	FROM Products
	WHERE CategoryID=2)
--SELECT
SELECT *, (SELECT AVG(UNITPRICE) FROM Products) 'AVG'
FROM Products

--FROM
SELECT O.*,PPO.PRICE
FROM Orders O JOIN (
	SELECT ORDERID, SUM(UNITPRICE*QUANTITY) PRICE
	FROM [Order Details]
	GROUP BY OrderID) PPO
ON O.OrderID=PPO.ORDERID


SELECT ProductName, UnitPrice
FROM Products
WHERE UnitPrice <ALL (
	SELECT UnitPrice
	FROM Products
	WHERE CategoryID=2)

SELECT CompanyName
FROM Suppliers
WHERE SupplierID IN (
	SELECT SupplierID
	FROM Products
	WHERE CategoryID = (
		SELECT CategoryID
		FROM Categories
		WHERE CategoryName = 'BEVERAGES'))

-- EXISTS,  NOT EXISTS
SELECT *
FROM Products
WHERE NOT EXISTS (SELECT 0)

SELECT *
FROM Customers
WHERE NOT EXISTS (
	SELECT *
	FROM Orders O
	WHERE O.CustomerID=C.CustomerID)


--SHOW ALL THE ORDERS WHICH TOTALPRICE >200

SELECT OrderID,SUM(UnitPrice*Quantity) AS total
	FROM [Order Details]
	GROUP BY OrderID
	HAVING SUM(UnitPrice*Quantity)>200


SELECT * FROM
	(SELECT OrderID,SUM(UnitPrice*Quantity) AS total
	FROM [Order Details]
	GROUP BY OrderID) newTable
WHERE total>200

--productName 'Alice Mutton'
--write a query which show all the products that its price is more expensive 
--than productName 'Alice Mutton'

SELECT ProductName,UnitPrice
FROM Products
WHERE UnitPrice>
(SELECT UnitPrice
FROM Products
WHERE ProductName LIKE 'alice%')

SELECT p1.ProductName,p1.UnitPrice
FROM Products P1 JOIN Products P2
ON P1.UnitPrice>P2.UnitPrice AND P2.ProductName LIKE 'alice%'

SELECT p1.ProductName,p1.UnitPrice
FROM Products P1 JOIN Products P2
ON P1.UnitPrice>P2.UnitPrice


SELECT p1.ProductName,p1.UnitPrice
FROM Products P1 JOIN Products P2
ON P1.UnitPrice>P2.UnitPrice 
WHERE P2.ProductName LIKE 'ALICE%'

--FIND ALL THE SUPPLIERS THAT SUPPLY THE MOST EXPENSIVE PRODUCT 
SELECT S.CompanyName
FROM Suppliers S JOIN Products P
ON S.SupplierID=P.SupplierID
WHERE P.UnitPrice=(
SELECT MAX(UNITPRICE)
FROM Products)

--FIND THE EMPLOYEE NAME WHICH MADE THE MOST EXPENSIVE ORDER 
SELECT E.FirstName+' '+E.LastName
FROM Employees E 
JOIN
(SELECT TOP 2 O.ORDERID,O.EmployeeID 
FROM Orders O JOIN [Order Details] OD
ON O.OrderID=OD.OrderID
GROUP BY O.ORDERID,O.EmployeeID
ORDER BY SUM(OD.UNITPRICE*OD.QUANTITY) DESC) newTable
ON E.EmployeeID=newTable.EmployeeID


SELECT E.FirstName+E.LastName FROM 
(SELECT * FROM Orders O WHERE OrderID=
(SELECT TOP 1 OrderID from(
SELECT ORDERID,SUM(UNITPRICE*QUANTITY) AS total
FROM [Order Details]
GROUP BY OrderID) aaa
ORDER BY total DESC)) ABC
JOIN Employees E ON ABC.EmployeeID= E.EmployeeID


--FIND THE CUSTOMERS WHICH MADE MORE THAN 10 ORDERS
SELECT * FROM
(SELECT CustomerID,COUNT(*) CNT
FROM Orders
GROUP BY CustomerID) new
WHERE CNT>10

SELECT CustomerID,COUNT(*) CNT
FROM Orders
GROUP BY CustomerID
HAVING COUNT(*)>10

SELECT COUNT(*),COUNT(CUSTOMERID),COUNT(ORDERID)
FROM Orders
--show the orders which num of products is above the avg num of products
--מספרי הזמנות בעלות מספר מוצרים גדול מהממוצע הכללי להזמנה

SELECT OrderID,COUNT(*) AS cnt
FROM [Order Details]
GROUP BY OrderID
HAVING COUNT(*)>
(SELECT AVG(cnt)
FROM
(SELECT COUNT(*) AS cnt
FROM [Order Details]
GROUP BY OrderID) A1)