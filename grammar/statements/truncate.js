// TRUNCATE TABLE name
export default {

  truncate_statement: $ => seq(
    $.keyword_truncate,
    $.keyword_table,
    $.object_reference,
  ),

};
