SELECT FirstName,
       LastName,
       JSON_VALUE(jsonInfo, '$.info.address.town') AS Town
  FROM Person.Person
 WHERE JSON_VALUE(jsonInfo, '$.info.address.state') LIKE 'US%'
 ORDER BY JSON_VALUE(jsonInfo, '$.info.address.town');
DECLARE @jsonInfo AS NVARCHAR(MAX);
DECLARE @town AS NVARCHAR(32);
SET @jsonInfo = N'{"info":{"address":[{"town":"Paris"},{"town":"London"}]}}';
SET @town = JSON_VALUE(@jsonInfo, '$.info.address[0].town');
SET @town = JSON_VALUE(@jsonInfo, '$.info.address[1].town');
CREATE TABLE dbo.Store (StoreID INT IDENTITY(1, 1) NOT NULL,
                        Address VARCHAR(500),
                        jsonContent NVARCHAR(4000),
                        Longitude AS JSON_VALUE(jsonContent, '$.address[0].longitude'),
                        Latitude AS JSON_VALUE(jsonContent, '$.address[0].latitude'));
SELECT PersonID,
       FullName,
       JSON_QUERY(CustomFields, '$.OtherLanguages') AS Languages
  FROM Application.People;
SELECT StockItemID,
       StockItemName,
       JSON_QUERY(Tags) AS Tags,
       JSON_QUERY(CONCAT('["', ValidFrom, '","', ValidTo, '"]')) AS ValidityPeriod
  FROM Warehouse.StockItems
FOR JSON PATH;

DECLARE @j AS JSON = '[1, 1.3333, true, "a", "1", "2025-01-01"]';

SELECT JSON_VALUE(@j, '$[5]' RETURNING date) AS date_value;

DECLARE @j JSON
    = '
{"id":2, "first_name":"Mamie", "last_name":"Baudassi", "email":"mbaudassi1@example.com", "gender":"Female", "ip_address":"148.199.129.123", "credit_cards":[ {"type":"jcb", "card#":"3545138777072343", "currency":"Koruna"}, {"type":"diners-club-carte-blanche", "card#":"30282304348533", "currency":"Dong"}, {"type":"jcb", "card#":"3585303288595361", "currency":"Yuan Renminbi"}, {"type":"maestro", "card#":"675984450768756054", "currency":"Rupiah"}, {"type":"instapayment", "card#":"6397068371771473", "currency":"Euro"}]}
';
SELECT JSON_QUERY(@j, '$.credit_cards[*].type' WITH ARRAY WRAPPER) as credit_card_types;
