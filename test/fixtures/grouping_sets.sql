CREATE TABLE Sales (Region VARCHAR(50),
                    Territory VARCHAR(50),
                    Sales INT);
GO

INSERT INTO Sales
VALUES (N'Canada', N'Alberta', 100);
INSERT INTO Sales
VALUES (N'Canada', N'British Columbia', 200);
INSERT INTO Sales
VALUES (N'Canada', N'British Columbia', 300);
INSERT INTO Sales
VALUES (N'United States', N'Montana', 100);

SELECT Region,
       Territory,
       SUM(Sales) AS TotalSales
  FROM Sales
 GROUP BY ROLLUP(Region, Territory);

SELECT Region,
       Territory,
       SUM(Sales) AS TotalSales
  FROM Sales
 GROUP BY CUBE(Region, Territory);

SELECT Region,
       Territory,
       SUM(Sales) AS TotalSales
  FROM Sales
 GROUP BY GROUPING SETS(ROLLUP(Region, Territory), CUBE(Region, Territory));

SELECT Region,
       SUM(Sales) AS TotalSales
  FROM Sales
 GROUP BY GROUPING SETS(Region, ());
