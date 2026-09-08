# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [0.1.4](https://github.com/meloncholic/tree-sitter-mssql/compare/v0.1.3...v0.1.4) - 2026-09-07

### Other

- sync dev from main ([#44](https://github.com/meloncholic/tree-sitter-mssql/pull/44))

## [0.1.3](https://github.com/meloncholic/tree-sitter-mssql/compare/v0.1.2...v0.1.3) - 2026-09-06

### Added

- parse Service Broker DML, encryption DDL, security policies and XML schema collections ([#19](https://github.com/meloncholic/tree-sitter-mssql/pull/19))
- parse BULK INSERT and CREATE/ALTER/DROP EVENT SESSION ([#17](https://github.com/meloncholic/tree-sitter-mssql/pull/17))
- parse every pending fixture and reject misordered EXEC arguments ([#15](https://github.com/meloncholic/tree-sitter-mssql/pull/15))
- nest block comments and accept the bare table hint ([#7](https://github.com/meloncholic/tree-sitter-mssql/pull/7))
- wire up marlin structural and vocabulary linting ([#3](https://github.com/meloncholic/tree-sitter-mssql/pull/3))
- initial commit of the T-SQL tree-sitter grammar

### Fixed

- *(ci)* dispatch release.yml explicitly after tagging ([#37](https://github.com/meloncholic/tree-sitter-mssql/pull/37))
- *(ci)* only match an open PR when reusing the release/sync branch ([#33](https://github.com/meloncholic/tree-sitter-mssql/pull/33))
- *(ci)* sync dev from a disposable branch, never from main itself ([#29](https://github.com/meloncholic/tree-sitter-mssql/pull/29))
- *(ci)* use npm pkg set for the release version bump ([#28](https://github.com/meloncholic/tree-sitter-mssql/pull/28))
- *(ci)* open PRs instead of pushing directly to protected branches ([#24](https://github.com/meloncholic/tree-sitter-mssql/pull/24))
- *(grammar)* parse CREATE MESSAGE TYPE's VALID_XML WITH SCHEMA COLLECTION ([#22](https://github.com/meloncholic/tree-sitter-mssql/pull/22))
- satisfy rustfmt and clippy in the generated build script

### Other

- *(release)* v0.1.2
- promote dev to main to fix release.yml never triggering ([#38](https://github.com/meloncholic/tree-sitter-mssql/pull/38))
- sync dev from main ([#26](https://github.com/meloncholic/tree-sitter-mssql/pull/26))
- automate crate and npm package releases ([#20](https://github.com/meloncholic/tree-sitter-mssql/pull/20))
- verify node-kind snapshot and fixture parse-cleanliness ([#21](https://github.com/meloncholic/tree-sitter-mssql/pull/21))
- shrink function fixtures to generic identifiers and add seven more ([#14](https://github.com/meloncholic/tree-sitter-mssql/pull/14))
- decouple CI and rebuild the fixture corpus ([#10](https://github.com/meloncholic/tree-sitter-mssql/pull/10))
- flatten fixtures by construct instead of origin ([#9](https://github.com/meloncholic/tree-sitter-mssql/pull/9))
- pin C, C++, gyp and scm sources to LF in .gitattributes ([#8](https://github.com/meloncholic/tree-sitter-mssql/pull/8))
- *(deps)* bump the npm-major group across 1 directory with 2 updates ([#2](https://github.com/meloncholic/tree-sitter-mssql/pull/2))
- *(deps)* bump the cargo-major group across 1 directory with 2 updates ([#1](https://github.com/meloncholic/tree-sitter-mssql/pull/1))
- *(deps)* label npm Dependabot PRs javascript instead of leaving them unlabeled
- add the org standard verify, cache-cleanup, and dev/main sync workflows

## [0.1.2](https://github.com/meloncholic/tree-sitter-mssql/compare/v0.1.1...v0.1.2) - 2026-09-06

### Fixed

- *(ci)* dispatch release.yml explicitly after tagging ([#37](https://github.com/meloncholic/tree-sitter-mssql/pull/37))

### Other

- promote dev to main to fix release.yml never triggering ([#38](https://github.com/meloncholic/tree-sitter-mssql/pull/38))

## [0.1.1](https://github.com/meloncholic/tree-sitter-mssql/compare/v0.1.0...v0.1.1) - 2026-09-06

### Fixed

- *(ci)* only match an open PR when reusing the release/sync branch ([#33](https://github.com/meloncholic/tree-sitter-mssql/pull/33))
- *(ci)* sync dev from a disposable branch, never from main itself ([#29](https://github.com/meloncholic/tree-sitter-mssql/pull/29))
- *(ci)* use npm pkg set for the release version bump ([#28](https://github.com/meloncholic/tree-sitter-mssql/pull/28))

### Other

- sync dev from main ([#26](https://github.com/meloncholic/tree-sitter-mssql/pull/26))

## [0.1.0](https://github.com/meloncholic/tree-sitter-mssql/releases/tag/v0.1.0) - 2026-09-06

### Added

- parse Service Broker DML, encryption DDL, security policies and XML schema collections ([#19](https://github.com/meloncholic/tree-sitter-mssql/pull/19))
- parse BULK INSERT and CREATE/ALTER/DROP EVENT SESSION ([#17](https://github.com/meloncholic/tree-sitter-mssql/pull/17))
- parse every pending fixture and reject misordered EXEC arguments ([#15](https://github.com/meloncholic/tree-sitter-mssql/pull/15))
- nest block comments and accept the bare table hint ([#7](https://github.com/meloncholic/tree-sitter-mssql/pull/7))
- wire up marlin structural and vocabulary linting ([#3](https://github.com/meloncholic/tree-sitter-mssql/pull/3))
- initial commit of the T-SQL tree-sitter grammar

### Fixed

- *(ci)* open PRs instead of pushing directly to protected branches ([#24](https://github.com/meloncholic/tree-sitter-mssql/pull/24))
- *(grammar)* parse CREATE MESSAGE TYPE's VALID_XML WITH SCHEMA COLLECTION ([#22](https://github.com/meloncholic/tree-sitter-mssql/pull/22))
- satisfy rustfmt and clippy in the generated build script

### Other

- automate crate and npm package releases ([#20](https://github.com/meloncholic/tree-sitter-mssql/pull/20))
- verify node-kind snapshot and fixture parse-cleanliness ([#21](https://github.com/meloncholic/tree-sitter-mssql/pull/21))
- shrink function fixtures to generic identifiers and add seven more ([#14](https://github.com/meloncholic/tree-sitter-mssql/pull/14))
- decouple CI and rebuild the fixture corpus ([#10](https://github.com/meloncholic/tree-sitter-mssql/pull/10))
- flatten fixtures by construct instead of origin ([#9](https://github.com/meloncholic/tree-sitter-mssql/pull/9))
- pin C, C++, gyp and scm sources to LF in .gitattributes ([#8](https://github.com/meloncholic/tree-sitter-mssql/pull/8))
- *(deps)* bump the npm-major group across 1 directory with 2 updates ([#2](https://github.com/meloncholic/tree-sitter-mssql/pull/2))
- *(deps)* bump the cargo-major group across 1 directory with 2 updates ([#1](https://github.com/meloncholic/tree-sitter-mssql/pull/1))
- *(deps)* label npm Dependabot PRs javascript instead of leaving them unlabeled
- add the org standard verify, cache-cleanup, and dev/main sync workflows
