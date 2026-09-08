IF NOT EXISTS (   SELECT *
                    FROM sys.synonyms
                   WHERE name      = N'Filters'
                     AND schema_id = SCHEMA_ID(N'frm'))
    CREATE SYNONYM [frm].[Filters]
    FOR [FormsDB].[dbo].[Filters];
