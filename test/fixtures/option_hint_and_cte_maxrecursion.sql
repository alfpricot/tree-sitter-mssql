SELECT Id
  FROM dbo.Customer
OPTION (RECOMPILE, OPTIMIZE FOR UNKNOWN);

WITH included_parts (part_id, level) AS (
    SELECT part_id, 0
      FROM dbo.Part
     WHERE parent_part_id IS NULL
    UNION ALL
    SELECT p.part_id, ip.level + 1
      FROM dbo.Part AS p
      JOIN included_parts AS ip ON p.parent_part_id = ip.part_id
)
SELECT part_id, level
  FROM included_parts
OPTION (MAXRECURSION 100);
