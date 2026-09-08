DECLARE @json NVARCHAR(2048)
    = N'{
   "String_value": "John",
   "DoublePrecisionFloatingPoint_value": 45,
   "DoublePrecisionFloatingPoint_value": 2.3456,
   "BooleanTrue_value": true,
   "BooleanFalse_value": false,
   "Null_value": null,
   "Array_value": ["a","r","r","a","y"],
   "Object_value": {"obj":"ect"}
}';

SELECT *
  FROM OpenJson(@json);

DECLARE @pSearchOptions NVARCHAR(4000) = N'[1,2,3,4]';

SELECT      *
  FROM      products
 INNER JOIN OPENJSON(@pSearchOptions) AS productTypes
    ON product.productTypeID = productTypes.value;

SELECT       SalesOrderID,
             OrderDate,
             value AS Reason
  FROM       Sales.SalesOrderHeader
 CROSS APPLY OPENJSON(SalesReasons);

DECLARE @json NVARCHAR(MAX)
    = N'[
  {
    "Order": {
      "Number":"SO43659",
      "Date":"2011-05-31T00:00:00"
    },
    "AccountNumber":"AW29825",
    "Item": {
      "Price":2024.9940,
      "Quantity":1
    }
  },
  {
    "Order": {
      "Number":"SO43661",
      "Date":"2011-06-01T00:00:00"
    },
    "AccountNumber":"AW73565",
    "Item": {
      "Price":2024.9940,
      "Quantity":3
    }
  }
]';

SELECT *
  FROM OPENJSON(@json)
       WITH (Number VARCHAR(200) '$.Order.Number',
             Date DATETIME '$.Order.Date',
             Customer VARCHAR(200) '$.AccountNumber',
             Quantity INT '$.Item.Quantity',
             [Order] NVARCHAR(MAX) AS JSON);

SELECT       SalesOrderID,
             OrderDate,
             value AS Reason
  FROM       Sales.SalesOrderHeader
 CROSS APPLY OPENJSON(SalesReasons)
             WITH (value NVARCHAR(100) '$');
