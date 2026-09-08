IF NOT EXISTS (SELECT * FROM master.sys.server_triggers WHERE parent_class_desc = 'SERVER' AND name = N'example_logon_trigger')
CREATE TRIGGER [example_logon_trigger]
ON ALL SERVER FOR LOGON
AS
BEGIN
    SET CONTEXT_INFO 0x00
END
ENABLE TRIGGER [example_logon_trigger] ON ALL SERVER
