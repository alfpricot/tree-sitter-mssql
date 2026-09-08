SELECT c.Id
  FROM dbo.Customer AS c
  JOIN dbo.Orders AS o
    ON c.Id = o.CustomerId
 WHERE c.Created > CURRENT_TIMESTAMP;
GO
