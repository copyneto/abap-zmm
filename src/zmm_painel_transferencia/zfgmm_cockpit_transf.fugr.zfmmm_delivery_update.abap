FUNCTION ZFMMM_DELIVERY_UPDATE .
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(IS_VBKOK_WA) LIKE  VBKOK STRUCTURE  VBKOK
*"     VALUE(IV_SYNCHRON) LIKE  RVSEL-XFELD DEFAULT ' '
*"     VALUE(IV_NO_MESSAGES_UPDATE) LIKE  RVSEL-XFELD DEFAULT SPACE
*"     VALUE(IV_COMMIT) LIKE  RVSEL-XFELD DEFAULT SPACE
*"     VALUE(IV_DELIVERY) LIKE  LIKP-VBELN
*"     VALUE(IV_UPDATE_PICKING) LIKE  RVSEL-XFELD DEFAULT SPACE
*"     VALUE(IV_NICHT_SPERREN) LIKE  RVSEL-NO_SP DEFAULT ' '
*"     VALUE(IV_CONFIRM_CENTRAL) LIKE  RVSEL-XFELD DEFAULT SPACE
*"     VALUE(IV_WMPP) LIKE  RVSEL-XFELD DEFAULT SPACE
*"     VALUE(IV_GET_DELIVERY_BUFFERED) TYPE  RVSEL-XFELD DEFAULT SPACE
*"     VALUE(IV_NO_GENERIC_SYSTEM_SERVICE) LIKE  RVSEL-XFELD DEFAULT
*"       SPACE
*"     VALUE(IV_DATABASE_UPDATE) TYPE  LESHP_DATABASE_UPDATE DEFAULT
*"       '1'
*"     VALUE(IV_NO_INIT) TYPE  XFELD DEFAULT SPACE
*"     VALUE(IV_NO_READ) TYPE  XFELD DEFAULT SPACE
*"     VALUE(IV_ERROR_MESSAGES_SEND_0) TYPE  XFELD DEFAULT 'X'
*"     VALUE(IV_NO_BUFFER_REFRESH) TYPE  V50AGL_NO_BUFFER_REFRESH
*"       DEFAULT SPACE
*"     VALUE(IT_PARTNER_UPDATE) TYPE  SHP_PARTNER_UPDATE_T OPTIONAL
*"     VALUE(IT_SERNR_UPDATE) TYPE  SHP_SERNR_UPDATE_T OPTIONAL
*"     VALUE(IV_NO_REMOTE_CHG) LIKE  RVSEL-XFELD DEFAULT ' '
*"     VALUE(IV_NO_MES_UPD_PACK) TYPE  V50AGL_NO_MES_UPD_PACK DEFAULT
*"       SPACE
*"     VALUE(IV_LATE_DELIVERY_UPD) TYPE  XFELD DEFAULT SPACE
*"     VALUE(IV_SIMULATE) TYPE  XFELD DEFAULT SPACE
*"     VALUE(IV_SHPMT_AUFRUFER) TYPE  T180-AKTYP OPTIONAL
*"  EXPORTING
*"     VALUE(EV_ERROR_ANY_0) TYPE  XFELD
*"     VALUE(EV_ERROR_IN_ITEM_DELETION_0) TYPE  XFELD
*"     VALUE(EV_ERROR_IN_POD_UPDATE_0) TYPE  XFELD
*"     VALUE(EV_ERROR_IN_INTERFACE_0) TYPE  XFELD
*"     VALUE(EV_ERROR_IN_GOODS_ISSUE_0) TYPE  XFELD
*"     VALUE(EV_ERROR_IN_FINAL_CHECK_0) TYPE  XFELD
*"     VALUE(EV_ERROR_PARTNER_UPDATE) TYPE  XFELD
*"     VALUE(EV_ERROR_SERNR_UPDATE) TYPE  XFELD
*"  TABLES
*"      IT_VBPOK_TAB STRUCTURE  VBPOK OPTIONAL
*"      IT_PROT STRUCTURE  PROTT OPTIONAL
*"      ET_RETURN STRUCTURE  BAPIRET2
*"----------------------------------------------------------------------
  CALL FUNCTION 'WS_DELIVERY_UPDATE'
    EXPORTING
      vbkok_wa                     = is_vbkok_wa
      synchron                     = iv_synchron
      no_messages_update           = iv_no_messages_update
      commit                       = iv_commit
      delivery                     = iv_delivery
      update_picking               = iv_update_picking
      nicht_sperren                = iv_nicht_sperren
      if_confirm_central           = iv_confirm_central
      if_wmpp                      = iv_wmpp
      if_get_delivery_buffered     = iv_get_delivery_buffered
      if_no_generic_system_service = iv_no_generic_system_service
      if_database_update           = iv_database_update
      if_no_init                   = iv_no_init
      if_no_read                   = iv_no_read
      if_error_messages_send_0     = iv_error_messages_send_0
      if_no_buffer_refresh         = iv_no_buffer_refresh
      it_partner_update            = it_partner_update
      it_sernr_update              = it_sernr_update
      if_no_remote_chg             = iv_no_remote_chg
      if_no_mes_upd_pack           = iv_no_mes_upd_pack
      if_late_delivery_upd         = iv_late_delivery_upd
      if_simulate                  = iv_simulate
    IMPORTING
      ef_error_any_0               = ev_error_any_0
      ef_error_in_item_deletion_0  = ev_error_in_item_deletion_0
      ef_error_in_pod_update_0     = ev_error_in_pod_update_0
      ef_error_in_interface_0      = ev_error_in_interface_0
      ef_error_in_goods_issue_0    = ev_error_in_goods_issue_0
      ef_error_in_final_check_0    = ev_error_in_final_check_0
      ef_error_partner_update      = ev_error_partner_update
      ef_error_sernr_update        = ev_error_sernr_update
    TABLES
      vbpok_tab                    = it_vbpok_tab
      prot                         = it_prot
    EXCEPTIONS
      error_message                = 99.
  IF sy-subrc NE 0.
    APPEND VALUE #( type       = sy-msgty
                    id         = sy-msgid
                    number     = sy-msgno
                    message_v1 = sy-msgv1
                    message_v2 = sy-msgv2
                    message_v3 = sy-msgv3
                    message_v4 = sy-msgv4 ) TO et_return.
  ENDIF.

ENDFUNCTION.
