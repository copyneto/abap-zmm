*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations
TYPES:     ty_t_key_tab TYPE SORTED TABLE OF /iwbep/s_mgw_name_value_pair
                        WITH NON-UNIQUE KEY name.

CONSTANTS: BEGIN OF gc_name,
             romaneio    TYPE string VALUE 'Romaneio',
             docuuidh    TYPE string VALUE 'DocUuidH',
             recebimento TYPE string VALUE 'Recebimento',
             itempedido  TYPE string VALUE 'ItemPedido',
           END OF gc_name,

           BEGIN OF gc_entity,
             imprimir TYPE string VALUE 'imprimir',
           END OF gc_entity.
