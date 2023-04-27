"!<p>Rotina de conversão para o campo SERNR. <br/>
"! Esta classe é utilizada na CDS view <em>ZC_MM_REMESSA e ZC_MM_RETORNO</em> <br/> <br/>
"!<p><strong>Autor:</strong> Thiago da Graça - Meta</p>
"!<p><strong>Data:</strong> 20/10/2021</p>
CLASS zclmm_convert_sernr DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_sadl_exit .
    INTERFACES if_sadl_exit_calc_element_read.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zclmm_convert_sernr IMPLEMENTATION.
  METHOD if_sadl_exit_calc_element_read~calculate.
    DATA: lt_calculated_data TYPE STANDARD TABLE OF zi_MM_COPACKER WITH DEFAULT KEY.

    IF it_original_data IS INITIAL.
      RETURN.
    ENDIF.

    MOVE-CORRESPONDING it_original_data TO lt_calculated_data.

    LOOP AT lt_calculated_data ASSIGNING FIELD-SYMBOL(<fs_calc_data>).

      IF <fs_calc_data>-SerialNumber IS NOT INITIAL.

        CALL FUNCTION 'CONVERSION_EXIT_GERNR_OUTPUT'
          EXPORTING
            input  = <fs_calc_data>-SerialNumber
          IMPORTING
            output = <fs_calc_data>-SerialNumber2.

      ENDIF.

    ENDLOOP.

    MOVE-CORRESPONDING lt_calculated_data TO ct_calculated_data.
  ENDMETHOD.

  METHOD if_sadl_exit_calc_element_read~get_calculation_info.
    APPEND 'SERIALNUMBER' TO et_requested_orig_elements.
  ENDMETHOD.

ENDCLASS.
