# Security policy

## Reporting a vulnerability

Found a parser crash or hang on some input? Include the input (or a minimized version) and which binding you used (Rust, Node, or the C API) in a normal GitHub issue. If it looks like it could be used to cause trouble for a downstream consumer before a fix ships, do not open a public issue; use [GitHub's private vulnerability reporting](https://github.com/alfpricot/tree-sitter-mssql/security/advisories/new) instead, and include what you found, how to reproduce it, and the impact you expect.

## Scope

This policy covers the grammar, the generated parser, the scanner, and the Rust and Node.js bindings in this repository.

## Supported versions

Fixes land on the latest published release.

## Practices

- No credentials in the repository: `Verify` scans the working tree and the Git history for secrets on every pull request.
- Dependencies are pinned to exact versions in `package.json`.
