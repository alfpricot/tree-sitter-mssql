SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
IF NOT EXISTS (   SELECT *
                    FROM sys.views
                   WHERE object_id = OBJECT_ID(N'[dbo].[dept]'))
    EXEC dbo.sp_executesql @statement = N'CREATE VIEW [dept]
AS SELECT [dept],[description],[varovhd_rate],[fixovhd_rate],[vo_acct],[fo_acct],[dl_acct],[mgr_num],[div_num],[lcn_no],[unit],[vo_acct_unit1],[vo_acct_unit2],[vo_acct_unit3],[vo_acct_unit4],[fo_acct_unit1],[fo_acct_unit2],[fo_acct_unit3],[fo_acct_unit4],[dl_acct_unit1],[dl_acct_unit2],[dl_acct_unit3],[dl_acct_unit4],[NoteExistsFlag],[RecordDate],[RowPointer],[CreatedBy],[UpdatedBy],[CreateDate],[InWorkflow]
FROM [dept_mst]
            WHERE [site_ref] = CAST(CONTEXT_INFO() AS NVARCHAR(8))';
