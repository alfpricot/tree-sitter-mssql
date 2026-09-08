CREATE TRIGGER [ABDataServicesInsert]
ON [ABDataServices]
INSTEAD OF INSERT
AS
IF @@ROWCOUNT = 0
    RETURN;
SET NOCOUNT ON;
DECLARE @Today DateType;
SET @Today = dbo.GetSiteDate(GETDATE());
DECLARE @UserName LongListType;
SET @UserName = dbo.UserNameSp();
INSERT [ABDataServices] ([Id],
                         [ProjectId],
                         [Runtime],
                         [Name],
                         [Version],
                         [Data],
                         [CreatedBy],
                         [UpdatedBy],
                         [CreateDate],
                         [RecordDate],
                         [RowPointer],
                         [NoteExistsFlag],
                         [InWorkflow],
                         [LastChangedByDisplayName],
                         [CreatedByDisplayName])
SELECT bt.[Id],
       bt.[ProjectId],
       bt.[Runtime],
       bt.[Name],
       bt.[Version],
       bt.[Data],
       @Username,
       @Username,
       @Today,
       @Today,
       bt.[RowPointer],
       bt.[NoteExistsFlag],
       bt.[InWorkflow],
       bt.[LastChangedByDisplayName],
       bt.[CreatedByDisplayName]
  FROM inserted AS bt WITH (READUNCOMMITTED);
RETURN;
