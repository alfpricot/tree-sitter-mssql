:setvar ColumnName object_id
:setvar TableName sys.objects

SELECT $(ColumnName)
  FROM $(TableName);
