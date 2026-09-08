DECLARE @StringVariable NVARCHAR(50);
SET @StringVariable = N'<\<%7.3s>>';

RAISERROR(@StringVariable, -- Message text.
          10, -- Severity,
          1, -- State,
          N'abcde'); -- First argument supplies the string.
                     -- The message text returned is: <<    abc>>.
GO
