CREATE TABLE dbo.vectors_fp16 (id INT PRIMARY KEY,
                               v VECTOR(3, float16) -- Uses float16 for reduced storage and precision
);

DECLARE @v AS VECTOR(3, float16) = '[0.1, 2, 30]';
SELECT @v;
