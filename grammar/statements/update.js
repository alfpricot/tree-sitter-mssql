// T-SQL UPDATE:
//
//   UPDATE [TOP (n)] target [WITH (hints)] SET assignments [OUTPUT ...] [FROM ...]
//     [WHERE ...] [OPTION (...)]
//
// `target` is usually a table (optionally aliased) but T-SQL also lets it be
// the alias of a relation introduced in the FROM clause
// (`UPDATE t SET ... FROM dbo.tbl AS t JOIN ...`), which is why the target
// is a full relation rather than a bare object reference. Unlike SELECT,
// UPDATE never takes GROUP BY/HAVING/ORDER BY/OFFSET FETCH — OPTION is the
// only one of `from`'s former trailing clauses real T-SQL allows here.
export default {

  _update_statement: $ => $.update,

  update: $ => prec.right(seq(
    $.keyword_update,
    optional($.top_clause),
    $._relation_with_hint,
    $._set_values,
    optional($.output_clause),
    optional($.from),
    optional($.where),
    optional($.option_clause),
  )),

};
