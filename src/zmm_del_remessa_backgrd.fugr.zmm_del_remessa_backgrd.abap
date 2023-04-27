FUNCTION zmm_del_remessa_backgrd.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(IV_VBELN) TYPE  VBELN_VL
*"----------------------------------------------------------------------
*Eliminar Remessa de Subcontratação após estorno do movimento
  DATA: lv_header_data    TYPE  bapiobdlvhdrchg,
        lv_header_control TYPE  bapiobdlvhdrctrlchg,
        lt_return         TYPE TABLE OF  bapiret2.

  lv_header_data-deliv_numb = iv_vbeln.

  lv_header_control-deliv_numb = iv_vbeln.
  lv_header_control-dlv_del = abap_true.
*  lv_header_control-dlv_del = 'X'.

  CALL FUNCTION 'BAPI_OUTB_DELIVERY_CHANGE'
    EXPORTING
      header_data    = lv_header_data
      header_control = lv_header_control
      delivery       = iv_vbeln
    TABLES
      return         = lt_return.

  IF NOT line_exists( lt_return[ type = 'E' ] ).
* Deletar tabela de histórico do Cokpit Subcontratação - Expedição Insumos
    DELETE FROM ztmm_sbct_pickin WHERE vbeln = iv_vbeln.

    CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'.
  ENDIF.

ENDFUNCTION.
