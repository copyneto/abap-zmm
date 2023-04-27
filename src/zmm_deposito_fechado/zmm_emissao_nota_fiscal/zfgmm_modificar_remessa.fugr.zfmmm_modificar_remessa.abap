FUNCTION zfmmm_modificar_remessa.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(IV_DELIVERY) TYPE  LIKP-VBELN
*"     VALUE(IS_VBKOK_WA) TYPE  VBKOK
*"     VALUE(IT_PARTNER_UPDATE) TYPE  SHP_PARTNER_UPDATE_T
*"  EXPORTING
*"     VALUE(ET_MENSAGENS) TYPE  BAPIRET2_T
*"----------------------------------------------------------------------

  DATA:
    lv_error_any_0              TYPE xfeld,
    lv_error_in_item_deletion_0 TYPE xfeld,
    lv_error_in_pod_update_0    TYPE xfeld,
    lv_error_in_interface_0     TYPE xfeld,
    lv_error_in_goods_issue_0   TYPE xfeld,
    lv_error_in_final_check_0   TYPE xfeld,
    lv_error_partner_update     TYPE xfeld,
    lv_error_sernr_update       TYPE xfeld.

  CONSTANTS:
    gc_emissao              TYPE string VALUE 'EMISSAO'.

  CALL FUNCTION 'WS_DELIVERY_UPDATE'
    EXPORTING
      delivery                    = iv_delivery
      vbkok_wa                    = is_vbkok_wa
      it_partner_update           = it_partner_update
      synchron                    = abap_true
      commit                      = abap_true
      if_error_messages_send_0    = abap_true
*     update_picking              = abap_true
    IMPORTING
      ef_error_any_0              = lv_error_any_0
      ef_error_in_item_deletion_0 = lv_error_in_item_deletion_0
      ef_error_in_pod_update_0    = lv_error_in_pod_update_0
      ef_error_in_interface_0     = lv_error_in_interface_0
      ef_error_in_goods_issue_0   = lv_error_in_goods_issue_0
      ef_error_in_final_check_0   = lv_error_in_final_check_0
      ef_error_partner_update     = lv_error_partner_update
      ef_error_sernr_update       = lv_error_sernr_update
    EXCEPTIONS
      error_message               = 4.
  IF sy-subrc <> 0 AND ( sy-msgty = 'E' ).
    et_mensagens = VALUE #( BASE et_mensagens (
      parameter  = gc_emissao
      type       = sy-msgty
      id         = sy-msgid
      number     = sy-msgno
      message_v1 = sy-msgv1
      message_v2 = sy-msgv2
      message_v3 = sy-msgv3
      message_v4 = sy-msgv4
    ) ).
  ENDIF.

ENDFUNCTION.
