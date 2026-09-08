CREATE view [dbo].[ServiceTypeView]
as
select [site_ref],
       [serv_type],
       [description],
       [waiver_charge],
       [prior_code],
       [charfld1],
       [charfld2],
       [charfld3],
       [datefld],
       [decifld1],
       [decifld2],
       [decifld3],
       [logifld],
       [NoteExistsFlag],
       [RecordDate],
       [RowPointer],
       [CreatedBy],
       [UpdatedBy],
       [CreateDate],
       [InWorkflow]
  FROM [dbo].[fs_serv_type_mst];

