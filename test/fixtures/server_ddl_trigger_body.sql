CREATE TRIGGER dbo.example_ddl_trigger
ON ALL SERVER
WITH EXECUTE AS CALLER
FOR DDL_DATABASE_LEVEL_EVENTS
AS
BEGIN
    BEGIN TRY
        SET NOCOUNT ON;
        IF EVENTDATA() IS NULL
            RETURN;
        IF ISNULL(IS_SRVROLEMEMBER('sysadmin'), 0) | ISNULL(IS_SRVROLEMEMBER('serveradmin'), 0) = 0
            RETURN;

        DECLARE @event AS XML = EVENTDATA(),
                @event_type NVARCHAR(512),
                @object_name NVARCHAR(512),
                @sql NVARCHAR(MAX),
                @result BIT = 0;

        SET @event_type = @event.value('(/EVENT_INSTANCE/EventType)[1]', 'nvarchar(512)');
        SET @object_name = @event.value('(/EVENT_INSTANCE/ObjectName)[1]', 'nvarchar(512)');

        DECLARE @ignore TABLE (
            name_filter NVARCHAR(512) NOT NULL,
            idx INT IDENTITY(1, 1) PRIMARY KEY
        );

        INSERT INTO @ignore (name_filter)
        SELECT i.name_filter
        FROM (VALUES (N'tmp_%'), (N'tt_%')) AS i (name_filter)
        UNION ALL
        SELECT i.name_filter
        FROM (VALUES (N'IX_tmp_%')) AS i (name_filter);

        IF EXISTS (SELECT 1 FROM @ignore AS i WHERE @object_name LIKE i.name_filter)
            RETURN;

        SET @sql = N'SET @result = 1;';
        EXECUTE sys.sp_executesql @stmt = @sql,
                                  @params = N'@result bit OUTPUT',
                                  @result = @result OUTPUT;

        INSERT INTO dbo.trigger_log (event_type, object_name)
        SELECT @event_type, @object_name;
    END TRY
    BEGIN CATCH
        RETURN;
    END CATCH;
END;
