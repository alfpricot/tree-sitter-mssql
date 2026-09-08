# Contributing

## Build

```sh
npx --package=tree-sitter-cli@0.26.3 -- tree-sitter generate
cargo build
```

The generated parser (`src/parser.c`, `src/grammar.json`, `src/node-types.json`) is committed.
Regenerate and commit the diff after any `grammar.js` change — a committed parser that has drifted
from the grammar that produced it is a CI failure. `generate` takes under a minute on this grammar;
a failed run leaves the previous `src/parser.c` in place, so check that its modification time moved
before trusting a subsequent test run. `generate` does not compile anything, so it needs no C
compiler even on a machine without MSVC.

## Test

```sh
CC=gcc CXX=g++ tree-sitter test
cargo test
```

`test/corpus/` holds per-construct tree assertions; `test/fixtures/*.sql` are larger real-shaped
files checked for zero `ERROR`/`MISSING`/zero-width nodes. `test/corpus/errors.txt` deliberately
pins error recovery on invalid input and is hand-written — `tree-sitter test --update` refuses to
touch it.

## Pull requests

- Regenerate and commit `src/parser.c` and `test/node-kinds.txt` alongside any `grammar.js` change;
  CI diffs both against a fresh regenerate and fails on drift.
- Add a corpus case (or extend a fixture) for any new construct.
- `cargo fmt` and `cargo clippy` must pass with no warnings.
