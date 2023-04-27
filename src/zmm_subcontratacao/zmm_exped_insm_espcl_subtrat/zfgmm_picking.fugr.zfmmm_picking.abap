FUNCTION zfmmm_picking.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(IS_VBKOK_WA) TYPE  ZSMM_EXPED_VBKOK OPTIONAL
*"     VALUE(IV_IF_ERROR) TYPE  XFELD DEFAULT 'X'
*"     VALUE(IT_VBPOK_TAB) TYPE  VBPOK_T OPTIONAL
*"     VALUE(IV_DOCNUM) TYPE  J_1BDOCNUM OPTIONAL
*"     VALUE(IV_ITMNUM) TYPE  J_1BITMNUM OPTIONAL
*"     VALUE(IV_APP_EXP) TYPE  XFELD OPTIONAL
*"     VALUE(IV_ESPECIAL) TYPE  XFELD OPTIONAL
*"  EXPORTING
*"     VALUE(ET_PROT) TYPE  TAB_PROTT
*"----------------------------------------------------------------------
  DATA: ls_vbkok TYPE vbkok.

  ls_vbkok-vbeln_vl = is_vbkok_wa-vbeln_vl.
  ls_vbkok-wabuc    = is_vbkok_wa-wabuc.

  gs_armaz_key-docnum = iv_docnum.
  gs_armaz_key-itmnum = IV_ITMNUM.
  gs_armaz_key-especial = iv_especial.

  gv_app_exp = iv_app_exp.

  CALL FUNCTION 'SD_DELIVERY_UPDATE_PICKING_1'
    EXPORTING
      vbkok_wa                 = ls_vbkok
      if_error_messages_send_1 = iv_if_error
    TABLES
      vbpok_tab                = it_vbpok_tab
      prot                     = et_prot.

  IF et_prot[] IS INITIAL.
    CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
      EXPORTING
        wait = abap_true.
  ENDIF.

ENDFUNCTION.
