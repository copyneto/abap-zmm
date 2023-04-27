CLASS zclmm_url_mestre_materiais DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_sadl_exit .
    INTERFACES if_sadl_exit_calc_element_read .
  PROTECTED SECTION.
  PRIVATE SECTION.
    CONSTANTS:

      BEGIN OF gc_semantic,
        object               TYPE char30 VALUE 'mestrematerial',
        action_global        TYPE char60 VALUE 'global',
        action_basicos       TYPE char60 VALUE 'basicos',
        action_compras       TYPE char60 VALUE 'compras',
        action_mrp           TYPE char60 VALUE 'mrp',
        action_vendas        TYPE char60 VALUE 'vendas',
        action_qualidade     TYPE char60 VALUE 'qualidade',
        action_contabilidade TYPE char60 VALUE 'contabilidade',
        action_um            TYPE char60 VALUE 'um',
      END OF gc_semantic.

ENDCLASS.


CLASS zclmm_url_mestre_materiais IMPLEMENTATION.

  METHOD if_sadl_exit_calc_element_read~calculate.

    DATA: lt_calculated_data TYPE TABLE OF zc_mm_mestre_materiais WITH DEFAULT KEY.
    lt_calculated_data = CORRESPONDING #( it_original_data ).

    LOOP AT lt_calculated_data ASSIGNING FIELD-SYMBOL(<fs_calculated>).

      CASE <fs_calculated>-visionid.
        WHEN '1'. " Global
          DATA(lv_action) = gc_semantic-action_global.
        WHEN '2'. " Dados básicos
          lv_action = gc_semantic-action_basicos.
        WHEN '3'. " Compras
          lv_action = gc_semantic-action_compras.
        WHEN '4'. " MRP
          lv_action = gc_semantic-action_mrp.
        WHEN '5'. " Vendas
          lv_action = gc_semantic-action_vendas.
        WHEN '6'. " Qualidade
          lv_action = gc_semantic-action_qualidade.
        WHEN '7'. " Contabilidade
          lv_action = gc_semantic-action_contabilidade.
        WHEN '8'. " Unidade de Medida
          lv_action = gc_semantic-action_um.
      ENDCASE.
      <fs_calculated>-url = cl_lsapi_manager=>create_flp_url( object = gc_semantic-object
                                                              action = lv_action ).
    ENDLOOP.

    ct_calculated_data = CORRESPONDING #( lt_calculated_data ).

  ENDMETHOD.


  METHOD if_sadl_exit_calc_element_read~get_calculation_info.
    IF et_requested_orig_elements IS INITIAL.
      APPEND 'VISIONID' TO et_requested_orig_elements.
    ENDIF.
  ENDMETHOD.
ENDCLASS.
