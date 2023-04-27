CLASS zclmm_estorno_mat DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_sadl_exit .
    INTERFACES if_sadl_exit_calc_element_read .

    METHODS setup_messages
      IMPORTING
        !p_task TYPE clike.

  PROTECTED SECTION.
  PRIVATE SECTION.

    CONSTANTS: BEGIN OF gc_value,
                 matnr        TYPE string VALUE 'MATNR' ##NO_TEXT,
                 mjhar        TYPE string VALUE 'MJAHR' ##NO_TEXT,
                 MblnrSai     TYPE string VALUE 'MBLNRSAI' ##NO_TEXT,
                 DocnumEstSai TYPE string VALUE 'DOCNUMESTSAI' ##NO_TEXT,
               END OF gc_value.

    DATA: gv_wait_async TYPE abap_bool.

ENDCLASS.



CLASS zclmm_estorno_mat IMPLEMENTATION.


  METHOD if_sadl_exit_calc_element_read~calculate.

    DATA: lt_original_data TYPE STANDARD TABLE OF zi_mm_mov_cntrl WITH DEFAULT KEY.

    lt_original_data = CORRESPONDING #( it_original_data ).

    IF lt_original_data IS NOT INITIAL.

      SELECT docnum, cancel FROM j_1bnfdoc
      FOR ALL ENTRIES IN @lt_original_data
         WHERE docnum = @lt_original_data-DocnumEstSai
      INTO TABLE @DATA(lt_nf_estornada).

      IF sy-subrc EQ 0.

        SELECT * FROM mseg
         FOR ALL ENTRIES IN @lt_original_data
         WHERE mblnr = @lt_original_data-MblnrSai
           AND mjahr = @lt_original_data-Mjahr
           AND smbln IS INITIAL
         INTO TABLE @DATA(lt_doc_mat_estor).

        LOOP AT lt_original_data ASSIGNING FIELD-SYMBOL(<fs_data>).

          DATA(ls_data) = VALUE #( lt_nf_estornada[ docnum = <fs_data>-DocnumEstSai ] ).

          IF sy-subrc EQ 0.

            IF line_exists( lt_doc_mat_estor[ mblnr = <fs_data>-MblnrSai
                                              mjahr = <fs_data>-Mjahr
                                              smbln = space ] ).

              CALL FUNCTION 'ZFMMM_CANCEL_MAT'
                STARTING NEW TASK 'MM_CANCEL_MAT'
                CALLING setup_messages ON END OF TASK
                EXPORTING
                  iv_matnr = <fs_data>-Matnr
                  iv_mjahr = <fs_data>-Mjahr.

              WAIT UNTIL gv_wait_async = abap_true.


            ENDIF.
          ENDIF.
        ENDLOOP.

        ct_calculated_data = CORRESPONDING #( lt_original_data ).

      ENDIF.
    ENDIF.

  ENDMETHOD.


  METHOD if_sadl_exit_calc_element_read~get_calculation_info.

    INSERT gc_value-matnr        INTO TABLE et_requested_orig_elements.
    INSERT gc_value-docnumestsai INTO TABLE et_requested_orig_elements.
    INSERT gc_value-mblnrsai     INTO TABLE et_requested_orig_elements.
    INSERT gc_value-mjhar        INTO TABLE et_requested_orig_elements.

  ENDMETHOD.

  METHOD setup_messages.

    CALL FUNCTION 'MM_CANCEL_MAT'.
    RECEIVE RESULTS FROM FUNCTION 'ZFMMM_CANCEL_MAT'.
*     IMPORTING
*       et_xvbfs = gt_xvbfs
*       et_lips  = gt_xxlips.

    gv_wait_async = abap_true.

  ENDMETHOD.

ENDCLASS.
