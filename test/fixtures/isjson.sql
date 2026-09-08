SELECT id,
       json_col
  FROM tab1
 WHERE ISJSON(json_col) = 1;

SELECT id,
       json_col
  FROM tab1
 WHERE ISJSON(json_col, SCALAR) = 1;

SELECT ISJSON('true', VALUE);

SELECT ISJSON('test string', VALUE);

SELECT ISJSON('"test string"', SCALAR);
