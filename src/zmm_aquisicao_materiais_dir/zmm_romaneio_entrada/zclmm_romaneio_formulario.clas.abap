class ZCLMM_ROMANEIO_FORMULARIO definition
  public
  final
  create public .

public section.

types: BEGIN OF ty_data_item.
        include TYPE ZSMM_ROMANEIO_ITE as Item RENAMING WITH SUFFIX _items.
        TYPES: lt_items  TYPE ZCTGMM_ROMANEIO_ITE,
               lt_caract TYPE ZCTGMM_ROMANEIO_CARACT,
       END OF ty_data_item,
       ty_tab_data_item TYPE STANDARD TABLE OF ty_data_item WITH NON-UNIQUE DEFAULT KEY .


  methods GET_DATA
     IMPORTING IT_ITE TYPE ZCTGMM_ROMANEIO_ITE
               IT_CARACT TYPE ZCTGMM_ROMANEIO_CARACT
     EXPORTING et_data TYPE   ty_tab_data_item.
protected section.
private section.

ENDCLASS.



CLASS ZCLMM_ROMANEIO_FORMULARIO IMPLEMENTATION.


  METHOD get_data.

    DATA: lv_char5 TYPE char5,
          lv_numc2 TYPE numc2.

    DATA: ls_ite LIKE LINE OF it_ite.

    LOOP AT it_ite ASSIGNING FIELD-SYMBOL(<fs_item>).

      APPEND INITIAL LINE TO et_data ASSIGNING FIELD-SYMBOL(<fs_data>).
      <fs_data>-romaneio_items        = <fs_item>-romaneio.
      <fs_data>-recebimento_items     = <fs_item>-recebimento.
      <fs_data>-item_items            = <fs_item>-item.
      <fs_data>-pedido_items          = <fs_item>-pedido.
      <fs_data>-material_items        = <fs_item>-material.
      <fs_data>-desc_material_items   = <fs_item>-desc_material.
      <fs_data>-lote_items            = <fs_item>-lote.
      <fs_data>-qtde_items            = <fs_item>-qtde.
      <fs_data>-qtd_kg_original_items = <fs_item>-qtd_kg_original.

      LOOP AT it_caract ASSIGNING FIELD-SYMBOL(<fs_caract>).
        CHECK <fs_caract>-item = <fs_item>-item.

        APPEND INITIAL LINE TO <fs_data>-lt_caract ASSIGNING FIELD-SYMBOL(<fs_data_caract>).
        <fs_data_caract> = CORRESPONDING #( <fs_caract> ).
      ENDLOOP.

      DATA(lv_linhas_block) = lines( <fs_data>-lt_caract ) + 2.

      DATA(lv_times) = 50 DIV lv_linhas_block.
      SUBTRACT 1 FROM lv_times.

      CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
        EXPORTING
          input  = <fs_item>-romaneio
        IMPORTING
          output = lv_char5.

      CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
        EXPORTING
          input  = lv_char5
        IMPORTING
          output = lv_char5.

      ls_ite = <fs_item>.

      CLEAR lv_numc2.
      DO lv_times TIMES.
        lv_numc2 = lv_numc2 + 1.
        ls_ite-lote+2 = |{ lv_char5 }{ '-' }{ lv_numc2 }|.
        APPEND ls_ite TO <fs_data>-lt_items.
      ENDDO.

    ENDLOOP.
  ENDMETHOD.
ENDCLASS.
