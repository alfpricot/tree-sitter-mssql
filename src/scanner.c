// External scanner for tree-sitter-mssql.
//
// Its only job is the block comment (`marginalia`), because T-SQL block
// comments nest -- `/* outer /* inner */ still a comment */` is one comment --
// and no regular expression can match balanced nesting. Everything else in
// the grammar is lexed from grammar.js.
#include "tree_sitter/parser.h"

enum TokenType {
  MARGINALIA,
};

void *tree_sitter_mssql_external_scanner_create(void) { return NULL; }
void tree_sitter_mssql_external_scanner_destroy(void *payload) { (void)payload; }
unsigned tree_sitter_mssql_external_scanner_serialize(void *payload, char *buffer) {
  (void)payload;
  (void)buffer;
  return 0;
}
void tree_sitter_mssql_external_scanner_deserialize(void *payload, const char *buffer, unsigned length) {
  (void)payload;
  (void)buffer;
  (void)length;
}

static inline bool is_space(int32_t c) {
  return c == ' ' || c == '\t' || c == '\r' || c == '\n' || c == '\f' || c == '\v';
}

bool tree_sitter_mssql_external_scanner_scan(void *payload, TSLexer *lexer, const bool *valid_symbols) {
  (void)payload;
  if (!valid_symbols[MARGINALIA]) {
    return false;
  }
  while (is_space(lexer->lookahead)) {
    lexer->advance(lexer, true);
  }
  if (lexer->lookahead != '/') {
    return false;
  }
  lexer->advance(lexer, false);
  if (lexer->lookahead != '*') {
    return false;
  }
  lexer->advance(lexer, false);

  unsigned depth = 1;
  while (depth > 0) {
    if (lexer->eof(lexer)) {
      // An unterminated comment runs to end of input, as SQL Server treats it.
      break;
    }
    if (lexer->lookahead == '/') {
      lexer->advance(lexer, false);
      if (lexer->lookahead == '*') {
        lexer->advance(lexer, false);
        depth++;
      }
    } else if (lexer->lookahead == '*') {
      lexer->advance(lexer, false);
      if (lexer->lookahead == '/') {
        lexer->advance(lexer, false);
        depth--;
      }
    } else {
      lexer->advance(lexer, false);
    }
  }
  lexer->mark_end(lexer);
  lexer->result_symbol = MARGINALIA;
  return true;
}
