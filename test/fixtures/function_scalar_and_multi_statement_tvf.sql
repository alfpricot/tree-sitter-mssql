use [example_db];
go
if exists (   select 1
                from sys.objects as o
               where o.[object_id] = object_id(N'[dbo].[example_scalar_fn]')
                 and o.[type] in ( N'FN', N'IF', N'FS', N'FT' ))
    drop function [dbo].[example_scalar_fn];
go
create function dbo.example_scalar_fn ()
returns flag_type
as
begin
    declare @flag flag_type;
    set @flag = 1;
    if exists (   select            1
                    from            parent_mst as s1
                    left outer join child_mst as i1
                      on s1.zone_name = i1.zone_name
                   where            isnull(i1.is_external, 0) = 0)
        set @flag = 0;
    return @flag;
end;
go
create function dbo.example_tvf (@computer_name nvarchar(50),
                                 @user_name nvarchar(50))
returns @result table (row_id uniqueidentifier,
                       name nvarchar(50))
as
begin
    insert into @result (row_id, name)
    select      e.row_id,
                e.name
      from      employee as e with (readuncommitted)
     inner join transfer as t with (readuncommitted)
        on t.emp_num = e.emp_num
     where      t.computer_name = @computer_name
       and      t.locked_by     = @user_name;
    return;
end;
go
