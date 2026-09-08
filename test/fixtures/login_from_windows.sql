IF NOT EXISTS (   SELECT *
                    FROM sys.server_principals
                   WHERE name = N'CORP\adminuser')
    CREATE LOGIN [CORP\adminuser] FROM WINDOWS
    WITH DEFAULT_DATABASE = [master], DEFAULT_LANGUAGE = [us_english];
ALTER SERVER ROLE [sysadmin] ADD MEMBER [CORP\adminuser];
