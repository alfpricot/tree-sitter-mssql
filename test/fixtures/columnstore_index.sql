CREATE TABLE dbo.SimpleTable (ProductKey INT NOT NULL,
                              OrderDateKey INT NOT NULL,
                              DueDateKey INT NOT NULL,
                              ShipDateKey INT NOT NULL);
GO

CREATE CLUSTERED COLUMNSTORE INDEX cci_Simple ON dbo.SimpleTable;
GO

CREATE CLUSTERED INDEX cl_simple ON dbo.SimpleTable (ProductKey);
GO

CREATE NONCLUSTERED COLUMNSTORE INDEX csindx_simple
ON dbo.SimpleTable (OrderDateKey, DueDateKey, ShipDateKey);
GO

CREATE NONCLUSTERED COLUMNSTORE INDEX csindx_simple
ON SimpleTable (OrderDateKey, DueDateKey, ShipDateKey)
WITH (DROP_EXISTING = ON, MAXDOP = 2)
ON "DEFAULT";
GO

IF EXISTS (   SELECT name
                FROM sys.indexes
               WHERE name      = N'FIBillOfMaterialsWithEndDate'
                 AND object_id = OBJECT_ID(N'Production.BillOfMaterials'))
    DROP INDEX FIBillOfMaterialsWithEndDate ON Production.BillOfMaterials;
GO

CREATE NONCLUSTERED COLUMNSTORE INDEX "FIBillOfMaterialsWithEndDate"
ON Production.BillOfMaterials (ComponentID, StartDate)
WHERE EndDate IS NOT NULL;
