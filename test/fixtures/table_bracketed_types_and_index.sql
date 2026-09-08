use [tier2_sample_db];
go

set ansi_nulls, quoted_identifier on;
go

if not exists (   select 1
                    from sys.objects as o
                   where o.[object_id] = object_id(N'[dbo].[bracketed_types_tbl]', N'U')
                     and o.[type]      = N'U')
begin
    create table [dbo].[bracketed_types_tbl] ([tenant_id] [dbo].[TenantType] not null,
                                              [created_by] [dbo].[UsernameType] not null,
                                              [updated_by] [dbo].[UsernameType] not null,
                                              [create_date] [dbo].[CurrentDateType] not null,
                                              [record_date] [dbo].[CurrentDateType] not null,
                                              [row_guid] [dbo].[RowPointerType] not null,
                                              [note_flag] [dbo].[FlagNyType] not null,
                                              [in_workflow] [dbo].[FlagNyType] not null,
                                              [plugin_name] [nvarchar](40) collate SQL_Latin1_General_CP1_CI_AS not null,
                                              [owner_name] [nvarchar](30) collate SQL_Latin1_General_CP1_CI_AS null,
                                              [group_code] [nvarchar](6) collate SQL_Latin1_General_CP1_CI_AS null,
                                              [shift_code] [nvarchar](3) collate SQL_Latin1_General_CP1_CI_AS null,
                                              [ref_num] [nvarchar](7) collate SQL_Latin1_General_CP1_CI_AS null,
                                              [station_name] [nvarchar](50) collate SQL_Latin1_General_CP1_CI_AS null,
                                              [login_name] [nvarchar](100) collate SQL_Latin1_General_CP1_CI_AS null,
                                              [domain_name] [nvarchar](256) collate SQL_Latin1_General_CP1_CI_AS null,
                                              [text_field_1] [nvarchar](max) collate SQL_Latin1_General_CP1_CI_AS null,
                                              [text_field_2] [nvarchar](max) collate SQL_Latin1_General_CP1_CI_AS null,
                                              [amount_1] [decimal](10, 2) null,
                                              [amount_2] [decimal](10, 2) null,
                                              [amount_3] [decimal](18, 4) null,
                                              [event_date_1] [datetime] null,
                                              [event_date_2] [datetime] null,
                                              [flag_1] [tinyint] null,
                                              [flag_2] [tinyint] null,
                                              [enabled] [tinyint] null,
                                              constraint [PK_bracketed_types_tbl]
                                                  primary key clustered ([tenant_id] asc, [row_guid] asc)
                                                  with (pad_index = off, statistics_norecompute = off,
                                                        ignore_dup_key = off, allow_row_locks = on,
                                                        allow_page_locks = on) on [PRIMARY]) on [PRIMARY] textimage_on [PRIMARY];
end;
go

set ansi_padding on;
go

if not exists (   select 1
                    from sys.indexes as i
                   where i.[object_id] = object_id(N'[dbo].[bracketed_types_tbl]', N'U')
                     and i.[name]      = N'IX_bracketed_types_tbl_guid_tenant')
    create unique nonclustered index [IX_bracketed_types_tbl_guid_tenant]
    on [dbo].[bracketed_types_tbl] ([row_guid] asc, [tenant_id] asc)
    with (pad_index = off, statistics_norecompute = off, sort_in_tempdb = off, ignore_dup_key = off,
          drop_existing = off, online = off, allow_row_locks = on, allow_page_locks = on, fillfactor = 90)
    on [PRIMARY];
go

if not exists (   select 1
                    from sys.objects as o
                   where o.[object_id] = object_id('[dbo].[DF_bracketed_types_tbl_tenant_id]', N'D')
                     and o.[type]      = N'D')
begin
    alter table [dbo].[bracketed_types_tbl]
    add constraint [DF_bracketed_types_tbl_tenant_id]
        default (rtrim(convert([nvarchar](8), context_info(), (0)))) for [tenant_id];
end;
go

if not exists (   select 1
                    from sys.objects as o
                   where o.[object_id] = object_id('[dbo].[DF_bracketed_types_tbl_created_by]', N'D')
                     and o.[type]      = N'D')
begin
    alter table [dbo].[bracketed_types_tbl]
    add constraint [DF_bracketed_types_tbl_created_by]
        default (suser_sname()) for [created_by];
end;
go

if not exists (   select 1
                    from sys.objects as o
                   where o.[object_id] = object_id('[dbo].[DF_bracketed_types_tbl_create_date]', N'D')
                     and o.[type]      = N'D')
begin
    alter table [dbo].[bracketed_types_tbl]
    add constraint [DF_bracketed_types_tbl_create_date]
        default (getdate()) for [create_date];
end;
go

if not exists (   select 1
                    from sys.objects as o
                   where o.[object_id] = object_id('[dbo].[DF_bracketed_types_tbl_row_guid]', N'D')
                     and o.[type]      = N'D')
begin
    alter table [dbo].[bracketed_types_tbl]
    add constraint [DF_bracketed_types_tbl_row_guid]
        default (newid()) for [row_guid];
end;
go

if not exists (   select 1
                    from sys.objects as o
                   where o.[object_id] = object_id('[dbo].[DF_bracketed_types_tbl_note_flag]', N'D')
                     and o.[type]      = N'D')
begin
    alter table [dbo].[bracketed_types_tbl]
    add constraint [DF_bracketed_types_tbl_note_flag]
        default ((0)) for [note_flag];
end;
go
