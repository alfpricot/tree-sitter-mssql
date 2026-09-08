IF NOT EXISTS (   SELECT *
                    FROM sys.check_constraints
                   WHERE object_id        = OBJECT_ID(N'[dbo].[CK_ABDataServices_InWorkflow]')
                     AND parent_object_id = OBJECT_ID(N'[dbo].[ABDataServices]'))
    ALTER TABLE [dbo].[ABDataServices] WITH CHECK
    ADD CONSTRAINT [CK_ABDataServices_InWorkflow] CHECK ((  [InWorkflow] = (0)
                                                        OR  [InWorkflow] = (1)));
IF EXISTS (   SELECT *
                FROM sys.check_constraints
               WHERE object_id        = OBJECT_ID(N'[dbo].[CK_ABDataServices_InWorkflow]')
                 AND parent_object_id = OBJECT_ID(N'[dbo].[ABDataServices]'))
    ALTER TABLE [dbo].[ABDataServices] CHECK CONSTRAINT [CK_ABDataServices_InWorkflow];
