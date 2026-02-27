/*========================================================
 PHASE 2: Sales Analysis System
 Views & Stored Procedures
========================================================*/

USE AdventureWorksLT;
GO

-- View for sales analysis
CREATE OR ALTER VIEW dbo.vw_SalesOrderDetails
AS
SELECT
    soh.SalesOrderID,
    CONCAT(c.FirstName, ' ', c.LastName) AS CustomerName,
    p.Name AS ProductName,
    sod.OrderQty,
    sod.UnitPrice,
    (sod.OrderQty * sod.UnitPrice) AS TotalPrice
FROM SalesLT.SalesOrderHeader soh
JOIN SalesLT.Customer c ON soh.CustomerID = c.CustomerID
JOIN SalesLT.SalesOrderDetail sod ON soh.SalesOrderID = sod.SalesOrderID
JOIN SalesLT.Product p ON sod.ProductID = p.ProductID;
GO

-- Stored Procedure with validation
CREATE OR ALTER PROCEDURE dbo.UpdateProductPrice
    @ProductID INT,
    @NewPrice DECIMAL(10,2)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @CurrentPrice DECIMAL(10,2);

    SELECT @CurrentPrice = ListPrice
    FROM SalesLT.Product
    WHERE ProductID = @ProductID;

    IF @CurrentPrice IS NULL
    BEGIN
        ;THROW 50001, 'Invalid ProductID.', 1;
    END;

    IF @NewPrice < (@CurrentPrice * 0.5)
    BEGIN
        ;THROW 50002, N'New price cannot be less than 50% of current price.', 1;
    END;

    UPDATE SalesLT.Product
    SET ListPrice = @NewPrice
    WHERE ProductID = @ProductID;
END;
GO

-- Query view
SELECT *
FROM dbo.vw_SalesOrderDetails
ORDER BY TotalPrice DESC;
GO

-- Execute procedure
EXEC dbo.UpdateProductPrice @ProductID = 680, @NewPrice = 50.00;
GO
