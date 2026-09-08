// T-SQL DELETE:
//
//   DELETE [TOP (n)] [FROM] target [WITH (hints)] [OUTPUT ...] [FROM ... joins] [WHERE ...]
//
// `target` is a table, a table variable, or the alias of a relation in the
// second FROM clause (`DELETE t FROM dbo.tbl AS t JOIN ...`). `from` already
// carries its own optional WHERE, so a standalone WHERE is only offered when
// there is no FROM.
export default {

  _delete_statement: $ => $.delete,

  delete: $ => prec.right(seq(
    $.keyword_delete,
    optional($.top_clause),
    optional($.keyword_from),
    $.object_reference,
    optional($.table_hint),
    optional($.output_clause),
    optional(choice($.from, $.where)),
  )),

};
