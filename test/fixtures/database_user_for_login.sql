IF NOT EXISTS (SELECT * FROM sys.database_principals WHERE name = N'user2')
    CREATE USER [user2] FOR LOGIN [login2] WITH DEFAULT_SCHEMA = [dbo];
