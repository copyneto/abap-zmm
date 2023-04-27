FUNCTION ZFMMM_LANC_FAT_RECEB_GRC .
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(IV_NFEID) TYPE  /XNFE/ID
*"     VALUE(IV_DOCNUM) TYPE  CHAR10
*"  TABLES
*"      ET_RETURN STRUCTURE  BAPIRET2 OPTIONAL
*"----------------------------------------------------------------------
  DATA: ls_nfehd  TYPE /xnfe/innfehd,
        ls_action TYPE /xnfe/action_allowed_s.

  DATA: lt_nfeit    TYPE /xnfe/innfeit_t,
        ls_xml_nfe  TYPE /xnfe/inxml,
        lt_assign   TYPE /xnfe/nfeassign_t,
        ls_status   TYPE /xnfe/step_result_s,
        lt_messages TYPE TABLE OF balm.

  CALL FUNCTION '/XNFE/B2BNFE_READ_NFE_FOR_UPD'
    EXPORTING
      iv_nfe_id          = iv_nfeid
    IMPORTING
      es_nfehd           = ls_nfehd
      et_nfeit           = lt_nfeit
      es_xml_nfe         = ls_xml_nfe
      et_assign          = lt_assign
    EXCEPTIONS
      nfe_does_not_exist = 1
      nfe_locked         = 2
      technical_error    = 3
      OTHERS             = 4.

  IF sy-subrc <> 0.
    APPEND VALUE #( type       = sy-msgty
                    id         = sy-msgid
                    number     = sy-msgno
                    message_v1 = sy-msgv1
                    message_v2 = sy-msgv2
                    message_v3 = sy-msgv3
                    message_v4 = sy-msgv4 ) TO et_return.
    EXIT.
  ENDIF.

*  CALL FUNCTION '/XNFE/GET_NEXT_STEP'
*    EXPORTING
*      iv_guid                = ls_nfehd-guid_header
*      iv_doctype             = 'NFE'
*      iv_direction           = 'INBD'
*    IMPORTING
*      es_action              = ls_action
*    EXCEPTIONS
*      error_reading_document = 1
*      OTHERS                 = 2.
*  IF sy-subrc <> 0.
*    APPEND VALUE #( type       = sy-msgty
*                    id         = sy-msgid
*                    number     = sy-msgno
*                    message_v1 = sy-msgv1
*                    message_v2 = sy-msgv2
*                    message_v3 = sy-msgv3
*                    message_v4 = sy-msgv4 ) TO et_return.
*    EXIT.
*  ENDIF.
*
*  IF ls_action-procstep NE 'IVPOSTNG'.
*    SELECT SINGLE FROM /xnfe/procstept
*      FIELDS procstep,
*             description
*      WHERE procstep = @ls_action-procstep
*        AND langu    = @sy-langu
*      INTO @DATA(ls_procstept).
*    IF sy-subrc EQ 0.
*      APPEND VALUE #( type       = 'E'
*                      id         = 'ZSD_INTERCOMPANY'
*                      number     = '020'
*                      message_v1 = ls_procstept-procstep
*                      message_v2 = ls_procstept-description ) TO et_return.
*    ENDIF.
*    EXIT.
*  ENDIF.


  DATA(lv_log_handle) = VALUE balloghndl( ).

  DATA(ls_log) = VALUE bal_s_log( extnumber  = |{ CONV j_1bdocnum( iv_docnum ) ALPHA = IN }|
                                  alprog     = sy-cprog
                                  object     = 'NFE'
                                  subobject  = 'MONITOR'
                                  aldate     = sy-datum
                                  altime     = sy-uzeit
                                  aldate_del = sy-datum + 7 ).

  CALL FUNCTION 'BAL_LOG_CREATE'
    EXPORTING
      i_s_log      = ls_log
    IMPORTING
      e_log_handle = lv_log_handle
    EXCEPTIONS
      OTHERS       = 2.
  IF sy-subrc <> 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
            WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4
            INTO DATA(ls_message).
  ENDIF.

  CALL FUNCTION '/XNFE/PROCSTEP_NFE_IVPOSTNG'
    EXPORTING
      is_header     = ls_nfehd
      it_items      = lt_nfeit
      iv_xml        = ls_xml_nfe-xmlstring
      iv_log_handle = lv_log_handle
    IMPORTING
      es_status     = ls_status
    CHANGING
      ct_assign     = lt_assign.

  DATA(lt_log_handle) = VALUE bal_t_logh( ).
  APPEND lv_log_handle TO lt_log_handle.

  CALL FUNCTION 'BAL_DB_SAVE'
    EXPORTING
      i_t_log_handle   = lt_log_handle
    EXCEPTIONS
      log_not_found    = 1
      save_not_allowed = 2
      numbering_error  = 3
      OTHERS           = 4.

  IF sy-subrc EQ 0.
    CALL FUNCTION 'APPL_LOG_READ_DB'
      EXPORTING
        object          = ls_log-object
        subobject       = ls_log-subobject
        external_number = ls_log-extnumber
        date_from       = ls_log-aldate
        date_to         = sy-datum
        time_from       = ls_log-altime
        time_to         = sy-uzeit
      TABLES
        messages        = lt_messages.

    LOOP AT lt_messages ASSIGNING FIELD-SYMBOL(<fs_messages>).
      APPEND VALUE #( type       = <fs_messages>-msgty
                      id         = <fs_messages>-msgid
                      number     = <fs_messages>-msgno
                      message_v1 = <fs_messages>-msgv1
                      message_v2 = <fs_messages>-msgv2
                      message_v3 = <fs_messages>-msgv3
                      message_v4 = <fs_messages>-msgv4 ) TO et_return.
    ENDLOOP.
  ENDIF.

ENDFUNCTION.
