FUNCTION zfmmm_nfein_accptnfe.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(IS_DHRECBTO) TYPE  /XNFE/DHRECBTO_UTC
*"     VALUE(IS_NFEID) TYPE  /XNFE/ID
*"     VALUE(IS_NPROT) TYPE  /XNFE/NPROT
*"     VALUE(IS_XMLVERSION) TYPE  /XNFE/XML_VERSION_NFE
*"     VALUE(IS_GUID_HEADER) TYPE  /XNFE/GUID_16
*"----------------------------------------------------------------------
  DATA: ls_nfe_header_erp TYPE  j1b_nf_xml_header,
        lt_nfe_item_erp   TYPE  j1b_nf_xml_item_tab,
        lv_auth_date      TYPE  j_1bauthdate,
        lv_auth_time      TYPE  j_1bauthtime,
        lv_acckey         TYPE  j_1b_nfe_access_key,
        ls_step_result    TYPE /xnfe/step_result_s,
        lt_return         TYPE bapirettab.

  lv_auth_date = is_dhrecbto(8).
  lv_auth_time = is_dhrecbto+8(6).
  lv_acckey = is_nfeid.

  CALL FUNCTION 'J_1BNFE_EXIST_CHECK_AND_UPDATE'
    EXPORTING
      i_acckey     = lv_acckey
      i_authcode   = is_nprot
      i_auth_date  = lv_auth_date
      i_auth_time  = lv_auth_time
      i_xmlgovvers = is_xmlversion
    IMPORTING
      e_xml_header = ls_nfe_header_erp
      et_xml_item  = lt_nfe_item_erp
    TABLES
      et_bapiret2  = lt_return.

*  DATA(lv_uname) = sy-uname.
*
*  ls_step_result-stepstatus  = '01'.
*  ls_step_result-msgid  =  '/XNFE/APPB2BSTEPS'.
*  ls_step_result-msgno = '001'.
*  ls_step_result-msgv1 =  lv_uname.
*
*  CALL FUNCTION '/XNFE/B2BNFE_SET_STEPRESULT'
*    EXPORTING
*      iv_guid_header       = is_guid_header
*      iv_proc_step         = 'ACCPTNFE'
*      is_step_result       = ls_step_result
*    EXCEPTIONS
*      nfe_does_not_exist   = 1
*      nfe_locked           = 2
*      procstep_not_allowed = 3
*      no_proc_allowed      = 4
*      technical_error      = 5
*      OTHERS               = 6.
*
*  IF sy-subrc IS NOT INITIAL.
*    MESSAGE id sy-msgid TYPE sy-msgty NUMBER sy-msgno WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
*  ENDIF.

  CALL FUNCTION '/XNFE/B2BNFE_SAVE_TO_DB'.

  CALL FUNCTION '/XNFE/COMMIT_WORK'.

  WAIT UP TO 1 SECONDS.

  CALL FUNCTION '/XNFE/NFE_PROCFLOW_EXECUTION'
    EXPORTING
      iv_guid_header    = is_guid_header
    EXCEPTIONS
      no_proc_allowed   = 1
      error_in_process  = 2
      technical_error   = 3
      error_reading_nfe = 4
      no_logsys         = 5
      OTHERS            = 6.

  IF sy-subrc <> 0.
     MESSAGE id sy-msgid TYPE sy-msgty NUMBER sy-msgno WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.


ENDFUNCTION.
