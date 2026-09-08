USE AdventureWorks2022;
GO
EXECUTE sp_rename 'Sales.SalesTerritory', 'SalesTerr';
GO
EXECUTE sp_rename 'Sales.SalesTerritory.TerritoryID', 'TerrID', 'COLUMN';
GO
EXECUTE sp_rename N'Purchasing.ProductVendor.IX_ProductVendor_VendorID',
                  N'IX_VendorID',
                  N'INDEX';
GO
EXECUTE sp_rename N'Phone', N'Telephone', N'USERDATATYPE';
GO
SELECT name,
       SCHEMA_NAME(schema_id) AS schema_name,
       type_desc
  FROM sys.objects
 WHERE parent_object_id = (OBJECT_ID('HumanResources.Employee'))
   AND type IN ( 'C', 'F', 'PK' );
GO
EXECUTE sp_rename 'HumanResources.PK_Employee_BusinessEntityID',
                  'PK_EmployeeID';
GO
EXECUTE sp_rename 'HumanResources.CK_Employee_BirthDate', 'CK_BirthDate';
GO
EXECUTE sp_rename 'HumanResources.FK_Employee_Person_BusinessEntityID',
                  'FK_EmployeeID';
EXECUTE sp_rename 'Person.Person.ContactMail1',
                  'NewContact',
                  'Statistics';
CREATE TABLE table1 (c1 INT,
                     c2 INT);
EXECUTE sp_rename 'table1.c1', 'col1', 'COLUMN';
GO
EXECUTE sp_rename @objname = 'dbo.table1',
                  @newname = 'table2',
                  @objtype = 'OBJECT';
