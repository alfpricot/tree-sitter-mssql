IF NOT EXISTS (   SELECT *
                    FROM sysfulltextcatalogs AS ftc
                   WHERE ftc.name = N'DocumentsCatalog')
    CREATE FULLTEXT CATALOG [DocumentsCatalog]
    WITH ACCENT_SENSITIVITY = ON;

