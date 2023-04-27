*"* use this source file for any type of declarations (class
*"* definitions, interfaces or type declarations) you need for
*"* components in the private section

* ===========================================================================
* CONSTANTES
* ===========================================================================

CONSTANTS:
  BEGIN OF gc_fields,
    docnum  TYPE string VALUE 'Docnum' ##NO_TEXT,
    doctype TYPE string VALUE 'Doctype' ##NO_TEXT,
    guid    TYPE string VALUE 'Guid' ##NO_TEXT,
  END OF gc_fields,

  BEGIN OF gc_fields_u,
    docnum  TYPE string VALUE 'DOCNUM' ##NO_TEXT,
    doctype TYPE string VALUE 'DOCTYPE' ##NO_TEXT,
    guid    TYPE string VALUE 'GUID' ##NO_TEXT,
  END OF gc_fields_u,

  BEGIN OF gc_entity,
    localDownload TYPE string VALUE 'localDownload' ##NO_TEXT,
  END OF gc_entity.
