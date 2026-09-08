import { comma_list, paren_list } from "../helpers.js";

// T-SQL INSERT:
//
//   INSERT [TOP (n)] [INTO] table [WITH (hints)] [(columns)] [OUTPUT ...]
//     { VALUES (...) [, ...] | select | EXEC ... | DEFAULT VALUES }
export default {

  _insert_statement: $ => $.insert,

  insert: $ => seq(
    $.keyword_insert,
    optional($.top_clause),
    optional($.keyword_into),
    $.object_reference,
    optional($.table_hint),
    optional(alias($._column_list, $.list)),
    optional($.output_clause),
    $._insert_source,
  ),

  _insert_source: $ => choice(
    seq(
      $.keyword_values,
      comma_list($.list, true),
    ),
    $._dml_read,
    $.execute_statement,
    seq($.keyword_default, $.keyword_values),
  ),

  // OUTPUT term [, ...] [INTO table [(columns)]] — on INSERT, UPDATE, DELETE
  // and MERGE. The terms reference the `inserted`/`deleted` pseudo-tables
  // and `$action`, all of which are ordinary identifiers here.
  output_clause: $ => seq(
    $.keyword_output,
    comma_list($.term, true),
    optional(
      seq(
        $.keyword_into,
        $.object_reference,
        optional(paren_list($.identifier, true)),
      ),
    ),
  ),

  assignment: $ => seq(
    field('left',
      alias(
        $._qualified_field,
        $.field,
      ),
    ),
    $.assignment_operator,
    field('right', $._expression),
  ),

  // An item is an assignment or a bare method call with no `=`, which is
  // how the xml and json `.modify()` mutators are applied to a column:
  //   UPDATE t SET x.modify('insert ...')
  _set_values: $ => seq(
    $.keyword_set,
    comma_list(choice($.assignment, $.invocation), true),
  ),

}
