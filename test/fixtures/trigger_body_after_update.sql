CREATE TRIGGER [ABDataServicesUpdatePenultimate]
ON [ABDataServices]
AFTER Update
AS
IF @@ROWCOUNT = 0
    RETURN;
IF TRIGGER_NESTLEVEL(OBJECT_ID(N'dbo.ABDataServicesIup')) > 0
    RETURN;
SET NOCOUNT ON;
IF dbo.SkipBaseTrigger() = 1
    RETURN;
DECLARE @Today DateType;
SET @Today = dbo.GetSiteDate(GETDATE());
DECLARE @UserName LongListType;
SET @UserName = dbo.UserNameSp();
UPDATE [ABDataServices]
   SET UpdatedBy = @Username,
       RecordDate = @Today
  FROM inserted AS ii WITH (READUNCOMMITTED)
 WHERE ii.RowPointer = [ABDataServices].RowPointer;
RETURN;
