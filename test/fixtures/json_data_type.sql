CREATE TABLE Orders (order_id INT,
                     order_details JSON NOT NULL);
CREATE TABLE Orders (order_id INT,
                     order_details JSON NOT NULL CHECK (JSON_PATH_EXISTS(order_details, '$.basket') = 1));
DROP TABLE IF EXISTS JsonTable;
CREATE TABLE JsonTable (id INT PRIMARY KEY,
                        d JSON);
INSERT INTO JsonTable (id,
                       d)
VALUES (1, '{"a":1, "b":"abc", "c":true}');
DECLARE @true JSON = 'true';
DECLARE @false JSON = 'false';
DECLARE @number JSON = '1234.56';
DECLARE @string JSON = '"contoso"';
DECLARE @null JSON = 'null';
DECLARE @null JSON = NULL;
DECLARE @object JSON = '{}';
DECLARE @array JSON = '[]';

UPDATE JsonTable
   SET d.modify('$.a', 14859)
 WHERE id = 1;

UPDATE JsonTable
   SET d.modify('$.b', 'def')
 WHERE id = 1;
