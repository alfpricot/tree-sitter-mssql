SELECT a.Id
  FROM dbo.A AS a
       INNER JOIN dbo.B AS b ON a.Id = b.AId
       LEFT OUTER JOIN dbo.C AS c ON a.Id = c.AId
       RIGHT JOIN dbo.D AS d ON a.Id = d.AId
       RIGHT OUTER JOIN dbo.E AS e ON a.Id = e.AId
       FULL JOIN dbo.F AS f ON a.Id = f.AId
       FULL OUTER JOIN dbo.G AS g ON a.Id = g.AId
       CROSS JOIN dbo.H AS h;
