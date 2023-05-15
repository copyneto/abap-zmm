CLASS zclmm_rec_solicitacao DEFINITION

  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    METHODS:

      "! Interface Gerar Requisição
      execute
        IMPORTING
          is_lista_req TYPE zclmm_mt_requisicao_compra
        RAISING
          zcxmm_erro_interface_mes
          zcxca_tabela_parametros,


      "! Interface Registrar Id Solicitacao
      execute_lista_in
        IMPORTING
          it_id TYPE zdt_id_solicitacao_lista_tab
        RAISING
          zcxmm_erro_interface_mes
          cx_ai_system_fault .

  PROTECTED SECTION.
  PRIVATE SECTION.

    TYPES:
      tt_item             TYPE TABLE OF bapimereqitemimp .
    TYPES:
      tt_itemx            TYPE TABLE OF bapimereqitemx .
    TYPES:
      tt_account          TYPE TABLE OF bapimereqaccount .
    TYPES:
      tt_accountx         TYPE TABLE OF bapimereqaccountx .
    TYPES:
      tt_headertext       TYPE TABLE OF bapimereqheadtext .
    TYPES:
      tt_itemtext         TYPE TABLE OF bapimereqitemtext .
    TYPES:
      tt_purchasereqnitem TYPE TABLE OF c_purchasereqnitem .

    CONSTANTS:
      BEGIN OF gc_solicita,
        reprovado       TYPE string VALUE 'Tipo de Operação em branco'                                       ##NO_TEXT,
        reprovado2      TYPE string VALUE 'Não foi encontrado o registro da Ordem da solicitação'            ##NO_TEXT,
        reprovado3      TYPE string VALUE 'Não foi encontrado o registro de Ativo da solicitação'            ##NO_TEXT,
        reprovado4      TYPE string VALUE 'Não foi encontrado o registro de Centro de Custo da solicitação'  ##NO_TEXT,
        reprovado5      TYPE string VALUE 'Não foi encontrado o registro de PEP da solicitação'              ##NO_TEXT,
        reprovado6      TYPE string VALUE 'Solicitação de Viagem já existe no S/4HANA'                       ##NO_TEXT,
        reprovado7      TYPE string VALUE 'Solicitação de Viagem não encontrada no S/4HANA.'                 ##NO_TEXT,
        classe          TYPE string VALUE 'ZMM_REQ_COMPRAS'                                                  ##NO_TEXT,
        argo            TYPE string VALUE 'Aguardando Liberação ARGO'                                        ##NO_TEXT,
        b01             TYPE string VALUE 'B01'                                                              ##NO_TEXT,
        pep             TYPE ps_posid_edit    VALUE 'PEP'                   ##NO_TEXT,
        modulo          TYPE ze_param_modulo  VALUE 'MM'                    ##NO_TEXT,
        chave1          TYPE ze_param_chave   VALUE 'ARGO'                  ##NO_TEXT,
        chave2          TYPE ze_param_chave   VALUE 'APROVADOR'             ##NO_TEXT,
        chave3          TYPE ze_param_chave_3 VALUE 'S/4HANA'               ##NO_TEXT,
        chave1_a        TYPE ze_param_chave   VALUE 'ARGO'                  ##NO_TEXT,
        chave2_a        TYPE ze_param_chave   VALUE 'BAPI_PR_CREATE'        ##NO_TEXT,
        chave3_a        TYPE ze_param_chave_3 VALUE 'PR_TYPE'               ##NO_TEXT,
        chave1_o        TYPE ze_param_chave   VALUE 'ARGO'                  ##NO_TEXT,
        chave2_o        TYPE ze_param_chave   VALUE 'ORG_COMPRAS'           ##NO_TEXT,
        chave3_o        TYPE ze_param_chave_3 VALUE 'PREQ'                  ##NO_TEXT,
        chave1_m        TYPE ze_param_chave   VALUE 'ME'                    ##NO_TEXT,
        chave2_m        TYPE ze_param_chave   VALUE 'CANCELITEM'            ##NO_TEXT,
        chave3_m        TYPE ze_param_chave_3 VALUE 'MENSAGEM'              ##NO_TEXT,
        string1         TYPE string VALUE 'Sol. Passagem | Solicitação: '   ##NO_TEXT,
        string2         TYPE string VALUE '| Passageiro: '                  ##NO_TEXT,
        string3         TYPE string VALUE 'Trecho - Origem: '               ##NO_TEXT,
        string4         TYPE string VALUE 'Destino: '                       ##NO_TEXT,
        string5         TYPE string VALUE 'Data da Viagem: '                ##NO_TEXT,
        string6         TYPE string VALUE 'Solicitante: '                   ##NO_TEXT,
        string7         TYPE string VALUE 'Sol. Hospedagem | Solicitação:'  ##NO_TEXT,
        string8         TYPE string VALUE '| Hospede: '                     ##NO_TEXT,
        string9         TYPE string VALUE 'Hotel: '                         ##NO_TEXT,
        string10        TYPE string VALUE 'Localidade: '                    ##NO_TEXT,
        string11        TYPE string VALUE 'Check-In: '                      ##NO_TEXT,
        string12        TYPE string VALUE 'Check-Out: '                     ##NO_TEXT,
        string13        TYPE string VALUE 'Último Aprovador: '              ##NO_TEXT,
        email_return    TYPE string VALUE 'email@temp.com.br',
        login_return    TYPE string VALUE 'integracao',
        nomecomp_return TYPE string VALUE 'ROBO ROBO',
        status_canc     TYPE string VALUE 'CAN',
        clcont_a        TYPE knttp  VALUE 'A',
        clcont_f        TYPE knttp  VALUE 'F',
        clcont_k        TYPE knttp  VALUE 'K',
        clcont_p        TYPE knttp  VALUE 'P',
      END OF gc_solicita .
    DATA gs_lista TYPE zclmm_dt_requisicao_compra .
    DATA:
      gt_order  TYPE TABLE OF aufk .
    DATA:
      gt_asset  TYPE TABLE OF c_assetassignmenttp .
    DATA:
      gt_accost TYPE TABLE OF c_costcenter .
    DATA:
      gt_wbse   TYPE TABLE OF c_wbselementbasicinfo .

    "! Inicio do processo
    METHODS processar
      IMPORTING
        !is_lista TYPE zclmm_dt_requisicao_compra
      RAISING
        cx_ai_system_fault
        zcxca_tabela_parametros
        zcxmm_erro_interface_mes .
    "! Validar classificação contábil
    METHODS validar_class_contabil
      EXPORTING
        !ev_erro TYPE boolean
      RAISING
        cx_ai_system_fault .
    METHODS validar_1
      IMPORTING
        !is_account TYPE zclmm_dt_requisicao_compra_pra
      EXPORTING
        !ev_erro    TYPE boolean
      RAISING
        cx_ai_system_fault .
    METHODS validar_2
      IMPORTING
        !is_account TYPE zclmm_dt_requisicao_compra_pra
      EXPORTING
        !ev_erro    TYPE boolean
      RAISING
        cx_ai_system_fault .
    METHODS validar_3
      IMPORTING
        !is_account TYPE zclmm_dt_requisicao_compra_pra
      EXPORTING
        !ev_erro    TYPE boolean
      RAISING
        cx_ai_system_fault .
    METHODS validar_4
      IMPORTING
        !is_account TYPE zclmm_dt_requisicao_compra_pra
      EXPORTING
        !ev_erro    TYPE boolean
      RAISING
        cx_ai_system_fault .
    METHODS verifica_fat_can
      RAISING
        cx_ai_system_fault
        zcxca_tabela_parametros
        zcxmm_erro_interface_mes .
    "! Interface de recusa
    METHODS erro
      IMPORTING
        !iv_motivo TYPE string
      RAISING
        cx_ai_system_fault .
    "! Selecionar dados classificação contábil
    METHODS selecionar_dados_clcon .
    "! Validar Status viajem
    METHODS validar_status_vj
      RAISING
        zcxca_tabela_parametros
        cx_ai_system_fault
        zcxmm_erro_interface_mes .
    METHODS verifica_aut
      RAISING
        zcxca_tabela_parametros
        cx_ai_system_fault .
    "! Preencher estruturas da bapi de criação
    METHODS preenche_create
      RAISING
        zcxca_tabela_parametros
        cx_ai_system_fault .
    "! Preencher estruturas da bapi de modificação
    METHODS preenche_change
      IMPORTING
        !it_item TYPE tt_purchasereqnitem
      RAISING
        zcxca_tabela_parametros
        cx_ai_system_fault
        zcxmm_erro_interface_mes .
    "! Preencher cabeçalho
    METHODS header
      EXPORTING
        !es_header  TYPE bapimereqheader
        !es_headerx TYPE bapimereqheaderx
      RAISING
        zcxca_tabela_parametros
        cx_ai_system_fault .
    "! Preencher item
    METHODS item
      EXPORTING
        !et_item  TYPE tt_item
        !et_itemx TYPE tt_itemx
      RAISING
        zcxca_tabela_parametros
        cx_ai_system_fault .
    "! Preencher account
    METHODS account
      EXPORTING
        !et_account  TYPE tt_account
        !et_accountx TYPE tt_accountx .
    "! Preencher texto do cabeçalho
    METHODS headertext
      EXPORTING
        !et_text TYPE tt_headertext .
    "! Executar a bapi de criação de requisição
    METHODS bapi_create
      IMPORTING
        !is_header   TYPE bapimereqheader
        !is_headerx  TYPE bapimereqheaderx
        !it_item     TYPE tt_item
        !it_itemx    TYPE tt_itemx
        !it_account  TYPE tt_account
        !it_accountx TYPE tt_accountx
        !it_text     TYPE tt_headertext
      RAISING
        cx_ai_system_fault .
    "! Disparar interfaces de aprovado/recusado
    METHODS enviar_resposta
      IMPORTING
        !iv_status TYPE c
        !iv_motivo TYPE string OPTIONAL
      RAISING
        cx_ai_system_fault .
    METHODS item_change_can
      IMPORTING
        !it_item  TYPE tt_purchasereqnitem
      EXPORTING
        !et_item  TYPE tt_item
        !et_itemx TYPE tt_itemx
        !et_text  TYPE tt_itemtext
      RAISING
        zcxca_tabela_parametros
        cx_ai_system_fault .
    METHODS item_change_fat
      IMPORTING
        !it_item  TYPE tt_purchasereqnitem
      EXPORTING
        !et_item  TYPE tt_item
        !et_itemx TYPE tt_itemx
        !et_text  TYPE tt_headertext .
    "! Executar a bapi de modificação
    METHODS bapi_change
      IMPORTING
        !iv_number     TYPE vdm_purchaserequisition
        !it_item       TYPE tt_item
        !it_itemx      TYPE tt_itemx
        !it_itemtext   TYPE tt_itemtext OPTIONAL
        !it_headertext TYPE tt_headertext OPTIONAL
      RAISING
        cx_ai_system_fault .
    "! Executar seleção da tabela de parâmetros
    METHODS tabela_param
      IMPORTING
        !iv_modulo TYPE ze_param_modulo
        !iv_chave1 TYPE ze_param_chave
        !iv_chave2 TYPE ze_param_chave OPTIONAL
        !iv_chave3 TYPE ze_param_chave_3 OPTIONAL
      EXPORTING
        !ev_param  TYPE ze_param_low
      RAISING
        zcxca_tabela_parametros
        cx_ai_system_fault .
    METHODS text_line
      IMPORTING
        !it_item        TYPE tt_purchasereqnitem
        !iv_number      TYPE vdm_purchaserequisition
      EXPORTING
        !et_text_header TYPE tt_headertext
      RAISING
        zcxmm_erro_interface_mes .
    "! Error raise
    METHODS erro_raise
      IMPORTING
        !is_ret TYPE scx_t100key
      RAISING
        zcxmm_erro_interface_mes .
ENDCLASS.



CLASS zclmm_rec_solicitacao IMPLEMENTATION.


  METHOD execute.

    TRY.
        me->processar(  EXPORTING is_lista = is_lista_req-mt_requisicao_compra ).
      CATCH cx_ai_system_fault.

    ENDTRY.

  ENDMETHOD.


  METHOD processar.

    gs_lista = is_lista.

    IF line_exists( is_lista-pritem[ tipo = '' ] ). "#EC CI_STDSEQ                    " Tipo de Operação estiver em branco
      erro( gc_solicita-reprovado ).
    ENDIF.

    IF gs_lista-viagem_reembolsada IS NOT INITIAL.                                    " Desprezar as viagens reembolsadas
      EXIT.
    ENDIF.

    validar_class_contabil( IMPORTING ev_erro = DATA(lv_erro) ).

    IF lv_erro IS INITIAL.
      validar_status_vj( ).
    ENDIF.

  ENDMETHOD.


  METHOD execute_lista_in.

    DATA(lo_buscar_det_out) = NEW zclmm_co_si_buscar_detalhe_sol( ). " Buscar detalhes solicitação

    TRY.

        LOOP AT it_id ASSIGNING FIELD-SYMBOL(<fs_id>).

          DATA(ls_id) = VALUE zifmt_id_detalhe_solicitacao( mt_id_detalhe_solicitacao-nro_solic = <fs_id>-nro_solic  mt_id_detalhe_solicitacao-solicitacao_id = <fs_id>-solicitacao_id ).

          lo_buscar_det_out->si_buscar_detalhe_solicitacao( EXPORTING output = ls_id  ). "#EC CI_IMUD_NESTED

        ENDLOOP.

      CATCH  cx_ai_system_fault .

        me->erro_raise( is_ret = VALUE scx_t100key(  msgid = gc_solicita-classe msgno = '002' ) ).

    ENDTRY.

  ENDMETHOD.


  METHOD validar_class_contabil.

    me->selecionar_dados_clcon( ).

    READ TABLE gs_lista-pritem INTO DATA(ls_lista) INDEX 1.

    LOOP AT gs_lista-praccount ASSIGNING FIELD-SYMBOL(<fs_account>).


*      IF <fs_account>-costcenter IS NOT INITIAL. " K
      IF ls_lista-acctasscat = 'K'.
        validar_3( EXPORTING is_account = <fs_account>
                   IMPORTING ev_erro    = ev_erro ).

*      ELSEIF <fs_account>-asset_no IS NOT INITIAL ." A
*        validar_2( EXPORTING is_account = <fs_account>
*                   IMPORTING ev_erro    = ev_erro ).

*      ELSEIF <fs_account>-orderid IS NOT INITIAL. " F
      ELSEIF ls_lista-acctasscat = 'F'. " F
        validar_1( EXPORTING is_account = <fs_account>
                   IMPORTING ev_erro    = ev_erro ).

*      ELSEIF <fs_account>-wbs_element IS NOT INITIAL. " P
      ELSEIF ls_lista-acctasscat = 'P'
          OR ls_lista-acctasscat = 'A'.
        validar_4( EXPORTING is_account = <fs_account>
                   IMPORTING ev_erro    = ev_erro ).
      ENDIF.

*      CASE <fs_account>-gl_account.
*        WHEN 'F'.
*          validar_1( <fs_account> ).
*        WHEN 'A'.
*          validar_2( <fs_account> ).
*        WHEN 'K'.
*          validar_3( <fs_account> ).
*        WHEN 'P'.
*          validar_4( <fs_account> ).
*      ENDCASE.

    ENDLOOP.

  ENDMETHOD.


  METHOD validar_1.

    DATA: lv_aufnr TYPE aufnr.

    CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
      EXPORTING
        input  = is_account-orderid
      IMPORTING
        output = lv_aufnr.

    DATA(lt_res) = VALUE #( gt_order[ aufnr = lv_aufnr ] OPTIONAL ). "#EC CI_STDSEQ

    IF lt_res IS INITIAL.
      erro( gc_solicita-reprovado2 ).
    ENDIF.

  ENDMETHOD.


  METHOD erro.

    DATA(lo_recusa) = NEW zclmm_co_si_enviar_status_out( ).

    TRY.

        DATA(ls_recusa) = VALUE zclmmmt_status_processamento(
            mt_status_processamento-aprovador  = VALUE zclmmdt_status_processamento_a( email = gs_lista-email login = gs_lista-login nome_completo = gs_lista-nome_completo )
            mt_status_processamento-motivo     = iv_motivo
            mt_status_processamento-nro_solic  = gs_lista-nro_solic "solicitacao_id
            mt_status_processamento-status     = gs_lista-status_viagem
          ).

        lo_recusa->si_enviar_status_out( ls_recusa ).

        COMMIT WORK.

      CATCH cx_ai_system_fault .

    ENDTRY.

  ENDMETHOD.


  METHOD selecionar_dados_clcon.

    DATA: lt_aufnr TYPE TABLE OF aufnr,
          lt_asset TYPE TABLE OF anln1,
          lt_cc    TYPE TABLE OF kostl,
          lt_pep   TYPE STANDARD TABLE OF ps_posid_edit.

    DATA: lv_aufnr TYPE aufnr.

    READ TABLE gs_lista-pritem INTO DATA(ls_lista) INDEX 1.

    LOOP AT gs_lista-praccount ASSIGNING FIELD-SYMBOL(<fs_acount>).

*      IF <fs_acount>-orderid IS NOT INITIAL. " F
      IF ls_lista-acctasscat = 'F'.
        IF <fs_acount>-orderid IS NOT INITIAL.
          CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
            EXPORTING
              input  = <fs_acount>-orderid
            IMPORTING
              output = lv_aufnr.

          APPEND lv_aufnr  TO lt_aufnr.
        ENDIF.
      ENDIF.

*      IF <fs_acount>-asset_no IS NOT INITIAL. " A
*        APPEND <fs_acount>-asset_no TO lt_asset.
*      ENDIF.

*      IF <fs_acount>-costcenter IS NOT INITIAL. " K
      IF ls_lista-acctasscat = 'K'.
        APPEND <fs_acount>-costcenter TO lt_cc.
      ENDIF.

*      IF <fs_acount>-wbs_element IS NOT INITIAL. " P
      IF ls_lista-acctasscat = 'P'
      OR ls_lista-acctasscat = 'A'.
        APPEND <fs_acount>-wbs_element TO lt_pep.
      ENDIF.

    ENDLOOP.

    IF lt_aufnr[] IS NOT INITIAL.
      SELECT *
        FROM aufk
         FOR ALL ENTRIES IN @lt_aufnr
       WHERE aufnr EQ @lt_aufnr-table_line
         AND loekz  IS INITIAL
        INTO TABLE @gt_order.

      IF sy-subrc IS INITIAL.
        SORT gt_order BY aufnr.
      ENDIF.
    ENDIF.

    IF lt_asset[] IS NOT INITIAL.
      SELECT *
        FROM c_assetassignmenttp
         FOR ALL ENTRIES IN @lt_asset
       WHERE masterfixedasset EQ @lt_asset-table_line
        INTO TABLE @gt_asset.

      IF sy-subrc IS INITIAL.
        SORT gt_asset BY masterfixedasset.
      ENDIF.
    ENDIF.

    IF lt_cc[] IS NOT INITIAL.
      SELECT *
        FROM c_costcenter
         FOR ALL ENTRIES IN @lt_cc
       WHERE costcenter EQ @lt_cc-table_line
         AND isblkdforprimarycostsposting IS INITIAL
        INTO TABLE @gt_accost.

      IF sy-subrc IS INITIAL.
        SORT gt_accost BY costcenter.
      ENDIF.
    ENDIF.

    IF lt_pep[] IS NOT INITIAL.
      SELECT wbselement
        FROM c_wbselementbasicinfo
         FOR ALL ENTRIES IN @lt_pep
       WHERE wbselement EQ @lt_pep-table_line
        INTO TABLE @gt_wbse.

      IF sy-subrc IS INITIAL.
        SORT gt_wbse BY wbselement.
      ENDIF.
    ENDIF.

  ENDMETHOD.


  METHOD validar_2.

    DATA(lt_res) = VALUE #( gt_asset[ masterfixedasset = is_account-asset_no ] OPTIONAL ). "#EC CI_STDSEQ
    IF lt_res IS INITIAL.
      erro( gc_solicita-reprovado3 ).
    ENDIF.

  ENDMETHOD.


  METHOD validar_3.

    DATA(lt_res) = VALUE #( gt_accost[ costcenter = is_account-costcenter ] OPTIONAL ). "#EC CI_STDSEQ

    IF lt_res IS INITIAL.
      erro( gc_solicita-reprovado4 ).
    ENDIF.

  ENDMETHOD.


  METHOD validar_4.

    DATA(lt_res) = VALUE #( gt_wbse[ wbselement = is_account-wbs_element ] OPTIONAL ). "#EC CI_STDSEQ

    IF lt_res IS INITIAL.
      erro( gc_solicita-reprovado5 ).
    ENDIF.

  ENDMETHOD.


  METHOD validar_status_vj.

    CASE gs_lista-status_viagem.
      WHEN 'AUT'.
        me->verifica_aut( ).
      WHEN 'FAT' OR 'CAN'.
        me->verifica_fat_can( ).
    ENDCASE.

  ENDMETHOD.


  METHOD verifica_fat_can.

    DATA: lt_PurchaseReqnItem TYPE TABLE OF C_PurchaseReqnItem.

    SELECT PurchaseRequisition, PurchaseRequisitionItem   FROM C_PurchaseReqnItem
    INTO CORRESPONDING FIELDS OF TABLE @lt_PurchaseReqnItem
    WHERE RequirementTracking EQ @gs_lista-nro_solic.

    IF sy-subrc EQ 0.
      me->preenche_change( lt_PurchaseReqnItem ).
    ELSE.
      enviar_resposta( EXPORTING iv_status = 'R' iv_motivo = gc_solicita-reprovado7 ).
    ENDIF.

  ENDMETHOD.


  METHOD verifica_aut.

*    DATA: lv_param TYPE ze_param_low.
*
*    DATA(lo_param) = NEW zclca_tabela_parametros( ).
*
*    me->tabela_param(
*    EXPORTING
*        iv_modulo = gc_solicita-modulo
*        iv_chave1 = gc_solicita-chave1
*        iv_chave2 = gc_solicita-chave2
*        iv_chave3 = gc_solicita-chave3
*    IMPORTING
*        ev_param = lv_param
*    ).
*
*    IF lv_param IS NOT INITIAL.
*
*      IF  gs_lista-login EQ lv_param .

    " Verifica se a Solicitação já foi criada
    SELECT SINGLE requirementtracking
      FROM c_purchasereqnitem
      INTO @DATA(lv_res)
     WHERE requirementtracking EQ @gs_lista-nro_solic.

    IF sy-subrc EQ 0.
*      enviar_resposta( EXPORTING iv_status = 'R' iv_motivo = gc_solicita-reprovado6 ).
    ELSE.
      preenche_create(  ).
    ENDIF.

*  ENDIF.
*
*    ENDIF.

  ENDMETHOD.


  METHOD preenche_change.

    DATA: lt_item        TYPE tt_item,
          lt_itemx       TYPE tt_itemx,
          lt_text        TYPE tt_itemtext,
          lt_text_header TYPE tt_headertext.

    DATA(lv_number) = VALUE #( it_item[ 1 ]-purchaserequisition OPTIONAL ).

    "$ ***************
    "$ Cancelamento
    "$ ***************
    IF gs_lista-status_viagem EQ gc_solicita-status_canc.

      me->item_change_can( EXPORTING it_item = it_item IMPORTING et_item =  lt_item et_itemx = lt_itemx et_text = lt_text ).

      "$ ***************
      "$ Desbloqueio
      "$ ***************
    ELSE.

      me->item_change_fat( EXPORTING it_item  = it_item
                           IMPORTING et_item  = lt_item
                                     et_itemx = lt_itemx
                                     et_text  = lt_text_header ).

      me->text_line( EXPORTING it_item        = it_item
                               iv_number      = lv_number
                     IMPORTING et_text_header = lt_text_header ).

    ENDIF.

    bapi_change( EXPORTING iv_number     = lv_number
                           it_item       = lt_item
                           it_itemx      = lt_itemx
                           it_itemtext   = lt_text
                           it_headertext = lt_text_header ).

  ENDMETHOD.


  METHOD preenche_create.

    DATA: lt_item       TYPE TABLE OF bapimereqitemimp,
          lt_itemx      TYPE TABLE OF bapimereqitemx,
          ls_header     TYPE bapimereqheader,
          ls_headerx    TYPE bapimereqheaderx,
          lt_account    TYPE TABLE OF bapimereqaccount,
          lt_accountx   TYPE TABLE OF bapimereqaccountx,
          lt_headertext TYPE TABLE OF bapimereqheadtext.

    me->header( IMPORTING es_header = ls_header es_headerx = ls_headerx ).

    IF ls_header IS NOT INITIAL.

      me->item( IMPORTING et_item = lt_item et_itemx = lt_itemx ).

      IF lt_item IS NOT INITIAL.

        me->account( IMPORTING et_account = lt_account et_accountx = lt_accountx ).
        me->headertext( IMPORTING et_text = lt_headertext ).

        me->bapi_create(
        EXPORTING
            is_header   = ls_header
            is_headerx  = ls_headerx
            it_item     = lt_item
            it_itemx    = lt_itemx
            it_account  = lt_account
            it_accountx = lt_accountx
            it_text     = lt_headertext
        ).

      ENDIF.

    ENDIF.

  ENDMETHOD.


  METHOD header.

    DATA lv_type  TYPE ze_param_low.

    DATA(lo_param) = NEW zclca_tabela_parametros( ).

    me->tabela_param(
    EXPORTING
        iv_modulo = gc_solicita-modulo
        iv_chave1 = gc_solicita-chave1_a
        iv_chave2 = gc_solicita-chave2_a
        iv_chave3 = gc_solicita-chave3_a
    IMPORTING
        ev_param = lv_type
    ).

    IF lv_type IS NOT INITIAL.

      es_header-pr_type   = lv_type.
      es_headerx-pr_type =  abap_true.

    ENDIF.


  ENDMETHOD.


  METHOD item.

    TYPES: BEGIN OF ty_final,
             tipo  TYPE ze_tipo_operacao,
             knttp TYPE knttp,
           END OF ty_final,

           ty_ope TYPE STANDARD TABLE OF ty_final WITH DEFAULT KEY.

    DATA: lt_aufnr TYPE TABLE OF aufnr,
          lt_asset TYPE TABLE OF anln1,
          lt_cc    TYPE TABLE OF kostl,
          lt_pep   TYPE STANDARD TABLE OF ps_posid_edit.

    DATA: lv_org   TYPE ze_param_low,
          lv_date  TYPE char14,
          ls_wmara TYPE mara,
          lv_aufnr TYPE aufnr.

    DATA(lo_param) = NEW zclca_tabela_parametros( ).

    me->tabela_param( EXPORTING iv_modulo = gc_solicita-modulo
                                iv_chave1 = gc_solicita-chave1_o
                                iv_chave2 = gc_solicita-chave2_o
                                iv_chave3 = gc_solicita-chave3_o
                      IMPORTING ev_param = lv_org ).

    IF lv_org IS NOT INITIAL.

      DATA(lt_op) = VALUE ty_ope(
                     FOR ls_op IN gs_lista-pritem
                     (  tipo  = ls_op-tipo
                        knttp = ls_op-acctasscat ) ).

      IF lt_op IS NOT INITIAL.

        SELECT operacao,
               matnr
          FROM ztmm_argo_op_par
           FOR ALL ENTRIES IN @lt_op
         WHERE operacao EQ @lt_op-tipo
           AND begda    LT @sy-datum
           AND active   EQ @abap_true
          INTO TABLE @DATA(lt_matnr).

        IF sy-subrc IS INITIAL.

          DATA(lt_matnr_fae) = lt_matnr[].

          SORT lt_matnr_fae BY matnr.
          DELETE ADJACENT DUPLICATES FROM lt_matnr_fae COMPARING matnr.

          IF lt_matnr_fae[] IS NOT INITIAL.
            SELECT a~matnr,
                   a~mtart,
                   b~producttypecode
              FROM mara AS a
             INNER JOIN i_producttype AS b ON b~producttype = a~mtart
               FOR ALL ENTRIES IN @lt_matnr_fae
             WHERE matnr = @lt_matnr_fae-matnr
              INTO TABLE @DATA(lt_mara).

            IF sy-subrc IS INITIAL.
              SORT lt_mara BY matnr.
            ENDIF.
          ENDIF.
        ENDIF.

        SELECT bukrs,
               knttp,
               werks,
               bkgrp
          FROM ztmm_argo_param
           FOR ALL ENTRIES IN @lt_op
         WHERE knttp  EQ @lt_op-knttp
           AND begda  LE @sy-datum
           AND active EQ @abap_true
          INTO TABLE @DATA(lt_werks).

        IF sy-subrc IS INITIAL.
          SORT lt_werks BY bukrs
                           knttp.
        ENDIF.

        READ TABLE gs_lista-pritem INTO DATA(ls_item) INDEX 1.

        LOOP AT gs_lista-praccount ASSIGNING FIELD-SYMBOL(<fs_account>).

*          IF <fs_account>-orderid IS NOT INITIAL. " F
          IF ls_item-acctasscat = 'F'.

            CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
              EXPORTING
                input  = <fs_account>-orderid
              IMPORTING
                output = lv_aufnr.

            APPEND lv_aufnr TO lt_aufnr.
          ENDIF.

*          IF <fs_account>-asset_no IS NOT INITIAL. " A
*            APPEND <fs_account>-asset_no TO lt_asset.
*          ENDIF.

*          IF <fs_account>-costcenter IS NOT INITIAL. " K
          IF ls_item-acctasscat = 'K'.
            APPEND <fs_account>-costcenter TO lt_cc.
          ENDIF.

*          IF <fs_account>-wbs_element IS NOT INITIAL. " P ou A
          IF ls_item-acctasscat = 'P'
          OR ls_item-acctasscat = 'A'.
            APPEND <fs_account>-wbs_element TO lt_pep.
          ENDIF.

        ENDLOOP.

        IF lt_cc[] IS NOT INITIAL.
          SELECT costcenter  AS kostl,
                 companycode AS bukrs
            FROM i_costcenter
             FOR ALL ENTRIES IN @lt_cc
           WHERE costcenter         = @lt_cc-table_line
             AND validitystartdate <= @sy-datum
             AND validityenddate   >= @sy-datum
            INTO TABLE @DATA(lt_csks).

          IF sy-subrc IS INITIAL.
            SORT lt_csks BY kostl.
          ENDIF.
        ENDIF.

        IF lt_pep[] IS NOT INITIAL.
          SELECT wbselement,
                 plant
            FROM c_wbselementbasicinfo
             FOR ALL ENTRIES IN @lt_pep
           WHERE wbselement = @lt_pep-table_line(24)
            INTO TABLE @DATA(lt_prps).

          IF sy-subrc IS INITIAL.
            SORT lt_prps BY wbselement.
          ENDIF.
        ENDIF.

*        IF lt_asset[] is not INITIAL.
*          SELECT
*        ENDIF.

        IF lt_aufnr[] IS NOT INITIAL.
          SELECT aufnr,
                 bukrs
            FROM aufk
             FOR ALL ENTRIES IN @lt_aufnr
           WHERE aufnr = @lt_aufnr-table_line
            INTO TABLE @DATA(lt_aufk).

          IF sy-subrc IS INITIAL.
            SORT lt_aufk BY aufnr.
          ENDIF.
        ENDIF.
      ENDIF.

      LOOP AT gs_lista-pritem ASSIGNING FIELD-SYMBOL(<fs_item>).

        DATA(lv_tabix) = sy-tabix.

        DATA(lv_matnr) = VALUE #( lt_matnr[ operacao = <fs_item>-tipo       ]-matnr OPTIONAL ). "#EC CI_STDSEQ
*        DATA(lv_werks) = VALUE #( lt_werks[ knttp    = <fs_item>-acctasscat ]-werks OPTIONAL ). "#EC CI_STDSEQ

        READ TABLE gs_lista-praccount ASSIGNING <fs_account> INDEX lv_tabix.
        IF sy-subrc IS INITIAL.

          CASE <fs_item>-acctasscat.
            WHEN 'P'
              OR 'A'.
              READ TABLE lt_prps ASSIGNING FIELD-SYMBOL(<fs_prps>)
                                               WITH KEY wbselement = <fs_account>-wbs_element
                                               BINARY SEARCH.
              IF sy-subrc IS INITIAL.
                READ TABLE lt_werks INTO DATA(ls_werks)
                                     WITH KEY bukrs = <fs_prps>-plant
                                              knttp = <fs_item>-acctasscat
                                              BINARY SEARCH.
                IF sy-subrc IS INITIAL.
                  DATA(lv_werks) = ls_werks-werks.
                  DATA(lv_bkgrp) = ls_werks-bkgrp.
                ENDIF.
              ENDIF.

            WHEN 'K'.
              READ TABLE lt_csks ASSIGNING FIELD-SYMBOL(<fs_csks>)
                                               WITH KEY kostl = <fs_account>-costcenter
                                               BINARY SEARCH.
              IF sy-subrc IS INITIAL.
                READ TABLE lt_werks INTO ls_werks
                                     WITH KEY bukrs = <fs_csks>-bukrs
                                              knttp = <fs_item>-acctasscat
                                              BINARY SEARCH.
                IF sy-subrc IS INITIAL.
                  lv_werks = ls_werks-werks.
                  lv_bkgrp = ls_werks-bkgrp.
                ENDIF.
              ENDIF.

*            WHEN 'A'.

            WHEN 'F'.
              CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
                EXPORTING
                  input  = <fs_account>-orderid
                IMPORTING
                  output = lv_aufnr.

              READ TABLE lt_aufk ASSIGNING FIELD-SYMBOL(<fs_aufk>)
                                               WITH KEY aufnr = lv_aufnr
                                               BINARY SEARCH.
              IF sy-subrc IS INITIAL.
                READ TABLE lt_werks INTO ls_werks
                                     WITH KEY bukrs = <fs_aufk>-bukrs
                                              knttp = <fs_item>-acctasscat
                                              BINARY SEARCH.
                IF sy-subrc IS INITIAL.
                  lv_werks = ls_werks-werks.
                  lv_bkgrp = ls_werks-bkgrp.
                ENDIF.
              ENDIF.

            WHEN OTHERS.
          ENDCASE.
        ENDIF.

        IF lv_matnr IS NOT INITIAL.
          READ TABLE lt_mara ASSIGNING FIELD-SYMBOL(<fs_mara>)
                                           WITH KEY matnr = lv_matnr
                                           BINARY SEARCH.
          IF sy-subrc IS INITIAL.
            DATA(lv_prod_type_code) = <fs_mara>-producttypecode.
          ELSE.
            CLEAR lv_prod_type_code.
          ENDIF.
        ELSE.
          CLEAR lv_prod_type_code.
        ENDIF.

        DATA(lv_producttype) = lv_prod_type_code.
*        WRITE <fs_item>-startdate TO lv_date.
        lv_date = <fs_item>-startdate(4) && <fs_item>-startdate+5(2) && <fs_item>-startdate+8(2).
        DATA(lv_startdate) = CONV mmpur_servproc_period_start( lv_date(8) ).

        et_item = VALUE #( BASE et_item ( preq_item       = ( sy-tabix * 10 )
                                          preq_name       = <fs_item>-preq_name
                                          material        = lv_matnr
                                          plant           = lv_werks
                                          pur_group       = lv_bkgrp
                                          trackingno      = <fs_item>-trackingno
                                          quantity        = '1'
                                          preq_date       = sy-datum
                                          deliv_date      = sy-datum
                                          preq_price      = <fs_item>-preq_price
                                          currency        = <fs_item>-currency
                                          purch_org       = lv_org
                                          acctasscat      = <fs_item>-acctasscat
                                          producttype     = lv_prod_type_code
                                          startdate       = COND #( WHEN lv_producttype EQ 2 THEN lv_startdate )
                                          enddate         = COND #( WHEN lv_producttype EQ 2 THEN lv_startdate + 90 )
                                          req_blocked     = '3'
                                          gr_ind          = space
                                          reason_blocking = gc_solicita-argo ) ).

        et_itemx = VALUE #( BASE et_itemx ( preq_item       = ( sy-tabix * 10 )
                                            preq_name       = abap_true
                                            material        = abap_true
                                            plant           = abap_true
                                            pur_group       = abap_true
                                            trackingno      = abap_true
                                            quantity        = abap_true
                                            preq_date       = abap_true
                                            deliv_date      = abap_true
                                            preq_price      = abap_true
                                            currency        = abap_true
                                            purch_org       = abap_true
                                            acctasscat      = abap_true
                                            producttype     = abap_true
                                            startdate       = abap_true
                                            enddate         = abap_true
                                            req_blocked     = abap_true
                                            distrib         = abap_true
                                            gr_ind          = abap_true
                                            reason_blocking = abap_true ) ).

      ENDLOOP.
    ENDIF.

  ENDMETHOD.


  METHOD account.

    DATA: lv_distr_perc TYPE vproz,
          lv_aufnr      TYPE aufnr.

    DATA(lv_acctasscat) = VALUE #( gs_lista-pritem[ 1 ]-acctasscat OPTIONAL ).

    LOOP AT gs_lista-praccount ASSIGNING FIELD-SYMBOL(<fs_account>).

      IF <fs_account>-distr_perc EQ 100.
        CLEAR lv_distr_perc.
      ELSE.
        lv_distr_perc = <fs_account>-distr_perc(2).
      ENDIF.

      IF <fs_account>-orderid IS NOT INITIAL.
        CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
          EXPORTING
            input  = <fs_account>-orderid
          IMPORTING
            output = lv_aufnr.
      ENDIF.

      et_account = VALUE #( BASE et_account (
         preq_item   = ( sy-tabix * 10 )
         serial_no   = sy-tabix
         distr_perc  = lv_distr_perc
         gl_account  = <fs_account>-gl_account
         costcenter  = COND #( WHEN lv_acctasscat  = 'K' THEN <fs_account>-costcenter )
*         asset_no    = COND #( WHEN lv_acctasscat  = 'A' THEN <fs_account>-wbs_element )
*         sub_number  = COND #( WHEN lv_acctasscat  = 'A' THEN <fs_account>-sub_number )
         orderid     = COND #( WHEN lv_acctasscat  = 'F' THEN lv_aufnr )
         wbs_element = COND #( WHEN lv_acctasscat  = 'P'
                                 OR lv_acctasscat  = 'A' THEN <fs_account>-wbs_element )

      ) ).

      et_accountx = VALUE #( BASE et_accountx (
        preq_item   = ( sy-tabix * 10 )
        serial_no   = sy-tabix
        distr_perc  = COND #( WHEN <fs_account>-distr_perc  = '100' THEN abap_false )
        gl_account  = abap_true
        costcenter  = COND #( WHEN lv_acctasscat  = 'K' THEN abap_true )
*        asset_no    = COND #( WHEN lv_acctasscat  = 'A' THEN abap_true )
*        sub_number  = COND #( WHEN lv_acctasscat  = 'A' THEN abap_true )
        orderid     = COND #( WHEN lv_acctasscat  = 'F' THEN abap_true )
        wbs_element = COND #( WHEN lv_acctasscat  = 'P'
                                OR lv_acctasscat  = 'A' THEN abap_true )
     ) ).

    ENDLOOP.

  ENDMETHOD.


  METHOD headertext.

    DATA: lv_tabix TYPE sy-tabix.

    LOOP AT gs_lista-text ASSIGNING FIELD-SYMBOL(<fs_text>).
      lv_tabix = sy-tabix.

      IF <fs_text> IS ASSIGNED.

        IF <fs_text>-tipo = 'A'.

          et_text = VALUE #( BASE et_text (
              preq_item = ( lv_tabix * 10 )
              text_form = gc_solicita-b01
              text_line = |{ gc_solicita-string1 } { gs_lista-nro_solic } { gc_solicita-string2 } { gs_lista-nome_completo } | ) ).

          LOOP AT <fs_text>-aerea ASSIGNING FIELD-SYMBOL(<fs_aerea>).
            et_text = VALUE #( BASE et_text (
                preq_item = ( lv_tabix * 10 )
                text_form = gc_solicita-b01
                text_line = |{ gc_solicita-string3 } { <fs_aerea>-origem } { gc_solicita-string4 } { <fs_aerea>-destino }| ) ).
          ENDLOOP.

          et_text = VALUE #( BASE et_text (
              preq_item = ( lv_tabix * 10 )
              text_form = gc_solicita-b01
              text_line = |{ gc_solicita-string5 } { <fs_text>-data_ini_viagem+6(2) }{ '/' }{ <fs_text>-data_ini_viagem+4(2) }{ '/' }{ <fs_text>-data_ini_viagem(4) }| ) ).

          et_text = VALUE #( BASE et_text (
              preq_item = ( lv_tabix * 10 )
              text_form = gc_solicita-b01
              text_line = |{ gc_solicita-string6 } { gs_lista-nome_completo1 }| ) ).

        ELSEIF <fs_text>-tipo = 'H'.

          et_text = VALUE #( BASE et_text (
              preq_item = ( lv_tabix * 10 )
              text_form = gc_solicita-b01
              text_line = |{ gc_solicita-string7 } { gs_lista-nro_solic } { gc_solicita-string8 } { gs_lista-nome_completo } | ) ).

          et_text = VALUE #( BASE et_text (
              preq_item = ( lv_tabix * 10 )
              text_form = gc_solicita-b01
              text_line = |{ gc_solicita-string9 } { <fs_text>-hotel }| ) ).

          et_text = VALUE #( BASE et_text (
              preq_item = ( lv_tabix * 10 )
              text_form = gc_solicita-b01
              text_line = |{ gc_solicita-string10 } { <fs_text>-cidade }| ) ).

          et_text = VALUE #( BASE et_text (
              preq_item = ( lv_tabix * 10 )
              text_form = gc_solicita-b01
              text_line = |{ gc_solicita-string11 } { <fs_text>-data_ini_viagem+6(2) }{ '/' }{ <fs_text>-data_ini_viagem+4(2) }{ '/' }{ <fs_text>-data_ini_viagem(4) }| ) ).

          et_text = VALUE #( BASE et_text (
              preq_item = ( lv_tabix * 10 )
              text_form = gc_solicita-b01
              text_line = |{ gc_solicita-string12 } { <fs_text>-data_saida+6(2) }{ '/' }{ <fs_text>-data_saida+4(2) }{ '/' }{ <fs_text>-data_saida(4) }| ) ).

          et_text = VALUE #( BASE et_text (
              preq_item = ( lv_tabix * 10 )
              text_form = gc_solicita-b01
              text_line = |{ gc_solicita-string6 } { gs_lista-nome_completo1 }| ) ).

        ENDIF.
      ENDIF.

    ENDLOOP.

  ENDMETHOD.


  METHOD bapi_create.

    DATA: lv_doc_ret TYPE banfn,
          lt_return  TYPE STANDARD TABLE OF bapiret2.

    TRY.

        DATA(lt_item)     = it_item[].
        DATA(lt_itemx)    = it_itemx[].
        DATA(lt_account)  = it_account[].
        DATA(lt_accountx) = it_accountx[].
        DATA(lt_text)     = it_text[].

        CALL FUNCTION 'BAPI_PR_CREATE'
          EXPORTING
            prheader      = is_header
            prheaderx     = is_headerx
          IMPORTING
            number        = lv_doc_ret
*           prheaderexp   =
          TABLES
            return        = lt_return
            pritem        = lt_item
            pritemx       = lt_itemx
            praccount     = lt_account
            praccountx    = lt_accountx
            prheadertext  = lt_text
          EXCEPTIONS
            error_message = 1
            OTHERS        = 2.

        IF sy-subrc IS NOT INITIAL.
          MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno WITH sy-msgv1
                                                                 sy-msgv2
                                                                 sy-msgv3
                                                                 sy-msgv4 INTO DATA(lv_msg).
        ENDIF.

      CATCH cx_sy_no_handler INTO DATA(lr_exception).

    ENDTRY.

    SORT lt_return BY type.

    READ TABLE lt_return ASSIGNING FIELD-SYMBOL(<fs_return>)
                                       WITH KEY type = 'E'
                                       BINARY SEARCH.
    IF sy-subrc IS INITIAL.

*      DATA(lv_motivo) = VALUE #( lt_return[ 1 ]-message OPTIONAL ).

      me->enviar_resposta( EXPORTING iv_status = 'R'
                                     iv_motivo = CONV #( <fs_return>-message ) ).

    ELSE.

      CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
        EXPORTING
          wait = abap_true.

      me->enviar_resposta( 'A' ).

    ENDIF.

  ENDMETHOD.


  METHOD enviar_resposta.

    DATA: lv_output TYPE zclmmmt_status_processamento.

    DATA(lo_ret) = NEW zclmm_co_si_enviar_status_out(  ).

    TRY.

        lv_output-mt_status_processamento = VALUE #( motivo        = iv_motivo
                                                     nro_solic     = gs_lista-nro_solic
                                                     status        = iv_status
                                                     aprovador     = VALUE  zclmmdt_status_processamento_a(
                                                     nome_completo = gc_solicita-nomecomp_return
                                                     login         = gc_solicita-login_return
                                                     email         = gc_solicita-email_return ) ).

        lo_ret->si_enviar_status_out( output = lv_output ).

        COMMIT WORK.

      CATCH cx_ai_system_fault  .

    ENDTRY.

  ENDMETHOD.


  METHOD item_change_can.

    DATA: lv_mess   TYPE ze_param_low.

    DATA(lo_param) = NEW zclca_tabela_parametros( ).

    me->tabela_param(
    EXPORTING
        iv_modulo = gc_solicita-modulo
        iv_chave1 = gc_solicita-chave1_m
        iv_chave2 = gc_solicita-chave2_m
        iv_chave3 = gc_solicita-chave3_m
    IMPORTING
        ev_param = lv_mess
    ).

    LOOP AT it_item ASSIGNING FIELD-SYMBOL(<fs_item>).

      et_item = VALUE #( BASE et_item (
        preq_item  = <fs_item>-PurchaseRequisitionItem
        delete_ind = abap_true
       ) ).

      et_itemx = VALUE #( BASE et_itemx (
         preq_item  = <fs_item>-PurchaseRequisitionItem
         preq_itemx = abap_true
         delete_ind = abap_true
      ) ).

      et_text = VALUE #( BASE et_text (
        preq_no   = <fs_item>-PurchaseRequisition
        preq_item = <fs_item>-PurchaseRequisitionItem
        text_form = 'B02'
        text_line = lv_mess
       ) ).

    ENDLOOP.

  ENDMETHOD.


  METHOD item_change_fat.

    LOOP AT it_item ASSIGNING FIELD-SYMBOL(<fs_item>).

      et_item = VALUE #( BASE et_item (
        preq_item       = <fs_item>-purchaserequisitionitem
        req_blocked     = ''
        reason_blocking = ''
        gr_ind          = ''
       ) ).

      et_itemx = VALUE #( BASE et_itemx (
         preq_item       = <fs_item>-purchaserequisitionitem
         preq_itemx      = abap_true
         req_blocked     = abap_true
         reason_blocking = abap_true
         gr_ind          = abap_true
      ) ).

    ENDLOOP.

  ENDMETHOD.


  METHOD bapi_change.

    DATA: lt_return TYPE STANDARD TABLE OF bapiret2.

    DATA(lt_item)       = it_item[].
    DATA(lt_itemx)      = it_itemx[].
    DATA(lt_itemtext)   = it_itemtext[].
    DATA(lt_headertext) = it_headertext[].

    CALL FUNCTION 'BAPI_PR_CHANGE'
      EXPORTING
        number        = iv_number
      TABLES
        return        = lt_return
        pritem        = lt_item
        pritemx       = lt_itemx
        pritemtext    = lt_itemtext
        prheadertext  = lt_headertext
      EXCEPTIONS
        error_message = 1
        OTHERS        = 2.

    IF sy-subrc NE 0.

      DATA(lv_motivo) = VALUE #( lt_return[ 1 ]-message OPTIONAL ).

      enviar_resposta( EXPORTING iv_status = 'R' iv_motivo = CONV #( lv_motivo ) ).

    ELSE.

      CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
        EXPORTING
          wait = abap_true.

      enviar_resposta( 'A' ).

    ENDIF.

    CLEAR: lt_return.

  ENDMETHOD.


  METHOD tabela_param.

    DATA(lo_param) = NEW zclca_tabela_parametros( ).

    TRY.

        lo_param->m_get_single(
              EXPORTING
              iv_modulo = iv_modulo
              iv_chave1 = iv_chave1
              iv_chave2 = iv_chave2
              iv_chave3 = iv_chave3
             IMPORTING
             ev_param = ev_param ).

      CATCH zcxca_tabela_parametros.

    ENDTRY.

  ENDMETHOD.


  METHOD text_line.

    DATA: lt_lines TYPE STANDARD TABLE OF tline,
          lv_text  TYPE string.

    CALL FUNCTION 'READ_TEXT'
      EXPORTING
        client                  = sy-mandt
        id                      = 'B01'
        language                = 'P'
        name                    = CONV tdobname( iv_number )
        object                  = 'EBANH'
      TABLES
        lines                   = lt_lines
      EXCEPTIONS
        id                      = 1
        language                = 2
        name                    = 3
        not_found               = 4
        object                  = 5
        reference_check         = 6
        wrong_access_to_archive = 7
        OTHERS                  = 8.

    IF sy-subrc NE 0.

      me->erro_raise( is_ret = VALUE scx_t100key(  msgid = gc_solicita-classe
                                         msgno = '001'
                                         attr1 = COND #( WHEN sy-subrc = 1 THEN 'ID'
                                                         WHEN sy-subrc = 2 THEN 'LANGUAGE'
                                                         WHEN sy-subrc = 3 THEN 'NAME'
                                                         WHEN sy-subrc = 4 THEN 'NOT_FOUND'
                                                         WHEN sy-subrc = 5 THEN 'OBJECT'
                                                         WHEN sy-subrc = 6 THEN 'REFERENCE_CHECK '
                                                         WHEN sy-subrc = 7 THEN 'WRONG_ACCESS_TO_ARCHIVE'
                                                         WHEN sy-subrc = 8 THEN 'OTHERS' ) ) ).

    ELSE.

      LOOP AT lt_lines ASSIGNING FIELD-SYMBOL(<fs_lines>).

*        lv_text = lv_text && <fs_lines>-tdline.
        et_text_header = VALUE #( BASE et_text_header ( preq_item = 10
                                                        text_form = <fs_lines>-tdformat
                                                        text_line = <fs_lines>-tdline   ) ).

      ENDLOOP.

*      LOOP AT it_item ASSIGNING FIELD-SYMBOL(<fs_item>).
      et_text_header = VALUE #( BASE et_text_header ( preq_item = 10
                                                      text_form = 'B01'
                                                      text_line = |{ gc_solicita-string13 } { gs_lista-nome_complet_o }| ) ).
*      ENDLOOP.

    ENDIF.

    CLEAR:  lv_text, lt_lines[].

  ENDMETHOD.


  METHOD erro_raise.

    RAISE EXCEPTION TYPE zcxmm_erro_interface_mes
      EXPORTING
        textid = VALUE #( msgid = is_ret-msgid
                          msgno = is_ret-msgno
                          attr1 = is_ret-attr1
                          ).

  ENDMETHOD.
ENDCLASS.
