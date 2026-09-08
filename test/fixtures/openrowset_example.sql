SELECT a.*
  FROM OPENROWSET('SQLNCLI', 'Server=SQLSERVER01;Trusted_Connection=yes;',
                  'SELECT Id, Name FROM dbo.Customer') AS a;

SELECT BulkColumn
  FROM OPENROWSET(BULK 'C:\data\example.csv', SINGLE_CLOB) AS b;
