-- SELECT * FROM dbo.Automobiles; 
-- SELECT * FROM dbo.Customers;
-- SELECT * FROM dbo.Make;
-- SELECT * FROM dbo.Sales;
-- SELECT * FROM dbo.SalesPeople;

-- Objective: Analyze the sales data of this database

---- EXPLORATORY DATA ANALYSIS

-- What brands cost the more on Average
SELECT DISTINCT(make),AVG(listPrice) AS [Average Price]
FROM dbo.Automobiles
GROUP BY make
ORDER BY AVG(listPrice) DESC;

-- What cars cost more on Average
SELECT DISTINCT(model), make ,AVG(listPrice)  AS [Average Price]
FROM dbo.Automobiles
GROUP BY model, make
ORDER BY AVG(listPrice) DESC;

-- Average listPrice per Brand for New and Used cars
SELECT DISTINCT(condition), AVG(listPrice) AS [Average Price]
FROM dbo.Automobiles
GROUP BY condition
ORDER BY AVG(listPrice) DESC;


-- Best SalesPerson in Overall (Those who generated more Revenue vs Revenue per Sale)

-- Overall Revenue
SELECT firstName + ' ' + lastName AS [Sales Person Full Name] , SUM(salePrice) AS [Total Revenue Generated]
FROM dbo.SalesPeople, dbo.Sales
WHERE dbo.SalesPeople.salesPersonId = dbo.Sales.salesPersonId
GROUP BY firstName + ' ' + lastName
ORDER BY SUM(salePrice) DESC;

-- Revenue per Sale - (the AVG function would work here instead the SUM/COUNT, however I chose this approach to show the logical reasoning from the previous step.
SELECT firstName + ' ' + lastName AS [Sales Person Full Name] , SUM(salePrice)/COUNT(salePrice) AS [Revenue per Sale], COUNT(saleId) AS [Number of Sales]
FROM dbo.SalesPeople, dbo.Sales
WHERE dbo.SalesPeople.salesPersonId = dbo.Sales.salesPersonId
GROUP BY firstName + ' ' + lastName
ORDER BY SUM(salePrice)/COUNT(salePrice) DESC;

/* General comment:
- Even though Sandra Baker appears at the TOP sales person in terms of revenue generated for the company, Pauline Hill is doing better in terms of efficiency, 
with an average of $27,962 of Revenue per Sale, with total number of sales of 16 against Sandra's 28 sales.
*/

-- Best SalesPerson in Overall that generated the most Profit SUM(salePrice - dealerPrice)

SELECT firstName, lastName, SUM(salePrice) - SUM(dealerPrice) AS [Total Profit Generated]
FROM dbo.SalesPeople, dbo.Sales, dbo.Automobiles
WHERE dbo.SalesPeople.salesPersonId = dbo.Sales.salesPersonId AND dbo.Automobiles.automobileId = dbo.Sales.automobileId
GROUP BY firstName, lastName
ORDER BY SUM(salePrice) - SUM(dealerPrice) DESC;


-- Assuming that the commission rate is 25% on profit, how much did each sales person get at the end of the period.
SELECT firstName + ' ' + lastName AS [Full Name], SUM(salePrice) - SUM(dealerPrice) AS [Total Profit Generated], (SUM(salePrice) - SUM(dealerPrice)) * 0.25 AS [Total Commission]
FROM dbo.SalesPeople, dbo.Sales, dbo.Automobiles
WHERE dbo.SalesPeople.salesPersonId = dbo.Sales.salesPersonId AND dbo.Automobiles.automobileId = dbo.Sales.automobileId
GROUP BY firstName + ' ' + lastName
ORDER BY SUM(salePrice) - SUM(dealerPrice) DESC;
