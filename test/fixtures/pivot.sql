USE AdventureWorks2022;
GO
SELECT 'AverageCost' AS CostSortedByProductionDays,
       [0],
       [1],
       [2],
       [3],
       [4]
  FROM (   SELECT DaysToManufacture,
                  StandardCost
             FROM Production.Product) AS SourceTable
  PIVOT (   AVG(StandardCost)
            FOR DaysToManufacture IN ([0], [1], [2], [3], [4])) AS PivotTable;
USE AdventureWorks2022;
GO
SELECT VendorID,
       [250] AS Emp1,
       [251] AS Emp2,
       [256] AS Emp3,
       [257] AS Emp4,
       [260] AS Emp5
  FROM (   SELECT PurchaseOrderID,
                  EmployeeID,
                  VendorID
             FROM Purchasing.PurchaseOrderHeader) AS p
  PIVOT (   COUNT(PurchaseOrderID)
              FOR EmployeeID IN ([250], [251], [256], [257], [260])) AS pvt
 ORDER BY pvt.VendorID;
