use [tier2_sample_db];
go
set ansi_nulls, quoted_identifier on;
go
if not exists (   select 1
                    from sys.objects as o
                   where o.[object_id] = object_id('[dbo].[compare_staging_sp]')
                     and o.[type] in ( N'P', N'PC' ))
begin
    execute dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[compare_staging_sp] AS';
end;
go
alter procedure [dbo].[compare_staging_sp]
as
begin
    set nocount on;
    if dbo.EventHasAnyHandlers(N'sample_manual_sync') = 0
    or dbo.IsCollectionOutboundIntegrated('SampleItems') = 0
        return 0;
    declare @severity    int            = 0,
            @object_name ObjectNameType = object_name(@@procid),
            @user_name   UsernameType   = dbo.GetUsername(),
            @today       DateTimeType   = dbo.GetSiteDate2(getdate());
    declare @changes table (change_type nvarchar(20) not null,
                            row_guid uniqueidentifier not null,
                            row_idx int identity(1, 1) primary key);
    merge dbo.staging_tbl as stg
    using (   select      i.item,
                          i.row_guid as item_row_guid,
                          pc.group_code as [group_code],
                          isnull(case
                                      when ga.row_guid is not null then ga.qty_avail_a
                                      else sa.qty_avail end,
                                 0.00) as qty_avail_in_stock,
                          case
                               when ga.row_guid is not null then isnull(ga.qty_avail_b, 0.00)
                               else null end as [qty_avail_pending],
                          ga.next_avail as [next_avail],
                          isnull(ga.flag_a, 0) as [special_flag]
                from      item_source_tbl as i with (readuncommitted)
               inner join group_code_mst as pc with (readuncommitted)
                  on i.group_code = pc.group_code
                 and i.tenant_id  = pc.tenant_id
                left join staging_source_a as sa with (readuncommitted)
                  on sa.item      = i.item
                left join staging_source_b as ga with (readuncommitted)
                  on ga.item      = i.item
               where      i.group_code is not null
                 and      pc.group_code is not null
                 and      not (   sa.row_guid is null
                            and   ga.row_guid is null)) as stage
       on stg.item = stage.item
     when matched and not (   stg.group_code = stage.group_code
                        and   isnull(stg.qty_avail_pending, 0.00) = isnull(stage.qty_avail_pending, 0.00)
                        and   isnull(stg.next_avail, nchar(1)) = isnull(stage.next_avail, nchar(1))
                        and   stg.qty_avail_in_stock = isnull(stage.qty_avail_in_stock, 0.00)
                        and   stg.item_row_guid = stage.item_row_guid) then
        update set stg.group_code = stage.group_code,
                   stg.qty_avail_pending = stage.qty_avail_pending,
                   stg.qty_avail_in_stock = stage.qty_avail_in_stock,
                   stg.next_avail = stage.next_avail,
                   stg.item_row_guid = stage.item_row_guid,
                   stg.record_date = @today,
                   stg.updated_by = @user_name
     when not matched then
        insert ([item],
                [item_row_guid],
                [group_code],
                [qty_avail_in_stock],
                [qty_avail_pending],
                [next_avail],
                [create_date],
                [record_date],
                [created_by],
                [updated_by])
        values (stage.item, stage.item_row_guid, stage.group_code, stage.qty_avail_in_stock, stage.qty_avail_pending,
                stage.next_avail, @today, @today, @user_name, @user_name)
    output $action as change_type,
           isnull(Inserted.item_row_guid, Deleted.item_row_guid)
    into @changes (change_type,
                   row_guid);
    delete s
    output N'Delete',
           deleted.item_row_guid
    into @changes (change_type,
                   row_guid)
      from staging_tbl as s
     where not exists (   select 1
                            from staging_source_b as ga with (readuncommitted)
                           where ga.item = s.item
                          union all
                          select 1
                            from staging_source_a as sa with (readuncommitted)
                           where sa.item = s.item);
    declare @row_guid  RowPointerType,
            @row_index int,
            @action    SampleActionType;
    while exists (select 1 from @changes as c)
    begin
        select top (1) @row_index = c.row_idx,
                       @row_guid = c.row_guid,
                       @action = c.change_type
          from @changes as c
         order by c.row_idx asc;
        if @row_index is null
            break;
        execute dbo.manual_sync_sp @collection = N'SampleItems',
                                   @row_guid = @row_guid,
                                   @action = @action,
                                   @calling_object = @object_name,
                                   @result = null,
                                   @infobar = null;
        delete c
          from @changes as c
         where row_idx = @row_index;
        set @row_index = null;
    end;
    return @severity;
end;
go
