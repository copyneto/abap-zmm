FUNCTION zfmmm_monitserv_invoice_create.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(IS_HEADERDATA) TYPE  BAPI_INCINV_CREATE_HEADER
*"     VALUE(IS_ADDRESSDATA) TYPE  BAPI_INCINV_CREATE_ADDRESSDATA
*"       OPTIONAL
*"     VALUE(IS_INVOICESTATUS) TYPE  BAPI_INCINV_CREATE_STATUS-RBSTAT
*"       DEFAULT '5'
*"  EXPORTING
*"     VALUE(EV_INVOICEDOCNUMBER) TYPE  BAPI_INCINV_FLD-INV_DOC_NO
*"     VALUE(EV_FISCALYEAR) TYPE  BAPI_INCINV_FLD-FISC_YEAR
*"  TABLES
*"      CT_ITEMDATA STRUCTURE  BAPI_INCINV_CREATE_ITEM OPTIONAL
*"      CT_ACCOUNTINGDATA STRUCTURE  BAPI_INCINV_CREATE_ACCOUNT
*"       OPTIONAL
*"      CT_GLACCOUNTDATA STRUCTURE  BAPI_INCINV_CREATE_GL_ACCOUNT
*"       OPTIONAL
*"      CT_MATERIALDATA STRUCTURE  BAPI_INCINV_CREATE_MATERIAL OPTIONAL
*"      CT_TAXDATA STRUCTURE  BAPI_INCINV_CREATE_TAX OPTIONAL
*"      CT_WITHTAXDATA STRUCTURE  BAPI_INCINV_CREATE_WITHTAX OPTIONAL
*"      CT_VENDORITEMSPLITDATA STRUCTURE
*"        BAPI_INCINV_CREATE_VENDORSPLIT OPTIONAL
*"      CT_RETURN STRUCTURE  BAPIRET2 OPTIONAL
*"      CT_EXTENSIONIN STRUCTURE  BAPIPAREX OPTIONAL
*"      CTT_EXTENSIONOUT STRUCTURE  BAPIPAREX OPTIONAL
*"      CT_TM_ITEMDATA STRUCTURE  BAPI_INCINV_CREATE_TM_ITEM OPTIONAL
*"      CT_ASSETDATA STRUCTURE  BAPI_INCINV_DETAIL_ASSET OPTIONAL
*"----------------------------------------------------------------------
  DATA lt_accountingdata TYPE TABLE OF bapi_incinv_create_account.



  CHECK ct_itemdata[] IS NOT INITIAL.
  DATA(ls_item) = ct_itemdata[ 1 ].

  SELECT SINGLE lifnr
    FROM ekko
    INTO @DATA(lv_lifnr)
   WHERE ebeln = @ls_item-po_number.

  SELECT witht, wt_withcd
    FROM lfbw
    INTO TABLE @DATA(lt_lfbw)
   WHERE lifnr     = @lv_lifnr
     AND bukrs     = @is_headerdata-comp_code
     AND wt_subjct = @abap_true.

  ct_withtaxdata[] = VALUE #( FOR ls_lfbw IN lt_lfbw INDEX INTO lv_index (
    split_key   = 1
    wi_tax_type = ls_lfbw-witht
    wi_tax_code = ls_lfbw-wt_withcd
  ) ).
  SELECT purchaseorder, purchaseorderitem, consumptionposting, taxcode, taxjurisdiction,
       netpriceamount, purchaseorderquantityunit
       FROM i_purchaseorderitem
       FOR ALL ENTRIES IN @ct_itemdata
       WHERE purchaseorder = @ct_itemdata-po_number
       AND   purchaseorderitem = @ct_itemdata-po_item
       INTO TABLE @DATA(lt_pursh).

  IF sy-subrc IS INITIAL.
    SORT lt_pursh BY purchaseorder purchaseorderitem.
    DATA(lt_pursh_aux) = lt_pursh[].
    SORT lt_pursh_aux BY purchaseorderquantityunit.
    DELETE ADJACENT DUPLICATES FROM lt_pursh_aux COMPARING purchaseorderquantityunit.

    IF  lt_pursh_aux[] IS NOT INITIAL.
      SELECT msehi, isocode
      FROM t006
      FOR ALL ENTRIES IN @lt_pursh_aux
      WHERE msehi = @lt_pursh_aux-purchaseorderquantityunit
      INTO TABLE @DATA(lt_t006).

    ENDIF.

  ENDIF.

  SELECT ebeln, ebelp, zekkn, menge, sakto, anln1, gsber, kokrs
      FROM ekkn
      FOR ALL ENTRIES IN @ct_itemdata
      WHERE ebeln = @ct_itemdata-po_number
      AND   ebelp = @ct_itemdata-po_item
      INTO TABLE @DATA(lt_ekkn).

  IF sy-subrc IS INITIAL.
    SORT lt_ekkn BY ebeln ebelp zekkn ASCENDING.
  ENDIF.


  LOOP AT ct_itemdata INTO DATA(ls_itemdata).

    READ TABLE lt_pursh INTO DATA(ls_pursh) WITH KEY purchaseorder = ls_itemdata-po_number
                                                    purchaseorderitem = ls_itemdata-po_item
                                                    BINARY SEARCH.
    IF sy-subrc IS INITIAL.

      IF ls_pursh-consumptionposting = 'A'.

        READ TABLE lt_ekkn WITH KEY ebeln = ls_itemdata-po_number
                                    ebelp = ls_itemdata-po_item
                                    BINARY SEARCH
                                    TRANSPORTING NO FIELDS.
        CHECK sy-subrc IS INITIAL.
        LOOP AT lt_ekkn ASSIGNING FIELD-SYMBOL(<fs_ekkn>) FROM sy-tabix.

          IF <fs_ekkn>-ebeln <> ls_itemdata-po_number
           OR <fs_ekkn>-ebelp <> ls_itemdata-po_item.
            EXIT.
          ENDIF.

          READ TABLE lt_t006 INTO DATA(ls_t006) WITH KEY msehi = ls_pursh-purchaseorderquantityunit
                                                         BINARY SEARCH.
          IF sy-subrc IS INITIAL.

            lt_accountingdata = VALUE #( BASE lt_accountingdata ( invoice_doc_item  = ls_itemdata-invoice_doc_item
                                                                  serial_no = <fs_ekkn>-zekkn
                                                                  tax_code = ls_pursh-taxcode
                                                                  taxjurcode = ls_pursh-taxjurisdiction
                                                                  item_amount = ls_pursh-netpriceamount
                                                                  quantity = <fs_ekkn>-menge
                                                                  po_unit = ls_pursh-purchaseorderquantityunit
                                                                  po_unit_iso = ls_t006-isocode
                                                                  po_pr_qnt = <fs_ekkn>-menge
                                                                  po_pr_uom = ls_pursh-purchaseorderquantityunit
                                                                  po_pr_uom_iso = ls_t006-isocode
                                                                  gl_account = <fs_ekkn>-sakto
                                                                  asset_no = <fs_ekkn>-anln1
                                                                  cmmt_item = <fs_ekkn>-sakto
                                                                  bus_area = <fs_ekkn>-gsber
                                                                  co_area = <fs_ekkn>-kokrs                         ) ).
          ENDIF.
        ENDLOOP.
      ENDIF.
    ENDIF.

  ENDLOOP.

  IF  lt_accountingdata[] IS NOT INITIAL.

    CALL FUNCTION 'BAPI_INCOMINGINVOICE_CREATE1'
      EXPORTING
        headerdata          = is_headerdata
        addressdata         = is_addressdata
        invoicestatus       = is_invoicestatus
      IMPORTING
        invoicedocnumber    = ev_invoicedocnumber
        fiscalyear          = ev_fiscalyear
      TABLES
        itemdata            = ct_itemdata
        accountingdata      = lt_accountingdata
        glaccountdata       = ct_glaccountdata
        materialdata        = ct_materialdata
        taxdata             = ct_taxdata
        withtaxdata         = ct_withtaxdata
        vendoritemsplitdata = ct_vendoritemsplitdata
        return              = ct_return
        extensionin         = ct_extensionin
        extensionout        = ctt_extensionout
        tm_itemdata         = ct_tm_itemdata
        assetdata           = ct_assetdata.
  ELSE.

    CALL FUNCTION 'BAPI_INCOMINGINVOICE_CREATE1'
      EXPORTING
        headerdata          = is_headerdata
        addressdata         = is_addressdata
        invoicestatus       = is_invoicestatus
      IMPORTING
        invoicedocnumber    = ev_invoicedocnumber
        fiscalyear          = ev_fiscalyear
      TABLES
        itemdata            = ct_itemdata
        accountingdata      = ct_accountingdata
        glaccountdata       = ct_glaccountdata
        materialdata        = ct_materialdata
        taxdata             = ct_taxdata
        withtaxdata         = ct_withtaxdata
        vendoritemsplitdata = ct_vendoritemsplitdata
        return              = ct_return
        extensionin         = ct_extensionin
        extensionout        = ctt_extensionout
        tm_itemdata         = ct_tm_itemdata
        assetdata           = ct_assetdata.
  ENDIF.
  IF ev_invoicedocnumber IS NOT INITIAL.
    CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'.
  ENDIF.

ENDFUNCTION.
