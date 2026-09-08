SET ANSI_NULLS ON;
SET QUOTED_IDENTIFIER ON;
IF NOT EXISTS (   SELECT *
                    FROM sys.objects
                   WHERE object_id = OBJECT_ID(N'[dbo].[cust_export_HJ_Orders]')
                     AND type in ( N'U' ))
BEGIN
    CREATE TABLE [dbo].[cust_export_HJ_Orders] ([hj_instance_id] [bigint] IDENTITY(1, 1) NOT NULL,
                                                [stat] [nvarchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
                                                [wh_id] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
                                                [order_number] [nvarchar](30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
                                                [hj_type_id] [int] NULL,
                                                [customer_id] [nvarchar](30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
                                                [cust_po_number] [nvarchar](30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
                                                [customer_name] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
                                                [customer_phone] [nvarchar](30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
                                                [customer_fax] [nvarchar](30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
                                                [customer_email] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
                                                [priority] [nvarchar](3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
                                                [order_date] [datetime] NULL,
                                                [date_expected] [datetime] NULL,
                                                [promised_date] [datetime] NULL,
                                                [backorder] [nvarchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
                                                [bill_to_code] [nvarchar](15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
                                                [bill_to_name] [nvarchar](60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
                                                [bill_to_addr1] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
                                                [bill_to_addr2] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
                                                [bill_to_addr3] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
                                                [bill_to_city] [nvarchar](30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
                                                [bill_to_state] [nvarchar](3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
                                                [bill_to_zip] [nvarchar](12) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
                                                [bill_to_country_code] [nvarchar](5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
                                                [bill_to_country_name] [nvarchar](30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
                                                [bill_to_phone] [nvarchar](30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
                                                [ship_to_code] [nvarchar](15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
                                                [ship_to_name] [nvarchar](60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
                                                [ship_to_addr1] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
                                                [ship_to_addr2] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
                                                [ship_to_addr3] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
                                                [ship_to_city] [nvarchar](30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
                                                [ship_to_state] [nvarchar](3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
                                                [ship_to_zip] [nvarchar](12) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
                                                [ship_to_country_code] [nvarchar](5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
                                                [ship_to_country_name] [nvarchar](30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
                                                [ship_to_phone] [nvarchar](30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
                                                [return_to_code] [nvarchar](30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
                                                [return_to_name] [nvarchar](60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
                                                [return_to_addr1] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
                                                [return_to_addr2] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
                                                [return_to_addr3] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
                                                [return_to_city] [nvarchar](30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
                                                [return_to_state] [nvarchar](3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
                                                [return_to_zip] [nvarchar](12) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
                                                [return_to_country_code] [nvarchar](5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
                                                [return_to_country_name] [nvarchar](30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
                                                [return_to_phone] [nvarchar](30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
                                                [status] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
                                                [zone] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
                                                [partial_order_flag] [nvarchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
                                                [actual_ship_date] [datetime] NULL,
                                                [order_number_ext] [nvarchar](30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
                                                [comment] [nvarchar](250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
                                                [direct_ship_order] [int] NULL,
                                                [customer_po_number] [nvarchar](30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
                                                [CreateDate] [dbo].[CurrentDateType] NOT NULL,
                                                [CreatedBy] [dbo].[UsernameType] NOT NULL,
                                                [InWorkflow] [dbo].[FlagNyType] NOT NULL,
                                                [NoteExistsFlag] [dbo].[FlagNyType] NOT NULL,
                                                [RecordDate] [dbo].[CurrentDateType] NOT NULL,
                                                [RowPointer] [dbo].[RowPointerType] NOT NULL,
                                                [UpdatedBy] [dbo].[UsernameType] NOT NULL,
                                                [bill_frght_to_code] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
                                                [au_flag] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
                                                [saturday_delivery] [dbo].[ListYesNoType] NULL,
                                                [signature_required] [dbo].[ListYesNoType] NULL) ON [PRIMARY];
END;
SET ANSI_PADDING ON;

IF NOT EXISTS (   SELECT *
                    FROM sys.indexes
                   WHERE object_id = OBJECT_ID(N'[dbo].[cust_export_HJ_Orders]')
                     AND name      = N'IX_cust_export_HJ_Orders_Stat')
    CREATE NONCLUSTERED INDEX [IX_cust_export_HJ_Orders_Stat]
    ON [dbo].[cust_export_HJ_Orders] ([stat] DESC)
    WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF,
          ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
    ON [PRIMARY];
IF NOT EXISTS (   SELECT *
                    FROM sys.objects
                   WHERE object_id = OBJECT_ID(N'[dbo].[DF_cust_export_HJ_Orders_CreateDate]')
                     AND type      = 'D')
BEGIN
    ALTER TABLE [dbo].[cust_export_HJ_Orders]
    ADD CONSTRAINT [DF_cust_export_HJ_Orders_CreateDate]
        DEFAULT (getdate()) FOR [CreateDate];
END;

IF NOT EXISTS (   SELECT *
                    FROM sys.objects
                   WHERE object_id = OBJECT_ID(N'[dbo].[DF_cust_export_HJ_Orders_CreatedBy]')
                     AND type      = 'D')
BEGIN
    ALTER TABLE [dbo].[cust_export_HJ_Orders]
    ADD CONSTRAINT [DF_cust_export_HJ_Orders_CreatedBy]
        DEFAULT (suser_sname()) FOR [CreatedBy];
END;

IF NOT EXISTS (   SELECT *
                    FROM sys.objects
                   WHERE object_id = OBJECT_ID(N'[dbo].[DF_cust_export_HJ_Orders_InWorkflow]')
                     AND type      = 'D')
BEGIN
    ALTER TABLE [dbo].[cust_export_HJ_Orders]
    ADD CONSTRAINT [DF_cust_export_HJ_Orders_InWorkflow]
        DEFAULT ((0)) FOR [InWorkflow];
END;

IF NOT EXISTS (   SELECT *
                    FROM sys.objects
                   WHERE object_id = OBJECT_ID(N'[dbo].[DF_cust_export_HJ_Orders_NoteExistsFlag]')
                     AND type      = 'D')
BEGIN
    ALTER TABLE [dbo].[cust_export_HJ_Orders]
    ADD CONSTRAINT [DF_cust_export_HJ_Orders_NoteExistsFlag]
        DEFAULT ((0)) FOR [NoteExistsFlag];
END;

IF NOT EXISTS (   SELECT *
                    FROM sys.objects
                   WHERE object_id = OBJECT_ID(N'[dbo].[DF_cust_export_HJ_Orders_RecordDate]')
                     AND type      = 'D')
BEGIN
    ALTER TABLE [dbo].[cust_export_HJ_Orders]
    ADD CONSTRAINT [DF_cust_export_HJ_Orders_RecordDate]
        DEFAULT (getdate()) FOR [RecordDate];
END;

IF NOT EXISTS (   SELECT *
                    FROM sys.objects
                   WHERE object_id = OBJECT_ID(N'[dbo].[DF_cust_export_HJ_Orders_RowPointer]')
                     AND type      = 'D')
BEGIN
    ALTER TABLE [dbo].[cust_export_HJ_Orders]
    ADD CONSTRAINT [DF_cust_export_HJ_Orders_RowPointer]
        DEFAULT (newid()) FOR [RowPointer];
END;

IF NOT EXISTS (   SELECT *
                    FROM sys.objects
                   WHERE object_id = OBJECT_ID(N'[dbo].[DF_cust_export_HJ_Orders_UpdatedBy]')
                     AND type      = 'D')
BEGIN
    ALTER TABLE [dbo].[cust_export_HJ_Orders]
    ADD CONSTRAINT [DF_cust_export_HJ_Orders_UpdatedBy]
        DEFAULT (suser_sname()) FOR [UpdatedBy];
END;

IF NOT EXISTS (   SELECT *
                    FROM sys.objects
                   WHERE object_id = OBJECT_ID(N'[dbo].[DF_cust_export_HJ_Orders_saturday_delivery]')
                     AND type      = 'D')
BEGIN
    ALTER TABLE [dbo].[cust_export_HJ_Orders]
    ADD CONSTRAINT [DF_cust_export_HJ_Orders_saturday_delivery]
        DEFAULT ((0)) FOR [saturday_delivery];
END;

IF NOT EXISTS (   SELECT *
                    FROM sys.objects
                   WHERE object_id = OBJECT_ID(N'[dbo].[DF_cust_export_HJ_Orders_signature_required]')
                     AND type      = 'D')
BEGIN
    ALTER TABLE [dbo].[cust_export_HJ_Orders]
    ADD CONSTRAINT [DF_cust_export_HJ_Orders_signature_required]
        DEFAULT ((0)) FOR [signature_required];
END;

