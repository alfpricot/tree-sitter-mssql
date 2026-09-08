SELECT CAST((SELECT column1, column2 FROM my_table FOR XML PATH('')) AS VARCHAR(MAX)) AS XMLDATA;

USE AdventureWorks2025;
SELECT      p.BusinessEntityID,
            FirstName,
            LastName,
            PhoneNumber AS Phone
  FROM      Person.Person AS p
 INNER JOIN Person.PersonPhone AS pph
    ON p.BusinessEntityID = pph.BusinessEntityID
 WHERE      LastName LIKE 'G%'
 ORDER BY LastName,
          FirstName
FOR XML AUTO, TYPE, XMLSCHEMA, ELEMENTS XSINIL;

SELECT Cust.CustomerID,
       OrderHeader.CustomerID,
       OrderHeader.SalesOrderID,
       OrderHeader.Status,
       Cust.CustomerType
  FROM Sales.Customer AS Cust,
       Sales.SalesOrderHeader AS OrderHeader
 WHERE Cust.CustomerID = OrderHeader.CustomerID
 ORDER BY Cust.CustomerID
FOR XML AUTO;

select OrderHeader.CustomerID,
       OrderHeader.SalesOrderID,
       OrderHeader.Status,
       Cust.CustomerID,
       Cust.CustomerType
  from Sales.Customer AS Cust,
       Sales.SalesOrderHeader AS OrderHeader
 where Cust.CustomerID = OrderHeader.CustomerID
for xml auto;

SELECT Cust.CustomerID,
       OrderHeader.CustomerID,
       OrderHeader.SalesOrderID,
       OrderHeader.Status,
       Cust.CustomerType
  FROM Sales.Customer AS Cust,
       Sales.SalesOrderHeader AS OrderHeader
 WHERE Cust.CustomerID = OrderHeader.CustomerID
 ORDER BY Cust.CustomerID
FOR XML AUTO, ELEMENTS;
