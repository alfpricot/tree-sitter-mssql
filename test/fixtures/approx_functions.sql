SELECT APPROX_COUNT_DISTINCT(O_OrderKey) AS Approx_Distinct_OrderKey
  FROM dbo.Orders;

SELECT O_OrderStatus,
       APPROX_COUNT_DISTINCT(O_OrderKey) AS Approx_Distinct_OrderKey
  FROM dbo.Orders
 GROUP BY O_OrderStatus
 ORDER BY O_OrderStatus;

SET NOCOUNT ON;
GO
DROP TABLE IF EXISTS tblEmployee;
GO
CREATE TABLE tblEmployee (EmplId INT IDENTITY(1, 1) PRIMARY KEY CLUSTERED,
                          DeptId INT,
                          Salary int);
GO
INSERT INTO tblEmployee
VALUES (1, 31),
       (1, 18),
       (2, 25),
       (2, NULL);
GO
SELECT DeptId,
       APPROX_PERCENTILE_CONT(0.10) WITHIN GROUP(ORDER BY Salary) AS P10_Cont,
       APPROX_PERCENTILE_DISC(0.90) WITHIN GROUP(ORDER BY Salary) AS P90_Disc
  FROM tblEmployee
 GROUP BY DeptId;
