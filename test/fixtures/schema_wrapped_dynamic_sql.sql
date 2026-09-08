IF NOT EXISTS (SELECT * FROM sys.schemas WHERE name = N'frm')
    EXEC sys.sp_executesql N'CREATE SCHEMA [frm]';

