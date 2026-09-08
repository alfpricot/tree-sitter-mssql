IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[example_proc]') AND type IN (N'P', N'PC'))
BEGIN
EXEC dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[example_proc] AS'
END
ALTER PROCEDURE [dbo].[example_proc] (
  @input_value  INT
, @output_value INT OUTPUT
) AS
IF EXISTS (SELECT 1 FROM [override_module] [om] WHERE ISNULL([om].[is_enabled], 0) = 1
AND OBJECT_ID(QUOTENAME(N'example_proc_' + [om].[module_name])) IS NOT NULL)
BEGIN
   DECLARE @overrides TABLE ([routine_name] sysname)
   DECLARE @current_routine sysname
   DECLARE @status int
   INSERT INTO @overrides ([routine_name])
   SELECT N'example_proc_' + [om].[module_name]
   FROM [override_module] [om]
   WHERE ISNULL([om].[is_enabled], 0) = 1
   WHILE EXISTS (SELECT 1 FROM @overrides)
   BEGIN
      SELECT TOP 1 @current_routine = [routine_name]
      FROM @overrides
      EXEC @status = @current_routine
           @input_value
         , @output_value OUTPUT
      IF @status <> 1
         RETURN @status
      DELETE @overrides WHERE [routine_name] = @current_routine
   END
END
RETURN 0
