FUNCTION zfmfi_posting_interface.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(IV_FUNCTION) TYPE  RFIPI-FUNCT
*"     VALUE(IV_AUGLV) TYPE  T041A-AUGLV
*"     VALUE(IV_TCODE) TYPE  SY-TCODE
*"     VALUE(IV_SGFUNCT) TYPE  RFIPI-SGFUNCT DEFAULT SPACE
*"     VALUE(IV_NO_AUTH) TYPE  CHAR1 DEFAULT SPACE
*"     VALUE(IV_XSIMU) TYPE  CHAR1 DEFAULT SPACE
*"     VALUE(IT_BLNTAB) TYPE  RE_T_EX_BLNTAB
*"     VALUE(IT_FTCLEAR) TYPE  FEB_T_FTCLEAR
*"     VALUE(IT_FTPOST) TYPE  FEB_T_FTPOST
*"     VALUE(IT_FTTAX) TYPE  FEB_T_FTTAX
*"     VALUE(IV_XREF1) TYPE  XREF1_HD
*"     VALUE(IV_XREF2) TYPE  XREF2_HD
*"  EXPORTING
*"     VALUE(EV_SUBRC) TYPE  SY-SUBRC
*"     VALUE(ES_RETURN) TYPE  BAPIRET2
*"----------------------------------------------------------------------
  DATA: lv_subrc TYPE syst_subrc.

  FREE MEMORY ID 'ZTCOMP'.
  DATA: lv_check TYPE abap_bool VALUE abap_true.
  EXPORT lv_check FROM lv_check TO MEMORY ID 'ZTCOMP'.

  CALL FUNCTION 'POSTING_INTERFACE_START'
    EXPORTING
      i_function         = iv_function
      i_mode             = 'N'
      i_user             = sy-uname
    EXCEPTIONS
      client_incorrect   = 1
      function_invalid   = 2
      group_name_missing = 3
      mode_invalid       = 4
      update_invalid     = 5
      user_invalid       = 6
      OTHERS             = 7.

  IF sy-subrc <> 0.

    es_return-id         = sy-msgid.
    es_return-number     = sy-msgno.
    es_return-type       = sy-msgty.
    es_return-message_v1 = sy-msgv1.
    es_return-message_v2 = sy-msgv2.
    es_return-message_v3 = sy-msgv3.
    es_return-message_v4 = sy-msgv4.

  ELSE.
    CALL FUNCTION 'POSTING_INTERFACE_CLEARING'
      EXPORTING
        i_auglv                    = iv_auglv
        i_tcode                    = iv_tcode
        i_sgfunct                  = iv_sgfunct
        i_no_auth                  = iv_no_auth
        i_xsimu                    = iv_xsimu
      IMPORTING
        e_msgid                    = es_return-id
        e_msgno                    = es_return-number
        e_msgty                    = es_return-type
        e_msgv1                    = es_return-message_v1
        e_msgv2                    = es_return-message_v2
        e_msgv3                    = es_return-message_v3
        e_msgv4                    = es_return-message_v4
        e_subrc                    = lv_subrc
      TABLES
        t_blntab                   = it_blntab
        t_ftclear                  = it_ftclear
        t_ftpost                   = it_ftpost
        t_fttax                    = it_fttax
      EXCEPTIONS
        clearing_procedure_invalid = 1
        clearing_procedure_missing = 2
        table_t041a_empty          = 3
        transaction_code_invalid   = 4
        amount_format_error        = 5
        too_many_line_items        = 6
        company_code_invalid       = 7
        screen_not_found           = 8
        no_authorization           = 9
        OTHERS                     = 10.

    IF lv_subrc IS INITIAL.

      DATA: lt_accchg TYPE fdm_t_accchg.
      lt_accchg = VALUE #( ( fdname = 'XREF1_HD' oldval = space newval = iv_xref1 ) ).
      lt_accchg = VALUE #( ( fdname = 'XREF2_HD' oldval = space newval = iv_xref2 ) ).

      CALL FUNCTION 'FI_DOCUMENT_CHANGE'
        EXPORTING
          i_obzei              = '000'
          x_lock               = abap_true
          i_bukrs              = it_blntab[ 1 ]-bukrs
          i_belnr              = it_blntab[ 1 ]-belnr
          i_gjahr              = it_blntab[ 1 ]-gjahr
          i_upd_fqm            = abap_true
        TABLES
          t_accchg             = lt_accchg
        EXCEPTIONS
          no_reference         = 1
          no_document          = 2
          many_documents       = 3
          wrong_input          = 4
          overwrite_creditcard = 5
          OTHERS               = 6.

      IF sy-subrc IS INITIAL.
        CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
          EXPORTING
            wait = abap_true.

        es_return-id         = 'ZMM_LIB_PGTO_GV'.
        es_return-number     = '008'.
        es_return-type       = 'S'.
        es_return-message_v1 = it_blntab[ 1 ]-belnr.
        es_return-message_v2 = it_blntab[ 1 ]-bukrs.
        es_return-message_v3 = it_blntab[ 1 ]-gjahr.

      ELSE.
        es_return-id         = sy-msgid.
        es_return-number     = sy-msgno.
        es_return-type       = sy-msgty.
        es_return-message_v1 = sy-msgv1.
        es_return-message_v2 = sy-msgv2.
        es_return-message_v3 = sy-msgv3.
        es_return-message_v4 = sy-msgv4.
      ENDIF.

    ELSE.
      es_return-type = 'E'.
    ENDIF.

  ENDIF.

ENDFUNCTION.
