CREATE FUNCTION dbo.IsScheduled (@job_id job_id_type,
                                 @suffix suffix_type)
RETURNS Flag
AS
BEGIN
    declare @Flag ListYesNoType;
    set @Flag = case
                     when exists (   select 1
                                       from orders (NOLOCK)
                                      where orders.ORDERID = dbo.ApsJobOrderId(@job_id, @suffix)
                                        and exists (   select      1
                                                         from      jobs (NOLOCK)
                                                        inner join resource_schedule (NOLOCK)
                                                           ON jobs.JOBTAG = resource_schedule.JOBTAG
                                                        where      jobs.ORDERTAG = orders.ORDERTAG)) then 1
                     else 0 end;
    return @Flag;
END;
