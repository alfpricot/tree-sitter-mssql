SELECT value
  FROM STRING_SPLIT('Lorem ipsum dolor sit amet.', ' ');

SELECT *
  FROM STRING_SPLIT('Lorem ipsum dolor sit amet.', ' ', 1);

DECLARE @tags NVARCHAR(400) = 'clothing,road,,touring,bike';

SELECT value
  FROM STRING_SPLIT(@tags, ',')
 WHERE RTRIM(value) <> '';

SELECT       ProductId,
             Name,
             value
  FROM       Product
 CROSS APPLY STRING_SPLIT(Tags, ',');

SELECT       value as tag,
             COUNT(*) AS [number_of_articles]
  FROM       Product
 CROSS APPLY STRING_SPLIT(Tags, ',')
 GROUP BY value
HAVING       COUNT(*) > 2
 ORDER BY COUNT(*) DESC;

SELECT ProductId,
       Name,
       Tags
  FROM Product
 WHERE 'clothing' IN ( SELECT value FROM STRING_SPLIT(Tags, ','));

SELECT ProductId,
       Name,
       Tags
  FROM Product
 WHERE EXISTS (SELECT * FROM STRING_SPLIT(Tags, ',')WHERE value IN ( 'clothing', 'road' ));

SELECT ProductId,
       Name,
       Tags
  FROM Product
  JOIN STRING_SPLIT('1,2,3', ',')
    ON value = ProductId;

SELECT *
  FROM STRING_SPLIT('Austin,Texas,Seattle,Washington,Denver,Colorado', ',', 1)
 WHERE ordinal % 2 = 0;

SELECT *
  FROM STRING_SPLIT('E-D-C-B-A', '-', 1)
 ORDER BY ordinal DESC;
