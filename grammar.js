import keyword_rules from './grammar/keywords.js';
import type_rules from './grammar/types.js';
import column_list_rules from './grammar/column-lists.js';
import expression_rules from './grammar/expressions.js';
import transaction_rules from './grammar/transactions.js';
import statement_rules from './grammar/statements/index.js';
import { sqlcmd_command } from './grammar/helpers.js';

export default grammar({
  name: 'mssql',

  extras: ($) => [/\s/, $.comment, $.marginalia],

  // The block comment is lexed by src/scanner.c rather than a regex because
  // T-SQL block comments nest, and a regex cannot match balanced nesting.
  // The scanner returns `_unterminated_comment` for a `/*` that never closes;
  // no rule accepts it, so the rest of the input becomes one ERROR node.
  // `_sqlcmd_boundary` is a zero-width check that a sqlcmd command name is
  // followed by whitespace or the end of input, which a regular expression
  // cannot express without consuming the character.
  externals: ($) => [$.marginalia, $._unterminated_comment, $._sqlcmd_boundary],

  // Every entry arbitrates a real fork the parser must carry a few tokens
  // before it can settle; tree-sitter reports any that stop being needed
  // as "unnecessary conflicts" on generate, and those are removed.
  conflicts: ($) => [
    // `a.b` — the prefix of a qualified column vs. an object reference.
    [$.object_reference, $._qualified_field],
    // `a.b.c.d` — how many parts belong to the reference.
    [$.object_reference],
    // `x BETWEEN a AND b` vs. `x BETWEEN (a AND b)`.
    [$.between_expression, $.binary_expression],
    // A `(` after a DBCC command may open its argument list or start the
    // next statement; a `WITH` after RECONFIGURE, RAISERROR, an
    // unterminated CREATE MESSAGE TYPE's VALIDATION clause, TRUNCATE
    // TABLE, CREATE QUEUE (when its ON filegroup is omitted), ALTER QUEUE's
    // REBUILD/REORGANIZE, ALTER ASSEMBLY, ALTER FULLTEXT CATALOG's REBUILD,
    // ALTER FULLTEXT INDEX's SET/ADD/DROP, or ALTER ROUTE may be its own
    // option list (or WITH SCHEMA COLLECTION suffix) or the next
    // statement's CTE.
    [$.dbcc_statement],
    [$.reconfigure_statement],
    [$.raiserror_statement],
    [$.create_message_type],
    [$.create_queue],
    [$.truncate_statement],
    [$.alter_queue],
    [$.alter_assembly],
    [$.alter_fulltext_catalog],
    [$.alter_fulltext_index],
    [$.alter_route],
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

  precedences: (_) => [
    [
      'postfix_modifier',
      'unary_not',
      'unary_sign',
      'binary_times',
      'binary_plus',
      'binary_in',
      'binary_relation',
      // IS [NOT] NULL and IS [NOT] DISTINCT FROM are comparison predicates, so
      // they take whole arithmetic operands: `a + b IS NULL` is
      // `(a + b) IS NULL`.
      'binary_is',
      'pattern_matching',
      'between',
      'logical_not',
      'clause_connective',
      'clause_disjunctive',
    ],
  ],

  word: ($) => $._identifier,

  rules: {
    // A script is a sequence of batches — real T-SQL semantics, since `GO`
    // is a client-tool separator that sends everything before it to the
    // server as one unit before starting the next (see `go_statement`
    // below). Grouping by batch, rather than leaving `go_statement` a flat
    // sibling of `statement`, is what lets a consumer iterate a script's
    // batches directly instead of re-deriving them by scanning for
    // `go_statement` and slicing.
    program: ($) => repeat($.batch),

    // Each statement/block may be terminated by `;`; only the batch's last
    // one may instead (or additionally) be closed by `GO`, which is why the
    // trailing `go_statement` sits outside the `repeat1` rather than beside
    // `;` on every item — `;` doesn't end a batch, `GO` always does. A bare
    // `GO` with nothing before it (consecutive `GO`s, or a script that
    // opens with one) is the second alternative, since `repeat1` cannot
    // itself be empty.
    batch: ($) =>
      choice(
        prec.right(
          seq(
            repeat1(
              choice(
                seq(choice($.statement, $.block), optional(';')),
                $.sqlcmd_setvar,
                $.sqlcmd_include,
                $.sqlcmd_on_error,
                $.sqlcmd_reset,
                $.sqlcmd_output,
                $.sqlcmd_connect,
                $.sqlcmd_xml,
                $.sqlcmd_exit,
                $.sqlcmd_quit,
                $.sqlcmd_list,
                $.sqlcmd_listvar,
                $.sqlcmd_ed,
                $.sqlcmd_shell,
              ),
            ),
            optional($.go_statement),
          ),
        ),
        $.go_statement,
      ),

    // T-SQL batch separator. Not a T-SQL keyword at all — it's a command
    // recognized by client tools (sqlcmd, SSMS) that splits a script into
    // separate batches sent to the server one at a time. It takes an
    // optional repeat count (`GO 5`) and must otherwise stand alone.
    go_statement: ($) => seq($.keyword_go, optional(alias($._natural_number, $.literal))),

    // SQLCMD commands — `:setvar name value`, `:r path`, `:on error exit` —
    // are interpreted by the sqlcmd/SSMS client, never sent to the server,
    // the same standing as GO. sqlcmd matches command names
    // case-insensitively, so SSDT's `:SETVAR` and `:On Error` parse too (see
    // `sqlcmd_command` in grammar/helpers.js).
    //
    // sqlcmd requires whitespace or the end of the line after a command name,
    // so `:rfile.sql` and `:setvarX 1` are not commands. `_sqlcmd_boundary`
    // (an external, zero-width token) enforces that; `:!!` is the one command
    // sqlcmd lets run straight into its argument, and `:exit` may run straight
    // into its parenthesized query.
    //
    // sqlcmd also accepts `RESET`, `EXIT`, `QUIT`, `ED` and `ON ERROR` with no
    // leading colon. Those forms are not parsed: without the colon they are
    // indistinguishable from the start of a T-SQL statement.
    //
    //   :setvar DatabaseName "MyDatabase"
    // The value is an object reference rather than an identifier so a
    // schema-qualified name (`:setvar TableName sys.objects`) is one value.
    // The value is optional: `:setvar MyVar` with no value is sqlcmd's
    // documented way to remove a scripting variable.
    sqlcmd_setvar: ($) =>
      prec.right(
        seq(
          sqlcmd_command('setvar'),
          $._sqlcmd_boundary,
          field('name', $.identifier),
          optional(field('value', choice($.object_reference, $.literal))),
        ),
      ),

    // :r path/to/script.sql — inlines another script file. The path can
    // contain characters (`.`, `/`, `\`) that are not valid identifier
    // characters, so it is a single raw token rather than composed from
    // identifiers, aliased to `identifier` since consumers need to see that
    // something is referenced here, not decompose the path.
    // A quoted path is taken whole. An unquoted path ends before a trailing
    // `-- comment`: it is words separated by spaces, where a hyphen may sit
    // anywhere (`Post-Deploy.sql`, `-init.sql`, `Seed - Copy.sql`) except
    // directly before another hyphen, so `--` is left for the comment token.
    sqlcmd_include: ($) =>
      seq(sqlcmd_command('r'), $._sqlcmd_boundary, alias($._sqlcmd_path, $.identifier)),
    _sqlcmd_path: (_) =>
      /"[^"\r\n]*"|([^\s-]|-[^\s-])+([ \t]+(([^\s-]|-[^\s-])+|-[ \t]+([^\s-]|-[^\s-])+))*/,

    // :on error [ exit | ignore ] — what sqlcmd does when a batch fails. SSDT
    // and sqlpackage publish scripts open with `:on error exit`.
    sqlcmd_on_error: ($) =>
      seq(
        sqlcmd_command('on'),
        $._sqlcmd_boundary,
        $.keyword_error,
        field('action', choice($.keyword_exit, $.keyword_ignore)),
      ),

    // :reset — clears sqlcmd's statement cache. It takes no argument. It has
    // its own token so that, by longest match, `:RESET` is not read as `:r`
    // including a file named `ESET`.
    sqlcmd_reset: ($) => seq(sqlcmd_command('reset'), $._sqlcmd_boundary),

    // :out and :error redirect query results and error messages to a file,
    // or to STDOUT or STDERR. The target is read the same way as an :r path.
    sqlcmd_output: ($) =>
      seq(
        choice(sqlcmd_command('out'), sqlcmd_command('error')),
        $._sqlcmd_boundary,
        field('target', alias($._sqlcmd_path, $.identifier)),
      ),

    // :connect server[\instance] [-l timeout] [-U user [-P password]] — the
    // rest of the line is kept as one `sqlcmd_text` node, not decomposed.
    sqlcmd_connect: ($) =>
      seq(
        sqlcmd_command('connect'),
        $._sqlcmd_boundary,
        field('arguments', alias($._sqlcmd_path, $.sqlcmd_text)),
      ),

    // :xml [ on | off ]
    sqlcmd_xml: ($) =>
      seq(
        sqlcmd_command('xml'),
        $._sqlcmd_boundary,
        field('state', choice($.keyword_on, $.keyword_off)),
      ),

    // :exit, :exit() and :exit(query) — end the session, optionally returning
    // the query's first value as the exit code. The query may follow the
    // command name directly, so the boundary is needed only without it. A
    // parenthesized query on the line after a bare :exit is read as its
    // query; sqlcmd never runs that line, since :exit ends the session.
    sqlcmd_exit: ($) =>
      prec.right(
        seq(
          sqlcmd_command('exit'),
          choice($._sqlcmd_exit_query, seq($._sqlcmd_boundary, optional($._sqlcmd_exit_query))),
        ),
      ),
    _sqlcmd_exit_query: ($) => choice(field('query', $.subquery), seq('(', ')')),

    // :quit, :list, :listvar and :ed take no argument, like :reset.
    sqlcmd_quit: ($) => seq(sqlcmd_command('quit'), $._sqlcmd_boundary),
    sqlcmd_list: ($) => seq(sqlcmd_command('list'), $._sqlcmd_boundary),
    sqlcmd_listvar: ($) => seq(sqlcmd_command('listvar'), $._sqlcmd_boundary),
    sqlcmd_ed: ($) => seq(sqlcmd_command('ed'), $._sqlcmd_boundary),

    // :!! command — runs an operating-system command. sqlcmd lets the command
    // follow `:!!` with no space, and it ends before a `-- comment` like an
    // :r path does.
    sqlcmd_shell: ($) => seq(':!!', field('command', alias($._sqlcmd_path, $.sqlcmd_text))),

    comment: (_) => /--.*/,
    // The block comment (`marginalia`) is an external token: see src/scanner.c.

    ...keyword_rules,
    ...type_rules,
    ...column_list_rules,
    ...expression_rules,
    ...transaction_rules,
    ...statement_rules,
  },
});
