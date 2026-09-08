# tree-sitter-mssql

A [tree-sitter](https://tree-sitter.github.io/tree-sitter/) grammar for Microsoft SQL Server
Transact-SQL (T-SQL).

**Scope: T-SQL only.** This is not a general or multi-dialect SQL grammar. PostgreSQL, MySQL,
SQLite, Hive, Spark, and Snowflake syntax are out of scope; the rule set inherited from the
upstream's other dialects has been removed rather than maintained.

**SQL Server versions.** One grammar accepts the union of every version's syntax, from what SQL
Server 2008 accepted through the current release and Azure SQL. A tree-sitter parser has no
runtime switch, and a consumer meets a file on disk without knowing the server it targets, so the
grammar never refuses a construct on version grounds. Deprecated syntax that still executes
(`SETUSER`, `READTEXT`, the bare `(NOLOCK)` hint) is in scope, since a linter has to see it to flag
it. A version-specific construct gets its own node kind so a downstream rule can flag it
against a target version, and the corpus test that introduces one names the minimum version.

**Status:** Procedure, function, and trigger bodies (DML, DDL and logon triggers), control flow
(`IF`/`ELSE`, `WHILE`, `TRY`/`CATCH`, `RETURN`, `GOTO`), transactions, variables and table
variables, cursors, `MERGE`, `OUTPUT`, `CROSS`/`OUTER APPLY`, `PIVOT`/`UNPIVOT`, `FOR XML`/`JSON`,
`OFFSET`/`FETCH`, `RAISERROR`/`THROW`, table and query hints, `TOP`, the full
`CREATE`/`ALTER`/`DROP` surface for tables, constraints, indexes, views, types, sequences,
synonyms, schemas, users, logins and roles, `GRANT`/`REVOKE`/`DENY`, the SSMS script header and
`GO`, SMO-scripted objects with no statement separators, and bracketed parameterized types all
parse. Not yet consumed by any downstream project.

This project started as a fork of [`tree-sitter-sql`](https://github.com/DerekStride/tree-sitter-sql)
by Derek Stride (MIT licensed; see `LICENSE` and `NOTICE`). The general-SQL core — expression
precedence, `SELECT`, CTEs, joins, window functions — comes from that project largely unchanged.
The T-SQL-specific surface is added on top, and the upstream's other-dialect surface is gone.

## Building

```sh
npx --package=tree-sitter-cli@0.26.3 -- tree-sitter generate
cargo build
```

The generated parser (`src/parser.c`, `src/grammar.json`, `src/node-types.json`) is committed, so
consumers can build the C parser through `cc` during `cargo build` without needing the tree-sitter
CLI themselves. Regenerate and commit the diff after any `grammar.js` change.

The block comment is lexed by `src/scanner.c` rather than a regex, because T-SQL block comments
nest and a regex cannot match balanced nesting. `src/scanner.c` must be compiled alongside
`src/parser.c` — vendoring one without the other produces a link error or a parser that cannot lex
a block comment.

`generate` takes under a minute on this grammar. Run it with a time cap and read the exit code, and
check that `src/parser.c`'s modification time moved before trusting a test run — a failed `generate`
leaves the previous parser in place.

## Testing

```sh
tree-sitter test
```

On a machine without MSVC, point the CLI at another C compiler:

```sh
CC=gcc CXX=g++ tree-sitter test
```

`test/corpus/` holds the per-construct tree assertions.

## License

MIT — see `LICENSE` and `NOTICE`.
