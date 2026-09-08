SELECT value
  FROM GENERATE_SERIES(1, 10);

SELECT value
  FROM GENERATE_SERIES(1, 50, 5);

DECLARE @start decimal(2, 1) = 0.0;
DECLARE @stop decimal(2, 1) = 1.0;
DECLARE @step decimal(2, 1) = 0.1;

SELECT value
  FROM GENERATE_SERIES(@start, @stop, @step);
