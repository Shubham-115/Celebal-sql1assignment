CREATE TABLE Customers (
    CustomerID VARCHAR(5) PRIMARY KEY,
    CompanyName VARCHAR(40),
    ContactName VARCHAR(30),
    ContactTitle VARCHAR(30),
    Address VARCHAR(60),
    City VARCHAR(15),
    Region VARCHAR(15),
    PostalCode VARCHAR(10),
    Country VARCHAR(15),
    Phone VARCHAR(24),
    Fax VARCHAR(24)
);
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerID VARCHAR(5),
    EmployeeID INT,
    OrderDate DATE,
    RequiredDate DATE,
    ShippedDate DATE,
    ShipVia INT,
    Freight DECIMAL(10, 2),
    ShipName VARCHAR(40),
    ShipAddress VARCHAR(60),
    ShipCity VARCHAR(15),
    ShipRegion VARCHAR(15),
    ShipPostalCode VARCHAR(10),
    ShipCountry VARCHAR(15),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID),
    FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID),
    FOREIGN KEY (ShipVia) REFERENCES Shippers(ShipperID)
);
CREATE TABLE OrderDetails (
    OrderID INT,
    ProductID INT,
    UnitPrice DECIMAL(10, 2),
    Quantity INT,
    Discount DECIMAL(3, 2),
    PRIMARY KEY (OrderID, ProductID),
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);
CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(40),
    SupplierID INT,
    CategoryID INT,
    QuantityPerUnit VARCHAR(20),
    UnitPrice DECIMAL(10, 2),
    UnitsInStock INT,
    UnitsOnOrder INT,
    ReorderLevel INT,
    Discontinued BOOLEAN,
    FOREIGN KEY (SupplierID) REFERENCES Suppliers(SupplierID),
    FOREIGN KEY (CategoryID) REFERENCES Categories(CategoryID)
);
CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY,
    LastName VARCHAR(20),
    FirstName VARCHAR(10),
    Title VARCHAR(30),
    TitleOfCourtesy VARCHAR(25),
    BirthDate DATE,
    HireDate DATE,
    Address VARCHAR(60),
    City VARCHAR(15),
    Region VARCHAR(15),
    PostalCode VARCHAR(10),
    Country VARCHAR(15),
    HomePhone VARCHAR(24),
    Extension VARCHAR(4),
    Notes TEXT,
    ReportsTo INT,
    FOREIGN KEY (ReportsTo) REFERENCES Employees(EmployeeID)
);
CREATE TABLE Shippers (
    ShipperID INT PRIMARY KEY,
    CompanyName VARCHAR(40),
    Phone VARCHAR(24)
);
CREATE TABLE Suppliers (
    SupplierID INT PRIMARY KEY,
    CompanyName VARCHAR(40),
    ContactName VARCHAR(30),
    ContactTitle VARCHAR(30),
    Address VARCHAR(60),
    City VARCHAR(15),
    Region VARCHAR(15),
    PostalCode VARCHAR(10),
    Country VARCHAR(15),
    Phone VARCHAR(24),
    Fax VARCHAR(24),
    HomePage TEXT
);
CREATE TABLE Categories (
    CategoryID INT PRIMARY KEY,
    CategoryName VARCHAR(15),
    Description TEXT
);
SELECT * FROM Customers;
SELECT * FROM Customers WHERE CompanyName LIKE '%N';
SELECT * FROM Customers WHERE City IN ('Berlin', 'London');
SELECT * FROM Customers WHERE Country IN ('UK', 'USA');
SELECT * FROM Products ORDER BY ProductName;
SELECT * FROM Products WHERE ProductName LIKE 'A%';
SELECT DISTINCT c.*
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID;
SELECT c.*
FROM Customers c
LEFT JOIN Orders o ON c.CustomerID = o.CustomerID
WHERE o.OrderID IS NULL;
SELECT DISTINCT c.*
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID
JOIN OrderDetails od ON o.OrderID = od.OrderID
JOIN Products p ON od.ProductID = p.ProductID
WHERE c.City = 'London' AND p.ProductName = 'Chai';
SELECT DISTINCT c.*
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID
JOIN OrderDetails od ON o.OrderID = od.OrderID
JOIN Products p ON od.ProductID = p.ProductID
WHERE p.ProductName = 'Tofu';
SELECT * FROM Orders ORDER BY OrderDate;
SELECT o.OrderDate, SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)) AS OrderTotal
FROM Orders o
JOIN OrderDetails od ON o.OrderID = od.OrderID
GROUP BY o.OrderDate
ORDER BY OrderTotal DESC;
SELECT OrderID, AVG(Quantity) AS AverageQuantity
FROM OrderDetails
GROUP BY OrderID;
SELECT OrderID, MIN(Quantity) AS MinQuantity, MAX(Quantity) AS MaxQuantity
FROM OrderDetails
GROUP BY OrderID;
SELECT e1.EmployeeID, e1.FirstName, e1.LastName, COUNT(e2.EmployeeID) AS NumberOfReports
FROM Employees e1
JOIN Employees e2 ON e1.EmployeeID = e2.ReportsTo
GROUP BY e1.EmployeeID, e1.FirstName, e1.LastName;
SELECT OrderID, SUM(Quantity) AS TotalQuantity
FROM OrderDetails
GROUP BY OrderID
HAVING TotalQuantity > 300;
SELECT * FROM Orders WHERE OrderDate >= '1996-12-31';
SELECT * FROM Orders WHERE ShipCountry = 'Canada';
SELECT o.*
FROM Orders o
JOIN OrderDetails od ON o.OrderID = od.OrderID
GROUP BY o.OrderID
HAVING SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)) > 200;
SELECT ShipCountry, SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)) AS TotalSales
FROM Orders o
JOIN OrderDetails od ON o.OrderID = od.OrderID
GROUP BY ShipCountry;
SELECT c.ContactName, COUNT(o.OrderID) AS NumberOfOrders
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID
GROUP BY c.ContactName;
SELECT c.ContactName, COUNT(o.OrderID) AS NumberOfOrders
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID
GROUP BY c.ContactName
HAVING NumberOfOrders > 3;
SELECT DISTINCT p.*
FROM Products p
JOIN OrderDetails od ON p.ProductID = od.ProductID
JOIN Orders o ON od.OrderID = o.OrderID
WHERE p.Discontinued = 1 AND o.OrderDate BETWEEN '1997-01-01' AND '1998-01-01';
SELECT e1.FirstName AS EmployeeFirstName, e1.LastName AS EmployeeLastName, 
       e2.FirstName AS SupervisorFirstName, e2.LastName AS SupervisorLastName
FROM Employees e1
LEFT JOIN Employees e2 ON e1.ReportsTo = e2.EmployeeID;
SELECT e.EmployeeID, SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)) AS TotalSales
FROM Employees e
JOIN Orders o ON e.EmployeeID = o.EmployeeID
JOIN OrderDetails od ON o.OrderID = od.OrderID
GROUP BY e.EmployeeID;
SELECT * FROM Employees WHERE FirstName LIKE '%a%';
SELECT e1.EmployeeID, e1.FirstName, e1.LastName, COUNT(e2.EmployeeID) AS NumberOfReports
FROM Employees e1
JOIN Employees e2 ON e1.EmployeeID = e2.ReportsTo
GROUP BY e1.EmployeeID, e1.FirstName, e1.LastName
HAVING NumberOfReports > 4;
SELECT o.OrderID, p.ProductName
FROM Orders o
JOIN OrderDetails od ON o.OrderID = od.OrderID
JOIN Products p ON od.ProductID = p.ProductID;
SELECT o.*
FROM Orders o
WHERE o.CustomerID IN (
    SELECT CustomerID
    FROM CustomerSpending
    WHERE TotalSpent = (
        SELECT MAX(TotalSpent)
        FROM (
            SELECT CustomerID, SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)) AS TotalSpent
            FROM Orders o
            JOIN OrderDetails od ON o.OrderID = od.OrderID
            GROUP BY CustomerID
        ) AS TotalSpendingSubquery
    )
);
SELECT o.*
FROM Orders o
JOIN Customers c ON o.CustomerID = c.CustomerID
WHERE c.Fax IS NULL;
SELECT DISTINCT o.ShipPostalCode
FROM Orders o
JOIN OrderDetails od ON o.OrderID = od.OrderID
JOIN Products p ON od.ProductID = p.ProductID
WHERE p.ProductName = 'Tofu';
SELECT DISTINCT p.ProductName
FROM Orders o
JOIN OrderDetails od ON o.OrderID = od.OrderID
JOIN Products p ON od.ProductID = p.ProductID
WHERE o.ShipCountry = 'France';
SELECT p.ProductName, c.CategoryName
FROM Products p
JOIN Suppliers s ON p.SupplierID = s.SupplierID
JOIN Categories c ON p.CategoryID = c.CategoryID
WHERE s.CompanyName = 'Specialty Biscuits, Ltd.';
SELECT p.*
FROM Products p
LEFT JOIN OrderDetails od ON p.ProductID = od.ProductID
WHERE od.ProductID IS NULL;
SELECT * FROM Products
WHERE UnitsInStock < 10 AND UnitsOnOrder = 0;
SELECT ShipCountry, SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)) AS TotalSales
FROM Orders o
JOIN OrderDetails od ON o.OrderID = od.OrderID
GROUP BY ShipCountry
ORDER BY TotalSales DESC ;
SELECT e.EmployeeID, e.FirstName, e.LastName, COUNT(o.OrderID) AS NumberOfOrders
FROM Employees e
JOIN Orders o ON e.EmployeeID = o.EmployeeID
JOIN Customers c ON o.CustomerID = c.CustomerID
WHERE c.CustomerID BETWEEN 'A' AND 'AO'
GROUP BY e.EmployeeID, e.FirstName, e.LastName;
SELECT o.OrderDate
FROM Orders o
JOIN OrderDetails od ON o.OrderID = od.OrderID
GROUP BY o.OrderID
ORDER BY SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)) DESC ;
SELECT p.ProductName, SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)) AS TotalRevenue
FROM Products p
JOIN OrderDetails od ON p.ProductID = od.ProductID
GROUP BY p.ProductName
ORDER BY TotalRevenue DESC ;
SELECT SupplierID, COUNT(ProductID) AS NumberOfProducts
FROM Products
GROUP BY SupplierID;
SELECT c.CustomerID, c.CompanyName, SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)) AS TotalSpent
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID
JOIN OrderDetails od ON o.OrderID = od.OrderID
GROUP BY c.CustomerID, c.CompanyName
ORDER BY TotalSpent DESC ;
SELECT SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)) AS TotalRevenue
FROM OrderDetails od;



    




