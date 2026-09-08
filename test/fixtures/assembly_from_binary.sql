IF NOT EXISTS (   SELECT *
                    FROM sys.assemblies AS asms
                   WHERE asms.name       = N'Replication'
                     and is_user_defined = 1)
    CREATE ASSEMBLY [Replication]
    FROM 0x4D5A90000300000004000000FFFF0000B800000000000000400000000000000000000000000000000000000000000000
    WITH PERMISSION_SET = EXTERNAL_ACCESS;

