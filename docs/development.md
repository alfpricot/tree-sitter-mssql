# Development

How to build and test the grammar. [CONTRIBUTING.md](../CONTRIBUTING.md) lists the checks a pull request must pass.

## Building

```sh
npx --yes --package=tree-sitter-cli@0.27.1 -- tree-sitter generate
cargo build
```

The generated parser (`src/parser.c`, `src/grammar.json`, `src/node-types.json`) is committed, so consumers can build the C parser through `cc` during `cargo build` without needing the tree-sitter CLI themselves. Regenerate and commit the diff after any `grammar.js` change.

The block comment is lexed by `src/scanner.c` rather than a regex, because T-SQL block comments nest and a regex cannot match balanced nesting. `src/scanner.c` must be compiled alongside `src/parser.c`.

`generate` takes under a minute on this grammar. Run it with a time cap and read the exit code, and check that `src/parser.c`'s modification time moved before trusting a test run — a failed `generate` leaves the previous parser in place.

## Testing

```sh
npx --yes --package=tree-sitter-cli@0.27.1 -- tree-sitter test
cargo test
```

On a machine without MSVC, point the CLI at another C compiler:

```sh
CC=gcc CXX=g++ npx --yes --package=tree-sitter-cli@0.27.1 -- tree-sitter test
```

`test/corpus/` holds the per-construct tree assertions. `test/corpus/errors.txt` deliberately pins error recovery on invalid input and is hand-written — `tree-sitter test --update` refuses to touch it. Every file under `test/fixtures/*.sql` should also parse with zero `ERROR`/`MISSING`/zero-width nodes:

```sh
for f in test/fixtures/*.sql; do printf "%s: " "$f"; CC=gcc CXX=g++ npx --yes --package=tree-sitter-cli@0.27.1 -- tree-sitter parse "$f" 2>/dev/null | grep -c "ERROR\|MISSING"; done
```

Regenerate `test/node-kinds.txt` after any change to a node kind or field name:

```sh
node test/generate-node-kinds.mjs
```

Check that every `create_*`/`alter_*`/`drop_*` rule is registered in its statement's `choice()`:

```sh
node test/check-registries.mjs
```

## Lint and format

`oxlint` and `oxfmt` are devDependencies (configured in `.oxlintrc.json` and `.oxfmtrc.json`), so they run from this checkout's own `node_modules` rather than through a one-off `npx --package=...` call. Install them once, skipping the package's own `node-gyp-build` install script, which needs a C++ build toolchain that linting does not:

```sh
npm install --ignore-scripts
npm run lint
npm run format:check
```

`npm run format` applies fixes. `lint` runs against `grammar.js`, `grammar/`, `test/`, and `bindings/node/`; `format` and `format:check` cover `grammar.js`, `grammar/**/*.js`, `test/*.mjs`, `tools/*.mjs`, and `bindings/node/*.js`. `src/**` is generated and excluded.

## Performance and fuzzing

Every `Verify` run's job summary reports the fixture set's parse throughput (bytes/ms) and the current `src/parser.c` size, so a change's effect on either is visible without a separate benchmark step. A scheduled workflow (`.github/workflows/fuzz.yml`) also fuzzes the parser and `src/scanner.c` against arbitrary input weekly, using the `cargo-fuzz` target in `fuzz/`.
