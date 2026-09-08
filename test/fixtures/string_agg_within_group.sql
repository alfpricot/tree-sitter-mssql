USE AdventureWorks2022;
GO

SELECT      TOP 10 City,
                   STRING_AGG(CONVERT(NVARCHAR(MAX), EmailAddress), ';') WITHIN GROUP(ORDER BY EmailAddress ASC) AS Emails
  FROM      Person.BusinessEntityAddress AS BEA
 INNER JOIN Person.Address AS A
    ON BEA.AddressID        = A.AddressID
 INNER JOIN Person.EmailAddress AS EA
    ON BEA.BusinessEntityID = EA.BusinessEntityID
 GROUP BY City;
GO
