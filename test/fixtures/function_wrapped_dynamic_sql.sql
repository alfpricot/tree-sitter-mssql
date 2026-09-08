SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
IF NOT EXISTS (   SELECT *
                    FROM sys.objects
                   WHERE object_id = OBJECT_ID(N'[dbo].[IsScheduled]')
                     AND type in ( N'FN', N'IF', N'TF', N'FS', N'FT' ))
BEGIN
    execute dbo.sp_executesql @statement = N'
CREATE FUNCTION dbo.IsScheduled (
   @job_id job_id_type
  ,@suffix suffix_type
)
RETURNS flag_type
AS
BEGIN
   declare @flag flag_type

   set @flag = case
      when exists(select 1 from orders (NOLOCK)
         where orders.ORDERID = dbo.example_lookup(@job_id, @suffix)
         and exists(select 1 from jobs (NOLOCK)
            inner join resource_schedule (NOLOCK) ON jobs.JOBTAG = resource_schedule.JOBTAG
         where jobs.ORDERTAG = orders.ORDERTAG))
         then 1
         else 0
      end

   return @flag
END
'   ;
END;
