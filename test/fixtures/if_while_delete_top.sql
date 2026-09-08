IF EXISTS (SELECT 1 FROM dbo.Orders WHERE Id = 1)
BEGIN
    PRINT 'found';
END;
ELSE
BEGIN
    PRINT 'missing';
END;

WHILE (SELECT COUNT(*)FROM dbo.Queue) > 0
BEGIN
    DELETE TOP (1) FROM dbo.Queue;
END;
