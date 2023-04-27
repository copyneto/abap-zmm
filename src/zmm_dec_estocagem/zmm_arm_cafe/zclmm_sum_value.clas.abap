CLASS zclmm_sum_value DEFINITION
 PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_sadl_exit .
    INTERFACES if_sadl_exit_calc_element_read .

  PROTECTED SECTION.
  PRIVATE SECTION.

    TYPES: ty_val_tab TYPE STANDARD TABLE OF api_vali.

    CONSTANTS: BEGIN OF gc_value,
                 material           TYPE string VALUE 'MATERIAL' ##NO_TEXT,
                 plant              TYPE string VALUE 'PLANT' ##NO_TEXT,
                 batch              TYPE string VALUE 'BATCH' ##NO_TEXT,
                 qtd_total_sacas    TYPE string VALUE 'QTD_TOTAL_SACAS' ##NO_TEXT,
                 qtd_total_kg       TYPE string VALUE 'QTD_TOTAL_KG' ##NO_TEXT,
                 ygv_qtd_sacas      TYPE atnam VALUE 'YGV_QTD_SACAS' ##NO_TEXT,
                 ygv_qtd_kg         TYPE atnam VALUE 'YGV_QTD_KG' ##NO_TEXT,
                 batch_number       TYPE string VALUE 'YB_BATCH_NUMBER' ##NO_TEXT,
                 charg              TYPE string VALUE 'CHARG' ##NO_TEXT,
                 quantityinbaseunit TYPE string VALUE 'QUANTITYINBASEUNIT' ##NO_TEXT,
                 r                  TYPE c VALUE 'R',
               END OF gc_value.

    METHODS conv
      IMPORTING
                it_value        TYPE ty_val_tab
                iv_atnam        TYPE atnam
      RETURNING VALUE(rv_valor) TYPE dec16_3.
ENDCLASS.



CLASS zclmm_sum_value IMPLEMENTATION.


  METHOD if_sadl_exit_calc_element_read~calculate.

    DATA: lt_original_data TYPE STANDARD TABLE OF zi_mm_01_cafe WITH DEFAULT KEY,
          lt_val_tab       TYPE STANDARD TABLE OF api_vali.

    lt_original_data = CORRESPONDING #( it_original_data ).

    LOOP AT lt_original_data ASSIGNING FIELD-SYMBOL(<fs_data>).

*      IF <fs_data>-charg+8(1) EQ gc_value-r.

        CALL FUNCTION 'QC01_BATCH_VALUES_READ'
          EXPORTING
            i_val_matnr    = <fs_data>-material
            i_val_werks    = <fs_data>-plant
*            i_val_charge   = <fs_data>-charg
          TABLES
            t_val_tab      = lt_val_tab
          EXCEPTIONS
            no_class       = 1
            internal_error = 2
            no_values      = 3
            no_chars       = 4
            OTHERS         = 5.

        IF lt_val_tab IS NOT INITIAL.


          <fs_data>-qtd_total_sacas = conv( EXPORTING it_value = lt_val_tab iv_atnam = gc_value-ygv_qtd_sacas ).
          <fs_data>-qtd_total_kg    = conv( EXPORTING it_value = lt_val_tab iv_atnam = gc_value-ygv_qtd_kg  ).

          CLEAR: lt_val_tab[].

        ENDIF.

*      ENDIF.

      <fs_data>-qtd_dif_nf  = <fs_data>-quantityinbaseunit - <fs_data>-qtd_total_sacas.

      IF <fs_data>-qtd_dif_nf GT 0.
        <fs_data>-statuscriticality2 = 2.
      ELSEIF <fs_data>-qtd_dif_nf  EQ 0.
        <fs_data>-statuscriticality2 = 3.
      ELSE.
        <fs_data>-statuscriticality2 = 1.
      ENDIF.

    ENDLOOP.

    ct_calculated_data = CORRESPONDING #( lt_original_data ).

  ENDMETHOD.


  METHOD if_sadl_exit_calc_element_read~get_calculation_info.

    INSERT gc_value-charg              INTO TABLE et_requested_orig_elements.
    INSERT gc_value-material           INTO TABLE et_requested_orig_elements.
    INSERT gc_value-plant              INTO TABLE et_requested_orig_elements.
    INSERT gc_value-batch              INTO TABLE et_requested_orig_elements.
    INSERT gc_value-qtd_total_sacas    INTO TABLE et_requested_orig_elements.
    INSERT gc_value-quantityinbaseunit INTO TABLE et_requested_orig_elements.

  ENDMETHOD.

  METHOD conv.

    DATA: lv_decimal TYPE p DECIMALS 2,
          lv_int     TYPE i,
          lv_len     TYPE i.

    DATA(lv_value) = VALUE #( it_value[ atnam = iv_atnam ]-atwrt OPTIONAL ).

    IF lv_value IS NOT INITIAL.

      lv_len = strlen( lv_value ).

      CLEAR lv_int.

      WHILE lv_int < lv_len.

        IF NOT  lv_value+lv_int(1) CA '0123456789,'.

          MOVE space TO  lv_value+lv_int(1).

        ENDIF.

        ADD 1 TO lv_int.

      ENDWHILE.

      CONDENSE lv_value NO-GAPS.

    ENDIF.

    TRANSLATE lv_value USING ',.'.
    rv_valor = CONV #( lv_value ).

  ENDMETHOD.

ENDCLASS.
