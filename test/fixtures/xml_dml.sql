USE AdventureWorks;
GO
DECLARE @myDoc XML;
SET @myDoc
    = '<Root>
    <ProductDescription ProductID="1" ProductName="Road Bike">
        <Features>
        </Features>
    </ProductDescription>
</Root>';
SELECT @myDoc;
SET @myDoc.modify('
insert <Maintenance>3 year parts and labor extended maintenance is available</Maintenance>
into (/Root/ProductDescription/Features)[1]');
SELECT @myDoc;
SET @myDoc.modify('
insert <Warranty>1 year parts and labor</Warranty>
as first
into (/Root/ProductDescription/Features)[1]
');
SELECT @myDoc;
SELECT @myDoc;
SET @myDoc.modify('
insert <Material>Aluminum</Material>
as last
into (/Root/ProductDescription/Features)[1]
');
SELECT @myDoc;
SELECT @myDoc;
SET @myDoc.modify('
insert <BikeFrame>Strong long lasting</BikeFrame>
after (/Root/ProductDescription/Features/Material)[1]
');
SELECT @myDoc;
GO
DECLARE @myDoc XML;
SET @myDoc
    = '<Root>
<Location LocationID="10"
            LaborHours="1.1"
            MachineHours=".2" >Manufacturing steps are described here.
<step>Manufacturing step 1 at this work center</step>
<step>Manufacturing step 2 at this work center</step>
</Location>
</Root>';
SELECT @myDoc;
SET @myDoc.modify('
  replace value of (/Root/Location/step[1]/text())[1]
  with "new text describing the manu step"
');
SELECT @myDoc;
SET @myDoc.modify('
  replace value of (/Root/Location/@LaborHours)[1]
  with "100.0"
');
SELECT @myDoc;
DROP TABLE T;
GO
CREATE TABLE T (i INT,
                x XML);
GO
INSERT INTO T
VALUES (1,
        '<Root>
<ProductDescription ProductID="1" ProductName="Road Bike">
<Features>
  <Warranty>1 year parts and labor</Warranty>
  <Maintenance>3 year parts and labor extended maintenance is available</Maintenance>
</Features>
</ProductDescription>
</Root>');
GO
SELECT x.query(' /Root/ProductDescription')
  FROM T;

-- insert a new element
UPDATE T
   SET x.modify('insert <Material>Aluminum</Material> as first
  into   (/Root/ProductDescription/Features)[1]
');
GO
-- check the update
SELECT x.query(' //ProductDescription/Features')
  FROM T;
GO

-- update the ProductName attribute value
UPDATE T
   SET x.modify('
  replace value of (/Root/ProductDescription/@ProductName)[1]
  with "New Road Bike" ');
