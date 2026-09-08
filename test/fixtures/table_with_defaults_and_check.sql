IF NOT EXISTS (   SELECT *
                    FROM sys.objects
                   WHERE object_id = OBJECT_ID(N'[dbo].[example_table]')
                     AND type in ( N'U' ))
BEGIN
    CREATE TABLE [dbo].[example_table] ([key1] [dbo].[key_type] NOT NULL,
                                        [code1] [dbo].[code_type] NOT NULL,
                                        [code2] [dbo].[code_type] NOT NULL,
                                        [value1] [dbo].[numeric_type] NOT NULL,
                                        [flag1] [dbo].[flag_type] NOT NULL,
                                        [created_by] [dbo].[username_type] NOT NULL,
                                        [created_date] [dbo].[date_type] NOT NULL,
                                        [row_id] [dbo].[row_id_type] NOT NULL,
                                        CONSTRAINT [pk_example_table]
                                            PRIMARY KEY NONCLUSTERED ([row_id] ASC, [key1] ASC)
                                            WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF,
                                                  ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]) ON [PRIMARY];
END;
SET ANSI_PADDING ON;
IF NOT EXISTS (   SELECT *
                    FROM sys.indexes
                   WHERE object_id = OBJECT_ID(N'[dbo].[example_table]')
                     AND name      = N'ix_example_table_code1')
    CREATE CLUSTERED INDEX [ix_example_table_code1]
    ON [dbo].[example_table] ([code1] ASC, [code2] ASC, [key1] ASC)
    WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF,
          ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
    ON [PRIMARY];
IF NOT EXISTS (   SELECT *
                    FROM sys.objects
                   WHERE object_id = OBJECT_ID(N'[dbo].[df_example_table_key1]')
                     AND type      = 'D')
BEGIN
    ALTER TABLE [dbo].[example_table]
    ADD CONSTRAINT [df_example_table_key1]
        DEFAULT (rtrim(CONVERT([nvarchar](8), context_info(), 0))) FOR [key1];
END;
IF NOT EXISTS (   SELECT *
                    FROM sys.objects
                   WHERE object_id = OBJECT_ID(N'[dbo].[df_example_table_flag1]')
                     AND type      = 'D')
BEGIN
    ALTER TABLE [dbo].[example_table]
    ADD CONSTRAINT [df_example_table_flag1]
        DEFAULT ((0)) FOR [flag1];
END;
IF NOT EXISTS (   SELECT *
                    FROM sys.objects
                   WHERE object_id = OBJECT_ID(N'[dbo].[df_example_table_created_by]')
                     AND type      = 'D')
BEGIN
    ALTER TABLE [dbo].[example_table]
    ADD CONSTRAINT [df_example_table_created_by]
        DEFAULT (suser_sname()) FOR [created_by];
END;
IF NOT EXISTS (   SELECT *
                    FROM sys.objects
                   WHERE object_id = OBJECT_ID(N'[dbo].[df_example_table_created_date]')
                     AND type      = 'D')
BEGIN
    ALTER TABLE [dbo].[example_table]
    ADD CONSTRAINT [df_example_table_created_date]
        DEFAULT (getdate()) FOR [created_date];
END;
IF NOT EXISTS (   SELECT *
                    FROM sys.objects
                   WHERE object_id = OBJECT_ID(N'[dbo].[df_example_table_row_id]')
                     AND type      = 'D')
BEGIN
    ALTER TABLE [dbo].[example_table]
    ADD CONSTRAINT [df_example_table_row_id]
        DEFAULT (newid()) FOR [row_id];
END;
IF NOT EXISTS (   SELECT *
                    FROM sys.check_constraints
                   WHERE object_id        = OBJECT_ID(N'[dbo].[ck_example_table_flag1]')
                     AND parent_object_id = OBJECT_ID(N'[dbo].[example_table]'))
    ALTER TABLE [dbo].[example_table] WITH CHECK
    ADD CONSTRAINT [ck_example_table_flag1] CHECK ((  [flag1] = (1)
                                                  OR  [flag1] = (0)));
IF EXISTS (   SELECT *
                FROM sys.check_constraints
               WHERE object_id        = OBJECT_ID(N'[dbo].[ck_example_table_flag1]')
                 AND parent_object_id = OBJECT_ID(N'[dbo].[example_table]'))
    ALTER TABLE [dbo].[example_table] CHECK CONSTRAINT [ck_example_table_flag1];
