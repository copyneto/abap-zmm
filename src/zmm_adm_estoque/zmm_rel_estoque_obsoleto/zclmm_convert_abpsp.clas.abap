"!<p>Rotina de conversão para o campo ABPSP. <br/>
"! Esta classe é utilizada na CDS view <em>ZI_MM_ESTQ_OBSOLETO</em> <br/> <br/>
"!<p><strong>Autor:</strong> Thiago da Graça - Meta</p>
"!<p><strong>Data:</strong> 05/out/2021</p>
CLASS zclmm_convert_abpsp DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_sadl_exit .
    INTERFACES if_sadl_exit_calc_element_read.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zclmm_convert_abpsp IMPLEMENTATION.
  METHOD if_sadl_exit_calc_element_read~calculate.
    DATA: lt_calculated_data TYPE STANDARD TABLE OF zi_mm_tipo_mov WITH DEFAULT KEY.

    IF it_original_data IS INITIAL.
      RETURN.
    ENDIF.

    MOVE-CORRESPONDING it_original_data TO lt_calculated_data.

    LOOP AT lt_calculated_data ASSIGNING FIELD-SYMBOL(<fs_calc_data>).

      IF <fs_calc_data>-WBSElementInternalID IS NOT INITIAL.

        CALL FUNCTION 'CONVERSION_EXIT_PARVW_OUTPUT'
          EXPORTING
            input  = <fs_calc_data>-WBSElementInternalID
          IMPORTING
            output = <fs_calc_data>-WBSElementInternalID1.

      ENDIF.

    ENDLOOP.

    MOVE-CORRESPONDING lt_calculated_data TO ct_calculated_data.
  ENDMETHOD.

  METHOD if_sadl_exit_calc_element_read~get_calculation_info.
    APPEND 'WBSELEMENTINTERNALID' TO et_requested_orig_elements.
  ENDMETHOD.

ENDCLASS.
