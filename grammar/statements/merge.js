import { optional_parenthesis, paren_list, comma_list } from "../helpers.js";

// T-SQL MERGE:
//
//   MERGE [TOP (n)] [INTO] target [WITH (hints)] [[AS] alias]
//     USING source [[AS] alias [(columns)]]
//     ON predicate
//     { WHEN [NOT] MATCHED [BY TARGET | BY SOURCE] [AND predicate] THEN action } [...]
//     [OUTPUT ...] [OPTION (...)]
export default {

  _merge_statement: $ => $.merge,

  merge: $ => seq(
    $.keyword_merge,
    optional($.top_clause),
    optional($.keyword_into),
    $.object_reference,
    optional($.table_hint),
    optional($._alias),
    $.keyword_using,
    choice(
      $.subquery,
      $.invocation,
      $.object_reference,
    ),
    optional($.table_hint),
    optional(seq($._alias, optional(alias($._column_list, $.list)))),
    $.keyword_on,
    optional_parenthesis(field("predicate", $._expression)),
    repeat1($.merge_when_clause),
    optional($.output_clause),
    optional($.option_clause),
  ),

  merge_when_clause: $ => prec.left(seq(
    $.keyword_when,
    optional($.keyword_not),
    $.keyword_matched,
    optional(
      seq(
        $.keyword_by,
        choice($.keyword_target, $.keyword_source),
      )
    ),
    optional(
      seq(
        $.keyword_and,
        optional_parenthesis(field("predicate", $._expression))
      )
    ),
    $.keyword_then,
    choice(
      $.keyword_delete,
      seq(
        $.keyword_update,
        $._set_values,
      ),
      seq(
        $.keyword_insert,
        optional(alias($._column_list, $.list)),
        choice(
          seq($.keyword_values, comma_list($.list, true)),
          seq($.keyword_default, $.keyword_values),
        ),
      ),
    )
  )),

};
