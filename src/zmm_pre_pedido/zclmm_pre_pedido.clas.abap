CLASS zclmm_pre_pedido DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    METHODS:

      "! Start the process
      execute
        IMPORTING
          is_pre_pedido TYPE zclmm_mt_pre_pedido
        RAISING
          zcxmm_erro_interface_mes,

      "! Start the delete process
      execute_delete
        IMPORTING
          is_item_del TYPE zclmm_mt_cancelar_pedido
        RAISING
          zcxmm_erro_interface_mes.

  PROTECTED SECTION.
  PRIVATE SECTION.

    TYPES:
      tt_poitem       TYPE STANDARD TABLE OF bapimepoitem  WITH DEFAULT KEY,
      tt_poitemx      TYPE STANDARD TABLE OF bapimepoitemx WITH DEFAULT KEY,
      tt_poschedule   TYPE STANDARD TABLE OF bapimeposchedule WITH DEFAULT KEY,
      tt_poschedulex  TYPE STANDARD TABLE OF bapimeposchedulx WITH DEFAULT KEY,
      tt_account      TYPE STANDARD TABLE OF bapimepoaccount  WITH DEFAULT KEY,
      tt_accountx     TYPE STANDARD TABLE OF bapimepoaccountx  WITH DEFAULT KEY,
      tt_theader      TYPE STANDARD TABLE OF bapimepotextheader WITH DEFAULT KEY,
      tt_titem        TYPE STANDARD TABLE OF bapimepotext WITH DEFAULT KEY,
      tt_addr         TYPE STANDARD TABLE OF bapimepoaddrdelivery WITH DEFAULT KEY,
      tt_ret          TYPE STANDARD TABLE OF bapiret2,
      tt_item         TYPE STANDARD TABLE OF ztmm_pedido_me   WITH DEFAULT KEY,
      tt_controle_int TYPE STANDARD TABLE OF ztmm_control_int WITH DEFAULT KEY,
      tt_partner      TYPE STANDARD TABLE OF bapiekkop  WITH DEFAULT KEY.


    CONSTANTS:
      BEGIN OF gc_values,
        modulo     TYPE ze_param_modulo    VALUE 'MM'  ##NO_TEXT,
        ch1        TYPE ze_param_chave     VALUE 'ME'  ##NO_TEXT,
        ef         TYPE pabez      VALUE 'EF'  ##NO_TEXT,
        fm         TYPE pabez      VALUE 'FM'  ##NO_TEXT,
        ch2        TYPE ze_param_chave     VALUE 'CODE_RELEASE' ##NO_TEXT,
        ch3        TYPE ze_param_chave_3   VALUE 'REL_CODE'  ##NO_TEXT,
        h          TYPE memorytype  VALUE 'H',
        e109       TYPE string VALUE '109' ##NO_TEXT,
        s104       TYPE string VALUE '104' ##NO_TEXT,
        s3         TYPE string VALUE '3' ##NO_TEXT,
        v1         TYPE char1 VALUE '1' ##NO_TEXT,
        v2         TYPE char1 VALUE '2' ##NO_TEXT,
        o109_1     TYPE string VALUE 'Pré-Pedido sem código de Fornecedor' ##NO_TEXT,
        o109_2     TYPE string VALUE 'Erro geração Pedido SAP' ##NO_TEXT,
        o104_1     TYPE string VALUE 'Aguadando aprovação no SAP.' ##NO_TEXT,
        vendor     TYPE string VALUE 'Vendor não encontrado na tabela LFA1' ##NO_TEXT,
        erro       TYPE string VALUE 'ERRO',
        classe     TYPE string VALUE 'ZMM_PRE_PEDIDO',
        msgno0     TYPE symsgno  VALUE '000',
        msgno1     TYPE symsgno  VALUE '001',
        msgno2     TYPE symsgno  VALUE '002',
        msgno3     TYPE symsgno  VALUE '003',
        msgno4     TYPE symsgno  VALUE '004',
        msgno5     TYPE symsgno  VALUE '005',
        msgno6     TYPE symsgno  VALUE '006',
        msgno12    TYPE symsgno  VALUE '012',
        e          TYPE c        VALUE 'E',
        v5         TYPE ze_tp_proc VALUE '05',
        f          TYPE c VALUE 'F',
        p          TYPE c VALUE 'P',
        a          TYPE c VALUE 'A',
        k          TYPE c VALUE 'K',
        w          TYPE c VALUE 'W',
        v          TYPE c VALUE 'V',
        sim        TYPE c VALUE 'S',
        nao        TYPE c VALUE 'N',
        m          TYPE me_dptyp VALUE 'M',
        f01        TYPE tdid     VALUE 'F01',
        f04        TYPE tdid     VALUE 'F04',
        txtitem    TYPE string   VALUE 'TEXTOITEM',
        gptipo     TYPE string   VALUE 'GrpTipoProduto',
        dtfim      TYPE string   VALUE 'DataFim',
        EntMerc    TYPE string   VALUE 'EntradaMercadoria',
        bapi       TYPE symsgid  VALUE 'BAPI',
        mepo       TYPE symsgid  VALUE 'MEPO',
        textheader TYPE  tdline  VALUE 'Pedido Criado Via Integração Mercado Eletrônico.',
        format     TYPE tdformat VALUE '*',
      END OF gc_values .

    DATA: gs_pre_pedido TYPE zclmm_mt_pre_pedido-mt_pre_pedido.

    DATA: gt_return TYPE tt_ret,
          gt_ret    TYPE STANDARD TABLE OF bapireturn.

    "! Validate registers M.E
    METHODS validate_reg
      RAISING
        !zcxmm_erro_interface_mes .

    "! Return error
    METHODS interface_12
      IMPORTING
        !iv_ebeln   TYPE string
        !iv_ref_1   TYPE string
        !iv_vendor  TYPE string
        !iv_obs_erp TYPE string
        !iv_status  TYPE string
      RAISING
        zcxmm_erro_interface_mes .

    "! Get data from table parameters
    METHODS get_parameters
      EXPORTING
        !ev_param TYPE ze_param_low .

    "! Status release
    METHODS bapi_release
      RAISING
        !zcxmm_erro_interface_mes .

    "! Create order
    METHODS bapi_create
      RAISING
        !zcxmm_erro_interface_mes .

    "! Validate vendor
    METHODS validate_vendor
      RAISING
        !zcxmm_erro_interface_mes .

    "! Change order
    METHODS bapi_change
      RAISING
        !zcxmm_erro_interface_mes .

    "! Search item
    METHODS item_refresh .

    "! Fill header
    METHODS header
      EXPORTING
        !es_header  TYPE bapimepoheader
        !es_headerx TYPE bapimepoheaderx .

    "! Fill item
    METHODS item
      EXPORTING
        !et_item  TYPE tt_poitem
        !et_itemx TYPE tt_poitemx .

    "! Fill schedule
    METHODS schedule
      EXPORTING
        !et_poschedule  TYPE tt_poschedule
        !et_poschedulex TYPE tt_poschedulex .

    "! Fill account
    METHODS account
      EXPORTING
        !et_accountx TYPE tt_accountx
        !et_account  TYPE tt_account .

    "! Fill text
    METHODS text
      EXPORTING
        !et_theader TYPE tt_theader
        !et_titem   TYPE tt_titem .

    "! Commit work
    METHODS commit_work .

    "! Fill delete item
    METHODS item_delete
      CHANGING
        !ct_item  TYPE tt_poitem
        !ct_itemx TYPE tt_poitemx .

    "! Call GAP 415|R01
    METHODS gap_415r01
      RAISING
        !zcxmm_erro_interface_mes .

    "! Fill file ME
    METHODS file_me_create
      EXPORTING
        !es_arquivo_me TYPE zsmm_arquivo_me .

    "! Call interface 23 - refresh table
    METHODS interface_23
      IMPORTING
        !iv_status TYPE string
        !iv_obs    TYPE string
      RAISING
        zcxmm_erro_interface_mes .

    "! Table return
    METHODS table_ret
      IMPORTING
        !iv_release_tab TYPE c OPTIONAL
      EXPORTING
        !ev_ret         TYPE string .

    "! Save data into table SAP
    METHODS table_me_save
      IMPORTING
        !iv_status TYPE string
        !iv_obs    TYPE string
      RAISING
        !zcxmm_erro_interface_mes .

    "! Trigger the error
    METHODS error_raise
      IMPORTING
        !is_ret TYPE scx_t100key
      RAISING
        !zcxmm_erro_interface_mes .

    "! Steps of error
    METHODS steps_erro
      RAISING
        !zcxmm_erro_interface_mes .

    "! Save data into table of log
    METHODS save_log
      IMPORTING
        !iv_desc TYPE string OPTIONAL .

    "! Steps to save
    METHODS steps_save
      RAISING
        !zcxmm_erro_interface_mes .

    "! Table return with items
    METHODS error_ret
      EXPORTING
        !et_controle_int TYPE tt_controle_int .

    "! Table return release
    METHODS error_release
      RAISING
        !zcxmm_erro_interface_mes .

    "! Pack
    METHODS pack
      IMPORTING
                !iv_matnr       TYPE matnr18
      RETURNING VALUE(rv_matnr) TYPE matnr18.

    "! Unit of measure converter
    METHODS conv_me
      IMPORTING
        !iv_me       TYPE char3
      RETURNING
        VALUE(rv_me) TYPE char3 .

    "! Fill structure to delete items
    METHODS fill_delete_item
      IMPORTING
        !is_item_delete TYPE zclmm_mt_cancelar_pedido
      EXPORTING
        !et_item        TYPE tt_poitem
        !et_itemx       TYPE tt_poitemx.

    "! Trigger interface 12
    METHODS send_return
      IMPORTING
        !it_ret         TYPE tt_ret
        !is_item_delete TYPE zclmm_mt_cancelar_pedido
      RAISING
        !zcxmm_erro_interface_mes.

    "! Concatenate return bapi
    METHODS get_text
      IMPORTING
        it_message     TYPE tt_ret
      RETURNING
        VALUE(rv_text) TYPE string.

    "! Error raise
    METHODS raise_change
      IMPORTING
        it_return TYPE tt_ret
      RAISING
        zcxmm_erro_interface_mes.
    METHODS conv_preco
      IMPORTING
        iv_item_valor    TYPE string
      RETURNING
        VALUE(rv_result) TYPE dec23_2.
    METHODS get_cat
      IMPORTING
        is_item          TYPE zclmm_dt_pre_predido_itens
      RETURNING
        VALUE(rv_result) TYPE char1.
    METHODS conv_date
      IMPORTING
        iv_eindt         TYPE string
      RETURNING
        VALUE(rv_result) TYPE dats.
    METHODS replace
      IMPORTING
        iv_eindt       TYPE string
      RETURNING
        VALUE(rv_date) TYPE eeind.
    METHODS partner
      EXPORTING
        et_partner TYPE tt_partner.
    METHODS get_merc
      IMPORTING
        Is_itens         TYPE zclmm_dt_pre_predido_itens
      RETURNING
        VALUE(rv_result) TYPE char1.
    METHODS addresdelivery
      EXPORTING
        et_addr TYPE tt_addr.
    METHODS get_addr
      IMPORTING
        iv_localentregacliente TYPE string
      RETURNING
        VALUE(rv_result)       TYPE ad_addrnum.
    METHODS conv_dec
      IMPORTING
        iv_adiantamento  TYPE string
      RETURNING
        VALUE(rv_result) TYPE me_dppcnt.
    METHODS conv_dats
      IMPORTING
        iv_data_adiantamento TYPE string
      RETURNING
        VALUE(rv_result)     TYPE me_dpddat.
    METHODS attach_link.
    METHODS concat
      RETURNING
        VALUE(rv_result) TYPE so_text255.
ENDCLASS.



CLASS ZCLMM_PRE_PEDIDO IMPLEMENTATION.


  METHOD validate_reg.

    IF gs_pre_pedido-vendor IS INITIAL.

      me->interface_12( EXPORTING iv_ebeln   = CONV string( gs_pre_pedido-ebeln  )
                                  iv_ref_1   = CONV string( gs_pre_pedido-ref_1  )
                                  iv_vendor  = CONV string( gs_pre_pedido-vendor )
                                  iv_obs_erp = gc_values-o109_1
                                  iv_status  = gc_values-e109 ).
    ELSE.

      me->validate_vendor(  ).

    ENDIF.

  ENDMETHOD.


  METHOD interface_12.

    TRY.

        NEW zclmm_co_si_processar_status_p(  )->si_processar_status_pre_pedido(
            EXPORTING
            output = VALUE zclmm_mt_mensagem_status_pre_p( mt_mensagem_status_pre_pedido-ebeln   = iv_ebeln
                                                           mt_mensagem_status_pre_pedido-ref_1   = iv_ref_1
                                                           mt_mensagem_status_pre_pedido-vendor  = iv_vendor
                                                           mt_mensagem_status_pre_pedido-status  = iv_status
                                                           mt_mensagem_status_pre_pedido-obs_erp = iv_obs_erp )
         ).
      CATCH cx_ai_system_fault .
        me->error_raise( is_ret = VALUE scx_t100key(  msgid = gc_values-classe msgno = gc_values-msgno6 ) ).
    ENDTRY.

  ENDMETHOD.


  METHOD get_parameters.

    TRY.

        NEW zclca_tabela_parametros( )->m_get_single(
        EXPORTING
            iv_modulo = gc_values-modulo
            iv_chave1 = gc_values-ch1
            iv_chave2 = gc_values-ch2
            iv_chave3 = gc_values-ch3
        IMPORTING
            ev_param = ev_param
        ).

      CATCH zcxca_tabela_parametros.
    ENDTRY.

  ENDMETHOD.


  METHOD bapi_release.

    DATA(ls_item) = VALUE #( gs_pre_pedido-itens[ 1 ] OPTIONAL ).

    IF ls_item IS NOT INITIAL.

      me->get_parameters( IMPORTING ev_param = DATA(lv_rel_code) ).

      TRY.

*          me->item_refresh(  ).

          IF gs_pre_pedido-ebeln IS INITIAL.
            me->bapi_create(  ).
          ELSE.
            me->bapi_change(  ).
          ENDIF.

        CATCH zcxmm_erro_interface_mes.
          me->error_raise( is_ret = VALUE scx_t100key(  msgid = gc_values-classe msgno = gc_values-msgno1 ) ).
      ENDTRY.

    ENDIF.

  ENDMETHOD.


  METHOD bapi_create.

    DATA: ls_poheader TYPE bapimepoheader,
          ls_bapieikp TYPE bapieikp.

    REFRESH gt_return.

    TRY.

        me->header( IMPORTING es_header = DATA(ls_header) es_headerx = DATA(ls_headerx) ).

        me->item( IMPORTING et_item = DATA(lt_item) et_itemx = DATA(lt_itemx) ).

        me->schedule( IMPORTING et_poschedule = DATA(lt_shedule) et_poschedulex = DATA(lt_shedulex) ).

        me->account( IMPORTING et_account = DATA(lt_account) et_accountx = DATA(lt_accountx) ).

        me->text( IMPORTING  et_theader = DATA(lt_theader) et_titem = DATA(lt_titem) ).

        me->partner( IMPORTING et_partner = DATA(lt_partner) ).

        me->addresdelivery( IMPORTING et_addr = DATA(lt_addr) ).


        CALL FUNCTION 'BAPI_PO_CREATE1'
          EXPORTING
            poheader          = ls_header
            poheaderx         = ls_headerx
            memory_complete   = abap_true
          IMPORTING
            exppurchaseorder  = gs_pre_pedido-ebeln
            expheader         = ls_poheader
            exppoexpimpheader = ls_bapieikp
          TABLES
            return            = gt_return
            poitem            = lt_item
            poitemx           = lt_itemx
            poaddrdelivery    = lt_addr
            poschedule        = lt_shedule
            poschedulex       = lt_shedulex
            poaccount         = lt_account
            poaccountx        = lt_accountx
            potextheader      = lt_theader
            potextitem        = lt_titem
            popartner         = lt_partner.

        IF NOT line_exists( gt_return[ type = gc_values-e ] ).

          me->steps_save(  ).
          me->attach_link(  ).

        ELSE.

          me->steps_erro(  ).

        ENDIF.

      CATCH zcxmm_erro_interface_mes.
        me->error_raise( is_ret = VALUE scx_t100key(  msgid = gc_values-classe msgno = gc_values-msgno2 ) ).
    ENDTRY.

  ENDMETHOD.


  METHOD execute.

    gs_pre_pedido = is_pre_pedido-mt_pre_pedido.

    me->validate_reg(  ).

  ENDMETHOD.


  METHOD validate_vendor.

    SELECT SINGLE lifnr FROM lfa1
        INTO @DATA(lv_lifnr)
         WHERE lifnr EQ @gs_pre_pedido-vendor.

    IF sy-subrc NE 0.

      me->interface_12( EXPORTING iv_ebeln   = CONV string( gs_pre_pedido-ebeln  )
                                  iv_ref_1   = CONV string( gs_pre_pedido-ref_1  )
                                  iv_vendor  = CONV string( gs_pre_pedido-vendor )
                                  iv_obs_erp = gc_values-vendor
                                  iv_status  = gc_values-e109 ).

    ELSE.

      me->bapi_release(  ).

    ENDIF.


  ENDMETHOD.


  METHOD bapi_change.

    REFRESH gt_return.

    TRY.

        me->item( IMPORTING et_item = DATA(lt_item) et_itemx = DATA(lt_itemx) ).

        IF gs_pre_pedido-cancelado IS INITIAL.

          me->header( IMPORTING es_header = DATA(ls_header) es_headerx = DATA(ls_headerx) ).

          me->schedule( IMPORTING et_poschedule = DATA(lt_shedule) et_poschedulex = DATA(lt_shedulex) ).

          me->account( IMPORTING et_account = DATA(lt_account) et_accountx = DATA(lt_accountx) ).

          me->text( IMPORTING et_theader = DATA(lt_theader) et_titem = DATA(lt_titem) ).

        ENDIF.

        CALL FUNCTION 'BAPI_PO_CHANGE'
          EXPORTING
            purchaseorder = gs_pre_pedido-ebeln
            poheader      = ls_header
            poheaderx     = ls_headerx
          TABLES
            return        = gt_return
            poitem        = lt_item
            poitemx       = lt_itemx
            poschedule    = lt_shedule
            poschedulex   = lt_shedulex
            poaccount     = lt_account
            poaccountx    = lt_accountx
            potextheader  = lt_theader
            potextitem    = lt_titem.

        IF NOT line_exists( gt_return[ type = gc_values-e ] ).
          me->steps_save(  ).
        ELSE.
          me->steps_erro(  ).
        ENDIF.

      CATCH zcxmm_erro_interface_mes.
        me->error_raise( is_ret = VALUE scx_t100key(  msgid = gc_values-classe msgno = gc_values-msgno3 ) ).
    ENDTRY.

  ENDMETHOD.


  METHOD item_refresh.

    CHECK gs_pre_pedido-itens IS NOT INITIAL.

    SELECT Material, plant, PurchaseContractItem FROM I_PurchaseContractItem
    FOR ALL ENTRIES IN @gs_pre_pedido-itens
        WHERE PurchaseContract = @gs_pre_pedido-itens-agreement
    INTO TABLE @DATA(lt_purchase).

    IF sy-subrc EQ 0.

      gs_pre_pedido-itens = VALUE zclmm_dt_pre_predido_itens_tab( "#EC CI_CONV_OK
                                     FOR ls_item IN gs_pre_pedido-itens
                                     FOR ls_purchase IN lt_purchase WHERE ( Material = ls_item-matnr "AND
*                                                                            Plant    = ls_item-werks
                                                                             )
                                      (
                                        agmt_item = ls_purchase-PurchaseContractItem
                                      ) ).

    ENDIF.

  ENDMETHOD.


  METHOD header.

*  select * from  I_PURCHASEORDERAPI01
*  where DownPaymentType =

    es_header = VALUE bapimepoheader(
    comp_code  = gs_pre_pedido-comp_code
    doc_type   = gs_pre_pedido-doc_type
    created_by = gs_pre_pedido-created_by
    vendor     = gs_pre_pedido-vendor
    pmnttrms   = gs_pre_pedido-pmnttrms
    purch_org  = gs_pre_pedido-purch_org
    pur_group  = gs_pre_pedido-pur_group
    currency   = gs_pre_pedido-waers
    ref_1      = gs_pre_pedido-ref_1
    incoterms1 = gs_pre_pedido-inco1
    incoterms2 = gs_pre_pedido-inco1
    collect_no = gs_pre_pedido-collect_no
    memory     = abap_true
    memorytype = gc_values-h
     ).

    es_headerx = VALUE bapimepoheaderx(
    comp_code  = abap_true
    doc_type   = abap_true
    created_by = abap_true
    vendor     = abap_true
    pmnttrms   = abap_true
    purch_org  = abap_true
    pur_group  = abap_true
    currency   = abap_true
    ref_1      = abap_true
    incoterms1 = abap_true
    incoterms2 = abap_true
    collect_no = abap_true
    memory     = abap_true
    memorytype = abap_true
     ).

  ENDMETHOD.


  METHOD schedule.

    et_poschedule = VALUE tt_poschedule(
                FOR ls_itens IN gs_pre_pedido-itens INDEX INTO lv_index (
                po_item        = COND #( WHEN ls_itens-ebelp IS NOT INITIAL THEN NEW zclmm_me_conv_num_item(  )->get_n_item( EXPORTING iv_num = ls_itens-ebelp ) ELSE ( lv_index * 10 ) )
                sched_line     = sy-tabix
*                delivery_date  = replace( ls_itens-eindt )
*                stat_date      = conv_date( ls_itens-eindt )
                delivery_date  = COND #( WHEN VALUE #( ls_itens-atributos[ nome_atributo = gc_values-gptipo ]-valor_atributo OPTIONAL ) EQ 2
                                           THEN NEW zclmm_me_conv_num_item(  )->get_dt_fim( EXPORTING iv_dtfim = ls_itens-atributos[ nome_atributo = gc_values-dtfim ]-valor_atributo ) ELSE replace( ls_itens-eindt ) )
                stat_date      = COND #( WHEN VALUE #( ls_itens-atributos[ nome_atributo = gc_values-gptipo ]-valor_atributo OPTIONAL ) EQ 2
                                           THEN NEW zclmm_me_conv_num_item(  )->get_dt_fim( EXPORTING iv_dtfim = ls_itens-atributos[ nome_atributo = gc_values-dtfim ]-valor_atributo ) ELSE conv_date( ls_itens-eindt ) )
                po_date        = sy-datum
                quantity       = ls_itens-menge
                 ) ).

    et_poschedulex = VALUE tt_poschedulex(
                FOR ls_schedulex IN et_poschedule (
                po_item        = ls_schedulex-po_item
                sched_line     = ls_schedulex-sched_line
                po_itemx       = abap_true
                delivery_date  = abap_true
                quantity       = abap_true
                stat_date      = abap_true
                po_date        = abap_true
                 ) ).

  ENDMETHOD.


  METHOD account.

    DATA: ls_item TYPE  zclmm_dt_pre_predido_itens.

    LOOP AT gs_pre_pedido-classficacao_contabil ASSIGNING FIELD-SYMBOL(<fs_class>) GROUP BY (
        ebelp = <fs_class>-ebelp
        size = GROUP SIZE
        index = GROUP INDEX
    )
    INTO DATA(lt_grp).

      LOOP AT GROUP lt_grp INTO DATA(ls_grp).

        IF ls_item IS INITIAL.
          ls_item  = VALUE #( gs_pre_pedido-itens[ ebelp = ls_grp-ebelp ] OPTIONAL ). "#EC CI_STDSEQ
        ENDIF.

        CHECK ls_item IS NOT INITIAL.

        et_account = VALUE #( BASE et_account (
                        po_item      = COND #( WHEN ls_grp-ebelp IS NOT INITIAL THEN NEW zclmm_me_conv_num_item(  )->get_n_item( EXPORTING iv_num = ls_grp-ebelp ) ELSE ( sy-tabix * 10 ) )
                        serial_no   = sy-tabix
                        quantity    = ls_grp-quantity
                        gl_account  = ls_grp-sakto
                        costcenter  = COND #( WHEN ls_item-knttp = gc_values-k THEN ls_grp-kostl )
                        asset_no    = COND #( WHEN ls_item-knttp = gc_values-a THEN ls_grp-anln1 )
                        sub_number  = COND #( WHEN ls_item-knttp = gc_values-a THEN ls_grp-anln2 )
                        orderid     = COND #( WHEN ls_item-knttp = gc_values-f THEN ls_grp-aufnr )
                        wbs_element = COND #( WHEN ls_item-knttp = gc_values-p THEN ls_grp-ps_psp_pnr )
        ) ).

      ENDLOOP.

      CLEAR: ls_item.

    ENDLOOP.

    et_accountx = VALUE tt_accountx(
        FOR ls_account IN et_account (
              po_item     = ls_account-po_item
              serial_no   = ls_account-serial_no
              quantity    = abap_true
              gl_account  = abap_true
              costcenter  = COND #( WHEN ls_account-costcenter  IS NOT INITIAL THEN abap_true  )
              asset_no    = COND #( WHEN ls_account-asset_no    IS NOT INITIAL THEN abap_true  )
              sub_number  = COND #( WHEN ls_account-sub_number  IS NOT INITIAL THEN abap_true  )
              orderid     = COND #( WHEN ls_account-orderid     IS NOT INITIAL THEN abap_true  )
              wbs_element = COND #( WHEN ls_account-wbs_element IS NOT INITIAL THEN abap_true  )
         ) ).

  ENDMETHOD.


  METHOD text.


    LOOP AT gs_pre_pedido-itens ASSIGNING FIELD-SYMBOL(<fs_item>).

      et_titem = VALUE #( BASE et_titem (
                            po_item   = COND #( WHEN gs_pre_pedido-ebeln IS NOT INITIAL THEN NEW zclmm_me_conv_num_item(  )->get_n_item( EXPORTING iv_num = <fs_item>-ebelp ) ELSE ( sy-tabix * 10 ) )
                            text_id   = gc_values-f01
                            text_line = VALUE #( <fs_item>-atributos[ nome_atributo = gc_values-txtitem ]-valor_atributo OPTIONAL ) )
                          ( po_item   = COND #( WHEN gs_pre_pedido-ebeln IS NOT INITIAL THEN NEW zclmm_me_conv_num_item(  )->get_n_item( EXPORTING iv_num = <fs_item>-ebelp ) ELSE ( sy-tabix * 10 ) )
                            text_id   = gc_values-f04
                            text_line = <fs_item>-textoitemremessa )
                            ) .

      et_theader = VALUE #( BASE et_theader (
                              po_item   = COND #( WHEN gs_pre_pedido-ebeln IS NOT INITIAL THEN NEW zclmm_me_conv_num_item(  )->get_n_item( EXPORTING iv_num = <fs_item>-ebelp ) ELSE ( sy-tabix * 10 ) )
                              text_id   = gc_values-f01
                              text_form = gc_values-format
                              text_line = gc_values-textheader ) ).

    ENDLOOP.

  ENDMETHOD.


  METHOD commit_work.

    CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
      EXPORTING
        wait = abap_true.

  ENDMETHOD.


  METHOD item.

    IF gs_pre_pedido-cancelado EQ gc_values-sim.

      me->item_delete( CHANGING ct_item = et_item ct_itemx = et_itemx ).

    ELSE.

      et_item = VALUE tt_poitem(
                FOR ls_itens IN gs_pre_pedido-itens INDEX INTO lv_index (
                    material     = pack( CONV #( ls_itens-matnr ) )
                    ematerial    = pack( CONV #( ls_itens-matnr ) )
                    po_item      = COND #( WHEN ls_itens-ebelp IS NOT INITIAL THEN NEW zclmm_me_conv_num_item(  )->get_n_item( EXPORTING iv_num = ls_itens-ebelp ) ELSE ( lv_index * 10 ) )
                    plant        = ls_itens-werks
                    net_price    = ls_itens-netpr
                    po_unit      = conv_me( ls_itens-meins )
                    item_cat     = get_cat( ls_itens )
                    tax_code     = ls_itens-mwskz
                    preq_no      = ls_itens-banfn
                    preq_item    = ls_itens-bnfpo
                    po_price     = gc_values-v2
                    quantity     = ls_itens-menge
                    acctasscat   = COND #( WHEN ls_itens-knttp EQ gc_values-v THEN space ELSE ls_itens-knttp )
                    bras_nbm     = ls_itens-j_1bnbm
                    matl_usage   = ls_itens-j_1bmatuse
                    mat_origin   = ls_itens-j_1bmatorg
                    agreement    = COND #( WHEN ls_itens-agreement IS NOT INITIAL THEN ls_itens-agreement )
                    agmt_item    = ( 10 * ls_itens-agmt_item )
                    producttype  = VALUE #( ls_itens-atributos[ nome_atributo = gc_values-gptipo ]-valor_atributo OPTIONAL )
                    startdate    = COND #( WHEN VALUE #( ls_itens-atributos[ nome_atributo = gc_values-gptipo ]-valor_atributo OPTIONAL ) EQ 2 THEN ls_itens-startdate )
*                    enddate      = COND #( WHEN VALUE #( ls_itens-atributos[ nome_atributo = gc_values-gptipo ]-valor_atributo OPTIONAL ) EQ 2 THEN ls_itens-enddate )
                    enddate      = COND #( WHEN VALUE #( ls_itens-atributos[ nome_atributo = gc_values-gptipo ]-valor_atributo OPTIONAL ) EQ 2
                                           THEN NEW zclmm_me_conv_num_item(  )->get_dt_fim( EXPORTING iv_dtfim = ls_itens-atributos[ nome_atributo = gc_values-dtfim ]-valor_atributo ) )
                    distrib      = COND #( WHEN REDUCE i( INIT lv_i TYPE i FOR ls_cont IN gs_pre_pedido-classficacao_contabil WHERE ( ebelp = ls_itens-ebelp ) NEXT lv_i = lv_i + 1 ) GT 1 THEN gc_values-v1 )
                    part_inv     = COND #( WHEN REDUCE i( INIT lv_i TYPE i FOR ls_cont IN gs_pre_pedido-classficacao_contabil WHERE ( ebelp = ls_itens-ebelp ) NEXT lv_i = lv_i + 1 ) GT 1 THEN gc_values-v2 )
                    conf_ctrl    = ls_itens-conf_ctrl
                    gr_ind       = get_merc( ls_itens )
                    downpay_type     = COND #( WHEN ls_itens-adiantamento IS NOT INITIAL THEN gc_values-m )
*                    downpay_amount   =
                    downpay_percent  = conv_dec( ls_itens-adiantamento )
                    downpay_duedate  = conv_dats( ls_itens-data_adiantamento )
                 ) ).

      et_itemx = VALUE tt_poitemx(
                   FOR ls_item IN et_item (
                      po_item     = ls_item-po_item
                      po_itemx    = abap_true
*                      delete_ind  = abap_true
                      material    = abap_true
                      ematerial   = abap_true
                      plant       = abap_true
                      trackingno  = abap_true
                      net_price   = abap_true
                      po_unit     = abap_true
                      price_unit  = abap_true
                      tax_code    = abap_true
                      preq_no     = abap_true
                      preq_item   = abap_true
                      po_price    = abap_true
                      quantity    = abap_true
                      acctasscat  = abap_true
                      bras_nbm    = abap_true
                      matl_usage  = abap_true
                      mat_origin  = abap_true
                      agreement   = abap_true
                      agmt_item   = abap_true
                      producttype = abap_true
                      info_rec    = abap_true
                      item_cat    = abap_true
                      startdate   = COND #( WHEN ls_item-producttype EQ gc_values-v2 THEN abap_true )
                      enddate     = COND #( WHEN ls_item-producttype EQ gc_values-v2 THEN abap_true )
                      distrib     = COND #( WHEN ls_item-distrib  IS NOT INITIAL THEN abap_true )
                      part_inv    = COND #( WHEN ls_item-part_inv IS NOT INITIAL THEN abap_true )
                      conf_ctrl   = abap_true
                      gr_ind      = abap_true
                      downpay_type     = COND #( WHEN ls_item-downpay_type    IS NOT INITIAL THEN abap_true )
*                      downpay_amount   = COND #( WHEN downpay_amount  IS NOT INITIAL THEN abap_true )
                      downpay_percent  = COND #( WHEN ls_item-downpay_percent IS NOT INITIAL THEN abap_true )
                      downpay_duedate  = COND #( WHEN ls_item-downpay_duedate IS NOT INITIAL THEN abap_true )
                    ) ).

    ENDIF.

  ENDMETHOD.


  METHOD item_delete.

    ct_item = VALUE tt_poitem(
              FOR ls_item IN gs_pre_pedido-itens (
                po_item    = ( 10 * ls_item-ebelp )
                delete_ind = abap_true
               ) ).

    ct_itemx = VALUE tt_poitemx(
              FOR ls_itemx IN ct_item (
                po_item    = ls_itemx-po_item
                po_itemx   = abap_true
                delete_ind = abap_true
               ) ).

  ENDMETHOD.


  METHOD gap_415r01.

    DATA: lv_obserp       TYPE string,
          lv_status       TYPE num03,
          lv_status_02(3) TYPE c.

    TRY.

        me->file_me_create( IMPORTING es_arquivo_me = DATA(ls_arquivo_me) ).

        NEW zclmm_valida_pre_pedido( )->process(
            EXPORTING
                is_arquivo_me = ls_arquivo_me
                iv_pedido     = gs_pre_pedido-ebeln
                iv_pedido_me  = gs_pre_pedido-ref_1
            IMPORTING
                ev_obserp = lv_obserp
                ev_status = lv_status
         ).

        WRITE lv_status TO lv_status_02.

        CONDENSE lv_status_02 NO-GAPS.

        IF lv_status_02 EQ gc_values-e109 OR
           lv_status_02 EQ gc_values-erro.

          me->interface_23( EXPORTING iv_obs = lv_obserp iv_status = CONV string( lv_status ) ).

        ELSE.
          me->table_me_save( EXPORTING iv_obs = lv_obserp iv_status = CONV string( lv_status ) ).
        ENDIF.

      CATCH zcxmm_erro_interface_mes.
        me->error_raise( is_ret = VALUE scx_t100key(  msgid = gc_values-classe msgno = gc_values-msgno4 ) ).
    ENDTRY.

  ENDMETHOD.


  METHOD file_me_create.

    es_arquivo_me =  CORRESPONDING #( gs_pre_pedido ).

    es_arquivo_me-obscli    = gs_pre_pedido-obs_cli.
    es_arquivo_me-obsrecusa = gs_pre_pedido-obs_recusa.

    es_arquivo_me-item = VALUE zctgmm_item_me(
            FOR ls_item IN gs_pre_pedido-itens (
                ebelp        = ls_item-ebelp
                menge        = ls_item-menge
                netpr        = ls_item-netpr
                precosemimposto = ls_item-precosemimposto "conv_preco( ls_item-precosemimposto )
                complemento     = ls_item-complemento
                meins           = ls_item-meins
                matnr           = ls_item-matnr
                issincluso      = ls_item-issincluso
                ipiincluso      = ls_item-ipiincluso
                alterapreco     = ls_item-alterapreco
                alterado        = ls_item-alterado
                cancelado       = ls_item-cancelado
                icmsincluso     = ls_item-icmsincluso
                mfrnr           = ls_item-mfrnr
                j_1bnbm         = ls_item-j_1bnbm
                peinh           = ls_item-peinh
                mwskz           = ls_item-mwskz
                j_1bmatuse      = ls_item-j_1bmatuse
                j_1bmatorg      = ls_item-j_1bmatorg
                servico         = ls_item-servico
                localentregacliente = ls_item-localentregacliente
                werks           = ls_item-werks
                precoconvertido = ls_item-precoconvertido
                agreement       = ls_item-agreement
                agmt_item       = ls_item-agmt_item
                banfn           = ls_item-banfn
                bnfpo           = ls_item-bnfpo
                knttp           = ls_item-knttp
                startdate       = ls_item-startdate
                enddate         = ls_item-enddate
                producttype     = VALUE #( ls_item-atributos[ nome_atributo = gc_values-gptipo ]-valor_atributo OPTIONAL )
                textoitem       = VALUE #( ls_item-atributos[ nome_atributo = gc_values-txtitem ]-valor_atributo OPTIONAL )
                textoitemremessa  = ls_item-textoitemremessa
                conf_ctrl       = ls_item-conf_ctrl
                aliquotaiss  = ls_item-aliquota_iss
                valoriss     = ls_item-valor_iss "conv_preco( ls_item-valor_iss )
                aliquotaipi  = ls_item-aliquota_ipi
                valoripi     = ls_item-valor_ipi "conv_preco( ls_item-valor_ipi )
                aliquotaicms = ls_item-aliquota_icms
                obscliitem   = ls_item-obs_cli_item
                valorfrete   = ls_item-valor_frete
                aliquotast   = ls_item-aliquota_st
                valorst      = ls_item-valor_st
             ) ).

  ENDMETHOD.


  METHOD interface_23.

    TRY.

        me->save_log( gc_values-o109_2 ).

        me->interface_12( EXPORTING iv_ebeln   = CONV string( gs_pre_pedido-ebeln  )
                                    iv_ref_1   = CONV string( gs_pre_pedido-ref_1  )
                                    iv_vendor  = CONV string( gs_pre_pedido-vendor )
                                    iv_obs_erp = iv_obs
                                    iv_status  = iv_status ).

      CATCH zcxmm_erro_interface_mes.
        me->error_raise( is_ret = VALUE scx_t100key(  msgid = gc_values-classe msgno = gc_values-msgno5 ) ).
    ENDTRY.

  ENDMETHOD.


  METHOD table_ret.

    IF iv_release_tab EQ abap_true.

      DELETE gt_return WHERE ( id = gc_values-bapi AND number = gc_values-msgno1 ) AND
                             ( id = gc_values-mepo AND number = gc_values-msgno0 ).

      ev_ret = REDUCE #( INIT lv_text TYPE string FOR ls_ret IN gt_ret WHERE ( type NE gc_values-w ) NEXT lv_text = lv_text && | | && ls_ret-message ).

    ELSE.

      DELETE gt_return WHERE ( id = gc_values-bapi AND number = gc_values-msgno1 ) AND
                             ( id = gc_values-mepo AND number = gc_values-msgno0 ).

      ev_ret = REDUCE #( INIT lv_text TYPE string FOR ls_ret2 IN gt_return WHERE ( type NE gc_values-w ) NEXT lv_text = lv_text && | | && ls_ret2-message ).

    ENDIF.

  ENDMETHOD.


  METHOD table_me_save.


    TRY.
        me->interface_12( EXPORTING iv_ebeln   = CONV string( gs_pre_pedido-ebeln  )
                                    iv_ref_1   = CONV string( gs_pre_pedido-ref_1  )
                                    iv_vendor  = CONV string( gs_pre_pedido-vendor )
                                    iv_obs_erp = iv_obs
                                    iv_status  = iv_status ).

      CATCH zcxmm_erro_interface_mes.
        me->error_raise( is_ret = VALUE scx_t100key(  msgid = gc_values-classe msgno = gc_values-msgno5 ) ).
    ENDTRY.

    DATA(lt_pedido_me) = VALUE tt_item(
            FOR ls_item IN gs_pre_pedido-itens (
                ebeln  = gs_pre_pedido-ebeln
                ebelp  = ( 10 * ls_item-ebelp )
                ped_me = gs_pre_pedido-ref_1
                lifnr  = gs_pre_pedido-vendor
             ) ).

    IF lt_pedido_me IS NOT INITIAL.

      MODIFY ztmm_pedido_me FROM TABLE lt_pedido_me.

      IF sy-subrc EQ 0.
        COMMIT WORK.
      ENDIF.

    ENDIF.

  ENDMETHOD.


  METHOD error_raise.

    RAISE EXCEPTION TYPE zcxmm_erro_interface_mes
      EXPORTING
        textid = VALUE #( msgid = is_ret-msgid
                          msgno = is_ret-msgno
                          ).

  ENDMETHOD.


  METHOD steps_erro.

    me->save_log( ).

    me->table_ret( IMPORTING ev_ret = DATA(lv_ret) ).

    me->interface_12( EXPORTING iv_ebeln   = CONV string( gs_pre_pedido-ebeln  )
                                iv_ref_1   = CONV string( gs_pre_pedido-ref_1  )
                                iv_vendor  = CONV string( gs_pre_pedido-vendor )
                                iv_obs_erp = lv_ret
                                iv_status  = gc_values-e109 ).

  ENDMETHOD.


  METHOD save_log.

    IF gt_return IS NOT INITIAL.

      me->error_ret( IMPORTING et_controle_int = DATA(lt_controle_int) ).

    ELSE.

      lt_controle_int = VALUE #( BASE lt_controle_int (
            tp_processo   = gc_values-v5
            categoria_doc = gc_values-f
            doc_sap       = gs_pre_pedido-ebeln
            dt_integracao = sy-datum
            log           = iv_desc ) ).

    ENDIF.

    IF lt_controle_int IS NOT INITIAL.

      MODIFY ztmm_control_int FROM  TABLE lt_controle_int.

      IF sy-subrc EQ 0.
        COMMIT WORK.
      ENDIF.

    ENDIF.

  ENDMETHOD.


  METHOD steps_save.

    me->commit_work(  ).

    me->gap_415r01(  ).

  ENDMETHOD.


  METHOD error_ret.

    DATA: lv_text TYPE string,
          lv_item TYPE char5.

    LOOP AT gt_return ASSIGNING FIELD-SYMBOL(<fs_return>) WHERE type NE gc_values-w GROUP BY (
         row   = <fs_return>-row
         size  = GROUP SIZE
         index = GROUP INDEX
     )
     INTO DATA(lt_grp).

      LOOP AT GROUP lt_grp INTO DATA(ls_grp).

        lv_text = lv_text && | | && ls_grp-message.
        lv_item = ls_grp-message_v2.

      ENDLOOP.

      et_controle_int = VALUE #( BASE et_controle_int (
            tp_processo   = gc_values-v5
            categoria_doc = gc_values-f
            doc_sap       = gs_pre_pedido-ebeln
            item_doc      = lv_item
            dt_integracao = sy-datum
            log           = lv_text
            ) ).

      CLEAR: lv_text, lv_item.

    ENDLOOP.

  ENDMETHOD.


  METHOD error_release.

    me->table_ret( EXPORTING iv_release_tab = abap_true IMPORTING ev_ret = DATA(lv_ret) ).

    me->interface_12( EXPORTING iv_ebeln   = CONV string( gs_pre_pedido-ebeln  )
                                iv_ref_1   = CONV string( gs_pre_pedido-ref_1  )
                                iv_vendor  = CONV string( gs_pre_pedido-vendor )
                                iv_obs_erp = lv_ret
                                iv_status  = gc_values-e109 ).

  ENDMETHOD.


  METHOD pack.

    UNPACK iv_matnr TO rv_matnr.

  ENDMETHOD.


  METHOD conv_me.

    CALL FUNCTION 'CONVERSION_EXIT_CUNIT_INPUT'
      EXPORTING
        input          = iv_me
        language       = sy-langu
      IMPORTING
        output         = rv_me
      EXCEPTIONS
        unit_not_found = 1
        OTHERS         = 2.

    IF sy-subrc NE 0.
      rv_me = iv_me.
    ENDIF.


  ENDMETHOD.


  METHOD execute_delete.

    DATA: lt_return TYPE tt_ret.

    me->fill_delete_item(
        EXPORTING
            is_item_delete = is_item_del
        IMPORTING
            et_item = DATA(lt_item)
            et_itemx = DATA(lt_itemx) ).

    IF lt_item IS NOT INITIAL.

      FREE MEMORY ID: 'ZMM_CANCELA'.

      EXPORT tab FROM is_item_del-mt_cancelar_pedido
        TO DATABASE indx(xy)
        CLIENT sy-mandt
        ID 'ZMM_CANCELA'.

      CALL FUNCTION 'BAPI_PO_CHANGE'
        EXPORTING
          purchaseorder = is_item_del-mt_cancelar_pedido-purchaseorder
        TABLES
          return        = lt_return
          poitem        = lt_item
          poitemx       = lt_itemx.

      IF NOT line_exists( lt_return[ type = gc_values-e ] ).
        me->commit_work( ).
      ELSE.
        me->raise_change( lt_return ).
      ENDIF.

      me->send_return( EXPORTING it_ret = lt_return is_item_delete = is_item_del ).

    ENDIF.

  ENDMETHOD.


  METHOD fill_delete_item.

*    IF is_item_delete-mt_cancelar_pedido-delete_ind EQ gc_values-sim.

    et_item = VALUE tt_poitem( FOR ls_item IN is_item_delete-mt_cancelar_pedido-itens (
                                po_item    = ( 10 * ls_item-po_item )
                                delete_ind = abap_true
                                preq_no    = abap_false
                                preq_item  = abap_false
                             ) ).

    IF et_item IS NOT INITIAL.

      et_itemx = VALUE tt_poitemx( FOR ls_itemx IN et_item (
                                  po_item    = ls_itemx-po_item
                                  po_itemx   = abap_true
                                  delete_ind = abap_true
                                  preq_no    = abap_true
                                  preq_item  = abap_true
                               ) ).

    ENDIF.

*    ENDIF.
  ENDMETHOD.


  METHOD send_return.

    TRY.

*        NEW zclmm_co_si_processar_status_p(  )->si_processar_status_pre_pedido(
*            EXPORTING
*            output = VALUE zclmm_mt_mensagem_status_pre_p( mt_mensagem_status_pre_pedido-ebeln   = is_item_delete-mt_cancelar_pedido-purchaseorder
*                                                           mt_mensagem_status_pre_pedido-ref_1   = is_item_delete-mt_cancelar_pedido-ref_1
*                                                           mt_mensagem_status_pre_pedido-vendor  = is_item_delete-mt_cancelar_pedido-vendor
*                                                           mt_mensagem_status_pre_pedido-status  = COND #( WHEN NOT line_exists( it_ret[ type = gc_values-e ] ) THEN gc_values-s3 )
*                                                           mt_mensagem_status_pre_pedido-obs_erp = get_text( it_ret ) ) ).

        NEW zclmm_co_si_processar_mensage2(  )->si_processar_mensagem_status_p(
            EXPORTING
            output = VALUE zclmm_mt_mensagem_status_pedid( mt_mensagem_status_pedido_erp-ebeln      = is_item_delete-mt_cancelar_pedido-purchaseorder
                                                           mt_mensagem_status_pedido_erp-vendor     = is_item_delete-mt_cancelar_pedido-vendor
                                                           mt_mensagem_status_pedido_erp-status     = COND #( WHEN NOT line_exists( it_ret[ type = gc_values-e ] ) THEN gc_values-v1 )
                                                           mt_mensagem_status_pedido_erp-data_hora  = sy-datum
                                                           mt_mensagem_status_pedido_erp-obs_erp    = get_text( it_ret ) ) ).

      CATCH cx_ai_system_fault .
        me->error_raise( is_ret = VALUE scx_t100key(  msgid = gc_values-classe msgno = gc_values-msgno6 ) ).
    ENDTRY.

  ENDMETHOD.


  METHOD get_text.

    LOOP AT it_message ASSIGNING FIELD-SYMBOL(<fs_ret>) WHERE type NE gc_values-w.
      CONCATENATE rv_text <fs_ret>-message  INTO rv_text SEPARATED BY space.
    ENDLOOP.

  ENDMETHOD.


  METHOD raise_change.

    DATA(ls_ret) = VALUE #( it_return[ type = gc_values-erro ] OPTIONAL ).

    IF ls_ret IS NOT INITIAL.

      RAISE EXCEPTION TYPE zcxmm_erro_interface_mes
        EXPORTING
          textid = VALUE #( msgid = ls_ret-id
                            msgno = ls_ret-number
                            attr1 = ls_ret-message_v1
                            attr2 = ls_ret-message_v2
                            attr3 = ls_ret-message_v3
                            attr4 = ls_ret-message_v4
                            ).
    ENDIF.

  ENDMETHOD.


  METHOD conv_preco.

    IF iv_item_valor CA '.'.

      SPLIT iv_item_valor AT '.' INTO DATA(lv_int) DATA(lv_dec).

      IF strlen( lv_dec ) GT 2.
        rv_result =  lv_int && '.' && lv_dec(2) .
      ELSE.
        rv_result = iv_item_valor.
      ENDIF.

    ELSE.
      rv_result = iv_item_valor.
    ENDIF.

  ENDMETHOD.


  METHOD get_cat.

    SELECT SINGLE pstyp FROM eban
    WHERE banfn = @is_item-banfn
      AND bnfpo = @is_item-bnfpo
      INTO @rv_result .

    IF sy-subrc EQ 0.

      CALL FUNCTION 'ME_ITEM_CATEGORY_OUTPUT'
        EXPORTING
          pstyp     = rv_result
        IMPORTING
          epstp     = rv_result
        EXCEPTIONS
          not_found = 1
          OTHERS    = 2.
      IF sy-subrc NE 0.
        RETURN.
      ENDIF.

    ENDIF.


  ENDMETHOD.


  METHOD conv_date.

    IF iv_eindt IS NOT INITIAL.

      DATA(lv_data) = iv_eindt.

      REPLACE ALL OCCURRENCES OF '-' IN lv_data WITH space.
      CONDENSE lv_data NO-GAPS.

      rv_result = lv_data.

    ENDIF.

  ENDMETHOD.


  METHOD replace.

    IF iv_eindt IS NOT INITIAL.

      DATA(lv_data) = iv_eindt.

      REPLACE ALL OCCURRENCES OF '-' IN lv_data WITH '.'.
      CONDENSE lv_data NO-GAPS.

      rv_date = lv_data+8(2) && lv_data+4(4) && lv_data(4).

    ENDIF.

  ENDMETHOD.


  METHOD partner.

    IF gs_pre_pedido-parvw IS NOT INITIAL.

      DO 2 TIMES.

        et_partner = VALUE #( BASE et_partner (
            partnerdesc = COND #(  WHEN sy-index EQ 1 THEN gc_values-ef ELSE gc_values-fm )
            langu       = sy-langu
            buspartno   = gs_pre_pedido-parvw
         ) ).

      ENDDO.

    ENDIF.

  ENDMETHOD.


  METHOD get_merc.

    rv_result = VALUE #( is_itens-atributos[ nome_atributo = gc_values-EntMerc ]-valor_atributo OPTIONAL ).

    CASE rv_result.
      WHEN gc_values-sim.
        rv_result = abap_true.
      WHEN gc_values-nao.
        rv_result = space.
    ENDCASE.

  ENDMETHOD.


  METHOD addresdelivery.

    et_addr = VALUE tt_addr( FOR ls_itens IN gs_pre_pedido-itens INDEX INTO lv_index
                           WHERE ( localentregacliente IS NOT INITIAL ) (
                           po_item = lv_index * 10
                           addr_no = get_addr( ls_itens-localentregacliente )
                          ) ).

  ENDMETHOD.


  METHOD get_addr.

    SELECT SINGLE addrcomm FROM but000
    WHERE partner = @iv_localentregacliente
    INTO @rv_result.

  ENDMETHOD.


  METHOD conv_dec.

    CHECK iv_adiantamento IS NOT INITIAL.

    DATA(lv_adia) = iv_adiantamento.

    TRANSLATE lv_adia USING ', '.
    CONDENSE  lv_adia NO-GAPS.

    rv_result =  lv_adia.

  ENDMETHOD.


  METHOD conv_dats.

    CHECK iv_data_adiantamento IS NOT INITIAL.

    DATA(lv_data) = iv_data_adiantamento.

    TRANSLATE lv_data USING '/ '.
    CONDENSE  lv_data NO-GAPS.

    rv_result = lv_data+4(4) && lv_data+2(2) && lv_data(2).

  ENDMETHOD.


  METHOD attach_link.

    DATA: ls_folderid TYPE      soodk,
          ls_obj_id   TYPE      soodk,
          ls_objdata  TYPE      sood1,
          lt_objcont  TYPE STANDARD TABLE OF soli,
          lt_objhead  TYPE STANDARD TABLE OF soli,
          ls_object   TYPE     borident,
          ls_reldoc   TYPE     borident,
          lv_syst     TYPE     syst.

    CHECK gs_pre_pedido-collect_no IS NOT INITIAL.

    CALL FUNCTION 'SO_FOLDER_ROOT_ID_GET'
      EXPORTING
        owner                 = sy-uname
        region                = 'B'
      IMPORTING
        folder_id             = ls_folderid
      EXCEPTIONS
        communication_failure = 1
        owner_not_exist       = 2
        system_failure        = 3
        x_error               = 4
        OTHERS                = 5.
    IF sy-subrc <> 0.
      EXIT.
    ENDIF.

    ls_objdata-objla     =  sy-langu.
    ls_objdata-objdes    = |Cotação | && gs_pre_pedido-collect_no.
    ls_objdata-objsns    = 'O'.


    APPEND VALUE #( line = concat(  )  ) TO lt_objcont.

    CALL FUNCTION 'SO_OBJECT_INSERT'
      EXPORTING
        folder_id                  = ls_folderid
        object_type                = 'URL'
        object_hd_change           = ls_objdata
        owner                      = sy-uname
      IMPORTING
        object_id                  = ls_obj_id
      TABLES
        objcont                    = lt_objcont
        objhead                    = lt_objhead
      EXCEPTIONS
        active_user_not_exist      = 1
        communication_failure      = 2
        component_not_available    = 3
        dl_name_exist              = 4
        folder_not_exist           = 5
        folder_no_authorization    = 6
        object_type_not_exist      = 7
        operation_no_authorization = 8
        owner_not_exist            = 9
        parameter_error            = 10
        substitute_not_active      = 11
        substitute_not_defined     = 12
        system_failure             = 13
        x_error                    = 14
        OTHERS                     = 15.
    IF sy-subrc <> 0.
      EXIT.
    ENDIF.

    ls_object-objkey  =  gs_pre_pedido-ebeln.
    ls_object-objtype = 'BUS2012'.

    CONCATENATE ls_folderid ls_obj_id INTO ls_reldoc-objkey.
    ls_reldoc-objtype = 'MESSAGE'.

    CALL FUNCTION 'BINARY_RELATION_CREATE'
      EXPORTING
        obj_rolea      = ls_object
        obj_roleb      = ls_reldoc
        relationtype   = 'URL'
      EXCEPTIONS
        no_model       = 1
        internal_error = 2
        unknown        = 3
        OTHERS         = 4.

    IF sy-subrc EQ 0.
      CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'.
    ENDIF.

  ENDMETHOD.


  METHOD concat.

    rv_result = |&KEY&https://stg.me.com.br/comparative-panel/{ gs_pre_pedido-collect_no }|.

  ENDMETHOD.
ENDCLASS.
