// External scanner for tree-sitter-mssql.
//
// It lexes the block comment (`marginalia`), because T-SQL block comments
// nest -- `/* outer /* inner */ still a comment */` is one comment -- and no
// regular expression can match balanced nesting. It also checks what follows a
// sqlcmd command name, which a regular expression cannot do without consuming
// the characters it looks at: whitespace or the end of input
// (`SQLCMD_BOUNDARY`), or spaces and then an argument on the same line
// (`SQLCMD_ARGUMENT`; for `:!!`, which needs no space and may have an empty
// command, `SQLCMD_INLINE` or `SQLCMD_EMPTY`).
// Everything else in the grammar is lexed from grammar.js.
#include "tree_sitter/parser.h"

enum TokenType {
  MARGINALIA,
  UNTERMINATED_COMMENT,
  SQLCMD_BOUNDARY,
  SQLCMD_ARGUMENT,
  SQLCMD_INLINE,
  SQLCMD_EMPTY,
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

static inline bool at_line_end(TSLexer *lexer) {
  return lexer->eof(lexer) || lexer->lookahead == '\r' || lexer->lookahead == '\n';
}

bool tree_sitter_mssql_external_scanner_scan(void *payload, TSLexer *lexer, const bool *valid_symbols) {
  (void)payload;
  // No rule accepts UNTERMINATED_COMMENT, so it is valid only during error
  // recovery, when every external token is. A zero-width token returned there
  // could be produced again at the same position, so the sqlcmd checks only run
  // during a normal parse.
  bool recovering = valid_symbols[UNTERMINATED_COMMENT];
  if (valid_symbols[SQLCMD_BOUNDARY] && !recovering) {
    if (lexer->eof(lexer) || is_space(lexer->lookahead)) {
      lexer->mark_end(lexer);
      lexer->result_symbol = SQLCMD_BOUNDARY;
      return true;
    }
    // A command name followed by anything else is not a command, including
    // one followed directly by a block comment.
    return false;
  }
  // sqlcmd reads a command one line at a time, so a command's argument must be
  // on the same line as its name. The spaces before the argument are skipped
  // and the token is zero-width, so the argument token starts right after it.
  if ((valid_symbols[SQLCMD_ARGUMENT] || valid_symbols[SQLCMD_INLINE]) && !recovering) {
    bool spaced = false;
    while (lexer->lookahead == ' ' || lexer->lookahead == '\t') {
      lexer->advance(lexer, true);
      spaced = true;
    }
    if (valid_symbols[SQLCMD_INLINE]) {
      // `:!!` decides here, once, whether its command is on this line, so a
      // block comment on the next line cannot let a later check find one.
      lexer->mark_end(lexer);
      lexer->result_symbol = at_line_end(lexer) ? SQLCMD_EMPTY : SQLCMD_INLINE;
      return true;
    }
    if (spaced && !at_line_end(lexer)) {
      lexer->mark_end(lexer);
      lexer->result_symbol = SQLCMD_ARGUMENT;
      return true;
    }
    // A command that needs an argument has none on its line.
    return false;
  }
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
      // SQL Server rejects an unterminated comment (Msg 113, "Missing end
      // comment mark"). Consume the rest of the input once as a token no rule
      // accepts, so it becomes a single ERROR node: refusing the token instead
      // would re-lex the comment body as statements and rescan to end of input
      // from every later `/*`.
      lexer->mark_end(lexer);
      lexer->result_symbol = UNTERMINATED_COMMENT;
      return true;
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
