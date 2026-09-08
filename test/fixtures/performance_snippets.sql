-- pe005_merge_join_hint_triggers
SELECT            a.Id
  FROM            dbo.A AS a
 INNER MERGE JOIN dbo.B AS b
    ON a.Id = b.Id;
GO

-- pe005_loop_join_hint_triggers
SELECT           a.Id
  FROM           dbo.A AS a
 INNER LOOP JOIN dbo.B AS b
    ON a.Id = b.Id;
GO

-- pe005_hash_join_hint_triggers
SELECT           a.Id
  FROM           dbo.A AS a
 INNER HASH JOIN dbo.B AS b
    ON a.Id = b.Id;
GO

-- pe018_cursor_used_for_positioned_update_is_clean
DECLARE cur CURSOR FOR SELECT Id FROM dbo.Customer;
OPEN cur;
FETCH NEXT FROM cur;
UPDATE dbo.Customer
   SET Id = Id
 WHERE CURRENT OF cur;
CLOSE cur;
DEALLOCATE cur;
GO
