IF NOT EXISTS (SELECT * FROM sys.routes WHERE name = N'AutoCreatedLocal')
    CREATE ROUTE [AutoCreatedLocal]
    WITH
    ADDRESS = N'LOCAL';
