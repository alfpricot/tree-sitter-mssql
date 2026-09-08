// T-SQL UPDATE:
//
//   UPDATE [TOP (n)] target [WITH (hints)] SET assignments [OUTPUT ...] [FROM ...] [WHERE ...]
//
// `target` is usually a table (optionally aliased) but T-SQL also lets it be
// the alias of a relation introduced in the FROM clause
// (`UPDATE t SET ... FROM dbo.tbl AS t JOIN ...`), which is why the target
// is a full relation rather than a bare object reference. `from` already
// carries its own optional WHERE, so a standalone WHERE is only offered when
// there is no FROM.
export default {

  _update_statement: $ => $.update,

  update: $ => prec.right(seq(
    $.keyword_update,
    optional($.top_clause),
    $._relation_with_hint,
    $._set_values,
    optional($.output_clause),
    optional(choice($.from, $.where)),
  )),

};
