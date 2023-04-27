CLASS zclmm_monitor_servic_calpedido DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_sadl_exit .
    INTERFACES if_sadl_exit_calc_element_read .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zclmm_monitor_servic_calpedido IMPLEMENTATION.
  METHOD if_sadl_exit_calc_element_read~calculate.
    DATA lt_calculated_fields TYPE TABLE OF zi_mm_monit_serv_po_values.
    lt_calculated_fields = CORRESPONDING #( it_original_data ).

    LOOP AT lt_calculated_fields ASSIGNING FIELD-SYMBOL(<fs_calculated_field>).
      <fs_calculated_field>-QtdadeDisponivel = 10. "<fs_calculated_field>-QtdadePedido - <fs_calculated_field>-QtdadeLancada.
    ENDLOOP.

    ct_calculated_data = CORRESPONDING #( lt_calculated_fields ).
  ENDMETHOD.

  METHOD if_sadl_exit_calc_element_read~get_calculation_info.
    APPEND 'QTDADEPEDIDO' TO et_requested_orig_elements.
    APPEND 'QTDADELANCADA' TO et_requested_orig_elements.
  ENDMETHOD.

ENDCLASS.
