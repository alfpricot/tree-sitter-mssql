CREATE TRIGGER [dbo].[ABOPTS_mstDel]
on [dbo].[ABOPTS_mst]
FOR DELETE
AS
IF @@ROWCOUNT = 0
    RETURN;
IF dbo.SkipBaseTrigger() = 1
    RETURN;
DECLARE @Severity INT,
        @Infobar  InfobarType;
SET @Severity = 0;
if @Severity = 0
BEGIN
    DELETE      DocumentObjectReference
      FROM      deleted AS dd
     INNER JOIN DocumentObjectReference AS dor
        ON dor.TableRowPointer = dd.RowPointer
     WHERE      dor.TableName = 'ABOPTS';
    DELETE ObjectNotes
      FROM deleted AS dd,
           ObjectNotes AS obn
     WHERE obn.RefRowPointer = dd.RowPointer;
    DELETE UserDefinedFields
      FROM deleted AS dd,
           UserDefinedFields AS udf
     WHERE udf.RowId = dd.RowPointer;
END;
IF @Severity <> 0
BEGIN
    EXEC dbo.RaiseErrorSp @Infobar, @Severity, 3;
    EXEC @Severity = dbo.RollbackTransactionSp @Severity;
    IF @Severity != 0
    BEGIN
        ROLLBACK TRANSACTION;
        RETURN;
    END;
END;
