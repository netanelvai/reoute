------------------------
---- GROUPING SETS -----
-----------------------

SELECT O.EmployeeID, YEAR(OrderDate) AS 'Year', SUM(UnitPrice*Quantity) AS Earnings
FROM Employees E JOIN Orders O
ON E.EmployeeID=O.EmployeeID
JOIN [Order Details] OD
ON O.OrderID=OD.OrderID
GROUP BY GROUPING SETS ((O.EmployeeID, YEAR(OrderDate)), O.EmployeeID, YEAR(OrderDate))
ORDER BY O.EmployeeID, YEAR(OrderDate)

SELECT O.EmployeeID, YEAR(OrderDate) AS 'Year', SUM(UnitPrice*Quantity) AS Earnings
FROM Employees E JOIN Orders O
ON E.EmployeeID=O.EmployeeID
JOIN [Order Details] OD
ON O.OrderID=OD.OrderID
GROUP BY O.EmployeeID, YEAR(OrderDate)
ORDER BY O.EmployeeID, YEAR(OrderDate)


SELECT ShipCountry,  YEAR(OrderDate) AS 'Year',SUM(Freight) AS MISHLOHIM
FROM Orders
GROUP BY ShipCountry,  YEAR(OrderDate)
ORDER BY ShipCountry


SELECT ShipCountry,  YEAR(OrderDate) AS 'Year',SUM(Freight) AS MISHLOHIM
FROM Orders
GROUP BY GROUPING SETS(ShipCountry,  YEAR(OrderDate))--,ShipCountry,  YEAR(OrderDate)
ORDER BY ShipCountry

SELECT ShipCountry,  YEAR(OrderDate) AS 'Year',SUM(Freight) AS MISHLOHIM
FROM Orders
GROUP BY GROUPING SETS(ShipCountry,  YEAR(OrderDate),ShipCountry,  YEAR(OrderDate))
ORDER BY ShipCountry

SELECT ShipCountry,  YEAR(OrderDate) AS 'Year',SUM(Freight) AS MISHLOHIM
FROM Orders
GROUP BY GROUPING SETS((ShipCountry,  YEAR(OrderDate)),ShipCountry,  YEAR(OrderDate))
ORDER BY ShipCountry,  YEAR(OrderDate) DESC

SELECT ShipCountry,  YEAR(OrderDate) AS 'Year',SUM(Freight) AS MISHLOHIM
FROM Orders
GROUP BY GROUPING SETS((ShipCountry,  YEAR(OrderDate)),ShipCountry,  YEAR(OrderDate))
ORDER BY ShipCountry ,  YEAR(OrderDate) 

/*AVG PRODUCT PRICE FOR EACH SUPPLIER AND  CATEGORY*/

SELECT P.CategoryID,S.ContactName AS SupplierName,AVG(UnitPrice) AS avgP
FROM Suppliers S JOIN Products P 
ON S.SupplierID=P.SupplierID
GROUP BY P.CategoryID,S.ContactName
ORDER BY P.CategoryID


SELECT P.CategoryID,AVG(UnitPrice) AS avgP
FROM Suppliers S JOIN Products P 
ON S.SupplierID=P.SupplierID
GROUP BY P.CategoryID
ORDER BY P.CategoryID

SELECT S.ContactName AS SupplierName,AVG(UnitPrice) AS avgP
FROM Suppliers S JOIN Products P 
ON S.SupplierID=P.SupplierID
GROUP BY S.ContactName
ORDER BY S.ContactName


SELECT P.CategoryID,S.ContactName AS SupplierName,AVG(UnitPrice) AS avgP
FROM Suppliers S JOIN Products P 
ON S.SupplierID=P.SupplierID
GROUP BY GROUPING SETS(P.CategoryID,S.ContactName)
ORDER BY P.CategoryID


SELECT P.CategoryID,S.ContactName AS SupplierName,AVG(UnitPrice) AS avgP
FROM Suppliers S JOIN Products P 
ON S.SupplierID=P.SupplierID
GROUP BY GROUPING SETS((P.CategoryID,S.ContactName),P.CategoryID,S.ContactName,())
ORDER BY P.CategoryID,S.ContactName

SELECT P.CategoryID,S.ContactName AS SupplierName,AVG(UnitPrice) AS avgP
FROM Suppliers S JOIN Products P 
ON S.SupplierID=P.SupplierID
GROUP BY GROUPING SETS((P.CategoryID,S.ContactName),P.CategoryID,S.ContactName)
ORDER BY P.CategoryID,S.ContactName


SELECT AVG(UNITPRICE) FROM Products


------------------------
---- WINDOW FUNCTIONS --
-----------------------

SELECT ProductName,UnitPrice,AVG(UNITPRICE)
FROM Products
GROUP BY ProductName,UnitPrice

SELECT ProductName,UnitPrice,AVG(UNITPRICE) OVER()
FROM Products
GROUP BY ProductName,UnitPrice
ORDER BY ProductName

SELECT ProductName,UnitPrice,AVG(UNITPRICE) OVER() EEEE,SUM(UNITPRICE) OVER() OOOO
FROM Products
ORDER BY ProductName

SELECT ProductName,UnitPrice,AVG(UNITPRICE) OVER(), UnitPrice-(AVG(UNITPRICE) OVER() )
FROM Products
ORDER BY ProductName

SELECT CategoryID,SUM(UNITPRICE),COUNT(*) OVER(PARTITION BY CATEGORYID)
FROM Products
GROUP BY CategoryID


SELECT CategoryID,COUNT(CategoryID) OVER()
FROM Products
GROUP BY CategoryID

SELECT CategoryID,COUNT(*) OVER(PARTITION BY CATEGORYID),AVG(UNITPRICE) OVER(PARTITION BY CATEGORYID),AVG(UNITPRICE)
FROM Products
GROUP BY CategoryID

SELECT YEAR(O.OrderDate) ,OD.UnitPrice,
SUM(OD.UNITPRICE) OVER(PARTITION BY YEAR(O.OrderDate))
FROM ORDERS O JOIN [Order Details] OD 
ON O.OrderID=OD.OrderID

SELECT YEAR(O.OrderDate) ,OD.UnitPrice,
SUM(OD.UNITPRICE) OVER(PARTITION BY YEAR(O.OrderDate) ORDER BY YEAR(O.OrderDate)
ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)
FROM ORDERS O JOIN [Order Details] OD 
ON O.OrderID=OD.OrderID

SELECT YEAR(O.OrderDate) ,OD.UnitPrice,
AVG(OD.UNITPRICE) OVER(PARTITION BY YEAR(O.OrderDate) ORDER BY YEAR(O.OrderDate)
ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)
FROM ORDERS O JOIN [Order Details] OD 
ON O.OrderID=OD.OrderID
ORDER BY YEAR(O.OrderDate)

--ROW NUMBER


SELECT YEAR(O.OrderDate) ,O.OrderDate,
ROW_NUMBER() OVER(PARTITION BY YEAR(O.OrderDate) ORDER BY O.ORDERDATE)
FROM ORDERS O JOIN [Order Details] OD 
ON O.OrderID=OD.OrderID
WHERE O.CustomerID='ANATR'

SELECT YEAR(O.OrderDate) ,O.OrderDate,O.CUSTOMERID,
ROW_NUMBER() OVER(PARTITION BY YEAR(O.OrderDate) ORDER BY O.ORDERDATE)
FROM ORDERS O JOIN [Order Details] OD 
ON O.OrderID=OD.OrderID

SELECT YEAR(O.OrderDate) ,O.OrderDate,O.CUSTOMERID,
ROW_NUMBER() OVER(PARTITION BY O.CUSTOMERID,YEAR(O.OrderDate) ORDER BY O.ORDERDATE)
FROM ORDERS O JOIN [Order Details] OD 
ON O.OrderID=OD.OrderID

SELECT YEAR(O.OrderDate) ,O.OrderDate,O.CUSTOMERID,
ROW_NUMBER() OVER( ORDER BY O.ORDERDATE)
FROM ORDERS O JOIN [Order Details] OD 
ON O.OrderID=OD.OrderID

SELECT CategoryID,ProductName,UnitPrice,
ROW_NUMBER() OVER(PARTITION BY CategoryID ORDER BY UnitPrice )
FROM Products

/* SHOW FOR EACH CUSTOMER HIS 5 FIRST ORDERS NUMBER*/

SELECT * FROM (
SELECT CustomerID,OrderID,OrderDate,
ROW_NUMBER() OVER(PARTITION BY CustomerID ORDER BY ORDERDATE ) AS NUM
FROM Orders) AS newTable
WHERE NUM<=5


--RANK
SELECT CategoryID,ProductName,UnitPrice,
RANK() OVER(PARTITION BY CategoryID ORDER BY UnitPrice )
FROM Products

--DENSE_RANK


SELECT CategoryID,ProductName,UnitPrice,
DENSE_RANK() OVER(PARTITION BY CategoryID ORDER BY UnitPrice )
FROM Products

SELECT CategoryID,ProductName,UnitPrice,
RANK() OVER(PARTITION BY CategoryID ORDER BY UnitPrice ),
DENSE_RANK() OVER(PARTITION BY CategoryID ORDER BY UnitPrice )
FROM Products


--NTILE 
SELECT ProductID,ProductName,UNITPRICE,
NTILE(5) OVER (ORDER BY UNITPRICE)
FROM Products
WHERE ProductID<=21

--LAG/LEAD
SELECT ProductID,ProductName,UnitPrice,
LAG(UnitPrice,1) OVER (ORDER BY UnitPrice) 'LAG',
LEAD(UnitPrice,1) OVER (ORDER BY UnitPrice) 'LEAD'
FROM Products
ORDER BY UnitPrice

SELECT ProductID,ProductName,UnitPrice,
LAG(UnitPrice,5) OVER (ORDER BY UnitPrice) 'LAG',
LEAD(UnitPrice,5) OVER (ORDER BY UnitPrice) 'LEAD'
FROM Products
ORDER BY UnitPrice

SELECT ProductID,ProductName,UnitPrice,
LAG(UnitPrice,2) OVER (ORDER BY UnitPrice) 'LAG',
LEAD(UnitPrice,4) OVER (ORDER BY UnitPrice) 'LEAD'
FROM Products
ORDER BY UnitPrice

SELECT *
FROM Products