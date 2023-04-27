CLASS zclmm_url_bens_consumo DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    METHODS setup_messages
      IMPORTING
        !p_task TYPE clike.

    INTERFACES if_sadl_exit .
    INTERFACES if_sadl_exit_calc_element_read .
  PROTECTED SECTION.
  PRIVATE SECTION.

    TYPES: ty_mm_mov_cntrl TYPE STANDARD TABLE OF zc_mm_mov_cntrl WITH DEFAULT KEY.

    DATA: gv_wait_async TYPE abap_bool,
          gs_head       TYPE bapi2017_gm_head_ret.

    METHODS cancel_doc_mat
      CHANGING ct_calculated_data TYPE ty_mm_mov_cntrl.

    CONSTANTS: BEGIN OF gc_value,
                 matnr        TYPE string VALUE 'MATNR' ##NO_TEXT,
                 mjhar        TYPE string VALUE 'MJAHR' ##NO_TEXT,
                 MblnrSai     TYPE string VALUE 'MBLNRSAI' ##NO_TEXT,
                 DocnumEstSai TYPE string VALUE 'DOCNUMESTSAI' ##NO_TEXT,
               END OF gc_value.

ENDCLASS.



CLASS ZCLMM_URL_BENS_CONSUMO IMPLEMENTATION.


  METHOD if_sadl_exit_calc_element_read~calculate.

    DATA: lt_key TYPE zctgmm_subc_saveatrib.

    CONSTANTS: lc_param_doc      TYPE ihttpnam VALUE 'DOCNUM-LOW', "NO_TEXT"
               lc_param_dat      TYPE ihttpnam VALUE 'DATE0-LOW',
               lc_param_buk      TYPE ihttpnam VALUE 'BUKRS-LOW',
               lc_object_vbln2   TYPE char30   VALUE 'OutboundDelivery',
               lc_action_vbln2   TYPE char60   VALUE 'zzreverseInWebGUI',
               lc_param_vbln2    TYPE ihttpnam VALUE 'NumeroRemessa',
               lc_object         TYPE char30   VALUE 'NotaFiscal',
               lc_action         TYPE char60   VALUE 'monitor',
               lc_param_docnum   TYPE ihttpnam VALUE 'DOCNUM-LOW', "BR_NotaFiscal',
               lc_object_docnum  TYPE char30   VALUE 'NotaFiscal',
               lc_action_docnum  TYPE char60   VALUE 'monitor', " display',
               lc_param_vbeln    TYPE ihttpnam VALUE 'OutboundDelivery',
               lc_object_vbeln   TYPE char30   VALUE 'OutboundDelivery',
               lc_action_vbeln   TYPE char60   VALUE 'changeInWebGUI',
               lc_param_belnr    TYPE ihttpnam VALUE  'AccountingDocument',
               lc_object_belnr   TYPE char30   VALUE 'AccountingDocument',
               lc_action_belnr   TYPE char60   VALUE 'displayDocument',
               lc_param_mblnr    TYPE ihttpnam  VALUE 'MaterialDocument', "'PurchaseOrder',
               lc_param_mjahr    TYPE ihttpnam  VALUE 'MaterialDocumentYear', "'PurchaseOrder',
               lc_object_mblnr   TYPE char30   VALUE 'MaterialMovement', "Material', ##NO_TEXT
               lc_action_mblnr   TYPE char60   VALUE 'displayFactSheet', "postGoodsMovementInWebGUI'.
               lc_ob_est_contb   TYPE char30   VALUE 'AccountingDocument',
               lc_ac_est_contab  TYPE char60   VALUE 'reverseDocument',
               lc_prm_est_cont_1 TYPE ihttpnam VALUE 'FiscalYear',
               lc_prm_est_cont_2 TYPE ihttpnam VALUE 'AccountingDocument',
               lc_prm_est_cont_3 TYPE ihttpnam VALUE 'CompanyCode',
*               lc_object_mov     TYPE char30   VALUE 'Material',
               lc_action_mov     TYPE char60   VALUE 'postGoodsMovementInWebGUI',
               lc_param_mov1     TYPE ihttpnam  VALUE 'PurchaseOrder',
               lc_param_mov2     TYPE ihttpnam  VALUE 'PurchaseOrderItem'.

    CHECK NOT it_original_data IS INITIAL.

    DATA lt_calculated_data TYPE ty_mm_mov_cntrl.

    MOVE-CORRESPONDING it_original_data TO lt_calculated_data.

    IF lt_calculated_data[] IS NOT INITIAL.
      SELECT id,
             belnr,
             bukrs_dc,
             gjahr_dc
        FROM ztmm_mov_cntrl
         FOR ALL ENTRIES IN @lt_calculated_data
       WHERE id = @lt_calculated_data-id
        INTO TABLE @DATA(lt_mov_ctrl).
      IF sy-subrc IS INITIAL.
        SORT lt_mov_ctrl BY id.
      ENDIF.
    ENDIF.

    DATA(lt_parameters) = VALUE tihttpnvp( ).

    me->cancel_doc_mat( CHANGING ct_calculated_data = lt_calculated_data ).

    LOOP AT lt_calculated_data ASSIGNING FIELD-SYMBOL(<fs_calculated>).

      FREE: lt_parameters[].

      IF <fs_calculated>-etapa = 1.

        FREE: lt_parameters[].
        APPEND VALUE #( name = lc_param_mblnr
                        value = <fs_calculated>-mblnrsai ) TO lt_parameters.

        APPEND VALUE #( name = lc_param_mjahr
                        value = <fs_calculated>-mjahr ) TO lt_parameters.

        <fs_calculated>-url_est = cl_lsapi_manager=>create_flp_url( object     = lc_object_mblnr
                                                                    action     = lc_action_mblnr
                                                                    parameters = lt_parameters   ).

      ELSEIF <fs_calculated>-etapa = 3
          OR <fs_calculated>-etapa = 2.

        FREE: lt_parameters[].
        APPEND VALUE #( name = lc_param_doc
                        value = <fs_calculated>-docnums ) TO lt_parameters.

        APPEND VALUE #( name = lc_param_dat
                        value = space ) TO lt_parameters.

        APPEND VALUE #( name = lc_param_buk
                        value = <fs_calculated>-bukrs ) TO lt_parameters.

        <fs_calculated>-url_est = cl_lsapi_manager=>create_flp_url( object     = lc_object
                                                                    action     = lc_action
                                                                    parameters = lt_parameters ).
      ELSEIF <fs_calculated>-etapa = 4.

        READ TABLE lt_mov_ctrl ASSIGNING FIELD-SYMBOL(<fs_mov_ctrl>)
                                             WITH KEY id = <fs_calculated>-id
                                             BINARY SEARCH.
        IF sy-subrc IS INITIAL.
          FREE: lt_parameters[].
          APPEND VALUE #( name = lc_prm_est_cont_1
                          value = <fs_mov_ctrl>-gjahr_dc ) TO lt_parameters.

          APPEND VALUE #( name = lc_prm_est_cont_2
                          value = <fs_calculated>-belnr ) TO lt_parameters.

          APPEND VALUE #( name = lc_prm_est_cont_3
                          value = <fs_mov_ctrl>-bukrs_dc ) TO lt_parameters.

          <fs_calculated>-url_est = cl_lsapi_manager=>create_flp_url( object     = lc_ob_est_contb
                                                                      action     = lc_ac_est_contab
                                                                      parameters = lt_parameters ).
        ENDIF.

      ELSEIF <fs_calculated>-etapa = 5.

        FREE: lt_parameters[].
        APPEND VALUE #( name = lc_param_docnum
                        value = <fs_calculated>-docnument ) TO lt_parameters.

        APPEND VALUE #( name = lc_param_buk
                        value = <fs_calculated>-bukrs ) TO lt_parameters.

        APPEND VALUE #( name = lc_param_dat
                        value = space ) TO lt_parameters.

        <fs_calculated>-url_est = cl_lsapi_manager=>create_flp_url( object     = lc_object_docnum
                                                                    action     = lc_action_docnum
                                                                    parameters = lt_parameters ).

      ELSEIF <fs_calculated>-etapa = 6.

        FREE: lt_parameters[].
        APPEND VALUE #( name = lc_param_mblnr
                        value = <fs_calculated>-mblnrent ) TO lt_parameters.

        APPEND VALUE #( name = lc_param_mjahr
                        value = <fs_calculated>-mjahrent ) TO lt_parameters.

        <fs_calculated>-url_est = cl_lsapi_manager=>create_flp_url( object     = lc_object_mblnr
                                                                    action     = lc_action_mblnr
                                                                    parameters = lt_parameters ).
*        FREE: lt_parameters[].
*        APPEND VALUE #( name = lc_param_doc
*                        value = <fs_calculated>-docnument ) TO lt_parameters.
*
*        APPEND VALUE #( name = lc_param_dat
*                        value = space ) TO lt_parameters.
*
*        APPEND VALUE #( name = lc_param_buk
*                        value = <fs_calculated>-bukrs ) TO lt_parameters.
*
*        <fs_calculated>-url_est = cl_lsapi_manager=>create_flp_url( object     = lc_object
*                                                                    action     = lc_action
*                                                                    parameters = lt_parameters ).

      ENDIF.

      IF <fs_calculated>-docnums IS NOT INITIAL.

        FREE: lt_parameters[].
        APPEND VALUE #( name = lc_param_docnum
                        value = <fs_calculated>-docnums ) TO lt_parameters.

        APPEND VALUE #( name = lc_param_buk
                        value = <fs_calculated>-bukrs ) TO lt_parameters.

        APPEND VALUE #( name = lc_param_dat
                        value = space ) TO lt_parameters.

        <fs_calculated>-url_docnums = cl_lsapi_manager=>create_flp_url( object     = lc_object_docnum
                                                                        action     = lc_action_docnum
                                                                        parameters = lt_parameters ).
      ENDIF.

      IF <fs_calculated>-docnument IS NOT INITIAL.

        FREE: lt_parameters[].
        APPEND VALUE #( name = lc_param_docnum
                        value = <fs_calculated>-docnument ) TO lt_parameters.

        APPEND VALUE #( name = lc_param_buk
                        value = <fs_calculated>-bukrs ) TO lt_parameters.

        APPEND VALUE #( name = lc_param_dat
                        value = space ) TO lt_parameters.

        <fs_calculated>-url_docnument = cl_lsapi_manager=>create_flp_url( object     = lc_object_docnum
                                                                       action     = lc_action_docnum
                                                                       parameters = lt_parameters ).
      ENDIF.

      IF <fs_calculated>-belnr IS NOT INITIAL.

        FREE: lt_parameters[].
        APPEND VALUE #( name = lc_param_belnr
                        value = <fs_calculated>-belnr ) TO lt_parameters.

        <fs_calculated>-url_belnr = cl_lsapi_manager=>create_flp_url( object     = lc_object_belnr
                                                                       action     = lc_action_belnr
                                                                       parameters = lt_parameters ).
      ENDIF.

      IF <fs_calculated>-mblnrsai IS NOT INITIAL.

        FREE: lt_parameters[].
        APPEND VALUE #( name = lc_param_mblnr
                        value = <fs_calculated>-mblnrsai ) TO lt_parameters.

        APPEND VALUE #( name = lc_param_mjahr
                        value = <fs_calculated>-mjahr ) TO lt_parameters.

        <fs_calculated>-url_mblnrsai = cl_lsapi_manager=>create_flp_url( object     = lc_object_mblnr
                                                                           action     = lc_action_mblnr
                                                                           parameters = lt_parameters ).
      ENDIF.

      IF <fs_calculated>-mblnrent IS NOT INITIAL.

        FREE: lt_parameters[].
        APPEND VALUE #( name = lc_param_mblnr
                        value = <fs_calculated>-mblnrent ) TO lt_parameters.

        APPEND VALUE #( name = lc_param_mjahr
                        value = <fs_calculated>-mjahrent ) TO lt_parameters.

        <fs_calculated>-url_mblnrent = cl_lsapi_manager=>create_flp_url( object     = lc_object_mblnr
                                                                           action     = lc_action_mblnr
                                                                           parameters = lt_parameters ).
      ENDIF.

    ENDLOOP.

    MOVE-CORRESPONDING lt_calculated_data TO ct_calculated_data.

  ENDMETHOD.


  METHOD if_sadl_exit_calc_element_read~get_calculation_info.
    IF et_requested_orig_elements IS INITIAL.
*    APPEND 'REQNUMBER' TO et_requested_orig_elements.
    ENDIF.

    INSERT gc_value-matnr        INTO TABLE et_requested_orig_elements.
    INSERT gc_value-docnumestsai INTO TABLE et_requested_orig_elements.
    INSERT gc_value-mblnrsai     INTO TABLE et_requested_orig_elements.
    INSERT gc_value-mjhar        INTO TABLE et_requested_orig_elements.

  ENDMETHOD.


  METHOD setup_messages.

    CASE p_task.

      WHEN  'MM_CANCEL_MAT'.
        RECEIVE RESULTS FROM FUNCTION 'ZFMMM_CANCEL_MAT'
         IMPORTING
           es_head = gs_head.

    ENDCASE.

    gv_wait_async = abap_true.

  ENDMETHOD.


  METHOD cancel_doc_mat.

    IF ct_calculated_data IS NOT INITIAL.

      SELECT *
        FROM ztmm_mov_cntrl
         FOR ALL ENTRIES IN @ct_calculated_data
       WHERE id = @ct_calculated_data-id
        INTO TABLE @DATA(lt_mov_contrl).
      IF sy-subrc IS INITIAL.
        SORT lt_mov_contrl BY id.
      ENDIF.

      SELECT docnum, cancel FROM j_1bnfdoc
      FOR ALL ENTRIES IN @ct_calculated_data
         WHERE docnum = @ct_calculated_data-docnums
           AND cancel = @abap_true
      INTO TABLE @DATA(lt_nf_estornada).

      IF sy-subrc EQ 0.

        LOOP AT ct_calculated_data ASSIGNING FIELD-SYMBOL(<fs_data>).

          DATA(ls_data) = VALUE #( lt_nf_estornada[ docnum = <fs_data>-docnums ] OPTIONAL ).

          IF ls_data IS NOT INITIAL.

            IF <fs_data>-mblnrest IS INITIAL.

              CALL FUNCTION 'ZFMMM_CANCEL_MAT'
                STARTING NEW TASK 'MM_CANCEL_MAT'
                CALLING setup_messages ON END OF TASK
                EXPORTING
                  iv_mblnr = <fs_data>-mblnrsai
                  iv_mjahr = <fs_data>-mjahr.

              WAIT UNTIL gv_wait_async = abap_true.

              IF gs_head IS NOT INITIAL.

                READ TABLE lt_mov_contrl ASSIGNING FIELD-SYMBOL(<fs_mov_contrl>)
                                                       WITH KEY id = <fs_data>-id
                                                       BINARY SEARCH.
                IF sy-subrc IS INITIAL.
                  <fs_mov_contrl>-mblnr_est = gs_head-mat_doc.
                  <fs_mov_contrl>-mjahr_est = gs_head-doc_year.
                ENDIF.

*                <fs_data>-mblnrest = gs_head-mat_doc.
*                <fs_data>-mjahrest = gs_head-doc_year.
*
*                UPDATE ztmm_mov_cntrl
*                    SET mblnr_est = @gs_head-mat_doc,
*                        mjahr_est = @gs_head-doc_year
*                    WHERE id = @<fs_data>-id.

              ENDIF.

              CLEAR: gv_wait_async, gs_head, ls_data.

            ENDIF.
          ENDIF.
        ENDLOOP.

        IF lt_mov_contrl[] IS NOT INITIAL.
          UPDATE ztmm_mov_cntrl FROM TABLE lt_mov_contrl.
        ENDIF.

      ENDIF.
    ENDIF.

  ENDMETHOD.
ENDCLASS.
