CREATE EXTERNAL DATA SOURCE mydatasource
WITH (TYPE = HADOOP,
      LOCATION = 'hdfs://xxx.xxx.xxx.xxx:8020');
GO

CREATE EXTERNAL FILE FORMAT myfileformat
WITH (FORMAT_TYPE = DELIMITEDTEXT,
      FORMAT_OPTIONS (FIELD_TERMINATOR = '|'));
GO

CREATE EXTERNAL TABLE ClickStream (url VARCHAR(50),
                                   event_date DATE,
                                   user_IP VARCHAR(50))
WITH (DATA_SOURCE = mydatasource,
      LOCATION = '/webdata/employee.tbl',
      FILE_FORMAT = myfileformat);
GO

SELECT TOP 10 (url)
  FROM ClickStream
 WHERE user_ip = 'xxx.xxx.xxx.xxx';
