FUNCTION zfmmm_gerar_nf_inventario.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  TABLES
*"      IT_MSEG STRUCTURE  MSEG OPTIONAL
*"      IT_MKPF STRUCTURE  MKPF OPTIONAL
*"----------------------------------------------------------------------
  CONSTANTS : gc_auart_saida   TYPE auart VALUE 'Y081',
              gc_auart_entrada TYPE auart VALUE 'YR81',
              gc_rate          TYPE c VALUE 'R',
              gc_value         TYPE c VALUE 'V',
              gc_base          TYPE c VALUE 'B',
              gc_90            TYPE c LENGTH 2 VALUE '90',
              gc_objeto        TYPE balobj_d VALUE 'ZMM_INVENT_FIS',
              gc_subobjeto_e   TYPE balsubobj VALUE 'ENTRADA',
              gc_subobjeto_s   TYPE balsubobj VALUE 'SAIDA',
              gc_701           TYPE bwart VALUE '701',
              gc_702           TYPE bwart VALUE '702',
              gc_cfop_in       TYPE ztmm_dirfiscais-cfop VALUE '1949%'.

  TYPES: ty_bapicond_t TYPE STANDARD TABLE OF bapicond.

  DATA:
    lt_nf_return        TYPE TABLE OF bapiret2,
    lt_nf_return_sa     TYPE TABLE OF bapiret2,
    lt_return           TYPE bapiret2_tab,
    lt_nf_ot_part       TYPE TABLE OF bapi_j_1bnfcpd,
    lt_nf_ref           TYPE TABLE OF bapi_j_1bnfref,
    lt_nfe_payment      TYPE TABLE OF bapi_j_1bnfe_payment,
    lt_dir_fiscais      TYPE TABLE OF zsmm_alv_r002_di,
    lt_cond             TYPE ty_bapicond_t,
    lt_nf_item_en       TYPE TABLE OF bapi_j_1bnflin,
    lt_nf_item_sa       TYPE TABLE OF bapi_j_1bnflin,
*    ls_nf_item        TYPE bapi_j_1bnflin,
    lv_cfop_en          TYPE j_1bnflin-cfop,
    lv_cfop_sa          TYPE j_1bnflin-cfop,
    lv_incltx           TYPE j_1bnflin-incltx VALUE 'X',
    ls_makt             TYPE makt,
    ls_mara             TYPE mara,
    lv_brgew_en         TYPE j_1bnfdoc-brgew,
    lv_ntgew_en         TYPE j_1bnfdoc-ntgew,
    lv_brgew_sa         TYPE j_1bnfdoc-brgew,
    lv_ntgew_sa         TYPE j_1bnfdoc-ntgew,
    lv_docnum_sa        TYPE j_1bnfdoc-docnum,
    lv_steuc            TYPE steuc,
    ls_nfe_payment      TYPE bapi_j_1bnfe_payment,
    lv_itmnum_en        TYPE j_1bnflin-itmnum,
    lv_itmnum_sa        TYPE j_1bnflin-itmnum,
    lt_nf_item_add_en   TYPE TABLE OF bapi_j_1bnflin_add,
    lt_nf_item_add_sa   TYPE TABLE OF bapi_j_1bnflin_add,
*    ls_nf_item_add    LIKE LINE OF lt_nf_item_add_en,
    lt_nf_msg_en        TYPE TABLE OF bapi_j_1bnfftx,
    lt_nf_msg_sa        TYPE TABLE OF bapi_j_1bnfftx,
    ls_nf_msg           LIKE LINE OF lt_nf_msg_en,
    lt_nf_header        TYPE TABLE OF bapi_j_1bnfdoc,
    ls_nf_header_en     LIKE LINE OF lt_nf_header,
    ls_dir_fiscais      TYPE zsmm_alv_r002_di,
    ls_nf_header_sa     LIKE LINE OF lt_nf_header,
    lt_nf_item_tax_en   TYPE TABLE OF bapi_j_1bnfstx,
    lt_nf_item_tax_sa   TYPE TABLE OF bapi_j_1bnfstx,
    ls_nf_item_tax      LIKE LINE OF lt_nf_item_tax_en,
    lv_test_value       TYPE j_1bbase,
    lt_nf_partner_en    TYPE TABLE OF bapi_j_1bnfnad,
    lt_nf_partner_sa    TYPE TABLE OF bapi_j_1bnfnad,
    ls_nf_partner       LIKE LINE OF lt_nf_partner_sa,
    lv_nftype_en        TYPE j_1bnfdoc-nftype,
    lv_nftype_sa        TYPE j_1bnfdoc-nftype,
    lv_parid_en         TYPE j_1bnfdoc-parid,
    lv_parid_sa         TYPE j_1bnfdoc-parid,
    lv_parvw_en         TYPE j_1bnfdoc-parvw,
    lv_parvw_sa         TYPE j_1bnfdoc-parvw,
    lv_partyp_en        TYPE j_1bnfdoc-partyp,
    lv_partyp_sa        TYPE j_1bnfdoc-partyp,
    lv_direct_en        TYPE j_1bnfdoc-direct,
    lv_nfcheck          TYPE bapi_j_1bnfcheck VALUE 'XX',
    lv_direct_sa        TYPE j_1bnfdoc-direct,
    lv_form_en          TYPE j_1bnfdoc-form,
    lv_form_sa          TYPE j_1bnfdoc-form,
    lv_docnum           TYPE j_1bnfdoc-docnum,
    ls_info_nota_en     TYPE j_1baa,
    lv_netwr            TYPE j_1bnetval,
    ls_info_nota_sa     TYPE j_1baa,
    lv_model_en         TYPE j_1bnfdoc-model,
    lv_model_sa         TYPE j_1bnfdoc-model,
    lv_doctyp_en        TYPE j_1bnfdoc-doctyp,
    lv_doctyp_sa        TYPE j_1bnfdoc-doctyp,
    lv_nftot            TYPE j_1bnfdoc-nftot,
    lv_condvalue        TYPE bapicond-condvalue,
    lv_total_with_taxes TYPE bapicond-condvalue,
    ls_return           TYPE bapireturn.

  CHECK it_mseg IS INITIAL.

  DATA(lt_mseg_resul) = it_mseg[].

  DELETE lt_mseg_resul WHERE bwart NE gc_701
                         AND bwart NE gc_702.

  CHECK lt_mseg_resul IS NOT INITIAL.

  DATA(lt_mseg_en) = lt_mseg_resul[].
  DELETE lt_mseg_en WHERE shkzg EQ 'H'.

  DATA(lt_mseg_sa) = lt_mseg_resul[].
  DELETE lt_mseg_sa WHERE shkzg EQ 'S'.

  SELECT *
      FROM mbew
      INTO TABLE @DATA(lt_mbew)
      FOR ALL ENTRIES IN @lt_mseg_resul
      WHERE matnr = @lt_mseg_resul-matnr
      AND   bwkey = @lt_mseg_resul-werks.

  CHECK lt_mbew IS NOT INITIAL.

  SORT lt_mbew BY matnr bwkey.

  SELECT * FROM mara INTO TABLE @DATA(lt_mara)
      FOR ALL ENTRIES IN @lt_mbew
      WHERE matnr EQ @lt_mbew-matnr.

  CHECK lt_mara IS NOT INITIAL.

  SORT lt_mara BY matnr.

  SELECT * FROM makt INTO TABLE @DATA(lt_makt)
    FOR ALL ENTRIES IN @lt_mara
    WHERE matnr EQ @lt_mara-matnr
    AND   spras EQ @sy-langu.

  SORT lt_makt BY matnr.

  SELECT matnr, werks, steuc FROM marc INTO TABLE @DATA(lt_marc)
    FOR ALL ENTRIES IN @lt_mbew
    WHERE matnr EQ @lt_mbew-matnr
    AND   werks EQ @lt_mbew-bwkey.

  SORT lt_marc BY matnr werks.

  IF sy-subrc EQ 0.

    SELECT a~regio, b~lifnr, b~col_ci, bukrs, werks FROM t001w AS a
    INNER JOIN ztmm_coligada AS b
    ON a~j_1bbranch = b~bupla
    FOR ALL ENTRIES IN @lt_mseg_resul
      WHERE bukrs = @lt_mseg_resul-bukrs
        AND werks = @lt_mseg_resul-werks
      INTO TABLE @DATA(lt_gerais).

  ENDIF.

  SELECT * FROM tvak
    INTO TABLE @DATA(lt_tvak)
   WHERE auart IN ( @gc_auart_saida,
                    @gc_auart_entrada ).

  LOOP AT lt_mseg_resul ASSIGNING FIELD-SYMBOL(<fs_msegx>)
       GROUP BY ( mblnr = <fs_msegx>-mblnr
                  gjahr = <fs_msegx>-gjahr
                  index = GROUP INDEX
                  size  = GROUP SIZE )
                ASSIGNING FIELD-SYMBOL(<fs_group>).

    CLEAR: lt_nf_item_add_sa[],
           lt_nf_item_add_en[],
           lt_nf_item_en[],
           lt_nf_item_sa[],
           lt_cond[],
           lt_dir_fiscais,
           ls_return,
           lv_condvalue.

    LOOP AT GROUP <fs_group> ASSIGNING FIELD-SYMBOL(<fs_msegx_grp>).

      READ TABLE lt_mbew INTO DATA(ls_mbew) WITH KEY matnr = <fs_msegx_grp>-matnr
                                                     bwkey = <fs_msegx_grp>-werks
                                                     BINARY SEARCH.

      CHECK sy-subrc IS INITIAL.

      READ TABLE lt_makt INTO ls_makt WITH KEY matnr = <fs_msegx_grp>-matnr BINARY SEARCH.
      CHECK sy-subrc IS INITIAL.

      READ TABLE lt_mara INTO ls_mara WITH KEY matnr = <fs_msegx_grp>-matnr BINARY SEARCH.

      lv_steuc = VALUE #( lt_marc[ matnr = <fs_msegx_grp>-matnr
                                   werks = <fs_msegx_grp>-werks ]-steuc OPTIONAL ).

      CHECK sy-subrc IS INITIAL.

      DATA(ls_nf_item)  =  VALUE bapi_j_1bnflin(
              matnr     = <fs_msegx_grp>-matnr
              werks     = <fs_msegx_grp>-werks
              menge     = <fs_msegx_grp>-menge
              charg     = <fs_msegx_grp>-charg
              incltx    = lv_incltx
              bwkey     = ls_mbew-bwkey
              meins     = <fs_msegx_grp>-meins
              matorg    = ls_mbew-mtorg
              matuse    = ls_mbew-mtuse
              ownpro    = ls_mbew-ownpr
              netwr     = ( ls_mbew-stprs * <fs_msegx_grp>-menge )
              netpr     = ls_mbew-stprs
              maktx     = ls_makt-maktx
              matkl     = ls_mara-matkl
              nbm       = lv_steuc
              reftyp    = 'MD'
              refkey    = <fs_msegx_grp>-mblnr && <fs_msegx_grp>-mjahr
              refitm    = <fs_msegx_grp>-zeile
              itmtyp    = COND #( WHEN <fs_msegx_grp>-shkzg EQ 'H' THEN '80'
                                  WHEN <fs_msegx_grp>-shkzg EQ 'S' THEN '81' )
              cfop_10   = COND #( WHEN <fs_msegx_grp>-shkzg EQ 'H' THEN '594920'
                                  WHEN <fs_msegx_grp>-shkzg EQ 'S' THEN '194920' )
              itmnum    = ( sy-tabix * 10 ) ).

      IF <fs_msegx_grp>-shkzg EQ 'H'. "saída

        lv_brgew_sa = ( ls_mara-brgew *  ls_nf_item-menge ) + lv_brgew_sa.
        lv_ntgew_sa = ( ls_mara-ntgew *  ls_nf_item-menge ) + lv_ntgew_sa.

        APPEND ls_nf_item TO lt_nf_item_sa.

      ELSEIF <fs_msegx_grp>-shkzg EQ 'S'. "entrada

        lv_brgew_en = ( ls_mara-brgew *  ls_nf_item-menge ) + lv_brgew_en.
        lv_ntgew_en = ( ls_mara-ntgew *  ls_nf_item-menge ) + lv_ntgew_en.

        APPEND ls_nf_item TO lt_nf_item_en.

      ENDIF.

      DATA(ls_nf_item_add)    = VALUE bapi_j_1bnflin_add(
                      itmnum  = ls_nf_item-itmnum
                      nfpri   = ls_nf_item-netpr
                      nfnet   = ls_nf_item-netwr
                      netwrt  = ls_nf_item-netwr
                      nfnett  = ls_nf_item-netwr ).

      IF <fs_msegx_grp>-shkzg EQ 'H' .
        APPEND ls_nf_item_add TO lt_nf_item_add_sa.
      ELSEIF <fs_msegx_grp>-shkzg EQ 'S'.
        APPEND ls_nf_item_add TO lt_nf_item_add_en.
      ENDIF.
    ENDLOOP.

    TRY.
        DATA(ls_gerais) = VALUE #( lt_gerais[ bukrs = <fs_msegx_grp>-bukrs werks = <fs_msegx_grp>-werks ] ).
      CATCH cx_sy_itab_line_not_found.
        lt_nf_return = VALUE #( (
         id = 'ZMM_INVENTARIO'
         number = 020
         type = 'E'
         message_v1 = <fs_msegx_grp>-bukrs
         message_v2 = <fs_msegx_grp>-werks
        ) ).
        NEW zclmm_gerar_nf_inventario(  )->save_log(
             EXPORTING
                 it_return = lt_nf_return[]
                 is_log    = VALUE bal_s_log(
                            aluser    = sy-uname
                            alprog    = sy-repid
                            object    = gc_objeto
                            subobject = COND #( WHEN <fs_msegx_grp>-bwart EQ gc_702 THEN gc_subobjeto_s ELSE gc_subobjeto_e )
                            extnumber = sy-timlo ) ).
        RETURN.
    ENDTRY.


    IF NOT lt_nf_item_en IS INITIAL.

      SELECT * FROM ztmm_dirfiscais
        INTO TABLE @DATA(lt_zsdtdirfiscais)
        "FOR ALL ENTRIES IN @lt_nf_item_en
        WHERE shipfrom = @ls_gerais-regio
        AND   direcao  = '1'
        AND   cfop     LIKE @gc_cfop_in
        AND   ativo    = @space.

    ENDIF.

    IF <fs_msegx_grp>-bwart = gc_702.

      "CONFIGURAÇÕES NOTA DE SAÍDA
      lv_parvw_sa  = 'AG'.
      lv_parid_sa  = ls_gerais-col_ci.
      lv_cfop_sa   = '594920'.

      READ TABLE lt_tvak INTO DATA(ls_tvak) WITH KEY auart = gc_auart_saida.
      lv_nftype_sa = ls_tvak-j_1bnftype.

      SELECT SINGLE * FROM j_1baa INTO ls_info_nota_sa
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

      ls_nf_msg-seqnum = '02'.
      ls_nf_msg-linnum = '01'.
      ls_nf_msg-manual = 'X'.
      ls_nf_msg-message = 'DOC INVENTÁRIO'.

      CONCATENATE ls_nf_msg-message space
*                i_iblnr
                     INTO ls_nf_msg-message SEPARATED BY ':'.
      IF NOT lt_nf_item_sa IS INITIAL.
        APPEND ls_nf_msg TO lt_nf_msg_sa.
      ENDIF.

*** IMPOSTOS:
      IF lt_mseg_sa IS NOT INITIAL.

        NEW zclmm_gerar_nf_inventario(  )->simulate(
          EXPORTING
            it_mkpf  = it_mkpf[]
            it_mseg  = lt_mseg_sa
            IMPORTING
            et_return = lt_return
            CHANGING
            ct_cond    = lt_cond
            ct_fiscais = lt_dir_fiscais
         ).

        IF  line_exists( lt_return[ type = 'E' ] ).

          NEW zclmm_gerar_nf_inventario(  )->save_log(
              EXPORTING
                   it_return = lt_nf_return[]
                   is_log    = VALUE bal_s_log(
                              aluser    = sy-uname
                              alprog    = sy-repid
                              object    = gc_objeto
                              subobject = gc_subobjeto_s
                              extnumber = sy-timlo ) ).

          CONTINUE.

        ELSE.

          LOOP AT lt_cond ASSIGNING FIELD-SYMBOL(<fs_cond>).
            IF  <fs_cond>-cond_type EQ 'BX23' OR
                <fs_cond>-cond_type EQ 'BX41' OR
                <fs_cond>-cond_type EQ 'BX4A'.
              ADD <fs_cond>-condvalue TO lv_condvalue.
            ENDIF.
          ENDLOOP.

        ENDIF.

      ENDIF.

      LOOP AT lt_nf_item_sa ASSIGNING FIELD-SYMBOL(<fs_nf_item_sa>).

        DATA(lv_tabix) = sy-tabix.

        CLEAR: ls_nf_item_tax,
               ls_dir_fiscais.

        "//get subtotal value with taxes included
        NEW zclmm_gerar_nf_inventario(  )->get_condition_to_field(
         EXPORTING
           it_conditions = lt_cond
           iv_item_num   = <fs_nf_item_sa>-itmnum
           iv_menge      = <fs_nf_item_sa>-menge
           iv_req_value  = gc_value
           iv_cond_type  =  'IBRX'
         CHANGING
           cv_field      = lv_total_with_taxes ).

        "Get taxes
        NEW zclmm_gerar_nf_inventario(  )->get_condition_to_field(
            EXPORTING
              it_conditions = lt_cond
              iv_item_num  = <fs_nf_item_sa>-itmnum
              iv_menge     = <fs_nf_item_sa>-menge
              iv_req_value = gc_rate
              iv_cond_type = 'ZICM'
            CHANGING
              cv_field = <fs_nf_item_sa>-netpr ).

        <fs_nf_item_sa>-netwr = <fs_nf_item_sa>-netpr * <fs_nf_item_sa>-menge.

        READ TABLE lt_nf_item_add_sa INTO ls_nf_item_add WITH KEY itmnum = <fs_nf_item_sa>-itmnum.

        DATA(lv_tabix2) = sy-tabix.
        ls_nf_item_add-nfpri  = <fs_nf_item_sa>-netpr.
        ls_nf_item_add-nfnet  = <fs_nf_item_sa>-netwr.
        ls_nf_item_add-netwrt = <fs_nf_item_sa>-netwr.
        ls_nf_item_add-nfnett = <fs_nf_item_sa>-netwr.


        NEW zclmm_gerar_nf_inventario(  )->get_condition_to_field(
            EXPORTING
              it_conditions = lt_cond
              iv_item_num  = <fs_nf_item_sa>-itmnum
              iv_menge     = <fs_nf_item_sa>-menge
              iv_req_value = gc_rate
              iv_cond_type = 'ISTS'
            CHANGING
              cv_field = ls_nf_item_add-p_mvast ).

        MODIFY lt_nf_item_add_sa FROM ls_nf_item_add INDEX lv_tabix2.

        ls_nf_item_tax-taxtyp = 'ICM3'.
        ls_nf_item_tax-itmnum = <fs_nf_item_sa>-itmnum.

        DO 6 TIMES.

          DATA(lv_data) = COND #( WHEN sy-index EQ 1 THEN ls_nf_item_tax-base
                                  WHEN sy-index EQ 2 THEN ls_nf_item_tax-rate
                                  WHEN sy-index EQ 3 THEN ls_nf_item_tax-taxval
                                  WHEN sy-index EQ 4 THEN ls_nf_item_tax-excbas
                                  WHEN sy-index EQ 5 THEN ls_nf_item_tax-othbas
                                  WHEN sy-index EQ 6 THEN ls_nf_item_tax-basered1 ).

          NEW zclmm_gerar_nf_inventario(  )->get_condition_to_field(
            EXPORTING
              it_conditions = lt_cond
              iv_item_num   = <fs_nf_item_sa>-itmnum
              iv_menge      = <fs_nf_item_sa>-menge
              iv_req_value  = COND #( WHEN sy-index EQ 2
                                        OR sy-index EQ 6 THEN gc_rate
                                                         ELSE gc_value )
               iv_cond_type  = COND #( WHEN sy-index EQ 1 THEN 'BX10'
                                       WHEN sy-index EQ 2 THEN 'BX13'
                                       WHEN sy-index EQ 3 THEN 'BX13'
                                       WHEN sy-index EQ 4 THEN 'BX11'
                                       WHEN sy-index EQ 5 THEN 'BX12'
                                       WHEN sy-index EQ 6 THEN 'ICBS' )
            CHANGING
              cv_field      = lv_data ).

          CASE sy-index.
            WHEN 1.
              ls_nf_item_tax-base     = lv_data.
              IF ls_nf_item_tax-base IS INITIAL.
                ls_nf_item_tax-othbas =  <fs_nf_item_sa>-netwr.
                EXIT.
              ENDIF.
            WHEN 2.
              ls_nf_item_tax-rate     = lv_data.
            WHEN 3.
              ls_nf_item_tax-taxval   = lv_data.
              DATA(lv_tax_icm3)       = lv_data.
            WHEN 4.
              ls_nf_item_tax-excbas   = lv_data.
            WHEN 5.
              ls_nf_item_tax-othbas   = lv_data.
            WHEN 6.
              ls_nf_item_tax-basered1 = lv_data.
          ENDCASE.
        ENDDO.

        IF ls_nf_item_tax-basered1 IS INITIAL.
          CLEAR:  ls_nf_item_tax-rate.
        ENDIF.

        APPEND ls_nf_item_tax TO lt_nf_item_tax_sa.

        CLEAR: ls_nf_item_tax.
        ls_nf_item_tax-taxtyp = 'ICS3'.
        ls_nf_item_tax-itmnum = <fs_nf_item_sa>-itmnum.

        DO 6 TIMES.

          lv_data = COND #( WHEN sy-index EQ 1 THEN ls_nf_item_tax-base
                            WHEN sy-index EQ 2 THEN ls_nf_item_tax-rate
                            WHEN sy-index EQ 3 THEN ls_nf_item_tax-taxval
                            WHEN sy-index EQ 4 THEN ls_nf_item_tax-excbas
                            WHEN sy-index EQ 5 THEN ls_nf_item_tax-othbas
                            WHEN sy-index EQ 6 THEN ls_nf_item_tax-basered1 ).

          NEW zclmm_gerar_nf_inventario(  )->get_condition_to_field(
           EXPORTING
             it_conditions = lt_cond
             iv_item_num   = <fs_nf_item_sa>-itmnum
             iv_menge      = <fs_nf_item_sa>-menge
             iv_req_value  = COND #( WHEN sy-index EQ 2
                                       OR sy-index EQ 6 THEN gc_rate
                                                        ELSE gc_value )
             iv_cond_type  = COND #( WHEN sy-index EQ 1 THEN 'BX40'
                                     WHEN sy-index EQ 2 THEN 'ISIC'
                                     WHEN sy-index EQ 3 THEN 'BX41'
                                     WHEN sy-index EQ 4 THEN 'BX42'
                                     WHEN sy-index EQ 5 THEN 'BX43'
                                     WHEN sy-index EQ 6 THEN 'ISTS'
                                     )
           CHANGING
             cv_field      = lv_data ).

          CASE sy-index.
            WHEN 1.
              ls_nf_item_tax-base     = lv_data.
            WHEN 2.
              ls_nf_item_tax-rate     = lv_data.
            WHEN 3.
              ls_nf_item_tax-taxval   = lv_data.
            WHEN 4.
              ls_nf_item_tax-excbas   = lv_data.
            WHEN 5.
              ls_nf_item_tax-othbas   = lv_data.
            WHEN 6.
              ls_nf_item_tax-basered1 = lv_data.
          ENDCASE.

        ENDDO.

        IF ls_nf_item_tax-taxval IS NOT INITIAL.

          IF ls_nf_item_tax-basered1 IS INITIAL.
            CLEAR: ls_nf_item_tax-rate.
          ENDIF.

          APPEND ls_nf_item_tax TO lt_nf_item_tax_sa.
        ENDIF.

        CLEAR: ls_nf_item_tax.
        ls_nf_item_tax-taxtyp = 'IPI3'.
        ls_nf_item_tax-itmnum = <fs_nf_item_sa>-itmnum.

        DO 6 TIMES.

          lv_data = COND #( WHEN sy-index EQ 1 THEN ls_nf_item_tax-base
                            WHEN sy-index EQ 2 THEN ls_nf_item_tax-rate
                            WHEN sy-index EQ 3 THEN ls_nf_item_tax-taxval
                            WHEN sy-index EQ 4 THEN ls_nf_item_tax-excbas
                            WHEN sy-index EQ 5 THEN ls_nf_item_tax-othbas
                            WHEN sy-index EQ 6 THEN ls_nf_item_tax-basered1 ).

          NEW zclmm_gerar_nf_inventario(  )->get_condition_to_field(
           EXPORTING
             iv_taxtyp     = ls_nf_item_tax-taxtyp
             it_conditions = lt_cond
             iv_item_num   = <fs_nf_item_sa>-itmnum
             iv_menge      = <fs_nf_item_sa>-menge
             iv_req_value  = COND #( WHEN sy-index EQ 2
                                       OR sy-index EQ 6 THEN gc_rate
                                                        ELSE gc_value )
             iv_cond_type  = COND #( WHEN sy-index EQ 1 THEN 'BX20'
                                     WHEN sy-index EQ 2 THEN 'IPVA'
                                     WHEN sy-index EQ 3 THEN 'BX23'
                                     WHEN sy-index EQ 4 THEN 'BX21'
                                     WHEN sy-index EQ 5 THEN 'BX22'
                                     WHEN sy-index EQ 6 THEN 'IPBS' )
           CHANGING
             cv_field      = lv_data ).

          CASE sy-index.
            WHEN 1.
              ls_nf_item_tax-base     = lv_data.
              IF lv_data EQ 0.
                ls_nf_item_tax-othbas =  <fs_nf_item_sa>-netwr.
                EXIT.
              ENDIF.
            WHEN 2.
              ls_nf_item_tax-rate     = lv_data.
            WHEN 3.
              ls_nf_item_tax-taxval   = lv_data.
            WHEN 4.
              ls_nf_item_tax-excbas   = lv_data.
            WHEN 5.
              ls_nf_item_tax-othbas   = lv_data.
            WHEN 6.
              ls_nf_item_tax-basered1 = lv_data.
          ENDCASE.

        ENDDO.

        APPEND ls_nf_item_tax TO lt_nf_item_tax_sa.

        CLEAR: ls_nf_item_tax.
        ls_nf_item_tax-taxtyp = 'ICON'.
        ls_nf_item_tax-itmnum = <fs_nf_item_sa>-itmnum.

        DO 5 TIMES.

          lv_data = COND #( WHEN sy-index EQ 1 THEN ls_nf_item_tax-base
                            WHEN sy-index EQ 2 THEN ls_nf_item_tax-rate
                            WHEN sy-index EQ 3 THEN ls_nf_item_tax-taxval
                            WHEN sy-index EQ 4 THEN ls_nf_item_tax-excbas
                            WHEN sy-index EQ 5 THEN ls_nf_item_tax-basered1 ).

          NEW zclmm_gerar_nf_inventario(  )->get_condition_to_field(
           EXPORTING
             iv_taxtyp     = ls_nf_item_tax-taxtyp
             it_conditions = lt_cond
             iv_item_num   = <fs_nf_item_sa>-itmnum
             iv_menge      = <fs_nf_item_sa>-menge
             iv_req_value  = COND #( WHEN sy-index EQ 2
                                       OR sy-index EQ 5 THEN gc_rate
                                                        ELSE gc_value )
             iv_cond_type  = COND #( WHEN sy-index EQ 1 THEN 'BX70'
                                     WHEN sy-index EQ 2 THEN 'BCO1'
                                     WHEN sy-index EQ 3 THEN 'BX72'
                                     WHEN sy-index EQ 4 THEN 'BX71'
                                     WHEN sy-index EQ 5 THEN 'BCO2' )
           CHANGING
             cv_field      = lv_data ).

          CASE sy-index.
            WHEN 1.
              TRY.
                  ls_nf_item_tax-base = lv_data.
                CATCH cx_root.
              ENDTRY.
            WHEN 2.
              ls_nf_item_tax-rate     = lv_data.
            WHEN 3.
              ls_nf_item_tax-taxval   = lv_data.
              IF lv_data IS INITIAL.
                CLEAR ls_nf_item_tax-base.
              ENDIF.
            WHEN 4.
              IF ls_nf_item_tax-taxval IS NOT INITIAL.
                ls_nf_item_tax-excbas   = lv_data.
              ELSE.
                ls_nf_item_tax-othbas = lv_data.
              ENDIF.
            WHEN 5.
              ls_nf_item_tax-basered1 = lv_data.
          ENDCASE.

        ENDDO.

        APPEND ls_nf_item_tax TO lt_nf_item_tax_sa.

        CLEAR: ls_nf_item_tax.
        ls_nf_item_tax-taxtyp = 'IPSN'.
        ls_nf_item_tax-itmnum = <fs_nf_item_sa>-itmnum.

        DO 5 TIMES.

          lv_data = COND #( WHEN sy-index EQ 1 THEN ls_nf_item_tax-base
                            WHEN sy-index EQ 2 THEN ls_nf_item_tax-rate
                            WHEN sy-index EQ 3 THEN ls_nf_item_tax-taxval
                            WHEN sy-index EQ 4 THEN ls_nf_item_tax-excbas
                            WHEN sy-index EQ 5 THEN ls_nf_item_tax-basered1 ).

          NEW zclmm_gerar_nf_inventario(  )->get_condition_to_field(
           EXPORTING
             iv_taxtyp     = ls_nf_item_tax-taxtyp
             it_conditions = lt_cond
             iv_item_num   = <fs_nf_item_sa>-itmnum
             iv_menge      = <fs_nf_item_sa>-menge
             iv_req_value  = COND #( WHEN sy-index EQ 2
                                       OR sy-index EQ 5 THEN gc_rate
                                                        ELSE gc_value )
             iv_cond_type  = COND #( WHEN sy-index EQ 1 THEN 'BX80'
                                     WHEN sy-index EQ 2 THEN 'BPI1'
                                     WHEN sy-index EQ 3 THEN 'BX82'
                                     WHEN sy-index EQ 4 THEN 'BX81'
                                     WHEN sy-index EQ 5 THEN 'BPI2' )
           CHANGING
             cv_field      = lv_data ).

          CASE sy-index.
            WHEN 1.
              TRY.
                  ls_nf_item_tax-base = lv_data.
                CATCH cx_root.
              ENDTRY.
            WHEN 2.
              ls_nf_item_tax-rate     = lv_data.
            WHEN 3.
              ls_nf_item_tax-taxval   = lv_data.
              IF lv_data IS INITIAL.
                CLEAR ls_nf_item_tax-base.
              ENDIF.
            WHEN 4.
              IF ls_nf_item_tax-taxval IS NOT INITIAL.
                ls_nf_item_tax-excbas   = lv_data.
              ELSE.
                ls_nf_item_tax-othbas = lv_data.
              ENDIF.
            WHEN 5.
              ls_nf_item_tax-basered1 = lv_data.
          ENDCASE.

        ENDDO.

        APPEND ls_nf_item_tax TO lt_nf_item_tax_sa.

        CLEAR: ls_nf_item_tax.
        ls_nf_item_tax-taxtyp = 'ICSC'.
        ls_nf_item_tax-itmnum = <fs_nf_item_sa>-itmnum.

        DO 5 TIMES.

          lv_data = COND #( WHEN sy-index EQ 1 THEN ls_nf_item_tax-base
                            WHEN sy-index EQ 2 THEN ls_nf_item_tax-rate
                            WHEN sy-index EQ 3 THEN ls_nf_item_tax-taxval
                            WHEN sy-index EQ 4 THEN ls_nf_item_tax-excbas
                            WHEN sy-index EQ 5 THEN ls_nf_item_tax-basered1 ).

          NEW zclmm_gerar_nf_inventario(  )->get_condition_to_field(
           EXPORTING
             it_conditions = lt_cond
             iv_item_num   = <fs_nf_item_sa>-itmnum
             iv_menge      = <fs_nf_item_sa>-menge
             iv_req_value  = COND #( WHEN sy-index EQ 2
                                       OR sy-index EQ 5 THEN gc_rate
                                                        ELSE gc_value )
             iv_cond_type  = COND #( WHEN sy-index EQ 1 THEN 'BX9M'
                                     WHEN sy-index EQ 2 THEN 'ISFR'
                                     WHEN sy-index EQ 3 THEN 'BX9I'
                                     WHEN sy-index EQ 4 THEN 'BX9L'
                                     WHEN sy-index EQ 5 THEN 'ISFB' )
           CHANGING
             cv_field      = lv_data ).

          CASE sy-index.
            WHEN 1.
              ls_nf_item_tax-base     = lv_data.
            WHEN 2.
              ls_nf_item_tax-rate     = lv_data.
            WHEN 3.
              ls_nf_item_tax-taxval   = lv_data.
            WHEN 4.
              ls_nf_item_tax-excbas   = lv_data.
            WHEN 5.
              ls_nf_item_tax-basered1 = lv_data.
          ENDCASE.

          IF ls_nf_item_tax-taxval IS INITIAL.
            CLEAR: ls_nf_item_tax.
          ELSE.

            IF ls_nf_item_tax-basered1 IS INITIAL.
              CLEAR: ls_nf_item_tax-rate.
            ENDIF.

          ENDIF.

        ENDDO.

        IF ls_nf_item_tax-taxval IS NOT INITIAL.
          APPEND ls_nf_item_tax TO lt_nf_item_tax_sa.
        ENDIF.

        CLEAR: ls_nf_item_tax.
        ls_nf_item_tax-taxtyp = 'FCP3'.
        ls_nf_item_tax-itmnum = <fs_nf_item_sa>-itmnum.

        DO 3 TIMES.

          lv_data = COND #( WHEN sy-index EQ 1 THEN ls_nf_item_tax-base
                            WHEN sy-index EQ 2 THEN ls_nf_item_tax-rate
                            WHEN sy-index EQ 3 THEN ls_nf_item_tax-taxval ).

          NEW zclmm_gerar_nf_inventario(  )->get_condition_to_field(
           EXPORTING
             it_conditions = lt_cond
             iv_item_num   = <fs_nf_item_sa>-itmnum
             iv_menge      = <fs_nf_item_sa>-menge
             iv_req_value  = COND #( WHEN sy-index EQ 2 THEN gc_rate
                                                        ELSE gc_value )
             iv_cond_type  = COND #( WHEN sy-index EQ 1 THEN 'BX9M'
                                     WHEN sy-index EQ 2 THEN 'BX97'
                                     WHEN sy-index EQ 3 THEN 'BX9I' )
           CHANGING
             cv_field      = lv_data ).

          CASE sy-index.
            WHEN 1.
              ls_nf_item_tax-base     = lv_data.
            WHEN 2.
              ls_nf_item_tax-rate     = lv_data.
            WHEN 3.
              ls_nf_item_tax-taxval   = lv_data.
          ENDCASE.

        ENDDO.

        IF ls_nf_item_tax-taxval IS NOT INITIAL.
          APPEND ls_nf_item_tax TO lt_nf_item_tax_sa.
        ENDIF.

        READ TABLE lt_dir_fiscais INTO ls_dir_fiscais WITH KEY itm_number = <fs_nf_item_sa>-itmnum.
        IF sy-subrc IS INITIAL.
          <fs_nf_item_sa>-taxlw1 = ls_dir_fiscais-taxlw1.
          <fs_nf_item_sa>-taxsit = ls_dir_fiscais-taxsit_icms.

          <fs_nf_item_sa>-taxlw2 = ls_dir_fiscais-taxlw2.
          <fs_nf_item_sa>-taxsi2 = ls_dir_fiscais-taxsitout_ipi.

          <fs_nf_item_sa>-taxlw5 = ls_dir_fiscais-taxlw5.
          <fs_nf_item_sa>-taxsi5 = ls_dir_fiscais-taxsitout_pis.

          <fs_nf_item_sa>-taxlw4 = ls_dir_fiscais-taxlw4.
          <fs_nf_item_sa>-taxsi4 = ls_dir_fiscais-taxsitout_cof.
        ENDIF.

      ENDLOOP.

      IF NOT lt_nf_item_sa IS INITIAL.
        ls_nf_partner-parvw  =  lv_parvw_sa.
        ls_nf_partner-parid  =  lv_parid_sa.
        ls_nf_partner-partyp =  lv_partyp_sa.
        APPEND ls_nf_partner TO lt_nf_partner_sa.
      ENDIF.

    ELSE.

      lv_parvw_en  = 'LF'.
      lv_parid_en  = ls_gerais-lifnr.
      lv_cfop_en   = '194920'.

      READ TABLE lt_tvak INTO ls_tvak WITH KEY auart = gc_auart_entrada.
      lv_nftype_en = ls_tvak-j_1bnftype.

      SELECT SINGLE * FROM j_1baa INTO ls_info_nota_en
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

      CONCATENATE ls_nf_msg-message space
*                i_iblnr
                     INTO ls_nf_msg-message SEPARATED BY ':'.

      IF NOT lt_nf_item_en IS INITIAL.
        APPEND ls_nf_msg TO lt_nf_msg_en.
      ENDIF.


      IF lt_mseg_en IS NOT INITIAL.

        NEW zclmm_gerar_nf_inventario(  )->simulate(
          EXPORTING
            it_mkpf  = it_mkpf[]
            it_mseg  = lt_mseg_en
            IMPORTING
            et_return = lt_return
            CHANGING
            ct_cond    = lt_cond
            ct_fiscais = lt_dir_fiscais
         ).

        IF  ls_return-type NE 'E'.

          LOOP AT lt_cond ASSIGNING <fs_cond>.
            IF <fs_cond>-cond_type EQ 'BX23' OR
               <fs_cond>-cond_type EQ 'BX41' OR
               <fs_cond>-cond_type EQ 'BX4A'.
              ADD <fs_cond>-condvalue TO lv_condvalue.
            ENDIF.
          ENDLOOP.

        ENDIF.

      ENDIF.


      LOOP AT lt_nf_item_en ASSIGNING FIELD-SYMBOL(<fs_nf_item_en>).

        lv_tabix = sy-tabix.

        CLEAR: ls_nf_item_tax,
               ls_dir_fiscais.

* Direito fiscal ICMS
        READ TABLE lt_zsdtdirfiscais INTO DATA(ls_zsdtdirfiscais) WITH KEY shipfrom = ls_gerais-regio
                                                                           direcao  = '1'.
        "cfop     = <fs_nf_item_en>-cfop_10.
        IF sy-subrc IS INITIAL.
          <fs_nf_item_en>-taxlw1 = ls_zsdtdirfiscais-taxlw1.

          SELECT SINGLE taxsit INTO <fs_nf_item_en>-taxsit FROM j_1batl1 WHERE taxlaw = ls_zsdtdirfiscais-taxlw1.

          <fs_nf_item_en>-taxlw2 = ls_zsdtdirfiscais-taxlw2.

          SELECT SINGLE taxsit INTO <fs_nf_item_en>-taxsi2 FROM j_1batl2 WHERE taxlaw = ls_zsdtdirfiscais-taxlw2.

          <fs_nf_item_en>-taxlw5 = ls_zsdtdirfiscais-taxlw5.

          SELECT SINGLE taxsit INTO <fs_nf_item_en>-taxsi5 FROM j_1batl5 WHERE taxlaw = ls_zsdtdirfiscais-taxlw5.

          <fs_nf_item_en>-taxlw4 = ls_zsdtdirfiscais-taxlw4.

          SELECT SINGLE taxsit INTO <fs_nf_item_en>-taxsi4 FROM j_1batl4a WHERE taxlaw = ls_zsdtdirfiscais-taxlw4.

        ENDIF.

        NEW zclmm_gerar_nf_inventario(  )->get_condition_to_field(
          EXPORTING
            it_conditions = lt_cond
            iv_item_num  = <fs_nf_item_en>-itmnum
            iv_menge     = <fs_nf_item_en>-menge
            iv_req_value = gc_rate
            iv_cond_type = 'ZICM'
          CHANGING
            cv_field = <fs_nf_item_en>-netpr ).

        <fs_nf_item_en>-netwr = <fs_nf_item_en>-netpr * <fs_nf_item_en>-menge.
        MODIFY lt_nf_item_en FROM <fs_nf_item_en> INDEX lv_tabix.
        READ TABLE lt_nf_item_add_en INTO ls_nf_item_add WITH KEY itmnum = <fs_nf_item_en>-itmnum.
        ls_nf_item_add-nfpri  = <fs_nf_item_en>-netpr.
        ls_nf_item_add-nfnet  = <fs_nf_item_en>-netwr.
        ls_nf_item_add-netwrt = <fs_nf_item_en>-netwr.
        ls_nf_item_add-nfnett = <fs_nf_item_en>-netwr.
        MODIFY lt_nf_item_add_en FROM ls_nf_item_add INDEX sy-tabix.

        CLEAR: ls_nf_item_tax.
        ls_nf_item_tax-taxtyp = 'IPI1'.
        ls_nf_item_tax-itmnum = <fs_nf_item_en>-itmnum.

        NEW zclmm_gerar_nf_inventario(  )->get_condition_to_field(
         EXPORTING
           it_conditions = lt_cond
           iv_item_num   = <fs_nf_item_en>-itmnum
           iv_menge      = <fs_nf_item_en>-menge
           iv_req_value  = gc_value
           iv_cond_type  =  'IBRX'
         CHANGING
           cv_field      = ls_nf_item_tax-othbas ).

        APPEND ls_nf_item_tax TO lt_nf_item_tax_en.

        CLEAR: ls_nf_item_tax.
        ls_nf_item_tax-taxtyp = 'ICM1'.
        ls_nf_item_tax-itmnum = <fs_nf_item_en>-itmnum.

        NEW zclmm_gerar_nf_inventario(  )->get_condition_to_field(
         EXPORTING
           it_conditions = lt_cond
           iv_item_num   = <fs_nf_item_en>-itmnum
           iv_menge      = <fs_nf_item_en>-menge
           iv_req_value  =  gc_value
           iv_cond_type  =  'IBRX'
         CHANGING
           cv_field      = ls_nf_item_tax-othbas ).

        APPEND ls_nf_item_tax TO lt_nf_item_tax_en.


        CLEAR: ls_nf_item_tax.
        ls_nf_item_tax-taxtyp = 'ICON'.
        ls_nf_item_tax-itmnum = <fs_nf_item_en>-itmnum.

        NEW zclmm_gerar_nf_inventario(  )->get_condition_to_field(
         EXPORTING
           it_conditions = lt_cond
           iv_item_num   = <fs_nf_item_en>-itmnum
           iv_menge      = <fs_nf_item_en>-menge
           iv_req_value  =  gc_value
           iv_cond_type  =  'IBRX'
         CHANGING
           cv_field      = ls_nf_item_tax-othbas ).

        APPEND ls_nf_item_tax TO lt_nf_item_tax_en.

        CLEAR: ls_nf_item_tax.
        ls_nf_item_tax-taxtyp = 'IPSN'.
        ls_nf_item_tax-itmnum = <fs_nf_item_en>-itmnum.

        NEW zclmm_gerar_nf_inventario(  )->get_condition_to_field(
         EXPORTING
           it_conditions = lt_cond
           iv_item_num   = <fs_nf_item_en>-itmnum
           iv_menge      = <fs_nf_item_en>-menge
           iv_req_value  =  gc_value
           iv_cond_type  =  'IBRX'
         CHANGING
           cv_field      = ls_nf_item_tax-othbas ).

        APPEND ls_nf_item_tax TO lt_nf_item_tax_en.

      ENDLOOP.

      IF NOT lt_nf_item_en IS INITIAL.
        ls_nf_partner-parvw  =  lv_parvw_en.
        ls_nf_partner-parid  =  lv_parid_en.
        ls_nf_partner-partyp =  lv_partyp_en.
        APPEND ls_nf_partner TO lt_nf_partner_en.
      ENDIF.

    ENDIF.


    IF NOT lt_nf_item_en IS INITIAL.

      SELECT SINGLE j_1bbranch FROM t001w INTO ls_nf_header_en-branch
        WHERE werks EQ <fs_msegx_grp>-werks.

      SELECT SINGLE series FROM j_1bb2 INTO ls_nf_header_en-series
        WHERE   bukrs  EQ <fs_msegx_grp>-bukrs
          AND   branch EQ ls_nf_header_en-branch
          AND   form   EQ lv_form_en.

      ls_nf_header_en-ntgew  = lv_ntgew_en.
      ls_nf_header_en-brgew  = lv_brgew_en.
      ls_nf_header_en-bukrs  = <fs_msegx_grp>-bukrs.
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
      ls_nf_header_en-waerk  = 'BRL'.
      ls_nf_header_en-manual = abap_true.
      ls_nf_header_en-nfe    = abap_true.
      ls_nf_header_en-inco1  = 'CIF'.
      ls_nf_header_en-entrad = abap_true.
    ENDIF.

    IF NOT lt_nf_item_sa IS INITIAL.

      SELECT SINGLE j_1bbranch FROM t001w INTO ls_nf_header_sa-branch
        WHERE werks EQ <fs_msegx_grp>-werks.

      SELECT SINGLE series FROM j_1bb2 INTO ls_nf_header_sa-series
        WHERE   bukrs  EQ <fs_msegx_grp>-bukrs
          AND   branch EQ ls_nf_header_sa-branch
          AND   form   EQ lv_form_sa.

      ls_nf_header_sa-ntgew  = lv_ntgew_sa.
      ls_nf_header_sa-brgew  = lv_brgew_sa.
      ls_nf_header_sa-bukrs  = <fs_msegx_grp>-bukrs.
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
      ls_nf_header_sa-waerk  = 'BRL'.
      ls_nf_header_sa-manual = 'X'.
      ls_nf_header_sa-nfe    = 'X'.
      ls_nf_header_sa-inco1  = 'CIF'.
    ENDIF.

    SORT lt_nf_msg_en BY docnum seqnum.
    DELETE ADJACENT DUPLICATES FROM lt_nf_msg_en COMPARING docnum seqnum.

    lv_netwr = REDUCE j_1bnetval( INIT lv_soma TYPE j_1bnetval
                                  FOR  ls_item_pay IN lt_nf_item_en
                                  NEXT lv_soma = lv_soma + ls_item_pay-netwr ).

    ADD lv_condvalue TO lv_netwr.

    ls_nfe_payment-docnum     = lv_docnum.
    ls_nfe_payment-t_pag      = gc_90.

    IF lt_nf_item_sa IS NOT INITIAL.
      ls_nfe_payment-v_pag  = lv_netwr.
    ENDIF.

    APPEND ls_nfe_payment TO lt_nfe_payment.

    IF <fs_msegx_grp>-bwart EQ gc_701.

      DATA(lt_nf_partner)  = lt_nf_partner_en.
      DATA(lt_nf_item)     = lt_nf_item_en.
      DATA(lt_nf_item_add) = lt_nf_item_add_en.
      DATA(lt_nf_item_tax) = lt_nf_item_tax_en.
      DATA(lt_nf_msg)      = lt_nf_msg_en.

    ELSE.

      lt_nf_partner  = lt_nf_partner_sa.
      lt_nf_item     = lt_nf_item_sa.
      lt_nf_item_add = lt_nf_item_add_sa.
      lt_nf_item_tax = lt_nf_item_tax_sa.
      lt_nf_msg      = lt_nf_msg_sa.

    ENDIF.

    DELETE lt_nf_item_tax WHERE itmnum IS INITIAL.       "#EC CI_STDSEQ

    " Efetua a criação do docto fiscal
    CALL FUNCTION 'BAPI_J_1B_NF_CREATEFROMDATA'
      EXPORTING
        obj_header     = COND #( WHEN <fs_msegx_grp>-bwart EQ gc_701 THEN ls_nf_header_en
                                                                     ELSE ls_nf_header_sa )
        nfcheck        = lv_nfcheck
      IMPORTING
        e_docnum       = lv_docnum
      TABLES
        obj_partner    = lt_nf_partner
        obj_item       = lt_nf_item
        obj_item_add   = lt_nf_item_add
        obj_item_tax   = lt_nf_item_tax
        obj_header_msg = lt_nf_msg
        obj_refer_msg  = lt_nf_ref
        obj_ot_partner = lt_nf_ot_part
        obj_payment    = lt_nfe_payment
        return         = lt_nf_return.

    IF lv_docnum IS INITIAL.
      CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.
    ELSE.
      CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
        EXPORTING
          wait = abap_true.
    ENDIF.

    NEW zclmm_gerar_nf_inventario(  )->save_log(
         EXPORTING
             it_return = lt_nf_return[]
             is_log    = VALUE bal_s_log(
                        aluser    = sy-uname
                        alprog    = sy-repid
                        object    = gc_objeto
                        subobject = COND #( WHEN <fs_msegx_grp>-bwart EQ gc_702 THEN gc_subobjeto_s ELSE gc_subobjeto_e )
                        extnumber = sy-timlo ) ).

    IF <fs_msegx_grp>-bwart EQ gc_702.

      IF NOT line_exists( lt_nf_return[ type = 'E' ] ).

        " Gerar contabilização
        NEW zclmm_gerar_nf_inventario(  )->gerar_contab( lv_docnum ).

      ENDIF.
    ENDIF.

    CLEAR: lv_docnum,
           lt_nf_partner[],
           lt_nf_partner_sa[],
           lt_nf_item[],
           lt_nf_item_sa[],
           lt_nf_item_add[] ,
           lt_nf_item_add_sa[],
           lt_nf_item_tax[] ,
           lt_nf_item_tax_sa[],
           lt_nf_msg[],
           lt_nf_msg_sa[],
           lt_nf_partner_en[],
           lt_nf_item_en[],
           lt_nf_item_add_en[],
           lt_nf_item_tax_en[],
           lt_nf_msg_en[].

  ENDLOOP.

ENDFUNCTION.
