CLASS zclmm_cockpit_transf DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    "! Método que realiza processo em background
    "! @parameter P_TASK        | Parâmentro standard
    METHODS task_finish
      IMPORTING
        !p_task TYPE clike .
    "! Método principal
    "! @parameter IS_INPUT        | Dados para criação da ordem
    "! @parameter RT_RETURN       | Mensagem de retorno
    METHODS exec_transf
      IMPORTING
        !is_input        TYPE zssd_ordem_intercompany
        !is_continuar    TYPE char1
      RETURNING
        VALUE(rt_return) TYPE bapiret2_t .
    "! Método principal
    "! @parameter IV_PURCHASEORDER        | Dados para criação da ordem
    "! @parameter RT_RETURN       | Mensagem de retorno
    METHODS exec_outb_delivery
      IMPORTING
        !iv_purchaseorder TYPE ebeln
        !is_input         TYPE zssd_ordem_intercompany
      RETURNING
        VALUE(rt_return)  TYPE bapiret2_t .
    "! Método principal
    "! @parameter IV_DELIVERY     | Dados para criação da ordem
    "! @parameter RT_RETURN       | Mensagem de retorno
    METHODS exec_deliv_update
      IMPORTING
        !iv_delivery     TYPE vbeln_vl
      RETURNING
        VALUE(rt_return) TYPE bapiret2_t .
    "! Método principal
    "! @parameter IV_ACCKEY       | Dados para criação da ordem
    "! @parameter RT_RETURN       | Mensagem de retorno
    METHODS exec_entr_merc_transf
      IMPORTING
        !iv_acckey       TYPE /xnfe/id
        !iv_docnum       TYPE char10
      RETURNING
        VALUE(rt_return) TYPE bapiret2_t .
    "! Método principal
    "! @parameter IS_INPUT        | Dados para criação da ordem
    "! @parameter RT_RETURN       | Mensagem de retorno
    METHODS exec_2_steps
      IMPORTING
        !is_input        TYPE zssd_ordem_intercompany
      RETURNING
        VALUE(rt_return) TYPE bapiret2_t .
    "! Método principal
    "! @parameter IV_ACCKEY       | Dados para criação da ordem
    "! @parameter RT_RETURN       | Mensagem de retorno
    METHODS exec_lanc_entr_merc_grc
      IMPORTING
        !iv_acckey       TYPE /xnfe/id
        !iv_docnum       TYPE char10
      RETURNING
        VALUE(rt_return) TYPE bapiret2_t .
    "! Método principal
    "! @parameter IS_INPUT       | Dados para criação da ordem
    "! @parameter RT_RETURN      | Mensagem de retorno
    METHODS exec_lanc_entr_merc IMPORTING !is_input        TYPE zssd_ordem_intercompany
                                RETURNING VALUE(rt_return) TYPE bapiret2_t .
    "! Método para checar Lançamento de Entrada de Mercadorias
    "! @parameter IV_PURCHASEORDER | Pedido de compras
    "! @parameter RT_RETURN        | Mensagem de retorno
    METHODS check_lanc_entr_merc
      IMPORTING
        !iv_purchaseorder TYPE ebeln
      RETURNING
        VALUE(rt_return)  TYPE bapiret2_t .
    "! Método principal
    "! @parameter IV_ACCKEY       | Dados para criação da ordem
    "! @parameter RT_RETURN       | Mensagem de retorno
    METHODS exec_lanc_fat_receb_grc
      IMPORTING
        !iv_acckey       TYPE /xnfe/id
        !iv_docnum       TYPE char10
      RETURNING
        VALUE(rt_return) TYPE bapiret2_t .
    "! Método principal
    "! @parameter IS_INPUT       | Dados para criação da ordem
    "! @parameter RT_RETURN      | Mensagem de retorno
    METHODS exec_lanc_fat_receb IMPORTING !is_input        TYPE zssd_ordem_intercompany
                                RETURNING VALUE(rt_return) TYPE bapiret2_t .
    "! Método para checar Lançamento de Entrada de Fatura
    "! @parameter IV_PURCHASEORDER | Pedido de compras
    "! @parameter RT_RETURN        | Mensagem de retorno
    METHODS check_lanc_fat_receb
      IMPORTING
        !iv_purchaseorder TYPE ebeln
      RETURNING
        VALUE(rt_return)  TYPE bapiret2_t .
    "! Método principal
    "! @parameter IS_INPUT        | Dados para criação da ordem
    "! @parameter RT_RETURN       | Mensagem de retorno
    METHODS exec_po_intercompany
      IMPORTING
        !is_input         TYPE zssd_ordem_intercompany
      EXPORTING
        !ev_purchaseorder TYPE ebeln
      RETURNING
        VALUE(rt_return)  TYPE bapiret2_t .
    "! Método principal
    "! @parameter iv_salesorder        | OV
    "! @parameter iv_purchaseorder     | Pedido
    "! @parameter RT_RETURN       | Mensagem de retorno
    METHODS exec_so_intercompany
      IMPORTING
        !iv_salesorder    TYPE vbeln
        !iv_purchaseorder TYPE ebeln
      RETURNING
        VALUE(rt_return)  TYPE bapiret2_t .
    METHODS deposito_fechado
      IMPORTING
        !is_header  TYPE j_1bnfdoc
        !it_nflin   TYPE j_1bnflin_tab
        !it_partner TYPE j_1b_tt_nfnad
      CHANGING
        !cs_doc     TYPE j_1bnf_badi_header
        !ct_lin     TYPE j_1bnf_badi_item_tab .
    "! Método para DANFE
    METHODS danfe_deposito_fechado
      IMPORTING
        !is_header  TYPE j_1bnfdoc
        !it_nflin   TYPE j_1bnflin_tab
        !it_partner TYPE nfe_partner_tab
        !it_hdr_msg TYPE j_1bnfftx_tab
      CHANGING
        !ct_inf_add TYPE tsftext .
    METHODS valida_centro
      IMPORTING
        !iv_centro1             TYPE werks_d
        !iv_centro2             TYPE werks_d
      RETURNING
        VALUE(rv_mesma_empresa) TYPE boole_d .
    METHODS deposito_fechado_xml
      IMPORTING
        !it_doc TYPE j_1bnfdoc
        !it_lin TYPE j_1bnflin .
  PROTECTED SECTION.
  PRIVATE SECTION.

    TYPES:
      BEGIN OF ty_lips,
        vbeln TYPE vbeln_vl,
        posnr TYPE posnr_vl,
        matnr TYPE matnr,
        werks TYPE werks,
        charg TYPE charg_d,
        bwtar TYPE bwtar_d,
        uecha TYPE uecha,
      END OF ty_lips .
    TYPES:
      BEGIN OF ty_itens_pedido,
        vbeln       TYPE vbeln_vl,
        posnr       TYPE posnr_vl,
        matnr       TYPE matnr,
        charg       TYPE charg_d,
        bwtar       TYPE bwtar_d,
        werks       TYPE werks_d,
        tax_code    TYPE mwskz,
        uecha       TYPE uecha,
        lfimg       TYPE lfimg,
        vrkme       TYPE vrkme,
        vgbel       TYPE vgbel,
        vgpos       TYPE vgpos,
        cond_value  TYPE  bapikbetr1,    "Montante de condição
        currency    TYPE waers,       "Código da moeda
        cond_unit   TYPE kmein,       "Unidade de medida da condição
        cond_p_unt  TYPE kpein,       "Unidade de preço da condição
        condbaseval TYPE bapikawrt1,
        po_unit     TYPE bstme,
        price_unit  TYPE epein,
        net_price   TYPE bapicurext,
      END OF ty_itens_pedido .
    TYPES:
      BEGIN OF ty_helper_type_line,
        vbeln TYPE lips-vbeln,
        posnr TYPE lips-posnr,
        matnr TYPE lips-matnr,
        charg TYPE lips-charg,
        bwtar TYPE lips-bwtar,
        uecha TYPE lips-uecha,
        lfimg TYPE lips-lfimg,
        meins TYPE lips-meins,
        vrkme TYPE lips-vrkme,
        vgbel TYPE lips-vgbel,
        vgpos TYPE lips-vgpos,
      END OF ty_helper_type_line .
    TYPES:
      ty_helper_type TYPE TABLE OF ty_helper_type_line WITH EMPTY KEY .

    CONSTANTS:
      BEGIN OF gc_const,
        ub   TYPE esart VALUE 'UB',
        nb   TYPE esart VALUE 'NB',
        zcol TYPE esart VALUE 'ZCOL',
      END OF gc_const .
    DATA gv_continuar TYPE char1 .
    DATA gv_wait_async TYPE xfeld .
    DATA gs_poheader TYPE bapimepoheader .
    DATA gs_poheaderx TYPE bapimepoheaderx .
    DATA:
      gt_poitem       TYPE TABLE OF bapimepoitem .
    DATA:
      gt_poitemx      TYPE TABLE OF bapimepoitemx .
    DATA:
      gt_poschedule   TYPE TABLE OF bapimeposchedule .
    DATA:
      gt_poschedulex  TYPE TABLE OF bapimeposchedulx .
    DATA:
      gt_popartner    TYPE TABLE OF bapiekkop .
    DATA:
      gt_potextheader TYPE TABLE OF bapimepotextheader .
    DATA:
      gt_pocond       TYPE TABLE OF bapimepocond .
    DATA:
      gt_pocondx      TYPE TABLE OF bapimepocondx .
    DATA:
      gt_mbew         TYPE TABLE OF mbew .
    DATA:       "is_input        TYPE zssd_ordem_intercompany,
      gt_prott        TYPE TABLE OF prott .
    DATA gv_purchaseorder TYPE ebeln .
    DATA gv_delivery TYPE vbeln_vl .
    DATA:
      gt_lips          TYPE TABLE OF ty_lips .
    DATA gt_return TYPE bapiret2_t .
    DATA:
      gt_itens_pedido TYPE TABLE OF ty_itens_pedido .

    "! Método para seleção dos dados
    METHODS exec_po_create
      IMPORTING
        !is_input     TYPE zssd_ordem_intercompany
        !is_continuar TYPE char1 OPTIONAL .
    "! Método para seleção dos dados
    METHODS set_header
      IMPORTING
        !is_input TYPE zssd_ordem_intercompany .
    "! Método para seleção dos dados
    METHODS set_partner
      IMPORTING
        !is_input TYPE zssd_ordem_intercompany .
    "! Método para seleção dos dados
    METHODS set_items
      IMPORTING
        !is_input TYPE zssd_ordem_intercompany .
    "! Método para seleção dos dados
    METHODS set_text
      IMPORTING
        !is_input TYPE zssd_ordem_intercompany .
    "! Método para seleção dos dados
    METHODS set_schedule
      IMPORTING
        !is_input TYPE zssd_ordem_intercompany .
    "! Método para seleção dos dados
    METHODS set_header_inter
      IMPORTING
        !is_input TYPE zssd_ordem_intercompany .
    "! Método para seleção dos dados
    METHODS set_items_inter
      IMPORTING
        !is_input TYPE zssd_ordem_intercompany .
    "! Método para seleção dos dados
    METHODS set_schedule_inter
      IMPORTING
        !is_input TYPE zssd_ordem_intercompany .
    "! Método para seleção dos dados
    METHODS set_cond_inter
      IMPORTING
        !is_input TYPE zssd_ordem_intercompany .
    "! Método para seleção dos dados
    METHODS get_iva
      IMPORTING
        !is_input        TYPE zssd_ordem_intercompany
        !is_item         TYPE zssd_ordem_inter_items
      RETURNING
        VALUE(rv_return) TYPE j_1btxsdc_ .
    "! Método seleção na tabela de parâmetro
    "! @parameter IV_CHAVE1        | Dados da chave 1
    "! @parameter IV_CHAVE2        | Dados da chave 2
    "! @parameter IV_CHAVE3        | Dados da chave 3
    "! @parameter RV_RETURN        | valor do parâmentro
    METHODS get_parametro
      IMPORTING
        !iv_chave1       TYPE ze_param_chave OPTIONAL
        !iv_chave2       TYPE ze_param_chave OPTIONAL
        !iv_chave3       TYPE ze_param_chave OPTIONAL
      RETURNING
        VALUE(rv_return) TYPE ze_param_low .
    METHODS read_mbew
      IMPORTING
        !is_input        TYPE zssd_ordem_intercompany
        !is_item         TYPE zssd_ordem_inter_items
      RETURNING
        VALUE(rs_result) TYPE mbew .
    METHODS get_mbew
      IMPORTING
        !is_input TYPE zssd_ordem_intercompany .
    METHODS get_original
      IMPORTING
        !iv_material     TYPE matnr
      RETURNING
        VALUE(rv_result) TYPE ty_lips .
    METHODS deposito_fechado_entrega
      IMPORTING
        !iv_werks_receptor TYPE werks_d
      CHANGING
        !cs_entrega        TYPE j_1bnf_badi_header.
    METHODS deposito_fechado_retirada
      IMPORTING
        !iv_werks_origem TYPE werks_d
      CHANGING
        !cs_retirada     TYPE j_1bnf_badi_header .
    METHODS deposito_fechado_text
      IMPORTING
        !iv_werks_origem   TYPE werks_d
        !iv_werks_receptor TYPE werks_d
        !is_header         TYPE j_1bnfdoc
        !is_item           TYPE j_1bnflin
        !it_partner        TYPE nfe_partner_tab
      CHANGING
        !cs_nfdoc          TYPE j_1bnf_badi_header.
    METHODS deposito_fechado_cest
      IMPORTING
        !is_header TYPE j_1bnfdoc
        !it_nfitem TYPE j_1bnflin_tab
      CHANGING
        !cs_nfdoc  TYPE j_1bnf_badi_header .
    METHODS itens_lote
      IMPORTING
        !is_item         TYPE ty_itens_pedido
        !it_lips         TYPE ty_helper_type
      RETURNING
        VALUE(rv_result) LIKE gt_itens_pedido .
    METHODS check_line
      CHANGING
        !ct_inf_add TYPE tsftext
        !cv_infcomp TYPE j1b_nf_xml_header-infcomp .
    METHODS deposito_fechado_entrega_xml
      IMPORTING
        !iv_werks_receptor TYPE werks_d
      CHANGING
        !cs_entrega        TYPE j1b_nf_xml_header .
    METHODS deposito_fechado_retirada_xml
      IMPORTING
        !iv_werks_origem TYPE werks_d
      CHANGING
        !cs_retirada     TYPE j1b_nf_xml_header .
    METHODS deposito_fechado_text_xml
      IMPORTING
        !iv_werks_origem   TYPE werks_d
        !iv_werks_receptor TYPE werks_d
        !is_header         TYPE j_1bnfdoc
        !is_item           TYPE j_1bnflin
        !it_partner        TYPE nfe_partner_tab
      CHANGING
        !cs_xmlh           TYPE j1b_nf_xml_header
        !ct_inf_add        TYPE tsftext OPTIONAL .
    METHODS deposito_fechado_cest_xml
      IMPORTING
        !is_header TYPE j_1bnfdoc
        !it_nfitem TYPE j_1bnflin_tab
      CHANGING
        !cs_xmlh   TYPE j1b_nf_xml_header .
ENDCLASS.



CLASS ZCLMM_COCKPIT_TRANSF IMPLEMENTATION.


  METHOD exec_transf.

    DATA(ls_input) = is_input.

    exec_po_create( is_input     = ls_input
                    is_continuar = is_continuar ).

    IF is_continuar EQ abap_true.
      FREE ls_input.

      SELECT SINGLE FROM ztsd_intercompan
        FIELDS guid,
               processo,
               tipooperacao   AS tipo_operacao,
               werks_origem   AS centro_fornecedor,
               lgort_origem   AS deposito_origem,
               werks_destino  AS centro_destino,
               lgort_destino  AS deposito_destino,
               werks_receptor AS centro_receptor,
               tpfrete        AS modalidade_frete,
               agfrete        AS agente_frete,
               tpexp          AS tipo_exped,
               condexp        AS cond_exped
        WHERE purchaseorder EQ @gv_purchaseorder
        INTO CORRESPONDING FIELDS OF @ls_input.
    ENDIF.

    exec_outb_delivery( EXPORTING iv_purchaseorder = gv_purchaseorder
                                  is_input         = ls_input ).

    rt_return[] = gt_return[].

  ENDMETHOD.


  METHOD set_header.

    FREE: gs_poheader,
          gs_poheaderx.

    IF gv_continuar IS INITIAL. "se não é segunda etapa do processo de intercompany
      DATA(lv_supplier) = |{ CONV lifnr_wk( is_input-centro_fornecedor ) ALPHA = IN }| .

      gs_poheader = VALUE #(
        doc_type   = gc_const-ub
        creat_date = sy-datum
        vendor     = lv_supplier
        langu      = sy-langu
*      LANGU_ISO
        purch_org  = is_input-org_compras
        pur_group  = is_input-grp_comp
        doc_date   = sy-datum
      ).

      gs_poheaderx = VALUE #(
        doc_type   = abap_true
        creat_date = abap_true
        vendor     = abap_true
        langu      = abap_true
*      LANGU_ISO  = abap_true
        purch_org  = abap_true
        pur_group  = abap_true
        doc_date   = abap_true
      ).


      SELECT SINGLE companycode,
                    @abap_true
        FROM i_suppliercompanybyplant
        INTO (@gs_poheader-comp_code, @gs_poheaderx-comp_code)
        WHERE plant    = @is_input-centro_fornecedor
          AND supplier = @lv_supplier.

    ELSE. "se é segunda etapa intercompany
      DATA(lv_supplier2) = |{ CONV lifnr_wk( is_input-centro_destino ) ALPHA = IN }| .

      gs_poheader = VALUE #(
        doc_type   = gc_const-ub
        creat_date = sy-datum
        vendor     = lv_supplier2
        langu      = sy-langu
*      LANGU_ISO
        purch_org  = is_input-org_compras
        pur_group  = is_input-grp_comp
        doc_date   = sy-datum
      ).

      gs_poheaderx = VALUE #(
        doc_type   = abap_true
        creat_date = abap_true
        vendor     = abap_true
        langu      = abap_true
*      LANGU_ISO  = abap_true
        purch_org  = abap_true
        pur_group  = abap_true
        doc_date   = abap_true
      ).


      SELECT SINGLE companycode,
                    @abap_true
        FROM i_suppliercompanybyplant
        INTO (@gs_poheader-comp_code, @gs_poheaderx-comp_code)
        WHERE plant    = @is_input-centro_destino
          AND supplier = @lv_supplier2.
    ENDIF.
  ENDMETHOD.


  METHOD set_partner.

    FREE gt_popartner.

    IF is_input-tipo_operacao NE 'TRA2'.
      RETURN.
    ENDIF.

    IF is_input-centro_receptor IS INITIAL.
      RETURN.
    ENDIF.

*    DATA(lv_deposito_fechado) = get_parametro( '' ).
*
*    IF is_input-centro_receptor NE lv_deposito_fechado.
*      RETURN.
*    ENDIF.
    DATA(lv_supplier) = |{ CONV lifnr_wk( is_input-centro_receptor ) ALPHA = IN }| .

    gt_popartner = VALUE #(
      ( partnerdesc = get_parametro( iv_chave3 = 'FUNCPARC' )
        buspartno   = lv_supplier
        langu       = sy-langu ) ).
  ENDMETHOD.


  METHOD set_items.

    FREE: gt_poitem,
          gt_poitemx.

    IF gv_continuar IS INITIAL. "se não é segunda etapa do processo de intercompany
      IF  is_input-tipo_operacao  EQ 'TRA7'
      AND is_input-remessa_origem IS NOT INITIAL.
        SELECT vbeln,
               posnr,
               matnr,
               werks,
               charg,
               bwtar,
               uecha
          FROM lips
          WHERE vbeln EQ @is_input-remessa_origem
          ORDER BY PRIMARY KEY
          INTO TABLE @DATA(lt_lips).

        LOOP AT lt_lips ASSIGNING FIELD-SYMBOL(<fs_lips>).
          CHECK <fs_lips>-uecha IS INITIAL.
          APPEND <fs_lips> TO gt_lips.
        ENDLOOP.

        SORT lt_lips BY uecha.

        LOOP AT gt_lips ASSIGNING FIELD-SYMBOL(<fs_lips1>).
          READ TABLE lt_lips INTO DATA(ls_lips)
            WITH KEY uecha = <fs_lips1>-posnr BINARY SEARCH.
          CHECK sy-subrc EQ 0.
          <fs_lips1>-werks = ls_lips-werks.
          <fs_lips1>-charg = ls_lips-charg.
          <fs_lips1>-bwtar = ls_lips-bwtar.
        ENDLOOP.
        SORT gt_lips BY matnr.
      ENDIF.

      gt_poitem = VALUE #( FOR ls_item IN is_input-itens INDEX INTO lv_index
        LET lv_item  = CONV ebelp( lv_index * 10 )
            ls_original  = get_original( ls_item-material )

        IN ( po_item     = lv_item
             material    = ls_item-material
             plant       = is_input-centro_destino
             stge_loc    = is_input-deposito_destino
             quantity    = ls_item-quantidade
             po_unit     = ls_item-unidade
             val_type    = ls_original-bwtar
             batch       = ls_original-charg
             gi_based_gr = COND #( WHEN ls_original-bwtar IS INITIAL THEN abap_true )
             ret_item    = COND #( WHEN is_input-tipo_operacao EQ 'TRA7' THEN abap_true )
             part_deliv  = 'A'
      ) ).

      gt_poitemx = VALUE #( FOR ls_poitem IN gt_poitem (
        po_item     = ls_poitem-po_item
        po_itemx    = abap_true
        material    = abap_true
        plant       = abap_true
        stge_loc    = abap_true
        quantity    = abap_true
        po_unit     = abap_true
        val_type    = COND #( WHEN ls_poitem-val_type IS NOT INITIAL THEN abap_true )
        batch       = COND #( WHEN ls_poitem-batch IS NOT INITIAL THEN abap_true )
        gi_based_gr = ls_poitem-gi_based_gr
        ret_item    = ls_poitem-ret_item
        part_deliv  = abap_true
      ) ).
    ELSE.
      IF is_input-tipo_operacao EQ 'INT4'.
        SELECT SINGLE purchaseorder
               INTO @DATA(lv_pedido_orig)
        FROM ztsd_intercompan
        WHERE guid = @is_input-guid.

        IF NOT lv_pedido_orig IS INITIAL.
          SELECT ebeln,
                 ebelp,
                 matnr,
                 menge,
                 meins,
                 bwtar
          FROM ekpo
           INTO TABLE @DATA(lt_ekpo)
          WHERE ebeln = @lv_pedido_orig.

*          DATA(lv_stge_loc) = get_parametro(
*          iv_chave1 = 'PED_INTER_ESP_SANTO'
*          iv_chave2 = 'DEP_ENT_INTER_ES'
*        ).

          IF NOT lt_ekpo IS INITIAL.
            gt_poitem = VALUE #( FOR ls_item2 IN lt_ekpo INDEX INTO lv_index
                LET lv_item2  =  ls_item2-ebelp
*                     ls_original  = get_original( ls_item-material )

                IN ( po_item     = lv_item2
                     material    = ls_item2-matnr
                     plant       = is_input-centro_receptor
*                     stge_loc   = COND #( WHEN is_input-processo = '2' AND is_input-tipo_operacao = 'INT4'
*                                  THEN lv_stge_loc
*                                  ELSE is_input-deposito_destino
*                                  )
                     stge_loc   = is_input-deposito_destino
                     quantity    = ls_item2-menge
                     po_unit     = ls_item2-meins
*                      val_type    = ls_original-bwtar
*                      batch       = ls_original-charg
              ) ).

            gt_poitemx = VALUE #( FOR ls_poitem IN gt_poitem (
              po_item     = ls_poitem-po_item
              po_itemx    = abap_true
              material    = abap_true
              plant       = abap_true
              stge_loc    = abap_true
              quantity    = abap_true
              po_unit     = abap_true
*                 val_type    = COND #( WHEN ls_poitem-val_type IS NOT INITIAL THEN abap_true )
*                 batch       = COND #( WHEN ls_poitem-batch IS NOT INITIAL THEN abap_true )
            ) ).
          ENDIF.
        ENDIF.
      ENDIF.
    ENDIF.
  ENDMETHOD.


  METHOD set_schedule.

    FREE: gt_poschedule,
          gt_poschedulex.

    IF gv_continuar IS INITIAL."se não é segunda etapa processo intercompany
      gt_poschedule = VALUE #( FOR ls_item IN is_input-itens INDEX INTO lv_index
        LET lv_item = CONV ebelp( lv_index * 10 )
        IN ( po_item       = lv_item
             sched_line    = 1
             delivery_date = sy-datum
             stat_date     = sy-datum
             quantity      = ls_item-quantidade ) ).

      gt_poschedulex = VALUE bapimeposchedulx_tp(
        FOR ls_poschedule IN gt_poschedule (
          po_item       = ls_poschedule-po_item
          sched_line    = ls_poschedule-sched_line
          po_itemx      = abap_true
          delivery_date = abap_true
          quantity      = abap_true
          stat_date     = abap_true ) ).
    ELSE.

      gt_poschedule = VALUE #( FOR ls_item_po IN gt_poitem INDEX INTO lv_index
        LET lv_item = ls_item_po-po_item
        IN ( po_item       = lv_item
             sched_line    = 1
             delivery_date = sy-datum
             stat_date     = sy-datum
             quantity      = ls_item_po-quantity ) ).

      gt_poschedulex = VALUE bapimeposchedulx_tp(
        FOR ls_poschedule IN gt_poschedule (
          po_item       = ls_poschedule-po_item
          sched_line    = ls_poschedule-sched_line
          po_itemx      = abap_true
          delivery_date = abap_true
          quantity      = abap_true
          stat_date     = abap_true ) ).
    ENDIF.
  ENDMETHOD.


  METHOD get_parametro.

    DATA(lv_chave1) = COND #( WHEN iv_chave1 IS NOT INITIAL THEN iv_chave1 ELSE 'TRANSFERENCIA' ).
    DATA(lv_chave2) = COND #( WHEN iv_chave2 IS NOT INITIAL THEN iv_chave2 ELSE 'DEPOSITO_FECHADO' ).
    DATA(lv_chave3) = COND #( WHEN iv_chave3 IS NOT INITIAL THEN iv_chave3 ).

    SELECT SINGLE low
      INTO rv_return
      FROM ztca_param_val
      WHERE modulo = 'MM'
        AND chave1 = lv_chave1
        AND chave2 = lv_chave2
        AND chave3 = lv_chave3.

  ENDMETHOD.


  METHOD set_text.

    FREE gt_potextheader.

    gt_potextheader = VALUE #( text_id = 'F01' text_form  = '*'
      ( text_line  = |{ TEXT-001 }: { is_input-tipo_operacao }| )
      ( text_line  = |{ TEXT-002 }: { is_input-centro_fornecedor }| )
      ( text_line  = |{ TEXT-003 }: { is_input-centro_destino }| )
      ( text_line  = |{ TEXT-004 }: { is_input-centro_receptor }| )
      ( text_line  = |{ TEXT-005 }: { is_input-deposito_origem }| )
      ( text_line  = |{ TEXT-006 }: { is_input-deposito_destino }| )
      ( text_line  = |{ TEXT-007 }: { is_input-org_compras }| )
      ( text_line  = |{ TEXT-008 }: { is_input-grp_comp }| )
    ).

  ENDMETHOD.


  METHOD exec_outb_delivery.

    IF iv_purchaseorder IS INITIAL.
      RETURN.
    ENDIF.

    FREE gv_wait_async.

    SELECT SINGLE FROM ekko
      FIELDS aedat
      WHERE ebeln EQ @iv_purchaseorder
      INTO @DATA(lv_due_date).

    DATA(lt_stock_trans_items) = VALUE /accgo/oe_tt_bapi_dlvr_sto(
      ( ref_doc = iv_purchaseorder ) ).

    IF is_input-agente_frete IS NOT INITIAL.
*      DATA(lv_agente_frete) = |{ CONV lifnr_wk( is_input-agente_frete ) ALPHA = IN }| .
      DATA(lt_agente_frete) = VALUE /spe/bapidlvpartnerchg_t(
        ( upd_mode_partn = 'I' partn_role = 'SP' partner_no = is_input-agente_frete ) ).
    ENDIF.

    CALL FUNCTION 'ZFMMM_OUTB_DELIV_CREATE'
      STARTING NEW TASK 'OUTB_DELIV_CREATE'
      CALLING task_finish ON END OF TASK
      EXPORTING
        iv_due_date          = lv_due_date
        iv_guid              = is_input-guid
        iv_input             = is_input
      TABLES
        it_stock_trans_items = lt_stock_trans_items
        it_header_partner    = lt_agente_frete.

    WAIT FOR ASYNCHRONOUS TASKS UNTIL gv_wait_async IS NOT INITIAL.

*    CHECK gv_delivery IS NOT INITIAL.
*
*    UPDATE ztsd_intercompan SET remessa = gv_delivery
*      WHERE guid = is_input-guid.

  ENDMETHOD.


  METHOD exec_deliv_update.

    IF iv_delivery IS INITIAL.
      RETURN.
    ENDIF.

    FREE gv_wait_async.

    SELECT FROM lips
      FIELDS vbeln,
             posnr,
             charg,
             lfimg
      WHERE vbeln = @iv_delivery
      INTO TABLE @DATA(lt_lips).
    IF sy-subrc NE 0.
      RETURN.
    ENDIF.

    DATA(ls_vbkok) = VALUE vbkok(
      vbeln_vl = iv_delivery
      vbeln    = iv_delivery
      kzntg    = abap_true
      wabuc    = abap_true ).

    DATA(lt_vbpok) = VALUE vbpok_t(
      FOR ls_lips IN lt_lips (
        vbeln_vl = ls_lips-vbeln
        posnr_vl = ls_lips-posnr
        vbeln    = ls_lips-vbeln
        posnn    = ls_lips-posnr
        charg    = ls_lips-charg
        pikmg    = ls_lips-lfimg ) ).

    CALL FUNCTION 'ZFMMM_DELIVERY_UPDATE'
      STARTING NEW TASK 'DELIVERY_UPDATE'
      CALLING task_finish ON END OF TASK
      EXPORTING
        is_vbkok_wa       = ls_vbkok
        iv_synchron       = abap_true
        iv_delivery       = iv_delivery
        iv_update_picking = abap_true
        iv_nicht_sperren  = abap_true
        iv_commit         = abap_true
      TABLES
        it_vbpok_tab      = lt_vbpok.

    WAIT FOR ASYNCHRONOUS TASKS UNTIL gv_wait_async IS NOT INITIAL.

    rt_return[] = gt_return[].

  ENDMETHOD.


  METHOD exec_entr_merc_transf.

    FREE gv_wait_async.

    CALL FUNCTION 'ZFMMM_ENTR_MERC_TRANSF'
      STARTING NEW TASK 'ENTR_MERC_TRANSF'
      CALLING task_finish ON END OF TASK
      EXPORTING
        iv_nfeid  = iv_acckey
        iv_docnum = iv_docnum.

    WAIT FOR ASYNCHRONOUS TASKS UNTIL gv_wait_async IS NOT INITIAL.

    rt_return[] = gt_return[].

  ENDMETHOD.


  METHOD exec_lanc_entr_merc_grc.

    FREE gv_wait_async.

    CALL FUNCTION 'ZFMMM_LANC_ENTR_MERC_GRC'
      STARTING NEW TASK 'LANC_ENTR_MERC_GRC'
      CALLING task_finish ON END OF TASK
      EXPORTING
        iv_nfeid  = iv_acckey
        iv_docnum = iv_docnum.

    WAIT FOR ASYNCHRONOUS TASKS UNTIL gv_wait_async IS NOT INITIAL.

    rt_return[] = gt_return[].

  ENDMETHOD.


  METHOD exec_lanc_entr_merc.

    FREE gv_wait_async.

    SELECT SINGLE FROM j_1bnfdoc
      FIELDS docnum,
             docdat,
             nfenum,
             series
      WHERE docnum EQ @is_input-nota_saida
      INTO @DATA(ls_doc).
    IF sy-subrc NE 0.
      RETURN.
    ENDIF.

    SELECT FROM ekpo
      FIELDS ebeln,
             ebelp,
             matnr,
             werks,
             lgort,
             menge,
             meins
      WHERE ebeln EQ @is_input-pedido1
      INTO TABLE @DATA(lt_ekpo).
    IF sy-subrc NE 0.
      RETURN.
    ENDIF.

    DATA(ls_goodsmvt_header) = VALUE bapi2017_gm_head_01(
      pstng_date = sy-datum
      doc_date   = ls_doc-docdat
      ref_doc_no = COND #( WHEN ls_doc-series IS INITIAL THEN ls_doc-nfenum
                           ELSE |{ ls_doc-nfenum }-{ ls_doc-series }| ) ).

    DATA(lt_goodsmvt_item) = VALUE bapi2017_gm_item_create_t(
      FOR ls_ekpo IN lt_ekpo ( material  = ls_ekpo-matnr
                               plant     = ls_ekpo-werks
                               stge_loc  = ls_ekpo-lgort
                               move_type = '101'
                               entry_qnt = ls_ekpo-menge
                               entry_uom = ls_ekpo-meins
                               po_number = ls_ekpo-ebeln
                               po_item   = ls_ekpo-ebelp
                               mvt_ind   = 'B' ) ).

    CALL FUNCTION 'ZFMMM_LANC_ENTR_MERC'
      STARTING NEW TASK 'LANC_ENTR_MERC'
      CALLING task_finish ON END OF TASK
      EXPORTING
        is_goodsmvt_header = ls_goodsmvt_header
        iv_goodsmvt_code   = '01'
      TABLES
        it_goodsmvt_item   = lt_goodsmvt_item.

    WAIT FOR ASYNCHRONOUS TASKS UNTIL gv_wait_async IS NOT INITIAL.

    rt_return[] = gt_return[].

  ENDMETHOD.


  METHOD exec_lanc_fat_receb_grc.

    FREE gv_wait_async.

    CALL FUNCTION 'ZFMMM_LANC_FAT_RECEB_GRC'
      STARTING NEW TASK 'LANC_FAT_RECEB_GRC'
      CALLING task_finish ON END OF TASK
      EXPORTING
        iv_nfeid  = iv_acckey
        iv_docnum = iv_docnum.

    WAIT FOR ASYNCHRONOUS TASKS UNTIL gv_wait_async IS NOT INITIAL.

    rt_return[] = gt_return[].

  ENDMETHOD.


  METHOD exec_lanc_fat_receb.

    FREE gv_wait_async.

    SELECT SINGLE FROM j_1bnfdoc
      FIELDS docnum,
             docdat,
             nfenum,
             series,
             nftot
      WHERE docnum EQ @is_input-nota_saida
      INTO @DATA(ls_doc).
    IF sy-subrc NE 0.
      RETURN.
    ENDIF.

    SELECT SINGLE FROM ekko
      FIELDS ebeln,
             bukrs,
             waers,
             zterm
      WHERE ebeln EQ @is_input-pedido1
      INTO @DATA(ls_ekko).
    IF sy-subrc NE 0.
      RETURN.
    ENDIF.

    SELECT FROM ekpo
      FIELDS ebeln,
             ebelp,
             mwskz,
             netwr,
             menge,
             meins
      WHERE ebeln EQ @is_input-pedido1
      INTO TABLE @DATA(lt_ekpo).
    IF sy-subrc NE 0.
      RETURN.
    ENDIF.

    SELECT ekbe~ebeln,
           ekbe~ebelp,
           ekbe~zekkn,
           ekbe~gjahr,
           ekbe~belnr,
           ekbe~buzei,
           mseg~mjahr AS ano_estorno,
           mseg~mblnr AS doc_estorno,
           mseg~zeile AS itm_estorno
      FROM ekbe
      LEFT JOIN mseg
        ON mseg~sjahr = ekbe~gjahr
       AND mseg~smbln = ekbe~belnr
       AND mseg~smblp = ekbe~buzei
      WHERE ekbe~ebeln EQ @ls_ekko-ebeln
        AND ekbe~vgabe EQ '1'
        AND ekbe~shkzg EQ 'S'
      INTO TABLE @DATA(lt_ekbe).
    IF sy-subrc NE 0.
      RETURN.
    ENDIF.

    SORT lt_ekbe BY doc_estorno gjahr DESCENDING belnr DESCENDING.

    READ TABLE lt_ekbe ASSIGNING FIELD-SYMBOL(<fs_ekbe>) INDEX 1.
    IF <fs_ekbe>-doc_estorno IS NOT INITIAL.
      RETURN.
    ENDIF.

    DATA(ls_headerdata) = VALUE bapi_incinv_create_header(
      invoice_ind  = abap_true
      doc_type     = 'RE'
      doc_date     = ls_doc-docdat
      pstng_date   = sy-datum
      ref_doc_no = COND #( WHEN ls_doc-series IS INITIAL THEN ls_doc-nfenum
                           ELSE |{ ls_doc-nfenum }-{ ls_doc-series }| )
      comp_code    = ls_ekko-bukrs
      currency     = ls_ekko-waers
      gross_amount = ls_doc-nftot
      calc_tax_ind = abap_true
      pmnttrms     = ls_ekko-zterm
      j_1bnftype   = get_parametro( iv_chave1 = 'ENT_ESPIRITO_SANTO' iv_chave2 = 'CATEGORIA_NF_MIRO' )
*      simulation   = abap_true
      ).

    DATA(lt_itemdata) = VALUE bapi_incinv_create_item_t(
      FOR ls_ekpo IN lt_ekpo INDEX INTO lv_index (
        invoice_doc_item = lv_index * 10
        po_number        = ls_ekpo-ebeln
        po_item          = ls_ekpo-ebelp
        ref_doc          = <fs_ekbe>-belnr
        ref_doc_year     = <fs_ekbe>-gjahr
*        ref_doc_it       = <fs_ekbe>-buzei
ref_doc_it       =  VALUE #( lt_ekbe[ ebeln = ls_ekpo-ebeln
                                      ebelp = ls_ekpo-ebelp ]-buzei )
        tax_code         = ls_ekpo-mwskz
        item_amount      = ls_ekpo-netwr
        quantity         = ls_ekpo-menge
        po_unit          = ls_ekpo-meins ) ).

    CALL FUNCTION 'ZFMMM_LANC_FAT_RECEB'
      STARTING NEW TASK 'LANC_FAT_RECEB'
      CALLING task_finish ON END OF TASK
      EXPORTING
        is_headerdata = ls_headerdata
      TABLES
        it_itemdata   = lt_itemdata.

    WAIT FOR ASYNCHRONOUS TASKS UNTIL gv_wait_async IS NOT INITIAL.

    rt_return[] = gt_return[].

  ENDMETHOD.


  METHOD task_finish.

    DATA: lt_return TYPE bapiret2_t.

    CASE p_task.
      WHEN 'PO_TRANSF_CREATE'.
        RECEIVE RESULTS FROM FUNCTION 'ZFMMM_PO_CREATE'
          IMPORTING
            ev_exppurchaseorder = gv_purchaseorder
          TABLES
            et_return           = lt_return.

      WHEN 'OUTB_DELIV_CREATE'.
        RECEIVE RESULTS FROM FUNCTION 'ZFMMM_OUTB_DELIV_CREATE'
          IMPORTING
            ev_delivery = gv_delivery
          TABLES
            et_return   = lt_return.

      WHEN 'DELIVERY_UPDATE'.
        RECEIVE RESULTS FROM FUNCTION 'ZFMMM_DELIVERY_UPDATE'
          TABLES
            it_prot   = gt_prott
            et_return = lt_return.

      WHEN 'ENTR_MERC_TRANSF'.
        RECEIVE RESULTS FROM FUNCTION 'ZFMMM_ENTR_MERC_TRANSF'
          TABLES
            et_return = lt_return.

      WHEN 'LANC_ENTR_MERC_GRC'.
        RECEIVE RESULTS FROM FUNCTION 'ZFMMM_LANC_ENTR_MERC_GRC'
          TABLES
            et_return = lt_return.

      WHEN 'LANC_ENTR_MERC'.
        RECEIVE RESULTS FROM FUNCTION 'ZFMMM_LANC_ENTR_MERC'
          TABLES
            et_return = lt_return.

      WHEN 'LANC_FAT_RECEB_GRC'.
        RECEIVE RESULTS FROM FUNCTION 'ZFMMM_LANC_FAT_RECEB_GRC'
          TABLES
            et_return = lt_return.

      WHEN 'LANC_FAT_RECEB'.
        RECEIVE RESULTS FROM FUNCTION 'ZFMMM_LANC_FAT_RECEB'
          TABLES
            et_return = lt_return.

      WHEN 'PO_INTERCOMPANY_CREATE'.
        RECEIVE RESULTS FROM FUNCTION 'ZFMMM_PO_CREATE'
          IMPORTING
            ev_exppurchaseorder = gv_purchaseorder
          TABLES
            et_return           = lt_return.

      WHEN 'SALESORDER_CHANGE'.
        RECEIVE RESULTS FROM FUNCTION 'ZFMMM_SALESORDER_CHANGE'
          TABLES
            et_return           = lt_return.

    ENDCASE.

    APPEND LINES OF lt_return TO gt_return.
    gv_wait_async = abap_true.
    RETURN.

  ENDMETHOD.


  METHOD exec_po_create.

    DATA: lv_timestamp TYPE timestampl,
          lt_itens     TYPE TABLE OF ztsd_interc_item.

    FREE: gv_purchaseorder,
          gv_wait_async.

    gv_continuar = is_continuar.

    set_header( is_input ).
    set_partner( is_input ).
    set_items( is_input ).
    set_text( is_input ).
    set_schedule( is_input ).

    CALL FUNCTION 'ZFMMM_PO_CREATE'
      STARTING NEW TASK 'PO_TRANSF_CREATE'
      CALLING task_finish ON END OF TASK
      EXPORTING
        is_poheader     = gs_poheader
        is_poheaderx    = gs_poheaderx
      TABLES
        it_poitem       = gt_poitem
        it_poitemx      = gt_poitemx
        it_poschedule   = gt_poschedule
        it_poschedulex  = gt_poschedulex
        it_popartner    = gt_popartner
        it_potextheader = gt_potextheader.

    WAIT FOR ASYNCHRONOUS TASKS UNTIL gv_wait_async IS NOT INITIAL.

    CHECK gv_purchaseorder IS NOT INITIAL.

    IF gv_continuar IS INITIAL. "se não é segunda etapa processo intercompany
      UPDATE ztsd_intercompan SET purchaseorder = gv_purchaseorder
        WHERE guid = is_input-guid.
    ELSE.
      UPDATE ztsd_intercompan SET purchaseorder2 = gv_purchaseorder
        WHERE guid = is_input-guid.

*      insere pedido da segunda etapa para fluxo normal de transferência
      SELECT SINGLE FROM ztsd_intercompan
        FIELDS werks_origem,
               lgort_origem,
               werks_destino,
               lgort_destino,
               werks_receptor,
               tpfrete,
               condexp,
               fracionado,
               ekorg,
               ekgrp,
               ztraid,
               ztrai1,
               ztrai2,
               ztrai3,
               agfrete,
               motora,
               tpexp,
               idsaga
        WHERE guid = @is_input-guid
        INTO @DATA(ls_intercompany).
      IF sy-subrc = 0.


        GET TIME STAMP FIELD lv_timestamp.

        "cria linha nova para a segunta etapa
        TRY.
            DATA(lv_guid) = NEW cl_system_uuid( )->if_system_uuid~create_uuid_x16( ).
          CATCH cx_uuid_error INTO DATA(lo_uuid_error).
            CLEAR lv_guid.
        ENDTRY.

        DATA(lv_stge_loc) = get_parametro(
              iv_chave1 = 'PED_INTER_ESP_SANTO'
              iv_chave2 = 'DEP_ENT_INTER_ES'
            ).

        DATA(ls_transferencia) = VALUE ztsd_intercompan(
          guid                  = lv_guid
          processo              = '1'
          tipooperacao          = 'TRA3'  "INTERCOMPANY segunda etapa - mesma empresa
          werks_origem          = ls_intercompany-werks_destino
          lgort_origem          = COND #( WHEN is_input-tipo_operacao = 'INT4'
                                  THEN lv_stge_loc
                                  ELSE ls_intercompany-lgort_destino
                                )
*          ls_intercompany-lgort_destino
          werks_destino         = ls_intercompany-werks_receptor
          lgort_destino         = ls_intercompany-lgort_destino
          purchaseorder         = gv_purchaseorder
          tpfrete               = ls_intercompany-tpfrete
          condexp               = ls_intercompany-condexp
          ekorg                 = ls_intercompany-ekorg
          ekgrp                 = ls_intercompany-ekgrp
          fracionado            = ls_intercompany-fracionado
          ztraid  = ls_intercompany-ztraid
          ztrai1 = ls_intercompany-ztrai1
          ztrai2 = ls_intercompany-ztrai2
          ztrai3 = ls_intercompany-ztrai3
          agfrete = ls_intercompany-agfrete
          motora = ls_intercompany-motora
          tpexp  = ls_intercompany-tpexp
          idsaga = ls_intercompany-idsaga
          created_by            = sy-uname
          created_at            = lv_timestamp
          last_changed_by       = sy-uname
          last_changed_at       = lv_timestamp
          local_last_changed_at = lv_timestamp ).

        "INSERE LINHA DA SEGUNDA ETAPA
        MODIFY ztsd_intercompan FROM ls_transferencia.

        SELECT FROM ztsd_interc_item
          FIELDS @lv_guid AS guid,
                 material,
                 materialbaseunit,
                 qtdsol
          WHERE guid EQ @is_input-guid
          INTO CORRESPONDING FIELDS OF TABLE @lt_itens.
        IF sy-subrc EQ 0.
          MODIFY ztsd_interc_item FROM TABLE lt_itens.
        ENDIF.

      ENDIF.
    ENDIF.

  ENDMETHOD.


  METHOD exec_2_steps.

*    IF is_input-tipo_operacao EQ 'TRA3'.
*
*      SELECT SINGLE salesorder,
*                    purchaseorder
*      FROM ztsd_intercompan
*      WHERE guid = @is_input-guid
*      INTO @DATA(ls_intercompany).
*      IF sy-subrc NE 0.
*        RETURN.
*      ENDIF.
*
*      SELECT SINGLE purchaseorder
*        FROM i_purchaseorder
*        WHERE purchaseorder = @ls_intercompany-purchaseorder
*        INTO @DATA(lv_purchaseorder).
*      IF sy-subrc NE 0.
*        RETURN.
*      ENDIF.
*
*      SELECT COUNT( * )
*        FROM i_br_nfitem AS nfitem
*        INNER JOIN i_br_nfdocument AS nfdoc
*          ON nfdoc~br_notafiscal = nfitem~br_notafiscal
*        WHERE nfitem~purchaseorder  EQ @lv_purchaseorder
*          AND nfdoc~br_nfdirection  EQ '1'
*          AND nfdoc~br_nfiscanceled EQ @abap_false.
*      IF sy-subrc NE 0.
*        RETURN.
*      ENDIF.
*
*
*      DATA(lv_supplier_origem) = |{ CONV lifnr_wk( is_input-centro_fornecedor ) ALPHA = IN }| .
*      SELECT SINGLE companycode
*        FROM i_suppliercompanybyplant
*        INTO @DATA(lv_empresa_origem)
*        WHERE plant    = @is_input-centro_fornecedor
*          AND supplier = @lv_supplier_origem.
*
*      DATA(lv_supplier_destino) = |{ CONV lifnr_wk( is_input-centro_destino ) ALPHA = IN }| .
*      SELECT SINGLE companycode
*        FROM i_suppliercompanybyplant
*        INTO @DATA(lv_empresa_destino)
*        WHERE plant    = @is_input-centro_destino
*          AND supplier = @lv_supplier_destino.
*
*
*      IF lv_empresa_origem EQ lv_empresa_destino.
*        exec_po_create( is_input ).
*      ELSE.
*        exec_po_intercompany( is_input = is_input ).
*        exec_so_intercompany( iv_salesorder    = ls_intercompany-salesorder
*                              iv_purchaseorder = gv_purchaseorder ).
*      ENDIF.
*
*    ELSE.



    DATA(lv_mesma_empresa) = valida_centro( iv_centro1 = is_input-centro_destino
                                            iv_centro2 = is_input-centro_receptor ).

    IF lv_mesma_empresa EQ abap_true. "Se centros são da mesma empresa, gera pedido de transferência.
      rt_return = exec_transf( is_input     = is_input
                               is_continuar = abap_true ).
    ELSE. "Caso contrário, gera OV intercompany e novo pedido de compra
      rt_return = NEW zclsd_cria_ordem_intercompany(  )->execute( is_input     = is_input
                                                                  is_continuar = abap_true ).
    ENDIF.

  ENDMETHOD.


  METHOD exec_po_intercompany.

    FREE: gv_purchaseorder,
          gv_wait_async.
    CLEAR: gt_popartner.
    set_header_inter( is_input ).
*    get_mbew( is_input ).
    set_items_inter( is_input ).
    set_schedule_inter( is_input ).
    set_cond_inter( is_input ).

    IF is_input-centro_receptor IS NOT INITIAL AND
       ( is_input-tipo_operacao = 'INT2' OR
         is_input-tipo_operacao = 'INT4' ).

      DATA(lv_supplier) = |{ CONV lifnr_wk( is_input-centro_receptor ) ALPHA = IN }| .
      gt_popartner = VALUE #(
        ( partnerdesc = get_parametro( iv_chave3 = 'FUNCPARC' )
          buspartno   = lv_supplier
          langu       = sy-langu ) ).
    ENDIF.

    CALL FUNCTION 'ZFMMM_PO_CREATE'
      STARTING NEW TASK 'PO_INTERCOMPANY_CREATE'
      CALLING task_finish ON END OF TASK
      EXPORTING
        is_poheader         = gs_poheader
        is_poheaderx        = gs_poheaderx
        iv_tipo_operacao    = is_input-tipo_operacao
        iv_no_price_from_po = abap_true
      TABLES
        it_poitem           = gt_poitem
        it_poitemx          = gt_poitemx
        it_poschedule       = gt_poschedule
        it_poschedulex      = gt_poschedulex
        it_pocond           = gt_pocond
        it_pocondx          = gt_pocondx
        it_popartner        = gt_popartner.

    WAIT FOR ASYNCHRONOUS TASKS UNTIL gv_wait_async IS NOT INITIAL.

*    CHECK gv_purchaseorder IS NOT INITIAL.
    IF gv_purchaseorder IS NOT INITIAL.
      UPDATE ztsd_intercompan SET purchaseorder = gv_purchaseorder

      WHERE guid = is_input-guid.
    ENDIF.

    ev_purchaseorder = gv_purchaseorder.
    rt_return[] = gt_return[].

  ENDMETHOD.


  METHOD set_header_inter.

    FREE: gs_poheader,
          gs_poheaderx.

    SELECT SINGLE salesorder
      FROM ztsd_intercompan
      INTO @DATA(lv_vbeln)
      WHERE guid =  @is_input-guid
      .
    IF sy-subrc IS INITIAL.

      SELECT vbeln, inco1, inco2
        UP TO 1 ROWS
        FROM vbkd
        INTO @DATA(ls_vbkd)
        WHERE vbeln = @lv_vbeln
        .
      ENDSELECT.
    ENDIF.



    gs_poheader = VALUE #(
      doc_type   = gc_const-zcol
      creat_date = sy-datum
      created_by = sy-uname
      langu      = sy-langu
      ref_1      = lv_vbeln
*      LANGU_ISO
*      purch_org  = 'OC01'
*      pur_group  = '310'
      purch_org  = is_input-org_compras
      pur_group  = is_input-grp_comp
      doc_date   = sy-datum
      currency   = 'BRL'
*      incoterms1 = is_input-modalidade_frete
*      incoterms2 = is_input-modalidade_frete
      incoterms1 = ls_vbkd-inco1
      incoterms2 = ls_vbkd-inco1
    ).

    gs_poheaderx = VALUE #(
      doc_type   = abap_true
      creat_date = abap_true
      langu      = abap_true
      ref_1      = abap_true
*      LANGU_ISO  = abap_true
      purch_org  = abap_true
      pur_group  = abap_true
      doc_date   = abap_true
      currency   = abap_true
      incoterms1 = abap_true
      incoterms2 = abap_true
    ).

    DATA(lv_supplier) = |{ CONV lifnr_wk( is_input-centro_destino ) ALPHA = IN }| .
    SELECT SINGLE companycode,
                  @abap_true
      FROM i_suppliercompanybyplant
      INTO (@gs_poheader-comp_code, @gs_poheaderx-comp_code)
      WHERE plant    = @is_input-centro_destino
        AND supplier = @lv_supplier.

    SELECT SINGLE plantcustomer,
                  @abap_true
      FROM i_plant
      INTO (@gs_poheader-vendor, @gs_poheaderx-vendor)
      WHERE plant    = @is_input-centro_fornecedor.



    IF is_input-tipo_operacao = 'INT2' AND is_input-centro_receptor IS NOT INITIAL.
      DATA(lv_dep_fechado) = |{ CONV lifnr_wk( is_input-centro_receptor ) ALPHA = IN }| .

      gt_popartner = VALUE #(
        ( partnerdesc = get_parametro( iv_chave3 = 'FUNCPARC' )
          buspartno   = lv_dep_fechado
          langu       = sy-langu ) ).
    ENDIF.
  ENDMETHOD.


  METHOD set_items_inter.

    DATA lt_lips_va TYPE TABLE OF ty_helper_type_line.
    DATA ls_lips_va TYPE ty_helper_type_line.
    DATA lt_lips_vb TYPE TABLE OF ty_helper_type_line.
    DATA ls_lips_vb TYPE ty_helper_type_line.


    FREE: gt_poitem,
          gt_poitemx,
          gt_itens_pedido.

    IF is_input-remessa_origem IS INITIAL.
      RETURN.
    ENDIF.

    SELECT vbeln,
           posnr,
           matnr,
           charg,
           bwtar,
           uecha,
           lfimg,
           meins,
           vrkme,
           vgbel,
           vgpos
      FROM lips
      WHERE vbeln EQ @is_input-remessa_origem
      ORDER BY PRIMARY KEY
      INTO TABLE @DATA(lt_lips).

    IF sy-subrc IS INITIAL.

      DATA(lt_lips_auart) = lt_lips[].
      SORT lt_lips_auart BY vgbel.
      DELETE lt_lips_auart WHERE vgbel IS INITIAL.
      DELETE ADJACENT DUPLICATES FROM lt_lips_auart COMPARING vgbel.
      IF lt_lips_auart IS NOT INITIAL.

        SELECT vbeln,
               auart
          FROM vbak
           FOR ALL ENTRIES IN @lt_lips_auart
         WHERE vbeln EQ @lt_lips_auart-vgbel
*          AND   auart EQ 'Z004'
           AND   auart IN ( 'Z004' , 'Z019' )
          INTO TABLE @DATA(lt_vbak_auart).

        IF sy-subrc IS INITIAL.
          SORT lt_vbak_auart BY vbeln.
        ENDIF.
      ENDIF.

    ENDIF.

    LOOP AT lt_lips INTO DATA(ls_lisp).

      READ TABLE lt_vbak_auart INTO DATA(ls_vbak) WITH KEY vbeln = ls_lisp-vgbel
                                                  BINARY SEARCH.

      IF sy-subrc IS INITIAL.

        ls_lips_va-vbeln = ls_lisp-vbeln.
        ls_lips_va-posnr = ls_lisp-posnr.
        ls_lips_va-matnr = ls_lisp-matnr.
        ls_lips_va-charg = ls_lisp-charg.
        ls_lips_va-bwtar = ls_lisp-bwtar.
        ls_lips_va-uecha = ls_lisp-uecha.
        ls_lips_va-lfimg = ls_lisp-lfimg.
        ls_lips_va-meins = ls_lisp-meins.
        ls_lips_va-vrkme = ls_lisp-vrkme.
        ls_lips_va-vgbel = ls_lisp-vgbel.
        ls_lips_va-vgpos = ls_lisp-vgpos.

        APPEND ls_lips_va TO lt_lips_va.
        CLEAR  ls_lips_va.

      ELSE.

        ls_lips_vb-vbeln = ls_lisp-vbeln.
        ls_lips_vb-posnr = ls_lisp-posnr.
        ls_lips_vb-matnr = ls_lisp-matnr.
        ls_lips_vb-charg = ls_lisp-charg.
        ls_lips_vb-bwtar = ls_lisp-bwtar.
        ls_lips_vb-uecha = ls_lisp-uecha.
        ls_lips_vb-lfimg = ls_lisp-lfimg.
        ls_lips_vb-meins = ls_lisp-meins.
        ls_lips_vb-vrkme = ls_lisp-vrkme.
        ls_lips_vb-vgbel = ls_lisp-vgbel.
        ls_lips_vb-vgpos = ls_lisp-vgpos.

        APPEND ls_lips_vb TO lt_lips_vb.
        CLEAR  ls_lips_vb.

      ENDIF.
    ENDLOOP.

*    DATA(lt_lips_vb) = lt_lips[].

    SORT lt_lips_va BY vgbel.
    DELETE ADJACENT DUPLICATES FROM lt_lips_va COMPARING vgbel.
    SORT lt_lips_vb BY vgbel.
    DELETE ADJACENT DUPLICATES FROM lt_lips_vb COMPARING vgbel.

    IF lt_lips_vb[] IS NOT INITIAL .
      SELECT vbak~vbeln,
             vbak~knumv,
             prcd~kposn,  "Item
             prcd~kappl,  "Aplicação
             prcd~kschl,  "Tipo de condição
             prcd~kawrt,  "Base da condição
             prcd~kbetr,  "Montante ou porcentagem da condição
             prcd~waers,  "moeda
             prcd~kpein,  "Unidade de preço da condição
             prcd~kmein   "Unidade de medida da condição
        FROM vbak
        INNER JOIN prcd_elements AS prcd
          ON prcd~knumv EQ vbak~knumv
         AND prcd~kappl EQ 'V'
         AND prcd~kschl EQ 'ICMI'  "preço + impostos
        INTO TABLE @DATA(lt_elements)
        FOR ALL ENTRIES IN @lt_lips_vb
        WHERE vbak~vbeln EQ @lt_lips_vb-vgbel.

      IF sy-subrc IS INITIAL.
        SORT lt_elements BY vbeln kposn.
      ENDIF.
    ENDIF.

    IF lt_lips_va[] IS NOT INITIAL.
      SELECT vbak~vbeln,
             vbak~knumv,
             prcd~kposn,  "Item
             prcd~kappl,  "Aplicação
             prcd~kschl,  "Tipo de condição
             prcd~kawrt,  "Base da condição
             prcd~kwert,  "Montante ou porcentagem da condição
             prcd~waerk,  "moeda
             prcd2~kpein,  "Unidade de preço da condição
             prcd2~kmein   "Unidade de medida da condição
        FROM vbak
       INNER JOIN prcd_elements AS prcd ON prcd~knumv EQ vbak~knumv
                                       AND prcd~kappl EQ 'V'
                                       AND prcd~kschl EQ 'ZICM'  "preço + impostos
       INNER JOIN prcd_elements AS prcd2 ON prcd2~knumv EQ vbak~knumv
                                        AND prcd2~kposn EQ prcd~kposn
                                        AND prcd2~kappl EQ 'V'
                                        AND prcd2~kschl EQ 'ICMI'  "preço + impostos
        INTO TABLE @DATA(lt_elements_a)
         FOR ALL ENTRIES IN @lt_lips_va
       WHERE vbak~vbeln EQ @lt_lips_va-vgbel.

      IF sy-subrc IS INITIAL.
        SORT lt_elements_a BY vbeln kposn.
      ENDIF.
    ENDIF.

    SORT lt_lips BY posnr uecha.
    DATA(lt_lips_aux) = lt_lips[].

    LOOP AT lt_lips ASSIGNING FIELD-SYMBOL(<fs_lips>).
      CHECK <fs_lips>-uecha IS INITIAL.

      DATA(ls_ped) = VALUE ty_itens_pedido( vbeln = <fs_lips>-vbeln
                                            posnr = <fs_lips>-posnr
                                            matnr = <fs_lips>-matnr
                                            charg = <fs_lips>-charg
                                            bwtar = <fs_lips>-bwtar
                                            uecha = <fs_lips>-uecha
                                            lfimg = <fs_lips>-lfimg
                                            vrkme = <fs_lips>-vrkme
                                            vgbel = <fs_lips>-vgbel
                                            vgpos = <fs_lips>-vgpos ).

      READ TABLE lt_elements INTO DATA(ls_elements)
                              WITH KEY vbeln = <fs_lips>-vgbel
                                       kposn = <fs_lips>-posnr
                                       BINARY SEARCH.

      IF sy-subrc = 0. "preço + impostos

        IF <fs_lips>-lfimg IS NOT INITIAL.
          ls_ped-cond_value  = ls_elements-kbetr / <fs_lips>-lfimg.
        ELSE.
          ls_ped-cond_value  = ls_elements-kbetr.       "Montante de condição
        ENDIF.

        ls_ped-currency    = ls_elements-waers.       "Código da moeda
        ls_ped-cond_unit   = ls_elements-kmein.       "Unidade de medida da condição
        ls_ped-cond_p_unt  = ls_elements-kpein.       "Unidade de preço da condição
        ls_ped-condbaseval = ls_elements-kawrt.
      ELSE.

        READ TABLE lt_elements_a INTO DATA(ls_elements_a)
                                  WITH KEY vbeln = <fs_lips>-vgbel
                                           kposn = <fs_lips>-posnr
                                           BINARY SEARCH.

        IF sy-subrc = 0. "preço + impostos

          IF  <fs_lips>-lfimg IS NOT INITIAL.
            ls_ped-cond_value  = ls_elements_a-kwert / <fs_lips>-lfimg.
          ELSE.
            ls_ped-cond_value  = ls_elements_a-kwert.       "Montante de condição
          ENDIF.

          ls_ped-currency    = ls_elements_a-waerk.       "Código da moeda
          ls_ped-cond_unit   = ls_elements_a-kmein.       "Unidade de medida da condição
          ls_ped-cond_p_unt  = ls_elements_a-kpein.       "Unidade de preço da condição
          ls_ped-condbaseval = ls_elements_a-kawrt.
          ls_ped-po_unit     = ls_elements_a-kmein.
          ls_ped-price_unit  = ls_elements_a-kpein.
          ls_ped-net_price   = ls_elements_a-kawrt.
        ENDIF.
      ENDIF.

      DATA(lt_itens_pedido) = itens_lote( EXPORTING is_item = ls_ped
                                                    it_lips = lt_lips_aux ).
      IF lt_itens_pedido IS NOT INITIAL.
        APPEND LINES OF lt_itens_pedido TO gt_itens_pedido.
      ELSE.
        APPEND ls_ped TO gt_itens_pedido.
      ENDIF.
      FREE ls_ped.

    ENDLOOP.

    SORT gt_itens_pedido BY vbeln posnr matnr.

    DATA(lv_stge_loc) = get_parametro( iv_chave1 = 'PED_INTER_ESP_SANTO'
                                       iv_chave2 = 'DEP_ENT_INTER_ES' ).

    gt_poitem =  VALUE #( FOR ls_ped_aux IN gt_itens_pedido INDEX INTO lv_index
    LET lv_item = CONV ebelp( lv_index * 10 )
        lv_taxcode = get_iva( is_input = is_input is_item = VALUE #( material = ls_ped_aux-matnr  bwtar = <fs_lips>-bwtar  ) )
        IN ( po_item    = lv_item
             material   = ls_ped_aux-matnr
             plant      = is_input-centro_destino
             stge_loc   = COND #( WHEN is_input-processo = '2' AND is_input-tipo_operacao = 'INT4'
                                  THEN lv_stge_loc
                                  ELSE is_input-deposito_destino
                                )
             quantity   = ls_ped_aux-lfimg
             po_unit    = COND #( WHEN ls_ped_aux-po_unit IS NOT INITIAL
                                    THEN ls_ped_aux-po_unit
                                  ELSE abap_false )
             price_unit = COND #( WHEN ls_ped_aux-price_unit IS NOT INITIAL
                                    THEN ls_ped_aux-price_unit
                                  ELSE abap_false )
             orderpr_un = ls_ped_aux-po_unit
             net_price  = COND #( WHEN ls_ped_aux-net_price IS NOT INITIAL
                                   AND ls_ped_aux-lfimg IS NOT INITIAL
                                    THEN ls_ped_aux-net_price / ls_ped_aux-lfimg
                                  ELSE abap_false )
*             val_type   = ls_ped_aux-bwtar
             val_type    =  COND #( WHEN ls_ped_aux-bwtar+8(2) = 'IN' THEN |{ ls_ped_aux-bwtar(8) }{ 'EX' }|
                                    WHEN ls_ped_aux-bwtar+8(2) = 'EX' THEN ls_ped_aux-bwtar
                                    ELSE space )
             batch       = ls_ped_aux-charg
             tax_code    = COND #( WHEN lv_taxcode IS INITIAL THEN 'I0' ELSE lv_taxcode )
             po_price    = '2'
            gi_based_gr  = COND #( WHEN ls_ped_aux-bwtar IS INITIAL THEN abap_true )
*            supp_vendor = COND #( WHEN is_input-tipo_operacao = 'INT2' THEN is_input-centro_receptor )
            supp_vendor  = COND #( WHEN is_input-tipo_operacao = 'INT2' THEN
          |{ CONV lifnr_wk( is_input-centro_receptor ) ALPHA = IN }| )
            ) ).

    gt_poitemx = VALUE #( FOR ls_poitem IN gt_poitem (
      po_item     = ls_poitem-po_item
      po_itemx    = abap_true
      material    = abap_true
      plant       = abap_true
      stge_loc    = abap_true
      quantity    = abap_true
      orderpr_un  = abap_true
      po_unit     = COND #( WHEN ls_poitem-po_unit     IS NOT INITIAL THEN abap_true )
      price_unit  = COND #( WHEN ls_poitem-price_unit  IS NOT INITIAL THEN abap_true )
      net_price   = COND #( WHEN ls_poitem-net_price   IS NOT INITIAL THEN abap_true )
      val_type    = COND #( WHEN ls_poitem-val_type    IS NOT INITIAL THEN abap_true )
      batch       = COND #( WHEN ls_poitem-batch       IS NOT INITIAL THEN abap_true )
      tax_code    = abap_true
      po_price    = abap_true
      gi_based_gr = ls_poitem-gi_based_gr
      supp_vendor = COND #( WHEN ls_poitem-supp_vendor IS NOT INITIAL THEN abap_true )
    ) ).

*
*    DATA(lv_val_type) = |{ gs_poheader-comp_code }{ is_input-centro_destino }IN|.
*
*    gt_poitem = VALUE #( FOR ls_item IN is_input-itens INDEX INTO lv_index
*      LET lv_item = CONV ebelp( lv_index * 10 )
*          ls_mbew = read_mbew( is_input = is_input is_item = ls_item )
*      IN ( po_item     = lv_item
*           material    = ls_item-material
*           plant       = is_input-centro_destino
*           stge_loc    = is_input-deposito_destino
*           quantity    = ls_item-quantidade
*           po_unit     = ls_item-unidade
**           PO_UNIT_ISO = ls_item-unidade
*           net_price   = SWITCH #( ls_mbew-vprsv
*                                   WHEN 'S' THEN ls_mbew-stprs
*                                   WHEN 'V' THEN ls_mbew-verpr )
*           price_unit  = ls_mbew-peinh
*           tax_code    = get_iva( is_input = is_input is_item = ls_item )
*           po_price    = '1'
*           conf_ctrl   = '0004'
*           val_type    = lv_val_type
*
**           gi_based_gr = abap_true
**           ret_item = COND #( WHEN is_input-tipo_operacao EQ 'TRA7' THEN abap_true )
*      )
*    ).
*
*    gt_poitemx = VALUE #( FOR ls_poitem IN gt_poitem (
*      po_item     = ls_poitem-po_item
*      po_itemx    = abap_true
*      material    = abap_true
*      plant       = abap_true
*      stge_loc    = abap_true
*      quantity    = abap_true
*      po_unit     = abap_true
**      PO_UNIT_ISO = ABAP_TRUE
*      net_price   = abap_true
*      price_unit  = abap_true
*      tax_code    = abap_true
*      po_price    = abap_true
*      conf_ctrl   = abap_true
*      val_type    = abap_true
*
**      gi_based_gr = abap_true
**      ret_item = COND #( WHEN is_input-tipo_operacao EQ 'TRA7' THEN abap_true )
*    ) ).

  ENDMETHOD.


  METHOD set_schedule_inter.

    FREE: gt_poschedule,
          gt_poschedulex.

*    gt_poschedule = VALUE #( FOR ls_item IN is_input-itens INDEX INTO lv_index
*      LET lv_item = CONV ebelp( lv_index * 10 )
*      IN ( po_item       = lv_item
    gt_poschedule = VALUE #( FOR ls_ped IN gt_poitem INDEX INTO lv_index (
      po_item       = ls_ped-po_item
*      sched_line    = lv_index
      sched_line    = '0001'
      delivery_date = sy-datum
      stat_date     = sy-datum
*           quantity      = ls_item-quantidade ) ).
      quantity      = ls_ped-quantity ) ) .

    gt_poschedulex = VALUE bapimeposchedulx_tp(
      FOR ls_poschedule IN gt_poschedule (
        po_item       = ls_poschedule-po_item
        sched_line    = ls_poschedule-sched_line
        po_itemx      = abap_true
        delivery_date = abap_true
        quantity      = abap_true
        stat_date     = abap_true ) ).

  ENDMETHOD.


  METHOD set_cond_inter.

    FREE: gt_pocond,
          gt_pocondx.


*    DATA(lv_val_type) = |{ gs_poheader-comp_code }{ is_input-centro_destino }IN|.

    gt_pocond = VALUE #( FOR ls_item IN gt_itens_pedido INDEX INTO lv_index

      LET lv_item = CONV ebelp( lv_index * 10 )
*          ls_mbew = read_mbew( is_input = is_input is_item = ls_item )

      IN ( condition_no = '001'
           itm_number   = lv_item
*           cond_type    = 'PBXX'
           cond_type    = 'PB00'
           cond_value   = ls_item-cond_value / ls_item-lfimg
*           cond_value   = SWITCH #( ls_mbew-vprsv
*                                    WHEN 'S' THEN ls_mbew-stprs
*                                    WHEN 'V' THEN ls_mbew-verpr )
*           currency     = 'BRL'
           currency     = ls_item-currency
           cond_unit    = ls_item-cond_unit
           "cond_p_unt   = ls_mbew-peinh
           cond_p_unt  = ls_item-cond_p_unt
           "cond_p_unt  =  ls_item-cond_p_unt
           calctypcon   = 'A'
           conbaseval  = ls_item-condbaseval / ls_item-lfimg
           change_id   = 'U'
*           conbaseval   = SWITCH #( ls_mbew-vprsv
*                                    WHEN 'S' THEN ls_mbew-stprs
*                                    WHEN 'V' THEN ls_mbew-verpr )
    ) ).

    gt_pocondx = VALUE #( FOR ls_pocond IN gt_pocond (
      condition_no = '001'
      itm_number   = ls_pocond-itm_number
      cond_type    = abap_true
      cond_value   = abap_true
      currency     = abap_true
      cond_unit    = abap_true
      cond_p_unt   = abap_true
      calctypcon   = abap_true
      conbaseval   = abap_true
      change_id    = abap_true
    ) ).

  ENDMETHOD.


  METHOD get_mbew.

    IF is_input-itens IS INITIAL.
      RETURN.
    ENDIF.

    DATA(lv_val_type) = |{ gs_poheader-comp_code }{ is_input-centro_destino }IN|.

    SELECT FROM mbew
      FIELDS matnr,
             bwkey,
             bwtar,
             vprsv,
             stprs,
             verpr,
             peinh
      FOR ALL ENTRIES IN @is_input-itens
      WHERE matnr EQ @is_input-itens-material
        AND bwkey EQ @is_input-centro_destino
        AND bwtar EQ @lv_val_type
      ORDER BY PRIMARY KEY
      INTO CORRESPONDING FIELDS OF TABLE @gt_mbew.

  ENDMETHOD.


  METHOD read_mbew.

    DATA(lv_val_type) = |{ gs_poheader-comp_code }{ is_input-centro_destino }IN|.

    READ TABLE gt_mbew INTO rs_result
      WITH KEY matnr = is_item-material
               bwkey = is_input-centro_destino
               bwtar = lv_val_type BINARY SEARCH.
  ENDMETHOD.


  METHOD exec_so_intercompany.

    IF iv_salesorder IS INITIAL
    OR iv_purchaseorder IS INITIAL.
      RETURN.
    ENDIF.

    DATA(ls_order_header_in) = VALUE bapisdh1(
      purch_no_c = iv_purchaseorder
    ).

    DATA(ls_order_header_inx) = VALUE bapisdh1x(
      updateflag = 'U'
      purch_no_c = abap_true
    ).

    CALL FUNCTION 'ZFMMM_SALESORDER_CHANGE'
      STARTING NEW TASK 'SALESORDER_CHANGE'
      CALLING task_finish ON END OF TASK
      EXPORTING
        iv_salesdocument    = iv_salesorder
        is_order_header_in  = ls_order_header_in
        is_order_header_inx = ls_order_header_inx.

    WAIT FOR ASYNCHRONOUS TASKS UNTIL gv_wait_async IS NOT INITIAL.

    rt_return[] = gt_return[].

  ENDMETHOD.


  METHOD get_iva.
*
*    SELECT SINGLE companycode,
*                  @abap_true
*      FROM i_suppliercompanybyplant
*      INTO (@gs_poheader-comp_code, @gs_poheaderx-comp_code)
*      WHERE plant    = @is_input-centro_fornecedor
*        AND supplier = @lv_supplier.
*

    DATA(lv_supplier) = |{ CONV lifnr_wk( is_input-centro_fornecedor ) ALPHA = IN }| .

    SELECT SINGLE regio,
                  j_1bbranch AS branch
      FROM t001w
      INTO @DATA(ls_ship_from)
      WHERE werks EQ @is_input-centro_fornecedor.

    SELECT SINGLE regio,
                  j_1bbranch AS branch
      FROM t001w
      INTO @DATA(ls_ship_to)
      WHERE werks EQ @is_input-centro_destino.

    SELECT SINGLE matkl
      FROM mara
      INTO @DATA(lv_matkl)
      WHERE matnr EQ @is_item-material.

    DATA(lr_ship_from) = VALUE /scmb/tt_regio_r(
      ( sign = 'I' option = 'EQ' low = space )
      ( sign = 'I' option = 'EQ' low = ls_ship_from-regio ) ).

    DATA(lr_ship_to) = VALUE /scmb/tt_regio_r(
      ( sign = 'I' option = 'EQ' low = space )
      ( sign = 'I' option = 'EQ' low = ls_ship_to-regio ) ).


    SELECT SINGLE werks_origem
      FROM ztsd_intercompan
      WHERE guid = @is_input-guid
      INTO @DATA(lv_werks_origem).

    SELECT SINGLE kunnr
      FROM t001w
      WHERE werks EQ @lv_werks_origem
      INTO @DATA(lv_kunnr).

    SELECT FROM ztmm_det_iva_po
      FIELDS ship_from,
             ship_to,
             werks,
             branch,
             lifnr,
             matnr,
             matkl,
             mwskz
      WHERE ship_from IN @lr_ship_from
        AND ship_to   IN @lr_ship_to
      ORDER BY ship_from DESCENDING,
               ship_to   DESCENDING,
               werks     DESCENDING,
               branch    DESCENDING,
               lifnr     DESCENDING,
               matnr     DESCENDING,
               matkl     DESCENDING
      INTO TABLE @DATA(lt_iva).


    LOOP AT lt_iva ASSIGNING FIELD-SYMBOL(<fs_iva>).
      IF <fs_iva>-ship_from IS NOT INITIAL.
        CHECK <fs_iva>-ship_from EQ ls_ship_from-regio.
      ENDIF.

      IF <fs_iva>-ship_to IS NOT INITIAL.
        CHECK <fs_iva>-ship_to EQ ls_ship_to-regio.
      ENDIF.

      IF <fs_iva>-werks IS NOT INITIAL.
        CHECK <fs_iva>-werks EQ is_input-centro_destino.
      ENDIF.

      IF <fs_iva>-branch IS NOT INITIAL.
        CHECK <fs_iva>-branch EQ ls_ship_from-branch.
      ENDIF.

      IF <fs_iva>-lifnr IS NOT INITIAL.
        CHECK lv_kunnr EQ <fs_iva>-lifnr.
      ENDIF.

      IF <fs_iva>-matnr IS NOT INITIAL.
        CHECK <fs_iva>-matnr EQ is_item-material.
      ENDIF.

      IF <fs_iva>-matkl IS NOT INITIAL.
        CHECK <fs_iva>-matkl EQ lv_matkl.
      ENDIF.

      rv_return = <fs_iva>-mwskz.
      EXIT.

    ENDLOOP.

    IF rv_return IS INITIAL.

      SELECT SINGLE matnr, bwkey, bwtar, mtuse
        FROM mbew
        WHERE matnr = @is_item-material
          AND bwkey = @lv_werks_origem
          AND bwtar = @is_item-bwtar
        INTO @DATA(ls_mbew).

      CHECK sy-subrc = 0.

      IF ls_mbew-mtuse = '0' OR ls_mbew-mtuse = '1'.

        SELECT SINGLE low
          FROM ztca_param_val
          WHERE modulo = 'MM'
            AND chave1 = 'PED_COMPRA_INTER'
            AND chave2 = 'IVA_PED_COMP_INDUST'
          INTO @DATA(lv_iva_ped_comp_indust).

        rv_return = lv_iva_ped_comp_indust.

      ELSEIF ls_mbew-mtuse = '2' OR ls_mbew-mtuse = '3'.
        SELECT SINGLE low
          FROM ztca_param_val
          WHERE modulo = 'MM'
            AND chave1 = 'PED_COMPRA_INTER'
            AND chave2 = 'IVA_PED_COMP_CONSUM'
          INTO @DATA(lv_iva_ped_comp_consum).

        rv_return = lv_iva_ped_comp_consum.

      ENDIF.

    ENDIF.

  ENDMETHOD.


  METHOD get_original.
    READ TABLE gt_lips INTO rv_result
      WITH KEY matnr = iv_material BINARY SEARCH.
  ENDMETHOD.


  METHOD deposito_fechado_entrega.

****    DATA: ls_address    TYPE sadr,
****          ls_branch     TYPE j_1bbranch,
****          lv_cgc_number TYPE j_1bcgc,
****          ls_address1   TYPE addr1_val.
****
****    SELECT SINGLE werks,
****                  j_1bbranch,
****                  adrnr
****      FROM t001w
****      INTO @DATA(ls_t001w_entrega)
****      WHERE werks EQ @iv_werks_receptor.
****    IF sy-subrc NE 0.
****      RETURN.
****    ENDIF.
****
****
****    SELECT bukrs,
****           branch
****      FROM j_1bbranch
****      INTO TABLE @DATA(lt_1bbranch)
****      WHERE branch EQ @ls_t001w_entrega-j_1bbranch.
****    IF sy-subrc NE 0.
****      RETURN.
****    ENDIF.
****
****    READ TABLE lt_1bbranch INTO DATA(ls_1bbranch) INDEX 1.
****
****    CALL FUNCTION 'J_1BREAD_BRANCH_DATA'
****      EXPORTING
****        branch            = ls_1bbranch-branch
****        bukrs             = ls_1bbranch-bukrs
****      IMPORTING
****        address           = ls_address
****        branch_data       = ls_branch
****        cgc_number        = lv_cgc_number
****        address1          = ls_address1
****      EXCEPTIONS
****        branch_not_found  = 1
****        address_not_found = 2
****        company_not_found = 3
****        OTHERS            = 4.
****
****    IF sy-subrc EQ 0.
****      cs_entrega-g_cnpj = lv_cgc_number.
****      cs_entrega-g_ie   = ls_branch-state_insc.
****      cs_entrega-g_fone = ls_address1-tel_number.
****    ENDIF.
****
****
****    SELECT addrnumber,
****           name2,
****           street,
****           house_num1,
****           city1,
****           city2,
****           taxjurcode,
****           region,
****           post_code1
****      FROM adrc
****      INTO TABLE @DATA(lt_adrc)
****      WHERE addrnumber EQ @ls_t001w_entrega-adrnr.
****    IF sy-subrc NE 0.
****      RETURN.
****    ENDIF.
****
****    READ TABLE lt_adrc INTO DATA(ls_adrc) INDEX 1.
****
****    cs_entrega-g_xnome   = ls_adrc-name2.
****    cs_entrega-g_xlgr    = ls_adrc-street.
****    cs_entrega-g_nro     = ls_adrc-house_num1.
*****    <fs_xmlh>-G_XCPL
****    cs_entrega-g_xbairro = ls_adrc-city2.
****    cs_entrega-g_cmun    = ls_adrc-taxjurcode+3.
****    cs_entrega-g_xmun    = ls_adrc-city1.
****    cs_entrega-g_uf      = ls_adrc-region.
****
****    TRANSLATE ls_adrc-post_code1 USING '- '.
****    CONDENSE ls_adrc-post_code1 NO-GAPS.
****    cs_entrega-g_cep     = ls_adrc-post_code1.
****    cs_entrega-g_cpais   = '1058'.
****    cs_entrega-g_xpais   = TEXT-t05.
*****    <fs_xmlh>-G_EMAIL

  ENDMETHOD.


  METHOD deposito_fechado_retirada.

****    DATA: ls_address    TYPE sadr,
****          ls_branch     TYPE j_1bbranch,
****          lv_cgc_number TYPE j_1bcgc,
****          ls_address1   TYPE addr1_val.
****
****    SELECT SINGLE centrodepfechado
****      FROM ztsd_centrofatdf
****      INTO @DATA(lv_dep_fechado)
****      WHERE centrofaturamento EQ @iv_werks_origem.
****    IF sy-subrc NE 0.
****      RETURN.
****    ENDIF.
****
****    IF iv_werks_origem EQ lv_dep_fechado.
****      RETURN.
****    ENDIF.
****
****    SELECT SINGLE werks,
****                  j_1bbranch,
****                  adrnr
****      FROM t001w
****      INTO @DATA(ls_t001w_retirada)
****      WHERE werks EQ @lv_dep_fechado.
****    IF sy-subrc NE 0.
****      RETURN.
****    ENDIF.
****
****
****    SELECT bukrs,
****           branch
****      FROM j_1bbranch
****      INTO TABLE @DATA(lt_1bbranch)
****      WHERE branch EQ @ls_t001w_retirada-j_1bbranch.
****    IF sy-subrc NE 0.
****      RETURN.
****    ENDIF.
****
****    READ TABLE lt_1bbranch INTO DATA(ls_1bbranch) INDEX 1.
****
****    CALL FUNCTION 'J_1BREAD_BRANCH_DATA'
****      EXPORTING
****        branch            = ls_1bbranch-branch
****        bukrs             = ls_1bbranch-bukrs
****      IMPORTING
****        address           = ls_address
****        branch_data       = ls_branch
****        cgc_number        = lv_cgc_number
****        address1          = ls_address1
****      EXCEPTIONS
****        branch_not_found  = 1
****        address_not_found = 2
****        company_not_found = 3
****        OTHERS            = 4.
****    IF sy-subrc EQ 0.
****      cs_retirada-f_cnpj = lv_cgc_number.
****      cs_retirada-f_ie   = ls_branch-state_insc.
****      cs_retirada-f_fone = ls_address1-tel_number.
****    ENDIF.
****
****
****    SELECT addrnumber,
****           name2,
****           street,
****           house_num1,
****           city1,
****           city2,
****           taxjurcode,
****           region,
****           post_code1
****      FROM adrc
****      INTO TABLE @DATA(lt_adrc)
****      WHERE addrnumber EQ @ls_t001w_retirada-adrnr.
****    IF sy-subrc NE 0.
****      RETURN.
****    ENDIF.
****
****    READ TABLE lt_adrc INTO DATA(ls_adrc) INDEX 1.
****
****    cs_retirada-f_xnome   = ls_adrc-name2.
****    cs_retirada-f_xlgr    = ls_adrc-street.
****    cs_retirada-f_nro     = ls_adrc-house_num1.
*****    <fs_xmlh>-f_XCPL
****    cs_retirada-f_xbairro = ls_adrc-city2.
****    cs_retirada-f_cmun    = ls_adrc-taxjurcode+3.
****    cs_retirada-f_xmun    = ls_adrc-city1.
****    cs_retirada-f_uf      = ls_adrc-region.
****
****    TRANSLATE ls_adrc-post_code1 USING '- '.
****    CONDENSE ls_adrc-post_code1 NO-GAPS.
****    cs_retirada-f_cep     = ls_adrc-post_code1.
****    cs_retirada-f_cpais   = '1058'.
****    cs_retirada-f_xpais   = TEXT-t05.
*****    <fs_xmlh>-f_EMAIL


  ENDMETHOD.


  METHOD deposito_fechado_text.

    DATA lv_nota TYPE char15.
    DATA lv_skip_dep TYPE abap_bool VALUE abap_false.

    LOOP AT it_partner ASSIGNING FIELD-SYMBOL(<fs_partner>).

      CASE <fs_partner>-parvw.
        WHEN 'WE'.
          cs_nfdoc-infcpl = |{ cs_nfdoc-infcpl } { TEXT-t01 } { <fs_partner>-parid } { <fs_partner>-sortl }|.
        WHEN 'Z1'.
          DATA(ls_partner) = <fs_partner>.
        WHEN OTHERS.
      ENDCASE.

      EXIT.
    ENDLOOP.


    IF iv_werks_receptor IS NOT INITIAL.
      cs_nfdoc-infcpl = |{ cs_nfdoc-infcpl } { TEXT-t02 }|.
      cs_nfdoc-infcpl = |{ cs_nfdoc-infcpl } { <fs_partner>-street } - { <fs_partner>-house_num1 } |. " { cs_nfdoc-g_xlgr } - { cs_xmlh-g_nro }, |.
      cs_nfdoc-infcpl = |{ cs_nfdoc-infcpl } { <fs_partner>-ort01 } - { <fs_partner>-regio }, |. "{ cs_nfdoc-g_xmun } - { cs_xmlh-g_uf }, |.
      cs_nfdoc-infcpl = |{ cs_nfdoc-infcpl } IE: { <fs_partner>-munins }, |. "IE: { cs_nfdoc-g_ie }, |.
      cs_nfdoc-infcpl = |{ cs_nfdoc-infcpl } CNPJ: { <fs_partner>-cgc }. |.  "CNPJ: { cs_nfdoc-g_cnpj }. |.
    ELSE.

      IF is_item-reftyp = 'MD'.

        SELECT COUNT( * )
          FROM ztmm_his_dep_fec
         WHERE purchase_order EQ @is_item-xped
           AND purchase_order_item EQ @is_item-nitemped.
        IF sy-subrc EQ 0.
          lv_skip_dep = abap_true.
        ENDIF.

      ENDIF.

      IF lv_skip_dep EQ abap_false.

        SELECT SINGLE centrodepfechado
          FROM ztsd_centrofatdf
          INTO @DATA(lv_dep_fechado)
          WHERE centrofaturamento EQ @iv_werks_origem.
        IF  sy-subrc EQ 0.
          cs_nfdoc-infcpl = |{ cs_nfdoc-infcpl } { TEXT-t03 }|.
          cs_nfdoc-infcpl = |{ cs_nfdoc-infcpl } { ls_partner-street } - { ls_partner-house_num1 } |. " { cs_nfdoc-f_xlgr } - { cs_xmlh-f_nro }, |.
          cs_nfdoc-infcpl = |{ cs_nfdoc-infcpl } { ls_partner-ort01 } - { ls_partner-regio }, |. "{ cs_nfdoc-f_xmun } - { cs_xmlh-f_uf }, |.
          cs_nfdoc-infcpl = |{ cs_nfdoc-infcpl } IE: { ls_partner-munins }, |. "IE: { cs_nfdoc-f_ie }, |.
          cs_nfdoc-infcpl = |{ cs_nfdoc-infcpl } CNPJ: { ls_partner-cgc }. |.  "CNPJ: { cs_nfdoc-f_cnpj }. |.
        ENDIF.
      ENDIF.

    ENDIF.

    IF is_header-series IS NOT INITIAL.
      lv_nota = |{ is_header-nfenum }-{ is_header-series }|.
    ELSE.
      lv_nota = |{ is_header-nfenum }|.
    ENDIF.

    IF is_item-reftyp EQ 'MD'.
      cs_nfdoc-infcpl = |{ cs_nfdoc-infcpl } { TEXT-t06 } { is_item-refkey(10) } / { is_item-refkey+10(4) } / { lv_nota } / { is_item-xped }|.
    ENDIF.

  ENDMETHOD.


  METHOD deposito_fechado_cest.

    DATA lv_text TYPE string.

    DATA(lt_nfitem) = it_nfitem.
    SORT lt_nfitem BY matnr.
    DELETE ADJACENT DUPLICATES FROM lt_nfitem COMPARING matnr.

    LOOP AT lt_nfitem ASSIGNING FIELD-SYMBOL(<fs_item>).
      IF <fs_item>-cest IS NOT INITIAL.

        CALL FUNCTION 'CONVERSION_EXIT_CCEST_OUTPUT'
          EXPORTING
            input  = <fs_item>-cest
          IMPORTING
            output = <fs_item>-cest.

*        cs_nfdoc-infcpl = |{ cs_nfdoc-infcpl } { TEXT-t04 } { <fs_item>-matnr ALPHA = OUT }: CEST { <fs_item>-cest ALPHA = OUT }|.
        lv_text = |{ TEXT-t04 } { <fs_item>-matnr ALPHA = OUT } { TEXT-t07 } { <fs_item>-cest ALPHA = OUT }|.
      ENDIF.

      CONDENSE lv_text.

      FIND lv_text IN cs_nfdoc-infcpl.
      IF sy-subrc NE 0.
        cs_nfdoc-infcpl = |{ cs_nfdoc-infcpl } - { lv_text }|.
      ENDIF.

      IF <fs_item>-nbm+10 IS NOT INITIAL.
        IF <fs_item>-cest IS NOT INITIAL.
          cs_nfdoc-infcpl = |{ cs_nfdoc-infcpl } - EXTIPI:{ <fs_item>-nbm+11 }|.
        ELSE.
          cs_nfdoc-infcpl = |{ cs_nfdoc-infcpl } { TEXT-t04 } { <fs_item>-matnr ALPHA = OUT }: EXTIPI { <fs_item>-nbm+11 }|.
        ENDIF.
      ENDIF.
    ENDLOOP.

  ENDMETHOD.


  METHOD danfe_deposito_fechado.

    CONSTANTS: BEGIN OF lc_param_df,
                 modulo    TYPE ztca_param_par-modulo VALUE 'SD',
                 chave1    TYPE ztca_param_par-chave1 VALUE 'DEPÓSITO FECHADO',
                 excecao   TYPE ztca_param_par-chave2 VALUE 'EXCEÇÕES',
                 local_ret TYPE ztca_param_par-chave2 VALUE 'LOCAL RETIRADA',
               END OF lc_param_df.

    TYPES: BEGIN OF ty_intercompany,
             purchaseorder TYPE ztsd_intercompan-purchaseorder,
             werks         TYPE ztsd_intercompan-werks_origem,
           END OF ty_intercompany.

    DATA lt_nflin_conv TYPE TABLE OF ty_intercompany.

    DATA: lt_werks_e  TYPE wrma_werks_ran_tab,
          lt_werks_lr TYPE wrma_werks_ran_tab.

    DATA: ls_xmlh             TYPE j1b_nf_xml_header,
          lv_bln_int_transf_r TYPE c, "se é processo de intercompany ou transferência
          lv_bln_int_transf_e TYPE c, "se é processo de intercompany ou transferência
          ls_tline            TYPE tline.

    lt_nflin_conv = CORRESPONDING #( it_nflin MAPPING purchaseorder = xped werks = werks ).
    SORT lt_nflin_conv BY purchaseorder werks.
    DELETE ADJACENT DUPLICATES FROM lt_nflin_conv
      COMPARING ALL FIELDS.

    DELETE lt_nflin_conv WHERE purchaseorder IS INITIAL.

    IF lt_nflin_conv IS INITIAL.
      RETURN.
    ENDIF.

    SELECT purchaseorder,
           werks_origem,
           werks_destino,
           werks_receptor
      FROM ztsd_intercompan
      FOR ALL ENTRIES IN @lt_nflin_conv
      WHERE ( processo EQ '1' ) "    OR processo NE '' )     " Transferência entre centros
        AND ( tipooperacao  EQ 'TRA2' OR tipooperacao NE '' ) " Depósito Fechado
        AND purchaseorder EQ @lt_nflin_conv-purchaseorder
      INTO TABLE @DATA(lt_intercompany).
    IF sy-subrc NE 0.
      RETURN.
    ELSE.

      TRY.
          DATA(lv_purord) = lt_nflin_conv[ 1 ]-purchaseorder.
          DATA(lo_param) = zclca_tabela_parametros=>get_instance( ).    " CHANGE - JWSILVA - 21.07.2023
          lo_param->m_get_range( EXPORTING iv_modulo = lc_param_df-modulo
                                           iv_chave1 = lc_param_df-chave1
                                           iv_chave2 = lc_param_df-excecao
                                 IMPORTING et_range  = lt_werks_e ).

          DATA(lv_werks_e) = lt_werks_e[ low = lt_intercompany[ werks_origem = lt_nflin_conv[ 1 ]-werks ]-werks_destino ]-high.
          DATA(lv_lifn2) = |{ CONV lifn2( lv_werks_e ) ALPHA = IN }|. "it_lin-werks

          SELECT COUNT( * )
            FROM ekpa
           WHERE ekpa~ebeln = @lv_purord
             AND ekpa~parvw = 'ZU'
             AND ekpa~lifn2 EQ @lv_lifn2.
          IF sy-subrc NE 0.
            SELECT COUNT( * ) BYPASSING BUFFER
              FROM t001w
              WHERE t001w~werks = @lv_werks_e.
            IF sy-subrc NE 0.
              lv_bln_int_transf_e = abap_true.
            ENDIF.
          ENDIF.

        CATCH cx_sy_itab_line_not_found zcxca_tabela_parametros.
          lv_bln_int_transf_e = abap_true.
      ENDTRY.

*          IF lv_bln_int_transf IS INITIAL.
      TRY.
          lo_param->m_get_range( EXPORTING iv_modulo = lc_param_df-modulo
                                           iv_chave1 = lc_param_df-chave1
                                           iv_chave2 = lc_param_df-local_ret
                                 IMPORTING et_range  = lt_werks_lr ).

          DATA(lv_werks_lr) = lt_werks_lr[ low = lt_nflin_conv[ 1 ]-werks ]-high.

        CATCH cx_sy_itab_line_not_found zcxca_tabela_parametros.
          lv_bln_int_transf_r = abap_true.
      ENDTRY.
*          ENDIF.

    ENDIF.

*    CHECK lv_bln_int_transf EQ abap_false.

    READ TABLE lt_intercompany INTO DATA(ls_intercompany) INDEX 1.

    ls_xmlh-nnf   = is_header-nfenum.
    ls_xmlh-serie = is_header-series.

*    FREE ct_inf_add.
*    LOOP AT it_hdr_msg ASSIGNING FIELD-SYMBOL(<fs_header_msg>).
*      CHECK <fs_header_msg>-message IS NOT INITIAL.
*
*      DATA(ls_tline) = VALUE tline( tdformat = '=' tdline = <fs_header_msg>-message ).
*      APPEND ls_tline TO ct_inf_add.
*    ENDLOOP.
*    IF sy-subrc EQ 0.
*      ls_tline = VALUE tline( tdformat = '=' tdline = ' - ' ).
*      APPEND ls_tline TO ct_inf_add.
*    ENDIF.

    IF lv_bln_int_transf_e EQ abap_false.

      deposito_fechado_entrega_xml( EXPORTING iv_werks_receptor = ls_intercompany-werks_receptor
                                    CHANGING  cs_entrega        = ls_xmlh ).

    ENDIF.

    IF lv_bln_int_transf_r EQ abap_false.

      deposito_fechado_retirada_xml( EXPORTING iv_werks_origem = ls_intercompany-werks_origem
                                     CHANGING  cs_retirada     = ls_xmlh ).

    ENDIF.

    READ TABLE it_nflin INTO DATA(ls_item) INDEX 1.
    deposito_fechado_text_xml( EXPORTING iv_werks_origem   = ls_intercompany-werks_origem
                                         iv_werks_receptor = ls_intercompany-werks_receptor
                                         is_header         = is_header
                                         is_item           = ls_item
                                         it_partner        = it_partner
                               CHANGING  cs_xmlh           = ls_xmlh
                                         ct_inf_add        = ct_inf_add ).

*    deposito_fechado_cest_xml( EXPORTING is_header = is_header
*                                         it_nfitem = it_nflin
*                               CHANGING  cs_xmlh   = ls_xmlh ).

    DATA lt_tline TYPE TABLE OF tdline.

    CALL FUNCTION 'RKD_WORD_WRAP'
      EXPORTING
        textline            = CONV char16384( ls_xmlh-infcomp )
        outputlen           = 132
      TABLES
        out_lines           = lt_tline
      EXCEPTIONS
        outputlen_too_large = 1
        OTHERS              = 2.
    IF sy-subrc EQ 0.

      LOOP AT lt_tline INTO ls_tline.
        FIND ls_tline IN TABLE ct_inf_add.
        IF sy-subrc NE 0.
          ct_inf_add = VALUE #( BASE ct_inf_add ( tdline = ls_tline ) ).
        ENDIF.
      ENDLOOP.

    ENDIF.

**    DO.
**      DATA(lv_len) = strlen( ls_xmlh-infcomp ).
**
**      IF lv_len LE 132.
**        ls_tline = VALUE tline( tdformat = '=' tdline = ls_xmlh-infcomp ).
**        APPEND ls_tline TO ct_inf_add.
**        EXIT.
**      ENDIF.
**
**      check_line( CHANGING ct_inf_add = ct_inf_add
**                           cv_infcomp = ls_xmlh-infcomp ).
**
**    ENDDO.

  ENDMETHOD.


  METHOD valida_centro.

*   Método para Validar se dois Centros são da mesma Empresa
    SELECT SINGLE t001k~bukrs BYPASSING BUFFER
      FROM t001w
      INNER JOIN t001k
         ON t001k~bwkey = t001w~bwkey
      INTO @DATA(lv_bukrs1)
      WHERE werks = @iv_centro1.

    SELECT SINGLE t001k~bukrs BYPASSING BUFFER
      FROM t001w
      INNER JOIN t001k
         ON t001k~bwkey = t001w~bwkey
      INTO @DATA(lv_bukrs2)
      WHERE werks = @iv_centro2.

    IF lv_bukrs1 = lv_bukrs2.
      rv_mesma_empresa = abap_true.
    ENDIF.

  ENDMETHOD.


  METHOD itens_lote.

    TYPES: BEGIN OF ty_tot_lips,
             vbeln TYPE lips-vbeln,
             posnr TYPE lips-posnr,
             lfimg TYPE lips-lfimg,
           END OF ty_tot_lips.

    DATA: ls_tot_lips TYPE ty_tot_lips,
          lt_tot_lips TYPE TABLE OF ty_tot_lips.

    FREE rv_result.

    DATA(ls_pedido) = is_item.

    DATA(lv_cond_value) =  ls_pedido-cond_value.

    LOOP AT it_lips INTO DATA(ls_lips).
      IF ls_lips-uecha <> '000000'.
        ls_tot_lips-vbeln = ls_lips-vbeln.
        ls_tot_lips-posnr = ls_lips-uecha.
        ls_tot_lips-lfimg = ls_lips-lfimg.
        COLLECT ls_tot_lips INTO lt_tot_lips.
        CLEAR ls_tot_lips.
      ENDIF.
    ENDLOOP.

    LOOP AT it_lips ASSIGNING FIELD-SYMBOL(<fs_lips_aux>).
      CHECK <fs_lips_aux>-uecha = ls_pedido-posnr. "itens com partição de lote

      READ TABLE lt_tot_lips INTO ls_tot_lips WITH KEY vbeln = ls_pedido-vbeln  "#EC CI_STDSEQ
                                                       posnr = ls_pedido-posnr. "#EC CI_STDSEQ

      IF sy-subrc = 0.

        CLEAR:  ls_pedido-cond_value.

        ls_pedido-charg = <fs_lips_aux>-charg.
        ls_pedido-bwtar = <fs_lips_aux>-bwtar.
        ls_pedido-lfimg = <fs_lips_aux>-lfimg.
        ls_pedido-vrkme = <fs_lips_aux>-vrkme.

        IF <fs_lips_aux>-lfimg IS NOT INITIAL.
          ls_pedido-cond_value = ( lv_cond_value * <fs_lips_aux>-lfimg ) / ls_tot_lips-lfimg.
          ls_pedido-condbaseval = ls_pedido-cond_value.
          ls_pedido-net_price = ls_pedido-cond_value.
        ENDIF.

        APPEND ls_pedido TO rv_result.

      ENDIF.

    ENDLOOP.

  ENDMETHOD.


  METHOD check_line.
    DATA: lv_character TYPE c.

    DATA(lv_pos) = 131.

    WHILE lv_pos GT 0.
      lv_character = cv_infcomp+lv_pos(1).
      IF lv_character IS INITIAL.
        DATA(ls_tline) = VALUE tline( tdformat = '=' tdline = cv_infcomp(lv_pos) ).
        APPEND ls_tline TO ct_inf_add.
        SHIFT cv_infcomp LEFT BY lv_pos PLACES.
        EXIT.
      ENDIF.
      lv_pos = lv_pos - 1.
    ENDWHILE.

  ENDMETHOD.


  METHOD check_lanc_entr_merc.

    SELECT ekbe~ebeln,
           ekbe~ebelp,
           ekbe~zekkn,
           ekbe~gjahr,
           ekbe~belnr,
           ekbe~buzei,
           mseg~mjahr AS ano_estorno,
           mseg~mblnr AS doc_estorno,
           mseg~zeile AS itm_estorno
      FROM ekbe
      LEFT JOIN mseg
        ON mseg~sjahr = ekbe~gjahr
       AND mseg~smbln = ekbe~belnr
       AND mseg~smblp = ekbe~buzei
      WHERE ekbe~ebeln EQ @iv_purchaseorder
        AND ekbe~vgabe EQ '1'
        AND ekbe~shkzg EQ 'S'
      INTO TABLE @DATA(lt_ekbe).
    IF sy-subrc EQ 0.
      LOOP AT lt_ekbe ASSIGNING FIELD-SYMBOL(<fs_ekbe>).
        CHECK <fs_ekbe>-doc_estorno IS INITIAL.
        RETURN.
      ENDLOOP.
    ENDIF.

    APPEND VALUE #( type       = 'E'
                    id         = 'ZSD_INTERCOMPANY'
                    number     = 037
                    message_v1 = iv_purchaseorder ) TO rt_return.

  ENDMETHOD.


  METHOD check_lanc_fat_receb.

    SELECT ekbe~ebeln,
           ekbe~ebelp,
           ekbe~zekkn,
           ekbe~gjahr,
           ekbe~belnr,
           rbkp~belnr AS doc_estorno,
           rbkp~gjahr AS ano_estorno
      FROM ekbe
      LEFT JOIN rbkp
         ON rbkp~stblg = ekbe~belnr
        AND rbkp~stjah = ekbe~gjahr
        AND rbkp~ivtyp = '5'
      WHERE ekbe~ebeln EQ @iv_purchaseorder
        AND ekbe~vgabe EQ '2'
        AND ekbe~shkzg EQ 'S'
      INTO TABLE @DATA(lt_ekbe).
    IF sy-subrc NE 0.
      APPEND VALUE #( type       = 'E'
                      id         = 'ZSD_INTERCOMPANY'
                      number     = 038
                      message_v1 = iv_purchaseorder ) TO rt_return.
      RETURN.
    ENDIF.

    LOOP AT lt_ekbe ASSIGNING FIELD-SYMBOL(<fs_ekbe>).
      CHECK <fs_ekbe>-doc_estorno IS INITIAL.
      RETURN.
    ENDLOOP.

    APPEND VALUE #( type       = 'E'
                    id         = 'ZSD_INTERCOMPANY'
                    number     = 038
                    message_v1 = iv_purchaseorder ) TO rt_return.

  ENDMETHOD.


  METHOD deposito_fechado_entrega_xml.

    DATA: ls_address    TYPE sadr,
          ls_branch     TYPE j_1bbranch,
          lv_cgc_number TYPE j_1bcgc,
          ls_address1   TYPE addr1_val.

    SELECT SINGLE werks,
                  j_1bbranch,
                  adrnr
      FROM t001w
      INTO @DATA(ls_t001w_entrega)
      WHERE werks EQ @iv_werks_receptor.
    IF sy-subrc NE 0.
      RETURN.
    ENDIF.


    SELECT bukrs,
           branch
      FROM j_1bbranch
      INTO TABLE @DATA(lt_1bbranch)
      WHERE branch EQ @ls_t001w_entrega-j_1bbranch.
    IF sy-subrc NE 0.
      RETURN.
    ENDIF.

    READ TABLE lt_1bbranch INTO DATA(ls_1bbranch) INDEX 1.

    CALL FUNCTION 'J_1BREAD_BRANCH_DATA'
      EXPORTING
        branch            = ls_1bbranch-branch
        bukrs             = ls_1bbranch-bukrs
      IMPORTING
        address           = ls_address
        branch_data       = ls_branch
        cgc_number        = lv_cgc_number
        address1          = ls_address1
      EXCEPTIONS
        branch_not_found  = 1
        address_not_found = 2
        company_not_found = 3
        OTHERS            = 4.
    IF sy-subrc EQ 0.
      cs_entrega-g_cnpj = lv_cgc_number.
      cs_entrega-g_ie   = ls_branch-state_insc.
      cs_entrega-g_fone = ls_address1-tel_number.
    ENDIF.


    SELECT addrnumber,
           name2,
           street,
           house_num1,
           city1,
           city2,
           taxjurcode,
           region,
           post_code1
      FROM adrc
      INTO TABLE @DATA(lt_adrc)
      WHERE addrnumber EQ @ls_t001w_entrega-adrnr.
    IF sy-subrc NE 0.
      RETURN.
    ENDIF.

    READ TABLE lt_adrc INTO DATA(ls_adrc) INDEX 1.

    cs_entrega-g_xnome   = ls_adrc-name2.
    cs_entrega-g_xlgr    = ls_adrc-street.
    cs_entrega-g_nro     = ls_adrc-house_num1.
*    <fs_xmlh>-G_XCPL
    cs_entrega-g_xbairro = ls_adrc-city2.
    cs_entrega-g_cmun    = ls_adrc-taxjurcode+3.
    cs_entrega-g_xmun    = ls_adrc-city1.
    cs_entrega-g_uf      = ls_adrc-region.

    TRANSLATE ls_adrc-post_code1 USING '- '.
    CONDENSE ls_adrc-post_code1 NO-GAPS.
    cs_entrega-g_cep     = ls_adrc-post_code1.
    cs_entrega-g_cpais   = '1058'.
    cs_entrega-g_xpais   = TEXT-t05.
*    <fs_xmlh>-G_EMAIL

  ENDMETHOD.


  METHOD deposito_fechado_cest_xml.

    DATA lv_text TYPE string.

    DATA(lt_nfitem) = it_nfitem.
    SORT lt_nfitem BY matnr.
    DELETE ADJACENT DUPLICATES FROM lt_nfitem COMPARING matnr.

    LOOP AT lt_nfitem ASSIGNING FIELD-SYMBOL(<fs_item>).
      IF <fs_item>-cest IS NOT INITIAL.

        CALL FUNCTION 'CONVERSION_EXIT_CCEST_OUTPUT'
          EXPORTING
            input  = <fs_item>-cest
          IMPORTING
            output = <fs_item>-cest.

*        cs_xmlh-infcomp = |{ cs_xmlh-infcomp } - { TEXT-t04 } { <fs_item>-matnr ALPHA = OUT } { TEXT-t07 } { <fs_item>-cest ALPHA = OUT }|.
        lv_text = |{ TEXT-t04 } { <fs_item>-matnr ALPHA = OUT } { TEXT-t07 } { <fs_item>-cest ALPHA = OUT }|.
      ENDIF.

      CONDENSE lv_text.

      FIND lv_text IN cs_xmlh-infcomp.
      IF sy-subrc NE 0.
        cs_xmlh-infcomp = |{ cs_xmlh-infcomp } - { lv_text }|.
      ENDIF.

* LSCHEPP - 8000006757, EXTIPI E HORÁRIO DE SAÍDA - 28.04.2023 Início
      FIND <fs_item>-cest IN cs_xmlh-infcomp.
      IF sy-subrc NE 0.
* LSCHEPP - 8000006757, EXTIPI E HORÁRIO DE SAÍDA - 28.04.2023 Fim
        IF <fs_item>-nbm+10 IS NOT INITIAL.
          IF <fs_item>-cest IS NOT INITIAL.
            cs_xmlh-infcomp = |{ cs_xmlh-infcomp } - EXTIPI: { <fs_item>-nbm+11 }|.
          ELSE.
            cs_xmlh-infcomp = |{ cs_xmlh-infcomp } - { TEXT-t04 } { <fs_item>-matnr ALPHA = OUT } EXTIPI: { <fs_item>-nbm+11 }|.
          ENDIF.
        ENDIF.
* LSCHEPP - 8000006757, EXTIPI E HORÁRIO DE SAÍDA - 28.04.2023 Início
      ENDIF.
* LSCHEPP - 8000006757, EXTIPI E HORÁRIO DE SAÍDA - 28.04.2023 Fim

    ENDLOOP.

  ENDMETHOD.


  METHOD deposito_fechado_retirada_xml.

    DATA: ls_address    TYPE sadr,
          ls_branch     TYPE j_1bbranch,
          lv_cgc_number TYPE j_1bcgc,
          ls_address1   TYPE addr1_val.

    SELECT SINGLE centrodepfechado
      FROM ztsd_centrofatdf
      INTO @DATA(lv_dep_fechado)
      WHERE centrofaturamento EQ @iv_werks_origem.
    IF sy-subrc NE 0.
      RETURN.
    ENDIF.

    IF iv_werks_origem EQ lv_dep_fechado.
      RETURN.
    ENDIF.

    SELECT SINGLE werks,
                  j_1bbranch,
                  adrnr
      FROM t001w
      INTO @DATA(ls_t001w_retirada)
      WHERE werks EQ @lv_dep_fechado.
    IF sy-subrc NE 0.
      RETURN.
    ENDIF.


    SELECT bukrs,
           branch
      FROM j_1bbranch
      INTO TABLE @DATA(lt_1bbranch)
      WHERE branch EQ @ls_t001w_retirada-j_1bbranch.
    IF sy-subrc NE 0.
      RETURN.
    ENDIF.

    READ TABLE lt_1bbranch INTO DATA(ls_1bbranch) INDEX 1.

    CALL FUNCTION 'J_1BREAD_BRANCH_DATA'
      EXPORTING
        branch            = ls_1bbranch-branch
        bukrs             = ls_1bbranch-bukrs
      IMPORTING
        address           = ls_address
        branch_data       = ls_branch
        cgc_number        = lv_cgc_number
        address1          = ls_address1
      EXCEPTIONS
        branch_not_found  = 1
        address_not_found = 2
        company_not_found = 3
        OTHERS            = 4.
    IF sy-subrc EQ 0.
      cs_retirada-f_cnpj = lv_cgc_number.
      cs_retirada-f_ie   = ls_branch-state_insc.
      cs_retirada-f_fone = ls_address1-tel_number.
    ENDIF.


    SELECT addrnumber,
           name2,
           street,
           house_num1,
           city1,
           city2,
           taxjurcode,
           region,
           post_code1
      FROM adrc
      INTO TABLE @DATA(lt_adrc)
      WHERE addrnumber EQ @ls_t001w_retirada-adrnr.
    IF sy-subrc NE 0.
      RETURN.
    ENDIF.

    READ TABLE lt_adrc INTO DATA(ls_adrc) INDEX 1.

    cs_retirada-f_xnome   = ls_adrc-name2.
    cs_retirada-f_xlgr    = ls_adrc-street.
    cs_retirada-f_nro     = ls_adrc-house_num1.
*    <fs_xmlh>-f_XCPL
    cs_retirada-f_xbairro = ls_adrc-city2.
    cs_retirada-f_cmun    = ls_adrc-taxjurcode+3.
    cs_retirada-f_xmun    = ls_adrc-city1.
    cs_retirada-f_uf      = ls_adrc-region.

    TRANSLATE ls_adrc-post_code1 USING '- '.
    CONDENSE ls_adrc-post_code1 NO-GAPS.
    cs_retirada-f_cep     = ls_adrc-post_code1.
    cs_retirada-f_cpais   = '1058'.
    cs_retirada-f_xpais   = TEXT-t05.
*    <fs_xmlh>-f_EMAIL


  ENDMETHOD.


  METHOD deposito_fechado_text_xml.

    DATA lv_nota TYPE char15.
    DATA lv_skip_dep TYPE abap_bool VALUE abap_false.

    IF is_item-reftyp = 'MD'.

      SELECT COUNT( * )
        FROM ztmm_his_dep_fec
       WHERE purchase_order EQ @is_item-xped
         AND purchase_order_item EQ @is_item-nitemped.
      IF sy-subrc EQ 0.
        lv_skip_dep = abap_true.
      ENDIF.

    ENDIF.

    LOOP AT it_partner ASSIGNING FIELD-SYMBOL(<fs_partner>).
      CHECK <fs_partner>-parvw = 'WE'.
      CHECK is_item-reftyp NE 'MD'.

      cs_xmlh-infcomp = |{ cs_xmlh-infcomp } { TEXT-t01 } { <fs_partner>-parid } { <fs_partner>-sortl }|.
      EXIT.
    ENDLOOP.


    IF iv_werks_receptor IS NOT INITIAL.
      FIND TEXT-t02 IN TABLE ct_inf_add.
      IF sy-subrc NE 0.
        cs_xmlh-infcomp = |{ cs_xmlh-infcomp } { TEXT-t02 }|.
        cs_xmlh-infcomp = |{ cs_xmlh-infcomp } { cs_xmlh-g_xlgr } - { cs_xmlh-g_nro }, |.
        cs_xmlh-infcomp = |{ cs_xmlh-infcomp } { cs_xmlh-g_xmun } - { cs_xmlh-g_uf }, |.
        cs_xmlh-infcomp = |{ cs_xmlh-infcomp } IE: { cs_xmlh-g_ie }, |.
        cs_xmlh-infcomp = |{ cs_xmlh-infcomp } CNPJ: { cs_xmlh-g_cnpj }. |.
      ENDIF.
    ELSE.

      IF lv_skip_dep EQ abap_false.

        SELECT SINGLE centrodepfechado
          FROM ztsd_centrofatdf
          INTO @DATA(lv_dep_fechado)
          WHERE centrofaturamento EQ @iv_werks_origem.
        IF  sy-subrc EQ 0.
          FIND TEXT-t03 IN TABLE ct_inf_add.
          IF sy-subrc NE 0.
            cs_xmlh-infcomp = |{ cs_xmlh-infcomp } { TEXT-t03 }|.
            cs_xmlh-infcomp = |{ cs_xmlh-infcomp } { cs_xmlh-f_xlgr } - { cs_xmlh-f_nro }, |.
            cs_xmlh-infcomp = |{ cs_xmlh-infcomp } { cs_xmlh-f_xmun } - { cs_xmlh-f_uf }, |.
            cs_xmlh-infcomp = |{ cs_xmlh-infcomp } IE: { cs_xmlh-f_ie }, |.
            cs_xmlh-infcomp = |{ cs_xmlh-infcomp } CNPJ: { cs_xmlh-f_cnpj }. |.
          ENDIF.
        ENDIF.
      ENDIF.

    ENDIF.

    IF cs_xmlh-serie IS NOT INITIAL.
      lv_nota = |{ cs_xmlh-nnf }-{ cs_xmlh-serie }|.
    ELSE.
      lv_nota = |{ cs_xmlh-nnf }|.
    ENDIF.

***    IF is_item-reftyp EQ 'MD'.
***      cs_xmlh-infcomp = |{ cs_xmlh-infcomp } { TEXT-t06 } { is_item-refkey(10) } / { is_item-refkey+10(4) } / { lv_nota } / { is_item-xped }|.
***    ENDIF.

  ENDMETHOD.


  METHOD deposito_fechado.

    DATA: lv_bln_int_transf TYPE c, "se é processo de intercompany ou transferência
          lr_vbelv          TYPE RANGE OF vbfa-vbelv.

    FIELD-SYMBOLS: <fs_xmlh>        TYPE j1b_nf_xml_header,
                   <fs_item_tab>    TYPE j_1bnflin_tab,
                   <fs_partner_tab> TYPE nfe_partner_tab.

    DATA(ls_lin) = it_nflin[ 1 ].

    TYPES: BEGIN OF ty_intercompany,
             purchaseorder TYPE ztsd_intercompan-purchaseorder,
           END OF ty_intercompany.
    DATA lt_nflin_conv TYPE TABLE OF ty_intercompany.

    lt_nflin_conv = CORRESPONDING #( it_nflin MAPPING purchaseorder = xped ).
    SORT lt_nflin_conv BY purchaseorder.
    DELETE ADJACENT DUPLICATES FROM lt_nflin_conv
      COMPARING purchaseorder.

    CLEAR: lv_bln_int_transf.
    IF ls_lin-reftyp = 'BI'. "Fatura de vendas
      IF NOT ls_lin-refkey IS INITIAL.
        SELECT vbelv
          INTO @DATA(lv_ov)
          FROM vbfa
          UP TO 1 ROWS
          WHERE vbelv   IN @lr_vbelv
            AND vbeln   EQ @ls_lin-refkey
            AND posnn   EQ @ls_lin-refitm
            AND vbtyp_n EQ 'M'
            AND vbtyp_v EQ 'C'. "OV
        ENDSELECT.
        IF lv_ov IS NOT INITIAL.
          SELECT SINGLE werks_origem,
                        werks_destino,
                        werks_receptor
          FROM ztsd_intercompan
          INTO @DATA(ls_intercompany)
          WHERE processo      EQ '2'    " Intercompany
            AND tipooperacao  EQ 'INT2' " Depósito Fechado
            AND salesorder    EQ @lv_ov.
          IF sy-subrc = 0.
            lv_bln_int_transf =  abap_true.
          ENDIF.
        ENDIF.
      ENDIF.
    ELSE. "Fatura MM

      IF ls_lin-xped IS INITIAL.
        RETURN.
      ENDIF.

      TRY.
          DATA(ls_lin_conv) = lt_nflin_conv[ 1 ].
        CATCH cx_sy_itab_line_not_found.
          RETURN.
      ENDTRY.

      SELECT SINGLE werks_origem,
                    werks_destino,
                    werks_receptor,
                    processo,
                    tipooperacao
        FROM ztsd_intercompan
        INTO @DATA(ls_transf)
        WHERE purchaseorder EQ @ls_lin_conv-purchaseorder.

      IF sy-subrc = 0 AND ( ls_transf-processo EQ '1' AND ls_transf-processo IS NOT INITIAL ) AND ( ls_transf-tipooperacao EQ 'TRA1' AND ls_transf-tipooperacao IS NOT INITIAL ).
        ls_intercompany = ls_transf.
        lv_bln_int_transf =  abap_true.
      ENDIF.
    ENDIF.

    IF NOT lv_bln_int_transf IS INITIAL. "se for processo de intercompany ou transferência (depósito fechado)

*      deposito_fechado_entrega( EXPORTING iv_werks_receptor = ls_intercompany-werks_receptor
*                                CHANGING  cs_entrega        = cs_doc ).
*
*      deposito_fechado_retirada( EXPORTING iv_werks_origem = ls_intercompany-werks_origem
*                                 CHANGING  cs_retirada     = cs_doc ).
*
*
*      ASSIGN ('(SAPLJ_1B_NFE)WK_ITEM[]') TO <fs_item_tab>.
*      IF <fs_item_tab> IS NOT ASSIGNED.
*        RETURN.
*      ENDIF.
*
*      READ TABLE <fs_item_tab> INTO DATA(ls_item) INDEX 1.
*      IF ls_item-itmnum EQ ls_lin-itmnum.
*
*        ASSIGN ('(SAPLJ_1B_NFE)WK_PARTNER[]') TO <fs_partner_tab>.
*        IF <fs_partner_tab> IS NOT ASSIGNED.
*          RETURN.
*        ENDIF.

      deposito_fechado_text( EXPORTING iv_werks_origem   = ls_intercompany-werks_origem
                                       iv_werks_receptor = ls_intercompany-werks_receptor
                                       is_header         = is_header
                                       is_item           = ls_lin
                                       it_partner        = it_partner
                             CHANGING  cs_nfdoc          = cs_doc ).

      deposito_fechado_cest( EXPORTING is_header = is_header
                                       it_nfitem = it_nflin
                             CHANGING  cs_nfdoc  = cs_doc ).
*      ENDIF.
    ENDIF.
  ENDMETHOD.


  METHOD deposito_fechado_xml.

    CONSTANTS: BEGIN OF lc_param_df,
                 modulo    TYPE ztca_param_par-modulo VALUE 'SD',
                 chave1    TYPE ztca_param_par-chave1 VALUE 'DEPÓSITO FECHADO',
                 excecao   TYPE ztca_param_par-chave2 VALUE 'EXCEÇÕES',
                 local_ret TYPE ztca_param_par-chave2 VALUE 'LOCAL RETIRADA',
               END OF lc_param_df.

    DATA: lt_werks_e  TYPE wrma_werks_ran_tab,
          lt_werks_lr TYPE wrma_werks_ran_tab.

    DATA: lv_bln_int_transf_r TYPE c, "se é processo de intercompany ou transferência RETIRADA
          lv_bln_int_transf_e TYPE c, "se é processo de intercompany ou transferência ENTREGA
          lr_vbelv            TYPE RANGE OF vbfa-vbelv.

    FIELD-SYMBOLS: <fs_xmlh>        TYPE j1b_nf_xml_header,
                   <fs_item_tab>    TYPE j_1bnflin_tab,
                   <fs_partner_tab> TYPE nfe_partner_tab.

    CLEAR: lv_bln_int_transf_r, lv_bln_int_transf_e.
    IF it_lin-reftyp = 'BI'. "Fatura de vendas
      IF NOT it_lin-refkey IS INITIAL.
        SELECT vbelv
          INTO @DATA(lv_ov)
          FROM vbfa
          UP TO 1 ROWS
          WHERE vbelv   IN @lr_vbelv
            AND vbeln   EQ @it_lin-refkey
            AND posnn   EQ @it_lin-refitm
            AND vbtyp_n EQ 'M'
            AND vbtyp_v EQ 'C'. "OV
        ENDSELECT.
        IF lv_ov IS NOT INITIAL.
          SELECT SINGLE werks_origem,
                        werks_destino,
                        werks_receptor
          FROM ztsd_intercompan
          INTO @DATA(ls_intercompany)
          WHERE processo      EQ '2'    " Intercompany
            AND tipooperacao  EQ 'INT2' " Depósito Fechado
            AND salesorder    EQ @lv_ov.
          IF sy-subrc = 0.
            lv_bln_int_transf_r = lv_bln_int_transf_e =  abap_true.
          ENDIF.
        ENDIF.
      ENDIF.
    ELSE. "Fatura MM

      IF it_lin-xped IS INITIAL.
        RETURN.
      ENDIF.

      SELECT SINGLE werks_origem,
                    werks_destino,
                    werks_receptor,
                    processo,
                    tipooperacao
        FROM ztsd_intercompan
*        INTO @DATA(ls_intercompany)
        INTO @DATA(ls_transf)
        WHERE purchaseorder EQ @it_lin-xped AND processo = '1'.

***      processo      eq '1'    " Transferência entre centros
***        and tipooperacao  eq 'TRA2' " Depósito Fechado
***        and

*      IF  sy-subrc NE 0.
*        RETURN.
*      ENDIF.
      IF sy-subrc = 0.
*      AND ( ls_transf-processo EQ '1' )." OR ls_transf-processo IS NOT INITIAL )
*      AND ( ls_transf-tipooperacao  EQ 'TRA2' OR ls_transf-tipooperacao IS NOT INITIAL ).

        TRY.
            DATA(lo_param) = zclca_tabela_parametros=>get_instance( ).    " CHANGE - JWSILVA - 21.07.2023
            lo_param->m_get_range( EXPORTING iv_modulo = lc_param_df-modulo
                                             iv_chave1 = lc_param_df-chave1
                                             iv_chave2 = lc_param_df-excecao
                                   IMPORTING et_range  = lt_werks_e ).
            TRY.
                DATA(lv_werks_e) = lt_werks_e[ low = ls_transf-werks_destino ]-high. "it_lin-werks
                DATA(lv_lifn2) = |{ CONV lifn2( lv_werks_e ) ALPHA = IN }|. "it_lin-werks

                SELECT COUNT( * )
                  FROM ekpa
                 WHERE ekpa~ebeln = @it_lin-xped
                   AND ekpa~parvw = 'ZU'
                   AND ekpa~lifn2 EQ @lv_lifn2.
                IF sy-subrc NE 0.
                  SELECT COUNT( * ) BYPASSING BUFFER
                    FROM t001w
                    WHERE t001w~werks = @lv_werks_e.
                  IF sy-subrc NE 0.
                    lv_bln_int_transf_e = abap_true.
                  ENDIF.
                ENDIF.
              CATCH cx_sy_itab_line_not_found.
                lv_bln_int_transf_e = abap_true.
            ENDTRY.
          CATCH zcxca_tabela_parametros.
            lv_bln_int_transf_e = abap_true.
        ENDTRY.


*                IF lv_bln_int_transf IS INITIAL.
        TRY.
            lo_param->m_get_range( EXPORTING iv_modulo = lc_param_df-modulo
                                             iv_chave1 = lc_param_df-chave1
                                             iv_chave2 = lc_param_df-local_ret
                                   IMPORTING et_range  = lt_werks_lr ).
            TRY.
                DATA(lv_werks_lr) = lt_werks_lr[ low = it_lin-werks ]-high.

              CATCH cx_sy_itab_line_not_found.
                lv_bln_int_transf_r = abap_true.
            ENDTRY.
          CATCH zcxca_tabela_parametros.
            lv_bln_int_transf_r = abap_true.
        ENDTRY.
*                ENDIF.

        ls_intercompany = ls_transf.
*        lv_bln_int_transf =  abap_true.
      ENDIF.

    ENDIF.

    ASSIGN ('(SAPLJ_1B_NFE)XMLH') TO <fs_xmlh>.
    IF <fs_xmlh> IS NOT ASSIGNED.
      RETURN.
    ENDIF.

**    IF NOT lv_bln_int_transf IS INITIAL. "se for processo de intercompany ou transferência (depósito fechado)
    IF lv_bln_int_transf_e EQ abap_false. "se for processo de intercompany ou transferência (depósito fechado) ENTREGA

      deposito_fechado_entrega_xml( EXPORTING iv_werks_receptor = ls_intercompany-werks_receptor
                                    CHANGING  cs_entrega        = <fs_xmlh> ).

    ENDIF.

    IF lv_bln_int_transf_r EQ abap_false. "se for processo de intercompany ou transferência (depósito fechado) RETIRADA

      deposito_fechado_retirada_xml( EXPORTING iv_werks_origem = ls_intercompany-werks_origem
                                     CHANGING  cs_retirada     = <fs_xmlh> ).

    ENDIF.


    ASSIGN ('(SAPLJ_1B_NFE)WK_ITEM[]') TO <fs_item_tab>.
    IF <fs_item_tab> IS NOT ASSIGNED.
      RETURN.
    ENDIF.

    READ TABLE <fs_item_tab> INTO DATA(ls_item) INDEX 1.
    IF ls_item-itmnum EQ it_lin-itmnum.

      ASSIGN ('(SAPLJ_1B_NFE)WK_PARTNER[]') TO <fs_partner_tab>.
      IF <fs_partner_tab> IS NOT ASSIGNED.
        RETURN.
      ENDIF.

      deposito_fechado_text_xml( EXPORTING iv_werks_origem   = ls_intercompany-werks_origem
                                           iv_werks_receptor = ls_intercompany-werks_receptor
                                           is_header         = it_doc
                                           is_item           = ls_item
                                           it_partner        = <fs_partner_tab>
                                 CHANGING  cs_xmlh           = <fs_xmlh> ).

      deposito_fechado_cest_xml( EXPORTING is_header = it_doc
                                           it_nfitem = <fs_item_tab>
                                 CHANGING  cs_xmlh   = <fs_xmlh> ).
    ENDIF.

  ENDMETHOD.
ENDCLASS.
