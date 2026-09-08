SELECT name,
       surname
  FROM emp
FOR JSON AUTO;
DROP TABLE IF EXISTS #tabStudent;
DROP TABLE IF EXISTS #tabClass;
GO
CREATE TABLE #tabClass (ClassGuid UNIQUEIDENTIFIER NOT NULL
                            DEFAULT newid(),
                        ClassName NVARCHAR(32) NOT NULL);
CREATE TABLE #tabStudent (StudentGuid UNIQUEIDENTIFIER NOT NULL
                              DEFAULT newid(),
                          StudentName NVARCHAR(32) NOT NULL,
                          ClassGuid UNIQUEIDENTIFIER NULL);
GO
INSERT INTO #tabClass (ClassGuid,
                       ClassName)
VALUES ('DE807673-ECFC-4850-930D-A86F921DE438', 'Algebra Math'),
       ('C55C6819-E744-4797-AC56-FF8A729A7F5C', 'Calculus Math'),
       ('98509D36-A2C8-4A65-A310-E744F5621C83', 'Art Painting');
INSERT INTO #tabStudent (StudentName,
                         ClassGuid)
VALUES ('Alice Apple', 'DE807673-ECFC-4850-930D-A86F921DE438'),
       ('Alice Apple', 'C55C6819-E744-4797-AC56-FF8A729A7F5C'),
       ('Betty Boot', 'C55C6819-E744-4797-AC56-FF8A729A7F5C'),
       ('Betty Boot', '98509D36-A2C8-4A65-A310-E744F5621C83'),
       ('Carla Cap', null);
GO
SELECT      c.ClassName,
            s.StudentName
  FROM      #tabClass AS c
 RIGHT JOIN #tabStudent AS s
    ON s.ClassGuid = c.ClassGuid
 ORDER BY c.ClassName,
          s.StudentName
FOR JSON AUTO;
GO
DROP TABLE IF EXISTS #tabStudent;
DROP TABLE IF EXISTS #tabClass;
GO
SELECT TOP 5 BusinessEntityID AS Id,
             FirstName,
             LastName,
             Title AS [Info.Title],
             MiddleName AS [Info.MiddleName]
  FROM Person.Person
FOR JSON PATH;
SELECT      TOP 2 H.SalesOrderNumber AS [Order.Number],
                  H.OrderDate AS [Order.Date],
                  D.UnitPrice AS [Product.Price],
                  D.OrderQty AS [Product.Quantity]
  FROM      Sales.SalesOrderHeader AS H
 INNER JOIN Sales.SalesOrderDetail AS D
    ON H.SalesOrderID = D.SalesOrderID
FOR JSON PATH;
