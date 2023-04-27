FUNCTION zfmmm_criar_ordem_frete.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  EXPORTING
*"     VALUE(EV_ORDEM_FRETE) TYPE  /SCMTMS/TOR_ID
*"     VALUE(ET_RETURN) TYPE  BAL_T_MSGR
*"  TABLES
*"      T_VBELN STRUCTURE  ZMMS_VBELN
*"----------------------------------------------------------------------

  DATA lt_remessa TYPE zcltm_process_of=>ty_tipos_remessas.
  CLEAR lt_remessa.

  LOOP AT t_vbeln ASSIGNING FIELD-SYMBOL(<fs_remessa>).
    APPEND VALUE #(
      sign = 'I'
      option = 'EQ'
      low = <fs_remessa>-vbeln
    ) TO lt_remessa.
  ENDLOOP.

  DATA(lv_delivery) = t_vbeln[ 1 ]-vbeln.
  SELECT driver, carrier, equipment, equipment_tow1, equipment_tow2, equipment_tow3 UP TO 1 ROWS
  FROM ztmm_his_dep_fec
  INTO @DATA(ls_dados_transporte)
  WHERE out_delivery_document = @lv_delivery.
  ENDSELECT.

  DATA(lo_gerar_of) = NEW zcltm_process_of( ).
  lo_gerar_of->process_documents(
      ir_remessas = lt_remessa
      ir_driver   = ls_dados_transporte-driver
      ir_tsp      = ls_dados_transporte-carrier
      ir_plctrk   = CONV #( ls_dados_transporte-equipment )
      ir_plctr1   = CONV #( ls_dados_transporte-equipment_tow1 )
      ir_plctr2   = CONV #( ls_dados_transporte-equipment_tow2 )
      ir_plctr3   = CONV #( ls_dados_transporte-equipment_tow3 )
      iv_event    = 'FATURAR/CARREGAR'
  ).

*  CALL METHOD lo_gerar_of->execute
*    EXPORTING
*      ir_remessas = lt_remessa. "VALUE #( ( sign = 'I' option = 'EQ' low = iv_remessa ) ).


  ev_ordem_frete = lo_gerar_of->get_freightorder( ).

  et_return = lo_gerar_of->read_log( ).                 "#EC CI_CONV_OK


ENDFUNCTION.
