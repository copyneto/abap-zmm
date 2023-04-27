CLASS zclmm_gerar_nf_inventario DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    TYPES: BEGIN OF ty_param,
             chave3 TYPE ze_param_chave_3,
             low    TYPE ze_param_low,
             high   TYPE ze_param_high,
           END OF ty_param.

    TYPES: ty_bapicond_t   TYPE STANDARD TABLE OF bapicond,
           ty_mkpf         TYPE STANDARD TABLE OF mkpf,
           ty_mseg         TYPE STANDARD TABLE OF mseg,
           ty_fiscal       TYPE STANDARD TABLE OF zsmm_alv_r002_di,
           ty_bapipartnr_t TYPE STANDARD TABLE OF bapipartnr,
           ty_bapiitemin_t TYPE STANDARD TABLE OF bapiitemin,
           ty_bapischdl_t  TYPE STANDARD TABLE OF bapischdl,
           ty_j_1bnfstx_t  TYPE STANDARD TABLE OF j_1bnfstx,
           ty_bapiacgl09_t TYPE STANDARD TABLE OF bapiacgl09,
           ty_bapiaccr09_t TYPE STANDARD TABLE OF bapiaccr09,
           ty_bapirex      TYPE STANDARD TABLE OF  bapiparex,
           ty_para         TYPE STANDARD TABLE OF ty_param.

    DATA:               gt_param TYPE ty_para.

    METHODS:
      get_condition_to_field
        IMPORTING
          iv_taxtyp     TYPE j_1btaxtyp OPTIONAL
          iv_cond_type  TYPE kscha
          iv_item_num   TYPE data
          iv_req_value  TYPE c
          iv_menge      TYPE menge_d
          it_conditions TYPE ty_bapicond_t
        CHANGING
          cv_field      TYPE data,

      simulate
        IMPORTING
          it_mkpf    TYPE ty_mkpf
          it_mseg    TYPE ty_mseg
        EXPORTING
          et_return  TYPE bapiret2_tab
        CHANGING
          ct_fiscais TYPE ty_fiscal
          ct_cond    TYPE ty_bapicond_t,

      gerar_contab
        IMPORTING
          iv_docnum TYPE j_1bdocnum,

      save_log
        IMPORTING
          it_return TYPE bapiret2_tab
          is_log    TYPE bal_s_log .

  PROTECTED SECTION.
  PRIVATE SECTION.

    CONSTANTS : gc_objeto    TYPE balobj_d VALUE 'ZMM_INVENT_FIS',
                gc_subobjeto TYPE balsubobj VALUE 'SAIDA'.

    METHODS: partner
      IMPORTING
        it_mkpf    TYPE ty_mkpf
        it_mseg    TYPE ty_mseg
        iv_cliente TYPE kunnr
        iv_t001w   TYPE t001w
      CHANGING
        ct_partner TYPE ty_bapipartnr_t
        cs_header  TYPE bapisdhead,

      schedule
        IMPORTING
          it_mseg  TYPE ty_mseg
        CHANGING
          ct_item  TYPE ty_bapiitemin_t
          ct_sched TYPE ty_bapischdl_t,

      check_filling
        IMPORTING
          it_item      TYPE ty_bapiitemin_t
          it_partner   TYPE ty_bapipartnr_t
          it_schedline TYPE ty_bapischdl_t
          is_header    TYPE bapisdhead ,

      get_tax_law
        IMPORTING
          it_item        TYPE esales_bapiitemin_tab
          it_partner     TYPE esales_bapipartnr_tab
          it_schedline   TYPE vlc_bapischdl_t
          is_header      TYPE bapisdhead
        EXPORTING
          et_return      TYPE bapiret2_tab
        CHANGING
          ct_cond        TYPE crmt_bapicond_t
          ct_dir_fiscais TYPE ty_fiscal,

      get_nf_data
        IMPORTING
          iv_docnum TYPE j_1bdocnum
        CHANGING
          cs_doc    TYPE j_1bnfdoc
          ct_stx    TYPE ty_j_1bnfstx_t,

      fill_header
        IMPORTING
          is_doc    TYPE j_1bnfdoc
        CHANGING
          cs_header TYPE bapiache09,

      fill_item_data
        IMPORTING
          it_stx       TYPE ty_j_1bnfstx_t
          is_doc       TYPE j_1bnfdoc
        CHANGING
          ct_accountgl TYPE ty_bapiacgl09_t
          ct_curr      TYPE ty_bapiaccr09_t
          ct_ext2      TYPE ty_bapirex,
      get_costcenter
        IMPORTING
          VALUE(is_cc) TYPE bapiacgl09
        RETURNING
          VALUE(rv_cc) TYPE kostl.

ENDCLASS.



CLASS zclmm_gerar_nf_inventario IMPLEMENTATION.


  METHOD get_condition_to_field.

    CONSTANTS: lc_b    TYPE c LENGTH 01 VALUE 'B',
               lc_rate TYPE c VALUE 'R'.

    DATA(ls_condition) = VALUE #( it_conditions[ itm_number = iv_item_num
                                                  cond_type = iv_cond_type ] OPTIONAL ).
    IF sy-subrc EQ 0.

      IF iv_req_value = lc_rate.
        IF iv_cond_type NE 'ZICM'.
          IF ls_condition-cond_value IS INITIAL AND
             ls_condition-calctypcon EQ lc_b    AND
             ls_condition-condvalue  IS NOT INITIAL.
            ls_condition-condvalue = ls_condition-condvalue / 10.
            MOVE ls_condition-condvalue TO cv_field.
          ELSE.
            IF  iv_cond_type EQ 'BX23'
            AND iv_taxtyp    EQ 'IPI3'.
              MOVE ls_condition-condvalue TO cv_field.
            ELSE.
              MOVE ls_condition-cond_value TO cv_field.
            ENDIF.
          ENDIF.

        ELSE.
          IF iv_menge = 0.
            cv_field = 0.
          ELSE.
            cv_field = ls_condition-condvalue / iv_menge.
          ENDIF.
        ENDIF.

      ELSE.
        MOVE ls_condition-condvalue TO cv_field.
      ENDIF.

*      IF iv_cond_type NE 'BX10'   AND
*          ( iv_taxtyp EQ 'ICON'   OR
*            iv_taxtyp EQ 'IPSN' ) AND
*            cv_field  EQ 0.
*
*        ls_condition = VALUE #( it_conditions[ itm_number = iv_item_num
*                                                cond_type = COND #( WHEN iv_taxtyp EQ 'ICON' THEN 'BX70' ELSE 'BX80' ) ] OPTIONAL ).
*
*        IF sy-subrc EQ 0.
*          cv_field = ls_condition-condvalue.
*        ENDIF.
*
*      ENDIF.

    ENDIF.

  ENDMETHOD.


  METHOD simulate.

    DATA: ls_header       TYPE bapisdhead,
          lt_item         TYPE TABLE OF bapiitemin,
          lt_items_out    TYPE TABLE OF bapiitemex,
          lt_partner      TYPE TABLE OF bapipartnr,
          lt_schedline    TYPE TABLE OF bapischdl,
          ls_bapireturn   TYPE bapireturn,
          lv_cliente      TYPE kunnr,
          ls_t001w        TYPE t001w,
          lt_cond         TYPE TABLE OF bapicond,
          lt_dir_fiscais  TYPE TABLE OF zsmm_alv_r002_di,
          lt_dir_fiscais2 TYPE TABLE OF zsmm_alv_r002_di.

    CLEAR: lt_items_out.

    READ TABLE it_mseg ASSIGNING FIELD-SYMBOL(<fs_mseg>) INDEX 1.
    IF <fs_mseg> IS ASSIGNED.

      SELECT SINGLE * FROM t001w
        INTO ls_t001w
       WHERE werks = <fs_mseg>-werks.

      SELECT SINGLE col_ci FROM ztmm_coligada
        INTO lv_cliente
       WHERE bukrs = <fs_mseg>-bukrs
         AND bupla = ls_t001w-j_1bbranch.

      IF sy-subrc NE 0.
        RETURN.
      ENDIF.
    ENDIF.

    SELECT chave3,
           low,
           high
      FROM ztca_param_val
     WHERE modulo EQ 'MM'
       AND chave1 EQ 'INVENTARIO'
       AND chave2 IN ( 'DOCUMENTO' , 'SAPLZFG_ALIVIUM' )
      INTO TABLE @gt_param.

    me->partner(
        EXPORTING
            iv_cliente  = lv_cliente
            it_mkpf     = it_mkpf
            it_mseg     = it_mseg
            iv_t001w    = ls_t001w
        CHANGING
           ct_partner  = lt_partner
            cs_header   = ls_header
     ).

    me->schedule(
    EXPORTING
        it_mseg = it_mseg
    CHANGING
        ct_item = lt_item
        ct_sched = lt_schedline ).

    me->check_filling(
    EXPORTING
        is_header    = ls_header
        it_item      = lt_item
        it_partner   = lt_partner
        it_schedline = lt_schedline ).

    me->get_tax_law(
         EXPORTING
             it_item        = lt_item
             it_partner     = lt_partner
             it_schedline   = lt_schedline
             is_header      = ls_header
         IMPORTING
             et_return = et_return
         CHANGING
             ct_cond        = ct_cond
             ct_dir_fiscais = lt_dir_fiscais ).

    IF lt_dir_fiscais[] IS NOT INITIAL.
      ct_fiscais[] = lt_dir_fiscais.
    ENDIF.

  ENDMETHOD.


  METHOD partner.

    READ  TABLE it_mkpf ASSIGNING FIELD-SYMBOL(<fs_mkpf>) INDEX 1.
    IF sy-subrc NE 0.
      RETURN.
    ENDIF.

    READ  TABLE it_mseg ASSIGNING FIELD-SYMBOL(<fs_mseg>) INDEX 1.
    IF sy-subrc NE 0.
      RETURN.
    ENDIF.

    CLEAR cs_header.
*    IF <fs_mseg>-shkzg EQ 'S'.
*      READ TABLE gt_param INTO DATA(ls_zalivium_params) WITH KEY chave3 = 'ENTRADA'.
*      IF sy-subrc = 0.
*        cs_header-doc_type    = ls_zalivium_params-low.
*      ENDIF.
*    ELSE.
    READ TABLE gt_param INTO DATA(ls_zalivium_params) WITH KEY chave3 = 'SAIDA'.
    IF sy-subrc = 0.
      cs_header-doc_type    = ls_zalivium_params-low.
    ENDIF.
*    ENDIF.

    cs_header-sales_org   =  iv_t001w-vkorg.

    READ TABLE gt_param INTO ls_zalivium_params WITH KEY chave3 = 'VTWEG'.
    IF sy-subrc = 0.
      cs_header-distr_chan  = ls_zalivium_params-low.
    ENDIF.

    READ TABLE gt_param INTO ls_zalivium_params WITH KEY chave3 = 'SPART'.
    IF sy-subrc = 0.
      cs_header-division    = ls_zalivium_params-low.
    ENDIF.

    cs_header-req_date_h  = sy-datum.
    cs_header-purch_date  = sy-datum.

    READ TABLE gt_param INTO ls_zalivium_params WITH KEY chave3 = 'INCO1'.
    IF sy-subrc = 0.
      cs_header-incoterms1  = ls_zalivium_params-low.
    ENDIF.

    READ TABLE gt_param INTO ls_zalivium_params WITH KEY chave3 = 'INCO2'.
    IF sy-subrc = 0.
      cs_header-incoterms2  = ls_zalivium_params-low.
    ENDIF.

    READ TABLE gt_param INTO ls_zalivium_params WITH KEY chave3 = 'DZTERM'.
    IF sy-subrc = 0.
      cs_header-pmnttrms    = ls_zalivium_params-low.
    ENDIF.

    cs_header-price_date  = sy-datum.
    cs_header-division = '99'.

    READ TABLE gt_param INTO ls_zalivium_params WITH KEY chave3 = 'VBTYP'.
    IF sy-subrc = 0.
      cs_header-sd_doc_cat  = ls_zalivium_params-low.
    ENDIF.

    APPEND INITIAL LINE TO ct_partner ASSIGNING FIELD-SYMBOL(<fs_partner>).
    READ TABLE gt_param INTO ls_zalivium_params WITH KEY chave3 = 'PARVW'.
    IF sy-subrc = 0.
      <fs_partner>-partn_role   =  ls_zalivium_params-low.
    ENDIF.
    <fs_partner>-partn_numb  =    iv_cliente.

  ENDMETHOD.


  METHOD schedule.

    DATA: lv_itm_number TYPE i.

    LOOP AT it_mseg ASSIGNING FIELD-SYMBOL(<fs_mseg>).

      APPEND INITIAL LINE TO ct_item ASSIGNING FIELD-SYMBOL(<fs_item>).
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

      READ TABLE gt_param INTO DATA(ls_zalivium_params) WITH KEY chave3 = 'KSCHA'.
      IF sy-subrc = 0.
        <fs_item>-cond_type    =  ls_zalivium_params-low.
      ENDIF.
      <fs_item>-cond_value   =  <fs_mseg>-dmbtr.
      <fs_item>-currency     =  <fs_mseg>-waers.

      READ TABLE gt_param INTO ls_zalivium_params WITH KEY chave3 = 'INCO1'.
      IF sy-subrc = 0.
        <fs_item>-incoterms1   =  ls_zalivium_params-low.
      ENDIF.

      READ TABLE gt_param INTO ls_zalivium_params WITH KEY chave3 = 'INCO2'.
      IF sy-subrc = 0.
        <fs_item>-incoterms2   =  ls_zalivium_params-low.
      ENDIF.

      APPEND INITIAL LINE TO ct_sched  ASSIGNING FIELD-SYMBOL(<fs_schedline>).
      <fs_schedline>-itm_number    =  lv_itm_number.
      <fs_schedline>-sched_line    =  sy-tabix.
      <fs_schedline>-req_qty       =  <fs_mseg>-menge .

    ENDLOOP.

  ENDMETHOD.


  METHOD check_filling.

    IF it_item[] IS INITIAL OR it_partner[] IS INITIAL OR
       it_schedline[] IS INITIAL OR is_header IS INITIAL.
      RETURN.
    ENDIF.

  ENDMETHOD.


  METHOD get_tax_law.

    DATA: lv_tabix       TYPE sy-tabix,
          lt_taxsit_icms TYPE TABLE OF j_1batl1,
          lt_taxsit_ipi  TYPE TABLE OF j_1batl2,
          lt_taxsit_cof  TYPE TABLE OF j_1batl4a,
          lt_taxsit_pis  TYPE TABLE OF j_1batl5,
          lt_dir_fisc    TYPE ty_fiscal,
          ls_dir_fiscais TYPE zsmm_alv_r002_di.


    DATA: ls_sales_header_in     TYPE bapisdhd1,
          ls_sales_header_inx    TYPE bapisdhd1x,
          lt_sales_items_in      TYPE STANDARD TABLE OF bapisditm,
          lt_sales_items_inx     TYPE STANDARD TABLE OF bapisditmx,
          lt_sales_partners      TYPE STANDARD TABLE OF bapiparnr,
          lt_sales_schedules_in  TYPE STANDARD TABLE OF bapischdl,
          lt_sales_schedules_inx TYPE STANDARD TABLE OF bapischdlx,
          lt_items_ex            TYPE STANDARD TABLE OF bapisdit,
          lt_return              TYPE STANDARD TABLE OF bapiret2.

    ls_sales_header_in    = CORRESPONDING #( is_header ).
    lt_sales_items_in     = CORRESPONDING #( it_item[] ).
    lt_sales_partners     = CORRESPONDING #( it_partner[] ).
    lt_sales_schedules_in = CORRESPONDING #( it_schedline[] ).

    lt_sales_items_inx = VALUE #( FOR ls_item_x IN it_item (    itm_number = ls_item_x-itm_number
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

    lt_sales_schedules_inx = VALUE #( FOR ls_schedules_inx IN it_schedline (
                                           itm_number = ls_schedules_inx-itm_number
                                           sched_line = ls_schedules_inx-sched_line
                                           req_qty    = abap_true ) ).

    CALL FUNCTION 'SD_SALESDOCUMENT_CREATE'
      EXPORTING
        sales_header_in       = ls_sales_header_in
*       sales_header_inx      = ls_sales_header_inx
        testrun               = abap_true
        status_buffer_refresh = 'X'
      TABLES
        return                = lt_return
        sales_items_in        = lt_sales_items_in
        sales_items_inx       = lt_sales_items_inx
        sales_partners        = lt_sales_partners
        sales_schedules_in    = lt_sales_schedules_in
        sales_schedules_inx   = lt_sales_schedules_inx
        items_ex              = lt_items_ex
        conditions_ex         = ct_cond.

    IF line_exists( lt_return[ type = 'E' ] ).

      et_return = lt_return.

    ELSE.

      LOOP AT lt_items_ex ASSIGNING FIELD-SYMBOL(<fs_items_ex>).

        ls_dir_fiscais-itm_number  = <fs_items_ex>-itm_number.
        ls_dir_fiscais-taxlw1  = <fs_items_ex>-taxlawicms.
        ls_dir_fiscais-taxlw2  = <fs_items_ex>-taxlawipi.
        ls_dir_fiscais-taxlw3  = <fs_items_ex>-taxlawiss.
        ls_dir_fiscais-taxlw4  = <fs_items_ex>-taxlawcofins.
        ls_dir_fiscais-taxlw5  = <fs_items_ex>-taxlawpis .
        APPEND ls_dir_fiscais TO ct_dir_fiscais .
        CLEAR ls_dir_fiscais.

      ENDLOOP.

      CHECK NOT ct_dir_fiscais IS INITIAL.

      SELECT *
          FROM j_1batl1
          INTO TABLE lt_taxsit_icms
          FOR ALL ENTRIES IN ct_dir_fiscais
          WHERE taxlaw = ct_dir_fiscais-taxlw1.

      SELECT *
        FROM j_1batl2
        INTO TABLE lt_taxsit_ipi
        FOR ALL ENTRIES IN ct_dir_fiscais
        WHERE taxlaw = ct_dir_fiscais-taxlw2.

      SELECT *
        FROM j_1batl5
        INTO TABLE lt_taxsit_pis
        FOR ALL ENTRIES IN ct_dir_fiscais
        WHERE taxlaw = ct_dir_fiscais-taxlw5.

      SELECT *
         FROM j_1batl4a
         INTO TABLE lt_taxsit_cof
         FOR ALL ENTRIES IN ct_dir_fiscais
         WHERE taxlaw = ct_dir_fiscais-taxlw4.

      LOOP AT ct_dir_fiscais ASSIGNING FIELD-SYMBOL(<fs_dir_fiscais>).

        READ TABLE lt_taxsit_icms INTO DATA(ls_taxsit_icms) WITH KEY taxlaw = <fs_dir_fiscais>-taxlw1.
        IF sy-subrc IS INITIAL.
          <fs_dir_fiscais>-taxsit_icms = ls_taxsit_icms-taxsit.
        ENDIF.

        READ TABLE lt_taxsit_ipi  INTO DATA(ls_taxsit_ipi) WITH KEY taxlaw = <fs_dir_fiscais>-taxlw2.
        IF sy-subrc IS INITIAL.
          <fs_dir_fiscais>-taxsitin_ipi   = ls_taxsit_ipi-taxsit.
          <fs_dir_fiscais>-taxsitout_ipi  = ls_taxsit_ipi-taxsitout.
        ENDIF.

        READ TABLE lt_taxsit_pis  INTO DATA(ls_taxsit_pis) WITH KEY taxlaw = <fs_dir_fiscais>-taxlw5.
        IF sy-subrc IS INITIAL.
          <fs_dir_fiscais>-taxsitin_pis   = ls_taxsit_pis-taxsit.
          <fs_dir_fiscais>-taxsitout_pis  = ls_taxsit_pis-taxsitout.
        ENDIF.

        READ TABLE lt_taxsit_cof  INTO DATA(ls_taxsit_cof) WITH KEY taxlaw = <fs_dir_fiscais>-taxlw4.
        IF sy-subrc IS INITIAL.
          <fs_dir_fiscais>-taxsitin_cof   = ls_taxsit_cof-taxsit.
          <fs_dir_fiscais>-taxsitout_cof  = ls_taxsit_cof-taxsitout.
        ENDIF.

        CLEAR: ls_taxsit_icms, ls_taxsit_ipi, ls_taxsit_pis, ls_taxsit_cof.

      ENDLOOP.

    ENDIF.

  ENDMETHOD.


  METHOD gerar_contab.

    DATA: ls_header     TYPE bapiache09,
          lt_accountgl  TYPE TABLE OF bapiacgl09,
          lt_curr       TYPE TABLE OF bapiaccr09,
          lt_return     TYPE TABLE OF bapiret2,
          lt_extension2 TYPE TABLE OF bapiparex,
          ls_return     TYPE bapiret2,
          lv_obj_type   TYPE  awtyp,
          lv_obj_key    TYPE  awkey,
          lv_obj_sys    TYPE  awsys.

    DATA: ls_doc TYPE j_1bnfdoc,
          lt_stx TYPE TABLE OF j_1bnfstx.

    me->get_nf_data(
        EXPORTING
            iv_docnum = iv_docnum
        CHANGING
            cs_doc = ls_doc
            ct_stx    = lt_stx
         ).


    me->fill_header(
        EXPORTING
            is_doc = ls_doc
        CHANGING
            cs_header = ls_header ).

    me->fill_item_data(
        EXPORTING
            is_doc = ls_doc
            it_stx = lt_stx
        CHANGING
            ct_accountgl =  lt_accountgl
            ct_ext2 = lt_extension2
            ct_curr = lt_curr
     ).


    CLEAR: ls_return.

    " Verifica se existem impostos para serem contabilizados.

    CHECK lt_stx IS NOT INITIAL.

    CALL FUNCTION 'BAPI_ACC_DOCUMENT_CHECK'
      EXPORTING
        documentheader = ls_header
      TABLES
        accountgl      = lt_accountgl
        currencyamount = lt_curr
        return         = lt_return
        extension2     = lt_extension2.

    IF NOT line_exists( lt_return[ type = 'E' ] ).

      REFRESH: lt_return.

      CALL FUNCTION 'BAPI_ACC_DOCUMENT_POST'
        EXPORTING
          documentheader = ls_header
        IMPORTING
          obj_type       = lv_obj_type
          obj_key        = lv_obj_key
          obj_sys        = lv_obj_sys
        TABLES
          accountgl      = lt_accountgl
          currencyamount = lt_curr
          return         = lt_return
          extension2     = lt_extension2.

      IF NOT line_exists( lt_return[ type = 'E' ] ).
        CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'.
      ELSE.
        CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.
      ENDIF.
    ENDIF.

    IF lt_return IS NOT INITIAL.

      NEW zclmm_gerar_nf_inventario(  )->save_log(
           EXPORTING
               it_return = lt_return
               is_log    = VALUE bal_s_log(
                          aluser    = sy-uname
                          alprog    = sy-repid
                          object    = gc_objeto
                          subobject = gc_subobjeto
                          extnumber = sy-timlo ) ).

    ENDIF.

  ENDMETHOD.


  METHOD get_nf_data.

    SELECT SINGLE  nfenum, bukrs, docdat, pstdat, docnum, branch FROM j_1bnfdoc
       INTO CORRESPONDING FIELDS OF @cs_doc
      WHERE docnum = @iv_docnum.

    SELECT * FROM j_1bnfstx
      INTO TABLE ct_stx
     WHERE docnum = iv_docnum.

  ENDMETHOD.


  METHOD fill_header.

    CLEAR cs_header.
    cs_header-username   = sy-uname.
    cs_header-header_txt = is_doc-nfenum.
    cs_header-comp_code  = is_doc-bukrs.
    cs_header-doc_date   = is_doc-docdat.
    cs_header-pstng_date = is_doc-pstdat.
    cs_header-doc_type   = 'SA'.
    cs_header-ref_doc_no = is_doc-docnum.

  ENDMETHOD.


  METHOD fill_item_data.

    TYPES: BEGIN OF ty_centro_lucro,
             itmnum TYPE j_1bnflin-itmnum,
             prctr  TYPE marc-prctr,
           END OF ty_centro_lucro.

    DATA: lt_centro_lucro TYPE HASHED TABLE OF ty_centro_lucro WITH UNIQUE KEY itmnum,
          ls_accountgl    TYPE bapiacgl09,
          ls_curr         TYPE bapiaccr09,
          ls_ext2         TYPE bapiparex,
          lv_tabix        TYPE sy-tabix.

    FIELD-SYMBOLS: <fs_centro_lucro> LIKE LINE OF lt_centro_lucro.

    SELECT *
      FROM ztmm_alv_account
      INTO TABLE @DATA(lt_zalivium_account)
           WHERE processo = 'ACABADO'
             AND bwart    = '702'
             AND grupo   NE 'STOCK'.

    "Encontra centro de custo com base na empresa
    SELECT SINGLE kostl
             FROM ztmm_alv_cc
             INTO @DATA(lv_kostl)
            WHERE bukrs = @is_doc-bukrs.

    "Encontra Área de Contab. Custos com base na empresa
    SELECT SINGLE kokrs
             FROM tka02
             INTO @DATA(lv_kokrs)
            WHERE bukrs = @is_doc-bukrs.

    SELECT SINGLE werks
             FROM j_1bnflin
             INTO @DATA(lv_werks)
            WHERE docnum = @is_doc-docnum.

    SELECT SINGLE gsber
             FROM ztmm_divisao
             INTO @DATA(lv_gsber)
    WHERE bukrs  = @is_doc-bukrs
    AND   bupla  = @is_doc-branch.

    IF NOT it_stx[] IS INITIAL.

      SELECT j_1bnflin~itmnum
             marc~prctr
      INTO CORRESPONDING FIELDS OF TABLE lt_centro_lucro
      FROM j_1bnflin
      INNER JOIN marc
      ON  marc~matnr = j_1bnflin~matnr
      AND marc~werks = j_1bnflin~werks
      FOR ALL ENTRIES IN it_stx
      WHERE j_1bnflin~docnum = it_stx-docnum
      AND   j_1bnflin~itmnum = it_stx-itmnum.
    ENDIF.

    LOOP AT it_stx ASSIGNING FIELD-SYMBOL(<fs_stx>).
      LOOP AT lt_zalivium_account ASSIGNING FIELD-SYMBOL(<fs_zalivium_account>).

        IF <fs_zalivium_account>-grupo CS <fs_stx>-taxgrp.
          ADD 1 TO lv_tabix.
          CLEAR: ls_curr, ls_accountgl.

          ls_accountgl-itemno_acc   = lv_tabix.
          ls_accountgl-gl_account   = <fs_zalivium_account>-newko.
          ls_accountgl-item_text    = |VR NF Nº { is_doc-nfenum }|.
          ls_accountgl-doc_type     = 'SA'.
          ls_accountgl-comp_code    = is_doc-bukrs.
          ls_accountgl-plant        = lv_werks.
          ls_accountgl-fisc_year    = sy-datum(4).
          ls_accountgl-pstng_date   = is_doc-pstdat.

          ls_curr-itemno_acc        = lv_tabix.
          ls_curr-currency          = 'BRL'.

          ls_curr-amt_doccur = <fs_stx>-taxval.

          READ TABLE lt_centro_lucro ASSIGNING <fs_centro_lucro> WITH KEY itmnum = <fs_stx>-itmnum.
          IF sy-subrc EQ 0.
            ls_accountgl-profit_ctr   = <fs_centro_lucro>-prctr.
          ENDIF.
          IF ls_accountgl-gl_account(1) NE '4'.
            ls_curr-amt_doccur        = ( ls_curr-amt_doccur * ( - 1 ) ).
          ENDIF.
          ls_accountgl-bus_area     = lv_gsber.

          IF ls_curr-amt_doccur IS NOT INITIAL.

            ls_accountgl-costcenter = get_costcenter( ls_accountgl ).

            APPEND ls_curr TO ct_curr.
            APPEND ls_accountgl TO ct_accountgl.

            CLEAR ls_ext2.
            ls_ext2-structure = 'ZALIVIUMBUS_PLACE'.
            ls_ext2-valuepart1 = ls_accountgl-itemno_acc.
            ls_ext2-valuepart2 = is_doc-branch.
            APPEND ls_ext2 TO ct_ext2.

          ENDIF.
        ENDIF.
      ENDLOOP.
    ENDLOOP.

  ENDMETHOD.


  METHOD save_log.

    CALL FUNCTION 'ZFMCA_LOG_MSG_ADD'
      STARTING NEW TASK 'SAVE_LOG'
      EXPORTING
        is_log  = is_log
        it_msgs = it_return.

  ENDMETHOD.

  METHOD get_costcenter.

    IF is_cc-gl_account(1) EQ '4'.

      SELECT SINGLE kostl  FROM ztco_okb9
       WHERE bukrs   EQ @is_cc-comp_code
        AND  kstar   EQ @is_cc-gl_account
        AND  gsber   EQ @is_cc-bus_area
        AND  prctr   EQ @is_cc-profit_ctr
      INTO @rv_cc.

    ENDIF.

  ENDMETHOD.

ENDCLASS.
