/* USE SalesDataDB;
GO

-- 1. Create target table schema
CREATE TABLE dbo.SalesStaging (
    Region VARCHAR(100),
    Country VARCHAR(100),
    ItemType VARCHAR(100),
    SalesChannel VARCHAR(50),
    OrderPriority CHAR(1),
    OrderDate DATE,
    OrderID BIGINT,
    ShipDate DATE,
    UnitsSold INT,
    UnitPrice DECIMAL(10, 2),
    UnitCost DECIMAL(10, 2),
    TotalRevenue DECIMAL(15, 2),
    TotalCost DECIMAL(15, 2),
    TotalProfit DECIMAL(15, 2)
);
GO

-- 2. Bulk insert data directly from the CSV file
BULK INSERT dbo.SalesStaging
FROM 'C:\Users\Hamza\Downloads\Sales_Project.csv'
WITH (
    FIRSTROW = 2,           -- Skips header row
    FIELDTERMINATOR = ',',   -- CSV column delimiter
    ROWTERMINATOR = '\n',    -- Line breakdown
    TABLOCK
);
GO

-- 3. Verify inserted data
SELECT TOP 10 * FROM dbo.SalesStaging; */

/* USE SalesDataDB;
GO

-- 1. Create a clean, production-ready table with ideal column names
CREATE TABLE dbo.Sales (
    Region VARCHAR(100),
    Country VARCHAR(100),
    ItemType VARCHAR(100),
    SalesChannel VARCHAR(50),
    OrderPriority CHAR(1),
    OrderDate DATE,
    OrderID BIGINT PRIMARY KEY,
    ShipDate DATE,
    UnitsSold INT,
    UnitPrice DECIMAL(10, 2),
    UnitCost DECIMAL(10, 2),
    TotalRevenue DECIMAL(15, 2),
    TotalCost DECIMAL(15, 2),
    TotalProfit DECIMAL(15, 2)
);
GO

-- 2. Populate the clean table from your staging table
INSERT INTO dbo.Sales (
    Region, Country, ItemType, SalesChannel, OrderPriority,
    OrderDate, OrderID, ShipDate, UnitsSold, UnitPrice,
    UnitCost, TotalRevenue, TotalCost, TotalProfit
)
SELECT 
    Region, Country, ItemType, SalesChannel, OrderPriority,
    OrderDate, OrderID, ShipDate, UnitsSold, UnitPrice,
    UnitCost, TotalRevenue, TotalCost, TotalProfit
FROM dbo.SalesStaging;
GO

-- 3. Verify total row count matches the 100 records from the original file
SELECT COUNT(*) AS LoadedRowCount FROM dbo.Sales;
GO */ 

