-- ============================================================================
-- SQL Portfolio Project: Global Sales & Profitability Analysis
-- Dataset: Sales_Project (100 Records)
-- Features: SELECT, WHERE, ORDER BY, TOP, DISTINCT, JOINS, SET OPERATORS, OPERATORS
-- ============================================================================

USE SalesDataDB;
GO

-- ----------------------------------------------------------------------------
-- Question 1: Top 5 Highest Revenue Orders
-- Business Context: Identify the individual transactions generating the highest gross revenue.
-- Concepts Used: SELECT, TOP, ORDER BY
-- ----------------------------------------------------------------------------
SELECT TOP 5
    OrderID,
    Country,
    ItemType,
    SalesChannel,
    TotalRevenue
FROM dbo.Sales
ORDER BY TotalRevenue DESC;
GO

-- ----------------------------------------------------------------------------
-- Question 2: High-Priority Online Sales in Europe
-- Business Context: Find critical (Priority 'H') online transactions within Europe to monitor order fulfillment speed.
-- Concepts Used: WHERE, Logical Operators (AND)
-- ----------------------------------------------------------------------------
SELECT 
    OrderID,
    Country,
    ItemType,
    OrderDate,
    TotalProfit
FROM dbo.Sales
WHERE Region = 'Europe' 
  AND SalesChannel = 'Online' 
  AND OrderPriority = 'H'
ORDER BY OrderDate DESC;
GO

-- ----------------------------------------------------------------------------
-- Question 3: Distinct Item Types Distributed Across Sub-Saharan Africa
-- Business Context: List all unique product categories currently expanding into the Sub-Saharan African region.
-- Concepts Used: DISTINCT, WHERE
-- ----------------------------------------------------------------------------
SELECT DISTINCT 
    ItemType
FROM dbo.Sales
WHERE Region = 'Sub-Saharan Africa'
ORDER BY ItemType ASC;
GO

-- ----------------------------------------------------------------------------
-- Question 4: Large Volume Orders (5,000 to 10,000 Units Sold)
-- Business Context: Filter orders with high bulk volume to assess supply chain efficiency.
-- Concepts Used: WHERE, BETWEEN Operator, ORDER BY
-- ----------------------------------------------------------------------------
SELECT 
    OrderID,
    Country,
    ItemType,
    UnitsSold,
    TotalRevenue
FROM dbo.Sales
WHERE UnitsSold BETWEEN 5000 AND 10000
ORDER BY UnitsSold DESC;
GO

-- ----------------------------------------------------------------------------
-- Question 5: High-Profit Margins in Specific Regions (Asia or North America)
-- Business Context: Extract transactions from Asia or North America where net profit exceeded $500,000.
-- Concepts Used: WHERE, IN Operator, Comparison Operators, AND/OR
-- ----------------------------------------------------------------------------
SELECT 
    OrderID,
    Region,
    Country,
    ItemType,
    TotalProfit
FROM dbo.Sales
WHERE Region IN ('Asia', 'North America')
  AND TotalProfit > 500000.00
ORDER BY TotalProfit DESC;
GO

-- ----------------------------------------------------------------------------
-- Question 6: Low Margin Household & Office Supply Orders
-- Business Context: Flag transactions for Household or Office Supplies where Unit Cost exceeded $200 but Unit Price was below $300.
-- Concepts Used: WHERE, Comparison & Logical Operators
-- ----------------------------------------------------------------------------
SELECT 
    OrderID,
    ItemType,
    UnitPrice,
    UnitCost,
    (UnitPrice - UnitCost) AS ProfitPerUnit
FROM dbo.Sales
WHERE ItemType IN ('Household', 'Office Supplies')
  AND UnitCost > 200.00 
  AND UnitPrice < 300.00;
GO

-- ----------------------------------------------------------------------------
-- Question 7: Identifying Orders Shipped Late (Ship Date > Order Date + 30 Days)
-- Business Context: Locate orders where shipping took longer than 30 days to flag potential logistics bottlenecks.
-- Concepts Used: WHERE, Date Operators (DATEDIFF), ORDER BY
-- ----------------------------------------------------------------------------
SELECT 
    OrderID,
    Country,
    OrderDate,
    ShipDate,
    DATEDIFF(DAY, OrderDate, ShipDate) AS DaysToShip
FROM dbo.Sales
WHERE DATEDIFF(DAY, OrderDate, ShipDate) > 30
ORDER BY DaysToShip DESC;
GO

-- ----------------------------------------------------------------------------
-- Question 8: Combined Catalog of High Revenue vs High Unit Volume Orders
-- Business Context: Create a consolidated view of top 3 revenue orders and top 3 unit-volume orders.
-- Concepts Used: TOP, SET OPERATORS (UNION ALL)
-- ----------------------------------------------------------------------------
SELECT TOP 3 
    OrderID, 
    ItemType, 
    'High Revenue' AS Category, 
    TotalRevenue AS MetricValue
FROM dbo.Sales
ORDER BY TotalRevenue DESC

UNION ALL

SELECT TOP 3 
    OrderID, 
    ItemType, 
    'High Volume' AS Category, 
    UnitsSold AS MetricValue
FROM dbo.Sales
ORDER BY UnitsSold DESC;
GO

-- ----------------------------------------------------------------------------
-- Question 9: Regional Order Breakdown Using Self-JOIN for Comparison
-- Business Context: Compare orders within the same region to identify order pairs sharing the exact same Order Priority and Sales Channel.
-- Concepts Used: INNER JOIN (Self-Join), Comparison Operators
-- ----------------------------------------------------------------------------
SELECT TOP 10
    A.Region,
    A.OrderID AS Order_A,
    B.OrderID AS Order_B,
    A.SalesChannel,
    A.OrderPriority
FROM dbo.Sales A
INNER JOIN dbo.Sales B 
    ON A.Region = B.Region 
   AND A.SalesChannel = B.SalesChannel 
   AND A.OrderPriority = B.OrderPriority 
   AND A.OrderID < B.OrderID;
GO

-- ----------------------------------------------------------------------------
-- Question 10: Comparative Analysis of Critical (H) vs Low (L) Priority Transactions
-- Business Context: Combine transactions with Critical ('H') and Low ('L') priority for comparative audit report.
-- Concepts Used: WHERE, SET OPERATORS (UNION), ORDER BY
-- ----------------------------------------------------------------------------
SELECT 
    OrderID,
    Country,
    OrderPriority,
    TotalProfit
FROM dbo.Sales
WHERE OrderPriority = 'H' AND TotalProfit > 400000.00

UNION

SELECT 
    OrderID,
    Country,
    OrderPriority,
    TotalProfit
FROM dbo.Sales
WHERE OrderPriority = 'L' AND TotalProfit > 400000.00
ORDER BY TotalProfit DESC;
GO