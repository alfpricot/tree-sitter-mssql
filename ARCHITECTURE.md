# tree-sitter-mssql architecture

`tree-sitter-mssql` is a tree-sitter grammar for Microsoft SQL Server T-SQL. The grammar is written in JavaScript, compiled by the tree-sitter CLI into a C parser that is committed to the repository, and wrapped by Rust and Node.js bindings so editors, linters, and formatters can parse T-SQL into a concrete syntax tree.

The main design choice is one grammar for every SQL Server version: it accepts the union of all versions' syntax and gives version-specific constructs their own node kinds, instead of switching behavior at run time. The grammar began as a fork of a general-SQL grammar; the rest of this document describes the parts that exist now. See [docs/scope.md](docs/scope.md) for the scope rules.

## What tree-sitter-mssql is not

- Not a general or multi-dialect SQL grammar: only T-SQL.
- Not a SQL Server client, validator, or formatter: it produces syntax trees and nothing else.
- Not a semantic checker: it accepts some statements SQL Server rejects and rejects some it accepts, and [docs/accepted-gaps.md](docs/accepted-gaps.md) records those differences.

## Major components

### [grammar.js](grammar.js) and [grammar/](grammar)

`grammar.js` is the grammar's entry point. The rules live in modules under `grammar/`: `expressions.js`, `types.js`, `keywords.js`, `column-lists.js`, `transactions.js`, `helpers.js`, and one file per statement family under [grammar/statements/](grammar/statements) (`select.js`, `insert.js`, `create.js`, `alter.js`, `security.js`, and so on).

### [src/](src)

The generated parser: `parser.c`, `grammar.json`, and `node-types.json` come from `tree-sitter generate` and are committed, so consumers build the parser without the CLI. `scanner.c` is hand-written and lexes nested block comments, which a regular expression cannot match.

### [queries/](queries)

Tree-sitter query files for editors: `highlights.scm`, `indents.scm`, `injections.scm`, `locals.scm`, and `tags.scm`. Both bindings export them.

### [bindings/](bindings)

`bindings/rust` is the crate (`lib.rs`, with `build.rs` compiling the C sources). `bindings/node` is the Node.js addon (`binding.cc`, `index.js`, type definitions, and its tests), built through `binding.gyp`.

### [test/](test)

`corpus/` holds per-construct expected trees, `fixtures/` holds larger T-SQL files that must parse without errors, and `highlight/` holds highlight-query tests. `node-kinds.txt` is the generated list of node kinds that serves as the public API surface, and `check-registries.mjs` and `generate-node-kinds.mjs` maintain and check it.

### [tools/](tools)

Release-support scripts: `release-policy.mjs` validates a tag against the manifests before anything is published, and `package-check.mjs` verifies that the publishable package contents are complete.

### [fuzz/](fuzz)

A `cargo-fuzz` target that parses arbitrary bytes through the grammar.

### [docs/](docs)

Hand-written documents on scope, consuming the grammar, development, and the ledger of accepted gaps. `versions.json` at the root maps node kinds to minimum SQL Server versions and deprecation status.

## External systems and data flow

The repository talks to no database or service at run time. A consumer passes T-SQL text to the parser through one of the bindings and receives a syntax tree.

```text
T-SQL text -> binding (Rust crate or Node addon) -> src/parser.c + src/scanner.c -> syntax tree
```

At publish time the project pushes to three registries: crates.io (the crate), npm (the package), and GitHub Packages (a copy scoped to the repository owner). Each GitHub Release also carries a WebAssembly build, `test/node-kinds.txt`, and `versions.json`.

## Build, test, release, and deploy

- **Pull requests and pushes to `dev` and `main`** run `Verify` (`.github/workflows/verify.yml`): PR-title validation, secret scanning, regeneration of the parser with a drift check, the node-kind and registry checks, lint and format checks, corpus, highlight, and fixture tests, `cargo fmt`, `clippy`, and `cargo test`, the Node binding build and tests, and workflow linting.
- **Pushes to `main`** run `Gala release` (`gala-release.yml`), which uses gala (`.gala.toml`) to compute the version from Conventional Commits, bump `Cargo.toml`, write `CHANGELOG.md`, commit and tag the release, push over a deploy key, and fast-forward `dev` to the release commit. It then dispatches `Release` (`release.yml`) with the new tag to publish to crates.io, npm, and GitHub Packages and create the GitHub Release.
- **On a schedule**, `Fuzz` runs weekly and `Cleanup stale caches` runs daily.
- Nothing is deployed: the repository publishes libraries only.

## Where things live

| Path | Holds |
| --- | --- |
| `grammar.js`, `grammar/` | Grammar source |
| `src/` | Generated parser and hand-written scanner |
| `queries/` | Tree-sitter query files |
| `bindings/rust`, `bindings/node` | Rust crate and Node.js addon |
| `test/` | Corpus, fixtures, highlight tests, node-kind snapshot |
| `tools/` | Release-policy and package-check scripts |
| `fuzz/` | Fuzz target |
| `docs/` | Project documentation |
| `.github/workflows/` | CI, release, sync, and scheduled workflows |
