SELECT SERVERPROPERTY('ProductVersion') AS ProductVersion,
       SERVERPROPERTY('Edition') AS Edition,
       OBJECTPROPERTY(OBJECT_ID(N'dbo.Customer'), 'IsTable') AS IsTable,
       OBJECTPROPERTYEX(OBJECT_ID(N'dbo.Customer'), 'BaseType') AS BaseType,
       DATABASEPROPERTYEX(DB_NAME(), 'Collation') AS Collation,
       COLUMNPROPERTY(OBJECT_ID(N'dbo.Customer'), 'Id', 'AllowsNull') AS AllowsNull;
