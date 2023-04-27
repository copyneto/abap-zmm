CLASS zclmm_conv_mat DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    CONSTANTS: gc_un TYPE meins VALUE 'UN'.

    INTERFACES if_sadl_exit .
    INTERFACES if_sadl_exit_calc_element_read .

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zclmm_conv_mat IMPLEMENTATION.

  METHOD if_sadl_exit_calc_element_read~calculate.

    DATA: lt_original_data TYPE STANDARD TABLE OF zi_mm_conf_prod WITH DEFAULT KEY,
          lv_brgew         TYPE brgew,
          lv_ntgew         TYPE ntgew,
          lv_meinh         TYPE lrmei.

    lt_original_data = CORRESPONDING #( it_original_data ).

    LOOP AT lt_original_data ASSIGNING FIELD-SYMBOL(<fs_data>)."  GROUP BY (
*                matnr = <fs_data>-matnr
*                werks = <fs_data>-werks
*                size  = GROUP SIZE
*                index = GROUP INDEX )
*      ASCENDING
*      REFERENCE INTO DATA(route_group).
*
*      IF route_group->size GT 1.
*
*        LOOP AT GROUP route_group ASSIGNING FIELD-SYMBOL(<fs_group>).
*          lv_meinh_1 = COND #( WHEN <fs_group>-umrez EQ 1 THEN <fs_group>-meinh ELSE lv_meinh_1 ).
*          lv_meinh_2 = COND #( WHEN <fs_group>-umrez NE 1 THEN <fs_group>-meinh ELSE lv_meinh_2 ).
*        ENDLOOP.
*
*        IF   lv_meinh_1 IS NOT INITIAL
*         AND lv_meinh_2 IS NOT INITIAL.

*          LOOP AT GROUP route_group ASSIGNING FIELD-SYMBOL(<fs_gp>).

      CALL FUNCTION 'MD_CONVERT_MATERIAL_UNIT' "#EC CI_SEL_NESTED
        EXPORTING
          i_matnr              = <fs_data>-matnr
          i_in_me              = <fs_data>-meinh
          i_out_me             = gc_un
          i_menge              = CONV bstmg( <fs_data>-umren )
        IMPORTING
          e_menge              = lv_ntgew
        EXCEPTIONS
          error_in_application = 1
          error                = 2
          OTHERS               = 3.

      IF sy-subrc EQ 0.
        <fs_data>-zntgew =  lv_ntgew * <fs_data>-ntgew.
      ENDIF.

      CALL FUNCTION 'MD_CONVERT_MATERIAL_UNIT' "#EC CI_SEL_NESTED
        EXPORTING
          i_matnr              = <fs_data>-matnr
          i_in_me              = <fs_data>-meinh
          i_out_me             = gc_un
          i_menge              = CONV bstmg( <fs_data>-umren )
        IMPORTING
          e_menge              = lv_brgew
        EXCEPTIONS
          error_in_application = 1
          error                = 2
          OTHERS               = 3.

      IF sy-subrc EQ 0.
        <fs_data>-zbrgew = lv_brgew * <fs_data>-brgew_mara.
      ENDIF.

*          ENDLOOP.
*        ENDIF.

*      ELSE.
*
*        LOOP AT GROUP route_group ASSIGNING FIELD-SYMBOL(<fs_group2>).
*          <fs_group2>-zntgew = <fs_group2>-ntgew.
*          <fs_group2>-zbrgew = <fs_group2>-brgew.
*        ENDLOOP.
*
*      ENDIF.

      CLEAR: lv_ntgew, lv_brgew.

    ENDLOOP.

    ct_calculated_data = CORRESPONDING #( lt_original_data ).

  ENDMETHOD.

  METHOD if_sadl_exit_calc_element_read~get_calculation_info.

    INSERT CONV string( 'BRGEW' ) INTO TABLE et_requested_orig_elements.
    INSERT CONV string( 'BRGEW_MARA' ) INTO TABLE et_requested_orig_elements.
    INSERT CONV string( 'MATNR' ) INTO TABLE et_requested_orig_elements.
    INSERT CONV string( 'MEINH' ) INTO TABLE et_requested_orig_elements.
    INSERT CONV string( 'NTGEW' ) INTO TABLE et_requested_orig_elements.

  ENDMETHOD.

ENDCLASS.
