FUNCTION zfmm_j1bn1.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     REFERENCE(IV_MBLNR) TYPE  MBLNR
*"     REFERENCE(IV_MJAHR) TYPE  MJAHR
*"     REFERENCE(IV_IBLNR) TYPE  IBLNR
*"     REFERENCE(IV_MAIN) TYPE  ZSMM_ALIVIUM
*"  EXPORTING
*"     REFERENCE(EV_DOCNUM_ENTRADA) TYPE  J_1BDOCNUM
*"     REFERENCE(EV_DOCNUM_SAIDA) TYPE  J_1BDOCNUM
*"     REFERENCE(ET_RETURN) TYPE  BAPIRET2_TAB
*"----------------------------------------------------------------------
  DATA: ls_mkpf           TYPE mkpf,
        lt_mseg           TYPE TABLE OF mseg,
        ls_mseg           LIKE LINE OF lt_mseg,
        lt_mbew           TYPE TABLE OF mbew,
        ls_mbew           LIKE LINE OF lt_mbew,
        lt_nf_item_en     TYPE TABLE OF bapi_j_1bnflin,
        lt_nf_item_sa     TYPE TABLE OF bapi_j_1bnflin,
        ls_nf_item        LIKE LINE OF lt_nf_item_en,
        lv_cfop_en        TYPE j_1bnflin-cfop,
        lv_cfop_sa        TYPE j_1bnflin-cfop,
        lv_incltx         TYPE j_1bnflin-incltx VALUE 'X',
        lt_makt           TYPE TABLE OF makt,
        ls_makt           LIKE LINE OF lt_makt,
        lt_mara           TYPE TABLE OF mara,
        ls_mara           LIKE LINE OF lt_mara,
        lv_brgew_en       TYPE j_1bnfdoc-brgew,
        lv_ntgew_en       TYPE j_1bnfdoc-ntgew,
        lv_brgew_sa       TYPE j_1bnfdoc-brgew,
        lv_ntgew_sa       TYPE j_1bnfdoc-ntgew,
        lt_marc           TYPE TABLE OF marc,
        ls_marc           LIKE LINE OF lt_marc,
        lv_itmnum_en      TYPE j_1bnflin-itmnum,
        lv_itmnum_sa      TYPE j_1bnflin-itmnum,
        lt_nf_item_add_en TYPE TABLE OF bapi_j_1bnflin_add,
        lt_nf_item_add_sa TYPE TABLE OF bapi_j_1bnflin_add,
        ls_nf_item_add    LIKE LINE OF lt_nf_item_add_en,
        lt_nf_msg_en      TYPE TABLE OF bapi_j_1bnfftx,
        lt_nf_msg_sa      TYPE TABLE OF bapi_j_1bnfftx,
        ls_nf_msg         LIKE LINE OF lt_nf_msg_en,
        lt_nf_header      TYPE TABLE OF bapi_j_1bnfdoc,
        ls_nf_header_en   LIKE LINE OF lt_nf_header,
        ls_nf_header_sa   LIKE LINE OF lt_nf_header,
        lt_nf_item_tax_en TYPE TABLE OF bapi_j_1bnfstx,
        lt_nf_item_tax_sa TYPE TABLE OF bapi_j_1bnfstx,
        ls_nf_item_tax    LIKE LINE OF lt_nf_item_tax_en,
        lv_test_value     TYPE j_1bbase,
        lt_nf_partner_en  TYPE TABLE OF bapi_j_1bnfnad,
        lt_nf_partner_sa  TYPE TABLE OF bapi_j_1bnfnad,
        ls_nf_partner     LIKE LINE OF lt_nf_partner_sa,
        lt_nf_ot_part     TYPE TABLE OF bapi_j_1bnfcpd,
        lt_nf_return_en   TYPE TABLE OF bapiret2,
        lt_nf_return_sa   TYPE TABLE OF bapiret2,
        lt_nf_ref         TYPE TABLE OF bapi_j_1bnfref,
        lv_nftype_en      TYPE j_1bnfdoc-nftype,
        lv_nftype_sa      TYPE j_1bnfdoc-nftype,
        lv_parid_en       TYPE j_1bnfdoc-parid,
        lv_parid_sa       TYPE j_1bnfdoc-parid,
        lv_parvw_en       TYPE j_1bnfdoc-parvw,
        lv_parvw_sa       TYPE j_1bnfdoc-parvw,
        lv_partyp_en      TYPE j_1bnfdoc-partyp,
        lv_partyp_sa      TYPE j_1bnfdoc-partyp,
        lv_direct_en      TYPE j_1bnfdoc-direct,
        lv_direct_sa      TYPE j_1bnfdoc-direct,
        lv_form_en        TYPE j_1bnfdoc-form,
        lv_form_sa        TYPE j_1bnfdoc-form,
        ls_info_nota_en   TYPE j_1baa,
        ls_info_nota_sa   TYPE j_1baa,
        lv_model_en       TYPE j_1bnfdoc-model,
        lv_model_sa       TYPE j_1bnfdoc-model,
        lv_doctyp_en      TYPE j_1bnfdoc-doctyp,
        lv_doctyp_sa      TYPE j_1bnfdoc-doctyp,
        lv_nftot          TYPE j_1bnfdoc-nftot,
        lv_condvalue      TYPE bapicond-condvalue.

  DATA: lt_mseg_en TYPE TABLE OF mseg,
        lt_mseg_sa TYPE TABLE OF mseg.

  DATA: lv_nfcheck    TYPE bapi_j_1bnfcheck VALUE 'XX'.

  DATA: lv_docnum_en TYPE j_1bnfdoc-docnum,
        lv_docnum_sa TYPE j_1bnfdoc-docnum.

  DATA: ls_zcgc_coligada TYPE ztmm_cgccoligada,
        ls_t001w         TYPE t001w,
        lt_tvak          TYPE TABLE OF tvak,
        ls_tvak          TYPE tvak.

  DATA: lv_tabix  TYPE sy-tabix,
        lv_tabix2 TYPE sy-tabix.

  DATA:
    lt_nfe_payment TYPE TABLE OF bapi_j_1bnfe_payment,
    ls_nfe_payment LIKE LINE  OF lt_nfe_payment,
    ls_nf_item_pay TYPE bapi_j_1bnflin,
    lv_netwr       TYPE j_1bnetval.

  SELECT SINGLE *                             "#EC CI_ALL_FIELDS_NEEDED
    FROM mkpf INTO ls_mkpf
   WHERE mblnr EQ iv_mblnr
     AND mjahr EQ iv_mjahr.

  CHECK sy-subrc IS INITIAL.

  SELECT * FROM mseg INTO TABLE lt_mseg
    WHERE mblnr EQ iv_mblnr
    AND   mjahr EQ iv_mjahr.

  CHECK sy-subrc IS INITIAL.

  lt_mseg_en = lt_mseg.
  DELETE lt_mseg_en WHERE shkzg EQ |H|.

  lt_mseg_sa = lt_mseg.
  DELETE lt_mseg_sa WHERE shkzg EQ |S|.

  SELECT *                                         "#EC CI_NO_TRANSFORM
    FROM mbew
    INTO TABLE lt_mbew
     FOR ALL ENTRIES IN lt_mseg
   WHERE matnr = lt_mseg-matnr
     AND bwkey = lt_mseg-werks.

  CHECK lt_mbew IS NOT INITIAL.

  SORT lt_mbew BY matnr bwkey.

  SELECT * FROM mara INTO TABLE lt_mara
    FOR ALL ENTRIES IN lt_mbew
    WHERE matnr EQ lt_mbew-matnr.

  CHECK lt_mara IS NOT INITIAL.

  SORT lt_mara BY matnr.

  SELECT *                                    "#EC CI_ALL_FIELDS_NEEDED
    FROM makt
    INTO TABLE lt_makt
     FOR ALL ENTRIES IN lt_mara
   WHERE matnr EQ lt_mara-matnr
     AND spras EQ sy-langu.

  SORT lt_makt BY matnr.

  SELECT *                                    "#EC CI_ALL_FIELDS_NEEDED
    FROM marc
    INTO TABLE lt_marc
     FOR ALL ENTRIES IN lt_mbew
   WHERE matnr EQ lt_mbew-matnr
     AND werks EQ lt_mbew-bwkey.

  SORT lt_marc BY matnr werks.

  READ TABLE lt_mseg INTO ls_mseg INDEX 1.

  SELECT SINGLE *                             "#EC CI_ALL_FIELDS_NEEDED
    FROM t001w
    INTO ls_t001w
   WHERE werks = ls_mseg-werks.

  SELECT SINGLE *                             "#EC CI_ALL_FIELDS_NEEDED
    FROM ztmm_cgccoligada
    INTO ls_zcgc_coligada
   WHERE bukrs = ls_mseg-bukrs
     AND bupla = ls_t001w-j_1bbranch.

  SELECT *                                    "#EC CI_ALL_FIELDS_NEEDED
    FROM tvak
    INTO TABLE lt_tvak
   WHERE auart IN (gc_auart_saida,gc_auart_entrada).

  lv_parvw_en = |LF|.
  lv_parid_en = ls_zcgc_coligada-lifnr.
  lv_cfop_en   = |194920|.

  READ TABLE lt_tvak INTO ls_tvak WITH KEY auart = gc_auart_entrada.
  lv_nftype_en = ls_tvak-j_1bnftype.

  SELECT SINGLE *                             "#EC CI_ALL_FIELDS_NEEDED
    FROM j_1baa
    INTO ls_info_nota_en
   WHERE nftype EQ lv_nftype_en.

  CHECK sy-subrc IS INITIAL.

  lv_direct_en = ls_info_nota_en-direct.
  lv_form_en   = ls_info_nota_en-form.
  lv_partyp_en = ls_info_nota_en-partyp.
  lv_model_en  = ls_info_nota_en-model.
  lv_doctyp_en = ls_info_nota_en-doctyp.

  IF NOT ls_info_nota_en-parvw IS INITIAL.
    lv_parvw_en = ls_info_nota_en-parvw.
  ENDIF.

  "CONFIGURAÇÕES NOTA DE SAÍDA
  lv_parvw_sa = |AG|.
  lv_parid_sa = ls_zcgc_coligada-col_ci.
  lv_cfop_sa   = |594920|.

  CLEAR ls_tvak.
  READ TABLE lt_tvak INTO ls_tvak WITH KEY auart = gc_auart_saida.
  lv_nftype_sa = ls_tvak-j_1bnftype.

  SELECT SINGLE *
    FROM j_1baa
    INTO ls_info_nota_sa
   WHERE nftype EQ lv_nftype_sa.

  CHECK sy-subrc IS INITIAL.
  lv_direct_sa = ls_info_nota_sa-direct.
  lv_form_sa   = ls_info_nota_sa-form.
  lv_partyp_sa = ls_info_nota_sa-partyp.
  lv_model_sa  = ls_info_nota_sa-model.
  lv_doctyp_sa = ls_info_nota_sa-doctyp.

  IF NOT ls_info_nota_sa-parvw IS INITIAL.
    lv_parvw_sa = ls_info_nota_sa-parvw.
  ENDIF.

  DATA: lt_mkpf           TYPE TABLE OF mkpf,
        lt_cond           TYPE crmt_bapicond_t,
        ls_cond           LIKE LINE OF lt_cond,
        lt_dir_fiscais    TYPE TABLE OF zsmm_alivium_dirfiscais,
        ls_dir_fiscais    TYPE zsmm_alivium_dirfiscais,
        lt_zsdtdirfiscais TYPE STANDARD TABLE OF ztmm_dirfiscais,
        ls_zsdtdirfiscais TYPE ztmm_dirfiscais.

  SELECT *                                          "#EC CI_ALL_FIELDS_NEEDED
    FROM mkpf
    INTO TABLE lt_mkpf
   WHERE mblnr = iv_mblnr
     AND mjahr = iv_mjahr.

  LOOP AT lt_mseg INTO ls_mseg.
    CLEAR: ls_nf_item.

    READ TABLE lt_mbew INTO ls_mbew WITH KEY matnr = ls_mseg-matnr
                                             bwkey = ls_mseg-werks
                                             BINARY SEARCH.

    CHECK sy-subrc IS INITIAL.

    READ TABLE lt_makt INTO ls_makt WITH KEY matnr = ls_mseg-matnr BINARY SEARCH.
    CHECK sy-subrc IS INITIAL.

    READ TABLE lt_mara INTO ls_mara WITH KEY matnr = ls_mseg-matnr BINARY SEARCH.

    READ TABLE lt_marc INTO ls_marc WITH KEY matnr = ls_mseg-matnr
                                             werks = ls_mseg-werks BINARY SEARCH.
    CHECK sy-subrc IS INITIAL.

    ls_nf_item-matnr     =  ls_mseg-matnr.
    ls_nf_item-werks     =  ls_mseg-werks.
    ls_nf_item-menge     =  ls_mseg-menge.
    ls_nf_item-charg     =  ls_mseg-charg.
    ls_nf_item-incltx    =  lv_incltx.
    ls_nf_item-bwkey     = ls_mbew-bwkey.
    ls_nf_item-meins     = ls_mseg-meins.
    ls_nf_item-matorg    = ls_mbew-mtorg.
    ls_nf_item-matuse    = ls_mbew-mtuse.
    ls_nf_item-ownpro    = ls_mbew-ownpr.
    ls_nf_item-netwr     = ls_mbew-stprs * ls_nf_item-menge.
    ls_nf_item-netpr     = ls_mbew-stprs.
    ls_nf_item-maktx     = ls_makt-maktx.
    ls_nf_item-matkl     = ls_mara-matkl.
    ls_nf_item-nbm       = ls_marc-steuc.

    ls_nf_item-reftyp   = |MD|.

    CONCATENATE ls_mseg-mblnr ls_mseg-mjahr INTO ls_nf_item-refkey.
    ls_nf_item-refitm   =  ls_mseg-zeile.

    IF iv_main-docnum_saida IS INITIAL AND ls_mseg-shkzg EQ |H|.
      "saída

      ls_nf_item-itmtyp    =  |80|.
      ls_nf_item-cfop_10   =  lv_cfop_sa.
      lv_brgew_sa = ( ls_mara-brgew *  ls_nf_item-menge ) + lv_brgew_sa.
      lv_ntgew_sa = ( ls_mara-ntgew *  ls_nf_item-menge ) + lv_ntgew_sa.

      ADD 10 TO lv_itmnum_sa.

      ls_nf_item-itmnum = lv_itmnum_sa.

      APPEND ls_nf_item TO lt_nf_item_sa.
    ELSEIF ls_mseg-shkzg EQ 'S' AND iv_main-docnum_entrada IS INITIAL.
      "entrada

      ls_nf_item-itmtyp  =  |81|.
      ls_nf_item-cfop_10 =  lv_cfop_en.
      lv_brgew_en = ( ls_mara-brgew *  ls_nf_item-menge ) + lv_brgew_en.
      lv_ntgew_en = ( ls_mara-ntgew *  ls_nf_item-menge ) + lv_ntgew_en.

      ADD 10 TO lv_itmnum_en.
      ls_nf_item-itmnum = lv_itmnum_en.
      APPEND ls_nf_item TO lt_nf_item_en.
    ENDIF.

    IF NOT lt_nf_item_en IS INITIAL.
      CLEAR lt_zsdtdirfiscais.
      SELECT *                                       "#EC CI_SEL_NESTED
        FROM ztmm_dirfiscais
         FOR ALL ENTRIES IN @lt_nf_item_en
       WHERE shipfrom = @ls_t001w-regio
         AND direcao  = @( |1| )
         AND cfop     = @lt_nf_item_en-cfop_10
        INTO TABLE @lt_zsdtdirfiscais.
    ENDIF.

    CLEAR: ls_nf_item_add.

    ls_nf_item_add-itmnum  = ls_nf_item-itmnum.
    ls_nf_item_add-nfpri   = ls_nf_item-netpr.
    ls_nf_item_add-nfnet   = ls_nf_item-netwr.
    ls_nf_item_add-netwrt  = ls_nf_item-netwr.
    ls_nf_item_add-nfnett  = ls_nf_item-netwr.

    IF iv_main-docnum_saida IS INITIAL AND ls_mseg-shkzg EQ |H|.
      "saída
      APPEND ls_nf_item_add TO lt_nf_item_add_sa.
    ELSEIF ls_mseg-shkzg EQ |S| AND iv_main-docnum_entrada IS INITIAL.
      "entrada
      APPEND ls_nf_item_add TO lt_nf_item_add_en.
    ENDIF.
  ENDLOOP.

  ls_nf_msg-seqnum = |02|.
  ls_nf_msg-linnum = |01|.
  ls_nf_msg-manual = |X|.
  ls_nf_msg-message = |DOC INVENTÁRIO|.
  CONCATENATE ls_nf_msg-message iv_iblnr INTO ls_nf_msg-message SEPARATED BY `:`.

  IF NOT lt_nf_item_en IS INITIAL.
    "nota entrada
    APPEND ls_nf_msg TO lt_nf_msg_en.
  ENDIF.

  IF NOT lt_nf_item_sa IS INITIAL.
    APPEND ls_nf_msg TO lt_nf_msg_sa.
  ENDIF.

  DATA: ls_return TYPE bapireturn.

  REFRESH: lt_cond,
           lt_dir_fiscais.

  CLEAR:   ls_return,
           lv_condvalue.

*** IMPOSTOS:
  IF lt_mseg_sa IS NOT INITIAL.
    CALL FUNCTION 'ZFMM_BAPI_SO_SIMULATE'
      EXPORTING
        it_mkpf                    = lt_mkpf
        it_mseg                    = lt_mseg_sa
        it_cond                    = lt_cond
        it_dirf                    = lt_dir_fiscais
      IMPORTING
        ev_bapireturn              = ls_return
        et_dirf                    = lt_dir_fiscais
      EXCEPTIONS
        ex_mkpf_not_filled         = 1
        ex_mseg_not_filled         = 2
        ex_filling_incomplete      = 3
        ex_zcgc_coligada_not_found = 4
        ex_dir_fiscais_error       = 5
        OTHERS                     = 6.

    IF sy-subrc <> 0.
      MESSAGE ls_return-message TYPE 'E'.
    ENDIF.

    IF ls_return IS NOT INITIAL.
      MESSAGE ls_return-message TYPE 'E'.
    ENDIF.

    LOOP AT lt_cond INTO ls_cond
                   WHERE cond_type EQ gc_cond-bx23 OR
                         cond_type EQ gc_cond-bx41 OR
                         cond_type EQ gc_cond-bx4a.
      ADD ls_cond-condvalue TO lv_condvalue.
    ENDLOOP.

  ENDIF.

  LOOP AT lt_nf_item_sa INTO ls_nf_item.
    "saída
    lv_tabix = sy-tabix.

    CLEAR: ls_nf_item_tax,
           ls_dir_fiscais.

    READ TABLE lt_dir_fiscais INTO ls_dir_fiscais WITH KEY itm_number = ls_nf_item-itmnum.
    IF sy-subrc IS INITIAL.
      ls_nf_item-taxlw1 = ls_dir_fiscais-taxlw1.
      ls_nf_item-taxsit = ls_dir_fiscais-taxsit_icms.

      ls_nf_item-taxlw2 = ls_dir_fiscais-taxlw2.
      ls_nf_item-taxsi2 = ls_dir_fiscais-taxsitout_ipi.

      ls_nf_item-taxlw5 = ls_dir_fiscais-taxlw5.
      ls_nf_item-taxsi5 = ls_dir_fiscais-taxsitout_pis.

      ls_nf_item-taxlw4 = ls_dir_fiscais-taxlw4.
      ls_nf_item-taxsi4 = ls_dir_fiscais-taxsitout_cof.
    ENDIF.

    "ICMI
    PERFORM f_get_condition_to_field TABLES lt_cond
                                            et_return
                                   USING    gc_cond-icmi
                                            ls_nf_item-itmnum
                                            gc_rate
                                            ls_nf_item-menge
                                   CHANGING ls_nf_item-netpr.

    ls_nf_item-netwr = ls_nf_item-netpr * ls_nf_item-menge.
    MODIFY lt_nf_item_sa FROM ls_nf_item INDEX lv_tabix.
    CLEAR lv_tabix2.
    READ TABLE lt_nf_item_add_sa INTO ls_nf_item_add WITH KEY itmnum = ls_nf_item-itmnum.
    lv_tabix2 = sy-tabix.
    ls_nf_item_add-nfpri  = ls_nf_item-netpr.
    ls_nf_item_add-nfnet  = ls_nf_item-netwr.
    ls_nf_item_add-netwrt = ls_nf_item-netwr.
    ls_nf_item_add-nfnett = ls_nf_item-netwr.

    PERFORM f_get_condition_to_field TABLES   lt_cond
    et_return
                                   USING    gc_cond-ists ls_nf_item-itmnum gc_rate ls_nf_item-menge
                                   CHANGING ls_nf_item_add-p_mvast.

    MODIFY lt_nf_item_add_sa FROM ls_nf_item_add INDEX lv_tabix2.

    "ICMS
    ls_nf_item_tax-taxtyp = gc_taxtyp-icm3.
    ls_nf_item_tax-itmnum = ls_nf_item-itmnum.
    PERFORM f_get_condition_to_field TABLES lt_cond
                                          et_return
                                    USING:
                                          gc_cond-bx10
                                          ls_nf_item-itmnum
                                          gc_value
                                          ls_nf_item-menge
                                 CHANGING ls_nf_item_tax-base,
                                          gc_cond-bx16
                                          ls_nf_item-itmnum
                                          gc_rate
                                          ls_nf_item-menge
                                 CHANGING ls_nf_item_tax-rate,
                                          gc_cond-bx13
                                          ls_nf_item-itmnum
                                          gc_value
                                          ls_nf_item-menge
                                 CHANGING ls_nf_item_tax-taxval,
                                          gc_cond-bx11
                                          ls_nf_item-itmnum
                                          gc_value
                                          ls_nf_item-menge
                                 CHANGING ls_nf_item_tax-excbas,
                                          gc_cond-bx12
                                          ls_nf_item-itmnum
                                          gc_value
                                          ls_nf_item-menge
                                 CHANGING ls_nf_item_tax-othbas,
                                          gc_cond-icbs
                                          ls_nf_item-itmnum
                                          gc_rate
                                          ls_nf_item-menge
                                 CHANGING ls_nf_item_tax-basered1.

    PERFORM f_clear_rate_if_no_base CHANGING ls_nf_item_tax.

    APPEND ls_nf_item_tax TO lt_nf_item_tax_sa.

    PERFORM f_get_condition_to_field TABLES lt_cond et_return
                                   USING: gc_cond-bx41
                                          ls_nf_item-itmnum
                                          gc_value
                                          ls_nf_item-menge
                                 CHANGING lv_test_value.

    IF lv_test_value IS NOT INITIAL.

      CLEAR: ls_nf_item_tax.
      ls_nf_item_tax-taxtyp = gc_taxtyp-ics3.
      ls_nf_item_tax-itmnum = ls_nf_item-itmnum.
      PERFORM f_get_condition_to_field TABLES lt_cond
                                            et_return
                                     USING:
                                            gc_cond-bx40
                                            ls_nf_item-itmnum
                                            gc_value
                                            ls_nf_item-menge
                                   CHANGING ls_nf_item_tax-base,
                                            gc_cond-bx16
                                            ls_nf_item-itmnum
                                            gc_rate
                                            ls_nf_item-menge
                                   CHANGING ls_nf_item_tax-rate,
                                            gc_cond-bx41
                                            ls_nf_item-itmnum
                                            gc_value
                                            ls_nf_item-menge
                                   CHANGING ls_nf_item_tax-taxval,
                                            gc_cond-bx42
                                            ls_nf_item-itmnum
                                            gc_value
                                            ls_nf_item-menge
                                   CHANGING ls_nf_item_tax-excbas,
                                            gc_cond-bx43
                                            ls_nf_item-itmnum
                                            gc_value
                                            ls_nf_item-menge
                                   CHANGING ls_nf_item_tax-othbas,
                                            gc_cond-ists
                                            ls_nf_item-itmnum
                                            gc_rate
                                            ls_nf_item-menge
                                   CHANGING ls_nf_item_tax-basered1.

      PERFORM f_clear_rate_if_no_base CHANGING ls_nf_item_tax.

      APPEND ls_nf_item_tax TO lt_nf_item_tax_sa.
    ENDIF.
    "IPI
    CLEAR: ls_nf_item_tax.
    ls_nf_item_tax-taxtyp = gc_taxtyp-ipi3.
    ls_nf_item_tax-itmnum = ls_nf_item-itmnum.
    PERFORM f_get_condition_to_field TABLES lt_cond
                                          et_return
                                   USING:
                                          gc_cond-bx20
                                          ls_nf_item-itmnum
                                          gc_value
                                          ls_nf_item-menge
                                 CHANGING ls_nf_item_tax-base,
                                          gc_cond-ipva
                                          ls_nf_item-itmnum
                                          gc_rate
                                          ls_nf_item-menge
                                 CHANGING ls_nf_item_tax-rate,
                                          gc_cond-bx23
                                          ls_nf_item-itmnum
                                          gc_value
                                          ls_nf_item-menge
                                 CHANGING ls_nf_item_tax-taxval,
                                          gc_cond-bx21
                                          ls_nf_item-itmnum
                                          gc_value
                                          ls_nf_item-menge
                                 CHANGING ls_nf_item_tax-excbas,
                                          gc_cond-bx22
                                          ls_nf_item-itmnum
                                          gc_value
                                          ls_nf_item-menge
                                 CHANGING ls_nf_item_tax-othbas,
                                          gc_cond-ipbs
                                          ls_nf_item-itmnum
                                          gc_rate
                                          ls_nf_item-menge
                                 CHANGING ls_nf_item_tax-basered1.

    PERFORM f_clear_rate_if_no_base CHANGING ls_nf_item_tax.

    APPEND ls_nf_item_tax TO lt_nf_item_tax_sa.

    "COFINS
    CLEAR: ls_nf_item_tax.
    ls_nf_item_tax-taxtyp = gc_taxtyp-icon.
    ls_nf_item_tax-itmnum = ls_nf_item-itmnum.
    PERFORM f_get_condition_to_field TABLES lt_cond et_return
                                    USING:
                                          gc_cond-bx70
                                          ls_nf_item-itmnum
                                          gc_value
                                          ls_nf_item-menge
                                 CHANGING ls_nf_item_tax-base,
                                          gc_cond-bco1
                                          ls_nf_item-itmnum
                                          gc_rate
                                          ls_nf_item-menge
                                 CHANGING ls_nf_item_tax-rate,
                                          gc_cond-bx72
                                          ls_nf_item-itmnum
                                          gc_value
                                          ls_nf_item-menge
                                 CHANGING ls_nf_item_tax-taxval,
                                          gc_cond-bx71
                                          ls_nf_item-itmnum
                                          gc_value
                                          ls_nf_item-menge
                                 CHANGING ls_nf_item_tax-excbas,
                                          gc_cond-bco2
                                          ls_nf_item-itmnum
                                          gc_rate
                                          ls_nf_item-menge
                                 CHANGING ls_nf_item_tax-basered1.

    PERFORM f_clear_rate_if_no_base CHANGING ls_nf_item_tax.

    APPEND ls_nf_item_tax TO lt_nf_item_tax_sa.

    "PIS
    CLEAR: ls_nf_item_tax.
    ls_nf_item_tax-taxtyp = gc_taxtyp-ipsn.
    ls_nf_item_tax-itmnum = ls_nf_item-itmnum.
    PERFORM f_get_condition_to_field TABLES lt_cond
                                          et_return
                                   USING:
                                          gc_cond-bx80
                                          ls_nf_item-itmnum
                                          gc_value
                                          ls_nf_item-menge
                                 CHANGING ls_nf_item_tax-base,
                                          gc_cond-bpi1
                                          ls_nf_item-itmnum
                                          gc_rate
                                          ls_nf_item-menge
                                 CHANGING ls_nf_item_tax-rate,
                                          gc_cond-bx82
                                          ls_nf_item-itmnum
                                          gc_value
                                          ls_nf_item-menge
                                 CHANGING ls_nf_item_tax-taxval,
                                          gc_cond-bx81
                                          ls_nf_item-itmnum
                                          gc_value
                                          ls_nf_item-menge
                                 CHANGING ls_nf_item_tax-excbas,
                                          gc_cond-bpi2
                                          ls_nf_item-itmnum
                                          gc_rate
                                          ls_nf_item-menge
                                 CHANGING ls_nf_item_tax-basered1.

    PERFORM f_clear_rate_if_no_base CHANGING ls_nf_item_tax.

    APPEND ls_nf_item_tax TO lt_nf_item_tax_sa.

    ls_nf_item_tax-taxtyp = gc_taxtyp-icsc.
    ls_nf_item_tax-itmnum = ls_nf_item-itmnum.
    PERFORM f_get_condition_to_field TABLES lt_cond
                                          et_return
                                   USING:
                                          gc_cond-bx9m
                                          ls_nf_item-itmnum
                                          gc_value
                                          ls_nf_item-menge
                                 CHANGING ls_nf_item_tax-base,
                                          gc_cond-isfr
                                          ls_nf_item-itmnum
                                          gc_rate
                                          ls_nf_item-menge
                                 CHANGING ls_nf_item_tax-rate,
                                          gc_cond-bx9i
                                          ls_nf_item-itmnum
                                          gc_value
                                          ls_nf_item-menge
                                 CHANGING ls_nf_item_tax-taxval,
                                          gc_cond-bx9l
                                          ls_nf_item-itmnum
                                          gc_value
                                          ls_nf_item-menge
                                 CHANGING ls_nf_item_tax-excbas,
                                          gc_cond-isfb
                                          ls_nf_item-itmnum
                                          gc_rate
                                          ls_nf_item-menge
                                 CHANGING ls_nf_item_tax-basered1.

    IF ls_nf_item_tax-taxval IS INITIAL.
      CLEAR: ls_nf_item_tax.
    ELSE.
      PERFORM f_clear_rate_if_no_base CHANGING ls_nf_item_tax.
      APPEND ls_nf_item_tax TO lt_nf_item_tax_sa.
    ENDIF.

    "ICFP.
    ls_nf_item_tax-taxtyp = gc_taxtyp-icfp.
    ls_nf_item_tax-itmnum = ls_nf_item-itmnum.
    PERFORM f_get_condition_to_field TABLES lt_cond
                                          et_return
                                   USING:
                                          gc_cond-bx4b
                                          ls_nf_item-itmnum
                                          gc_value
                                          ls_nf_item-menge
                                 CHANGING ls_nf_item_tax-base,
                                          gc_cond-bx4c
                                          ls_nf_item-itmnum
                                          gc_rate
                                          ls_nf_item-menge
                                 CHANGING ls_nf_item_tax-rate,
                                          gc_cond-bx4a
                                          ls_nf_item-itmnum
                                          gc_value
                                          ls_nf_item-menge
                                 CHANGING ls_nf_item_tax-taxval.


    IF ls_nf_item_tax-taxval IS INITIAL.

      CLEAR: ls_nf_item_tax.

    ELSE.

      APPEND ls_nf_item_tax TO lt_nf_item_tax_sa.

    ENDIF.

  ENDLOOP.

  REFRESH: lt_cond, lt_dir_fiscais.

  CLEAR:   ls_return.

  IF lt_mseg_en IS NOT INITIAL.
    CALL FUNCTION 'ZFMM_BAPI_SO_SIMULATE'
      EXPORTING
        it_mkpf                    = lt_mkpf
        it_mseg                    = lt_mseg_sa
        it_cond                    = lt_cond
        it_dirf                    = lt_dir_fiscais
      IMPORTING
        ev_bapireturn              = ls_return
        et_dirf                    = lt_dir_fiscais
      EXCEPTIONS
        ex_mkpf_not_filled         = 1
        ex_mseg_not_filled         = 2
        ex_filling_incomplete      = 3
        ex_zcgc_coligada_not_found = 4
        ex_dir_fiscais_error       = 5
        OTHERS                     = 6.

    IF sy-subrc <> 0.
      MESSAGE ls_return-message TYPE 'E'.
    ENDIF.

    IF ls_return IS NOT INITIAL.
      MESSAGE ls_return-message TYPE 'E'.
    ENDIF.

    LOOP AT lt_cond INTO ls_cond WHERE cond_type EQ gc_cond-bx23 OR
                                       cond_type EQ gc_cond-bx41 OR
                                       cond_type EQ gc_cond-bx4A.
      ADD ls_cond-condvalue TO lv_condvalue.
    ENDLOOP.

  ENDIF.

  LOOP AT lt_nf_item_en INTO ls_nf_item.
    "entrada
    lv_tabix = sy-tabix.

    CLEAR: ls_nf_item_tax, ls_dir_fiscais, ls_zsdtdirfiscais.

    READ TABLE lt_zsdtdirfiscais INTO ls_zsdtdirfiscais WITH KEY shipfrom = ls_t001w-regio
                                                                 direcao  = |1|
                                                                 cfop     = ls_nf_item-cfop_10.
    IF sy-subrc IS INITIAL.

      ls_nf_item-taxlw1 = ls_zsdtdirfiscais-taxlw1.

      SELECT SINGLE taxsit INTO ls_nf_item-taxsit FROM j_1batl1 WHERE taxlaw = ls_zsdtdirfiscais-taxlw1.

      ls_nf_item-taxlw2 = ls_zsdtdirfiscais-taxlw2.

      SELECT SINGLE taxsit INTO ls_nf_item-taxsi2 FROM j_1batl2 WHERE taxlaw = ls_zsdtdirfiscais-taxlw2.

      ls_nf_item-taxlw5 = ls_zsdtdirfiscais-taxlw5.

      SELECT SINGLE taxsit INTO ls_nf_item-taxsi5 FROM j_1batl5 WHERE taxlaw = ls_zsdtdirfiscais-taxlw5.

      ls_nf_item-taxlw4 = ls_zsdtdirfiscais-taxlw4.

      SELECT SINGLE taxsit INTO ls_nf_item-taxsi4 FROM j_1batl4a WHERE taxlaw = ls_zsdtdirfiscais-taxlw4.

    ENDIF.

    "ICMI
    PERFORM f_get_condition_to_field TABLES lt_cond
                                          et_return
                                    USING gc_cond-icmi
                                          ls_nf_item-itmnum
                                          gc_rate
                                          ls_nf_item-menge
                                 CHANGING ls_nf_item-netpr.

    ls_nf_item-netwr = ls_nf_item-netpr * ls_nf_item-menge.

    MODIFY lt_nf_item_en FROM ls_nf_item INDEX lv_tabix.

    READ TABLE lt_nf_item_add_en INTO ls_nf_item_add WITH KEY itmnum = ls_nf_item-itmnum.

    ls_nf_item_add-nfpri  = ls_nf_item-netpr.
    ls_nf_item_add-nfnet  = ls_nf_item-netwr.
    ls_nf_item_add-netwrt = ls_nf_item-netwr.
    ls_nf_item_add-nfnett = ls_nf_item-netwr.

    MODIFY lt_nf_item_add_en FROM ls_nf_item_add INDEX sy-tabix.

    "ICMS
    ls_nf_item_tax-taxtyp = gc_taxtyp-icm1.
    ls_nf_item_tax-itmnum = ls_nf_item-itmnum.
    PERFORM f_get_condition_to_field TABLES lt_cond
                                          et_return
                                   USING:
                                          gc_cond-bx10
                                          ls_nf_item-itmnum
                                          gc_value
                                          ls_nf_item-menge
                                 CHANGING ls_nf_item_tax-base,
                                          gc_cond-icva
                                          ls_nf_item-itmnum
                                          gc_rate
                                          ls_nf_item-menge
                                 CHANGING ls_nf_item_tax-rate,
                                          gc_cond-bx13
                                          ls_nf_item-itmnum
                                          gc_value
                                          ls_nf_item-menge
                                 CHANGING ls_nf_item_tax-taxval,
                                          gc_cond-bx11
                                          ls_nf_item-itmnum
                                          gc_value
                                          ls_nf_item-menge
                                 CHANGING ls_nf_item_tax-excbas,
                                          gc_cond-bx12
                                          ls_nf_item-itmnum
                                          gc_value
                                          ls_nf_item-menge
                                 CHANGING ls_nf_item_tax-othbas,
                                          gc_cond-icbs
                                          ls_nf_item-itmnum
                                          gc_rate
                                          ls_nf_item-menge
                                 CHANGING ls_nf_item_tax-basered1.

    PERFORM f_clear_rate_if_no_base CHANGING ls_nf_item_tax.

    APPEND ls_nf_item_tax TO lt_nf_item_tax_en.

    "IPI
    CLEAR: ls_nf_item_tax.
    ls_nf_item_tax-taxtyp = gc_taxtyp-ipi1.
    ls_nf_item_tax-itmnum = ls_nf_item-itmnum.
    PERFORM f_get_condition_to_field TABLES lt_cond
                                          et_return
                                   USING:
                                          gc_cond-bx20
                                          ls_nf_item-itmnum
                                          gc_value
                                          ls_nf_item-menge
                                 CHANGING ls_nf_item_tax-base,
                                          gc_cond-ipva
                                          ls_nf_item-itmnum
                                          gc_rate
                                          ls_nf_item-menge
                                 CHANGING ls_nf_item_tax-rate,
                                          gc_cond-bx23
                                          ls_nf_item-itmnum
                                          gc_value
                                          ls_nf_item-menge
                                 CHANGING ls_nf_item_tax-taxval,
                                          gc_cond-bx21
                                          ls_nf_item-itmnum
                                          gc_value
                                          ls_nf_item-menge
                                 CHANGING ls_nf_item_tax-excbas,
                                          gc_cond-bx22
                                          ls_nf_item-itmnum
                                          gc_value
                                          ls_nf_item-menge
                                 CHANGING ls_nf_item_tax-othbas,
                                          gc_cond-ipbs
                                          ls_nf_item-itmnum
                                          gc_rate
                                          ls_nf_item-menge
                                 CHANGING ls_nf_item_tax-basered1.

    PERFORM f_clear_rate_if_no_base CHANGING ls_nf_item_tax.

    APPEND ls_nf_item_tax TO lt_nf_item_tax_en.

    "COFINS
    CLEAR: ls_nf_item_tax.
    ls_nf_item_tax-taxtyp = gc_taxtyp-icon.
    ls_nf_item_tax-itmnum = ls_nf_item-itmnum.
    PERFORM f_get_condition_to_field TABLES lt_cond
                                          et_return
                                   USING:
                                          gc_cond-bx70
                                          ls_nf_item-itmnum
                                          gc_value
                                          ls_nf_item-menge
                                 CHANGING ls_nf_item_tax-base,
                                          gc_cond-bco1
                                          ls_nf_item-itmnum
                                          gc_rate
                                          ls_nf_item-menge
                                 CHANGING ls_nf_item_tax-rate,
                                          gc_cond-bx72
                                          ls_nf_item-itmnum
                                          gc_value
                                          ls_nf_item-menge
                                 CHANGING ls_nf_item_tax-taxval,
                                          gc_cond-bx71
                                          ls_nf_item-itmnum
                                          gc_value
                                          ls_nf_item-menge
                                 CHANGING ls_nf_item_tax-excbas,
                                          gc_cond-bco2
                                          ls_nf_item-itmnum
                                          gc_rate
                                          ls_nf_item-menge
                                 CHANGING ls_nf_item_tax-basered1.

    PERFORM f_clear_rate_if_no_base CHANGING ls_nf_item_tax.

    APPEND ls_nf_item_tax TO lt_nf_item_tax_en.

    "PIS
    CLEAR: ls_nf_item_tax.
    ls_nf_item_tax-taxtyp = gc_taxtyp-ipsn.
    ls_nf_item_tax-itmnum = ls_nf_item-itmnum.
    PERFORM f_get_condition_to_field TABLES lt_cond
                                          et_return
                                   USING:
                                          gc_cond-bx80
                                          ls_nf_item-itmnum
                                          gc_value
                                          ls_nf_item-menge
                                 CHANGING ls_nf_item_tax-base,
                                          gc_cond-bpi1
                                          ls_nf_item-itmnum
                                          gc_rate
                                          ls_nf_item-menge
                                 CHANGING ls_nf_item_tax-rate,
                                          gc_cond-bx82
                                          ls_nf_item-itmnum
                                          gc_value
                                          ls_nf_item-menge
                                 CHANGING ls_nf_item_tax-taxval,
                                          gc_cond-bx81
                                          ls_nf_item-itmnum
                                          gc_value
                                          ls_nf_item-menge
                                 CHANGING ls_nf_item_tax-excbas,
                                          gc_cond-bpi2
                                          ls_nf_item-itmnum
                                          gc_rate
                                          ls_nf_item-menge
                                 CHANGING ls_nf_item_tax-basered1.

    PERFORM f_clear_rate_if_no_base CHANGING ls_nf_item_tax.

    APPEND ls_nf_item_tax TO lt_nf_item_tax_en.

  ENDLOOP.

**********************************************************************
*** PARCEIRO:
  IF NOT lt_nf_item_en IS INITIAL.
    ls_nf_partner-parvw  =  lv_parvw_en.
    ls_nf_partner-parid  =  lv_parid_en.
    ls_nf_partner-partyp =  lv_partyp_en.
    APPEND ls_nf_partner TO lt_nf_partner_en.
  ENDIF.

  IF NOT lt_nf_item_sa IS INITIAL.
    ls_nf_partner-parvw  =  lv_parvw_sa.
    ls_nf_partner-parid  =  lv_parid_sa.
    ls_nf_partner-partyp =  lv_partyp_sa.
    APPEND ls_nf_partner TO lt_nf_partner_sa.
  ENDIF.

**********************************************************************
*** HEADER:

  IF NOT lt_nf_item_en IS INITIAL.
    READ TABLE lt_mseg INTO ls_mseg INDEX 1.
    SELECT SINGLE j_1bbranch FROM t001w INTO ls_nf_header_en-branch
      WHERE werks EQ ls_mseg-werks.

    SELECT SINGLE series FROM j_1bb2 INTO ls_nf_header_en-series
      WHERE bukrs EQ ls_mseg-bukrs
      AND   branch EQ ls_nf_header_en-branch
      AND   form   EQ lv_form_en.

    ls_nf_header_en-ntgew  = lv_ntgew_en.
    ls_nf_header_en-brgew  = lv_brgew_en.
    ls_nf_header_en-bukrs  = ls_mseg-bukrs.
    ls_nf_header_en-nftype = lv_nftype_en.
    ls_nf_header_en-parvw  = lv_parvw_en.
    ls_nf_header_en-parid  = lv_parid_en.
    ls_nf_header_en-partyp = lv_partyp_en.
    ls_nf_header_en-docdat = sy-datum.
    ls_nf_header_en-pstdat = sy-datum.
    ls_nf_header_en-model  = lv_model_en.
    ls_nf_header_en-form   = lv_form_en.
    ls_nf_header_en-doctyp = lv_doctyp_en.
    ls_nf_header_en-direct = lv_direct_en.
    ls_nf_header_en-waerk  = gc_currency.
    ls_nf_header_en-manual = abap_true.
    ls_nf_header_en-nfe    = abap_true.
    ls_nf_header_en-inco1  = gc_inco1.
    ls_nf_header_en-entrad = abap_true.
  ENDIF.

  IF NOT lt_nf_item_sa IS INITIAL.
    READ TABLE lt_mseg INTO ls_mseg INDEX 1.

    SELECT SINGLE j_1bbranch FROM t001w INTO ls_nf_header_sa-branch
      WHERE werks EQ ls_mseg-werks.

    SELECT SINGLE series FROM j_1bb2 INTO ls_nf_header_sa-series
      WHERE bukrs EQ ls_mseg-bukrs
      AND   branch EQ ls_nf_header_sa-branch
      AND   form   EQ lv_form_sa.

    ls_nf_header_sa-ntgew  = lv_ntgew_sa.
    ls_nf_header_sa-brgew  = lv_brgew_sa.
    ls_nf_header_sa-bukrs  = ls_mseg-bukrs.
    ls_nf_header_sa-nftype = lv_nftype_sa.
    ls_nf_header_sa-parvw  = lv_parvw_sa.
    ls_nf_header_sa-parid  = lv_parid_sa.
    ls_nf_header_sa-partyp = lv_partyp_sa.
    ls_nf_header_sa-docdat = sy-datum.
    ls_nf_header_sa-pstdat = sy-datum.
    ls_nf_header_sa-model  = lv_model_sa.
    ls_nf_header_sa-form   = lv_form_sa.
    ls_nf_header_sa-doctyp = lv_doctyp_sa.
    ls_nf_header_sa-direct = lv_direct_sa.
    ls_nf_header_sa-waerk  = gc_currency.
    ls_nf_header_sa-manual = abap_true.
    ls_nf_header_sa-nfe    = abap_true.
    ls_nf_header_sa-inco1  = gc_inco1   .
  ENDIF.
**********************************************************************

  SORT lt_nf_msg_en BY docnum seqnum.
  DELETE ADJACENT DUPLICATES FROM lt_nf_msg_en COMPARING docnum seqnum.

** Efetua a criação do docto fiscal
  IF NOT lt_nf_item_en IS INITIAL.

** Início - Rafael Ribeiro - LETNIS - Chamado 16520 - 12.abr.2018
    CLEAR: ls_nfe_payment, lt_nfe_payment, ls_nf_item_pay, lv_netwr.


    LOOP AT lt_nf_item_en INTO ls_nf_item_pay.
      lv_netwr = lv_netwr + ls_nf_item_pay-netwr.
    ENDLOOP.

    ADD lv_condvalue TO lv_netwr.

    ls_nfe_payment-docnum     = lv_docnum_en.
    ls_nfe_payment-t_pag      = gc_90.
    ls_nfe_payment-v_pag      = lv_netwr.

    APPEND ls_nfe_payment TO lt_nfe_payment.
** Fim    - Rafael Ribeiro - LETNIS - Chamado 16520 - 12.abr.2018

    CALL FUNCTION 'BAPI_J_1B_NF_CREATEFROMDATA'
      EXPORTING
        obj_header     = ls_nf_header_en
        nfcheck        = lv_nfcheck
      IMPORTING
        e_docnum       = lv_docnum_en
      TABLES
        obj_partner    = lt_nf_partner_en
        obj_item       = lt_nf_item_en
        obj_item_add   = lt_nf_item_add_en
        obj_item_tax   = lt_nf_item_tax_en
        obj_header_msg = lt_nf_msg_en
        obj_refer_msg  = lt_nf_ref
        obj_ot_partner = lt_nf_ot_part
        obj_payment    = lt_nfe_payment
        return         = lt_nf_return_en.

* Se não gerou documento, efetua rollback
    IF lv_docnum_en IS INITIAL.
      CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.
    ELSE.
* Se gerou documento, efetua commit para gravar
      CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
        EXPORTING
          wait = abap_true.
    ENDIF.
  ENDIF.

** Efetua a criação do docto fiscal
  IF NOT lt_nf_item_sa IS INITIAL.

** Início - Rafael Ribeiro - LETNIS - Chamado 16520 - 12.abr.2018
    CLEAR: ls_nfe_payment, lt_nfe_payment, ls_nf_item_pay, lv_netwr.

    LOOP AT lt_nf_item_sa INTO ls_nf_item_pay.
      lv_netwr = lv_netwr + ls_nf_item_pay-netwr.
    ENDLOOP.

    ADD lv_condvalue TO lv_netwr.

    ls_nfe_payment-docnum     = lv_docnum_en.
    ls_nfe_payment-t_pag      = gc_90.
    ls_nfe_payment-v_pag      = lv_netwr.

    APPEND ls_nfe_payment TO lt_nfe_payment.
** Fim    - Rafael Ribeiro - LETNIS - Chamado 16520 - 12.abr.2018

    CALL FUNCTION 'BAPI_J_1B_NF_CREATEFROMDATA'
      EXPORTING
        obj_header     = ls_nf_header_sa
        nfcheck        = lv_nfcheck
      IMPORTING
        e_docnum       = lv_docnum_sa
      TABLES
        obj_partner    = lt_nf_partner_sa
        obj_item       = lt_nf_item_sa
        obj_item_add   = lt_nf_item_add_sa
        obj_item_tax   = lt_nf_item_tax_sa
        obj_header_msg = lt_nf_msg_sa
        obj_refer_msg  = lt_nf_ref
        obj_ot_partner = lt_nf_ot_part
        obj_payment    = lt_nfe_payment  "Rafael Ribeiro - LETNIS - Chamado 16520 - 12.abr.2018
        return         = lt_nf_return_sa.

* Se não gerou documento, efetua rollback
    IF lv_docnum_sa IS INITIAL.
      CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.
    ELSE.
* Se gerou documento, efetua commit para gravar
      CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
        EXPORTING
          wait = abap_true.
    ENDIF.
  ENDIF.
  APPEND LINES OF lt_nf_return_en TO et_return.
  APPEND LINES OF lt_nf_return_sa TO et_return.

  IF iv_main-docnum_entrada IS INITIAL.
    ev_docnum_entrada = lv_docnum_en.
  ENDIF.

  IF iv_main-docnum_saida IS INITIAL.
    ev_docnum_saida   = lv_docnum_sa.
  ENDIF.

ENDFUNCTION.
