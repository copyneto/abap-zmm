
CLASS lcl_retarmazenagem DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS delete FOR MODIFY
      IMPORTING keys FOR DELETE retarmazenagem.

    METHODS update FOR MODIFY
      IMPORTING entities FOR UPDATE retarmazenagem.

    METHODS lock FOR LOCK
      IMPORTING keys FOR LOCK retarmazenagem.

    METHODS read FOR READ
      IMPORTING keys FOR READ retarmazenagem RESULT result.

    METHODS rba_serie FOR READ
      IMPORTING keys_rba FOR READ retarmazenagem\_serie FULL result_requested RESULT result LINK association_links.

    METHODS rba_mensagem FOR READ
      IMPORTING keys_rba FOR READ retarmazenagem\_mensagem FULL result_requested RESULT result LINK association_links.


    METHODS criarnfe FOR MODIFY
      IMPORTING keys FOR ACTION retarmazenagem~criarnfe.

    METHODS movervalores FOR MODIFY
      IMPORTING keys FOR ACTION retarmazenagem~movervalores.

    METHODS qtdetransferida FOR MODIFY
      IMPORTING keys FOR ACTION retarmazenagem~qtdetransferida.

    METHODS get_features FOR FEATURES
      IMPORTING keys REQUEST requested_features FOR retarmazenagem RESULT result.

    METHODS get_authorizations FOR AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR retarmazenagem RESULT result.

    METHODS fragmentcheckbox FOR MODIFY
      IMPORTING keys FOR ACTION retarmazenagem~fragmentcheckbox.
    METHODS fragmentusedstock FOR MODIFY
      IMPORTING keys FOR ACTION retarmazenagem~fragmentusedstock.
    METHODS continuarprocesso FOR MODIFY
      IMPORTING keys FOR ACTION retarmazenagem~continuar.

    METHODS validarnotarejeitada
      IMPORTING
        is_ret_armazenagem_app TYPE zi_mm_ret_armazenagem_app
      RETURNING
        VALUE(rv_retorno)      TYPE abap_bool.

    METHODS criaremesimb FOR MODIFY
      IMPORTING keys FOR ACTION retarmazenagem~criaremesimb.

    METHODS criaremessa FOR MODIFY
      IMPORTING keys FOR ACTION retarmazenagem~criaremessa.

    METHODS criaorderfrete FOR MODIFY
      IMPORTING keys FOR ACTION retarmazenagem~criaorderfrete.

    METHODS adicionarserie FOR MODIFY
      IMPORTING keys FOR ACTION RetArmazenagem~adicionarSerie.

ENDCLASS.


CLASS lcl_retarmazenagem IMPLEMENTATION.

  METHOD delete.

    DATA(lo_aux) = NEW  zclmm_aux_ret_armazenagem(  ).
    DATA lt_entity  TYPE zclmm_aux_ret_armazenagem=>ty_t_entity.

    DATA: lv_update TYPE if_abap_behv=>t_xflag,
          lv_delete TYPE if_abap_behv=>t_xflag.

* ---------------------------------------------------------------------------
* Recupera dados das linhas selecionadas
* ---------------------------------------------------------------------------
    READ ENTITIES OF zi_mm_ret_armazenagem_app
         IN LOCAL MODE ENTITY retarmazenagem
         ALL FIELDS WITH CORRESPONDING #( keys )
         RESULT DATA(lt_retarmazenagem) FAILED failed.

* ---------------------------------------------------------------------------
* Apagar os Dados
* ---------------------------------------------------------------------------
    lo_aux->apagar_historico(
      EXPORTING
        it_entity = CORRESPONDING #( lt_retarmazenagem )
        IMPORTING
        et_return = DATA(lt_return)
    ).
* ---------------------------------------------------------------------------
* Retornar mensagens
* ---------------------------------------------------------------------------
    lo_aux->build_reported( EXPORTING it_return   = lt_return
                            IMPORTING es_reported = DATA(lt_reported) ).

    reported = CORRESPONDING #( DEEP lt_reported ).


  ENDMETHOD.

  METHOD update.
* ---------------------------------------------------------------------------
* Recupera dados das linhas selecionadas
* ---------------------------------------------------------------------------
    READ ENTITIES OF zi_mm_ret_armazenagem_app
           IN LOCAL MODE ENTITY retarmazenagem
           ALL FIELDS WITH CORRESPONDING #( entities )
           RESULT DATA(lt_retarmazenagem) FAILED failed.
    DATA(ls_entities) = entities[ 1 ].

* ---------------------------------------------------------------------------
* Transafere os dados modificados
* ---------------------------------------------------------------------------
    LOOP AT lt_retarmazenagem REFERENCE INTO DATA(ls_emissao).

      " Quando houver alteração manual, ignorar Checkbox
      ls_emissao->useavailable        = COND #( WHEN ls_entities-%control-utilizacaolivre NE if_abap_behv=>fc-o-enabled
                                        THEN abap_false
                                        WHEN ls_entities-%control-useavailable EQ if_abap_behv=>fc-o-enabled
                                        THEN ls_emissao->useavailable
                                        ELSE ls_entities-useavailable ).

      ls_emissao->utilizacaolivre           = COND #( WHEN ls_entities-%control-utilizacaolivre EQ if_abap_behv=>fc-o-enabled
                                        THEN ls_emissao->utilizacaolivre
                                        ELSE ls_entities-utilizacaolivre ).
      ls_emissao->transportador             = COND #( WHEN ls_entities-%control-transportador EQ if_abap_behv=>fc-o-enabled
                                        THEN ls_emissao->transportador
                                        ELSE ls_entities-transportador ).
      ls_emissao->driver              = COND #( WHEN ls_entities-%control-driver EQ if_abap_behv=>fc-o-enabled
                                        THEN ls_emissao->driver
                                        ELSE ls_entities-driver ).
      ls_emissao->equipment           = COND #( WHEN ls_entities-%control-equipment EQ if_abap_behv=>fc-o-enabled
                                        THEN ls_emissao->equipment
                                        ELSE ls_entities-equipment ).
      ls_emissao->shipping_conditions  = COND #( WHEN ls_entities-%control-shipping_conditions EQ if_abap_behv=>fc-o-enabled
                                        THEN ls_emissao->shipping_conditions
                                        ELSE ls_entities-shipping_conditions ).
      ls_emissao->shipping_type        = COND #( WHEN ls_entities-%control-shipping_type EQ if_abap_behv=>fc-o-enabled
                                        THEN ls_emissao->shipping_type
                                        ELSE ls_entities-shipping_type ).
      ls_emissao->equipment_tow1       = COND #( WHEN ls_entities-%control-equipment_tow1 EQ if_abap_behv=>fc-o-enabled
                                        THEN ls_emissao->equipment_tow1
                                        ELSE ls_entities-equipment_tow1 ).
      ls_emissao->equipment_tow2       = COND #( WHEN ls_entities-%control-equipment_tow2 EQ if_abap_behv=>fc-o-enabled
                                        THEN ls_emissao->equipment_tow2
                                        ELSE ls_entities-equipment_tow2 ).
      ls_emissao->equipment_tow3       = COND #( WHEN ls_entities-%control-equipment_tow3 EQ if_abap_behv=>fc-o-enabled
                                        THEN ls_emissao->equipment_tow3
                                        ELSE ls_entities-equipment_tow3 ).
      ls_emissao->freight_mode         = COND #( WHEN ls_entities-%control-freight_mode EQ if_abap_behv=>fc-o-enabled
                                        THEN ls_emissao->freight_mode
                                        ELSE ls_entities-freight_mode ).
      ls_emissao->lote               = COND #( WHEN ls_entities-%control-lote EQ if_abap_behv=>fc-o-enabled
                                        THEN ls_emissao->lote
                                        ELSE ls_entities-lote ).

    ENDLOOP.

    DATA lt_dados_remessa TYPE zclmm_adm_emissao_nf_events=>ty_t_emissao_cds .
    lt_dados_remessa = CORRESPONDING #( lt_retarmazenagem
      MAPPING
*        outbounddelivery = outbounddelivery
        carrier = transportador
*        driver =  driver
        shippingtype = shipping_type
        freightmode  = freight_mode
        equipment = equipment
        shippingconditions = shipping_conditions
    ).
    DATA(lt_return) = NEW zclmm_atualiza_remessa( )->executar( lt_dados_remessa ).

* ---------------------------------------------------------------------------
* Salva os dados de emissão
* ---------------------------------------------------------------------------
    DATA(lo_aux) = NEW  zclmm_aux_ret_armazenagem(  ).
    DATA(lo_events) = NEW zclmm_adm_emissao_nf_events( ).
    IF NOT line_exists( lt_return[ type = 'E' ] ).

      IF NOT line_exists( lt_dados_remessa[ outbounddelivery = '' ] ).
        SELECT *                              "#EC CI_ALL_FIELDS_NEEDED
          FROM zi_mm_ret_armazenagem_app
          FOR ALL ENTRIES IN @lt_dados_remessa
          WHERE outbounddelivery = @lt_dados_remessa-outbounddelivery
          INTO TABLE @DATA(lt_ret_armazenagem). "#EC CI_SEL_DEL #EC CI_ALL_FIELDS_NEEDED #EC CI_FAE_LINES_ENSURED
        LOOP AT lt_ret_armazenagem ASSIGNING FIELD-SYMBOL(<fs_ret_armazenagem>).
          <fs_ret_armazenagem>-Transportador      = ls_emissao->Transportador.
          <fs_ret_armazenagem>-driver             = ls_emissao->driver.
          <fs_ret_armazenagem>-equipment          = ls_emissao->equipment.
          <fs_ret_armazenagem>-shipping_conditions = ls_emissao->shipping_conditions.
          <fs_ret_armazenagem>-shipping_type       = ls_emissao->shipping_type.
          <fs_ret_armazenagem>-equipment_tow1      = ls_emissao->equipment_tow1.
          <fs_ret_armazenagem>-equipment_tow2      = ls_emissao->equipment_tow2.
          <fs_ret_armazenagem>-equipment_tow3      = ls_emissao->equipment_tow3.
          <fs_ret_armazenagem>-freight_mode        = ls_emissao->freight_mode.
        ENDLOOP.
      ENDIF.
* ---------------------------------------------------------------------------
* Salva os dados de emissão
* ---------------------------------------------------------------------------
      lo_aux->salvar_historico(
        EXPORTING
          it_entity = lt_ret_armazenagem
        IMPORTING
          et_return = DATA(lt_return2) ).
    ELSE.
      NEW zclmm_adm_emissao_nf_events( )->format_return( CHANGING ct_return = lt_return ).
    ENDIF.
* ---------------------------------------------------------------------------
* Retornar mensagens
* ---------------------------------------------------------------------------
    lo_aux->build_reported(
      EXPORTING
        it_return   = lt_return
      IMPORTING
        es_reported = DATA(lt_reported)
    ).
    reported = CORRESPONDING #( DEEP lt_reported ).
  ENDMETHOD.

  METHOD lock.
    RETURN.
  ENDMETHOD.

  METHOD read.

* ---------------------------------------------------------------------------
* Recupera os dados de Emissão
* ---------------------------------------------------------------------------
    IF keys[] IS NOT INITIAL.

      SELECT *
        FROM zi_mm_ret_armazenagem_app
        FOR ALL ENTRIES IN @keys
        WHERE guid = @keys-guid
          AND numeroordemdefrete = @keys-numeroordemdefrete
          AND numerodaremessa    = @keys-numerodaremessa
          AND material           = @keys-material
          AND umborigin          = @keys-umborigin
          AND umbdestino         = @keys-umbdestino
          AND centroorigem       = @keys-centroorigem
          AND depositoorigem     = @keys-depositoorigem
          AND centrodestino      = @keys-centrodestino
          AND depositodestino    = @keys-depositodestino
          AND lote               = @keys-lote
          AND eantype            = @keys-eantype
          AND dadosdohistorico   = @keys-dadosdohistorico
        INTO CORRESPONDING FIELDS OF TABLE @result.     "#EC CI_SEL_DEL

      IF sy-subrc NE 0.
        FREE result.
      ENDIF.
    ENDIF.
  ENDMETHOD.

  METHOD criarnfe.

    DATA: lt_entity TYPE zclmm_aux_ret_armazenagem=>ty_t_entity.


    SELECT SINGLE low
    FROM ztca_param_val
    WHERE modulo = 'MM'
    AND chave1 = 'LIMITADOR_ITENS'
    AND chave2 = 'QTDE_ITENS_NF'
    AND chave3 IS INITIAL
    INTO @DATA(lv_limitador_itens).


    lt_entity[] = VALUE #( FOR ls_keys IN keys ( numeroordemdefrete     = ls_keys-numeroordemdefrete
                                                 numerodaremessa        = ls_keys-numerodaremessa
                                                 material               = ls_keys-material
                                                 umborigin              = ls_keys-umborigin
                                                 umbdestino             = ls_keys-umbdestino
                                                 centroorigem           = ls_keys-centroorigem
                                                 depositoorigem         = ls_keys-depositoorigem
                                                 centrodestino          = ls_keys-centrodestino
                                                 depositodestino        = ls_keys-depositodestino
                                                 lote                   = ls_keys-lote
                                                 eantype                = ls_keys-eantype
                                                 dadosdohistorico       = ls_keys-dadosdohistorico
                                                 transportador          = ls_keys-%param-transportador
                                                 driver                 = ls_keys-%param-driver
                                                 equipment              = ls_keys-%param-equipment
                                                 shipping_conditions    = ls_keys-%param-shipping_conditions
                                                 shipping_type          = ls_keys-%param-shipping_type
                                                 equipment_tow1         = ls_keys-%param-equipment_tow1
                                                 equipment_tow2         = ls_keys-%param-equipment_tow2
                                                 equipment_tow3         = ls_keys-%param-equipment_tow3
                                                 freight_mode           = ls_keys-%param-freight_mode ) ).



    IF lv_limitador_itens IS NOT INITIAL.
      IF lines( keys ) > lv_limitador_itens.
        DATA(lt_return) = VALUE bapiret2_t( ( type = 'E' id = 'ZMM_DEPOSITO_FECHADO' number = '041' message_v1 = lv_limitador_itens ) ).

        DATA(lo_armazenagem) = NEW zclmm_aux_ret_armazenagem( ).

        lo_armazenagem->build_reported( EXPORTING it_return   = lt_return
                                        IMPORTING es_reported = DATA(lt_reported) ).

        reported = CORRESPONDING #( DEEP lt_reported ).

        RETURN.
      ENDIF.
    ENDIF.



* ---------------------------------------------------------------------------
* Criar NFe
* ---------------------------------------------------------------------------
    DATA(lo_events) = NEW zclmm_adm_emissao_nf_events( ).

    lo_events->create_documents_f05( EXPORTING it_armazenagem_cds = lt_entity
                                     IMPORTING et_return       = lt_return ).

* ---------------------------------------------------------------------------
* Retornar mensagens
* ---------------------------------------------------------------------------
    lo_armazenagem = NEW zclmm_aux_ret_armazenagem( ).

    lo_armazenagem->build_reported( EXPORTING it_return   = lt_return
                                    IMPORTING es_reported = lt_reported ).

    reported = CORRESPONDING #( DEEP lt_reported ).

  ENDMETHOD.

  METHOD movervalores.

    fragmentcheckbox(
      EXPORTING
        keys     = VALUE #( FOR ls_key IN keys ( VALUE #( BASE CORRESPONDING #( ls_key )  %param-useavailablecheckbox = abap_true ) ) )
      CHANGING
        mapped   = mapped
        failed   = failed
        reported = reported
    ).


*    DATA(lo_aux) = NEW  zclmm_aux_ret_armazenagem(  ).
*    DATA lt_entity  TYPE zclmm_aux_ret_armazenagem=>ty_t_entity.
** ---------------------------------------------------------------------------
** Recupera dados das linhas selecionadas
** ---------------------------------------------------------------------------
*    READ ENTITIES OF zi_mm_ret_armazenagem_app
*         IN LOCAL MODE ENTITY retarmazenagem
*         ALL FIELDS WITH CORRESPONDING #( keys )
*         RESULT DATA(lt_retarmazenagem) FAILED failed.
*
*    lo_aux->mover_quantidade(
*      EXPORTING
*        it_entity = CORRESPONDING #( lt_retarmazenagem )
*        iv_useavailablecheckbox = abap_true
*      IMPORTING
*        et_return = DATA(lt_return)
*        et_entity = lt_entity
*    ).
** ---------------------------------------------------------------------------
** Salva os dados de emissão
** ---------------------------------------------------------------------------
*    lo_aux->salvar_historico(
*      EXPORTING
*        it_entity = lt_entity
*        IMPORTING
*        et_return = DATA(lt_return2)
*    ).
*
*    APPEND LINES OF lt_return2 TO lt_return.
** ---------------------------------------------------------------------------
** Retornar mensagens
** ---------------------------------------------------------------------------
*    lo_aux->build_reported( EXPORTING it_return   = lt_return
*                               IMPORTING es_reported = DATA(lt_reported) ).
*
*    reported = CORRESPONDING #( DEEP lt_reported ).


  ENDMETHOD.

  METHOD qtdetransferida.

    fragmentusedstock(
      EXPORTING
        keys     = CORRESPONDING #( keys MAPPING %param = %param )
      CHANGING
        mapped   = mapped
        failed   = failed
        reported = reported
    ).

*    DATA(lo_aux) = NEW  zclmm_aux_ret_armazenagem(  ).
*    DATA lt_entity  TYPE zclmm_aux_ret_armazenagem=>ty_t_entity.
*
** ---------------------------------------------------------------------------
** Recupera dados das linhas selecionadas
** ---------------------------------------------------------------------------
*    READ ENTITIES OF zi_mm_ret_armazenagem_app
*         IN LOCAL MODE ENTITY retarmazenagem
*         ALL FIELDS WITH CORRESPONDING #( keys )
*         RESULT DATA(lt_retarmazenagem) FAILED failed.
*
** ---------------------------------------------------------------------------
** Atualiza dados com o valor informado no Abstract
** ---------------------------------------------------------------------------
*    TRY.
*        DATA(ls_popup) = keys[ 1 ]-%param.
*      CATCH cx_root.
*    ENDTRY.
*
** ---------------------------------------------------------------------------
** Atualiza dados com o valor informado no Abstract
** ---------------------------------------------------------------------------
*    lo_aux->mover_quantidade(
*      EXPORTING
*        it_entity = CORRESPONDING #( lt_retarmazenagem )
*        iv_useavailablecheckbox = abap_true
*        is_popup  = ls_popup
*      IMPORTING
*        et_return = DATA(lt_return)
*        et_entity = lt_entity ).
*
** ---------------------------------------------------------------------------
** Salva os dados de emissão
** ---------------------------------------------------------------------------
*    lo_aux->salvar_historico(
*      EXPORTING
*        it_entity = lt_entity
*        IMPORTING
*        et_return = DATA(lt_return2) ).
*
*    APPEND LINES OF lt_return2 TO lt_return.
*
** ---------------------------------------------------------------------------
** Retornar mensagens
** ---------------------------------------------------------------------------
*    lo_aux->build_reported( EXPORTING it_return   = lt_return
*                            IMPORTING es_reported = DATA(lt_reported) ).
*
*    reported = CORRESPONDING #( DEEP lt_reported ).

  ENDMETHOD.

  METHOD get_features.


* ---------------------------------------------------------------------------
* Recupera dados das linhas selecionadas
* ---------------------------------------------------------------------------
    READ ENTITIES OF zi_mm_ret_armazenagem_app
         IN LOCAL MODE ENTITY retarmazenagem
         ALL FIELDS WITH CORRESPONDING #( keys )
         RESULT DATA(lt_ret) FAILED failed.


* ---------------------------------------------------------------------------
* Atualiza permissões de cada linha
* ---------------------------------------------------------------------------

    result = VALUE #( FOR ls_ordem IN lt_ret

                    ( %tky                              = ls_ordem-%tky

                      %update                           = COND #( WHEN ls_ordem-statushistorico EQ zclmm_aux_pend_ordem_de_frete=>gc_status-inicial
                                                                    OR ls_ordem-statushistorico EQ zclmm_aux_pend_ordem_de_frete=>gc_status-em_processamento
                                                                    OR ls_ordem-statushistorico EQ zclmm_aux_pend_ordem_de_frete=>gc_status-ordem_frete_job
                                                                    OR ls_ordem-statushistorico EQ zclmm_aux_pend_ordem_de_frete=>gc_status-ordem_frete
                                                                    OR ls_ordem-statushistorico EQ zclmm_aux_pend_ordem_de_frete=>gc_status-saida_nota
                                                          THEN if_abap_behv=>fc-o-enabled
                                                          ELSE if_abap_behv=>fc-o-disabled )

*                      %delete                           = COND #( WHEN ls_ordem-statushistorico EQ zclmm_aux_pend_ordem_de_frete=>gc_status-em_processamento
*                                                          THEN if_abap_behv=>fc-o-enabled
*                                                          ELSE if_abap_behv=>fc-o-disabled )

                      %delete                           = COND #( WHEN ls_ordem-status EQ zclmm_adm_emissao_nf_events=>gc_status-em_processamento
                                                                    OR ( ls_ordem-status EQ zclmm_adm_emissao_nf_events=>gc_status-nota_rejeita AND validarnotarejeitada( CORRESPONDING #( ls_ordem ) ) )
                                                          THEN if_abap_behv=>fc-o-enabled
                                                          ELSE if_abap_behv=>fc-o-disabled )

                      %action-criarnfe                  = COND #( WHEN ls_ordem-statushistorico EQ zclmm_aux_pend_ordem_de_frete=>gc_status-em_processamento
                                                                    OR ls_ordem-statushistorico EQ zclmm_aux_pend_ordem_de_frete=>gc_status-incompleto
                                                          THEN if_abap_behv=>fc-o-enabled
                                                          ELSE if_abap_behv=>fc-o-disabled )

                      %action-movervalores             = COND #( WHEN ls_ordem-statushistorico EQ zclmm_aux_pend_ordem_de_frete=>gc_status-inicial
                                                                   OR ls_ordem-statushistorico EQ zclmm_aux_pend_ordem_de_frete=>gc_status-em_processamento
                                                          THEN if_abap_behv=>fc-o-enabled
                                                          ELSE if_abap_behv=>fc-o-disabled )

                      %action-qtdetransferida          = COND #( WHEN ls_ordem-statushistorico EQ zclmm_aux_pend_ordem_de_frete=>gc_status-inicial
                                                                   OR ls_ordem-statushistorico EQ zclmm_aux_pend_ordem_de_frete=>gc_status-em_processamento
                                                          THEN if_abap_behv=>fc-o-enabled
                                                          ELSE if_abap_behv=>fc-o-disabled )

                      %action-continuar              = COND #( WHEN ( ls_ordem-status EQ zclmm_adm_emissao_nf_events=>gc_status-incompleto OR
                                                                      ls_ordem-status EQ zclmm_adm_emissao_nf_events=>gc_status-nota_rejeita )
                                                          THEN if_abap_behv=>fc-o-enabled
                                                          ELSE if_abap_behv=>fc-o-disabled )

                      %action-criaremessa               = COND #( WHEN ls_ordem-status EQ zclmm_adm_emissao_nf_events=>gc_status-em_processamento
                                                                    OR ls_ordem-status EQ zclmm_adm_emissao_nf_events=>gc_status-incompleto
                                                          THEN if_abap_behv=>fc-o-enabled
                                                          ELSE if_abap_behv=>fc-o-disabled )

                      %action-criaremesimb              = COND #( WHEN ls_ordem-status EQ zclmm_adm_emissao_nf_events=>gc_status-em_processamento
                                                                    OR ls_ordem-status EQ zclmm_adm_emissao_nf_events=>gc_status-incompleto
                                                          THEN if_abap_behv=>fc-o-enabled
                                                          ELSE if_abap_behv=>fc-o-disabled )

                      %action-criaorderfrete            = COND #( WHEN ls_ordem-status EQ zclmm_adm_emissao_nf_events=>gc_status-ordem_frete
                                                          THEN if_abap_behv=>fc-o-enabled
                                                          ELSE if_abap_behv=>fc-o-disabled )

                    ) ).
  ENDMETHOD.

  METHOD validarnotarejeitada.

    SELECT COUNT(*) FROM ekpo WHERE ebeln = @is_ret_armazenagem_app-purchaseorder AND loekz <> ''.
    IF sy-subrc = 0.
      SELECT COUNT(*) FROM j_1bnfdoc WHERE docnum = @is_ret_armazenagem_app-outbr_notafiscal AND cancel <> ''.
      IF sy-subrc = 0.
        rv_retorno =  abap_true.
        RETURN.
      ENDIF.
    ENDIF.
  ENDMETHOD.

  METHOD rba_serie.
    RETURN.
  ENDMETHOD.


  METHOD get_authorizations.

    READ ENTITIES OF zi_mm_ret_armazenagem_app IN LOCAL MODE
        ENTITY retarmazenagem
        ALL FIELDS WITH CORRESPONDING #( keys )
        RESULT DATA(lt_data)
        FAILED failed.

    CHECK lt_data IS NOT INITIAL.

    DATA: lv_update TYPE if_abap_behv=>t_xflag,
          lv_delete TYPE if_abap_behv=>t_xflag.

    LOOP AT lt_data ASSIGNING FIELD-SYMBOL(<fs_data>).

      IF requested_authorizations-%update EQ if_abap_behv=>mk-on.

        IF zclmm_auth_zmmwerks=>werks_update( <fs_data>-centroorigem ).
          lv_update = if_abap_behv=>auth-allowed.
        ELSE.
          lv_update = if_abap_behv=>auth-unauthorized.
        ENDIF.

      ENDIF.


      IF requested_authorizations-%update EQ if_abap_behv=>mk-on.

        IF zclmm_auth_zmmwerks=>werks_update( <fs_data>-centroorigem ).
          lv_update = if_abap_behv=>auth-allowed.
        ELSE.
          lv_update = if_abap_behv=>auth-unauthorized.
        ENDIF.

      ENDIF.

      APPEND VALUE #( %tky = <fs_data>-%tky %update = lv_update ) TO result.

    ENDLOOP.

  ENDMETHOD.

  METHOD fragmentcheckbox.
    CONSTANTS lc_em_processamento TYPE ze_mm_df_status VALUE '01'.
    DATA lt_return TYPE bapiret2_t.
    DATA(lo_aux) = NEW  zclmm_aux_ret_armazenagem(  ).
    DATA lt_entity  TYPE zclmm_aux_ret_armazenagem=>ty_t_entity.
* ---------------------------------------------------------------------------
* Recupera dados das linhas selecionadas
* ---------------------------------------------------------------------------
*    READ ENTITIES OF zi_mm_ret_armazenagem_app
*         IN LOCAL MODE ENTITY retarmazenagem
*         ALL FIELDS WITH CORRESPONDING #( keys )
*         RESULT DATA(lt_retarmazenagem) FAILED failed.
*
*    DATA(useavailablecheckbox) = VALUE abap_bool( keys[ 1 ]-%param-useavailablecheckbox  OPTIONAL ).
*
*    lo_aux->mover_quantidade(
*      EXPORTING
*        it_entity = CORRESPONDING #( lt_retarmazenagem )
*        iv_useavailablecheckbox = useavailablecheckbox
*      IMPORTING
*        et_return = DATA(lt_return)
*        et_entity = lt_entity
*    ).
    lt_entity = VALUE #( FOR ls_keys IN keys (
      numeroordemdefrete      = ls_keys-numeroordemdefrete
      numerodaremessa         = ls_keys-numerodaremessa
      material                = ls_keys-material
      umborigin               = ls_keys-umborigin
      umbdestino              = ls_keys-umbdestino
      centroorigem            = ls_keys-centroorigem
      depositoorigem          = ls_keys-depositoorigem
      centrodestino           = ls_keys-centrodestino
      depositodestino         = ls_keys-depositodestino
      lote                    = ls_keys-lote
      eantype                 = ls_keys-eantype
      dadosdohistorico        = ls_keys-dadosdohistorico
      useavailable            = ls_keys-%param-useavailablecheckbox
*      QtdTransportada         =
    ) ).

    IF lt_entity IS NOT INITIAL.
      SELECT DISTINCT *
        FROM zi_mm_ret_armazenagem_app
        FOR ALL ENTRIES IN @lt_entity
        WHERE material           = @lt_entity-material
          AND umborigin          = @lt_entity-umborigin
          AND umbdestino         = @lt_entity-umbdestino
          AND centroorigem       = @lt_entity-centroorigem
          AND depositoorigem     = @lt_entity-depositoorigem
          AND centrodestino      = @lt_entity-centrodestino
          AND depositodestino    = @lt_entity-depositodestino
          AND lote               = @lt_entity-lote
          AND eantype            = @lt_entity-eantype
          AND dadosdohistorico   = @lt_entity-dadosdohistorico
        INTO TABLE @DATA(lt_ret_armazenagem_app).       "#EC CI_SEL_DEL
    ENDIF.

    LOOP AT lt_entity ASSIGNING FIELD-SYMBOL(<fs_entity>).
      READ TABLE lt_ret_armazenagem_app INTO DATA(ls_ret_armazenagem_app)
        WITH KEY numeroordemdefrete  = <fs_entity>-numeroordemdefrete
                  numerodaremessa     = <fs_entity>-numerodaremessa
                  material             = <fs_entity>-material
                  umborigin            = <fs_entity>-umborigin
                  umbdestino           = <fs_entity>-umbdestino
                  centroorigem         = <fs_entity>-centroorigem
                  depositoorigem       = <fs_entity>-depositoorigem
                  centrodestino        = <fs_entity>-centrodestino
                  depositodestino      = <fs_entity>-depositodestino
                  lote                 = <fs_entity>-lote
                  eantype              = <fs_entity>-eantype
                  dadosdohistorico     = <fs_entity>-dadosdohistorico  .
      IF sy-subrc NE 0.
        CONTINUE.
      ENDIF.

      <fs_entity>-qtdtransportada = COND #(
        WHEN <fs_entity>-useavailable = abap_true
        THEN ls_ret_armazenagem_app-utilizacaolivre
        ELSE ls_ret_armazenagem_app-qtdtransportada
      ).
      <fs_entity>-status = lc_em_processamento.
      <fs_entity>-statushistorico = lc_em_processamento.
    ENDLOOP.

* ---------------------------------------------------------------------------
* Salva os dados de emissão
* ---------------------------------------------------------------------------
    lo_aux->salvar_historico(
      EXPORTING
        it_entity = lt_entity
        IMPORTING
        et_return = DATA(lt_return2)
    ).

    APPEND LINES OF lt_return2 TO lt_return.
* ---------------------------------------------------------------------------
* Retornar mensagens
* ---------------------------------------------------------------------------
    lo_aux->build_reported( EXPORTING it_return   = lt_return
                               IMPORTING es_reported = DATA(lt_reported) ).

    reported = CORRESPONDING #( DEEP lt_reported ).

  ENDMETHOD.

  METHOD fragmentusedstock.

    CONSTANTS lc_em_processamento TYPE ze_mm_df_status VALUE '01'.
    DATA lt_entity  TYPE zclmm_aux_ret_armazenagem=>ty_t_entity.
* ---------------------------------------------------------------------------
* Recupera a chave e os novos dados informados
* ---------------------------------------------------------------------------
    lt_entity = VALUE #( FOR ls_keys IN keys (
      numeroordemdefrete      = ls_keys-numeroordemdefrete
      numerodaremessa         = ls_keys-numerodaremessa
      material                = ls_keys-material
      umborigin               = ls_keys-umborigin
      umbdestino              = ls_keys-umbdestino
      centroorigem            = ls_keys-centroorigem
      depositoorigem          = ls_keys-depositoorigem
      centrodestino           = ls_keys-centrodestino
      depositodestino         = ls_keys-depositodestino
      guid                    = ls_keys-guid
      lote                    = ls_keys-lote
      eantype                 = ls_keys-eantype
      dadosdohistorico        = ls_keys-dadosdohistorico
      qtdtransportada         = ls_keys-%param-newusedstock
      status = lc_em_processamento
      statushistorico = lc_em_processamento
    ) ).


*    IF lt_entity IS NOT INITIAL.
*      SELECT DISTINCT *
*        FROM zi_mm_ret_armazenagem_app
*        FOR ALL ENTRIES IN @lt_entity
*        WHERE numeroordemdefrete = @lt_entity-numeroordemdefrete
*          AND numerodaremessa    = @lt_entity-numerodaremessa
*          AND material           = @lt_entity-material
*          AND umborigin          = @lt_entity-umborigin
*          AND umbdestino         = @lt_entity-umbdestino
*          AND centroorigem       = @lt_entity-centroorigem
*          AND depositoorigem     = @lt_entity-depositoorigem
*          AND centrodestino      = @lt_entity-centrodestino
*          AND depositodestino    = @lt_entity-depositodestino
*          AND lote               = @lt_entity-lote
*          AND eantype            = @lt_entity-eantype
*          AND dadosdohistorico   = @lt_entity-dadosdohistorico
*        INTO TABLE @DATA(lt_ret_armazenagem_app).       "#EC CI_SEL_DEL
*    ENDIF.
*
*    LOOP AT lt_entity ASSIGNING FIELD-SYMBOL(<fs_entity>).
*      READ TABLE lt_ret_armazenagem_app INTO DATA(ls_ret_armazenagem_app)
*        WITH KEY numeroordemdefrete  = <fs_entity>-numeroordemdefrete
*                  numerodaremessa     = <fs_entity>-numerodaremessa
*                  material             = <fs_entity>-material
*                  umborigin            = <fs_entity>-umborigin
*                  umbdestino           = <fs_entity>-umbdestino
*                  centroorigem         = <fs_entity>-centroorigem
*                  depositoorigem       = <fs_entity>-depositoorigem
*                  centrodestino        = <fs_entity>-centrodestino
*                  depositodestino      = <fs_entity>-depositodestino
*                  lote                 = <fs_entity>-lote
*                  eantype              = <fs_entity>-eantype
*                  dadosdohistorico     = <fs_entity>-dadosdohistorico  .
*      IF sy-subrc NE 0.
*        CONTINUE.
*      ENDIF.
*      <fs_entity>-qtdtransportada = ls_ret_armazenagem_app-estoquelivreutilizacao.
*      <fs_entity>-Status = lc_em_processamento.
*    ENDLOOP.


    DATA(lo_aux) = NEW  zclmm_aux_ret_armazenagem(  ).
*    DATA lt_entity  TYPE zclmm_aux_ret_armazenagem=>ty_t_entity.

* ---------------------------------------------------------------------------
* Recupera dados das linhas selecionadas
* ---------------------------------------------------------------------------
*    READ ENTITIES OF zi_mm_ret_armazenagem_app
*         IN LOCAL MODE ENTITY retarmazenagem
*         ALL FIELDS WITH CORRESPONDING #( keys )
*         RESULT DATA(lt_retarmazenagem) FAILED failed.
*
** ---------------------------------------------------------------------------
** Atualiza dados com o valor informado no Abstract
** ---------------------------------------------------------------------------
*    TRY.
*        DATA(ls_popup) = keys[ 1 ]-%param.
*      CATCH cx_root.
*    ENDTRY.

* ---------------------------------------------------------------------------
* Atualiza dados com o valor informado no Abstract
* ---------------------------------------------------------------------------
*    lo_aux->mover_quantidade(
*      EXPORTING
*        it_entity = CORRESPONDING #( lt_retarmazenagem )
*        iv_useavailablecheckbox = abap_false
*        is_popup  = ls_popup
*      IMPORTING
*        et_return = DATA(lt_return)
*        et_entity = lt_entity ).

* ---------------------------------------------------------------------------
* Salva os dados de emissão
* ---------------------------------------------------------------------------
    DATA   lt_return TYPE bapiret2_t.
    lo_aux->salvar_historico(
      EXPORTING
        it_entity = lt_entity
        IMPORTING
        et_return = DATA(lt_return2) ).

    APPEND LINES OF lt_return2 TO lt_return.

* ---------------------------------------------------------------------------
* Retornar mensagens
* ---------------------------------------------------------------------------
    lo_aux->build_reported( EXPORTING it_return   = lt_return
                            IMPORTING es_reported = DATA(lt_reported) ).

    reported = CORRESPONDING #( DEEP lt_reported ).

  ENDMETHOD.

  METHOD continuarprocesso.
    DATA: lt_ret_armazenagem TYPE zclmm_aux_ret_armazenagem=>ty_t_entity.
*    DATA: lt_emissao_cds TYPE STANDARD TABLE OF zi_mm_administrar_emissao_nf.

    lt_ret_armazenagem = VALUE #( FOR ls_keys IN keys (
       material               = ls_keys-material
       umborigin              = ls_keys-umborigin
       umbdestino             = ls_keys-umbdestino
       centroorigem           = ls_keys-centroorigem
       depositoorigem         = ls_keys-depositoorigem
       centrodestino          = ls_keys-centrodestino
       depositodestino        = ls_keys-depositodestino
       lote                   = ls_keys-lote
       eantype                = ls_keys-eantype
       dadosdohistorico       = ls_keys-dadosdohistorico
       guid                   = ls_keys-guid
    ) ).


    DATA(lo_events) = NEW zclmm_adm_emissao_nf_events( ).
    lo_events->retry_process(
      EXPORTING
        it_emissao_cds = CORRESPONDING #( lt_ret_armazenagem )
      IMPORTING
        et_return  = DATA(lt_return) ).
*
** ---------------------------------------------------------------------------
** Retornar mensagens
** ---------------------------------------------------------------------------
    DATA(lo_aux) = NEW  zclmm_aux_ret_armazenagem(  ).

    lo_aux->build_reported( EXPORTING it_return   = lt_return
                               IMPORTING es_reported = DATA(lt_reported) ).

    reported = CORRESPONDING #( DEEP lt_reported ).

  ENDMETHOD.

  METHOD criaremesimb.

    SELECT SINGLE low
    FROM ztca_param_val
    WHERE modulo = 'MM'
    AND chave1 = 'LIMITADOR_ITENS'
    AND chave2 = 'QTDE_ITENS_NF'
    AND chave3 IS INITIAL
    INTO @DATA(lv_limitador_itens).

    DATA: lt_entity TYPE zclmm_aux_ret_armazenagem=>ty_t_entity.
    lt_entity[] = VALUE #( FOR ls_keys IN keys (
     guid                   = ls_keys-guid
     numeroordemdefrete     = ls_keys-numeroordemdefrete
     numerodaremessa        = ls_keys-numerodaremessa
     material               = ls_keys-material
     umborigin              = ls_keys-umborigin
     umbdestino             = ls_keys-umbdestino
     centroorigem           = ls_keys-centroorigem
     depositoorigem         = ls_keys-depositoorigem
     centrodestino          = ls_keys-centrodestino
     depositodestino        = ls_keys-depositodestino
     lote                   = ls_keys-lote
     eantype                = ls_keys-eantype
     dadosdohistorico       = ls_keys-dadosdohistorico
   ) ).

    IF lv_limitador_itens IS NOT INITIAL.
      IF lines( keys ) > lv_limitador_itens.
        DATA(lt_return) = VALUE bapiret2_t( ( type = 'E' id = 'ZMM_DEPOSITO_FECHADO' number = '041' message_v1 = lv_limitador_itens ) ).

        DATA(lo_armazenagem) = NEW zclmm_aux_ret_armazenagem( ).

        lo_armazenagem->build_reported( EXPORTING it_return   = lt_return
                                        IMPORTING es_reported = DATA(lt_reported) ).

        reported = CORRESPONDING #( DEEP lt_reported ).

        RETURN.
      ENDIF.
    ENDIF.

* ---------------------------------------------------------------------------
* Criar NFe
* ---------------------------------------------------------------------------
    DATA(lo_events) = NEW zclmm_adm_emissao_nf_events( ).

    lo_events->create_documents_f05( EXPORTING it_armazenagem_cds = lt_entity
                                     IMPORTING et_return       = lt_return ).

* ---------------------------------------------------------------------------
* Retornar mensagens
* ---------------------------------------------------------------------------
    lo_armazenagem = NEW zclmm_aux_ret_armazenagem( ).

    lo_armazenagem->build_reported( EXPORTING it_return   = lt_return
                                    IMPORTING es_reported = lt_reported ).

    reported = CORRESPONDING #( DEEP lt_reported ).

  ENDMETHOD.

  METHOD criaremessa.

    SELECT SINGLE low
    FROM ztca_param_val
    WHERE modulo = 'MM'
    AND chave1 = 'LIMITADOR_ITENS'
    AND chave2 = 'QTDE_ITENS_NF'
    AND chave3 IS INITIAL
    INTO @DATA(lv_limitador_itens).

    DATA: lt_entity TYPE zclmm_aux_ret_armazenagem=>ty_t_entity.
    lt_entity[] = VALUE #( FOR ls_keys IN keys (
      guid     = ls_keys-guid
      numeroordemdefrete     = ls_keys-numeroordemdefrete
      numerodaremessa        = ls_keys-numerodaremessa
      material               = ls_keys-material
      umborigin              = ls_keys-umborigin
      umbdestino             = ls_keys-umbdestino
      centroorigem           = ls_keys-centroorigem
      depositoorigem         = ls_keys-depositoorigem
      centrodestino          = ls_keys-centrodestino
      depositodestino        = ls_keys-depositodestino
      lote                   = ls_keys-lote
      eantype                = ls_keys-eantype
      dadosdohistorico       = ls_keys-dadosdohistorico
      transportador          = ls_keys-%param-transportador
      driver                 = ls_keys-%param-driver
      equipment              = ls_keys-%param-equipment
      shipping_conditions    = ls_keys-%param-shipping_conditions
      shipping_type          = ls_keys-%param-shipping_type
      equipment_tow1         = ls_keys-%param-equipment_tow1
      equipment_tow2         = ls_keys-%param-equipment_tow2
      equipment_tow3         = ls_keys-%param-equipment_tow3
      freight_mode           = ls_keys-%param-freight_mode
    ) ).

    IF lv_limitador_itens IS NOT INITIAL.
      IF lines( keys ) > lv_limitador_itens.
        DATA(lt_return) = VALUE bapiret2_t( ( type = 'E' id = 'ZMM_DEPOSITO_FECHADO' number = '041' message_v1 = lv_limitador_itens ) ).

        DATA(lo_armazenagem) = NEW zclmm_aux_ret_armazenagem( ).

        lo_armazenagem->build_reported( EXPORTING it_return   = lt_return
                                        IMPORTING es_reported = DATA(lt_reported) ).

        reported = CORRESPONDING #( DEEP lt_reported ).

        RETURN.
      ENDIF.
    ENDIF.
    LOOP AT keys ASSIGNING FIELD-SYMBOL(<fs_key>).
      IF <fs_key>-%param-transportador  IS INITIAL.
        APPEND VALUE #( %tky                = <fs_key>-%tky ) TO failed-retarmazenagem.
        APPEND VALUE #( %tky                = <fs_key>-%tky
                        %msg                = new_message(
                          id       = 'ZMM_DEPOSITO_FECHADO'
                          number   = '042'
                          severity = if_abap_behv_message=>severity-error )
                        %element-transportador  = if_abap_behv=>mk-on ) TO reported-retarmazenagem.
        DATA(lv_error) = abap_true.
      ENDIF.
    ENDLOOP.
    CHECK lv_error = abap_false.

* ---------------------------------------------------------------------------
* Criar NFe
* ---------------------------------------------------------------------------
    DATA(lo_events) = NEW zclmm_adm_emissao_nf_events( ).

    lo_events->create_documents_f05( EXPORTING it_armazenagem_cds = lt_entity
                                     IMPORTING et_return       = lt_return ).


    DATA(lt_return_aux) = lt_return.

    LOOP AT lt_return ASSIGNING FIELD-SYMBOL(<fs_return>).
      DATA(lv_tabix) = sy-tabix.
      READ TABLE lt_return TRANSPORTING NO FIELDS WITH KEY message = <fs_return>-message.
      IF sy-subrc = 0 AND sy-tabix <> lv_tabix.
        DELETE lt_return INDEX lv_tabix.
      ENDIF.
    ENDLOOP.

* ---------------------------------------------------------------------------
* Retornar mensagens
* ---------------------------------------------------------------------------
    lo_armazenagem = NEW zclmm_aux_ret_armazenagem( ).

    lo_armazenagem->build_reported( EXPORTING it_return   = lt_return
                                    IMPORTING es_reported = lt_reported ).

    reported = CORRESPONDING #( DEEP lt_reported ).

  ENDMETHOD.

  METHOD criaorderfrete.

    DATA(lo_events) = NEW zclmm_adm_emissao_nf_events( ).

    lo_events->create_ordem_frete(
      EXPORTING
        it_emissao_cds = VALUE #( FOR ls_keys IN keys ( guid = ls_keys-guid ) )
      IMPORTING
        et_return      = DATA(lt_return) ).

* ---------------------------------------------------------------------------
* Retornar mensagens
* ---------------------------------------------------------------------------
    lo_events->build_reported( EXPORTING it_return   = lt_return
                               IMPORTING es_reported = DATA(lt_reported) ).

    reported = CORRESPONDING #( DEEP lt_reported ).

  ENDMETHOD.

  METHOD adicionarserie.

    DATA: lt_serie_cds TYPE table of zi_mm_administrar_serie,
          lt_serialno  TYPE STANDARD TABLE OF zi_mm_administrar_serie-serialno.

* ---------------------------------------------------------------------------
* Recupera dados das linhas selecionadas
* ---------------------------------------------------------------------------
    LOOP AT keys REFERENCE INTO DATA(ls_keys).

      DATA(ls_serie_cds) = VALUE zi_mm_administrar_serie(
        material                = ls_keys->material
        OriginPlant             = ls_keys->CentroOrigem
        OriginStorageLocation   = ls_keys->DepositoOrigem
        batch                   = ls_keys->Lote
        DestinyPlant            = ls_keys->CentroDestino
        DestinyStorageLocation  = ls_keys->DepositoDestino
        guid                    = ls_keys->Guid ).

        ls_serie_cds-ProcessStep = 'F05'.
      FREE lt_serialno.
      SPLIT ls_keys->%param-serialnolist AT ';' INTO TABLE lt_serialno.

      LOOP AT lt_serialno REFERENCE INTO DATA(lv_serialno).
        ls_serie_cds-serialno =  |{ lv_serialno->* ALPHA = IN }|.
        APPEND ls_serie_cds TO lt_serie_cds[].
      ENDLOOP.
    ENDLOOP.

* ---------------------------------------------------------------------------
* Salva os dados de série
* ---------------------------------------------------------------------------
    DATA(lo_events) = NEW zclmm_adm_emissao_nf_events( ).

    lo_events->save_series_retorno( EXPORTING it_serie_cds = lt_serie_cds
                                    IMPORTING et_return    = DATA(lt_return) ).

* ---------------------------------------------------------------------------
* Retornar mensagens
* ---------------------------------------------------------------------------
    lo_events->build_reported( EXPORTING it_return   = lt_return
                               IMPORTING es_reported = DATA(lt_reported) ).

    reported = CORRESPONDING #( DEEP lt_reported ).

  ENDMETHOD.

  METHOD rba_mensagem.
    RETURN.
  ENDMETHOD.

ENDCLASS.

CLASS lcl_zi_mm_ret_armazenagem_app DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS check_before_save REDEFINITION.

    METHODS finalize          REDEFINITION.

    METHODS save              REDEFINITION.

    METHODS adjust_numbers    REDEFINITION.

ENDCLASS.

CLASS lcl_zi_mm_ret_armazenagem_app IMPLEMENTATION.

  METHOD check_before_save.
    RETURN.
  ENDMETHOD.

  METHOD finalize.
    RETURN.
  ENDMETHOD.

  METHOD save.
    RETURN.
  ENDMETHOD.

  METHOD adjust_numbers.
    RETURN.
  ENDMETHOD.

ENDCLASS.
