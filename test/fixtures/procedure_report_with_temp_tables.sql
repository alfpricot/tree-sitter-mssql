ALTER PROCEDURE [dbo].[example_report] (@end_date DATE)
AS
BEGIN TRANSACTION;
SET XACT_ABORT ON;
IF dbo.get_isolation_level(N'example_report') = N'COMMITTED'
    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
ELSE
    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
DECLARE @start_date DATE;
SET @end_date = ISNULL(@end_date, GETDATE());
SET @start_date = DATEADD(YY, -1, @end_date);
SET NOCOUNT ON;
BEGIN
    IF OBJECT_ID('tempdb..#staging') IS NOT NULL
        DROP TABLE #staging;
END;
BEGIN
    CREATE TABLE #staging (row_date date,
                           category nvarchar(30),
                           amount decimal(10, 2)
                               DEFAULT 0);
    CREATE INDEX ix_staging ON #staging (row_date, category);
END;
BEGIN
    INSERT INTO #staging (row_date,
                          category,
                          amount)
    SELECT      dbo.header.row_date,
                dbo.item.category,
                SUM(dbo.item.amount) AS amount
      FROM      dbo.header
     INNER JOIN dbo.item
        ON dbo.header.id = dbo.item.header_id
     GROUP BY dbo.header.row_date,
              dbo.item.category
    HAVING      (dbo.header.row_date BETWEEN @start_date AND @end_date);
END;
BEGIN
    UPDATE      #staging
       SET      #staging.amount = a.total
      FROM      (   SELECT category,
                           SUM(amount) AS total
                      FROM #staging
                     GROUP BY category) AS a
     INNER JOIN #staging
        ON #staging.category = a.category;
END;
BEGIN
    DELETE FROM #staging
     WHERE amount = 0;
END;
SELECT category,
       CASE
            WHEN amount > 0 THEN 'active'
            ELSE 'inactive' END AS status
  FROM #staging
 ORDER BY category;
DROP TABLE #staging;
COMMIT TRANSACTION;
RETURN 0;
