CREATE TRIGGER dbo.tr_test ON dbo.Target FOR INSERT AS SELECT Id FROM inserted;
GO

ALTER TRIGGER dbo.tr_test ON dbo.Target FOR INSERT AS BEGIN SELECT Id FROM inserted; END;
GO
