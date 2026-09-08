-- bp017_delete_with_left_outer_hash_join_and_no_where_triggers
DELETE                 t
  FROM                 dbo.T AS t
  LEFT OUTER HASH JOIN dbo.U AS u
    ON u.Id = t.Id;
GO
