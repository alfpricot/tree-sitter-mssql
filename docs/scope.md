# Scope

What this grammar covers, what it deliberately leaves out, and how it treats SQL Server versions.

**Scope: T-SQL only.** This is not a general or multi-dialect SQL grammar. PostgreSQL, MySQL, SQLite, Hive, Spark, and Snowflake syntax are out of scope; the rule set inherited from the upstream's other dialects has been removed rather than maintained.

**SQL Server versions.** One grammar accepts the union of every version's syntax, from what SQL Server 2008 accepted through the current release and Azure SQL. A tree-sitter parser has no runtime switch, and a consumer meets a file on disk without knowing the server it targets, so the grammar never refuses a construct on version grounds. Deprecated syntax that still executes (`SETUSER`, `READTEXT`, the bare `(NOLOCK)` hint) is in scope, since a linter has to see it to flag it. A version-specific construct gets its own node kind so a downstream rule can flag it against a target version, and the corpus test that introduces one names the minimum version.

**Status.** Procedure, function, and trigger bodies (DML, DDL and logon triggers), control flow (`IF`/`ELSE`, `WHILE`, `TRY`/`CATCH`, `RETURN`, `GOTO`), transactions, variables and table variables, cursors, `MERGE`, `OUTPUT`, `CROSS`/`OUTER APPLY`, `PIVOT`/`UNPIVOT`, `FOR XML`/`JSON`, `OFFSET`/`FETCH`, `RAISERROR`/`THROW`, table and query hints, `TOP`, the full `CREATE`/`ALTER`/`DROP` surface for tables, constraints, indexes, views, types, sequences, synonyms, schemas, users, logins and roles, `GRANT`/`REVOKE`/`DENY`, the SSMS script header and `GO`, SMO-scripted objects with no statement separators, and bracketed parameterized types all parse. No downstream project consumes the grammar yet.

**Known mismatches.** [accepted-gaps.md](accepted-gaps.md) lists the places where this grammar and SQL Server disagree about what is valid. [`test/fixtures/README.md`](../test/fixtures/README.md) lists the constructs deliberately left unmodeled.

## Origin

This project started as a fork of [`tree-sitter-sql`](https://github.com/DerekStride/tree-sitter-sql) by Derek Stride (MIT licensed; see `LICENSE` and `NOTICE`). The general-SQL core — expression precedence, `SELECT`, CTEs, joins, window functions — comes from that project largely unchanged. The T-SQL-specific surface is added on top, and the upstream's other-dialect surface is gone.
