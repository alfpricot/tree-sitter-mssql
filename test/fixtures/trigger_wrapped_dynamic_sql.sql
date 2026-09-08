SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
IF NOT EXISTS (   SELECT *
                    FROM sys.triggers
                   WHERE object_id = OBJECT_ID(N'[dbo].[ABOPTS_mstDel]'))
    EXEC dbo.sp_executesql @statement = N'

/* header removed */

/* vendor notice removed */

/* revision history removed */
CREATE TRIGGER [dbo].[ABOPTS_mstDel]
on [dbo].[ABOPTS_mst]
FOR DELETE
AS

IF @@ROWCOUNT = 0 RETURN

-- Skip trigger operations as required.
IF dbo.SkipBaseTrigger() = 1
   RETURN


DECLARE
  @Severity INT
, @Infobar  InfobarType

SET @Severity = 0


/*======== CURSOR PROCESSING SECTION ========*/

/*
** Delete any notes attached to the deleted row(s).
** This code was not done in the cursor for performance reasons.
*/
if @Severity = 0
BEGIN
   -- Delete any document references
   DELETE DocumentObjectReference
   FROM deleted dd
   INNER JOIN DocumentObjectReference dor ON
     dor.TableRowPointer = dd.RowPointer
   WHERE dor.TableName = ''ABOPTS''


   DELETE ObjectNotes
   FROM deleted dd
      , ObjectNotes obn
   WHERE obn.RefRowPointer = dd.RowPointer

   DELETE UserDefinedFields
   FROM deleted dd
   , UserDefinedFields udf
   WHERE udf.RowId = dd.RowPointer

   

END


IF @Severity <> 0
BEGIN
    EXEC dbo.RaiseErrorSp @Infobar, @Severity, 3
 
    EXEC @Severity = dbo.RollbackTransactionSp
       @Severity
 
    IF @Severity != 0
    BEGIN
       ROLLBACK TRANSACTION
       RETURN
    END
END
 
'   ;
ALTER TABLE [dbo].[ABOPTS_mst] ENABLE TRIGGER [ABOPTS_mstDel];
EXEC sp_settriggerorder @triggername = N'[dbo].[ABOPTS_mstDel]',
                        @order = N'First',
                        @stmttype = N'DELETE';
