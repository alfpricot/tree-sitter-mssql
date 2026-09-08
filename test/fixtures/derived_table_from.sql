SELECT t.Id,
       t.Total
  FROM (SELECT Id, SUM(Amount) AS Total FROM dbo.Orders GROUP BY Id) AS t
 WHERE t.Total > 100;
