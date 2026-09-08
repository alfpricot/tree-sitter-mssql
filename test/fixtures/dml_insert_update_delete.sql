INSERT INTO dbo.Customer (Id,
                          Name,
                          Total)
VALUES (1, 'Alice', 100),
       (2, 'Bob', 200);
UPDATE dbo.Customer
   SET Total = Total + 1
 WHERE Id = 1;
DELETE FROM dbo.Customer
 WHERE Id = 2;
