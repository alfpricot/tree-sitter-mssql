SET ANSI_PADDING ON;

IF NOT EXISTS (   SELECT *
                    FROM sys.indexes
                   WHERE object_id = OBJECT_ID(N'[dbo].[ABDataServices]')
                     AND name      = N'PK_ABDataServices')
    ALTER TABLE [dbo].[ABDataServices]
    ADD CONSTRAINT [PK_ABDataServices]
        PRIMARY KEY CLUSTERED ([ProjectId] ASC, [Id] ASC, [Runtime] ASC)
        WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF,
              ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY];
