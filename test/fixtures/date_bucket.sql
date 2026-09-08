DECLARE @date AS DATETIME2 = '2020-04-30 21:21:21';

SELECT 'Week',
       DATE_BUCKET(WEEK, 1, @date)
UNION ALL
SELECT 'Day',
       DATE_BUCKET(DAY, 1, @date)
UNION ALL
SELECT 'Hour',
       DATE_BUCKET(HOUR, 1, @date)
UNION ALL
SELECT 'Minutes',
       DATE_BUCKET(MINUTE, 1, @date)
UNION ALL
SELECT 'Seconds',
       DATE_BUCKET(SECOND, 1, @date);

DECLARE @days     AS INT       = 365,
        @datetime AS DATETIME2 = '2000-01-01 01:01:01.1110000';

SELECT DATE_BUCKET(DAY, @days, @datetime);

SELECT DATE_BUCKET(WEEK, 1, CAST(ShipDate AS DATETIME2)) AS ShippedDateBucket,
       SUM(OrderQuantity) AS SumOrderQuantity,
       SUM(UnitPrice) AS SumUnitPrice
  FROM dbo.FactInternetSales AS FIS
 WHERE ShipDate BETWEEN '2011-01-03 00:00:00.000' AND '2011-02-28 00:00:00.000'
 GROUP BY DATE_BUCKET(WEEK, 1, CAST(ShipDate AS DATETIME2))
 ORDER BY ShippedDateBucket;

SELECT DATE_BUCKET(
           WEEK,
       (SELECT TOP 1 CustomerKey FROM dbo.DimCustomer WHERE GeographyKey > 100),
       (SELECT MAX(OrderDate)FROM dbo.FactInternetSales));

SELECT DATE_BUCKET(WEEK, (10 / 2), SYSDATETIME());

SELECT DISTINCT DATE_BUCKET(DAY, 30, CAST([ShipDate] AS DATETIME2)) AS DateBucket,
                FIRST_VALUE([SalesOrderNumber]) OVER (ORDER BY DATE_BUCKET(DAY, 30, CAST([ShipDate] AS DATETIME2))) AS First_Value_In_Bucket,
                LAST_VALUE([SalesOrderNumber]) OVER (ORDER BY DATE_BUCKET(DAY, 30, CAST([ShipDate] AS DATETIME2))) AS Last_Value_In_Bucket
  FROM [dbo].[FactInternetSales]
 WHERE ShipDate BETWEEN '2011-01-03 00:00:00.000' AND '2011-02-28 00:00:00.000'
 ORDER BY DateBucket;
GO

DECLARE @date AS DATETIME2 = '2020-06-15 21:22:11';
DECLARE @origin AS DATETIME2 = '2019-01-01 00:00:00';

SELECT DATE_BUCKET(HOUR, 2, @date, @origin);
