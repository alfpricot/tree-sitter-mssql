use [tier2_sample_db];
go
if exists (   select 1
                from sys.triggers as t
               where t.[object_id] = object_id(N'[dbo].[sample_tbl_insert_trg]', N'TR'))
    drop trigger [dbo].[sample_tbl_insert_trg];
go
use [tier2_sample_db];
go
set ansi_nulls, quoted_identifier on;
go
create trigger [sample_tbl_insert_trg]
on [sample_tbl]
instead of insert
as
if @@rowcount = 0
    return;
set nocount on;
declare @today DateType;
set @today = dbo.GetSiteDate(getdate());
declare @user_name LongListType;
set @user_name = dbo.UserNameSp();
insert [sample_tbl] ([id],
                     [parent_id],
                     [name],
                     [kind],
                     [created_by],
                     [updated_by],
                     [create_date],
                     [record_date],
                     [row_guid],
                     [note_flag],
                     [in_workflow])
select bt.[id],
       bt.[parent_id],
       bt.[name],
       bt.[kind],
       @user_name,
       @user_name,
       @today,
       @today,
       bt.[row_guid],
       bt.[note_flag],
       bt.[in_workflow]
  from inserted as bt with (readuncommitted);
return;
go
alter table [dbo].[sample_tbl] enable trigger [sample_tbl_insert_trg];
go
