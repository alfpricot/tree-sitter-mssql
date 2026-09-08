-- ei023_current_of_non_updatable_cursor_triggers
DECLARE cur CURSOR FOR SELECT Id FROM dbo.Customer;
UPDATE dbo.Customer
   SET Name = 'x'
 WHERE CURRENT OF cur;
GO

-- ei023_current_of_updatable_cursor_is_clean
DECLARE cur CURSOR FOR SELECT Id FROM dbo.Customer FOR UPDATE;
UPDATE dbo.Customer
   SET Name = 'x'
 WHERE CURRENT OF cur;
GO

-- ei023_delete_current_of_non_updatable_cursor_triggers
DECLARE cur CURSOR FOR SELECT Id FROM dbo.Customer;
DELETE FROM dbo.Customer
 WHERE CURRENT OF cur;
GO

-- ei033_dynamic_sql_with_execute_as_is_clean
EXECUTE ('SELECT 1') AS USER = 'someuser';
GO
