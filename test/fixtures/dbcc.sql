DBCC CHECKDB WITH NO_INFOMSGS;

DECLARE @dbcc_stmt sysname;
SET @dbcc_stmt = 'CHECKDB';
DBCC HELP(@dbcc_stmt);
GO
