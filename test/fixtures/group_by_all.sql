SELECT Region, SUM(Sales) FROM dbo.Sales GROUP BY ALL Region;
GO

SELECT Region, SUM(Sales) FROM dbo.Sales GROUP BY Region;
GO
