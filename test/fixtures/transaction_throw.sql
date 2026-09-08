use [tier2_sample_db];
go
set ansi_nulls, quoted_identifier on;
go
if not exists (   select 1
                    from sys.objects as o
                   where o.[object_id] = object_id('[dbo].[catalog_line_sp]')
                     and o.[type] in ( N'P', N'PC' ))
begin
    execute dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[catalog_line_sp] AS';
end;
go
alter procedure [dbo].[catalog_line_sp] (
@line_row_guid RowPointerType,
@error_severity int output)
as
begin
    declare @item_row_guid RowPointerType,
            @item          nvarchar(30),
            @item_um       nvarchar(10);
    set @error_severity = 0;
    begin transaction;
    begin try
        set @item_row_guid = null;
        select @item_row_guid = row_guid,
               @item = item.item,
               @item_um = item.u_m
          from item
         where item.row_guid = @line_row_guid;
        if @item_row_guid is null
        begin
            raiserror(N'Referenced item was not found.', 16, 1) with log;
        end;
        update catalog_line
           set item_row_guid = @item_row_guid,
               item_um = @item_um
         where row_guid = @line_row_guid;
    end try
    begin catch
        throw;
        rollback transaction;
    end catch;
    if @error_severity = 0
    begin
        commit transaction;
    end;
    return @error_severity;
end;
go
