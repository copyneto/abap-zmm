FUNCTION zfmm_nfwrite_contabil.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  EXPORTING
*"     REFERENCE(EV_OBJ_TYPE) TYPE  AWTYP
*"     REFERENCE(EV_OBJ_KEY) TYPE  AWKEY
*"     REFERENCE(EV_OBJ_SYS) TYPE  AWSYS
*"     REFERENCE(ET_RETURN) TYPE  BAPIRET2_TAB
*"  CHANGING
*"     REFERENCE(CS_ALIVIUM) TYPE  ZTMM_ALIVIUM
*"----------------------------------------------------------------------
  DATA: ls_header     TYPE bapiache09,
        lt_accountgl  TYPE TABLE OF bapiacgl09,
        lt_curr       TYPE TABLE OF bapiaccr09,
        lt_return     TYPE TABLE OF bapiret2,
        lt_extension2 TYPE TABLE OF bapiparex,
        ls_return     TYPE bapiret2,
        lv_ok         TYPE c,
        lv_docnum     TYPE j_1bdocnum.

  DATA: ls_doc TYPE j_1bnfdoc,
        lt_stx TYPE TABLE OF j_1bnfstx.

*    IF cs_alivium-docnum_entrada IS NOT INITIAL.
  IF cs_alivium-docnum_saida IS NOT INITIAL.
    lv_docnum = cs_alivium-docnum_saida.
  ELSE.
    lv_docnum = cs_alivium-docnum_entrada.
  ENDIF.

  PERFORM f_get_nf_data TABLES lt_stx
                         USING lv_docnum
                      CHANGING ls_doc.

  PERFORM f_fill_header USING ls_doc
                     CHANGING ls_header.


  PERFORM f_fill_item_data TABLES lt_stx
                                  lt_accountgl
                                  lt_curr
                                  lt_extension2
                            USING ls_doc.

  CLEAR: ls_return.

  PERFORM f_check_acc_doc_needed TABLES lt_stx
                                        lt_return
                               CHANGING lv_ok.

  "Se existirem impostos para serem contabilizados, cria doc. contabil.
  IF lv_ok = abap_true.

    CLEAR: lv_ok.

    CALL FUNCTION 'BAPI_ACC_DOCUMENT_CHECK'
      EXPORTING
        documentheader = ls_header
*       CUSTOMERCPD    =
*       CONTRACTHEADER =
      TABLES
        accountgl      = lt_accountgl
*       ACCOUNTRECEIVABLE       =
*       ACCOUNTPAYABLE =
*       ACCOUNTTAX     =
        currencyamount = lt_curr
*       CRITERIA       =
*       VALUEFIELD     =
*       EXTENSION1     =
        return         = lt_return
*       PAYMENTCARD    =
*       CONTRACTITEM   =
        extension2     = lt_extension2.
*     REALESTATE     =
*     ACCOUNTWT      =

    PERFORM f_check_ok USING lt_return CHANGING lv_ok.

    IF lv_ok = abap_true.
      REFRESH: lt_return.
      CALL FUNCTION 'BAPI_ACC_DOCUMENT_POST'
        EXPORTING
          documentheader = ls_header
*         CUSTOMERCPD    =
*         CONTRACTHEADER =
        IMPORTING
          obj_type       = ev_obj_type
          obj_key        = ev_obj_key
          obj_sys        = ev_obj_sys
        TABLES
          accountgl      = lt_accountgl
*         ACCOUNTRECEIVABLE       =
*         ACCOUNTPAYABLE =
*         ACCOUNTTAX     =
          currencyamount = lt_curr
*         CRITERIA       =
*         VALUEFIELD     =
*         EXTENSION1     =
          return         = lt_return
*         PAYMENTCARD    =
*         CONTRACTITEM   =
          extension2     = lt_extension2.
*       REALESTATE     =
*       ACCOUNTWT      =

      IF lv_ok = abap_true.

        CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'.

        SELECT SINGLE * FROM ztmm_alivium
          INTO cs_alivium
         WHERE iblnr = cs_alivium-iblnr
           AND gjahr = cs_alivium-gjahr
           AND ( docnum_entrada = ls_doc-docnum OR docnum_saida = ls_doc-docnum ).
        IF sy-subrc EQ 0.
          cs_alivium-belnr = ev_obj_key(10).
          cs_alivium-bukrs = ev_obj_key+10(4).
          MODIFY ztmm_alivium FROM cs_alivium.
          IF sy-subrc = 0.
            COMMIT WORK.
          ENDIF.
        ENDIF.
      ELSE.
        CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.
      ENDIF.
    ENDIF.

  ELSE.

    SELECT SINGLE * FROM ztmm_alivium
      INTO cs_alivium
     WHERE iblnr = cs_alivium-iblnr
       AND gjahr = cs_alivium-gjahr
       AND ( docnum_entrada = ls_doc-docnum OR docnum_saida = ls_doc-docnum ).
    IF sy-subrc EQ 0.
      cs_alivium-belnr = |N/A|.
      cs_alivium-bukrs = ls_header-comp_code.
      MODIFY ztmm_alivium FROM cs_alivium.
      IF sy-subrc = 0.
        COMMIT WORK.
      ENDIF.
    ENDIF.

  ENDIF.

  APPEND LINES OF lt_return TO et_return.

ENDFUNCTION.
