FORM f_get_nf_data TABLES lt_stx    TYPE j_1bnfstx_tab
                    USING us_docnum TYPE j_1bdocnum
                 CHANGING cs_doc    TYPE j_1bnfdoc.

  SELECT SINGLE *                             "#EC CI_ALL_FIELDS_NEEDED
    FROM j_1bnfdoc
    INTO cs_doc
   WHERE docnum = us_docnum.

  SELECT *
    FROM j_1bnfstx
    INTO TABLE lt_stx
   WHERE docnum = us_docnum.

ENDFORM.

FORM f_fill_header USING us_doc    TYPE j_1bnfdoc
                CHANGING cs_header TYPE bapiache09.

  CLEAR cs_header.
  cs_header-username   = sy-uname.
  cs_header-header_txt = us_doc-nfenum.
  cs_header-comp_code  = us_doc-bukrs.
  cs_header-doc_date   = us_doc-docdat.
  cs_header-pstng_date = us_doc-pstdat.
  cs_header-doc_type   = gc_blart.
  cs_header-ref_doc_no = us_doc-docnum.  "us_doc-nfenum. "brandao-2018 73624[582608][590747].

ENDFORM.

FORM f_fill_item_data TABLES lt_stx        TYPE j_1bnfstx_tab
                             lt_accountgl  TYPE bapiacgl09_tab
                             lt_curr       TYPE bapiaccr09_tab
                             lt_ext2       STRUCTURE bapiparex
                       USING us_doc        TYPE j_1bnfdoc.

  TYPES: BEGIN OF ty_centro_lucro,
           itmnum TYPE j_1bnflin-itmnum,
           prctr  TYPE marc-prctr,
         END OF ty_centro_lucro.

  DATA: lt_centro_lucro     TYPE HASHED TABLE OF ty_centro_lucro WITH UNIQUE KEY itmnum,
        lt_zalivium_account TYPE TABLE OF ztmm_alivium_acc,
        ls_zalivium_account TYPE ztmm_alivium_acc,
        ls_accountgl        TYPE bapiacgl09,
        ls_stx              TYPE j_1bnfstx,
        ls_curr             TYPE bapiaccr09,
        ls_ext2             TYPE bapiparex,
        lv_kostl            TYPE kostl,
        lv_kokrs            TYPE kokrs,
        lv_werks            TYPE werks_d,
        lv_tabix            TYPE sy-tabix,
        lv_gsber            TYPE gsber.

  FIELD-SYMBOLS: <fs_centro_lucro> LIKE LINE OF lt_centro_lucro.

  CLEAR: lv_kostl,
         lv_kokrs,
         lv_werks.

  SELECT *                                    "#EC CI_ALL_FIELDS_NEEDED
    FROM ztmm_alivium_acc
    INTO TABLE lt_zalivium_account
         WHERE processo EQ gc_processo
           AND bwart    EQ gc_bwart
           AND grupo    NE gc_grupo.

  "Encontra centro de custo com base na empresa
  SELECT SINGLE kostl
           FROM ztmm_alivium_cc
           INTO lv_kostl
          WHERE bukrs = us_doc-bukrs.

  "Encontra Área de Contab. Custos com base na empresa
  SELECT SINGLE kokrs
           FROM tka02
           INTO lv_kokrs
          WHERE bukrs = us_doc-bukrs.

  SELECT SINGLE werks
           FROM j_1bnflin
           INTO lv_werks
          WHERE docnum = us_doc-docnum.

*  SELECT SINGLE gsber INTO lv_gsber
*  FROM zdivisao
*  WHERE burks  = us_doc-bukrs
*  AND   bupla  = us_doc-branch.

  IF NOT lt_stx[] IS INITIAL.

    SELECT j_1bnflin~itmnum, marc~prctr            "#EC CI_NO_TRANSFORM
      FROM j_1bnflin
     INNER JOIN marc
        ON marc~matnr = j_1bnflin~matnr
       AND marc~werks = j_1bnflin~werks
       FOR ALL ENTRIES IN @lt_stx
     WHERE j_1bnflin~docnum = @lt_stx-docnum
       AND j_1bnflin~itmnum = @lt_stx-itmnum
      INTO CORRESPONDING FIELDS OF TABLE @lt_centro_lucro.


  ENDIF.

  LOOP AT lt_stx INTO ls_stx.                      "#EC CI_LOOP_INTO_WA

    LOOP AT lt_zalivium_account INTO ls_zalivium_account WHERE grupo CS ls_stx-taxgrp. "#EC CI_NESTED "#EC CI_LOOP_INTO_WA

      ADD 1 TO lv_tabix.
      CLEAR: ls_curr, ls_accountgl.

      ls_accountgl-itemno_acc   = lv_tabix.
      ls_accountgl-gl_account   = ls_zalivium_account-newko.
      ls_accountgl-item_text    = |VR NF Nº { us_doc-nfenum }|.
      ls_accountgl-doc_type     = gc_blart.
      ls_accountgl-comp_code    = us_doc-bukrs.
      ls_accountgl-plant        = lv_werks.
      ls_accountgl-fisc_year    = sy-datum(4).
      ls_accountgl-pstng_date   = us_doc-pstdat.

      ls_curr-itemno_acc        = lv_tabix.
      ls_curr-currency          = gc_currency.

      ls_curr-amt_doccur = ls_stx-taxval.

      READ TABLE lt_centro_lucro ASSIGNING <fs_centro_lucro> WITH KEY itmnum = ls_stx-itmnum.
      IF sy-subrc EQ 0.
        ls_accountgl-profit_ctr   = <fs_centro_lucro>-prctr.
      ENDIF.
      IF ls_accountgl-gl_account(1) NE |4|.
        ls_curr-amt_doccur        = ( ls_curr-amt_doccur * ( - 1 ) ).
      ENDIF.
      ls_accountgl-bus_area     = lv_gsber.

      IF ls_curr-amt_doccur IS NOT INITIAL.

        APPEND ls_curr TO lt_curr.
        APPEND ls_accountgl TO lt_accountgl.

        CLEAR ls_ext2.

        ls_ext2-structure = gc_s_bus_place. "Revisar com funcionais
        ls_ext2-valuepart1 = ls_accountgl-itemno_acc.
        ls_ext2-valuepart2 = us_doc-branch.

        APPEND ls_ext2 TO lt_ext2.

      ENDIF.
    ENDLOOP.
  ENDLOOP.
ENDFORM.

FORM f_check_ok USING ut_return TYPE bapiret2_tab
             CHANGING cv_ok     TYPE abap_bool.

  READ TABLE ut_return TRANSPORTING NO FIELDS WITH KEY type = CONV #( if_abap_behv_message=>severity-success ) " 'S'
                                                         id = |RW|
                                                     number = |614|.

  IF sy-subrc EQ 0.
    cv_ok = abap_true.
  ENDIF.
ENDFORM.


FORM f_check_acc_doc_needed TABLES lt_stx TYPE j_1bnfstx_tab
                                lt_return TYPE bapiret2_tab
                          CHANGING cv_ok  TYPE abap_bool.

  DATA: ls_stx    LIKE LINE OF lt_stx,
        ls_return TYPE bapiret2.

  CLEAR: cv_ok,
         ls_stx,
         ls_return.

  REFRESH: lt_return.

  "Verifica se existem impostos para serem contabilizados.
  LOOP AT lt_stx INTO ls_stx.                      "#EC CI_LOOP_INTO_WA
    IF ls_stx-taxval IS NOT INITIAL.
      cv_ok = abap_true.
    ENDIF.
  ENDLOOP.

  "Se não existirem impostos para serem contabilizados, preenche mensagem de log.
  IF cv_ok IS INITIAL.
    ls_return-type    = CONV #( if_abap_behv_message=>severity-warning ).
    ls_return-id      = |ZMM_INVENTARIO|.
    ls_return-number  = 016.
    APPEND ls_return TO lt_return.
  ENDIF.

ENDFORM.

FORM f_get_condition_to_field TABLES lt_conditions TYPE crmt_bapicond_t
                                     lt_messages   TYPE bapiret2_tab
                               USING uv_cond_type  TYPE kscha
                                     uv_item_num   TYPE data
                                     uv_req_value  TYPE c
                                     uv_menge      TYPE menge_d
                            CHANGING cv_field      TYPE data.


  DATA: ls_condition LIKE LINE OF lt_conditions.
  READ TABLE lt_conditions INTO ls_condition WITH KEY itm_number = uv_item_num
                                                      cond_type = uv_cond_type.
  IF sy-subrc EQ 0.
    IF uv_req_value = gc_rate.
      IF uv_cond_type NE gc_cond-icmi.
        IF ls_condition-cond_value IS INITIAL
       AND ls_condition-calctypcon EQ gc_condtype-b
       AND ls_condition-condvalue  IS NOT INITIAL.
          ls_condition-condvalue = ls_condition-condvalue / 10.
          MOVE ls_condition-condvalue TO cv_field.
        ELSE.
          MOVE ls_condition-cond_value TO cv_field.
        ENDIF.

      ELSE.
        IF uv_menge = 0.
          cv_field = 0.
        ELSE.
          cv_field = ls_condition-condvalue / uv_menge.
        ENDIF.
      ENDIF.
    ELSE.
      MOVE ls_condition-condvalue TO cv_field.
    ENDIF.
  ELSE.
    IF uv_cond_type NE gc_cond-ists."Condição para MVA não obrigatória

      APPEND VALUE #( type = if_abap_behv_message=>severity-information id = |ZMM_INVENTARIO| number = 017 message_v1 = uv_cond_type ) TO lt_messages.

    ENDIF.
  ENDIF.
ENDFORM.

FORM f_clear_rate_if_no_base CHANGING cs_item_tax TYPE bapi_j_1bnfstx.

  IF cs_item_tax-basered1 IS INITIAL.
    CLEAR: cs_item_tax-rate.
  ENDIF.

ENDFORM.

FORM f_bapiso_header_partner TABLES lt_partner TYPE esales_bapipartnr_tab
                                  lt_mkpf    TYPE ty_t_mkpf
                                  lt_mseg    TYPE ty_t_mseg
                            USING us_zcgc_coligada TYPE ztmm_cgccoligada
                                  us_t001w TYPE t001w
                         CHANGING cs_header  TYPE bapisdhead.

  READ  TABLE lt_mkpf ASSIGNING FIELD-SYMBOL(<fs_mkpf>) INDEX 1.
  IF sy-subrc NE 0.
    RAISE ex_mkpf_not_filled.
  ENDIF.

  READ TABLE lt_mseg ASSIGNING FIELD-SYMBOL(<fs_mseg>) INDEX 1.
  IF sy-subrc NE 0.
    RAISE ex_mseg_not_filled.
  ENDIF.

  CLEAR cs_header.
  IF <fs_mseg>-shkzg EQ 'S'.
    READ TABLE gt_zalivium_params INTO gs_zalivium_params WITH KEY name = 'AUART_ENTRADA'.
    IF sy-subrc = 0.
      cs_header-doc_type    = gs_zalivium_params-value.
    ENDIF.
  ELSE.
    READ TABLE gt_zalivium_params INTO gs_zalivium_params WITH KEY name = 'AUART_SAIDA'.
    IF sy-subrc = 0.
      cs_header-doc_type    = gs_zalivium_params-value.
    ENDIF.
  ENDIF.

  cs_header-sales_org   = us_t001w-vkorg.

  READ TABLE gt_zalivium_params INTO gs_zalivium_params WITH KEY name = 'VTWEG'.
  IF sy-subrc = 0.
    cs_header-distr_chan  = gs_zalivium_params-value.
  ENDIF.

  READ TABLE gt_zalivium_params INTO gs_zalivium_params WITH KEY name = 'SPART'.
  IF sy-subrc = 0.
    cs_header-division    = gs_zalivium_params-value.
  ENDIF.

  cs_header-req_date_h  = sy-datum.
  cs_header-purch_date  = sy-datum.

  READ TABLE gt_zalivium_params INTO gs_zalivium_params WITH KEY name = 'INCO1'.
  IF sy-subrc = 0.
    cs_header-incoterms1  = gs_zalivium_params-value.
  ENDIF.

  READ TABLE gt_zalivium_params INTO gs_zalivium_params WITH KEY name = 'INCO2'.
  IF sy-subrc = 0.
    cs_header-incoterms2  = gs_zalivium_params-value.
  ENDIF.

  READ TABLE gt_zalivium_params INTO gs_zalivium_params WITH KEY name = 'DZTERM'.
  IF sy-subrc = 0.
    cs_header-pmnttrms    = gs_zalivium_params-value.
  ENDIF.

  cs_header-price_date  = sy-datum.

  READ TABLE gt_zalivium_params INTO gs_zalivium_params WITH KEY name = 'VBTYP'.
  IF sy-subrc = 0.
    cs_header-sd_doc_cat  = gs_zalivium_params-value.
  ENDIF.

  APPEND INITIAL LINE TO lt_partner ASSIGNING FIELD-SYMBOL(<fs_partner>).
  READ TABLE gt_zalivium_params INTO gs_zalivium_params WITH KEY name = 'PARVW'.
  IF sy-subrc = 0.
    <fs_partner>-partn_role   =  gs_zalivium_params-value.
  ENDIF.
  <fs_partner>-partn_numb  =   us_zcgc_coligada-col_ci.

ENDFORM.

FORM f_bapiso_item_sched TABLES lt_item      TYPE bapiitemin_tt
                                lt_schedline TYPE cmp_t_schdl
                                lt_mseg      TYPE ty_t_mseg.

  DATA: lv_itm_number TYPE i.

  LOOP AT lt_mseg ASSIGNING FIELD-SYMBOL(<fs_mseg>).
    APPEND INITIAL LINE TO lt_item ASSIGNING FIELD-SYMBOL(<fs_item>).
    ADD 10 TO lv_itm_number.
    <fs_item>-itm_number   =  lv_itm_number.
    <fs_item>-material     = <fs_mseg>-matnr.
    <fs_item>-bill_date     = sy-datum.
    <fs_item>-plant        =  <fs_mseg>-werks.
    <fs_item>-target_qty    = <fs_mseg>-menge.
    <fs_item>-req_qty       = <fs_mseg>-menge.
    <fs_item>-sales_unit    = <fs_mseg>-meins.
    <fs_item>-store_loc     = <fs_mseg>-lgort.
    <fs_item>-req_date      = sy-datum.

    READ TABLE gt_zalivium_params INTO gs_zalivium_params WITH KEY name = 'KSCHA'.
    IF sy-subrc = 0.
      <fs_item>-cond_type    =  gs_zalivium_params-value.
    ENDIF.
    <fs_item>-cond_value   =  <fs_mseg>-dmbtr.
    <fs_item>-currency     =  <fs_mseg>-waers.

    READ TABLE gt_zalivium_params INTO gs_zalivium_params WITH KEY name = 'INCO1'.
    IF sy-subrc = 0.
      <fs_item>-incoterms1   =  gs_zalivium_params-value.
    ENDIF.

    READ TABLE gt_zalivium_params INTO gs_zalivium_params WITH KEY name = 'INCO2'.
    IF sy-subrc = 0.
      <fs_item>-incoterms2   =  gs_zalivium_params-value.
    ENDIF.

    APPEND INITIAL LINE TO lt_schedline ASSIGNING FIELD-SYMBOL(<fs_schedline>).
    <fs_schedline>-itm_number    =  lv_itm_number.
    <fs_schedline>-sched_line    =  sy-tabix.
    <fs_schedline>-req_qty       =  <fs_mseg>-menge .



  ENDLOOP.
ENDFORM.

FORM f_check_filling TABLES lt_item      TYPE bapiitemin_tt
                            lt_partner   TYPE esales_bapipartnr_tab
                            lt_schedline TYPE cmp_t_schdl
                      USING us_header    TYPE bapisdhead.

  IF lt_item[] IS INITIAL OR lt_partner[] IS INITIAL OR
     lt_schedline[] IS INITIAL OR us_header IS INITIAL.
    RAISE ex_filling_incomplete.
  ENDIF.
ENDFORM.

FORM f_get_tax_laws TABLES lt_items_out   TYPE esales_bapiitemex_tab
                           lt_mseg        TYPE ty_t_mseg
                           lt_partner     TYPE esales_bapipartnr_tab
                           lt_dir_fiscais STRUCTURE ztmm_dirfiscais
                     USING us_ls_header   TYPE bapisdhead
                           us_ls_t001w    TYPE t001w.

  "Declaração de Tipos
  TYPES: BEGIN OF ty_mbew,
           matnr TYPE mbew-matnr,
           bwkey TYPE mbew-bwkey,
           bwtar TYPE mbew-bwtar,
           mtuse TYPE mbew-mtuse,
           mtorg TYPE mbew-mtorg,
         END OF ty_mbew.

  TYPES: BEGIN OF ty_dica,
           auart TYPE j_1bsdica-auart,
           pstyv TYPE j_1bsdica-pstyv,
           txsdc TYPE j_1bsdica-txsdc,
         END OF ty_dica.

  TYPES: BEGIN OF ty_taxsit_icms,
           taxlaw TYPE j_1batl1-taxlaw,
           taxsit TYPE j_1batl1-taxsit,
         END OF ty_taxsit_icms.

  TYPES: BEGIN OF ty_taxsit_ipi,
           taxlaw    TYPE j_1batl2-taxlaw,
           taxsit    TYPE j_1batl2-taxsit,
           taxsitout TYPE j_1batl2-taxsitout,
         END OF ty_taxsit_ipi.

  TYPES: BEGIN OF ty_taxsit_pis,
           taxlaw    TYPE j_1batl5-taxlaw,
           taxsit    TYPE j_1batl5-taxsit,
           taxsitout TYPE j_1batl5-taxsitout,
         END OF ty_taxsit_pis.

  TYPES: BEGIN OF ty_taxsit_cof,
           taxlaw    TYPE j_1batl4a-taxlaw,
           taxsit    TYPE j_1batl4a-taxsit,
           taxsitout TYPE j_1batl4a-taxsitout,
         END OF ty_taxsit_cof.

  "Declaração de variaveis, estruturas e tabelas
  DATA: ls_items_out   TYPE bapiitemex,
        ls_partner     TYPE bapipartnr,
        ls_mseg        TYPE mseg,
        lt_mbew        TYPE TABLE OF ty_mbew,
        ls_mbew        LIKE LINE OF lt_mbew,
        lt_dica        TYPE TABLE OF ty_dica,
        ls_dica        LIKE LINE OF lt_dica,
        ls_dir_fiscais TYPE zsmm_alivium_dirfiscais,
        lt_vbpa        TYPE TABLE OF vbpa.

  DATA: lv_kalvg  TYPE tvak-kalvg,
        lv_kalsm  TYPE t683v-kalsm,
        lv_taxlw1 TYPE j_1bsdica-taxlw1,
        lv_taxlw2 TYPE j_1bsdica-taxlw2,
        lv_taxlw3 TYPE j_1btaxlw3,
        lv_taxlw4 TYPE j_1btaxlw4,
        lv_taxlw5 TYPE j_1btaxlw5.

  DATA: lv_tabix       TYPE sy-tabix,
        lt_taxsit_icms TYPE TABLE OF ty_taxsit_icms,
        ls_taxsit_icms LIKE LINE OF lt_taxsit_icms,
        lt_taxsit_ipi  TYPE TABLE OF ty_taxsit_ipi,
        ls_taxsit_ipi  LIKE LINE OF lt_taxsit_ipi,
        lt_taxsit_pis  TYPE TABLE OF ty_taxsit_pis,
        ls_taxsit_pis  LIKE LINE OF lt_taxsit_pis,
        lt_taxsit_cof  TYPE TABLE OF ty_taxsit_cof,
        ls_taxsit_cof  LIKE LINE OF lt_taxsit_cof.

  "Limpeza de variaveis, estruturas e tabelas
  CLEAR: ls_items_out,
         ls_mseg,
         ls_partner,
         ls_dica,
         lv_kalvg,
         lv_kalsm,
         ls_dir_fiscais,
         lv_tabix.

  REFRESH: lt_mbew,
           lt_dica,
           lt_vbpa.

  REFRESH:  lt_taxsit_icms,
            lt_taxsit_ipi,
            lt_taxsit_pis,
            lt_taxsit_cof.

  "Coletor de dados anterior a determinação das leis fiscais por item
  IF lt_mseg[] IS NOT INITIAL.

    SELECT matnr bwkey bwtar mtuse mtorg
      FROM mbew
      INTO CORRESPONDING FIELDS OF TABLE lt_mbew
       FOR ALL ENTRIES IN lt_mseg
     WHERE matnr = lt_mseg-matnr
       AND bwkey = lt_mseg-werks.

  ENDIF.

  SELECT auart pstyv txsdc
    FROM j_1bsdica
    INTO CORRESPONDING FIELDS OF TABLE lt_dica
   WHERE auart = us_ls_header-doc_type.

  SELECT SINGLE kalvg
    FROM tvak
    INTO lv_kalvg
   WHERE auart = us_ls_header-doc_type.

  IF lv_kalvg IS NOT INITIAL.
    SELECT SINGLE kalsm
      FROM t683v
      INTO lv_kalsm
     WHERE vkorg = us_ls_header-sales_org
       AND vtweg = us_ls_header-distr_chan
       AND spart = us_ls_header-division
       AND kalvg = lv_kalvg.
  ENDIF.

  READ TABLE lt_partner INTO ls_partner INDEX 1.

  "Determinação das leis fiscais por item
  LOOP AT lt_items_out INTO ls_items_out.            "#EC CI_SEL_NESTED

    CLEAR: ls_mseg,
           ls_mbew,
           ls_dica,
           lv_taxlw1,
           lv_taxlw2,
           lv_taxlw3,
           lv_taxlw4,
           lv_taxlw5.

    READ TABLE lt_mseg INTO ls_mseg INDEX sy-tabix.

    CHECK sy-subrc IS INITIAL.

    READ TABLE lt_mbew INTO ls_mbew WITH KEY matnr = ls_items_out-material
                                             bwkey = ls_items_out-plant
                                             bwtar = ls_mseg-charg.

    IF sy-subrc IS NOT INITIAL.
      READ TABLE lt_mbew INTO ls_mbew WITH KEY matnr = ls_items_out-material
                                               bwkey = ls_items_out-plant.
    ENDIF.

    READ TABLE lt_dica INTO ls_dica WITH KEY auart = us_ls_header-doc_type
                                             pstyv = ls_items_out-item_categ.

    CHECK sy-subrc IS INITIAL.

    CALL FUNCTION 'J_1B_SD_TAXLAW'
      EXPORTING
        ordertype          = us_ls_header-doc_type
        itemcategory       = ls_items_out-item_categ
        plant              = ls_items_out-plant
        company            = ls_mseg-bukrs
        branch             = us_ls_t001w-j_1bbranch
        customer           = ls_partner-partn_numb
        material           = COND #( WHEN ls_items_out-material_long IS INITIAL THEN CONV matnr( ls_items_out-material ) ELSE ls_items_out-material_long )
        material_group     = ls_items_out-matl_group
        material_usage     = ls_mbew-mtuse
        material_orig      = ls_mbew-mtorg
        mwskz              = ls_dica-txsdc
        date               = sy-datum
        txjcd_wk           = us_ls_t001w-txjcd
        kalsm              = lv_kalsm
      IMPORTING
        taxlw1             = lv_taxlw1
        taxlw2             = lv_taxlw2
        taxlw3             = lv_taxlw3
        taxlw4             = lv_taxlw4
        taxlw5             = lv_taxlw5
      TABLES
        t_vbpa             = lt_vbpa
      EXCEPTIONS
        customer_not_found = 1                " Customer not found
        company_not_found  = 2                " Company Code not found
        branch_not_found   = 3                " Branch not found
        OTHERS             = 4.

    IF sy-subrc IS INITIAL.
      CLEAR: ls_dir_fiscais.
      ls_dir_fiscais-itm_number  = ls_items_out-itm_number.
      ls_dir_fiscais-taxlw1      = lv_taxlw1.
      ls_dir_fiscais-taxlw2      = lv_taxlw2.
      ls_dir_fiscais-taxlw3      = lv_taxlw3.
      ls_dir_fiscais-taxlw4      = lv_taxlw4.
      ls_dir_fiscais-taxlw5      = lv_taxlw5.
      APPEND ls_dir_fiscais TO lt_dir_fiscais.
    ENDIF.

  ENDLOOP.

  IF lt_dir_fiscais[] IS INITIAL.
    RAISE ex_dir_fiscais_error.
  ENDIF.

  SELECT taxlaw taxsit
    FROM j_1batl1
    INTO TABLE lt_taxsit_icms
    FOR ALL ENTRIES IN lt_dir_fiscais
    WHERE taxlaw = lt_dir_fiscais-taxlw1.

  SELECT taxlaw taxsit taxsitout
    FROM j_1batl2
    INTO TABLE lt_taxsit_ipi
    FOR ALL ENTRIES IN lt_dir_fiscais
    WHERE taxlaw = lt_dir_fiscais-taxlw2.

  SELECT taxlaw taxsit taxsitout
    FROM j_1batl5
    INTO TABLE lt_taxsit_pis
    FOR ALL ENTRIES IN lt_dir_fiscais
    WHERE taxlaw = lt_dir_fiscais-taxlw5.

  SELECT taxlaw taxsit taxsitout
     FROM j_1batl4a
     INTO TABLE lt_taxsit_cof
     FOR ALL ENTRIES IN lt_dir_fiscais
     WHERE taxlaw = lt_dir_fiscais-taxlw4.

  IF lt_taxsit_icms[] IS INITIAL OR
     lt_taxsit_ipi[]  IS INITIAL OR
     lt_taxsit_pis[]  IS INITIAL OR
     lt_taxsit_cof[]  IS INITIAL.
    RAISE ex_dir_fiscais_error.
  ENDIF.

  CLEAR: ls_dir_fiscais.

  LOOP AT lt_dir_fiscais INTO ls_dir_fiscais.

    lv_tabix = sy-tabix.

    CLEAR: ls_taxsit_icms.
    READ TABLE lt_taxsit_icms INTO ls_taxsit_icms WITH KEY taxlaw = ls_dir_fiscais-taxlw1.
    IF sy-subrc IS INITIAL.
      ls_dir_fiscais-taxsit_icms = ls_taxsit_icms-taxsit.
    ENDIF.

    CLEAR: ls_taxsit_ipi.
    READ TABLE lt_taxsit_ipi  INTO ls_taxsit_ipi WITH KEY taxlaw = ls_dir_fiscais-taxlw2.
    IF sy-subrc IS INITIAL.
      ls_dir_fiscais-taxsitin_ipi   = ls_taxsit_ipi-taxsit.
      ls_dir_fiscais-taxsitout_ipi  = ls_taxsit_ipi-taxsitout.
    ENDIF.

    CLEAR: ls_taxsit_pis.
    READ TABLE lt_taxsit_pis  INTO ls_taxsit_pis WITH KEY taxlaw = ls_dir_fiscais-taxlw5.
    IF sy-subrc IS INITIAL.
      ls_dir_fiscais-taxsitin_pis   = ls_taxsit_pis-taxsit.
      ls_dir_fiscais-taxsitout_pis  = ls_taxsit_pis-taxsitout.
    ENDIF.

    CLEAR: ls_taxsit_cof.
    READ TABLE lt_taxsit_cof  INTO ls_taxsit_cof WITH KEY taxlaw = ls_dir_fiscais-taxlw4.
    IF sy-subrc IS INITIAL.
      ls_dir_fiscais-taxsitin_cof   = ls_taxsit_cof-taxsit.
      ls_dir_fiscais-taxsitout_cof  = ls_taxsit_cof-taxsitout.
    ENDIF.

    MODIFY lt_dir_fiscais FROM ls_dir_fiscais INDEX lv_tabix.

    CLEAR: ls_dir_fiscais,
           lv_tabix.

  ENDLOOP.

ENDFORM.
FORM f_get_tax_law TABLES lt_item        TYPE esales_bapiitemin_tab
                          lt_partner     TYPE esales_bapipartnr_tab
                          lt_schedline   TYPE vlc_bapischdl_t
                          lt_dir_fiscais TYPE zctgmm_alivium_dirfiscais
                          lt_cond        TYPE crmt_bapicond_t
                    USING us_ls_header   TYPE bapisdhead.

  DATA: lv_tabix       TYPE sy-tabix,
        lt_taxsit_icms TYPE TABLE OF j_1batl1,
        lt_taxsit_ipi  TYPE TABLE OF j_1batl2,
        lt_taxsit_cof  TYPE TABLE OF j_1batl4a,
        lt_taxsit_pis  TYPE TABLE OF j_1batl5,
        lt_dir_fisc    TYPE STANDARD TABLE OF zsmm_alivium_dirfiscais,
        ls_dir_fiscais TYPE zsmm_alivium_dirfiscais.


  DATA: ls_sales_header_in     TYPE bapisdhd1,
        ls_sales_header_inx    TYPE bapisdhd1x,
        ls_sales_items_in      TYPE STANDARD TABLE OF bapisditm,
        ls_sales_items_inx     TYPE STANDARD TABLE OF bapisditmx,
        ls_sales_partners      TYPE STANDARD TABLE OF bapiparnr,
        ls_sales_schedules_in  TYPE STANDARD TABLE OF bapischdl,
        ls_sales_schedules_inx TYPE STANDARD TABLE OF bapischdlx,
        lt_items_ex            TYPE STANDARD TABLE OF bapisdit,
        lt_conditions_ex       TYPE STANDARD TABLE OF bapicond,
        lt_return              TYPE STANDARD TABLE OF bapiret2.

  ls_sales_header_in = CORRESPONDING #( us_ls_header ).
  ls_sales_items_in     = CORRESPONDING #( lt_item[] ).
  ls_sales_partners     = CORRESPONDING #( lt_partner[] ).
  ls_sales_schedules_in = CORRESPONDING #( lt_schedline[] ).

  ls_sales_items_inx = VALUE #( FOR ls_item_x IN ls_sales_items_in ( itm_number = ls_item_x-itm_number
                                                               material   =  abap_true
                                                               bill_date  =  abap_true
                                                               plant      =  abap_true
                                                               store_loc  =  abap_true
                                                               target_qty =  abap_true
                                                               target_qu  =  abap_true
                                                               sales_unit =  abap_true
                                                               incoterms1 =  abap_true
                                                               incoterms2 =  abap_true
                                                               t_unit_iso =  abap_true ) ).

  ls_sales_schedules_inx = VALUE #( FOR ls_schedules_inx IN ls_sales_schedules_in ( itm_number = ls_schedules_inx-itm_number
                                                                                    sched_line = ls_schedules_inx-sched_line
                                                                                    req_qty    = abap_true ) ).

  CALL FUNCTION 'SD_SALESDOCUMENT_CREATE'
    EXPORTING
      sales_header_in       = ls_sales_header_in
      sales_header_inx      = ls_sales_header_inx
      testrun               = abap_true
      status_buffer_refresh = abap_true
    TABLES
      return                = lt_return
      sales_items_in        = ls_sales_items_in
      sales_items_inx       = ls_sales_items_inx
      sales_partners        = ls_sales_partners
      sales_schedules_in    = ls_sales_schedules_in
      sales_schedules_inx   = ls_sales_schedules_inx
      items_ex              = lt_items_ex
      conditions_ex         = lt_cond.

  READ TABLE lt_return WITH KEY type = 'E' TRANSPORTING NO FIELDS.

  CHECK NOT sy-subrc IS INITIAL.

  LOOP AT lt_items_ex INTO DATA(ls_items_ex).

    ls_dir_fiscais-itm_number  = ls_items_ex-itm_number.
    ls_dir_fiscais-taxlw1  = ls_items_ex-taxlawicms.
    ls_dir_fiscais-taxlw2  = ls_items_ex-taxlawipi.
    ls_dir_fiscais-taxlw3  = ls_items_ex-taxlawiss.
    ls_dir_fiscais-taxlw4  = ls_items_ex-taxlawcofins.
    ls_dir_fiscais-taxlw5  = ls_items_ex-taxlawpis .
    APPEND ls_dir_fiscais TO lt_dir_fiscais.
    CLEAR ls_dir_fiscais.

  ENDLOOP.

  CHECK NOT lt_dir_fiscais IS INITIAL.

  SELECT *
    FROM j_1batl1
    INTO TABLE lt_taxsit_icms
     FOR ALL ENTRIES IN lt_dir_fiscais
   WHERE taxlaw = lt_dir_fiscais-taxlw1.

  SELECT *
    FROM j_1batl2
    INTO TABLE lt_taxsit_ipi
     FOR ALL ENTRIES IN lt_dir_fiscais
   WHERE taxlaw = lt_dir_fiscais-taxlw2.

  SELECT *
    FROM j_1batl5
    INTO TABLE lt_taxsit_pis
     FOR ALL ENTRIES IN lt_dir_fiscais
   WHERE taxlaw = lt_dir_fiscais-taxlw5.

  SELECT *
    FROM j_1batl4a
    INTO TABLE lt_taxsit_cof
     FOR ALL ENTRIES IN lt_dir_fiscais
   WHERE taxlaw = lt_dir_fiscais-taxlw4.

  LOOP AT lt_dir_fiscais INTO ls_dir_fiscais.

    lv_tabix = sy-tabix.

    READ TABLE lt_taxsit_icms INTO DATA(ls_taxsit_icms) WITH KEY taxlaw = ls_dir_fiscais-taxlw1.
    IF sy-subrc IS INITIAL.
      ls_dir_fiscais-taxsit_icms = ls_taxsit_icms-taxsit.
    ENDIF.

    READ TABLE lt_taxsit_ipi  INTO DATA(ls_taxsit_ipi) WITH KEY taxlaw = ls_dir_fiscais-taxlw2.
    IF sy-subrc IS INITIAL.
      ls_dir_fiscais-taxsitin_ipi   = ls_taxsit_ipi-taxsit.
      ls_dir_fiscais-taxsitout_ipi  = ls_taxsit_ipi-taxsitout.
    ENDIF.

    READ TABLE lt_taxsit_pis  INTO DATA(ls_taxsit_pis) WITH KEY taxlaw = ls_dir_fiscais-taxlw5.
    IF sy-subrc IS INITIAL.
      ls_dir_fiscais-taxsitin_pis   = ls_taxsit_pis-taxsit.
      ls_dir_fiscais-taxsitout_pis  = ls_taxsit_pis-taxsitout.
    ENDIF.

    READ TABLE lt_taxsit_cof  INTO DATA(ls_taxsit_cof) WITH KEY taxlaw = ls_dir_fiscais-taxlw4.
    IF sy-subrc IS INITIAL.
      ls_dir_fiscais-taxsitin_cof   = ls_taxsit_cof-taxsit.
      ls_dir_fiscais-taxsitout_cof  = ls_taxsit_cof-taxsitout.
    ENDIF.

    MODIFY lt_dir_fiscais FROM ls_dir_fiscais INDEX lv_tabix.

    CLEAR: ls_dir_fiscais, lv_tabix, ls_taxsit_icms, ls_taxsit_ipi, ls_taxsit_pis, ls_taxsit_cof.

  ENDLOOP.

ENDFORM.
