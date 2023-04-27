FUNCTION zfmmm_salesorder_change.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(IV_SALESDOCUMENT) LIKE  BAPIVBELN-VBELN
*"     VALUE(IS_ORDER_HEADER_IN) LIKE  BAPISDH1 STRUCTURE  BAPISDH1
*"       OPTIONAL
*"     VALUE(IS_ORDER_HEADER_INX) LIKE  BAPISDH1X STRUCTURE  BAPISDH1X
*"     VALUE(IV_SIMULATION) LIKE  BAPIFLAG-BAPIFLAG OPTIONAL
*"     VALUE(IV_BEHAVE_WHEN_ERROR) LIKE  BAPIFLAG-BAPIFLAG DEFAULT
*"       SPACE
*"     VALUE(IV_INT_NUMBER_ASSIGNMENT) LIKE  BAPIFLAG-BAPIFLAG DEFAULT
*"       SPACE
*"     VALUE(IS_LOGIC_SWITCH) LIKE  BAPISDLS STRUCTURE  BAPISDLS
*"       OPTIONAL
*"     VALUE(IV_NO_STATUS_BUF_INIT) LIKE  BAPIFLAG-BAPIFLAG DEFAULT
*"       SPACE
*"  TABLES
*"      ET_RETURN STRUCTURE  BAPIRET2
*"      IT_ORDER_ITEM_IN STRUCTURE  BAPISDITM OPTIONAL
*"      IT_ORDER_ITEM_INX STRUCTURE  BAPISDITMX OPTIONAL
*"      IT_PARTNERS STRUCTURE  BAPIPARNR OPTIONAL
*"      IT_PARTNERCHANGES STRUCTURE  BAPIPARNRC OPTIONAL
*"      IT_PARTNERADDRESSES STRUCTURE  BAPIADDR1 OPTIONAL
*"      IT_ORDER_CFGS_REF STRUCTURE  BAPICUCFG OPTIONAL
*"      IT_ORDER_CFGS_INST STRUCTURE  BAPICUINS OPTIONAL
*"      IT_ORDER_CFGS_PART_OF STRUCTURE  BAPICUPRT OPTIONAL
*"      IT_ORDER_CFGS_VALUE STRUCTURE  BAPICUVAL OPTIONAL
*"      IT_ORDER_CFGS_BLOB STRUCTURE  BAPICUBLB OPTIONAL
*"      IT_ORDER_CFGS_VK STRUCTURE  BAPICUVK OPTIONAL
*"      IT_ORDER_CFGS_REFINST STRUCTURE  BAPICUREF OPTIONAL
*"      IT_SCHEDULE_LINES STRUCTURE  BAPISCHDL OPTIONAL
*"      IT_SCHEDULE_LINESX STRUCTURE  BAPISCHDLX OPTIONAL
*"      IT_ORDER_TEXT STRUCTURE  BAPISDTEXT OPTIONAL
*"      IT_ORDER_KEYS STRUCTURE  BAPISDKEY OPTIONAL
*"      IT_CONDITIONS_IN STRUCTURE  BAPICOND OPTIONAL
*"      IT_CONDITIONS_INX STRUCTURE  BAPICONDX OPTIONAL
*"      IT_EXTENSIONIN STRUCTURE  BAPIPAREX OPTIONAL
*"      IT_EXTENSIONEX STRUCTURE  BAPIPAREX OPTIONAL
*"----------------------------------------------------------------------

  CALL FUNCTION 'BAPI_SALESORDER_CHANGE'
    EXPORTING
      salesdocument         = iv_salesdocument
      order_header_in       = is_order_header_in
      order_header_inx      = is_order_header_inx
      simulation            = iv_simulation
      behave_when_error     = iv_behave_when_error
      int_number_assignment = iv_int_number_assignment
      logic_switch          = is_logic_switch
      no_status_buf_init    = iv_no_status_buf_init
    TABLES
      return                = et_return
      order_item_in         = it_order_item_in
      order_item_inx        = it_order_item_inx
      partners              = it_partners
      partnerchanges        = it_partnerchanges
      partneraddresses      = it_partneraddresses
      order_cfgs_ref        = it_order_cfgs_ref
      order_cfgs_inst       = it_order_cfgs_inst
      order_cfgs_part_of    = it_order_cfgs_part_of
      order_cfgs_value      = it_order_cfgs_value
      order_cfgs_blob       = it_order_cfgs_blob
      order_cfgs_vk         = it_order_cfgs_vk
      order_cfgs_refinst    = it_order_cfgs_refinst
      schedule_lines        = it_schedule_lines
      schedule_linesx       = it_schedule_linesx
      order_text            = it_order_text
      order_keys            = it_order_keys
      conditions_in         = it_conditions_in
      conditions_inx        = it_conditions_inx
      extensionin           = it_extensionin
      extensionex           = it_extensionex.

  LOOP AT et_return ASSIGNING FIELD-SYMBOL(<fs_return>).
    CHECK <fs_return>-type = 'S'.
    CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
      EXPORTING
        wait = 'X'.
    RETURN.
  ENDLOOP.

ENDFUNCTION.
