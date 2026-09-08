-- dep002_readtext_triggers
READTEXT dbo.Customer.Notes @ptrval 0 100;
GO

-- dep002_writetext_triggers
WRITETEXT dbo.Customer.Notes @ptrval 'hello';
GO

-- dep002_updatetext_triggers
UPDATETEXT dbo.Customer.Notes @ptrval @off @len 'hi';
GO

-- dep006_setuser_triggers
SETUSER 'dbo';
GO

-- dep007_backup_to_tape_triggers
BACKUP DATABASE MyDb TO TAPE = '\\.\tape0';
GO

-- dep007_backup_to_disk_is_clean
BACKUP DATABASE MyDb TO DISK = 'MyDb.bak';
GO

-- dep008_backup_with_password_triggers
BACKUP DATABASE MyDb TO DISK = 'MyDb.bak' WITH PASSWORD = 'secret';
GO

-- dep008_backup_without_password_is_clean
BACKUP DATABASE MyDb TO DISK = 'MyDb.bak' WITH COMPRESSION;
GO

-- dep020_numbered_procedure_triggers
CREATE PROC MyProc;1 AS SELECT 1;
GO
