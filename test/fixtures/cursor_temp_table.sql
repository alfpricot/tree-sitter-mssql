use [tier2_sample_db];
go
set ansi_nulls, quoted_identifier on;
go
if not exists (   select 1
                    from sys.objects as o
                   where o.[object_id] = object_id('[dbo].[cursor_walk_sp]')
                     and o.[type] in ( N'P', N'PC' ))
begin
    execute dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[cursor_walk_sp] AS';
end;
go
alter procedure [dbo].[cursor_walk_sp] (
@i_form_name as nvarchar(50),
@i_value1 as nvarchar(40),
@i_value2 as nvarchar(40),
@i_value3 as nvarchar(40),
@o_path1 as nvarchar(500) output,
@o_path2 as nvarchar(500) output,
@o_path3 as nvarchar(500) output)
as
begin
    declare @l_ref1 as nvarchar(40);
    declare @l_ref2 as nvarchar(40);
    declare @l_refsize1 as int;
    declare @l_refsize2 as int;
    declare @l_description as nvarchar(40);
    declare @l_filename as nvarchar(max);
    declare @l_subdir as bit;
    declare @l_replace as nvarchar(42);
    declare @l_module as nvarchar(30);
    declare @l_count as int;
    set @l_count = 1;
    create table #walk_rules (path nvarchar(2000));
    declare @l_debug_print as bit;
    select @l_ref1 = reference_1,
           @l_ref2 = reference_2,
           @l_refsize1 = reference_1size,
           @l_refsize2 = reference_2size
      from sample_master as m
     where m.form = @i_form_name;
    declare walk_cursor cursor for
    select      distinct v.[description],
                         v.[filename],
                         v.recursive
      from      sample_detail as v
     inner join sample_master as m
        on m.mod = v.mod
     where      m.form         = @i_form_name
       and      isnull(v.type, 'F') = 'F';
    open walk_cursor;
    fetch next from walk_cursor
     into @l_description,
          @l_filename,
          @l_subdir;
    while (@@fetch_status = 0)
    begin
        if (@l_debug_print = 1)
        begin
            print 'IN THE WALK_CURSOR LOOP';
        end;
        select @l_replace = reference_1
          from sample_master as m
         where m.form = @i_form_name;
        if @l_replace is not null
        begin
            set @l_replace = N'<' + @l_replace + N'>';
            select @l_filename = replace(@l_filename, @l_replace, ltrim(rtrim(@i_value1)));
        end;
        select @l_module = mod
          from sample_master as m
         where m.form = @i_form_name;
        exec sample_search_replace_sp @l_module,
                                      @i_value1,
                                      @i_value2,
                                      @i_value3,
                                      @l_filename,
                                      @l_filename output;
        set @l_subdir = isnull(@l_subdir, 0);
        if @l_count = 1
            set @o_path1 = cast(@l_subdir as nvarchar(1)) + @l_filename;
        if @l_count = 2
            set @o_path2 = cast(@l_subdir as nvarchar(1)) + @l_filename;
        if @l_count = 3
            set @o_path3 = cast(@l_subdir as nvarchar(1)) + @l_filename;
        set @l_count = @l_count + 1;
        fetch next from walk_cursor
         into @l_description,
              @l_filename,
              @l_subdir;
    end;
    close walk_cursor;
    deallocate walk_cursor;
end;
go
