SELECT GREATEST('6.62', 3.1415, N'7') AS GreatestVal;
GO

SELECT GREATEST('Glacier', N'Joshua Tree', 'Mount Rainier') AS GreatestString;
GO

SELECT      P.Name,
            P.SellStartDate,
            P.DiscontinuedDate,
            PM.ModifiedDate AS ModelModifiedDate,
            GREATEST(P.SellStartDate, P.DiscontinuedDate, PM.ModifiedDate) AS LatestDate
  FROM      SalesLT.Product AS P
 INNER JOIN SalesLT.ProductModel AS PM
    ON P.ProductModelID = PM.ProductModelID
 WHERE      GREATEST(P.SellStartDate, P.DiscontinuedDate, PM.ModifiedDate) >= '2007-01-01'
   AND      P.SellStartDate                                                     >= '2007-01-01'
   AND      P.Name LIKE 'Touring %'
 ORDER BY P.Name;

CREATE TABLE dbo.Studies (VarX VARCHAR(10) NOT NULL,
                          Correlation DECIMAL(4, 3) NULL);

INSERT INTO dbo.Studies
VALUES ('Var1', 0.2),
       ('Var2', 0.825),
       ('Var3', 0.61);
GO

DECLARE @PredictionA DECIMAL(2, 1) = 0.7;
DECLARE @PredictionB DECIMAL(3, 1) = 0.65;

SELECT VarX,
       Correlation
  FROM dbo.Studies
 WHERE Correlation > GREATEST(@PredictionA, @PredictionB);
GO

DECLARE @VarX DECIMAL(4, 3) = 0.59;

SELECT VarX,
       Correlation,
       GREATEST(Correlation, 0, @VarX) AS GreatestVar
  FROM dbo.Studies;
GO

SELECT LEAST('6.62', 3.1415, N'7') AS LeastVal;
GO

SELECT LEAST('Glacier', N'Joshua Tree', 'Mount Rainier') AS LeastString;
GO

SELECT      P.Name,
            P.SellStartDate,
            P.DiscontinuedDate,
            PM.ModifiedDate AS ModelModifiedDate,
            LEAST(P.SellStartDate, P.DiscontinuedDate, PM.ModifiedDate) AS EarliestDate
  FROM      SalesLT.Product AS P
 INNER JOIN SalesLT.ProductModel AS PM
    ON P.ProductModelID = PM.ProductModelID
 WHERE      LEAST(P.SellStartDate, P.DiscontinuedDate, PM.ModifiedDate) >= '2007-01-01'
   AND      P.SellStartDate                                             >= '2007-01-01'
   AND      P.Name LIKE 'Touring %'
 ORDER BY P.Name;

DECLARE @PredictionA DECIMAL(2, 1) = 0.7;
DECLARE @PredictionB DECIMAL(3, 1) = 0.65;

SELECT VarX,
       Correlation
  FROM dbo.Studies
 WHERE Correlation < LEAST(@PredictionA, @PredictionB);
GO

DECLARE @VarX DECIMAL(4, 3) = 0.59;

SELECT VarX,
       Correlation,
       LEAST(Correlation, 1.0, @VarX) AS LeastVar
  FROM dbo.Studies;
GO
