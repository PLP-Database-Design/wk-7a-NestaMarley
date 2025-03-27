--  using SQL Server
CREATE TABLE ProductDetail_1NF (
    OrderID INT,
    CustomerName VARCHAR(50),
    Product VARCHAR(50)
);

INSERT INTO ProductDetail_1NF
SELECT OrderID, CustomerName, value
FROM ProductDetail
CROSS APPLY STRING_SPLIT(Products, ',');


-- Step 1: Create a new table for Customers
CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,
    CustomerName VARCHAR(50)
);

-- Step 2: Insert data into the Customers table
INSERT INTO Customers (CustomerID, CustomerName)
SELECT DISTINCT OrderID, CustomerName
FROM OrderDetails;

-- Step 3: Create the new OrderDetails table in 2NF
CREATE TABLE OrderDetails_2NF (
    OrderID INT,
    ProductID INT,
    Quantity INT,
    PRIMARY KEY (OrderID, ProductID),
    FOREIGN KEY (OrderID) REFERENCES Customers(CustomerID)
);

-- Step 4: Insert data into the OrderDetails_2NF table
INSERT INTO OrderDetails_2NF (OrderID, ProductID, Quantity)
SELECT OrderID, ROW_NUMBER() OVER (PARTITION BY OrderID, Product ORDER BY Product) AS ProductID, Quantity
FROM OrderDetails;
