DECLARE @myDoc XML;
DECLARE @ProdID INT;

SET @myDoc
    = '<Root>
<ProductDescription ProductID="1" ProductName="Road Bike">
<Features>
  <Warranty>1 year parts and labor</Warranty>
  <Maintenance>3 year parts and labor extended maintenance is available</Maintenance>
</Features>
</ProductDescription>
</Root>';

SET @ProdID = @myDoc.value('(/Root/ProductDescription/@ProductID)[1]', 'int');
SELECT @ProdID;

CREATE TABLE T (c1 INT,
                c2 VARCHAR(10),
                c3 XML);
GO

SELECT c1,
       c2,
       c3
  FROM T
 WHERE c3.value('(/root/@a)[1]', 'integer') = c1;
GO

SELECT c1,
       c2,
       c3
  FROM T
 WHERE c3.exist('/root[@a=sql:column("c1")]') = 1;
GO

DECLARE @myDoc XML;
SET @myDoc
    = '<Root>
<ProductDescription ProductID="1" ProductName="Road Bike">
<Features>
  <Warranty>1 year parts and labor</Warranty>
  <Maintenance>3 year parts and labor extended maintenance is available</Maintenance>
</Features>
</ProductDescription>
</Root>';
SELECT @myDoc.query('/Root/ProductDescription/Features');

DECLARE @x XML;
SET @x
    = '<Root>
    <row id="1"><name>Larry</name><oflw>some text</oflw></row>
    <row id="2"><name>moe</name></row>
    <row id="3" />
</Root>';
SELECT T.c.query('.') AS result
  FROM @x.nodes('/Root/row') AS T(c);
GO

SELECT T.c.query('..') AS result
  FROM @x.nodes('/Root/row') AS T(c);
GO

DECLARE @x XML;
DECLARE @f BIT;
SET @x = '<root Somedate = "2002-01-01Z"/>';
SET @f = @x.exist('/root[(@Somedate cast as xs:date?) eq xs:date("2002-01-01Z")]');
SELECT @f;

DECLARE @x XML;
DECLARE @f BIT;
SET @x = '<Somedate>2002-01-01Z</Somedate>';
SET @f = @x.exist('/Somedate[(text()[1] cast as xs:date ?) = xs:date("2002-01-01Z") ]');
SELECT @f;
