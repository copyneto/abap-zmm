CLASS zclmm_cds_btcestdet DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_sadl_exit .
    INTERFACES if_sadl_exit_calc_element_read .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.

CLASS zclmm_cds_btcestdet IMPLEMENTATION.
  METHOD if_sadl_exit_calc_element_read~get_calculation_info.

      LOOP AT it_requested_calc_elements ASSIGNING FIELD-SYMBOL(<fs_calc_element>).
          APPEND 'CEST' TO et_requested_orig_elements.
      ENDLOOP.

  ENDMETHOD.

  METHOD if_sadl_exit_calc_element_read~calculate.

    DATA: lt_original_data TYPE STANDARD TABLE OF zi_mm_icms_st_det WITH DEFAULT KEY.

    lt_original_data = CORRESPONDING #( it_original_data ).

    LOOP AT lt_original_data ASSIGNING FIELD-SYMBOL(<fs_data>).

      CALL FUNCTION 'CONVERSION_EXIT_CCEST_OUTPUT'
        EXPORTING
          input  = <fs_data>-cest
        IMPORTING
          output = <fs_data>-cest_out.

    ENDLOOP.

    ct_calculated_data = CORRESPONDING #(  lt_original_data ).

  ENDMETHOD.
ENDCLASS.
