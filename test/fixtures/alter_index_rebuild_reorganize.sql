ALTER INDEX ALL ON dbo.Customer REBUILD;
GO

ALTER INDEX ALL ON dbo.Customer REORGANIZE;
GO

ALTER INDEX ix_Customer_Name ON dbo.Customer RESUME;
GO

ALTER INDEX ix_Customer_Name ON dbo.Customer RESUME WITH (MAX_DURATION = 60 MINUTES);
GO

ALTER INDEX ix_Customer_Name ON dbo.Customer PAUSE;
GO

ALTER INDEX ix_Customer_Name ON dbo.Customer ABORT;
GO
