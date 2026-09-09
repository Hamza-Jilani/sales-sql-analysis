# Global Sales & Profitability Analysis (SQL Server & SSMS)

An end-to-end SQL Data Analysis project leveraging Microsoft SQL Server and SQL Server Management Studio (SSMS). This project demonstrates data ingestion, schema design, staging transformations, and business intelligence queries on a dataset containing global sales and order fulfillment records.

---

## 📌 Table of Contents
- [Project Overview](#-project-overview)
- [Dataset Summary](#-dataset-summary)
- [Database & Table Schema](#-database--table-schema)
- [Data Ingestion Workflow](#-data-ingestion-workflow)
- [10 Business Questions & SQL Solutions](#-10-business-questions--sql-solutions)
- [How to Run This Project](#-how-to-run-this-project)
- [Repository Structure](#-repository-structure)

---

## 📌 Project Overview
The objective of this project is to analyze transactional sales performance across various global regions, sales channels, product categories, and order priorities. Key analytical goals include:
1. Identifying high-revenue and high-margin product lines.
2. Evaluating sales channel performance (**Online** vs. **Offline**).
3. Analyzing order fulfillment efficiency and shipping delays.
4. Structuring clean T-SQL queries for exploratory data analysis (EDA).

---

## 📊 Dataset Summary
* **Source Files:** `Sales_Project.csv` / `sales.xlsx`
* **Total Rows:** 100 Order Records
* **Attributes:** 14 Dimensions and Metrics:
  - `Region` (VARCHAR)
  - `Country` (VARCHAR)
  - `Item Type` (VARCHAR)
  - `Sales Channel` (VARCHAR)
  - `Order Priority` (CHAR)
  - `Order Date` (DATE)
  - `Order ID` (BIGINT)
  - `Ship Date` (DATE)
  - `Units Sold` (INT)
  - `Unit Price` (DECIMAL)
  - `Unit Cost` (DECIMAL)
  - `Total Revenue` (DECIMAL)
  - `Total Cost` (DECIMAL)
  - `Total Profit` (DECIMAL)

 ---

## 🗄️ Database & Table Schema

The production-ready SQL table `Sales` is defined with appropriate SQL data types, primary key constraint, and monetary precision:

```sql
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


## Data Ingestion Workflow

BULK INSERT dbo.SalesStaging
FROM 'C:\Temp\Sales_Project.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    TABLOCK
);

---

### Section 4: 10 Business Questions & SQL Solutions



## 🔍 10 Business Questions & SQL Solutions

The queries below use core T-SQL concepts: `SELECT`, `WHERE`, `ORDER BY`, `TOP`, `DISTINCT`, `JOINS`, `SET OPERATORS (UNION)`, and logical/comparison operators.

```sql
-- ============================================================================
-- SQL Portfolio Project: Global Sales & Profitability Analysis
-- Dataset: Sales_Project (100 Records)
-- Concepts: SELECT, WHERE, ORDER BY, TOP, DISTINCT, JOINS, SET OPERATORS, OPERATORS
-- ============================================================================

USE SalesDataDB;
GO

-- ----------------------------------------------------------------------------
-- Question 1: Top 5 Highest Revenue Orders
-- Business Context: Identify individual transactions generating the highest gross revenue.
-- Finding: Bulk orders of **Household** goods and Office Supplies drive the highest top-line revenue, led by a high-value      order in Honduras ($5.99M) and Myanmar ($5.51M). 
-- Business Impact: High-density enterprise consumer categories generate the largest deal sizes, making them primary targets for institutional B2B sales drives.
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
-- Business Context: Find critical (Priority 'H') online transactions in Europe to monitor order fulfillment.
-- Finding: Critical priority ('H') online sales in Europe—such as a $1.37M profit order in Romania for Cosmetics—show          strong consumer demand in high-tier retail product lines.
-- Business Impact: High-priority orders require streamlined local fulfillment centers in Central and Eastern Europe to         protect high-margin delivery SLAs.
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
-- Business Context: List all unique product categories currently sold in Sub-Saharan Africa.
-- Finding: Sub-Saharan Africa demonstrates complete product category adoption, actively purchasing across all 12 distinct      product categories (from Staples like Baby Food to High-Margin items like Cosmetics).
-- Business Impact: The market requires a diversified catalog strategy rather than a restricted single-category entry plan.
-- ----------------------------------------------------------------------------
SELECT DISTINCT 
    ItemType
FROM dbo.Sales
WHERE Region = 'Sub-Saharan Africa'
ORDER BY ItemType ASC;
GO

-- ----------------------------------------------------------------------------
-- Question 4: Large Volume Orders (5,000 to 10,000 Units Sold)
-- Business Context: Filter high bulk volume orders to assess supply chain distribution.
-- Finding: 55% of all orders (55 out of 100) represent wholesale volume transactions falling between 5,000 and 10,000 units    sold.
-- Business Impact: The core distribution engine operates on large bulk logistics; optimizing container shipment costs          directly impacts bottom-line performance.
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
-- Finding: Asia dominates high-margin transactions, capturing 6 out of the 7 mega-profit orders (> $500,000 profit), led by    Myanmar ($1.36M profit) and Sri Lanka ($1.20M profit).
-- Business Impact: Asian operations yield significantly higher returns per order, justifying increased marketing and           operational investment in APAC logistics. 
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
-- Business Context: Flag transactions for Household or Office Supplies where Unit Cost > $200 and Unit Price < $300.
-- Finding: Zero orders in the dataset exhibited squeezed margins (where unit cost exceeded $200 while pricing stayed below     $300) for Household or Office Supplies.
-- Business Impact: Product pricing controls and wholesale markups are functioning efficiently without margin erosion on        premium items.
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
-- Business Context: Locate orders where shipping took longer than 30 days to detect potential bottlenecks.
-- Finding: 37% of all shipments experienced significant delays exceeding 30 days between order date and ship date, peaking     at 50 days for orders in the Democratic Republic of the Congo.
-- Business Impact: Severe supply chain lag affects over a third of transactions, signaling an urgent need to re-evaluate       regional carrier contracts and fulfillment workflows.
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
-- Business Context: Consolidate top 3 revenue orders and top 3 unit-volume orders into a single audit view.
-- Finding: High volume (units sold) does not strictly correlate with high revenue; high-priced item categories generate        greater gross metric values even at modest unit volumes.
-- Business Impact: Sales incentives should prioritize margin and total revenue contribution over raw unit sales volume.
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
-- Business Context: Compare orders within the same region matching priority and sales channel.
-- Finding: Multiple orders within the same region frequently share identical priority and sales channel configurations         (e.g., matching High-Priority Offline orders across Latin American territories).
-- Business Impact: Regional warehouses can batch-process matching order types to streamline pick-and-pack warehouse            logistics.
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
-- Business Context: Combine transactions with High ('H') and Low ('L') priority for comparative audit report.
-- Finding: Low-priority ('L') transactions frequently match or exceed the net profit totals of Critical-priority ('H')         orders when bulk volume is high.
-- Business Impact: Order priority reflects delivery urgency rather than deal value; warehouse dispatch operations must         balance speed with total transaction profit value.
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


## 🚀 How to Run This Project

### Prerequisites
* **SQL Server** (2017+ / Express / Developer Edition)
* **SQL Server Management Studio (SSMS 18/19/20)**

### Execution Steps
1. Clone this repository:
   ```bash
   git clone [https://github.com/your-username/sales-sql-analysis.git](https://github.com/your-username/sales-sql-analysis.git)
   ```
2. Open SSMS and execute the database & table creation script (`schema_setup.sql`).
3. Execute `business_analysis.sql` to run all 10 analytical business queries.

---

## 📁 Repository Structure

```text
.
├── Sales_Project.csv          # Raw CSV Dataset
├── sales.xlsx                 # Raw Excel Dataset
├── schema_setup.sql        # Database creation, schema & BULK INSERT
├── business_analysis.sql   # 10 Business Analysis SQL Queries
└── README.md                  # Complete Project Documentation
```
```
