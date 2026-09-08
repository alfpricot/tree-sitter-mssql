import keyword_rules from "./grammar/keywords.js";
import type_rules from "./grammar/types.js";
import column_list_rules from "./grammar/column-lists.js";
import expression_rules from "./grammar/expressions.js";
import transaction_rules from "./grammar/transactions.js";
import statement_rules from "./grammar/statements/index.js";

export default grammar({
  name: 'mssql',

  extras: $ => [
    /\s\n/,
    /\s/,
    $.comment,
    $.marginalia,
  ],

  // The block comment is lexed by src/scanner.c rather than a regex because
  // T-SQL block comments nest, and a regex cannot match balanced nesting.
  externals: $ => [
    $.marginalia,
  ],

  // Every entry arbitrates a real fork the parser must carry a few tokens
  // before it can settle; tree-sitter reports any that stop being needed
  // as "unnecessary conflicts" on generate, and those are removed.
  conflicts: $ => [
    // `a.b` — the prefix of a qualified column vs. an object reference.
    [$.object_reference, $._qualified_field],
    // `a.b.c.d` — how many parts belong to the reference.
    [$.object_reference],
    // `x BETWEEN a AND b` vs. `x BETWEEN (a AND b)`.
    [$.between_expression, $.binary_expression],
    // A `(` after a DBCC command may open its argument list or start the
    // next statement; a `WITH` after RECONFIGURE, RAISERROR or an
    // unterminated CREATE MESSAGE TYPE's VALIDATION clause may be its
    // option list (or WITH SCHEMA COLLECTION suffix) or the next
    // statement's CTE.
    [$.dbcc_statement],
    [$.reconfigure_statement],
    [$.raiserror_statement],
    [$.create_message_type],
    // `OUTPUT a, b INTO t` — where the term list ends.
    [$.output_clause],
    // `FROM t WITH` — a table hint or the next statement's CTE.
    [$._relation_with_hint],
    // `SELECT a b` — `b` may be an alias or continue the expression.
    [$.term],
    // `IF cond stmt ;` — the `;` may start a `; ELSE` clause or end the IF;
    // see else_clause.
    [$.if_statement],
  ],

  precedences: $ => [
    [
      'binary_is',
      'unary_not',
      'unary_sign',
      'binary_exp',
      'binary_times',
      'binary_plus',
      'unary_other',
      'binary_other',
      'binary_in',
      'binary_compare',
      'binary_relation',
      'pattern_matching',
      'between',
      'clause_connective',
      'clause_disjunctive',
    ],
  ],

  word: $ => $._identifier,

  rules: {
    // A script: statements and blocks, each optionally terminated by `;` or
    // a `GO` batch separator, plus bare `GO` lines. The separator is
    // optional because T-SQL does not require one between statements and
    // SMO/SSMS-scripted objects mostly omit it; every T-SQL statement
    // starts with a keyword the previous statement cannot continue with,
    // which is what makes this unambiguous.
    program: $ => repeat(
      choice(
        seq(
          choice($.statement, $.block),
          optional(choice(';', $.go_statement)),
        ),
        $.go_statement,
        $.sqlcmd_setvar,
        $.sqlcmd_include,
      ),
    ),

    // T-SQL batch separator. Not a T-SQL keyword at all — it's a command
    // recognized by client tools (sqlcmd, SSMS) that splits a script into
    // separate batches sent to the server one at a time. It takes an
    // optional repeat count (`GO 5`) and must otherwise stand alone.
    go_statement: $ => seq($.keyword_go, optional(alias($._natural_number, $.literal))),

    // SQLCMD scripting variables — `:setvar name value` and `:r path` — are
    // interpreted by the sqlcmd/SSMS client, never sent to the server, the
    // same standing as GO. Unlike T-SQL keywords, sqlcmd command names are
    // case-sensitive, so they are plain literal tokens rather than
    // `make_keyword` regexes.
    //   :setvar DatabaseName "MyDatabase"
    // The value is an object reference rather than an identifier so a
    // schema-qualified name (`:setvar TableName sys.objects`) is one value.
    sqlcmd_setvar: $ => seq(
      ':setvar',
      field('name', $.identifier),
      field('value', choice($.object_reference, $.literal)),
    ),

    // :r path/to/script.sql — inlines another script file. The path can
    // contain characters (`.`, `/`, `\`) that are not valid identifier
    // characters, so it is a single raw token rather than composed from
    // identifiers, aliased to `identifier` since consumers need to see that
    // something is referenced here, not decompose the path.
    sqlcmd_include: $ => seq(':r', alias($._sqlcmd_path, $.identifier)),
    _sqlcmd_path: _ => /[^\s][^\r\n]*/,

    comment: _ => /--.*/,
    // The block comment (`marginalia`) is an external token: see src/scanner.c.

    ...keyword_rules,
    ...type_rules,
    ...column_list_rules,
    ...expression_rules,
    ...transaction_rules,
    ...statement_rules,
  }
});
