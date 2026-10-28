# Contributing to tree-sitter-mssql

A tree-sitter grammar for Microsoft SQL Server T-SQL, with Rust and Node.js bindings.

## Before you start

1. Branch from **`dev`**; `main` is the production branch, updated by promotion pull requests from `dev`, with each release cut automatically from `main`.
2. Read [ARCHITECTURE.md](ARCHITECTURE.md), [docs/scope.md](docs/scope.md), and [docs/development.md](docs/development.md).

## Local setup

```sh
npm install --ignore-scripts
npx --yes --package=tree-sitter-cli@0.27.1 -- tree-sitter generate
cargo build
```

`--ignore-scripts` skips the package's own `node-gyp-build` install script, which needs a C++ build toolchain. Regenerate the parser and commit the diff after any `grammar.js` change; a committed parser that has drifted from the grammar is a CI failure. On a machine without MSVC, prefix `tree-sitter test` and `tree-sitter parse` with `CC=gcc CXX=g++`.

## Validation before a pull request

```sh
npx --yes --package=tree-sitter-cli@0.27.1 -- tree-sitter test
node test/generate-node-kinds.mjs
node test/check-registries.mjs
npm run lint
npm run format:check
cargo fmt --check
cargo clippy --all-targets -- -D warnings
cargo test
```

`test/corpus/` holds per-construct tree assertions and `test/fixtures/*.sql` are larger files checked for `ERROR`, `MISSING`, and zero-width nodes; [docs/development.md](docs/development.md) has the fixture loop. CI (`Verify`) runs all of this, plus the Node binding tests (`npm test`), secret scanning, and workflow linting.

## Pull requests

- Open pull requests against **`dev`**.
- Use a Conventional Commit title (`feat:`, `fix:`, `docs:`, `chore:`, `test:`, ...).
- Keep each pull request to one change; link the issue it resolves in the body.
- Regenerate and commit `src/parser.c` and `test/node-kinds.txt` alongside any `grammar.js` change; CI diffs both against a fresh regenerate and fails on drift.
- Add a corpus case, or extend a fixture, for any new construct.
- A node-kind addition, removal, or rename is part of the published API surface (see [docs/consuming.md](docs/consuming.md)); call it out in the description so it reaches `CHANGELOG.md`.

## Documentation

| Document | Covers |
| --- | --- |
| [docs/scope.md](docs/scope.md) | What the grammar covers and how it treats SQL Server versions |
| [docs/consuming.md](docs/consuming.md) | Symbol, ABI, query files, node-kind stability |
| [docs/development.md](docs/development.md) | Building, testing, linting, fuzzing |
| [docs/accepted-gaps.md](docs/accepted-gaps.md) | Known differences from SQL Server |
