CLASS lcl_cockpit DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PUBLIC SECTION.

    CONSTANTS:
      BEGIN OF gc_msg,
        id    TYPE msgid VALUE 'ZMM_COCKPIT_LIB',
        error TYPE msgty VALUE 'E',
        suces TYPE msgty VALUE 'S',
        info  TYPE msgty VALUE 'I',
        n001  TYPE msgno VALUE '001',
      END OF gc_msg.

    CONSTANTS:
      BEGIN OF lc_stats,
        pendente           TYPE ze_doc_status VALUE IS INITIAL,
        revisaocomercial   TYPE ze_doc_status VALUE 'A',
        liberadocomercial  TYPE ze_doc_status VALUE 'B',
        revisaofinanceiro  TYPE ze_doc_status VALUE 'C',
        retornadocomercial TYPE ze_doc_status VALUE 'D',
        liberadofinanceiro TYPE ze_doc_status VALUE 'E',
        finalizado         TYPE ze_doc_status VALUE 'F',
      END OF lc_stats.

    CONSTANTS:
      BEGIN OF gc_param,
        modulo TYPE ztca_param_par-modulo VALUE 'MM',
        chave1 TYPE ztca_param_par-chave1 VALUE 'LIB_PAGTO_GV',
        chave2 TYPE ztca_param_par-chave2 VALUE 'CONTARAZAO',
      END OF gc_param.

*      BEGIN OF ENUM ty_enum_tipo STRUCTURE lc_tipo BASE TYPE ze_tipo_registro,
*        none       VALUE IS INITIAL,
*        comercial  VALUE 'C',
*        financeiro VALUE 'F',
*      END OF ENUM ty_enum_tipo STRUCTURE lc_tipo.

    METHODS get_messages
      IMPORTING p_task TYPE clike.

  PROTECTED SECTION.

    DATA: gs_log        TYPE bal_s_log,
          gv_log_handle TYPE balloghndl,
          gs_msg        TYPE bal_s_msg,
          gt_messages   TYPE bapiret2_tab,
          gv_wait_async TYPE xfeld,
          gv_error      TYPE xfeld,
          "gv_obj_key    TYPE awkey,
          gv_belnr      TYPE belnr_d,
          gv_bukrs      TYPE bukrs,
          gv_gjahr      TYPE gjahr.

  PRIVATE SECTION.

    CONSTANTS:
      "! Objeto de Autorização
      BEGIN OF gc_authobj,
        zmmlibcom TYPE xuobject VALUE 'ZMMLIBCOM',
        zmmlibfin TYPE xuobject VALUE 'ZMMLIBFIN',
      END OF gc_authobj,

      "! Campos do Objeto de Autorização
      BEGIN OF gc_id,
        actvt TYPE fieldname VALUE 'ACTVT',
      END OF gc_id,

      "! Ações básicas do Objeto de Autorização
      BEGIN OF gc_actvt,
        executar TYPE char2 VALUE '16',
      END OF gc_actvt.


    METHODS comercialdiscount FOR MODIFY
      IMPORTING keys FOR ACTION _cockpit~comercialdiscount RESULT result.

    METHODS financialdiscount FOR MODIFY
      IMPORTING keys FOR ACTION _cockpit~financialdiscount RESULT result.

    METHODS comercialreturn FOR MODIFY
      IMPORTING keys FOR ACTION _cockpit~comercialreturn RESULT result.

    METHODS comercialrelease FOR MODIFY
      IMPORTING keys FOR ACTION _cockpit~comercialrelease RESULT result.

    METHODS financialrelease FOR MODIFY
      IMPORTING keys FOR ACTION _cockpit~financialrelease RESULT result.

    METHODS documentclose FOR MODIFY
      IMPORTING keys FOR ACTION _cockpit~documentclose RESULT result.

    METHODS fupdocument FOR MODIFY
      IMPORTING keys FOR ACTION _cockpit~fupdocument RESULT result.

    METHODS get_features FOR FEATURES
      IMPORTING keys REQUEST requested_features FOR _cockpit RESULT result.

    METHODS create_log
      IMPORTING is_log        TYPE bal_s_log
      RETURNING VALUE(rv_msg) TYPE REF TO if_abap_behv_message.

    METHODS add_log_msg
      IMPORTING is_msg        TYPE bal_s_msg
                iv_log        TYPE xfeld OPTIONAL
      RETURNING VALUE(rv_msg) TYPE REF TO if_abap_behv_message.

    METHODS liberacao_comercial RETURNING VALUE(rv_result) TYPE abap_bool.

    METHODS liberacao_financeira RETURNING VALUE(rv_result) TYPE abap_bool.

ENDCLASS.

CLASS lcl_cockpit IMPLEMENTATION.

  METHOD comercialdiscount.

    READ ENTITIES OF zi_mm_cockpit IN LOCAL MODE
        ENTITY _cockpit
          FIELDS ( status descontocomercial observcomercial waers )
            WITH CORRESPONDING #( keys )
              RESULT DATA(lt_desccom).

    TRY.
        DATA(ls_desccom) = lt_desccom[ 1 ].
      CATCH cx_sy_itab_line_not_found INTO DATA(lo_exception).
        RETURN.
    ENDTRY.

    SELECT SINGLE COUNT( * )
      FROM ztmm_desc_pag_gv
      WHERE ebeln  EQ @ls_desccom-purchaseorder
        AND ebelp  EQ @ls_desccom-purchaseorderitem
        AND docnum EQ @ls_desccom-br_notafiscal.
    IF sy-subrc NE 0.

      INSERT INTO ztmm_desc_pag_gv VALUES @(
        VALUE #( ebeln            = keys[ 1 ]-purchaseorder
                 ebelp            = keys[ 1 ]-purchaseorderitem
                 docnum           = keys[ 1 ]-br_notafiscal
                 status           = lc_stats-revisaocomercial
                 vlr_desconto_com = keys[ 1 ]-%param-descontocomercial
                 observacao_com   = keys[ 1 ]-%param-observcomercial
                 waers            = keys[ 1 ]-%param-waers
                 usuario_com      = sy-uname
                 data_com         = sy-datum ) ).

    ELSE.

      MODIFY ENTITIES OF zi_mm_cockpit IN LOCAL MODE
        ENTITY _cockpit
          UPDATE FIELDS ( status descontocomercial observcomercial waers usuariocomercial datacomercial )
            WITH VALUE #( FOR ls_result IN lt_desccom
                              ( %tky = ls_result-%tky
                                status = lc_stats-revisaocomercial
                                descontocomercial = keys[ 1 ]-%param-descontocomercial
                                observcomercial   = keys[ 1 ]-%param-observcomercial
                                waers             = keys[ 1 ]-%param-waers
                                usuariocomercial  = sy-uname
                                datacomercial     = sy-datum ) )
              FAILED failed
              REPORTED reported.
    ENDIF.

    IF lines( failed-_cockpit ) GT 0.
      gs_msg = VALUE #( msgid =  gc_msg-id
                        msgno = 002
                        msgty = if_abap_behv_message=>severity-error ).
    ELSE.
      gs_msg = VALUE #( msgid = gc_msg-id
                        msgno = 001
                        msgty = if_abap_behv_message=>severity-success ).
    ENDIF.

    APPEND VALUE #( %tky = lt_desccom[ 1 ]-%tky
                    %msg = me->add_log_msg( is_msg = gs_msg ) ) TO reported-_cockpit.

    READ ENTITIES OF zi_mm_cockpit IN LOCAL MODE
      ENTITY _cockpit
      ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(lt_result_all).

    result = VALUE #( FOR ls_result_all IN lt_result_all (
                        %key   = ls_result_all-%key
                        %param = ls_result_all ) ).

  ENDMETHOD.

  METHOD financialdiscount.

    READ ENTITIES OF zi_mm_cockpit IN LOCAL MODE
      ENTITY _cockpit
        FIELDS ( status descontofinanceiro observfinanceiro waers )
          WITH CORRESPONDING #( keys )
            RESULT DATA(lt_descfin).

    MODIFY ENTITIES OF zi_mm_cockpit IN LOCAL MODE
      ENTITY _cockpit
        UPDATE FIELDS ( status descontofinanceiro observfinanceiro devolucaofutura
                        waers usuariofinanceiro datafinanceiro )
          WITH VALUE #( FOR ls_descfin IN lt_descfin
                            ( %tky = ls_descfin-%tky
                              status = lc_stats-revisaofinanceiro
*                              tipo = lc_tipo-financeiro
                              descontofinanceiro = keys[ 1 ]-%param-descontofinanceiro
                              observfinanceiro   = keys[ 1 ]-%param-observfinanceiro
                              devolucaofutura    = keys[ 1 ]-%param-devolucaofutura
                              waers              = keys[ 1 ]-%param-waers
                              usuariofinanceiro  = sy-uname
                              datafinanceiro     = sy-datum ) )
            FAILED failed
            REPORTED reported.

    IF lines( failed-_cockpit ) GT 0.
      gs_msg = VALUE #( msgid =  gc_msg-id
                        msgno = 004
                        msgty = if_abap_behv_message=>severity-error ).
    ELSE.
      gs_msg = VALUE #( msgid = gc_msg-id
                        msgno = 003
                        msgty = if_abap_behv_message=>severity-success ).
    ENDIF.

    APPEND VALUE #( %tky = lt_descfin[ 1 ]-%tky
                    %msg = me->add_log_msg( is_msg = gs_msg ) ) TO reported-_cockpit.

    READ ENTITIES OF zi_mm_cockpit IN LOCAL MODE
      ENTITY _cockpit
      ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(lt_result_all).

    result = VALUE #( FOR ls_result_all IN lt_result_all (
                        %key   = ls_result_all-%key
                        %param = ls_result_all ) ).

  ENDMETHOD.

  METHOD comercialreturn.

    READ ENTITIES OF zi_mm_cockpit IN LOCAL MODE
      ENTITY _cockpit
        FIELDS ( status )
          WITH CORRESPONDING #( keys )
            RESULT DATA(lt_return).

    MODIFY ENTITIES OF zi_mm_cockpit IN LOCAL MODE
      ENTITY _cockpit
        UPDATE FIELDS ( status usuariofinanceiro datafinanceiro )
          WITH VALUE #( FOR ls_return IN lt_return
                            ( %tky = ls_return-%tky
                              status = lc_stats-retornadocomercial
                              usuariofinanceiro = sy-uname
                              datafinanceiro    = sy-datum ) )
            FAILED failed
            REPORTED reported.

    IF lines( failed-_cockpit ) GT 0.
      gs_msg = VALUE #( msgid =  gc_msg-id
                        msgno = 006
                        msgty = if_abap_behv_message=>severity-error ).
    ELSE.
      gs_msg = VALUE #( msgid = gc_msg-id
                        msgno = 005
                        msgty = if_abap_behv_message=>severity-success ).
    ENDIF.

    APPEND VALUE #( %tky = lt_return[ 1 ]-%tky
                    %msg = me->add_log_msg( is_msg = gs_msg ) ) TO reported-_cockpit.

    READ ENTITIES OF zi_mm_cockpit IN LOCAL MODE
      ENTITY _cockpit
      ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(lt_result_all).

    result = VALUE #( FOR ls_result_all IN lt_result_all (
                        %key   = ls_result_all-%key
                        %param = ls_result_all ) ).
  ENDMETHOD.

  METHOD comercialrelease.

    READ ENTITIES OF zi_mm_cockpit IN LOCAL MODE
        ENTITY _cockpit
          ALL FIELDS
            WITH CORRESPONDING #( keys )
              RESULT DATA(lt_release).

    TRY.
        DATA(ls_result) = lt_release[ 1 ].
      CATCH cx_sy_itab_line_not_found INTO DATA(lo_exception).
        RETURN.
    ENDTRY.


    SELECT SINGLE COUNT( * )
      FROM ztmm_desc_pag_gv
      WHERE ebeln  EQ @ls_result-purchaseorder
        AND ebelp  EQ @ls_result-purchaseorderitem
        AND docnum EQ @ls_result-br_notafiscal.
    IF sy-subrc NE 0.

      INSERT INTO ztmm_desc_pag_gv VALUES @(
        VALUE #( ebeln            = keys[ 1 ]-purchaseorder
                 ebelp            = keys[ 1 ]-purchaseorderitem
                 docnum           = keys[ 1 ]-br_notafiscal
                 status           = lc_stats-liberadocomercial
                 usuario_com      = sy-uname
                 data_com         = sy-datum ) ).

    ELSE.

      MODIFY ENTITIES OF zi_mm_cockpit IN LOCAL MODE
        ENTITY _cockpit
          UPDATE FIELDS ( status usuariocomercial datacomercial )
            WITH VALUE #( FOR ls_release IN lt_release
                              ( %tky = ls_release-%tky
                                status = lc_stats-liberadocomercial
                                usuariocomercial = sy-uname
                                datacomercial    = sy-datum ) )
              FAILED failed
              REPORTED reported.
    ENDIF.

    "Vamos mover para o outro app os dados necessários
    DATA: ls_gv_cab TYPE ztmm_pag_gv_cab,
          ls_gv_desc TYPE ztmm_pag_gv_desc.

    TRY.

        GET TIME STAMP FIELD DATA(lv_timestamp).

        "Cabeçalho
        ls_gv_cab-bukrs                 = ls_result-CompanyCode.
        ls_gv_cab-ebeln                 = ls_result-PurchaseOrder.
        ls_gv_cab-gjahr                 = ls_result-FiscalYear.
        ls_gv_cab-status                = lc_stats-liberadocomercial.
        ls_gv_cab-created_by            = sy-uname.
        ls_gv_cab-created_at            = lv_timestamp.
        ls_gv_cab-last_changed_by       = sy-uname.
        ls_gv_cab-last_changed_at       = lv_timestamp.
        ls_gv_cab-local_last_changed_at = lv_timestamp.

        "Item
        MODIFY ztmm_pag_gv_cab FROM ls_gv_cab.
        MOVE-CORRESPONDING ls_gv_cab TO ls_gv_desc.

        "Validar se já existe registro
        SELECT SINGLE guid
        FROM ztmm_pag_gv_desc
        WHERE bukrs = @ls_result-CompanyCode
        AND   ebeln = @ls_result-PurchaseOrder
        AND   docnum_com = @ls_result-BR_NotaFiscal
        AND   vlr_desconto_com = @ls_result-DescontoComercial
        AND   observacao_com = @ls_result-ObservComercial
        INTO @DATA(lv_guid).

        IF lv_guid IS INITIAL.
            ls_gv_desc-guid = cl_system_uuid=>create_uuid_x16_static( ).
            "ls_gv_desc-bukrs            = ls_gv_cab-bukrs.
            "ls_gv_desc-ebeln            = ls_gv_cab-ebeln.
            ls_gv_desc-waers            = ls_result-waers.
            ls_gv_desc-docnum_com       = ls_result-BR_NotaFiscal.
            "ls_gv_desc-doccont_com      = ?
            ls_gv_desc-vlr_desconto_com = ls_result-DescontoComercial.
            ls_gv_desc-observacao_com   = ls_result-ObservComercial.
            ls_gv_desc-usuario_com      = sy-uname.
            ls_gv_desc-data_com         = sy-datum.
            ls_gv_desc-gjahr_com        = ls_result-FiscalYear.

            MODIFY ztmm_pag_gv_desc FROM ls_gv_desc.

        ENDIF.
*        ELSE.
*            ls_gv_desc-guid = lv_guid.
*        ENDIF.
*
*        "ls_gv_desc-bukrs            = ls_gv_cab-bukrs.
*        "ls_gv_desc-ebeln            = ls_gv_cab-ebeln.
*        ls_gv_desc-waers            = ls_result-waers.
*        ls_gv_desc-docnum_com       = ls_result-BR_NotaFiscal.
*        "ls_gv_desc-doccont_com      = ?
*        ls_gv_desc-vlr_desconto_com = ls_result-DescontoComercial.
*        ls_gv_desc-observacao_com   = ls_result-ObservComercial.
*        ls_gv_desc-usuario_com      = sy-uname.
*        ls_gv_desc-data_com         = sy-datum.
*        ls_gv_desc-gjahr_com        = ls_result-FiscalYear.
*
*        MODIFY ztmm_pag_gv_desc FROM ls_gv_desc.

      CATCH cx_root INTO DATA(lo_root).
        DATA(lv_message) = CONV bapi_msg( lo_root->get_longtext( ) ).
    ENDTRY.


    IF lines( failed-_cockpit ) GT 0.
      gs_msg = VALUE #( msgid =  gc_msg-id
                        msgno = 008
                        msgty = if_abap_behv_message=>severity-error ).
    ELSE.
      gs_msg = VALUE #( msgid = gc_msg-id
                        msgno = 007
                        msgty = if_abap_behv_message=>severity-success ).
    ENDIF.

    APPEND VALUE #( %tky = lt_release[ 1 ]-%tky
                    %msg = me->add_log_msg( is_msg = gs_msg ) ) TO reported-_cockpit.

    READ ENTITIES OF zi_mm_cockpit IN LOCAL MODE
      ENTITY _cockpit
      ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(lt_result_all).

    result = VALUE #( FOR ls_result_all IN lt_result_all (
                        %key   = ls_result_all-%key
                        %param = ls_result_all ) ).

  ENDMETHOD.

  METHOD financialrelease.

    READ ENTITIES OF zi_mm_cockpit IN LOCAL MODE
        ENTITY _cockpit
          ALL FIELDS
            WITH CORRESPONDING #( keys )
              RESULT DATA(lt_release).

    MODIFY ENTITIES OF zi_mm_cockpit IN LOCAL MODE
      ENTITY _cockpit
        UPDATE FIELDS ( status usuariofinanceiro datafinanceiro )
          WITH VALUE #( FOR ls_release IN lt_release
                            ( %tky = ls_release-%tky
                              status = lc_stats-liberadofinanceiro
                              usuariofinanceiro = sy-uname
                              datafinanceiro    = sy-datum ) )
            FAILED failed
            REPORTED reported.

    IF lines( failed-_cockpit ) GT 0.
      gs_msg = VALUE #( msgid =  gc_msg-id
                        msgno = 010
                        msgty = if_abap_behv_message=>severity-error ).
    ELSE.
      gs_msg = VALUE #( msgid = gc_msg-id
                        msgno = 009
                        msgty = if_abap_behv_message=>severity-success ).
    ENDIF.

    APPEND VALUE #( %tky = lt_release[ 1 ]-%tky
                    %msg = me->add_log_msg( is_msg = gs_msg ) ) TO reported-_cockpit.

    READ ENTITIES OF zi_mm_cockpit IN LOCAL MODE ENTITY _cockpit
        ALL FIELDS WITH CORRESPONDING #( keys )
        RESULT DATA(lt_result_all).

    result = VALUE #( FOR ls_result_all IN lt_result_all (
                        %key   = ls_result_all-%key
                        %param = ls_result_all ) ).

  ENDMETHOD.

  METHOD documentclose.

    READ ENTITIES OF zi_mm_cockpit IN LOCAL MODE
        ENTITY _cockpit
          FIELDS ( status )
            WITH CORRESPONDING #( keys )
              RESULT DATA(lt_close).

    MODIFY ENTITIES OF zi_mm_cockpit IN LOCAL MODE
      ENTITY _cockpit
        UPDATE FIELDS ( status usuariofinanceiro datafinanceiro )
          WITH VALUE #( FOR ls_close IN lt_close
                            ( %tky = ls_close-%tky
                              status = lc_stats-finalizado
                              usuariofinanceiro = sy-uname
                              datafinanceiro    = sy-datum ) )
            FAILED failed
            REPORTED reported.

    IF lines( failed-_cockpit ) GT 0.
      gs_msg = VALUE #( msgid =  gc_msg-id
                        msgno = 012
                        msgty = if_abap_behv_message=>severity-error ).
    ELSE.
      gs_msg = VALUE #( msgid = gc_msg-id
                        msgno = 011
                        msgty = if_abap_behv_message=>severity-success ).
    ENDIF.

    APPEND VALUE #( %tky = lt_close[ 1 ]-%tky
                    %msg = me->add_log_msg( is_msg = gs_msg ) ) TO reported-_cockpit.

    READ ENTITIES OF zi_mm_cockpit IN LOCAL MODE
      ENTITY _cockpit
      ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(lt_result_all).

    result = VALUE #( FOR ls_result_all IN lt_result_all (
                        %key   = ls_result_all-%key
                        %param = ls_result_all ) ).
  ENDMETHOD.

  METHOD fupdocument.

*    DATA ls_header TYPE bapiache09.
    DATA ls_header TYPE zsmm_lancam_comp_header_data.
    DATA lv_kstar  TYPE kstar.

    DATA lt_return TYPE bapiret2_tab.
*    DATA lt_ret_aux TYPE bapiret2_tab.
*    DATA lt_accountgl TYPE bapiacgl09_tab.
*    DATA lt_accountpayable TYPE bapiacap09_tab.
*    DATA lt_currency TYPE bapiaccr09_tab.
    DATA lt_item TYPE zctgmm_lancam_comp_item_data.
    DATA lt_documents TYPE zctgmm_lancam_comp_documents.

    READ ENTITIES OF zi_mm_cockpit IN LOCAL MODE
        ENTITY _cockpit
          ALL FIELDS WITH CORRESPONDING #( keys )
          RESULT DATA(lt_data).

    TRY.
        DATA(ls_data) = lt_data[ 1 ].
      CATCH cx_sy_itab_line_not_found INTO DATA(lo_exception).
        RETURN.
    ENDTRY.

    gs_log = VALUE #( aluser    = sy-uname
                      alprog    = sy-repid
                      aldate    = sy-datum
                      object    = gc_log-object
                      subobject = gc_log-subobject
                      extnumber = |{ ls_data-purchaseorder }{ ls_data-purchaseorderitem }{ ls_data-%key-br_notafiscal }| ).

    SELECT b~bldat, b~bukrs, b~waers, b~xblnr, b~bktxt,
           bs~lifnr, bs~gsber, bs~netdt, bs~belnr, bs~gjahr,
           bs~buzei, bs~bupla, bs~zlsch, bs~hbkid, bs~prctr,
           bs~segment, bs~kostl, bs~wrbtr
            FROM i_br_nfdocumentflow_c AS a
           INNER JOIN bkpf AS b
              ON a~referencedocument = b~awkey
           INNER JOIN bseg AS bs
              ON b~bukrs = bs~bukrs
             AND b~belnr = bs~belnr
             AND b~gjahr = bs~gjahr
             AND bs~koart = 'K' "'S'
*             AND bs~buzei = 1
           WHERE a~br_notafiscal = @ls_data-br_notafiscal
             AND a~originreferencedocument = @ls_data-purchaseorder
             AND a~originreferencedocumentitem = @ls_data-purchaseorderitem
            ORDER BY buzei
            INTO TABLE @DATA(lt_account).

    TRY.
        DATA(ls_account) = lt_account[ 1 ].
      CATCH cx_sy_itab_line_not_found INTO lo_exception.
        RETURN.
    ENDTRY.

*    ls_header = VALUE bapiache09( doc_date = ls_account-bldat
*                                  pstng_date = sy-datum
*                                  doc_type = |KR|
*                                  comp_code = ls_account-bukrs
*                                  fis_period = sy-datum+4(2)
*                                  ref_doc_no = ls_account-xblnr
*                                  username   = sy-uname
*                                  header_txt = |CONTABILIDADE| ).

    ls_header =  VALUE zsmm_lancam_comp_header_data( bukrs = ls_account-bukrs
                                                     waers = ls_account-waers
                                                     bldat = ls_account-bldat
                                                     budat = sy-datum
                                                     blart = |KR|
                                                     bktxt = |CONTABILIDADE|
                                                     monat = sy-datum+4(2)
                                                     xblnr = ls_account-xblnr  ).

*    lt_accountpayable = VALUE bapiacap09_tab( ( itemno_acc = 1
*                                                vendor_no = ls_data-supplier
*                                                bus_area = ls_account-gsber
*                                                bline_date = ls_account-netdt
*                                                paymt_ref = ls_account-belnr
*                                                part_businessplace = ls_account-gjahr
*                                                ppa_ex_ind = ls_account-buzei
*                                                pymt_meth = ls_account-zlsch
*                                                partner_bk = ls_account-hbkid
*                                                item_text = |{ TEXT-001 } { ls_account-xblnr }|
*                                                profit_ctr = ls_account-prctr ) ).

*    DATA(lv_kstar) = CONV kstar( |4310100013| ).
*    DATA(lv_kostl) = CONV kostl( |1854031Z15| ).
*    CALL FUNCTION 'K_ACCOUNT_ASSIGNMENT_GET'
*      EXPORTING
*        bukrs = ls_account-bukrs
*        kstar = lv_kstar
*      IMPORTING
*        kostl = ls_account-kostl.

    DATA(lo_param) = zclca_tabela_parametros=>get_instance( ).    " CHANGE - JWSILVA - 21.07.2023

    TRY.
        lo_param->m_get_single( EXPORTING iv_modulo = gc_param-modulo
                                          iv_chave1 = gc_param-chave1
                                          iv_chave2 = gc_param-chave2
                                IMPORTING ev_param  = lv_kstar ).
        "OKB9
        SELECT SINGLE kostl
        FROM tka3a
        INTO @DATA(lv_kostl)
        WHERE bukrs = @ls_account-bukrs
          AND kstar = @lv_kstar.
      CATCH zcxca_tabela_parametros.
    ENDTRY.

    DATA(lv_desconto) = ls_data-descontocomercial + ls_data-descontofinanceiro.
    DATA(lv_valor) = ls_account-wrbtr - lv_desconto.

    lt_item = VALUE zctgmm_lancam_comp_item_data( ( buzei = 001
                                                    bschl = 37
                                                    bupla = ls_account-bupla
                                                    zlsch = ls_account-zlsch
                                                    zlspr = space
                                                    zterm = space
                                                    zfbdt = sy-datum
                                                    hkont = ls_data-supplier
                                                    wrbtr = lv_valor
                                                    zuonr = ls_data-observacao
                                                    sgtxt = |{ TEXT-001 } { ls_account-xblnr }|
                                                    prctr = ls_account-prctr
                                                    kostl = space
                                                    xref2 = space
                                                    gsber = ls_account-gsber
                                                    augtx = space ) ).

    lt_documents = VALUE zctgmm_lancam_comp_documents( ( bukrs = ls_account-bukrs
                                                         koart = 'K'
                                                         hkont = ls_data-supplier
                                                         belnr = ls_account-belnr
                                                         gjahr = ls_account-gjahr
                                                         buzei = ls_account-buzei ) ).

*    lt_accountgl = VALUE bapiacgl09_tab( ( itemno_acc = 2
**                                           stat_con = |H|
*                                           gl_account = lv_kstar
*                                           bus_area = ls_account-gsber
*                                           item_text = |{ TEXT-001 } { ls_account-xblnr }|
*                                           costcenter = lv_kostl
*                                           profit_ctr = ls_account-prctr
*                                           segment = ls_account-segment ) ).


*    DATA(lt_extension2) = VALUE re_t_xa_bapiparex(
*      ( structure  = 'BUPLA' valuepart1 = 1 valuepart2 = ls_account-bupla ) ).

*    IF ls_data-descontocomercial IS NOT INITIAL.

*      DATA(lt_currencyamount) = VALUE re_t_bapiaccr09(
*        ( itemno_acc   = 1
*          currency_iso = ls_data-waers
*          amt_doccur   = ls_data-descontocomercial * -1 )
*        ( itemno_acc   = 2
*          currency_iso = ls_data-waers
*          amt_doccur   = ls_data-descontocomercial ) ).

    APPEND VALUE zsmm_lancam_comp_item_data( buzei = 002
                                             bschl = 50
                                             bupla = ls_account-bupla
                                             hkont = lv_kstar
                                             wrbtr = lv_desconto
                                             zuonr = ls_data-observcomercial
                                             sgtxt = |{ TEXT-001 } { ls_account-xblnr }|
                                             kostl = lv_kostl ) TO lt_item.

    gv_wait_async = abap_false.

*      CALL FUNCTION 'BAPI_ACC_DOCUMENT_POST'
*        STARTING NEW TASK 'ACC_DOCUMENT_POST_COMERCIAL'
*        CALLING get_messages ON END OF TASK
*        EXPORTING
*          documentheader = ls_header
*        TABLES
*          accountgl      = lt_accountgl
*          accountpayable = lt_accountpayable
*          currencyamount = lt_currencyamount
*          extension2     = lt_extension2.

    CALL FUNCTION 'ZFMMM_LANCAM_COMPENSACAO'
      STARTING NEW TASK 'LANCAM_COMPENSACAO'
      CALLING get_messages ON END OF TASK
      EXPORTING
        is_header    = ls_header
      TABLES
        it_item      = lt_item
        it_documents = lt_documents.

    WAIT UNTIL gv_wait_async = abap_true.

    CALL FUNCTION 'ZFMCA_LOG_MSG_ADD'
*        STARTING NEW TASK 'LOG_DESCONTO_COMERCIAL'
      STARTING NEW TASK 'LOG_DESCONTO'
      EXPORTING
        is_log  = gs_log
        it_msgs = gt_messages.

*      IF gv_obj_key IS INITIAL.
    IF gv_belnr IS INITIAL.
      APPEND VALUE #( %tky = ls_data-%tky
                      %msg = me->add_log_msg( VALUE #( msgid = gc_msg-id
                                                       msgno = 014
                                                       msgty = if_abap_behv_message=>severity-error ) ) ) TO reported-_cockpit.
    ELSE.
      APPEND VALUE #( %tky = ls_data-%tky
                      %msg = me->add_log_msg( VALUE #( msgid = gc_msg-id
                                                       msgno = 013
                                                       msgty = if_abap_behv_message=>severity-success
*                                                         msgv1 = gv_obj_key(10)
                                                       msgv1 = gv_belnr
*                                                         msgv2 = gv_obj_key+10(4)
                                                       msgv2 = gv_gjahr
*                                                         msgv3 = gv_obj_key+14(4) ) ) ) TO reported-_cockpit.
                                                       msgv3 = gv_bukrs ) ) ) TO reported-_cockpit.
    ENDIF.

*    ENDIF.


*    IF ls_data-descontofinanceiro IS NOT INITIAL.
*
**      lt_currencyamount = VALUE re_t_bapiaccr09(
**        ( itemno_acc   = 1
**          currency_iso = ls_data-waers
**          amt_doccur   = ls_data-descontofinanceiro * -1 )
**        ( itemno_acc   = 2
**          currency_iso = ls_data-waers
**          amt_doccur   = ls_data-descontofinanceiro ) ).
*
*      gv_wait_async = abap_false.
*
**      CALL FUNCTION 'BAPI_ACC_DOCUMENT_POST'
**        STARTING NEW TASK 'ACC_DOCUMENT_POST_FINANCEIRO'
**        CALLING get_messages ON END OF TASK
**        EXPORTING
**          documentheader = ls_header
**        TABLES
**          accountgl      = lt_accountgl
**          accountpayable = lt_accountpayable
**          currencyamount = lt_currencyamount
**          extension2     = lt_extension2.
*
*      WAIT UNTIL gv_wait_async = abap_true.
*
*      CALL FUNCTION 'ZFMCA_LOG_MSG_ADD'
*        STARTING NEW TASK 'LOG_DESCONTO_FINANCEIRO'
*        EXPORTING
*          is_log  = gs_log
*          it_msgs = gt_messages.
*
**      IF gv_obj_key IS INITIAL.
*      IF gv_belnr IS INITIAL.
*        APPEND VALUE #( %tky = ls_data-%tky
*                        %msg = me->add_log_msg( VALUE #( msgid = gc_msg-id
*                                                         msgno = 014
*                                                         msgty = if_abap_behv_message=>severity-error ) ) ) TO reported-_cockpit.
*      ELSE.
*        APPEND VALUE #( %tky = ls_data-%tky
*                        %msg = me->add_log_msg( VALUE #( msgid = gc_msg-id
*                                                         msgno = 013
*                                                         msgty = if_abap_behv_message=>severity-success
*                                                         msgv1 = gv_obj_key(10)
*                                                         msgv2 = gv_obj_key+10(4)
*                                                         msgv3 = gv_obj_key+14(4) ) ) ) TO reported-_cockpit.
*      ENDIF.
*    ENDIF.

    IF gv_error IS INITIAL.
      MODIFY ENTITIES OF zi_mm_cockpit IN LOCAL MODE
        ENTITY _cockpit
          UPDATE FIELDS ( status usuariofinanceiro datafinanceiro )
            WITH VALUE #( FOR ls_result IN lt_data
                              ( %tky = ls_result-%tky
                                status = lc_stats-finalizado
                                usuariocomercial  = COND #( WHEN ls_result-status EQ lc_stats-liberadocomercial
                                                            THEN sy-uname )
                                datacomercial     = COND #( WHEN ls_result-status EQ lc_stats-liberadocomercial
                                                            THEN sy-datum )
                                usuariofinanceiro = COND #( WHEN ls_result-status EQ lc_stats-liberadofinanceiro
                                                            THEN sy-uname )
                                datafinanceiro    = COND #( WHEN ls_result-status EQ lc_stats-liberadofinanceiro
                                                            THEN sy-datum ) ) )
              FAILED failed
              REPORTED DATA(lt_reported).
    ENDIF.

    READ ENTITIES OF zi_mm_cockpit IN LOCAL MODE
      ENTITY _cockpit
      ALL FIELDS WITH CORRESPONDING #( keys )
      RESULT DATA(lt_result_all).

    result = VALUE #( FOR ls_result_all IN lt_result_all (
                        %key   = ls_result_all-%key
                        %param = ls_result_all ) ).

  ENDMETHOD.

  METHOD get_features.

    READ ENTITIES OF zi_mm_cockpit IN LOCAL MODE
        ENTITY _cockpit
          FIELDS ( status statuscompensado ) WITH CORRESPONDING #( keys )
            RESULT DATA(lt_features).


    result = VALUE #(
      FOR ls_features IN lt_features (
        %tky = ls_features-%tky

        %action-comercialdiscount  = COND #( WHEN ( ls_features-status = gc_status_pendente OR ls_features-status = gc_status_retcomercial OR ls_features-status = gc_status_revcomercial )
                                              AND liberacao_comercial( )
                                             THEN if_abap_behv=>fc-o-enabled ELSE if_abap_behv=>fc-o-disabled )
*        %action-comercialdiscount  = COND #( WHEN ls_features-statuscompensado IS INITIAL
*                                              AND ( ls_features-status = gc_status_pendente OR ls_features-status = gc_status_revComercial OR ls_features-status = gc_status_retComercial )
*                                              AND liberacao_comercial( )
*                                             THEN if_abap_behv=>fc-o-enabled ELSE if_abap_behv=>fc-o-disabled )

        %action-comercialrelease   = COND #( WHEN ( ls_features-status = gc_status_revComercial OR ls_features-status = gc_status_retComercial )
                                              AND liberacao_comercial( )
                                             THEN if_abap_behv=>fc-o-enabled ELSE if_abap_behv=>fc-o-disabled )


*        %action-financialrelease   = COND #( WHEN ls_features-statuscompensado IS INITIAL
*                                              AND ( ls_features-status = gc_status_revFinanceiro OR ls_features-status = gc_status_libComercial )
*                                              AND liberacao_financeira( )
*                                             THEN if_abap_behv=>fc-o-enabled ELSE if_abap_behv=>fc-o-disabled )

        "Botoes inutilizados
        %action-financialdiscount = if_abap_behv=>fc-o-disabled
        %action-documentclose     = if_abap_behv=>fc-o-disabled
        %action-comercialreturn   = if_abap_behv=>fc-o-disabled
        %action-fupdocument       = if_abap_behv=>fc-o-disabled
        %action-financialrelease  = if_abap_behv=>fc-o-disabled

*        %action-comercialreturn    = COND #( WHEN ls_features-statuscompensado IS INITIAL
*                                              AND ( ls_features-status = gc_status_revFinanceiro OR ls_features-status = gc_status_libComercial OR ls_features-status = gc_status_libFinanceiro )
*                                              AND liberacao_financeira( )
*                                             THEN if_abap_behv=>fc-o-enabled ELSE if_abap_behv=>fc-o-disabled )

*        %action-financialdiscount  = COND #( WHEN ls_features-statuscompensado IS INITIAL
*                                              AND ( ls_features-status = gc_status_revFinanceiro OR ls_features-status = gc_status_libComercial OR ls_features-status = gc_status_libFinanceiro )
*                                              AND liberacao_financeira( )
*                                             THEN if_abap_behv=>fc-o-enabled ELSE if_abap_behv=>fc-o-disabled )


*        %action-documentclose      = COND #( WHEN ls_features-statuscompensado IS INITIAL
*                                              AND ( ls_features-status = gc_status_revFinanceiro OR ls_features-status = gc_status_libComercial OR ls_features-status = gc_status_libFinanceiro )
*                                              AND liberacao_financeira( )
*                                             THEN if_abap_behv=>fc-o-enabled ELSE if_abap_behv=>fc-o-disabled )

*        %action-fupdocument        = COND #( WHEN ls_features-status = gc_status_libFinanceiro
*                                              AND liberacao_financeira( )
*                                             THEN if_abap_behv=>fc-o-enabled ELSE if_abap_behv=>fc-o-disabled )

                                             ) ).
*        %action-showLog            = if_abap_behv=>fc-o-enabled ) ).

  ENDMETHOD.

  METHOD add_log_msg.

    IF NOT gs_msg IS INITIAL.
      rv_msg = new_message( id       = gs_msg-msgid
                            number   = gs_msg-msgno
                            severity = CONV #( gs_msg-msgty )
                            v1       = gs_msg-msgv1
                            v2       = gs_msg-msgv2
                            v3       = gs_msg-msgv3
                            v4       = gs_msg-msgv4 ).
    ELSE.
      rv_msg = new_message( id       = is_msg-msgid
                            number   = is_msg-msgno
                            severity = CONV #( gs_msg-msgty )
                            v1       = is_msg-msgv1
                            v2       = is_msg-msgv2
                            v3       = is_msg-msgv3
                            v4       = is_msg-msgv4 ).
    ENDIF.

  ENDMETHOD.

  METHOD create_log.

    CALL FUNCTION 'BAL_LOG_CREATE'
      EXPORTING
        i_s_log                 = is_log
      IMPORTING
        e_log_handle            = gv_log_handle
      EXCEPTIONS
        log_header_inconsistent = 1
        OTHERS                  = 2.
    IF sy-subrc <> 0.
      rv_msg = new_message( EXPORTING id       = sy-msgid
                                      number   = sy-msgno
                                      severity = CONV #( sy-msgty )
                                      v1       = sy-msgv1
                                      v2       = sy-msgv2
                                      v3       = sy-msgv3
                                      v4       = sy-msgv4 ).
    ENDIF.

  ENDMETHOD.

  METHOD get_messages.

    FREE: "gv_obj_key,
          gv_belnr,
          gt_messages.

*    RECEIVE RESULTS FROM FUNCTION 'BAPI_ACC_DOCUMENT_POST'
*      IMPORTING
*        obj_key = gv_obj_key
*      TABLES
*        return  = gt_messages.
*
*    DATA(lv_len) = strlen( gv_obj_key ).
*    IF lv_len LT 18.
*      FREE gv_obj_key.
*      gv_error = abap_true.
*    ELSE.
*      CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'.
*    ENDIF.

    RECEIVE RESULTS FROM FUNCTION 'ZFMMM_LANCAM_COMPENSACAO'
      IMPORTING
        ev_belnr  = gv_belnr
        ev_gjahr  = gv_gjahr
        ev_bukrs  = gv_bukrs
      TABLES
        et_return = gt_messages.

    IF gv_belnr IS INITIAL.
      gv_error = abap_true.
    ENDIF.

*    CASE p_task.
**      WHEN 'ACC_DOCUMENT_POST_COMERCIAL'.
*      WHEN 'LANCAM_COMPENSACAO_COMERCIAL'.
*        INSERT VALUE #( type   = gc_msg-info
*                        id     = gc_msg-id
*                        number = 015 ) INTO gt_messages INDEX 1.
*
**      WHEN 'ACC_DOCUMENT_POST_FINANCEIRO'.
*      WHEN 'LANCAM_COMPENSACAO_FINANCEIRO'.
*        INSERT VALUE #( type   = gc_msg-info
*                        id     = gc_msg-id
*                        number = 016 ) INTO gt_messages INDEX 1.
*    ENDCASE.

    CASE p_task.
      WHEN 'LANCAM_COMPENSACAO'.
        INSERT VALUE #( type   = gc_msg-info
                        id     = gc_msg-id
                        number = 017 ) INTO gt_messages INDEX 1.
    ENDCASE.

    gv_wait_async = abap_true.

  ENDMETHOD.


  METHOD liberacao_comercial.
    FREE rv_result.

    AUTHORITY-CHECK OBJECT gc_authobj-zmmlibcom
      ID gc_id-actvt FIELD gc_actvt-executar.
    CHECK sy-subrc IS INITIAL.

    rv_result = abap_true.
  ENDMETHOD.


  METHOD liberacao_financeira.
    FREE rv_result.

    AUTHORITY-CHECK OBJECT gc_authobj-zmmlibfin
      ID gc_id-actvt FIELD gc_actvt-executar.
    CHECK sy-subrc IS INITIAL.

    rv_result = abap_true.
  ENDMETHOD.

ENDCLASS.
