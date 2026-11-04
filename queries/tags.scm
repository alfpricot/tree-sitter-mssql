; Symbol extraction.
;
; Every definition below carries a `name` field, so a pattern matches the
; field rather than a position. A trigger's ON table is a second
; object_reference in the same node, in its own `target` field, so it is never
; tagged as the trigger's name.

(create_procedure
  name: (object_reference) @name) @definition.function

(alter_procedure
  name: (object_reference) @name) @definition.function

(create_function
  name: (object_reference) @name) @definition.function

(alter_function
  name: (object_reference) @name) @definition.function

(create_trigger
  name: (object_reference) @name) @definition.function

(alter_trigger
  name: (object_reference) @name) @definition.function

(create_table
  name: (object_reference) @name) @definition.class

(create_view
  name: (object_reference) @name) @definition.class

(alter_view
  name: (object_reference) @name) @definition.class

(create_type
  name: (object_reference) @name) @definition.type

(create_index
  name: (identifier) @name) @definition.class
