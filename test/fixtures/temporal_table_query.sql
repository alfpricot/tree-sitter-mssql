CREATE TABLE dbo.employee_history (
  employee_id int NOT NULL,
  salary decimal(10, 2) NOT NULL,
  valid_from datetime2 NOT NULL,
  valid_to datetime2 NOT NULL,
  PERIOD FOR SYSTEM_TIME (valid_from, valid_to)
);

ALTER TABLE dbo.employee_history ADD PERIOD FOR SYSTEM_TIME (valid_from, valid_to);

SELECT * FROM dbo.employee_history FOR SYSTEM_TIME AS OF '2020-01-01T00:00:00.0000000';

SELECT * FROM dbo.employee_history FOR SYSTEM_TIME FROM '2020-01-01' TO '2021-01-01' AS h;

SELECT * FROM dbo.employee_history FOR SYSTEM_TIME BETWEEN '2020-01-01' AND '2021-01-01';

SELECT * FROM dbo.employee_history FOR SYSTEM_TIME CONTAINED IN ('2020-01-01', '2021-01-01');

SELECT * FROM dbo.employee_history FOR SYSTEM_TIME ALL;
