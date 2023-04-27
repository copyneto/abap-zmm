*"* use this source file for any type of declarations (class
*"* definitions, interfaces or type declarations) you need for
*"* components in the private section

* ===========================================================================
* GLOBAL CONSTANTS
* ===========================================================================

CONSTANTS: BEGIN OF gc_status,
             criado     TYPE ztmm_inventory_h-status VALUE ' ',
             incompleto TYPE ztmm_inventory_h-status VALUE '00',
             liberado   TYPE ztmm_inventory_h-status VALUE '01',
             cancelado  TYPE ztmm_inventory_h-status VALUE '02',
           END OF gc_status.
