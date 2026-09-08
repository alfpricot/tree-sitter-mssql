CREATE TRIGGER [ShopFloor_Connections]
ON ALL SERVER
FOR logon
AS
BEGIN
    DECLARE @L_Program_Name AS NVARCHAR(MAX);
    DECLARE @L_Site NCHAR(8);
    DECLARE @L_Context VARBINARY(128);
    DECLARE @L_PadSite NCHAR(8);
    select TOP 1 @L_Program_Name = program_name
      from sys.sysprocesses
     where spid = @@SPID;
    IF PATINDEX('ShopClient:%', @L_Program_Name) > 0
    BEGIN
        SET @L_Site = SUBSTRING(@L_Program_Name, 11, LEN(@L_Program_Name) - 10);
        SET @L_PadSite = @L_Site + SPACE(8);
        SET @L_Context = CAST(@L_PadSite AS VARBINARY(128));
        SET CONTEXT_INFO @L_Context;
    END;
END;
