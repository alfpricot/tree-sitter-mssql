SELECT CustomerId,
       COUNT(*) AS OrderCount
  FROM dbo.Orders
 GROUP BY CustomerId
HAVING COUNT(*) > 5
 ORDER BY OrderCount DESC;
