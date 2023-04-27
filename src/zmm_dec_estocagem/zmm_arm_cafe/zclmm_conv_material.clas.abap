CLASS zclmm_conv_material DEFINITION
 PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_sadl_exit .
    INTERFACES if_sadl_exit_calc_element_read .

  PROTECTED SECTION.
  PRIVATE SECTION.

    CONSTANTS: BEGIN OF gc_value,
                 Material           TYPE string VALUE 'MATERIAL' ##NO_TEXT,
                 BaseUnit           TYPE string VALUE 'BASEUNIT' ##NO_TEXT,
                 meins              TYPE string VALUE 'MEINS' ##NO_TEXT,
                 QuantityInBaseUnit TYPE string VALUE 'QUANTITYINBASEUNIT' ##NO_TEXT,
               END OF gc_value.
ENDCLASS.



CLASS zclmm_conv_material IMPLEMENTATION.


  METHOD if_sadl_exit_calc_element_read~calculate.

    DATA: lt_original_data TYPE STANDARD TABLE OF zi_mm_01_cafe WITH DEFAULT KEY,
          lv_brgew         TYPE brgew,
          lv_ntgew         TYPE ntgew.

    lt_original_data = CORRESPONDING #( it_original_data ).

    LOOP AT lt_original_data ASSIGNING FIELD-SYMBOL(<fs_data>).

      CALL FUNCTION 'MD_CONVERT_MATERIAL_UNIT'
        EXPORTING
          i_matnr              = <fs_data>-Material
          i_in_me              = <fs_data>-BaseUnit
          i_out_me             = <fs_data>-meins
          i_menge              = <fs_data>-QuantityInBaseUnit
        IMPORTING
          e_menge              = lv_ntgew
        EXCEPTIONS
          error_in_application = 1
          error                = 2
          OTHERS               = 3.

      IF sy-subrc EQ 0.
        <fs_data>-menge =  lv_ntgew.
      ENDIF.

      <fs_data>-peso_dif_nf = <fs_data>-menge - <fs_data>-qtd_total_kg.

      IF <fs_data>-peso_dif_nf GT 0.
           <fs_data>-StatusCriticality = 2.
      ELSEIF <fs_data>-peso_dif_nf EQ 0.
           <fs_data>-StatusCriticality = 3.
      ELSE.
           <fs_data>-StatusCriticality = 1.
      ENDIF.

      CLEAR: lv_ntgew.

    ENDLOOP.

    ct_calculated_data = CORRESPONDING #( lt_original_data ).

  ENDMETHOD.


  METHOD if_sadl_exit_calc_element_read~get_calculation_info.

    INSERT gc_value-material            INTO TABLE et_requested_orig_elements.
    INSERT gc_value-baseunit            INTO TABLE et_requested_orig_elements.
    INSERT gc_value-meins               INTO TABLE et_requested_orig_elements.
    INSERT gc_value-quantityinbaseunit  INTO TABLE et_requested_orig_elements.

  ENDMETHOD.
ENDCLASS.
