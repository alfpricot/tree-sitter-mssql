SELECT object_id,
       COUNT(*) OVER (ORDER BY object_id ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS [preceding],
       COUNT(*) OVER (ORDER BY object_id ROWS BETWEEN 2 PRECEDING AND 2 FOLLOWING) AS [central],
       COUNT(*) OVER (ORDER BY object_id ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING) AS [following]
  FROM sys.objects
 ORDER BY object_id ASC;

SELECT BusinessEntityID,
       TerritoryID,
       CONVERT(VARCHAR(20), SalesYTD, 1) AS SalesYTD,
       DATEPART(yy, ModifiedDate) AS SalesYear,
       CONVERT(VARCHAR(20),
               SUM(SalesYTD) OVER (PARTITION BY TerritoryID
                                       ORDER BY DATEPART(yy, ModifiedDate)
                                        ROWS BETWEEN CURRENT ROW AND 1 FOLLOWING),
               1) AS CumulativeTotal
  FROM Sales.SalesPerson
 WHERE TerritoryID IS NULL
    OR TerritoryID < 5;

SELECT BusinessEntityID,
       TerritoryID,
       CONVERT(VARCHAR(20), SalesYTD, 1) AS SalesYTD,
       DATEPART(yy, ModifiedDate) AS SalesYear,
       CONVERT(VARCHAR(20),
               SUM(SalesYTD) OVER (PARTITION BY TerritoryID
                                       ORDER BY DATEPART(yy, ModifiedDate)
                                        ROWS UNBOUNDED PRECEDING),
               1) AS CumulativeTotal
  FROM Sales.SalesPerson
 WHERE TerritoryID IS NULL
    OR TerritoryID < 5;
