FUNCTION zfmmm_lanc_fat_receb.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(IS_HEADERDATA) LIKE  BAPI_INCINV_CREATE_HEADER STRUCTURE
*"        BAPI_INCINV_CREATE_HEADER
*"  EXPORTING
*"     VALUE(EV_INVOICEDOCNUMBER) LIKE  BAPI_INCINV_FLD-INV_DOC_NO
*"     VALUE(EV_FISCALYEAR) LIKE  BAPI_INCINV_FLD-FISC_YEAR
*"  TABLES
*"      IT_ITEMDATA STRUCTURE  BAPI_INCINV_CREATE_ITEM
*"      ET_RETURN STRUCTURE  BAPIRET2
*"----------------------------------------------------------------------

  "Export de memória para atribuiçao de CFOP STANDARD
  "Import J_1B_NF_CFOP_1_DETERMINATION
  DATA(lv_cfop) = abap_true.
  EXPORT: lv_cfop TO MEMORY ID 'LANC_FAT_CFOP'.

  CALL FUNCTION 'BAPI_INCOMINGINVOICE_CREATE1'
    EXPORTING
      headerdata       = is_headerdata
    IMPORTING
      invoicedocnumber = ev_invoicedocnumber
      fiscalyear       = ev_fiscalyear
    TABLES
      itemdata         = it_itemdata
      return           = et_return.

  SORT et_return BY type.

  READ TABLE et_return TRANSPORTING NO FIELDS
    WITH KEY type = 'E' BINARY SEARCH.
  IF sy-subrc NE 0.
    CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
      EXPORTING
        wait = abap_true.
  ENDIF.

  FREE MEMORY ID 'LANC_FAT_CFOP'.

ENDFUNCTION.
