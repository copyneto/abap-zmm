CLASS zclmm_criar_replic_nf_writer DEFINITION PUBLIC FINAL CREATE PUBLIC .
  PUBLIC SECTION.
    METHODS:
      executar.

  PRIVATE SECTION.
    TYPES:
      BEGIN OF ty_pedido_principal,
        main_purchase_order      TYPE ekko-ebeln,
        main_purchase_order_item TYPE ekpo-ebelp,
        refkey                   TYPE j_1bnflin-refkey,
        refitm                   TYPE j_1bnflin-refitm,
        refitm_aux               TYPE j_1bnflin-refitm,
        lifnr                    TYPE ekko-lifnr,
        regio                    TYPE lfa1-regio,
        in_br_nota_fiscal        TYPE ztmm_his_dep_fec-in_br_nota_fiscal,
      END OF ty_pedido_principal,

      BEGIN OF ty_nfe_active,
        docnum  TYPE j_1bnfe_active-docnum,
        regio   TYPE j_1bnfe_active-regio,
        nfyear  TYPE j_1bnfe_active-nfyear,
        nfmonth TYPE j_1bnfe_active-nfmonth,
        stcd1   TYPE j_1bnfe_active-stcd1,
        model   TYPE j_1bnfe_active-model,
        serie   TYPE j_1bnfe_active-serie,
        nfnum9  TYPE j_1bnfe_active-nfnum9,
        docnum9 TYPE j_1bnfe_active-docnum9,
        cdv     TYPE j_1bnfe_active-cdv,
      END OF ty_nfe_active,

      BEGIN OF ty_nf_entrada_doc,
        docnum TYPE j_1bnfdoc-docnum,
        bukrs  TYPE j_1bnfdoc-bukrs,
        branch TYPE j_1bnfdoc-branch,
      END OF ty_nf_entrada_doc,

      BEGIN OF ty_nf_entrada_lin,
        docnum TYPE j_1bnflin-docnum,
        itmnum TYPE j_1bnflin-itmnum,
        bwkey  TYPE j_1bnflin-bwkey,
        werks  TYPE j_1bnflin-werks,
      END OF ty_nf_entrada_lin,

      tt_nf_entrada_lin TYPE SORTED TABLE OF ty_nf_entrada_lin  WITH UNIQUE KEY docnum itmnum,

      BEGIN OF ty_dados_nf_pedido,
        in_br_nota_fiscal        TYPE ztmm_his_dep_fec-in_br_nota_fiscal,
        rep_br_nota_fiscal       TYPE j_1bdocnum,
        main_purchase_order      TYPE ekko-ebeln,
        main_purchase_order_item TYPE ekpo-ebelp,
        lifnr                    TYPE ekko-lifnr,
        regio                    TYPE lfa1-regio,
        j_1bnfdoc                TYPE j_1bnfdoc,
        j_1bnfe_active           TYPE ty_nfe_active,
        j_1bnflin                TYPE j_1bnflin_tab,
*        j_1bnfstx                TYPE j_1bnfstx_tab,
        doc_entrada              TYPE ty_nf_entrada_doc,
        lin_entrada              TYPE tt_nf_entrada_lin,
      END OF ty_dados_nf_pedido,

      BEGIN OF ty_documentos_writer,
        main_purchase_order TYPE ztmm_his_dep_fec-main_purchase_order,
        rep_br_nota_fiscal  TYPE ztmm_his_dep_fec-rep_br_nota_fiscal,
      END OF ty_documentos_writer.

    TYPES:
      tt_pedidos_principal TYPE STANDARD TABLE OF ty_pedido_principal WITH NON-UNIQUE KEY main_purchase_order main_purchase_order_item,
      tt_dados_nf_pedido   TYPE STANDARD TABLE OF ty_dados_nf_pedido  WITH DEFAULT KEY,
      tt_documentos_writer TYPE SORTED TABLE OF ty_documentos_writer  WITH NON-UNIQUE KEY main_purchase_order,
      tt_nfe_active        TYPE SORTED TABLE OF ty_nfe_active  WITH UNIQUE KEY docnum.

    METHODS:
      exec_bapi_nf_createfromdata
        IMPORTING
          is_obj_header    TYPE bapi_j_1bnfdoc
          it_obj_partner   TYPE bapi_j_1bnfnad_tab
          it_obj_item      TYPE bapi_j_1bnflin_tab
          it_obj_item_tax  TYPE bapi_j_1bnfstx_tab
        RETURNING
          VALUE(rv_return) TYPE j_1bdocnum,

      preenche_obj_header
        IMPORTING
          is_dados_pedido  TYPE ty_dados_nf_pedido
        RETURNING
          VALUE(rs_return) TYPE bapi_j_1bnfdoc,

      preencher_obj_partner
        IMPORTING
          is_dados_pedido  TYPE ty_dados_nf_pedido
        RETURNING
          VALUE(rt_return) TYPE bapi_j_1bnfnad_tab,

      preencher_obj_item
        IMPORTING
          is_dados_pedido  TYPE ty_dados_nf_pedido
        RETURNING
          VALUE(rt_return) TYPE bapi_j_1bnflin_tab,

      preencher_obj_item_tax
        IMPORTING
          is_dados_pedido  TYPE ty_dados_nf_pedido
        RETURNING
          VALUE(rt_return) TYPE bapi_j_1bnfstx_tab,

      seleciona_pedidos_criar_nf
        RETURNING
          VALUE(rt_return) TYPE tt_pedidos_principal,

      pedidos_fornecedor_externo
        RETURNING
          VALUE(rt_return) TYPE tt_pedidos_principal,

      transferencia_entre_centros
        RETURNING
          VALUE(rt_return) TYPE tt_pedidos_principal,

      seleciona_dados_nf_pedido
        IMPORTING
          it_pedidos_principal TYPE tt_pedidos_principal
        RETURNING
          VALUE(rt_return)     TYPE tt_dados_nf_pedido,

      atualizar_tab_hist_nf_replic
        IMPORTING
          it_documentos_writer TYPE tt_documentos_writer,

      atualizar_nf_writer
        IMPORTING
          it_documentos_writer TYPE tt_documentos_writer,

      criar_nf_writer
        IMPORTING
          it_dados_nf_pedido TYPE tt_dados_nf_pedido
        RETURNING
          VALUE(rt_return)   TYPE tt_documentos_writer.
ENDCLASS.



CLASS ZCLMM_CRIAR_REPLIC_NF_WRITER IMPLEMENTATION.


  METHOD executar.
    DATA(lt_pedidos_criar_nf)  = seleciona_pedidos_criar_nf( ).
    DATA(lt_dados_nf_pedido)   = seleciona_dados_nf_pedido( lt_pedidos_criar_nf ). "#EC CI_CONV_OK
    DATA(lt_documentos_writer) = criar_nf_writer( lt_dados_nf_pedido ).
    atualizar_nf_writer( lt_documentos_writer ).
    atualizar_tab_hist_nf_replic( lt_documentos_writer ).
  ENDMETHOD.


  METHOD criar_nf_writer.
    LOOP AT it_dados_nf_pedido ASSIGNING FIELD-SYMBOL(<fs_dados_nf_pedido>).
      DATA(lv_rep_br_nota_fiscal) = exec_bapi_nf_createfromdata(
        is_obj_header  = preenche_obj_header( <fs_dados_nf_pedido> )
        it_obj_partner = preencher_obj_partner( <fs_dados_nf_pedido> )
        it_obj_item    = preencher_obj_item( <fs_dados_nf_pedido> )
        it_obj_item_tax = preencher_obj_item_tax( <fs_dados_nf_pedido> )
      ).
      rt_return = COND #( WHEN lv_rep_br_nota_fiscal IS NOT INITIAL
        THEN VALUE #( BASE rt_return
          ( main_purchase_order = <fs_dados_nf_pedido>-main_purchase_order
            rep_br_nota_fiscal  = lv_rep_br_nota_fiscal ) )
        ELSE rt_return
      ).
    ENDLOOP.
  ENDMETHOD.


  METHOD atualizar_tab_hist_nf_replic.
    CHECK it_documentos_writer IS NOT INITIAL.

    SELECT _his_dep_fec~* FROM ztmm_his_dep_fec AS _his_dep_fec
    INNER JOIN @it_documentos_writer AS _documentos_writer
    ON _documentos_writer~main_purchase_order = _his_dep_fec~main_purchase_order
    INTO TABLE @DATA(lt_his_dep_fec).

    CHECK lt_his_dep_fec IS NOT INITIAL.

    LOOP AT lt_his_dep_fec ASSIGNING FIELD-SYMBOL(<fs_his_dep_fec>).
      READ TABLE it_documentos_writer ASSIGNING FIELD-SYMBOL(<fs_dados_nf_pedido_principal>)
      WITH KEY main_purchase_order = <fs_his_dep_fec>-main_purchase_order BINARY SEARCH.
      IF sy-subrc = 0.
        <fs_his_dep_fec>-rep_br_nota_fiscal = <fs_dados_nf_pedido_principal>-rep_br_nota_fiscal.
      ENDIF.
    ENDLOOP.
    UPDATE ztmm_his_dep_fec FROM TABLE lt_his_dep_fec.
  ENDMETHOD.


  METHOD atualizar_nf_writer.

    SELECT _lin~* FROM j_1bnflin AS _lin
    INNER JOIN @it_documentos_writer AS _writer
    ON _lin~docnum = _writer~rep_br_nota_fiscal
    INTO TABLE @DATA(lt_j_1bnflin).
    IF sy-subrc = 0.
      LOOP AT lt_j_1bnflin ASSIGNING FIELD-SYMBOL(<fs_lin>).
        CLEAR <fs_lin>-nitemped.
      ENDLOOP.
      UPDATE j_1bnflin FROM TABLE lt_j_1bnflin.
      COMMIT WORK.
    ENDIF.
  ENDMETHOD.


  METHOD seleciona_dados_nf_pedido.
    DATA lt_doc TYPE SORTED TABLE OF j_1bnfdoc WITH UNIQUE KEY mandt docnum.
    DATA lt_lin TYPE SORTED TABLE OF j_1bnflin WITH UNIQUE KEY mandt docnum itmnum.
*    DATA lt_stx TYPE SORTED TABLE OF j_1bnfstx WITH UNIQUE KEY mandt docnum itmnum taxtyp.
    DATA lt_doc_entrada TYPE SORTED TABLE OF ty_nf_entrada_doc WITH UNIQUE KEY docnum.
    DATA lt_lin_entrada TYPE SORTED TABLE OF ty_nf_entrada_lin WITH UNIQUE KEY docnum itmnum.
    DATA lt_nfe_active TYPE tt_nfe_active.

    CHECK it_pedidos_principal IS NOT INITIAL.

    SELECT _lin~* FROM j_1bnflin AS _lin
    INNER JOIN @it_pedidos_principal AS _pedidos_principal
    ON _pedidos_principal~refkey        = _lin~refkey
    AND ( _pedidos_principal~refitm     = _lin~refitm OR
          _pedidos_principal~refitm_aux = _lin~refitm )
    INTO TABLE @lt_lin.

    CHECK lt_lin IS NOT INITIAL.

    SELECT DISTINCT _doc~* FROM j_1bnfdoc AS _doc
    INNER JOIN @lt_lin AS _lin
    ON  _lin~docnum = _doc~docnum
    INTO TABLE @lt_doc.

*    SELECT _stx~* FROM j_1bnfstx AS _stx
*    INNER JOIN @lt_lin AS _lin
*    ON  _lin~docnum = _stx~docnum
*    AND _lin~itmnum = _stx~itmnum
*    INTO TABLE @lt_stx.

    IF ( lines( lt_doc ) > 0 ).
      SELECT _nfe_active~docnum,
             _nfe_active~regio,
             _nfe_active~nfyear,
             _nfe_active~nfmonth,
             _nfe_active~stcd1,
             _nfe_active~model,
             _nfe_active~serie,
             _nfe_active~nfnum9,
             _nfe_active~docnum9,
             _nfe_active~cdv
      FROM j_1bnfe_active AS _nfe_active
      INNER JOIN @lt_doc AS _doc
      ON _nfe_active~docnum = _doc~docnum
      INTO TABLE @lt_nfe_active.
    ENDIF.

    SELECT DISTINCT docnum, bukrs, branch
    FROM j_1bnfdoc AS _doc
    INNER JOIN @it_pedidos_principal AS _pedidos_principal
    ON  _pedidos_principal~in_br_nota_fiscal = _doc~docnum
    INTO TABLE @lt_doc_entrada.

    IF sy-subrc = 0.
      SELECT _lin~docnum, _lin~itmnum, _lin~bwkey, _lin~werks
      FROM j_1bnflin AS _lin
      INNER JOIN @lt_doc_entrada AS _doc_entrada
      ON  _doc_entrada~docnum = _lin~docnum
      INTO TABLE @lt_lin_entrada.
    ENDIF.

    LOOP AT lt_doc ASSIGNING FIELD-SYMBOL(<fs_j_1bnfdoc>).
      DATA(ls_j_1bnflin) = VALUE #( lt_lin[ mandt = <fs_j_1bnfdoc>-mandt docnum = <fs_j_1bnfdoc>-docnum ] OPTIONAL ).
      CHECK ls_j_1bnflin-docnum IS NOT INITIAL.
      READ TABLE it_pedidos_principal INTO DATA(ls_pedido_principal) WITH KEY refkey = ls_j_1bnflin-refkey refitm = ls_j_1bnflin-refitm BINARY SEARCH.
      IF sy-subrc <> 0.
        READ TABLE it_pedidos_principal INTO ls_pedido_principal WITH KEY refkey = ls_j_1bnflin-refkey refitm_aux = ls_j_1bnflin-refitm BINARY SEARCH.
      ENDIF.

      CHECK ls_pedido_principal-main_purchase_order IS NOT INITIAL.

      APPEND VALUE #( BASE CORRESPONDING #( ls_pedido_principal )
        j_1bnfdoc = <fs_j_1bnfdoc>
        j_1bnfe_active = VALUE #( lt_nfe_active[ docnum = <fs_j_1bnfdoc>-docnum ] OPTIONAL )
        j_1bnflin = FILTER #( lt_lin WHERE mandt = <fs_j_1bnfdoc>-mandt AND docnum = <fs_j_1bnfdoc>-docnum  )
*        j_1bnfstx = FILTER #( lt_stx WHERE mandt = <fs_j_1bnfdoc>-mandt AND docnum = <fs_j_1bnfdoc>-docnum  )
        doc_entrada = VALUE #( lt_doc_entrada[ docnum = ls_pedido_principal-in_br_nota_fiscal ] OPTIONAL )
        lin_entrada = FILTER #( lt_lin_entrada WHERE docnum = ls_pedido_principal-in_br_nota_fiscal  )
      ) TO rt_return.
    ENDLOOP.
    SORT rt_return BY main_purchase_order.

  ENDMETHOD.


  METHOD seleciona_pedidos_criar_nf.
    APPEND LINES OF pedidos_fornecedor_externo( )  TO rt_return.
    APPEND LINES OF transferencia_entre_centros( ) TO rt_return.
    SORT rt_return BY refkey refitm refitm_aux.
  ENDMETHOD.


  METHOD pedidos_fornecedor_externo.
    SELECT DISTINCT
           _hist_dep_fec~main_purchase_order,
           _hist_dep_fec~main_purchase_order_item,
           concat( _pedido_historico~belnr, _pedido_historico~gjahr ) AS refkey,
           _hist_dep_fec~main_purchase_order_item AS refitm,
           CAST( substring( _hist_dep_fec~main_purchase_order_item, 1, 4 ) AS NUMC ) AS refitm_aux,
           _pedido~lifnr,
           _fornecedor~regio,
           _hist_dep_fec~in_br_nota_fiscal
      FROM ztmm_his_dep_fec AS _hist_dep_fec
     INNER JOIN ekko AS _pedido
             ON _pedido~ebeln = _hist_dep_fec~main_purchase_order
            AND ( _pedido~bsart = 'NB' OR _pedido~bsart = 'ZMRP' OR _pedido~bsart = 'ZCOL' )
     INNER JOIN ekbe AS _pedido_historico
             ON _pedido_historico~ebeln = _hist_dep_fec~main_purchase_order
            AND _pedido_historico~ebelp = _hist_dep_fec~main_purchase_order_item
            AND _pedido_historico~vgabe = '2'
            AND _pedido_historico~bewtp = 'Q'
     INNER JOIN ekpo AS _item_pedido
             ON _item_pedido~ebeln = _pedido~ebeln
     INNER JOIN t001w AS _centros
             ON _centros~werks = _item_pedido~werks
            AND _centros~regio = 'MG'
      LEFT JOIN lfa1 AS _fornecedor
             ON _fornecedor~lifnr = _pedido~lifnr
     WHERE _hist_dep_fec~main_purchase_order IS NOT INITIAL
       AND _hist_dep_fec~process_step        = 'F06'
       AND _hist_dep_fec~rep_br_nota_fiscal  IS INITIAL
       AND _hist_dep_fec~in_br_nota_fiscal   IS NOT INITIAL
     ORDER BY
      _hist_dep_fec~main_purchase_order ASCENDING,
      _hist_dep_fec~main_purchase_order_item ASCENDING,
      refkey DESCENDING
    INTO TABLE @rt_return BYPASSING BUFFER.             "#EC CI_SEL_DEL

    IF sy-subrc = 0.
      DELETE ADJACENT DUPLICATES FROM rt_return COMPARING main_purchase_order main_purchase_order_item.
    ENDIF.
  ENDMETHOD.


  METHOD transferencia_entre_centros.
    SELECT DISTINCT
       _hist_dep_fec~main_purchase_order,
       _hist_dep_fec~main_purchase_order_item,
       concat( _pedido_historico~belnr, _pedido_historico~gjahr ) AS refkey,
       _pedido_historico~buzei AS refitm,
       _pedido_historico~buzei AS refitm_aux,
        _pedido~lifnr,
        _fornecedor~regio,
        _hist_dep_fec~in_br_nota_fiscal
    FROM ztmm_his_dep_fec AS _hist_dep_fec
    INNER JOIN ekko AS _pedido
    ON  _pedido~ebeln = _hist_dep_fec~main_purchase_order
    AND _pedido~bsart = 'UB'
    INNER JOIN ekbe AS _pedido_historico
    ON  _pedido_historico~ebeln = _hist_dep_fec~main_purchase_order
    AND _pedido_historico~ebelp = _hist_dep_fec~main_purchase_order_item
    AND _pedido_historico~vgabe = '1'
    AND _pedido_historico~bewtp = 'E'
    INNER JOIN ekpo AS _item_pedido
    ON _item_pedido~ebeln = _pedido~ebeln
    INNER JOIN t001w AS _centros
    ON _centros~werks = _item_pedido~werks
    AND _centros~regio = 'MG'
    LEFT JOIN lfa1 AS _fornecedor
    ON _fornecedor~lifnr = _pedido~lifnr
    WHERE _hist_dep_fec~main_purchase_order IS NOT INITIAL
      AND _hist_dep_fec~process_step = 'F06'
      AND _hist_dep_fec~rep_br_nota_fiscal IS INITIAL
      AND _hist_dep_fec~in_br_nota_fiscal IS NOT INITIAL
    ORDER BY
      _hist_dep_fec~main_purchase_order ASCENDING,
      _hist_dep_fec~main_purchase_order_item ASCENDING,
      refkey DESCENDING
    INTO TABLE @rt_return BYPASSING BUFFER.             "#EC CI_SEL_DEL
    IF sy-subrc = 0.
      DELETE ADJACENT DUPLICATES FROM rt_return COMPARING main_purchase_order main_purchase_order_item.
    ENDIF.
  ENDMETHOD.


  METHOD preenche_obj_header.
    rs_return = VALUE #(
      nftype = 'YA'
      doctyp = '1'
      direct = '1'
      model  = '55'  "verificar
      manual = 'X'
      waerk  = 'BRL'
      inco1  = 'SRF'
      inco2  = 'SRF'
      entrad = 'X'
      docstat = '1'
      observat = is_dados_pedido-j_1bnfdoc-nfenum && '-' && is_dados_pedido-j_1bnfdoc-series
      docref   = is_dados_pedido-j_1bnfdoc-docnum
      docdat   = is_dados_pedido-j_1bnfdoc-docdat
      pstdat   = is_dados_pedido-j_1bnfdoc-pstdat
      series   = is_dados_pedido-j_1bnfdoc-series
      parvw    = is_dados_pedido-j_1bnfdoc-parvw
      parid    = is_dados_pedido-j_1bnfdoc-parid
      parxcpdk = is_dados_pedido-j_1bnfdoc-parxcpdk
      partyp   = is_dados_pedido-j_1bnfdoc-partyp
      nfe      = is_dados_pedido-j_1bnfdoc-nfe
      nfenum   = is_dados_pedido-j_1bnfdoc-nfenum
      nfesrv   = is_dados_pedido-j_1bnfdoc-nfesrv
      conting  = is_dados_pedido-j_1bnfdoc-conting
      authcod  = is_dados_pedido-j_1bnfdoc-authcod
      xmlvers  = is_dados_pedido-j_1bnfdoc-xmlvers
      nfenrnr  = is_dados_pedido-j_1bnfdoc-nfenrnr
      authdate = is_dados_pedido-j_1bnfdoc-authdate
      authtime = is_dados_pedido-j_1bnfdoc-authtime
      bukrs    = is_dados_pedido-doc_entrada-bukrs
      branch   = is_dados_pedido-doc_entrada-branch
      access_key = is_dados_pedido-j_1bnfe_active-regio &&
                   is_dados_pedido-j_1bnfe_active-nfyear &&
                   is_dados_pedido-j_1bnfe_active-nfmonth &&
                   is_dados_pedido-j_1bnfe_active-stcd1  &&
                   is_dados_pedido-j_1bnfe_active-model  &&
                   is_dados_pedido-j_1bnfe_active-serie  &&
                   is_dados_pedido-j_1bnfe_active-nfnum9 &&
                   is_dados_pedido-j_1bnfe_active-docnum9 &&
                   is_dados_pedido-j_1bnfe_active-cdv
    ).
  ENDMETHOD.


  METHOD preencher_obj_partner.
    rt_return = VALUE #(
      ( parid = is_dados_pedido-lifnr
        parvw  = 'LF'
        partyp = 'V'
        xcpdk  = 'X' )
    ).
  ENDMETHOD.


  METHOD preencher_obj_item.
    rt_return = VALUE #( FOR ls_lin IN is_dados_pedido-j_1bnflin
    LET ls_lin_entrada = VALUE #(
      is_dados_pedido-lin_entrada[ docnum = is_dados_pedido-in_br_nota_fiscal itmnum = ls_lin-itmnum ] DEFAULT
      VALUE #( is_dados_pedido-lin_entrada[ docnum = is_dados_pedido-in_br_nota_fiscal itmnum = ls_lin-itmnum(5) ] DEFAULT
      VALUE #( is_dados_pedido-lin_entrada[ docnum = is_dados_pedido-in_br_nota_fiscal itmnum(5) = ls_lin-itmnum ] OPTIONAL
      ) ) )
    IN
    ( VALUE #(
      BASE CORRESPONDING #( ls_lin
        EXCEPT docnum mandt cfop cfop_10 bwkey werks refkey refitm xped nitemped num_item )
      taxsit  = '41'
      taxsi2  = '00005'
      taxlw1  = 'W61'
      taxlw2  = 'I55'
      netpr   = ls_lin-nfpri
      netwr   = ls_lin-nfnet
      bwkey   = ls_lin_entrada-bwkey
      werks   = ls_lin_entrada-werks
      cfop    = COND #( WHEN is_dados_pedido-regio = 'MG' THEN '1905' ELSE '2905' )
      cfop_10 = COND #( WHEN is_dados_pedido-regio = 'MG' THEN '1905AA' ELSE '2905AA' )
    ) ) ).
  ENDMETHOD.


  METHOD preencher_obj_item_tax.
    rt_return = VALUE #( FOR ls_lin IN is_dados_pedido-j_1bnflin
      ( VALUE #( itmnum = ls_lin-itmnum taxtyp = 'ICM0' othbas = ls_lin-nfnett ) )
      ( VALUE #( itmnum = ls_lin-itmnum taxtyp = 'IPI0' othbas = ls_lin-nfnett ) )
    ).
*    rt_return = VALUE #( FOR ls_stx IN is_dados_pedido-j_1bnfstx (
*      CORRESPONDING #( ls_stx EXCEPT docnum mandt )
*    ) ).
  ENDMETHOD.


  METHOD exec_bapi_nf_createfromdata.
    DATA:
      lt_return TYPE bapiret2_t.

    DATA(lt_obj_partner)  = it_obj_partner.
    DATA(lt_obj_item)     = it_obj_item.
    DATA(lt_obj_item_tax) = it_obj_item_tax.

    CALL FUNCTION 'BAPI_J_1B_NF_CREATEFROMDATA'
      EXPORTING
        obj_header     = is_obj_header
        obj_header_add = VALUE bapi_j_1bnfdoc_add( nfdec = '2' )
        nfcheck        = VALUE bapi_j_1bnfcheck( chekcon = abap_true )
      IMPORTING
        e_docnum       = rv_return
      TABLES
        obj_partner    = lt_obj_partner
        obj_item       = lt_obj_item
        obj_item_tax   = lt_obj_item_tax
        return         = lt_return
      EXCEPTIONS
        error_message  = 4.
    IF sy-subrc <> 0 OR rv_return IS INITIAL OR rv_return = 0000000000.
      RETURN.
    ENDIF.
    CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
      EXPORTING
        wait = abap_true.
  ENDMETHOD.
ENDCLASS.
