// Rules shared by more than one module kind (procedure, function, trigger).
export default {
  // A CLR module's body: the method in a registered assembly that implements
  // the procedure, function, or trigger.
  //   EXTERNAL NAME assembly_name.[Namespace.Class].method_name
  external_name: ($) =>
    seq($.keyword_external, $.keyword_name, field('method', $.object_reference)),

  // EXECUTE AS { CALLER | SELF | OWNER | 'user_name' } — the module-level
  // execution-context option shared by procedures, functions, and triggers
  // (procedure_option in create-procedure.js, function_option in
  // create-function.js, trigger_option in create.js).
  execute_as_clause: ($) =>
    seq(
      choice($.keyword_exec, $.keyword_execute),
      $.keyword_as,
      choice(
        $.keyword_caller,
        $.keyword_self,
        $.keyword_owner,
        alias($._single_quote_string, $.literal),
      ),
    ),
};
