CREATE STATISTICS ContactMail1
ON Person.Person (BusinessEntityID,
                  EmailPromotion)
WITH SAMPLE 5 PERCENT;
