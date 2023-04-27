*"* use this source file for any type of declarations (class
*"* definitions, interfaces or type declarations) you need for
*"* components in the private section

* ===========================================================================
* GLOBAL CONSTANTS
* ===========================================================================

CONSTANTS: BEGIN OF gc_doctype,
             nfe    TYPE ze_doctype_pdf VALUE '1',
             cce    TYPE ze_doctype_pdf VALUE '2',
             boleto TYPE ze_doctype_pdf VALUE '3',
             mdfe   TYPE ze_doctype_pdf VALUE '4',
           END OF gc_doctype.
