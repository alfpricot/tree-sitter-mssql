DECLARE @v1 AS VECTOR(2) = '[1,1]';
DECLARE @v2 AS VECTOR(2) = '[-1,-1]';

SELECT VECTOR_DISTANCE('euclidean', @v1, @v2) AS euclidean,
       VECTOR_DISTANCE('cosine', @v1, @v2) AS cosine,
       VECTOR_DISTANCE('dot', @v1, @v2) AS negative_dot_product;

DECLARE @v AS VECTOR(1536);

SELECT @v = title_vector
  FROM [dbo].[wikipedia_articles]
 WHERE title = 'Alan Turing';

SELECT id,
       title,
       VECTOR_DISTANCE('cosine', @v, title_vector) AS distance
  FROM [dbo].[wikipedia_articles]
 WHERE VECTOR_DISTANCE('cosine', @v, title_vector) < 0.3
 ORDER BY distance;
