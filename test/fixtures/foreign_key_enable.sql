IF NOT EXISTS (   SELECT *
                    FROM sys.foreign_keys
                   WHERE object_id        = OBJECT_ID(N'[dbo].[FK_ack_mst_trans_nat_2_site_ref]')
                     AND parent_object_id = OBJECT_ID(N'[dbo].[ack_mst]'))
    ALTER TABLE [dbo].[ack_mst] WITH CHECK
    ADD CONSTRAINT [FK_ack_mst_trans_nat_2_site_ref]
        FOREIGN KEY ([trans_nat_2], [site_ref])
        REFERENCES [dbo].[trans_nature_2_mst] ([trans_nat_2], [site_ref]);
IF EXISTS (   SELECT *
                FROM sys.foreign_keys
               WHERE object_id        = OBJECT_ID(N'[dbo].[FK_ack_mst_trans_nat_2_site_ref]')
                 AND parent_object_id = OBJECT_ID(N'[dbo].[ack_mst]'))
    ALTER TABLE [dbo].[ack_mst] CHECK CONSTRAINT [FK_ack_mst_trans_nat_2_site_ref];
