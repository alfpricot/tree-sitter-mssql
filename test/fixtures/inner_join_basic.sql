SELECT      a.Id,
            a.Name,
            b.Total
  FROM      dbo.A AS a
 INNER JOIN dbo.B AS b
    ON a.Id = b.AId
 WHERE      a.Id > 1
 ORDER BY a.Name;
