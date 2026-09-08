ALTER PROCEDURE [dbo].[example_report_totals] (
@start_id IntKeyType = NULL,
@end_id IntKeyType = NULL,
@out_count IntKeyType OUTPUT)
AS
DECLARE @rpt_set TABLE (line_id IntKeyType,
                        addr##1 AddressType,
                        addr##2 AddressType,
                        amount AmtTotType,
                        display_addr LongAddress);

INSERT INTO @rpt_set (line_id,
                      addr##1,
                      addr##2,
                      amount,
                      display_addr)
SELECT h.line_id,
       h.addr_line_1,
       h.addr_line_2,
       CASE
            WHEN RANK() OVER (PARTITION BY h.id ORDER BY h.id, h.line_id) = 1 THEN h.total
            ELSE 0 END,
       dbo.format_address(h.addr_line_1, h.addr_line_2, DEFAULT, DEFAULT, h.country)
  FROM dbo.header AS h
 WHERE h.id BETWEEN @start_id AND @end_id
 ORDER BY h.id,
          h.line_id;

SET @out_count = @@ROWCOUNT;

SELECT line_id,
       IIF(ISNULL(addr##1, '') = '', '', addr##1) AS display_line_1,
       amount
  FROM @rpt_set
 ORDER BY line_id;
