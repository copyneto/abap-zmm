FUNCTION zfmmm_outb_deliv_create.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(IV_SHIP_POINT) TYPE  BAPIDLVCREATEHEADER-SHIP_POINT
*"       OPTIONAL
*"     VALUE(IV_DUE_DATE) TYPE  BAPIDLVCREATEHEADER-DUE_DATE OPTIONAL
*"     VALUE(IV_DEBUG_FLG) TYPE  BAPIDLVCONTROL-DEBUG_FLG OPTIONAL
*"     VALUE(IV_NO_DEQUEUE) TYPE  BAPIFLAG-BAPIFLAG DEFAULT ' '
*"     VALUE(IV_GUID) TYPE  SYSUUID_X16 OPTIONAL
*"     VALUE(IV_INPUT) TYPE  ZSSD_ORDEM_INTERCOMPANY
*"  EXPORTING
*"     VALUE(EV_DELIVERY) TYPE  BAPISHPDELIVNUMB-DELIV_NUMB
*"     VALUE(EV_NUM_DELIVERIES) TYPE
*"        BAPIDLVCREATEHEADER-NUM_DELIVERIES
*"  TABLES
*"      IT_STOCK_TRANS_ITEMS STRUCTURE  BAPIDLVREFTOSTO
*"      IT_SERIAL_NUMBERS STRUCTURE  BAPIDLVSERIALNUMBER OPTIONAL
*"      IT_EXTENSION_IN STRUCTURE  BAPIPAREX OPTIONAL
*"      IT_DELIVERIES STRUCTURE  BAPISHPDELIVNUMB OPTIONAL
*"      IT_CREATED_ITEMS STRUCTURE  BAPIDLVITEMCREATED OPTIONAL
*"      IT_EXTENSION_OUT STRUCTURE  BAPIPAREX OPTIONAL
*"      IT_HEADER_PARTNER STRUCTURE  BAPIDLVPARTNERCHG OPTIONAL
*"      ET_RETURN STRUCTURE  BAPIRET2 OPTIONAL
*"----------------------------------------------------------------------
  CALL FUNCTION 'BAPI_OUTB_DELIVERY_CREATE_STO'
    EXPORTING
      ship_point        = iv_ship_point
      due_date          = iv_due_date
      debug_flg         = iv_debug_flg
      no_dequeue        = iv_no_dequeue
    IMPORTING
      delivery          = ev_delivery
      num_deliveries    = ev_num_deliveries
    TABLES
      stock_trans_items = it_stock_trans_items
      serial_numbers    = it_serial_numbers
      extension_in      = it_extension_in
      deliveries        = it_deliveries
      created_items     = it_created_items
      extension_out     = it_extension_out
      return            = et_return.

  LOOP AT et_return ASSIGNING FIELD-SYMBOL(<fs_return>).
    CHECK <fs_return>-type = 'E'.
    CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.
    RETURN.
  ENDLOOP.

  IF iv_guid IS SUPPLIED.
    IF iv_guid IS NOT INITIAL.
      UPDATE ztsd_intercompan SET remessa = ev_delivery
           WHERE guid = iv_guid.
    ENDIF.
  ENDIF.

  CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
    EXPORTING
      wait = abap_true.

*  IF it_header_partner[] IS INITIAL.
*    RETURN.
*  ENDIF.

  SELECT lifsp
    UP TO 1 ROWS
    FROM tvlsp
    INTO @DATA(lv_lifsp)
    WHERE lfart = 'ZNLC'. "transferencia
  ENDSELECT.

  DATA(lt_return) = VALUE bapiret2_t( ).
  CALL FUNCTION 'BAPI_OUTB_DELIVERY_CHANGE'
    EXPORTING
      header_data    = VALUE bapiobdlvhdrchg( deliv_numb = ev_delivery
                                              dlv_block  = lv_lifsp )
      header_control = VALUE bapiobdlvhdrctrlchg( deliv_numb = ev_delivery
                                                  dlv_block_flg = abap_true )
      delivery       = ev_delivery
    TABLES
     header_partner = it_header_partner
*     header_partner_addr     =
*     header_deadlines        =
*     item_data      =
*     item_control   =
*     item_serial_no =
*     supplier_cons_data      =
*     extension1     =
*     extension2     =
      return         = lt_return
*     tokenreference =
*     item_data_spl  =
*     collective_change_items =
*     new_item_data  =
*     new_item_data_spl       =
*     new_item_org   =
*     item_data_docu_batch    =
*     cwm_item_data  =
    .

  LOOP AT lt_return ASSIGNING <fs_return>.
    CHECK <fs_return>-type = 'E'.
    CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.
    APPEND LINES OF lt_return TO et_return.
    RETURN.
  ENDLOOP.

  CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
    EXPORTING
      wait = abap_true.


  if iv_input-tipo_operacao = 'TRA7'.
  UPDATE LIKP
    set lifex = iv_input-remessa_origem
    where vbeln = ev_delivery.

  update lips
    set WERKS = iv_input-centro_fornecedor
        LGORT = iv_input-deposito_origem
        where vbeln = ev_delivery.

  CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
    EXPORTING
      wait = abap_true.

 endif.


ENDFUNCTION.
