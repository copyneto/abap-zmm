class ZCLMM_CDS_CFOP definition
  public
  final
  create public .

public section.

  interfaces IF_SADL_EXIT .
  interfaces IF_SADL_EXIT_CALC_ELEMENT_READ .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZCLMM_CDS_CFOP IMPLEMENTATION.


  METHOD if_sadl_exit_calc_element_read~calculate.

    DATA: lt_original_data TYPE STANDARD TABLE OF zi_mm_mov_param WITH DEFAULT KEY.

    lt_original_data = CORRESPONDING #( it_original_data ).

    LOOP AT lt_original_data ASSIGNING FIELD-SYMBOL(<fs_data>).

      CALL FUNCTION 'CONVERSION_EXIT_CCEST_OUTPUT'
        EXPORTING
          input  = <fs_data>-cfop
        IMPORTING
          output = <fs_data>-cfop.

    ENDLOOP.

    ct_calculated_data = CORRESPONDING #(  lt_original_data ).

  ENDMETHOD.


  METHOD IF_SADL_EXIT_CALC_ELEMENT_READ~GET_CALCULATION_INFO.

      LOOP AT it_requested_calc_elements ASSIGNING FIELD-SYMBOL(<fs_calc_element>).
          APPEND 'CFOP' TO et_requested_orig_elements.
      ENDLOOP.

  ENDMETHOD.
ENDCLASS.
