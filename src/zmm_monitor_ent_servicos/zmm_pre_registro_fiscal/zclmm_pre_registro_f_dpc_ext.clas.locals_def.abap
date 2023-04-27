*"* use this source file for any type of declarations (class
*"* definitions, interfaces or type declarations) you need for
*"* components in the private section

    CONSTANTS:
      BEGIN OF gc_fields,
        id   TYPE /iwbep/s_mgw_name_value_pair-name VALUE 'Id' ##NO_TEXT,
      END OF gc_fields,

      BEGIN OF gc_entity,
        download TYPE string VALUE 'download' ##NO_TEXT,
      END OF gc_entity.
