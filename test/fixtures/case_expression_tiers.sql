SELECT Id,
       CASE
            WHEN Total > 100 THEN 'high'
            WHEN Total > 10 THEN 'medium'
            ELSE 'low' END AS Tier
  FROM dbo.Orders;
