USE AdventureWorks2025;
GO
SELECT DepartmentID,
       Name,
       GroupName
  FROM HumanResources.Department
 ORDER BY DepartmentID;
SELECT DepartmentID,
       Name,
       GroupName
  FROM HumanResources.Department
 ORDER BY DepartmentID OFFSET 5 ROWS;
SELECT DepartmentID,
       Name,
       GroupName
  FROM HumanResources.Department
 ORDER BY DepartmentID OFFSET 0 ROWS FETCH NEXT 10 ROWS ONLY;
USE AdventureWorks2025;
GO
CREATE TABLE dbo.AppSettings (AppSettingID INT NOT NULL,
                              PageSize INT NOT NULL);
INSERT INTO dbo.AppSettings
VALUES (1, 10);
DECLARE @StartingRowNumber AS TINYINT = 1;
SELECT DepartmentID,
       Name,
       GroupName
  FROM HumanResources.Department
 ORDER BY DepartmentID ASC OFFSET @StartingRowNumber ROWS FETCH NEXT (SELECT PageSize FROM dbo.AppSettings WHERE AppSettingID = 1) ROWS ONLY;
