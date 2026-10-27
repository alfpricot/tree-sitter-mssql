# tree-sitter-mssql

[![Verify](https://github.com/alfpricot/tree-sitter-mssql/actions/workflows/verify.yml/badge.svg?branch=dev)](https://github.com/alfpricot/tree-sitter-mssql/actions/workflows/verify.yml) [![crates.io](https://img.shields.io/crates/v/tree-sitter-mssql.svg)](https://crates.io/crates/tree-sitter-mssql)

A [tree-sitter](https://tree-sitter.github.io/tree-sitter/) grammar for Microsoft SQL Server Transact-SQL (T-SQL). It covers T-SQL only, not a general or multi-dialect SQL, and one grammar accepts the union of every SQL Server version's syntax, from SQL Server 2008 through the current release and Azure SQL, so a consumer never needs to know the server version a file targets. It started as a fork of [`tree-sitter-sql`](https://github.com/DerekStride/tree-sitter-sql) by Derek Stride (MIT licensed; see `LICENSE` and `NOTICE`). [docs/scope.md](docs/scope.md) holds the scope rules, version handling, and the list of covered syntax.

## Installation

For Rust:

```sh
cargo add tree-sitter tree-sitter-mssql
```

For Node.js:

```sh
npm install tree-sitter-mssql
```

A GitHub Packages copy of the npm package is also published as `@alfpricot/tree-sitter-mssql`.

### Requirements

- Rust 1.85 or newer (the crate uses edition 2024).
- For Node.js, the `tree-sitter` package `^0.25.0` is an optional peer dependency.
- The npm package ships prebuilt native addons for `linux-x64` and `win32-x64`, so those platforms need no C toolchain. Any other platform compiles the committed generated parser on install and needs a C compiler.

## Usage

```rust
let mut parser = tree_sitter::Parser::new();
let language = tree_sitter_mssql::LANGUAGE;
parser.set_language(&language.into()).expect("Error loading T-SQL parser");
let tree = parser.parse("SELECT TOP (10) name FROM sys.objects WHERE type = 'U';", None).unwrap();
assert!(!tree.root_node().has_error());
```

```js
import Parser from "tree-sitter";
import SQL from "tree-sitter-mssql";

const parser = new Parser();
parser.setLanguage(SQL);
```

Every [GitHub Release](https://github.com/alfpricot/tree-sitter-mssql/releases) carries a `tree-sitter-mssql.wasm` build for `web-tree-sitter` consumers (browsers, sandboxed runtimes):

```js
import { Parser, Language } from "web-tree-sitter";
await Parser.init();
const language = await Language.load("tree-sitter-mssql.wasm");
const parser = new Parser();
parser.setLanguage(language);
```

[docs/consuming.md](docs/consuming.md) covers the exported symbol, the parser ABI, the query-file constants, node-kind stability, and `versions.json`.

## How to contribute

Branch from `dev`, regenerate the parser after any `grammar.js` change, and run the checks described in [CONTRIBUTING.md](CONTRIBUTING.md). [docs/development.md](docs/development.md) has the build and test details, and [ARCHITECTURE.md](ARCHITECTURE.md) maps the repository.

## License

MIT — see [LICENSE](LICENSE) and [NOTICE](NOTICE).
