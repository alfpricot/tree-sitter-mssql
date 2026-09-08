IF NOT EXISTS (   SELECT *
                    FROM sys.database_principals
                   WHERE name = N'db_executestoredprocedures'
                     AND type = 'R')
    CREATE ROLE [db_executestoredprocedures];
