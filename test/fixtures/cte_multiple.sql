WITH Recent
  AS (SELECT Id,
             Name
        FROM dbo.Customer
       WHERE CreatedOn > '2024-01-01'),
     LongerName
  AS (SELECT Id,
             Total
        FROM dbo.Orders)
SELECT Recent.Name,
       LongerName.Total
  FROM Recent
  JOIN LongerName
    ON Recent.Id = LongerName.Id;
