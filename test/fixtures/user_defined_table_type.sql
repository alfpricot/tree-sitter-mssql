IF NOT EXISTS (   SELECT *
                    FROM sys.types AS st
                    JOIN sys.schemas AS ss
                      ON st.schema_id = ss.schema_id
                   WHERE st.name = N'PortalItemSearchCriteriaTableType'
                     AND ss.name = N'dbo')
    CREATE TYPE [dbo].[PortalItemSearchCriteriaTableType] AS TABLE ([criterion] [dbo].[CriterionType] NULL,
                                                                    [type] [dbo].[CriterionTypeType] NULL);
