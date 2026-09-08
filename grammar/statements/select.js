import { comma_list, optional_parenthesis, paren_list, wrapped_in_parenthesis } from "../helpers.js";

export default {

  // WITH [XMLNAMESPACES (...) ,] cte [, ...] — the namespace declaration
  // goes first, where a CTE list starts, and may be followed by CTEs.
  _cte: $ => seq(
      $.keyword_with,
      choice(
        seq($.xmlnamespaces, repeat(seq(',', $.cte))),
        seq($.cte, repeat(seq(',', $.cte))),
      ),
  ),

  // XMLNAMESPACES ('uri' AS prefix [, ...] [, DEFAULT 'uri']) — declares
  // the prefixes the query's XQuery methods use.
  xmlnamespaces: $ => seq(
    $.keyword_xmlnamespaces,
    paren_list($.xmlnamespace, true),
  ),

  xmlnamespace: $ => choice(
    seq(field('uri', $.literal), $.keyword_as, field('prefix', $.identifier)),
    seq($.keyword_default, field('uri', $.literal)),
  ),

  cte: $ => seq(
    $.identifier,
    optional(paren_list(field("argument", $.identifier))),
    $.keyword_as,
    wrapped_in_parenthesis(
      alias($._dml_read, $.statement),
    ),
  ),

  set_operation: $ => seq(
    $._select_statement,
    repeat1(
      seq(
        field(
          "operation",
          choice(
            seq($.keyword_union, optional($.keyword_all)),
            $.keyword_except,
            $.keyword_intersect,
          ),
        ),
        $._select_statement,
      ),
    ),
  ),

  // SELECT ... [INTO new_table] [FROM ...] [FOR XML ... | FOR JSON ... | FOR UPDATE]
  _select_statement: $ => optional_parenthesis(
    seq(
      $.select,
      optional(
        seq(
          $.keyword_into,
          $.object_reference,
        ),
      ),
      optional($.from),
      optional($.for_clause),
    ),
  ),

  select: $ => seq(
    $.keyword_select,
    // `SELECT ALL` is not accepted: ALL is also a unary operator
    // (`= ALL (subquery)`), and `SELECT ALL x` is ambiguous between the two.
    optional($.keyword_distinct),
    optional($.top_clause),
    $.select_expression,
  ),

  // T-SQL TOP: `TOP (expression)` or the legacy bare `TOP n`, optionally
  // `PERCENT` and `WITH TIES`. The bare form takes only a natural number,
  // which is all SQL Server accepts there.
  top_clause: $ => seq(
    $.keyword_top,
    choice(
      wrapped_in_parenthesis($._expression),
      alias($._natural_number, $.literal),
    ),
    optional($.keyword_percent),
    optional(seq($.keyword_with, $.keyword_ties)),
  ),

  select_expression: $ => seq(
    $.term,
    repeat(
      seq(
        ',',
        $.term,
      ),
    ),
  ),

  term: $ => seq(
    field(
      'value',
      choice(
        $.all_fields,
        $._expression,
      ),
    ),
    optional($._alias),
  ),

  all_fields: $ => seq(
    optional(
      seq(
        $.object_reference,
        '.',
      ),
    ),
    '*',
  ),

  // FOR XML { RAW | AUTO | EXPLICIT | PATH [('name')] } [, option ...]
  // FOR JSON { AUTO | PATH } [, option ...]
  // FOR UPDATE [OF column [, ...]] and FOR READ ONLY (cursor declarations)
  // The XML/JSON options (ELEMENTS, ROOT('r'), TYPE, BINARY BASE64, ...)
  // are identifiers.
  for_clause: $ => prec.right(seq(
    $.keyword_for,
    choice(
      seq($.keyword_xml, comma_list($.for_option, true)),
      seq($.keyword_json, comma_list($.for_option, true)),
      seq($.keyword_update, optional(seq($.keyword_of, comma_list($.identifier, true)))),
      seq($.keyword_read, $.keyword_only),
    ),
  )),

  for_option: $ => prec.right(seq(
    $.identifier,
    optional(wrapped_in_parenthesis(optional($.literal))),
    repeat($.identifier),
  )),

  partition_by: $ => seq(
      $.keyword_partition,
      $.keyword_by,
      comma_list($._expression, true),
  ),

  frame_definition: $ => seq(
      choice(
        seq(
          $.keyword_unbounded,
          $.keyword_preceding,
        ),
        seq(
            field("start", alias($._integer, $.literal)),
            $.keyword_preceding,
        ),
        $._current_row,
        seq(
            field("end", alias($._integer, $.literal)),
            $.keyword_following,
        ),
        seq(
          $.keyword_unbounded,
          $.keyword_following,
        ),
      ),
  ),

  window_frame: $ => seq(
      choice(
          $.keyword_range,
          $.keyword_rows,
      ),
      choice(
          seq(
              $.keyword_between,
              $.frame_definition,
              $.keyword_and,
              $.frame_definition,
          ),
          $.frame_definition,
      ),
  ),

  window_specification: $ => wrapped_in_parenthesis(
    seq(
      optional($.partition_by),
      optional($.order_by),
      optional($.window_frame),
    ),
  ),

  window_function: $ => seq(
      $.invocation,
      $.keyword_over,
      $.window_specification,
  ),

  _alias: $ => seq(
    optional($.keyword_as),
    // T-SQL also permits a single-quoted string literal in the alias position,
    // e.g. SUM(x) 'TotalX' or SUM(x) AS 'TotalX', alongside a plain identifier.
    field('alias', choice($.identifier, alias($._single_quote_string, $.literal))),
  ),

  from: $ => seq(
    $.keyword_from,
    comma_list($._relation_with_hint, true),
    repeat(
      choice(
        $.join,
        $.cross_join,
        $.apply_join,
        $.pivot_clause,
        $.unpivot_clause,
      ),
    ),
    optional($.where),
    optional($.group_by),
    optional($.having),
    optional($.order_by),
    optional($.offset_fetch),
    optional($.option_clause),
  ),

  // OFFSET n { ROW | ROWS } [FETCH { FIRST | NEXT } n { ROW | ROWS } ONLY]
  // prec.right: a following FETCH belongs to this clause, not to a cursor
  // FETCH statement starting the next one.
  offset_fetch: $ => prec.right(seq(
    $.keyword_offset,
    $._expression,
    choice($.keyword_row, $.keyword_rows),
    optional(seq(
      $.keyword_fetch,
      choice($.keyword_first, $.keyword_next),
      $._expression,
      choice($.keyword_row, $.keyword_rows),
      $.keyword_only,
    )),
  )),

  // T-SQL query hint clause, e.g. OPTION (HASH GROUP, FAST 10, MAXDOP 1) or
  // OPTION (OPTIMIZE FOR (@x = 'literal', @y UNKNOWN)). Hints other than
  // OPTIMIZE FOR and RECOMPILE are identifiers — T-SQL has dozens, most of
  // them multi-word, and nothing downstream needs them distinguished.
  option_clause: $ => seq(
    $.keyword_option,
    wrapped_in_parenthesis(comma_list($.query_hint, true)),
  ),

  query_hint: $ => prec.right(choice(
    seq(
      $.keyword_optimize,
      $.keyword_for,
      choice(
        $.keyword_unknown,
        wrapped_in_parenthesis(comma_list($.optimize_for_item, true)),
      ),
    ),
    $.keyword_recompile,
    seq(
      $.identifier,
      repeat(choice($.identifier, alias($._natural_number, $.literal))),
      optional(paren_list($.literal, true)),
    ),
  )),

  optimize_for_item: $ => seq(
    field('name', $.identifier),
    choice(
      seq('=', $.literal),
      $.keyword_unknown,
    ),
  ),

  relation: $ => prec.right(
    seq(
      choice(
        $.subquery,
        $.invocation,
        $.object_reference,
        wrapped_in_parenthesis($.values),
        // A MERGE with an OUTPUT clause is a legal row source: INSERT
        // ... SELECT ... FROM (MERGE ... OUTPUT ...) AS changes.
        wrapped_in_parenthesis($.merge),
      ),
      optional(
        seq(
          $._alias,
          optional(alias($._column_list, $.list)),
        ),
      ),
      // The deprecated bare hint sits inside `relation` rather than beside
      // it in `_relation_with_hint`: after the table name the parser has
      // to shift `(` for both an invocation and the hint from the same
      // state, and reducing `relation` first would lose to the
      // invocation's shift on precedence.
      optional(alias($._bare_table_hint, $.table_hint)),
    ),
  ),

  // A relation with an optional trailing table hint, e.g. `dbo.t AS x WITH
  // (NOLOCK)`, or OPENJSON's schema followed by its own alias:
  // `OPENJSON(@j) WITH (a INT '$.a') AS j`. The schema sits here, after
  // `relation` has reduced, rather than inside `relation` next to the
  // invocation: `relation` is prec.right, so a schema alternative inside
  // it wins the `WITH (` outright and a table hint after an un-aliased
  // function call (`FROM dbo.f(1) WITH (NOLOCK)`) is read as a column list
  // with an empty type. From this state the two are an ordinary LR(1)
  // choice — a hint item is an identifier followed by `,` or `)`, a schema
  // column is an identifier followed by a type.
  _relation_with_hint: $ => seq(
    $.relation,
    optional(choice(
      $.table_hint,
      seq(
        $.openjson_schema,
        optional(seq($._alias, optional(alias($._column_list, $.list)))),
      ),
    )),
  ),

  // OPENJSON(...) WITH (name type ['path'] [AS JSON] [, ...]) — the
  // explicit schema of OPENJSON's result.
  openjson_schema: $ => seq(
    $.keyword_with,
    paren_list($.openjson_column, true),
  ),

  openjson_column: $ => seq(
    field('name', $.identifier),
    field('type', $._type),
    optional(field('path', $.literal)),
    optional(seq($.keyword_as, $.keyword_json)),
  ),

  values: $ => seq(
    $.keyword_values,
    comma_list($.list, true),
  ),

  join: $ => seq(
    optional(
      seq(
        choice(
          seq($.keyword_left, optional($.keyword_outer)),
          seq($.keyword_right, optional($.keyword_outer)),
          seq($.keyword_full, optional($.keyword_outer)),
          $.keyword_inner,
        ),
        optional($.join_hint),
      ),
    ),
    $.keyword_join,
    $._relation_with_hint,
    optional($.join),
    $.keyword_on,
    field("predicate", $._expression),
  ),

  // { HASH | LOOP | MERGE | REMOTE } between the join type and JOIN: a
  // physical join hint, its own node because a linter wants to flag it.
  // The hint is only accepted after a join type. A bare `FROM a HASH JOIN
  // b` would make HASH, LOOP and REMOTE keywords in the position an
  // AS-less alias occupies, so `FROM dbo.t hash` would stop parsing and
  // `FROM dbo.a remote JOIN dbo.b` would silently lose its alias; and a
  // bare MERGE is also a MERGE statement starting after an unterminated
  // FROM, which a `conflicts` entry on `from` resolves at triple the
  // generate time. The untyped spellings are the join forms the grammar
  // does not parse.
  join_hint: $ => choice(
    $.keyword_hash,
    $.keyword_loop,
    $.keyword_merge,
    $.keyword_remote,
  ),

  cross_join: $ => seq(
    $.keyword_cross,
    $.keyword_join,
    $._relation_with_hint,
  ),

  // T-SQL CROSS APPLY / OUTER APPLY — a correlated join evaluated per row of
  // the outer table. No ON predicate. CROSS APPLY excludes rows where the
  // right side returns empty; OUTER APPLY produces NULLs (like LEFT JOIN).
  apply_join: $ => prec.right(seq(
    choice(
      seq($.keyword_cross, $.keyword_apply),
      seq($.keyword_outer, $.keyword_apply),
    ),
    // No bare object_reference target: reaching object_reference from here
    // multiplies the parser's state space enough that generate does not
    // finish, and APPLY on a plain table (rather than a function or
    // subquery) has no practical use in T-SQL.
    choice(
      $.subquery,
      seq($.invocation, optional($.openjson_schema)),
    ),
    // The alias uses the same optional-AS form as `relation` — retried
    // 2026-09-04 after the M2a dialect removal shrank generate from
    // minutes to under a minute; the bare form (`OUTER APPLY fn(x) a`) no
    // longer runs the parser-table build past the cap.
    optional(
      seq(
        $._alias,
        optional(alias($._column_list, $.list)),
      ),
    ),
  )),

  // table_source PIVOT ( aggregate(column) FOR column IN (value [, ...]) ) [AS] alias
  pivot_clause: $ => prec.right(seq(
    $.keyword_pivot,
    wrapped_in_parenthesis(seq(
      $.invocation,
      $.keyword_for,
      alias($._qualified_field, $.field),
      $.keyword_in,
      paren_list($.identifier, true),
    )),
    optional($._alias),
  )),

  // table_source UNPIVOT ( value_column FOR pivot_column IN (column [, ...]) ) [AS] alias
  unpivot_clause: $ => prec.right(seq(
    $.keyword_unpivot,
    wrapped_in_parenthesis(seq(
      $.identifier,
      $.keyword_for,
      $.identifier,
      $.keyword_in,
      paren_list($.identifier, true),
    )),
    optional($._alias),
  )),

  where: $ => seq(
    $.keyword_where,
    choice(
      field("predicate", $._expression),
      $.current_of,
    ),
  ),

  // WHERE CURRENT OF [GLOBAL] cursor — a positioned UPDATE or DELETE
  // through an open cursor, in place of a predicate.
  current_of: $ => seq(
    $.keyword_current,
    $.keyword_of,
    optional($.keyword_global),
    $.identifier,
  ),

  // GROUP BY expression [, ...], where an expression may be ROLLUP(...),
  // CUBE(...) — ordinary invocations — or GROUPING SETS (...).
  group_by: $ => seq(
    $.keyword_group,
    $.keyword_by,
    comma_list(choice($._expression, $.grouping_sets), true),
  ),

  grouping_sets: $ => seq(
    $.keyword_grouping,
    $.keyword_sets,
    paren_list($._expression, true),
  ),

  having: $ => seq(
    $.keyword_having,
    $._expression,
  ),

  order_by: $ => prec.right(seq(
    $.keyword_order,
    $.keyword_by,
    comma_list($.order_target, true),
  )),

  order_target: $ => seq(
    $._expression,
    optional($.direction),
  ),

};
