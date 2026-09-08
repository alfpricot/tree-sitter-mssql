CREATE FUNCTION dbo.example_needs_bom (@job_id job_id_type,
                                       @suffix suffix_type)
RETURNS flag_type
AS
begin
    declare @f flag_type;
    set @f = case
                  when exists (   select *
                                    from jobs WITH (READUNCOMMITTED)
                                    join items WITH (READUNCOMMITTED)
                                      on items.item = jobs.item
                                   where jobs.job    = @job_id
                                     and jobs.suffix = @suffix
                                     and jobs.type not in ( 'S', 'A', 'B' )
                                     and jobs.stat not in ( 'C', 'H' )
                                     and items.stat  <> 'O') then 1
                  else 0 end;
    return @f;
end;
