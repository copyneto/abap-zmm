CLASS zclmm_lib_pgt_grverde_desc_com DEFINITION
  PUBLIC
  INHERITING FROM zclmm_libpg_grvde_disc
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    METHODS zifmm_lib_pgto_graoverde_desc~build REDEFINITION .

  PROTECTED SECTION.
  PRIVATE SECTION.

    CONSTANTS:

      BEGIN OF gc_item,
        pmnt_block TYPE acpi_zlspr VALUE 'C',
        item_text  TYPE sgtxt VALUE 'Desconto NF',
      END OF gc_item,

      BEGIN OF gc_document,
        header_txt TYPE bktxt VALUE 'Desconto Comercial',
        xref1_hd   TYPE xref1_hd VALUE 'Desconto-Lib-GV',
      END OF gc_document.

ENDCLASS.



CLASS zclmm_lib_pgt_grverde_desc_com IMPLEMENTATION.

  METHOD zifmm_lib_pgto_graoverde_desc~build.

    super->zifmm_lib_pgto_graoverde_desc~build( ).

*TO DO: Implementar construção dos parâmetros da BAPI

  ENDMETHOD.

ENDCLASS.
