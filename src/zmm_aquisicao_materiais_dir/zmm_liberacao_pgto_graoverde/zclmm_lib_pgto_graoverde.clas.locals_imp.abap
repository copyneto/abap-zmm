CLASS lcl_LibPgtoGraoVerde DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    DATA lr_object TYPE REF TO zifmm_lib_pgto_graoverde.

    METHODS get_authorizations FOR AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR _LibPgtoGVApp RESULT result.

    METHODS descontoFinanceiro FOR MODIFY
      IMPORTING keys FOR ACTION _LibPgtoGVApp~descontoFinanceiro.

    METHODS retornarComercial FOR MODIFY
      IMPORTING keys FOR ACTION _LibPgtoGVApp~retornarComercial.

    METHODS contabilizarDesconto FOR MODIFY
      IMPORTING keys FOR ACTION _LibPgtoGVApp~contabilizarDesconto.

    METHODS liberadoFinanceiro FOR MODIFY
      IMPORTING keys FOR ACTION _LibPgtoGVApp~liberadoFinanceiro.

    METHODS finalizado FOR MODIFY
      IMPORTING keys FOR ACTION _LibPgtoGVApp~finalizado.

    METHODS get_features FOR FEATURES
      IMPORTING keys REQUEST requested_features FOR _LibPgtoGVApp RESULT result.

    METHODS format_return
      CHANGING
        !ct_return TYPE bapiret2_t.

    METHODS check_permission
      IMPORTING
        !iv_actvt    TYPE activ_auth
      EXPORTING
        !ev_ok       TYPE flag
        !et_return   TYPE bapiret2_t
      RETURNING
        VALUE(rv_ok) TYPE flag .

    METHODS check_all_permission
      EXPORTING
        !ev_desc_fin  TYPE flag
        !ev_cont_des  TYPE flag
        !ev_libe_fin  TYPE flag
        !ev_reto_com  TYPE flag
        !ev_finalizar TYPE flag.

    METHODS limparMarcados
      IMPORTING
        !iv_numdocumento TYPE ebeln
        !iv_fat          TYPE flag
        !iv_adi          TYPE flag
        !iv_dev          TYPE flag
        !iv_des_con      TYPE flag.

ENDCLASS.

CLASS lcl_LibPgtoGraoVerde IMPLEMENTATION.

  METHOD get_authorizations.
    RETURN.
  ENDMETHOD.

  METHOD descontoFinanceiro.

    DATA: lt_return TYPE bapiret2_tab.

    READ ENTITIES OF zi_mm_lib_pgto_app
      IN LOCAL MODE ENTITY _LibPgtoGVApp BY \_fat
         ALL FIELDS
         WITH CORRESPONDING #( keys )
         RESULT DATA(lt_fat)
         FAILED failed.

    TRY.

        DELETE lt_fat WHERE marcado IS INITIAL.

        IF lt_fat[] IS NOT INITIAL.

            READ ENTITIES OF zi_mm_lib_pgto_app
              IN LOCAL MODE ENTITY _LibPgtoGVApp BY \_desComFin
                 ALL FIELDS
                 WITH CORRESPONDING #( keys )
                 RESULT DATA(lt_desc).

            DATA(lv_bukrs) = lt_fat[ 1 ]-Empresa.
            DATA(lv_gjahr) = lt_fat[ 1 ]-Ano.
            DATA(lv_belnr) = lt_fat[ 1 ]-NumDocumento.
            DATA(lv_ebeln) = lt_fat[ 1 ]-NumDocumentoRef.
            DATA(lv_waers) = lt_fat[ 1 ]-Moeda.

            SELECT SINGLE j_1bnfdoc~docnum
            FROM bkpf
            INNER JOIN  j_1bnfdoc on bkpf~bukrs = j_1bnfdoc~bukrs AND
                                    bkpf~gjahr = j_1bnfdoc~gjahr AND
                                    substring( bkpf~awkey, 1, 10 ) = j_1bnfdoc~belnr
            WHERE bkpf~bukrs = @lv_bukrs
            AND  bkpf~gjahr = @lv_gjahr
            AND  bkpf~belnr = @lv_belnr
            INTO @DATA(lv_docnum).


*            MODIFY ENTITIES OF zi_mm_lib_pgto_app
*                IN LOCAL MODE
*            ENTITY _LibPgtoGVDesFinCom
*            UPDATE FIELDS ( VlrDescontoFin ObservacaoFin UsuarioFin DataFin DocNumFinanceiro GjahrFinanceiro )
*              WITH VALUE #( FOR ls_desc IN lt_desc ( %tky = ls_desc-%tky
*                                           VlrDescontoFin = VALUE #( keys[ 1 ]-%param-vlr_desconto_fin OPTIONAL )
*                                           ObservacaoFin = VALUE #( keys[ 1 ]-%param-observacao_fin OPTIONAL )
*                                           UsuarioFin = sy-uname
*                                           DataFin = sy-datum
*                                           DocNumFinanceiro = lv_docnum
*                                           GjahrFinanceiro = lv_gjahr ) )
*            FAILED failed
*            REPORTED reported.

            DATA: ls_gv_desc TYPE ztmm_pag_gv_desc.

            GET TIME STAMP FIELD DATA(lv_timestamp).

            ls_gv_desc-guid                  = cl_system_uuid=>create_uuid_x16_static( ).
            ls_gv_desc-bukrs                 = lv_bukrs.
            ls_gv_desc-ebeln                 = lv_ebeln.
            ls_gv_desc-waers                 = lv_waers.
            ls_gv_desc-docnum_fin            = lv_docnum.
            ls_gv_desc-vlr_desconto_fin      = VALUE #( keys[ 1 ]-%param-vlr_desconto_fin OPTIONAL ).
            ls_gv_desc-observacao_fin        = VALUE #( keys[ 1 ]-%param-observacao_fin OPTIONAL ).
            ls_gv_desc-usuario_fin           = sy-uname.
            ls_gv_desc-data_fin              = sy-datum.
            ls_gv_desc-gjahr_fin             = lv_gjahr.
            ls_gv_desc-created_by            = sy-uname.
            ls_gv_desc-created_at            = lv_timestamp.
            ls_gv_desc-last_changed_by       = sy-uname.
            ls_gv_desc-last_changed_at       = lv_timestamp.
            ls_gv_desc-local_last_changed_at = lv_timestamp.

            MODIFY ztmm_pag_gv_desc FROM ls_gv_desc.

            IF sy-subrc EQ 0.

              MODIFY ENTITIES OF zi_mm_lib_pgto_app
                  IN LOCAL MODE
              ENTITY _LibPgtoGVApp
              UPDATE FIELDS ( Status )
                WITH VALUE #( FOR ls_key IN keys ( %tky = ls_key-%tky
                                                  status = gc_status_revfinanceiro ) )
              FAILED failed
              REPORTED reported.

*              me->limparmarcados(
*                EXPORTING
*                  iv_numdocumento = lt_fat[ 1 ]-NumDocumentoRef
*                  iv_fat          = abap_true
*                  iv_adi          = abap_false
*                  iv_dev          = abap_false
*                  iv_des_con      = abap_false
*              ).

            ENDIF.

        ELSE.
          lt_return[] = VALUE #( BASE lt_return ( type = 'E' id = 'ZMM_LIB_PGTO_GV' number = '003' ) ).
        ENDIF.

      CATCH cx_root INTO DATA(lo_error).

    ENDTRY.

    reported-_libpgtogvapp = VALUE #( FOR ls_return IN lt_return (
                        %tky = COND #( WHEN lt_fat[] IS NOT INITIAL THEN lt_fat[ 1 ]-%tky )
                        %msg = new_message( id       = ls_return-id
                                            number   = ls_return-number
                                            v1       = ls_return-message_v1
                                            v2       = ls_return-message_v2
                                            v3       = ls_return-message_v3
                                            v4       = ls_return-message_v4
                                            severity = CONV #( ls_return-type ) ) ) ).


  ENDMETHOD.

  METHOD retornarComercial.

    READ ENTITIES OF zi_mm_lib_pgto_app
        IN LOCAL MODE ENTITY _LibPgtoGVApp BY \_desComFin
           ALL FIELDS
           WITH CORRESPONDING #( keys )
           RESULT DATA(lt_com).

    MODIFY ENTITIES OF zi_mm_lib_pgto_app
        IN LOCAL MODE
    ENTITY _LibPgtoGVDesFinCom
    UPDATE FIELDS ( UsuarioFin DataFin )
      WITH VALUE #( FOR ls_com IN lt_com ( %tky = ls_com-%tky
                                     usuariofin = sy-uname
                                        datafin = sy-datum ) )
    FAILED failed
    REPORTED reported.

    TRY.

        "vVamos manter apenas registros que possuem desconto comercial
        DELETE lt_com WHERE VlrDescontoCom IS INITIAL.

        SELECT  *
        FROM ztmm_desc_pag_gv
        FOR ALL ENTRIES IN @lt_com
        WHERE ebeln = @lt_com-NumDocumento
        AND   docnum = @lt_com-DocNumComercial
        INTO TABLE @DATA(lt_gv_cab).

        IF lt_gv_cab IS NOT INITIAL.

            LOOP AT lt_gv_cab ASSIGNING FIELD-SYMBOL(<fs_item>).
                <fs_item>-status = gc_status_retcomercial.
            ENDLOOP.

            MODIFY ztmm_desc_pag_gv FROM TABLE lt_gv_cab.

        ENDIF.

     CATCH cx_root INTO DATA(lo_root).
        DATA(lv_message) = CONV bapi_msg( lo_root->get_longtext( ) ).
    ENDTRY.




    IF lines( failed-_libpgtogvdesfincom ) EQ 0.

      MODIFY ENTITIES OF zi_mm_lib_pgto_app
          IN LOCAL MODE
      ENTITY _LibPgtoGVApp
      UPDATE FIELDS ( Status )
        WITH VALUE #( FOR ls_key IN keys ( %tky = ls_key-%tky
                                         status = gc_status_retcomercial ) )
      FAILED failed
    REPORTED reported.

    ENDIF.

  ENDMETHOD.

  METHOD contabilizarDesconto.

** ---------------------------------------------------------------------------
** Verifica autorização
** ---------------------------------------------------------------------------
*    me->check_permission( EXPORTING iv_actvt  = gc_authority-contabilizar_desconto
*                          IMPORTING et_return = DATA(lt_return) ).

* ---------------------------------------------------------------------------
* Recupera dados das linhas selecionadas
* ---------------------------------------------------------------------------
    READ ENTITIES OF zi_mm_lib_pgto_app
      IN LOCAL MODE ENTITY _LibPgtoGVApp BY \_fat
         ALL FIELDS
         WITH CORRESPONDING #( keys )
         RESULT DATA(lt_fat)
         FAILED failed.

* ---------------------------------------------------------------------------
* Recupera dados informados
* ---------------------------------------------------------------------------
    TRY.

        DATA: lt_return TYPE BAPIRET2_TAB.

        DELETE lt_fat WHERE marcado IS INITIAL.

        IF lt_fat[] IS NOT INITIAL.
          lr_object = zclmm_libpg_grvde_op=>factory( iv_oper = zifmm_lib_pgto_graoverde=>gc_tipo-financeiro ).
          lr_object->set_properties( it_properties = REF #( lt_fat ) ).

          READ ENTITIES OF zi_mm_lib_pgto_app
          IN LOCAL MODE ENTITY _LibPgtoGVApp BY \_desComFin
          ALL FIELDS
          WITH CORRESPONDING #( keys )
          RESULT DATA(lt_desc).

          DATA: lv_desc_fin TYPE flag,
                lv_desc_com TYPE flag.

          DELETE lt_desc WHERE VlrDescontoFin IS INITIAL AND VlrDescontoCom IS INITIAL.

          LOOP AT lt_desc INTO DATA(ls_desc).

            IF ls_desc-VlrDescontoFin > 0 AND ls_desc-DocContabilFinanceiro IS INITIAL.
                lv_desc_fin = abap_true.
            ELSE.
                "lv_doc_contabil_fin = .
                IF ls_desc-DocContabilFinanceiro IS NOT INITIAL.
                    lt_return[] = VALUE #( BASE lt_return ( type = 'I' id = 'ZMM_LIB_PGTO_GV' number = '012' message_v1 = ls_desc-DocNumFinanceiro ) ).
                ENDIF.

            ENDIF.

            IF ls_desc-VlrDescontoCom > 0 AND ls_desc-DocContabilComercial IS INITIAL.
                lv_desc_com = abap_true.
            ELSE.
                "lv_doc_contabil_com = .
                IF ls_desc-DocContabilComercial IS NOT INITIAL.
                lt_return[] = VALUE #( BASE lt_return ( type = 'I' id = 'ZMM_LIB_PGTO_GV' number = '013' message_v1 = ls_desc-DocNumComercial ) ).
                ENDIF.

            ENDIF.

          ENDLOOP.

          "Lançar desc. financeiro
          IF lv_desc_fin = abap_true.
            lr_object->executar( iv_tipo = 'F' ).
            DATA(lt_return_desc_fin) = CAST zclmm_libpg_grvde_disc( lr_object )->get_messages( ).

*            SORT lt_return_desc_fin[] BY type.
*            READ TABLE lt_return_desc_fin[] TRANSPORTING message_v1 INTO DATA(lv_doc_cont_fin) WITH KEY type = 'S' BINARY SEARCH.
*
*            IF lv_doc_cont_fin IS NOT INITIAL.
*                lv_doc_contabil_fin = lv_doc_cont_fin-message_v1.
*            ENDIF.

          ENDIF.
          "Lançar desc. comercial
          IF lv_desc_com = abap_true.
            lr_object->executar( iv_tipo = 'C' ).
            DATA(lt_return_desc_com) = CAST zclmm_libpg_grvde_disc( lr_object )->get_messages( ).

*            SORT lt_return_desc_com[] BY type.
*            READ TABLE lt_return_desc_com[] TRANSPORTING message_v1 INTO DATA(lv_doc_cont_com) WITH KEY type = 'S' BINARY SEARCH.
*
*            IF lv_doc_cont_com IS NOT INITIAL.
*                lv_doc_contabil_com = lv_doc_cont_com-message_v1.
*            ENDIF.

          ENDIF.

          APPEND LINES OF lt_return_desc_fin TO lt_return.
          APPEND LINES OF lt_return_desc_com TO lt_return.
          SORT lt_return BY number ASCENDING.
          DELETE ADJACENT DUPLICATES FROM lt_return COMPARING number message_v1 message_v2 message_v3 message_v4.

        ELSE.
          lt_return[] = VALUE #( BASE lt_return ( type = 'E' id = 'ZMM_LIB_PGTO_GV' number = '003' ) ).
        ENDIF.

      CATCH cx_root INTO DATA(lo_error).

    ENDTRY.

* ---------------------------------------------------------------------------
* Desmarca os registros
* ---------------------------------------------------------------------------
    IF NOT line_exists( lt_return[ type = 'E' ] ).
*    IF line_exists( lt_return[ type = 'S' ] ).
*      me->limparmarcados(
*        EXPORTING
*          iv_numdocumento = lt_fat[ 1 ]-NumDocumentoRef
*          iv_fat          = abap_true
*          iv_adi          = abap_false
*          iv_dev          = abap_false
*          iv_des_con      = abap_false
*      ).
*      voltar caso ncessário
*      MODIFY ENTITIES OF zi_mm_lib_pgto_app
*      IN LOCAL MODE
*      ENTITY _LibPgtoGVDesFinCom
*      UPDATE FIELDS ( DocContabilFinanceiro DocContabilComercial )
*      WITH VALUE #( FOR ls_fin IN lt_desc ( %tky = ls_fin-%tky
*                                            DocContabilFinanceiro = lv_doc_contabil_fin
*                                            DocContabilComercial  = lv_doc_contabil_com ) ).

      MODIFY ENTITIES OF zi_mm_lib_pgto_app
      IN LOCAL MODE ENTITY _LibPgtoGVApp
      UPDATE FIELDS ( Status )
      WITH VALUE #( FOR ls_key IN keys ( %tky = ls_key-%tky
                                        status = gc_status_libfinanceiro ) )
      FAILED failed
      REPORTED reported.

    ENDIF.

    me->format_return( CHANGING ct_return = lt_return[] ).

* ---------------------------------------------------------------------------
* Retorna mensagens
* ---------------------------------------------------------------------------

    reported-_libpgtogvapp = VALUE #( FOR ls_return IN lt_return (
                        %tky = COND #( WHEN lt_fat[] IS NOT INITIAL THEN lt_fat[ 1 ]-%tky )
                        %msg = new_message( id       = ls_return-id
                                            number   = ls_return-number
                                            v1       = ls_return-message_v1
                                            v2       = ls_return-message_v2
                                            v3       = ls_return-message_v3
                                            v4       = ls_return-message_v4
                                            severity = CONV #( ls_return-type ) ) ) ).


  ENDMETHOD.

  METHOD liberadoFinanceiro.

    READ ENTITIES OF zi_mm_lib_pgto_app
      IN LOCAL MODE ENTITY _LibPgtoGVApp BY \_fat
         ALL FIELDS
         WITH CORRESPONDING #( keys )
         RESULT DATA(lt_fat)
         FAILED failed.

    READ ENTITIES OF zi_mm_lib_pgto_app
      IN LOCAL MODE ENTITY _LibPgtoGVApp BY \_adi
         ALL FIELDS
         WITH CORRESPONDING #( keys )
         RESULT DATA(lt_adi)
         FAILED failed.

    READ ENTITIES OF zi_mm_lib_pgto_app
      IN LOCAL MODE ENTITY _LibPgtoGVApp BY \_dev
         ALL FIELDS
         WITH CORRESPONDING #( keys )
         RESULT DATA(lt_dev)
         FAILED failed.

    READ ENTITIES OF zi_mm_lib_pgto_app
      IN LOCAL MODE ENTITY _LibPgtoGVApp BY \_des
         ALL FIELDS
         WITH CORRESPONDING #( keys )
         RESULT DATA(lt_des)
         FAILED failed.

    "Ajustamos o exercicio caso esteja diferente
    LOOP AT lt_des ASSIGNING FIELD-SYMBOL(<fs_item>).

        SELECT SINGLE _bkpf~gjahr
        FROM bkpf as _bkpf
        join bseg as _bseg  on  _bkpf~bukrs = _bseg~bukrs
                            and _bkpf~gjahr = _bseg~gjahr
                            and _bkpf~belnr = _bseg~belnr
        join bsik_view as _bsik  on  _bseg~bukrs = _bsik~bukrs
                                 and _bseg~gjahr = _bsik~gjahr
                                 and _bseg~belnr = _bsik~belnr
                                 and _bseg~buzei = _bsik~buzei
        WHERE _bkpf~bukrs = @<fs_item>-Empresa
        AND _bkpf~belnr = @<fs_item>-NumDocumento
        AND _bsik~shkzg = 'S'
        INTO @DATA(lv_gjahr).

        IF sy-subrc = 0 AND
        <fs_item>-Ano <> lv_gjahr.
            <fs_item>-Ano = lv_gjahr.
        ENDIF.
    ENDLOOP.


    APPEND LINES OF: lt_adi TO lt_fat,
                     lt_dev TO lt_fat,
                     lt_des TO lt_fat.

    DELETE lt_fat WHERE marcado IS INITIAL.

    IF line_exists( lt_fat[ Indicador = |S| ] ).

      lr_object = zclmm_libpg_grvde_op=>factory( iv_oper = zifmm_lib_pgto_graoverde=>gc_tipo-transfercomp ).

    ELSE.

      lr_object = zclmm_libpg_grvde_op=>factory( iv_oper = zifmm_lib_pgto_graoverde=>gc_tipo-retiradabloq ).

    ENDIF.

    TRY.

        lt_fat[ 1 ]-DtVencimentoLiquido = VALUE #( keys[ 1 ]-%param-vctoresidual OPTIONAL ).

        lr_object->set_properties( it_properties = REF #( lt_fat ) ).
        lr_object->executar( ).

        DATA(lt_return) = CAST zclmm_libpg_grvde_op( lr_object )->get_messages( ).

      CATCH cx_sy_itab_line_not_found INTO DATA(lo_error).

    ENDTRY.

* ---------------------------------------------------------------------------
* Desmarca os registros
* ---------------------------------------------------------------------------
    IF line_exists( lt_return[ type = 'S' ] ).
*      me->limparmarcados(
*        EXPORTING
*          iv_numdocumento = lt_fat[ 1 ]-NumDocumentoRef
*          iv_fat          = abap_true
*          iv_adi          = abap_false
*          iv_dev          = abap_false
*          iv_des_con      = abap_false
*      ).

      MODIFY ENTITIES OF zi_mm_lib_pgto_app
      IN LOCAL MODE ENTITY _LibPgtoGVApp
      UPDATE FIELDS ( Status )
      WITH VALUE #( FOR ls_key IN keys ( %tky = ls_key-%tky
                                        status = gc_status_libfinanceiro ) )
      FAILED failed
      REPORTED reported.

    ENDIF.

* ---------------------------------------------------------------------------
* Retorna mensagens
* ---------------------------------------------------------------------------
    reported-_libpgtogvapp = VALUE #( FOR ls_return IN lt_return (
                        %tky = lt_fat[ 1 ]-%tky
                        %msg = new_message( id       = ls_return-id
                                            number   = ls_return-number
                                            v1       = ls_return-message_v1
                                            v2       = ls_return-message_v2
                                            v3       = ls_return-message_v3
                                            v4       = ls_return-message_v4
                                            severity = CONV #( ls_return-type ) ) ) ).

  ENDMETHOD.

  METHOD finalizado.

    READ ENTITIES OF zi_mm_lib_pgto_app
      IN LOCAL MODE
  ENTITY _LibPgtoGVApp BY \_desComFin
     ALL FIELDS
    WITH CORRESPONDING #( keys )
  RESULT DATA(lt_fin).

    MODIFY ENTITIES OF zi_mm_lib_pgto_app
        IN LOCAL MODE
    ENTITY _LibPgtoGVDesFinCom
    UPDATE FIELDS ( VlrDescontoFin ObservacaoFin UsuarioFin DataFin )
      WITH VALUE #( FOR ls_fin IN lt_fin ( %tky = ls_fin-%tky
                                     usuariofin = sy-uname
                                        datafin = sy-datum ) )
    FAILED failed
    REPORTED reported.

    IF lines( failed-_libpgtogvdesfincom ) EQ 0.

      MODIFY ENTITIES OF zi_mm_lib_pgto_app
          IN LOCAL MODE
      ENTITY _LibPgtoGVApp
      UPDATE FIELDS ( Status )
        WITH VALUE #( FOR ls_key IN keys ( %tky = ls_key-%tky
                                          status = gc_status_finalizado ) )
      FAILED failed
    REPORTED reported.

    ENDIF.

  ENDMETHOD.

  METHOD get_features.

* ---------------------------------------------------------------------------
* Verifica autorização
* ---------------------------------------------------------------------------
*    me->check_permission( EXPORTING iv_actvt  = gc_authority-contabilizar_desconto
*                          IMPORTING et_return = DATA(lt_return) ).
*
*    DATA(lv_feat) = COND #( WHEN line_exists( lt_return[ type = |E| ] ) THEN abap_false ELSE abap_true ).

    me->check_all_permission( IMPORTING ev_desc_fin  = DATA(lv_desc_fin)
                                        ev_cont_des  = DATA(lv_cont_des)
                                        ev_libe_fin  = DATA(lv_libe_fin)
                                        ev_reto_com  = DATA(lv_reto_com)
                                        ev_finalizar = DATA(lv_finalizar) ).

    READ ENTITIES OF zi_mm_lib_pgto_app IN LOCAL MODE
          ENTITY _LibPgtoGVApp
            FIELDS ( Status ) WITH CORRESPONDING #( keys )
              RESULT DATA(lt_features).

    result = VALUE #(
      FOR ls_features IN lt_features (
        %tky = ls_features-%tky
        %action-descontofinanceiro = COND #( WHEN ls_features-status EQ gc_status_libComercial OR
                                                  ls_features-status EQ gc_status_revFinanceiro OR
                                                  ls_features-status EQ gc_status_libFinanceiro AND
                                                  lv_desc_fin EQ abap_true
                                              THEN if_abap_behv=>fc-o-enabled ELSE if_abap_behv=>fc-o-disabled )

        %action-retornarcomercial = COND #( WHEN ls_features-status EQ gc_status_libComercial OR
                                                  ls_features-status EQ gc_status_revFinanceiro OR
                                                  ls_features-status EQ gc_status_libFinanceiro AND
                                                  lv_reto_com EQ abap_true
                                              THEN if_abap_behv=>fc-o-enabled ELSE if_abap_behv=>fc-o-disabled )

        %action-contabilizardesconto = COND #( WHEN ls_features-status EQ gc_status_revFinanceiro OR
                                                  ls_features-status EQ gc_status_libFinanceiro AND
                                                  lv_cont_des EQ abap_true
                                              THEN if_abap_behv=>fc-o-enabled ELSE if_abap_behv=>fc-o-disabled )

        %action-liberadofinanceiro = COND #( WHEN ls_features-status EQ gc_status_libComercial OR
                                                  ls_features-status EQ gc_status_revFinanceiro OR
                                                  ls_features-status EQ gc_status_libFinanceiro AND
                                                  lv_libe_fin EQ abap_true
                                              THEN if_abap_behv=>fc-o-enabled ELSE if_abap_behv=>fc-o-disabled )

        %action-finalizado = COND #( WHEN ls_features-status EQ gc_status_libComercial OR
                                                  ls_features-status EQ gc_status_revFinanceiro OR
                                                  ls_features-status EQ gc_status_libFinanceiro AND
                                                  lv_finalizar EQ abap_true
                                              THEN if_abap_behv=>fc-o-enabled ELSE if_abap_behv=>fc-o-disabled )

        %update = COND #( WHEN ls_features-status EQ gc_status_finalizado
                            THEN if_abap_behv=>fc-o-disabled ELSE if_abap_behv=>fc-o-enabled ) ) ).

  ENDMETHOD.

  METHOD format_return.

    DATA: ls_return_format TYPE bapiret2.

* ---------------------------------------------------------------------------
* Format mensagens de retorno
* ---------------------------------------------------------------------------
    LOOP AT ct_return REFERENCE INTO DATA(ls_return).

      " ---------------------------------------------------------------------------
      " Ao processar a Action com múltiplas linhas, quando há qualquer mensagem de
      " erro ele acaba ocultando as outras mensagens de Sucesso, Informação e
      " Aviso. Esta alternativa foi encontrada para exibir todas as mensagens
      " ---------------------------------------------------------------------------


      IF  ls_return->message IS INITIAL.

        TRY.
            CALL FUNCTION 'FORMAT_MESSAGE'
              EXPORTING
                id        = ls_return->id
                lang      = sy-langu
                no        = ls_return->number
                v1        = ls_return->message_v1
                v2        = ls_return->message_v2
                v3        = ls_return->message_v3
                v4        = ls_return->message_v4
              IMPORTING
                msg       = ls_return->message
              EXCEPTIONS
                not_found = 1
                OTHERS    = 2.

            IF sy-subrc <> 0.
              CLEAR ls_return->message.
            ENDIF.

          CATCH cx_root INTO DATA(lo_root).
            DATA(lv_message) = lo_root->get_longtext( ).
        ENDTRY.

      ENDIF.

    ENDLOOP.

  ENDMETHOD.

  METHOD check_permission.

    FREE: et_return, ev_ok.

*     ---------------------------------------------------------------------------
*     Botões mapeados no objeto de autorização
*     ---------------------------------------------------------------------------
*     02 - Desconto Financeiro
*     16 - Contabilizar Descontos
*     43 - Liberar Financeiro
*     85 - Retornar Comercial
*     D9 - Finalizar
*     ---------------------------------------------------------------------------
    AUTHORITY-CHECK OBJECT 'ZLIB_PG_GV'
    ID 'ACTVT' FIELD iv_actvt.

    IF sy-subrc NE 0.
      "Sem autorização para acessar esta funcionalidade.
      et_return[] = VALUE #( BASE et_return ( type = 'E' id = 'ZMM_LIB_PGTO_GV' number = '001' ) ).
    ELSE.
      rv_ok = ev_ok = abap_true.
    ENDIF.


    me->format_return( CHANGING ct_return = et_return[] ).

  ENDMETHOD.

  METHOD check_all_permission.

*     ---------------------------------------------------------------------------
*     Botões mapeados no objeto de autorização
*     ---------------------------------------------------------------------------
*     02 - Desconto Financeiro
*     16 - Contabilizar Descontos
*     43 - Liberar Financeiro
*     85 - Retornar Comercial
*     D9 - Finalizar
*     ---------------------------------------------------------------------------
    ev_desc_fin = abap_false.
    ev_cont_des = abap_false.
    ev_libe_fin = abap_false.
    ev_reto_com = abap_false.
    ev_finalizar = abap_false.

    AUTHORITY-CHECK OBJECT 'ZLIB_PG_GV'
    ID 'ACTVT' FIELD gc_authority-desconto_financeiro.

    IF sy-subrc IS INITIAL.
      ev_desc_fin = abap_true.
    ENDIF.

    AUTHORITY-CHECK OBJECT 'ZLIB_PG_GV'
    ID 'ACTVT' FIELD gc_authority-contabilizar_desconto.

    IF sy-subrc IS INITIAL.
      ev_cont_des = abap_true.
    ENDIF.

    AUTHORITY-CHECK OBJECT 'ZLIB_PG_GV'
    ID 'ACTVT' FIELD gc_authority-liberar_financeiro.

    IF sy-subrc IS INITIAL.
      ev_libe_fin = abap_true.
    ENDIF.

    AUTHORITY-CHECK OBJECT 'ZLIB_PG_GV'
    ID 'ACTVT' FIELD gc_authority-retornar_comercial.

    IF sy-subrc IS INITIAL.
      ev_reto_com = abap_true.
    ENDIF.

    AUTHORITY-CHECK OBJECT 'ZLIB_PG_GV'
    ID 'ACTVT' FIELD gc_authority-finalizar.

    IF sy-subrc IS INITIAL.
      ev_finalizar = abap_true.
    ENDIF.

  ENDMETHOD.

  METHOD limparMarcados.

    SELECT SINGLE *
    FROM zi_mm_lib_pgto_app
    WHERE NumDocumento
    EQ @iv_numdocumento
    INTO @DATA(ls_dados).

    CHECK ls_dados IS NOT INITIAL.

    IF iv_fat EQ abap_true.
      DELETE FROM ztmm_pag_gv_fat  WHERE bukrs = @ls_dados-Empresa
                                   AND ebeln   = @ls_dados-NumDocumento
                                   AND marcado = @abap_true.
    ENDIF.

    IF iv_adi EQ abap_true.
      DELETE FROM ztmm_pag_gv_adi  WHERE bukrs = @ls_dados-Empresa
                                   AND ebeln   = @ls_dados-NumDocumento
                                   AND marcado = @abap_true.
    ENDIF.

    IF iv_dev EQ abap_true.
      DELETE FROM ztmm_pag_gv_dev  WHERE bukrs = @ls_dados-Empresa
                                   AND ebeln   = @ls_dados-NumDocumento
                                   AND marcado = @abap_true.
    ENDIF.

    IF iv_des_con EQ abap_true.
      DELETE FROM ztmm_pag_gv_des  WHERE bukrs = @ls_dados-Empresa
                                   AND ebeln   = @ls_dados-NumDocumento
                                   AND marcado = @abap_true.
    ENDIF.

  ENDMETHOD.

ENDCLASS.
