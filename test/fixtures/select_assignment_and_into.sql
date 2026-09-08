DECLARE @x INT;
SELECT @x = Id FROM dbo.Customer;
GO

SELECT Id INTO #t FROM dbo.Customer;
GO
