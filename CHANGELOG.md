# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [0.1.5](https://github.com/meloncholic/tree-sitter-mssql/compare/v0.1.4...v0.1.5) - 2026-09-08

### Added

- parse ALTER TABLE SWITCH PARTITION, the $PARTITION pseudo-function, and graph table MATCH querying ([#8](https://github.com/meloncholic/tree-sitter-mssql/pull/8))
- parse FOR SYSTEM_TIME, AT TIME ZONE, TABLESAMPLE, and rowset function coverage ([#5](https://github.com/meloncholic/tree-sitter-mssql/pull/5))

### Fixed

- *(grammar)* correct identifier and multipart-name parsing, dedup helpers ([#3](https://github.com/meloncholic/tree-sitter-mssql/pull/3))

### Other

- *(docs)* correct LICENSE copyright name ([#4](https://github.com/meloncholic/tree-sitter-mssql/pull/4))
- promote dev to main ([#6](https://github.com/meloncholic/tree-sitter-mssql/pull/6))
- sync dev from main ([#7](https://github.com/meloncholic/tree-sitter-mssql/pull/7))
