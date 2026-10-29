# Consuming this grammar

What a downstream project needs to know to depend on `tree-sitter-mssql`.

## Symbol and ABI

The exported C symbol is `tree_sitter_mssql` (not `tree_sitter_sql`), so linking this grammar alongside a general-SQL tree-sitter grammar in the same binary does not collide. The parser is `LANGUAGE_VERSION` (ABI) 15. The crate depends on `tree-sitter-language = "0.1"` at runtime and only dev-depends on `tree-sitter ~0.27`, so a consumer on `tree-sitter = "0.26"` or newer is compatible.

## Query files

Both bindings expose every query file — `HIGHLIGHTS_QUERY`, `INDENTS_QUERY`, `INJECTIONS_QUERY`, `LOCALS_QUERY`, `TAGS_QUERY` — so a consumer can load `queries/highlights.scm` without resolving the package's install path by hand. The Rust crate exports them as real `pub const` items (`tree_sitter_mssql::HIGHLIGHTS_QUERY`); the Node binding exposes them as properties of its default export (`SQL.HIGHLIGHTS_QUERY`, not a named import).

## Node-kind stability

`test/node-kinds.txt` is the public API surface. It is generated from `src/node-types.json`, checked for drift on every pull request in `.github/workflows/verify.yml`, and attached to every GitHub Release so two versions can be diffed mechanically. Before 1.0, treat node-kind additions as compatible and removals or renames as breaking; call out either in the pull request or commit that makes the change so it is visible in `CHANGELOG.md`.

## Version-specific and deprecated constructs

`versions.json` maps the node kinds that are specific to a SQL Server release (for example `named_window`, requiring SQL Server 2022) or that model deprecated-but-still-executing syntax (for example `readtext_statement`), so a downstream linter can flag either without maintaining its own list. See the file's own `_meta` section for the node kinds it does not yet cover.

## Packaging

The npm package ships prebuilt native addons for `linux-x64` and `win32-x64`; on any other platform `node-gyp-build` falls back to compiling the committed generated parser. `src/scanner.c` must be compiled alongside `src/parser.c` — vendoring one without the other produces a link error or a parser that cannot lex a block comment.
