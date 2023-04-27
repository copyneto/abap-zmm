CLASS zclmm_dep_fech_conver_unid DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_sadl_exit .
    INTERFACES if_sadl_exit_calc_element_read .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zclmm_dep_fech_conver_unid IMPLEMENTATION.
  METHOD if_sadl_exit_calc_element_read~calculate.

    DATA: lt_data  TYPE STANDARD TABLE OF zc_mm_administrar_emissao_nf,
          lv_menge TYPE bstmg.

    MOVE-CORRESPONDING it_original_data TO lt_data.

    LOOP AT lt_data ASSIGNING FIELD-SYMBOL(<fs_data>).



      CALL FUNCTION 'MD_CONVERT_MATERIAL_UNIT'
        EXPORTING
          i_matnr              = <fs_data>-Material
          i_in_me              = <fs_data>-OriginUnit
          i_out_me             = <fs_data>-OriginUnit
          i_menge              = <fs_data>-AvailableStock
        IMPORTING
          e_menge              = lv_menge
        EXCEPTIONS
          error_in_application = 1
          error                = 2
          OTHERS               = 3.
      IF sy-subrc <> 0.
        MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
          WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
      ENDIF.

*     <fs_data>-teste = '10.1111'.



    ENDLOOP.

    MOVE-CORRESPONDING lt_data TO ct_calculated_data.

  ENDMETHOD.

  METHOD if_sadl_exit_calc_element_read~get_calculation_info.
    RETURN.
  ENDMETHOD.

ENDCLASS.
