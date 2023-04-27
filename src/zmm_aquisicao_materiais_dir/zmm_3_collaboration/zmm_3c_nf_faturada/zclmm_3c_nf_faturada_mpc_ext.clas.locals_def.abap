*"* use this source file for any type of declarations (class
*"* definitions, interfaces or type declarations) you need for
*"* components in the private section

* ======================================================================
* Global constants
* ======================================================================

    CONSTANTS:
      BEGIN OF gc_fields,
        Docnum  TYPE /iwbep/if_mgw_med_odata_types=>ty_e_med_entity_name VALUE 'Docnum' ##NO_TEXT,
        Doctype TYPE /iwbep/if_mgw_med_odata_types=>ty_e_med_entity_name VALUE 'Doctype' ##NO_TEXT,
        guid    TYPE /iwbep/if_mgw_med_odata_types=>ty_e_med_entity_name VALUE 'Guid' ##NO_TEXT,
      END OF gc_fields,

      BEGIN OF gc_entity,
        localDownload TYPE /iwbep/if_mgw_med_odata_types=>ty_e_med_entity_name VALUE 'localDownload' ##NO_TEXT,
      END OF gc_entity.
