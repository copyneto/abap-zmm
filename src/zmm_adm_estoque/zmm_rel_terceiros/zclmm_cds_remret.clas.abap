CLASS zclmm_cds_remret DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_sadl_exit .
    INTERFACES if_sadl_exit_calc_element_read .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zclmm_cds_remret IMPLEMENTATION.

  METHOD if_sadl_exit_calc_element_read~get_calculation_info.

    LOOP AT it_requested_calc_elements ASSIGNING FIELD-SYMBOL(<fs_calc_element>).
      APPEND 'QTDEREMESSA' TO et_requested_orig_elements.
      APPEND 'QTDERETORNO' TO et_requested_orig_elements.
    ENDLOOP.

  ENDMETHOD.

  METHOD if_sadl_exit_calc_element_read~calculate.

    DATA: lt_original_data TYPE STANDARD TABLE OF zi_mm_rel_terc WITH DEFAULT KEY.

    DATA: lv_soma TYPE menge_d.

    lt_original_data = CORRESPONDING #( it_original_data ).


    LOOP AT lt_original_data ASSIGNING FIELD-SYMBOL(<fs_data>).

      lv_soma = <fs_data>-QtdeRemessa - <fs_data>-QtdeRetorno.

      WRITE lv_soma TO <fs_data>-Soma.

    ENDLOOP.

    ct_calculated_data = CORRESPONDING #(  lt_original_data ).

  ENDMETHOD.


ENDCLASS.
