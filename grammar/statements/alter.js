import { comma_list, paren_list } from "../helpers.js";
import { event_session_body } from "./create.js";

export default {

  _alter_statement: $ => choice(
    $.alter_table,
    $.alter_view,
    $.alter_index,
    $.alter_database,
    $.alter_schema,
    $.alter_role,
    $.alter_user,
    $.alter_login,
    $.alter_sequence,
    $.alter_authorization,
    $.alter_procedure,
    $.alter_function,
    $.alter_trigger,
    $.alter_server_audit,
    $.alter_event_session,
    $.alter_master_key,
    $.alter_certificate,
    $.alter_symmetric_key,
    $.alter_asymmetric_key,
    $.alter_security_policy,
    $.alter_xml_schema_collection,
  ),

  // ALTER XML SCHEMA COLLECTION name ADD expression
  alter_xml_schema_collection: $ => seq(
    $.keyword_alter,
    $.keyword_xml,
    $.keyword_schema,
    $.keyword_collection,
    field('name', $.object_reference),
    $.keyword_add,
    $._expression,
  ),

  // ALTER TABLE name
  //     [WITH { CHECK | NOCHECK }] ADD { column | constraint } [, ...]
  //   | DROP { [CONSTRAINT] [IF EXISTS] name [, ...] | COLUMN [IF EXISTS] name [, ...] }
  //   | ALTER COLUMN name { type [COLLATE name] [NULL | NOT NULL] | ADD/DROP flag }
  //   | { CHECK | NOCHECK } CONSTRAINT { ALL | name [, ...] }
  //   | { ENABLE | DISABLE } TRIGGER { ALL | name [, ...] }
  //   | SET ( option [, ...] )
  //   | REBUILD [WITH (options)]
  //   | SWITCH [PARTITION expr] TO table [PARTITION expr]
  alter_table: $ => prec.right(seq(
    $.keyword_alter,
    $.keyword_table,
    $.object_reference,
    choice(
      seq(
        optional(seq($.keyword_with, choice($.keyword_check, $.keyword_nocheck))),
        $.keyword_add,
        comma_list(choice($.column_definition, $.constraint, $.period_for_system_time), true),
      ),
      seq(
        $.keyword_drop,
        choice(
          seq($.keyword_column, optional($._if_exists), comma_list($.identifier, true)),
          seq(optional($.keyword_constraint), optional($._if_exists), comma_list($.identifier, true)),
        ),
      ),
      seq(
        $.keyword_alter,
        $.keyword_column,
        field('name', $.identifier),
        choice(
          seq(
            field('type', $._type),
            optional(seq($.keyword_collate, $.identifier)),
            optional(choice($.keyword_null, $._not_null)),
          ),
          seq(choice($.keyword_add, $.keyword_drop), $.identifier),
        ),
      ),
      seq(
        optional(seq($.keyword_with, choice($.keyword_check, $.keyword_nocheck))),
        choice($.keyword_check, $.keyword_nocheck),
        $.keyword_constraint,
        choice($.keyword_all, comma_list($.identifier, true)),
      ),
      seq(
        choice($.keyword_enable, $.keyword_disable),
        $.keyword_trigger,
        choice($.keyword_all, comma_list($.identifier, true)),
      ),
      seq($.keyword_set, paren_list($.option, true)),
      seq($.keyword_rebuild, optional($.with_options)),
      seq(
        $.keyword_switch,
        optional(seq($.keyword_partition, field('from_partition', $._expression))),
        $.keyword_to,
        field('target', $.object_reference),
        optional(seq($.keyword_partition, field('to_partition', $._expression))),
      ),
    ),
  )),

  // ALTER INDEX { name | ALL } ON table { REBUILD [WITH (options)] | REORGANIZE [WITH (options)] | DISABLE | SET (options) }
  alter_index: $ => prec.right(seq(
    $.keyword_alter,
    $.keyword_index,
    choice($.keyword_all, field('name', $.identifier)),
    $.keyword_on,
    $.object_reference,
    choice(
      seq($.keyword_rebuild, optional($.with_options)),
      seq($.keyword_reorganize, optional($.with_options)),
      $.keyword_disable,
      seq($.keyword_set, paren_list($.option, true)),
    ),
  )),

  // ALTER DATABASE name { SET option [, ...] [WITH termination] | MODIFY NAME = name | COLLATE name }
  // ALTER DATABASE SCOPED CONFIGURATION SET option = value
  // Options are identifiers with an optional value: RECOVERY SIMPLE,
  // READ_ONLY, AUTO_UPDATE_STATISTICS ON, COMPATIBILITY_LEVEL = 150.
  alter_database: $ => prec.right(seq(
    $.keyword_alter,
    $.keyword_database,
    $.identifier,
    optional($.identifier),
    choice(
      seq(
        $.keyword_set,
        comma_list($.option, true),
        optional(seq($.keyword_with, choice(
          seq($.keyword_rollback, $.identifier),
          $.identifier,
        ))),
      ),
      seq($.keyword_modify, $.option),
      seq($.keyword_collate, $.identifier),
    ),
  )),

  // ALTER SCHEMA name TRANSFER [class::] object
  alter_schema: $ => seq(
    $.keyword_alter,
    $.keyword_schema,
    $.identifier,
    $.keyword_transfer,
    optional(seq($.identifier, '::')),
    $.object_reference,
  ),

  // ALTER [SERVER] ROLE name { ADD MEMBER name | DROP MEMBER name | WITH NAME = name }
  alter_role: $ => seq(
    $.keyword_alter,
    optional($.keyword_server),
    $.keyword_role,
    $.identifier,
    choice(
      seq($.keyword_add, $.keyword_member, $.identifier),
      seq($.keyword_drop, $.keyword_member, $.identifier),
      $.with_clause,
    ),
  ),

  // ALTER USER name WITH option [, ...]
  alter_user: $ => seq(
    $.keyword_alter,
    $.keyword_user,
    $.identifier,
    $.with_clause,
  ),

  // ALTER LOGIN name { ENABLE | DISABLE | WITH option [, ...] | ADD/DROP CREDENTIAL name }
  alter_login: $ => seq(
    $.keyword_alter,
    $.keyword_login,
    $.identifier,
    choice(
      $.keyword_enable,
      $.keyword_disable,
      $.with_clause,
      seq(choice($.keyword_add, $.keyword_drop), $.identifier, $.identifier),
    ),
  ),

  // ALTER SEQUENCE name option [...]
  alter_sequence: $ => prec.right(seq(
    $.keyword_alter,
    $.keyword_sequence,
    $.object_reference,
    repeat1($.sequence_option),
  )),

  // ALTER AUTHORIZATION ON [class::] object TO { principal | SCHEMA OWNER }
  alter_authorization: $ => seq(
    $.keyword_alter,
    $.keyword_authorization,
    $.keyword_on,
    optional(seq($.identifier, '::')),
    $.object_reference,
    $.keyword_to,
    choice(
      seq($.keyword_schema, $.keyword_owner),
      $.identifier,
    ),
  ),

  // ALTER EVENT SESSION name ON SERVER
  //   { [ADD EVENT ...] [ADD TARGET ...] [DROP EVENT name [, ...]]
  //     [DROP TARGET name [, ...]] [WITH (options)]
  //   | STATE = START | STOP }
  // STATE = value must be the statement's only clause — SQL Server rejects
  // combining it with ADD/DROP/WITH — so it is a separate alternative
  // rather than one more optional segment of event_session_body() (shared
  // with create_event_session in create.js, whose comment there explains
  // the fixed ADD/DROP/WITH clause order this assumes).
  alter_event_session: $ => prec.right(seq(
    $.keyword_alter,
    $.keyword_event,
    $.keyword_session,
    field('name', $.identifier),
    $.keyword_on,
    $.keyword_server,
    choice(
      event_session_body($),
      $.option,
    ),
  )),

};
