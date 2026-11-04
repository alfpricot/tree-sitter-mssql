//! This crate provides T-SQL (Microsoft SQL Server) language support for the [tree-sitter][] parsing library.
//!
//! Typically, you will use the [LANGUAGE][] constant to add this language to a
//! tree-sitter [Parser][], and then use the parser to parse some code:
//!
//! ```
//! let code = r#"
//! SELECT TOP (10) name FROM sys.objects WHERE type = 'U';
//! "#;
//! let mut parser = tree_sitter::Parser::new();
//! let language = tree_sitter_mssql::LANGUAGE;
//! parser
//!     .set_language(&language.into())
//!     .expect("Error loading T-SQL parser");
//! let tree = parser.parse(code, None).unwrap();
//! assert!(!tree.root_node().has_error());
//! ```
//!
//! [Parser]: https://docs.rs/tree-sitter/*/tree_sitter/struct.Parser.html
//! [tree-sitter]: https://tree-sitter.github.io/

use tree_sitter_language::LanguageFn;

unsafe extern "C" {
    fn tree_sitter_mssql() -> *const ();
}

/// The tree-sitter [`LanguageFn`][LanguageFn] for this grammar.
///
/// [LanguageFn]: https://docs.rs/tree-sitter-language/*/tree_sitter_language/struct.LanguageFn.html
pub const LANGUAGE: LanguageFn = unsafe { LanguageFn::from_raw(tree_sitter_mssql) };

/// The content of the [`node-types.json`][] file for this grammar.
///
/// [`node-types.json`]: https://tree-sitter.github.io/tree-sitter/using-parsers#static-node-types
pub const NODE_TYPES: &str = include_str!("../../src/node-types.json");

pub const HIGHLIGHTS_QUERY: &str = include_str!("../../queries/highlights.scm");
pub const INDENTS_QUERY: &str = include_str!("../../queries/indents.scm");
pub const INJECTIONS_QUERY: &str = include_str!("../../queries/injections.scm");
pub const LOCALS_QUERY: &str = include_str!("../../queries/locals.scm");
pub const TAGS_QUERY: &str = include_str!("../../queries/tags.scm");

#[cfg(test)]
mod tests {
    use tree_sitter::{Parser, Query, QueryCursor, StreamingIterator};

    #[test]
    fn test_can_load_grammar() {
        let mut parser = tree_sitter::Parser::new();
        parser
            .set_language(&super::LANGUAGE.into())
            .expect("Error loading T-SQL parser");
    }

    /// The text of every `capture` node the query finds in `source`, in
    /// document order. Duplicates are kept, so a query that captures one
    /// node twice fails the test that expects it once.
    fn captures(query_source: &str, source: &str, capture: &str) -> Vec<String> {
        let language = super::LANGUAGE.into();
        let mut parser = Parser::new();
        parser.set_language(&language).unwrap();
        let tree = parser.parse(source, None).unwrap();
        assert!(
            !tree.root_node().has_error(),
            "sample does not parse: {source}"
        );
        let query = Query::new(&language, query_source).unwrap();
        let index = query.capture_index_for_name(capture).unwrap();
        let mut cursor = QueryCursor::new();
        let mut found = Vec::new();
        let mut it = cursor.captures(&query, tree.root_node(), source.as_bytes());
        while let Some((m, i)) = it.next() {
            let c = m.captures()[*i];
            if c.index == index {
                found.push((
                    c.node.start_byte(),
                    c.node.utf8_text(source.as_bytes()).unwrap().to_string(),
                ));
            }
        }
        found.sort();
        found.into_iter().map(|(_, text)| text).collect()
    }

    #[test]
    fn tags_name_each_definition_but_not_a_trigger_table() {
        let source = "\
CREATE PROCEDURE dbo.load_orders AS BEGIN RETURN END
GO
CREATE FUNCTION dbo.order_total (@id int) RETURNS int AS BEGIN RETURN 1 END
GO
CREATE TRIGGER dbo.trg_orders ON dbo.orders AFTER INSERT AS SELECT 1;
GO
CREATE TABLE dbo.orders (id int);
CREATE VIEW dbo.open_orders AS SELECT id FROM dbo.orders;
CREATE TYPE dbo.order_id FROM int;
CREATE INDEX ix_orders_id ON dbo.orders (id);
";
        assert_eq!(
            captures(super::TAGS_QUERY, source, "name"),
            [
                "dbo.load_orders",
                "dbo.order_total",
                "dbo.trg_orders",
                "dbo.orders",
                "dbo.open_orders",
                "dbo.order_id",
                "ix_orders_id",
            ]
        );
    }

    #[test]
    fn locals_define_every_alias_and_cte_name() {
        let source = "\
WITH c (x) AS (SELECT 1 AS x)
SELECT * FROM t AS a
JOIN OPENJSON(@j) WITH (v int) AS oj ON 1 = 1
CROSS JOIN OPENJSON(@k) WITH (w int) ok
CROSS APPLY (VALUES (1)) AS ap (n)
PIVOT (MAX(v) FOR w IN ([1])) AS pv;
SELECT f.v FROM OPENJSON(@j) WITH (v int) AS f;
MERGE dbo.t AS tgt USING dbo.s AS src ON tgt.id = src.id
WHEN MATCHED THEN DELETE;
";
        assert_eq!(
            captures(super::LOCALS_QUERY, source, "local.definition"),
            ["c", "a", "oj", "ok", "ap", "pv", "f", "tgt", "src"]
        );
    }

    #[test]
    fn injections_cover_exec_literals_and_their_concatenation() {
        let source = "\
EXEC('SELECT 1');
EXEC('SELECT * FROM ' + @t + ' WHERE a = ' + @a + ' AND b = 1' + @b + '' + @c + ' ORDER BY 1');
EXECUTE(N'SELECT 2') AS USER = 'u';
EXEC sp_executesql N'SELECT @p', N'@p int', @p = 1;
SELECT 'not' + 'sql';
EXEC('SELECT TOP ' + 10 + ' x');
EXEC('a' - 'b');
EXEC(10);
";
        assert_eq!(
            captures(super::INJECTIONS_QUERY, source, "injection.content"),
            [
                "'SELECT 1'",
                "'SELECT * FROM '",
                "' WHERE a = '",
                "' AND b = 1'",
                "''",
                "' ORDER BY 1'",
                "N'SELECT 2'",
                "N'SELECT @p'",
                "'SELECT TOP '",
                "' x'",
            ]
        );
    }
}
