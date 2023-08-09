FUNCTION zfmmm_monitserv_invoice_simula.
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
*"     VALUE(ET_ACCOUNTING) TYPE  ZCTGMM_INVOICE_ACCOUNTING
*"     VALUE(ET_RETURN) TYPE  BAPIRET2_T
*"  TABLES
*"      CT_ITEMDATA STRUCTURE  BAPI_INCINV_CREATE_ITEM OPTIONAL
*"----------------------------------------------------------------------
  CHECK ct_itemdata[] IS NOT INITIAL.
  DATA(ls_item) = ct_itemdata[ 1 ].

  DATA lt_material    TYPE TABLE OF bapi_incinv_create_material.
  DATA lt_withtaxdata TYPE TABLE OF bapi_incinv_create_withtax.
  DATA lt_return      TYPE TABLE OF bapiret2.
  DATA lt_acchd       TYPE TABLE OF acchd.
  DATA lt_accit       TYPE TABLE OF accit.
  DATA lt_acccr       TYPE TABLE OF acccr.
  DATA ls_accitem     TYPE zsmm_invoice_accounting.
  DATA lv_buzei       TYPE bseg-buzei.
  DATA lt_accountingdata TYPE TABLE OF bapi_incinv_create_account.

  CONSTANTS:  lc_5 TYPE i VALUE '5'.

  FIELD-SYMBOLS:
    <fs_xaccit> TYPE accit,
    <fs_xacccr> TYPE acccr,
    <fs_bseg>   TYPE zsmm_invoice_accounting.

  CONSTANTS:
    lc_currency_brl     TYPE bkpf-waers VALUE 'BRL',
    lc_vendor_indicator TYPE bseg-shkzg VALUE 'K'.

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

  lt_withtaxdata[] = VALUE #( FOR ls_fsbw IN lt_lfbw INDEX INTO lv_index (
    split_key   = 1
    wi_tax_type = ls_fsbw-witht
    wi_tax_code = ls_fsbw-wt_withcd
  ) ).

  SELECT
      matnr,
      werks,
      mwskz,
      menge,
      txjcd,
      brtwr,
      meins
  FROM ekpo
  INTO TABLE @DATA(lt_ekpo)
   FOR ALL ENTRIES IN @ct_itemdata
 WHERE ebeln = @ct_itemdata-po_number
   AND ebelp = @ct_itemdata-po_item.

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

  SELECT ebeln, ebelp, zekkn, menge, sakto, anln1, gsber, kokrs, kostl, aufnr, ps_psp_pnr, fistl, fkber, prctr
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
                                                    purchaseorderitem = ls_itemdata-po_item..
    IF sy-subrc IS INITIAL.

      IF ls_pursh-consumptionposting = 'A' OR ls_pursh-consumptionposting = 'V'.

        READ TABLE lt_ekkn WITH KEY ebeln = ls_itemdata-po_number
                                    ebelp = ls_itemdata-po_item
                                    TRANSPORTING NO FIELDS.

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
                                                                  item_amount = ls_pursh-netpriceamount * <fs_ekkn>-menge
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
                                                                  co_area = <fs_ekkn>-kokrs
                                                                  costcenter = <fs_ekkn>-kostl
                                                                  funds_ctr = <fs_ekkn>-fistl
                                                                  func_area = <fs_ekkn>-fkber
                                                                  profit_ctr = <fs_ekkn>-prctr
                                                                  orderid =  COND #( WHEN ls_pursh-consumptionposting = 'V' OR ls_pursh-consumptionposting = 'A' THEN <fs_ekkn>-aufnr )
                                                                  wbs_elem = COND #( WHEN ls_pursh-consumptionposting = 'V' OR ls_pursh-consumptionposting = 'A' THEN <fs_ekkn>-ps_psp_pnr ) ) ).
          ENDIF.
        ENDLOOP.
      ENDIF.
    ENDIF.

  ENDLOOP.

  DATA(lv_posi_t) = strlen( is_headerdata-ref_doc_no ).
  IF lv_posi_t > lc_5.
    DATA(lv_rest) = lv_posi_t - 6.
    is_headerdata-ref_doc_no = is_headerdata-ref_doc_no+lv_rest(6).
  ENDIF.

  IF  lt_accountingdata[] IS NOT INITIAL.

    CALL FUNCTION 'BAPI_INCOMINGINVOICE_CREATE1'
      EXPORTING
        headerdata       = is_headerdata
        addressdata      = is_addressdata
        invoicestatus    = is_invoicestatus
      IMPORTING
        invoicedocnumber = ev_invoicedocnumber
        fiscalyear       = ev_fiscalyear
      TABLES
        itemdata         = ct_itemdata
        withtaxdata      = lt_withtaxdata
        accountingdata   = lt_accountingdata
        return           = et_return.
  ELSE.
    CALL FUNCTION 'BAPI_INCOMINGINVOICE_CREATE1'
      EXPORTING
        headerdata       = is_headerdata
        addressdata      = is_addressdata
        invoicestatus    = is_invoicestatus
      IMPORTING
        invoicedocnumber = ev_invoicedocnumber
        fiscalyear       = ev_fiscalyear
      TABLES
        itemdata         = ct_itemdata
        withtaxdata      = lt_withtaxdata
        return           = et_return.
  ENDIF.
  SORT et_return BY type.
  CHECK NOT line_exists( et_return[ type = 'E' ] ).

  CALL FUNCTION 'MRM_XACCITCR_EXPORT'
    TABLES
      t_acchd = lt_acchd
      t_accit = lt_accit
      t_acccr = lt_acccr.

  LOOP AT lt_accit ASSIGNING <fs_xaccit> WHERE lifnr <> space.
    ls_accitem-bschl = <fs_xaccit>-bschl.
    ls_accitem-shkzg = lc_vendor_indicator.
    ls_accitem-bukrs = <fs_xaccit>-bukrs.
    ls_accitem-werks = <fs_xaccit>-werks.
    ls_accitem-hkont = <fs_xaccit>-kunnr.
    ls_accitem-zuonr = <fs_xaccit>-zuonr.
    ls_accitem-mwskz = <fs_xaccit>-mwskz.

    SELECT SINGLE name1
      INTO ls_accitem-ktext
      FROM lfa1
     WHERE lifnr = <fs_xaccit>-lifnr.                "#EC CI_SEL_NESTED

    READ TABLE lt_acccr ASSIGNING <fs_xacccr> WITH KEY posnr = <fs_xaccit>-posnr.
    IF sy-subrc = 0.
      ls_accitem-dmbtr   = <fs_xacccr>-wrbtr.
      ls_accitem-wrbtr   = <fs_xacccr>-wrbtr.
      ls_accitem-h_hwaer = <fs_xacccr>-waers.
      ls_accitem-h_waers = <fs_xacccr>-waers.

      "//Verifica se é diferente de BRL
      IF <fs_xacccr>-waers <> lc_currency_brl.
        UNASSIGN <fs_xacccr>.
        READ TABLE lt_acccr ASSIGNING <fs_xacccr>
         WITH KEY posnr = <fs_xaccit>-posnr waers = lc_currency_brl.

        IF sy-subrc = 0.
          ls_accitem-h_hwaer = lc_currency_brl.
          ls_accitem-dmbtr   = <fs_xacccr>-wrbtr.
          ls_accitem-kursf   = ls_accitem-dmbtr / ls_accitem-wrbtr.
        ENDIF.
      ENDIF.
    ENDIF.

    IF ls_accitem-kursf < 0.
      ls_accitem-kursf = ls_accitem-kursf * -1.
    ENDIF.

    IF NOT ls_accitem-dmbtr IS INITIAL.
      APPEND ls_accitem TO et_accounting.
    ENDIF.

    CLEAR ls_accitem.
  ENDLOOP.

  "//Contas somente sem fornecedor
  LOOP AT lt_accit ASSIGNING <fs_xaccit> WHERE hkont <> space AND lifnr = space.
    ls_accitem-bschl = <fs_xaccit>-bschl.
    ls_accitem-bukrs = <fs_xaccit>-bukrs.
    ls_accitem-werks = <fs_xaccit>-werks.
    ls_accitem-shkzg = <fs_xaccit>-shkzg.
    ls_accitem-hkont = <fs_xaccit>-hkont.
    ls_accitem-zuonr = <fs_xaccit>-bldat.
    ls_accitem-mwskz = <fs_xaccit>-mwskz.
    ls_accitem-qsskz = <fs_xaccit>-qsskz.

    SELECT SINGLE txt50
      INTO ls_accitem-ktext
      FROM skat
     WHERE spras = sy-langu
       AND saknr = <fs_xaccit>-hkont.                "#EC CI_SEL_NESTED

    READ TABLE lt_acccr ASSIGNING <fs_xacccr> WITH KEY posnr = <fs_xaccit>-posnr.
    IF sy-subrc = 0.
      ls_accitem-dmbtr   = <fs_xacccr>-wrbtr.
      ls_accitem-wrbtr   = <fs_xacccr>-wrbtr.
      ls_accitem-h_hwaer = <fs_xacccr>-waers.
      ls_accitem-h_waers = <fs_xacccr>-waers.

      "//Verifica se é diferente de BRL
      IF <fs_xacccr>-waers <> lc_currency_brl.
        UNASSIGN <fs_xacccr>.
        READ TABLE lt_acccr ASSIGNING <fs_xacccr>
         WITH KEY posnr = <fs_xaccit>-posnr waers = lc_currency_brl.

        IF sy-subrc = 0.
          ls_accitem-h_hwaer = lc_currency_brl.
          ls_accitem-dmbtr   = <fs_xacccr>-wrbtr.
          ls_accitem-kursf   = ls_accitem-dmbtr / ls_accitem-wrbtr.
        ENDIF.
      ENDIF.
    ENDIF.

    IF ls_accitem-kursf < 0.
      ls_accitem-kursf = ls_accitem-kursf * -1.
    ENDIF.

    IF NOT ls_accitem-dmbtr IS INITIAL.
      APPEND ls_accitem TO et_accounting.
    ENDIF.

    CLEAR ls_accitem.
  ENDLOOP.

  LOOP AT et_accounting ASSIGNING <fs_bseg>.
    ADD 1 TO lv_buzei.
    <fs_bseg>-buzei = lv_buzei.
  ENDLOOP.

ENDFUNCTION.
