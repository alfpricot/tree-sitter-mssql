use [tier2_sample_db];
go
set ansi_nulls, quoted_identifier on;
go
if not exists (   select 1
                    from sys.objects as o
                   where o.[object_id] = object_id('[dbo].[validate_link_sp]')
                     and o.[type] in ( N'P', N'PC' ))
begin
    execute dbo.sp_executesql @statement = N'CREATE PROCEDURE [dbo].[validate_link_sp] AS';
end;
go
alter procedure [dbo].[validate_link_sp] (
@linked_server_name OSLocationType,
@infobar InfobarType output,
@tenant TenantType = null)
as
if object_id(N'dbo.EXTGEN_validate_link_sp') is not null
begin
    declare @extgen_sp_name sysname;
    set @extgen_sp_name = N'dbo.EXTGEN_validate_link_sp';
    declare @extgen_severity int;
    exec @extgen_severity = @extgen_sp_name @linked_server_name,
                                            @infobar output,
                                            @tenant;
    if @extgen_severity <> 1
        return @extgen_severity;
end;
declare @severity int;
set @severity = 0;
declare @app_db_name OSLocationType,
        @sql         nvarchar(max);
select @app_db_name = app_db_name
  from tenant_mst
 where tenant_id = @tenant;
if @app_db_name is not null
begin
    if @linked_server_name = 'localhost'
        set @sql
            = N'DECLARE @Tenant SYSNAME SELECT TOP 1 @Tenant = tenant_id FROM ' + quotename(@app_db_name)
              + N'.dbo.tenant_mst ';
    else
        set @sql
            = N'DECLARE @Tenant SYSNAME SELECT TOP 1 @Tenant = tenant_id FROM ' + quotename(@linked_server_name) + N'.'
              + quotename(@app_db_name) + N'.dbo.tenant_mst ';
    begin try
        execute sys.sp_executesql @sql;
    end try
    begin catch
        execute @severity = dbo.MsgAppSp @infobar output,
                                         'E=NoExist',
                                         '@tenant.app_db_name',
                                         '@link.linked_server_name',
                                         @linked_server_name,
                                         '@tenant.app_db_name',
                                         @app_db_name;
        execute @severity = dbo.MsgAppSp @infobar output, 'E=ContactSysAdmin';
    end catch;
end;
return @severity;
go
