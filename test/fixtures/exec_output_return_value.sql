DECLARE @return_value  int,
        @SuccessDetail nvarchar(4000),
        @SuccessID     int;

EXEC @return_value = [dbo].[PJ_Archive_TMS_AuditSp] @SuccessDetail = @SuccessDetail OUTPUT,
                                                    @SuccessID = @SuccessID OUTPUT;


