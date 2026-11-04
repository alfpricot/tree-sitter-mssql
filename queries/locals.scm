; Local variable and scope resolution.
;
; Covers the definition sites a consumer needs to resolve a qualified column
; reference (`t.col`) against: a FROM relation's alias, an APPLY, PIVOT or
; UNPIVOT alias, a MERGE target or source alias, and a CTE name.
;
; `statement` is the scope of a lone query. Its `ORDER BY` sits beside
; `query_specification`, not inside it, so the table alias has to be
; visible from that outer scope. A `query_specification` is its own scope
; when it is one arm of a set operation, or the body of a subquery, so
; those aliases do not leak into the enclosing statement. A CTE name stays
; in the outer statement scope, next to the query that references it.
(statement) @local.scope

(set_operation
  (query_specification) @local.scope)

(subquery
  (query_specification) @local.scope)

(relation
  alias: (identifier) @local.definition)

; CROSS/OUTER APPLY's alias, and the alias after a PIVOT or UNPIVOT clause.
(apply_join
  alias: (identifier) @local.definition)

(pivot_clause
  alias: (identifier) @local.definition)

(unpivot_clause
  alias: (identifier) @local.definition)

; MERGE t AS tgt USING src AS s: both aliases are `alias` fields of the
; `merge` node, and the WHEN clauses reference either one.
(merge
  alias: (identifier) @local.definition)

; A CTE's own name is its `name` field; its optional column list
; (`WITH c (a, b) AS (...)`) is the separate `argument` field.
(cte
  name: (identifier) @local.definition)

(field
  (object_reference
    name: (identifier) @local.reference))
