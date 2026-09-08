BEGIN
    INSERT INTO dbo.DocProfileCustomer_mst ([site_ref],
                                            [CustNum],
                                            [CustSeq],
                                            [Device],
                                            [Description],
                                            [NumCopies],
                                            [ErrorMessage],
                                            [CanOverride],
                                            [Method],
                                            [active],
                                            [RptName],
                                            [Destination],
                                            [CoverSheetContact],
                                            [CoverSheetCompany])
    SELECT 'MAIN' as site_ref,
           [CustNum],
           [CustSeq],
           [Device],
           [Description],
           [NumCopies],
           [ErrorMessage],
           [CanOverride],
           [Method],
           1 as active,
           [RptName],
           'invoices@example.com' as destination,
           [CoverSheetContact],
           [CoverSheetCompany]
      FROM [AppDB].[dbo].[DocProfileCustomer_mst] AS src
     WHERE RptName = 'Order Invoicing/Credit Memo'
       AND Not EXISTS (   SELECT 1
                            from DocProfileCustomer_mst with (nolock)
                           where DocProfileCustomer_mst.custNum     = src.custNum
                             AND DocProfileCustomer_mst.custseq     = src.custseq
                             and DocProfileCustomer_mst.Destination = 'invoices@example.com');
    INSERT INTO dbo.DocProfileCustomer_mst ([site_ref],
                                            [CustNum],
                                            [CustSeq],
                                            [Device],
                                            [Description],
                                            [NumCopies],
                                            [ErrorMessage],
                                            [CanOverride],
                                            [Method],
                                            [active],
                                            [RptName],
                                            [Destination],
                                            [CoverSheetContact],
                                            [CoverSheetCompany])
    SELECT DISTINCT 'MAIN' as site_ref,
                    [Cust_Num],
                    [Cust_Seq],
                    NULL,
                    'Invoice/credit',
                    1,
                    NULL,
                    0,
                    'E',
                    1 as active,
                    'Order Invoicing/Credit Memo',
                    'invoices@example.com' as destination,
                    NULL,
                    NULL
      FROM [AppDB].[dbo].[Customer_mst] AS src
     WHERE Not EXISTS (   SELECT 1
                            from DocProfileCustomer_mst with (nolock)
                           where DocProfileCustomer_mst.custNum     = src.cust_Num
                             AND DocProfileCustomer_mst.custseq     = src.cust_seq
                             and DocProfileCustomer_mst.Destination = 'invoices@example.com')
       AND cust_num like 'C%'
       AND cust_num > dbo.ExpandKyByType('CustNumType', 'C000009');
    INSERT INTO dbo.DocProfileCustomer_mst ([site_ref],
                                            [CustNum],
                                            [CustSeq],
                                            [Device],
                                            [Description],
                                            [NumCopies],
                                            [ErrorMessage],
                                            [CanOverride],
                                            [Method],
                                            [active],
                                            [RptName],
                                            [Destination],
                                            [CoverSheetContact],
                                            [CoverSheetCompany])
    SELECT DISTINCT 'MAIN' as site_ref,
                    [Cust_Num],
                    [Cust_Seq],
                    NULL,
                    'Invoice/credit',
                    1,
                    NULL,
                    0,
                    'E',
                    1 as active,
                    'Order Invoicing/Credit Memo',
                    'invoices@example.com' as destination,
                    NULL,
                    NULL
      FROM [AppDB].[dbo].[Customer_mst] AS src
     WHERE Not EXISTS (   SELECT 1
                            from DocProfileCustomer_mst with (nolock)
                           where DocProfileCustomer_mst.custNum     = src.cust_Num
                             AND DocProfileCustomer_mst.custseq     = src.cust_seq
                             and DocProfileCustomer_mst.Destination = 'invoices@example.com')
       AND cust_num like 'M%'
       AND cust_num <> dbo.ExpandKyByType('CustNumType', 'MOC2004');
END;
