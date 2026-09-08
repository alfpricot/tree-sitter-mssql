import { comma_list } from "../helpers.js";

// T-SQL CREATE [OR ALTER] PROC[EDURE].
//
//   CREATE [OR ALTER] { PROC | PROCEDURE } name
//       [ @param [AS] type [= default] [OUT | OUTPUT] [READONLY] [, ...] ]
//       [ WITH { ENCRYPTION | RECOMPILE | EXECUTE AS ... } [, ...] ]
//       [ FOR REPLICATION ]
//   AS { BEGIN ... END | statement [ ... ] }
export default {

  create_procedure: $ => seq(
    $.keyword_create,
    optional($._or_alter),
    $._procedure_definition,
  ),

  // ALTER PROCEDURE takes exactly the CREATE shape. SSMS-scripted objects
  // are almost all `CREATE ... AS` stubs followed by an ALTER carrying the
  // real body, so this node is what the consumers mostly measure.
  alter_procedure: $ => seq(
    $.keyword_alter,
    $._procedure_definition,
  ),

  // The `;number` suffix is a numbered procedure (`CREATE PROC p;2`), a
  // deprecated grouping that still executes.
  _procedure_definition: $ => seq(
    choice($.keyword_procedure, $.keyword_proc),
    $.object_reference,
    optional(seq(';', field('number', alias($._natural_number, $.literal)))),
    optional($.function_arguments),
    optional($.procedure_options),
    optional(seq($.keyword_for, $.keyword_replication)),
    $.procedure_body,
  ),

  procedure_options: $ => seq(
    $.keyword_with,
    comma_list($.procedure_option, true),
  ),

  procedure_option: $ => choice(
    $.keyword_encryption,
    $.keyword_recompile,
    $.execute_as_clause,
  ),

  // EXECUTE AS { CALLER | SELF | OWNER | 'user_name' } — the module-level
  // execution-context option shared by procedures, functions, and triggers.
  execute_as_clause: $ => seq(
    choice($.keyword_exec, $.keyword_execute),
    $.keyword_as,
    choice(
      $.keyword_caller,
      $.keyword_self,
      $.keyword_owner,
      alias($._single_quote_string, $.literal),
    ),
  ),

  // The body is everything after AS up to the end of the batch: one or more
  // body items, where the conventional `BEGIN ... END` wrapper is simply a
  // body whose first (and usually only) item is a block. Modeling it that
  // way rather than as a separate alternative avoids an ambiguity between
  // "the wrapper block" and "a bare body starting with a block" — they are
  // the same tokens — and keeps the shape SSMS-scripted triggers use (bare
  // statements after AS, no BEGIN/END) as a legitimate form. prec.right
  // keeps consuming statements rather than handing them back to `program`,
  // which is T-SQL's own rule: the body runs to the next GO. The body may
  // be empty: `CREATE PROCEDURE dbo.p AS` followed by GO is the stub SSMS
  // scripts before the ALTER that carries the real body. Triggers share
  // this rule, so a body-less trigger (which SQL Server rejects) also
  // parses clean — a knowing over-acceptance rather than a second rule.
  procedure_body: $ => prec.right(seq(
    $.keyword_as,
    repeat($._body_item),
  )),

  // One statement of a module body: a statement or a nested BEGIN ... END
  // block, with an optional `;`. prec.right so a trailing `;` binds to the
  // body item it follows rather than to `program`'s own separator —
  // otherwise a bare body would end at its first semicolon.
  _body_item: $ => prec.right(seq(
    choice($.statement, $.block),
    optional(';'),
  )),

};
