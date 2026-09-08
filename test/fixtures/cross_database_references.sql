SELECT OtherDb.dbo.SomeFunc(1);
GO
SELECT Id FROM OtherDb.dbo.Customer;
GO
UPDATE OtherDb.dbo.Customer SET Name = 'x' WHERE Id = 1;
GO
INSERT INTO OtherDb.dbo.Customer (Id) VALUES (1);
GO
