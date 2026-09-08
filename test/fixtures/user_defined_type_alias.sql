IF NOT EXISTS (   SELECT *
                    FROM sys.types AS st
                    JOIN sys.schemas AS ss
                      ON st.schema_id = ss.schema_id
                   WHERE st.name = N'RevisionIDType'
                     AND ss.name = N'dbo')
    CREATE TYPE [dbo].[RevisionIDType] FROM [nvarchar](22) NULL;
