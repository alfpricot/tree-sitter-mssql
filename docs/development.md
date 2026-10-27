# Development

How to build and test the grammar. [CONTRIBUTING.md](../CONTRIBUTING.md) lists the checks a pull request must pass.

## Building

```sh
npx --yes --package=tree-sitter-cli@0.27.0 -- tree-sitter generate
cargo build
```

The generated parser (`src/parser.c`, `src/grammar.json`, `src/node-types.json`) is committed, so consumers can build the C parser through `cc` during `cargo build` without needing the tree-sitter CLI themselves. Regenerate and commit the diff after any `grammar.js` change.

The block comment is lexed by `src/scanner.c` rather than a regex, because T-SQL block comments nest and a regex cannot match balanced nesting. `src/scanner.c` must be compiled alongside `src/parser.c`.

`generate` takes under a minute on this grammar. Run it with a time cap and read the exit code, and check that `src/parser.c`'s modification time moved before trusting a test run — a failed `generate` leaves the previous parser in place.

## Testing

```sh
npx --yes --package=tree-sitter-cli@0.27.0 -- tree-sitter test
cargo test
```

On a machine without MSVC, point the CLI at another C compiler:

```sh
CC=gcc CXX=g++ npx --yes --package=tree-sitter-cli@0.27.0 -- tree-sitter test
```

`test/corpus/` holds the per-construct tree assertions. `test/corpus/errors.txt` deliberately pins error recovery on invalid input and is hand-written — `tree-sitter test --update` refuses to touch it. Every file under `test/fixtures/*.sql` should also parse with zero `ERROR`/`MISSING`/zero-width nodes:

```sh
for f in test/fixtures/*.sql; do printf "%s: " "$f"; CC=gcc CXX=g++ npx --yes --package=tree-sitter-cli@0.27.0 -- tree-sitter parse "$f" 2>/dev/null | grep -c "ERROR\|MISSING"; done
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

`eslint` and `prettier` are devDependencies, and ESLint's flat config (`eslint.config.js`) imports `@eslint/js` from this checkout's own `node_modules`, so they cannot run through a one-off `npx --package=...` call. Install them once, skipping the package's own `node-gyp-build` install script, which needs a C++ build toolchain that linting does not:

```sh
npm install --ignore-scripts
npm run lint
npm run format:check
```

`npm run format` applies fixes. All three run against `grammar.js`, `grammar/**/*.js`, `test/*.mjs`, and `bindings/node/*.js` (`format` and `format:check` also cover `tools/*.mjs`). `src/**` is generated and excluded.

## Performance and fuzzing

Every `Verify` run's job summary reports the fixture set's parse throughput (bytes/ms) and the current `src/parser.c` size, so a change's effect on either is visible without a separate benchmark step. A scheduled workflow (`.github/workflows/fuzz.yml`) also fuzzes the parser and `src/scanner.c` against arbitrary input weekly, using the `cargo-fuzz` target in `fuzz/`.
