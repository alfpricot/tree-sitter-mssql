SELECT JSON_OBJECT();

SELECT JSON_OBJECT('name' : 'value', 'type' : 1);

SELECT JSON_OBJECT('name' : 'value', 'type' : NULL ABSENT ON NULL);

DECLARE @id_key   AS NVARCHAR(10) = N'id',
        @id_value AS NVARCHAR(64) = NEWID();
SELECT JSON_OBJECT('user_name' : USER_NAME(), @id_key : @id_value, 'sid' : (SELECT @@SPID));

SELECT JSON_OBJECT("a" : 1 RETURNING json);

SELECT JSON_ARRAY();

SELECT JSON_ARRAY('a', 1, 'b', 2);

SELECT JSON_ARRAY('a', 1, 'b', NULL);

SELECT JSON_ARRAY('a', 1, NULL, 2 NULL ON NULL);

DECLARE @id_value AS NVARCHAR(64) = NEWID();
SELECT JSON_ARRAY(1, @id_value, (SELECT @@SPID));

SELECT JSON_ARRAY(1 RETURNING JSON);
