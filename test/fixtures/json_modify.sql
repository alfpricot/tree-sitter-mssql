DECLARE @info NVARCHAR(100) = '{"name":"John","skills":["C#","SQL"]}';
PRINT @info;
SET @info = JSON_MODIFY(@info, '$.name', 'Mike');
PRINT @info;
SET @info = JSON_MODIFY(@info, '$.surname', 'Smith');
PRINT @info;
SET @info = JSON_MODIFY(@info, 'strict $.name', NULL);
PRINT @info;
SET @info = JSON_MODIFY(@info, '$.name', NULL);
PRINT @info;
SET @info = JSON_MODIFY(@info, 'append $.skills', 'Azure');
PRINT @info;
DECLARE @product NVARCHAR(100) = '{"price":49.99}';
PRINT @product;
SET @product
    = JSON_MODIFY(
          JSON_MODIFY(@product, '$.Price', CAST(JSON_VALUE(@product, '$.price') AS NUMERIC(4, 2))), '$.price', NULL);
PRINT @product;
UPDATE Employee
   SET jsonCol = JSON_MODIFY(jsonCol, '$.info.address.town', 'London')
 WHERE EmployeeID = 17;
