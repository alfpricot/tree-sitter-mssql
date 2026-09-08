CREATE PARTITION FUNCTION myRangePF1 (int)
AS RANGE LEFT FOR VALUES (1,
                          100,
                          1000);

CREATE PARTITION FUNCTION myRangePF2 (int)
AS RANGE RIGHT FOR VALUES (1,
                           100,
                           1000);

CREATE PARTITION FUNCTION [myDateRangePF1] (datetime)
AS RANGE RIGHT FOR VALUES ('20030201',
                           '20030301',
                           '20030401',
                           '20030501',
                           '20030601',
                           '20030701',
                           '20030801',
                           '20030901',
                           '20031001',
                           '20031101',
                           '20031201');

CREATE PARTITION FUNCTION myRangePF3 (char(20))
AS RANGE RIGHT FOR VALUES ('EX',
                           'RXE',
                           'XR');

CREATE PARTITION SCHEME myRangePS1
AS PARTITION myRangePF1
TO (test1fg,
    test2fg,
    test3fg,
    test4fg);

CREATE PARTITION SCHEME myRangePS2
AS PARTITION myRangePF2
TO (test1fg,
    test1fg,
    test1fg,
    test2fg);

CREATE PARTITION SCHEME myRangePS3
AS PARTITION myRangePF3
ALL TO (test1fg);

CREATE PARTITION SCHEME myRangePS4
AS PARTITION myRangePF1
TO (test1fg,
    test2fg,
    test3fg,
    test4fg,
    test5fg);

CREATE PARTITION SCHEME myRangePS1
AS PARTITION myRangePF1
ALL TO ([PRIMARY]);

ALTER TABLE myPartitionedTable SWITCH PARTITION 1 TO myOtherTable;
ALTER TABLE myPartitionedTable SWITCH PARTITION 1 TO myOtherTable PARTITION 2;
ALTER TABLE myPartitionedTable SWITCH TO myOtherTable;

SELECT $PARTITION.myRangePF1(col) FROM myPartitionedTable;
