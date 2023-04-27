CLASS lcl_ordemfrete DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS lock FOR LOCK
      IMPORTING keys FOR LOCK ordemfrete.

    METHODS read FOR READ
      IMPORTING keys FOR READ ordemfrete RESULT result.

    METHODS criarnfe FOR MODIFY
      IMPORTING keys FOR ACTION ordemfrete~criarnfe .

    METHODS delete FOR MODIFY
      IMPORTING entities FOR DELETE ordemfrete.

    METHODS get_features FOR FEATURES
      IMPORTING keys REQUEST requested_features FOR ordemfrete RESULT result.

    METHODS update FOR MODIFY
      IMPORTING entities FOR UPDATE ordemfrete.

    METHODS qtdetransferida FOR MODIFY
      IMPORTING keys FOR ACTION ordemfrete~qtdetransferida.

    METHODS utilizarqtde FOR MODIFY
      IMPORTING keys FOR ACTION ordemfrete~utilizarqtde.

    METHODS get_authorizations FOR AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR ordemfrete RESULT result.

    METHODS fragmentcheckbox FOR MODIFY
      IMPORTING keys FOR ACTION ordemfrete~fragmentcheckbox.

    METHODS fragmentusedstock FOR MODIFY
      IMPORTING keys FOR ACTION ordemfrete~fragmentusedstock.


ENDCLASS.

CLASS lcl_ordemfrete IMPLEMENTATION.

  METHOD lock.
    RETURN.
  ENDMETHOD.


  METHOD read.

* ---------------------------------------------------------------------------
* Recupera os dados de Emissão
* ---------------------------------------------------------------------------
    IF keys[] IS NOT INITIAL.

      SELECT *
        FROM zi_mm_pendente_ordem_frete_app
        FOR ALL ENTRIES IN @keys
        WHERE numeroordemdefrete = @keys-numeroordemdefrete
          AND numerodaremessa    = @keys-numerodaremessa
          AND material           = @keys-material
          AND umborigin          = @keys-umborigin
          AND umbdestino         = @keys-umbdestino
          AND centroremessa      = @keys-centroremessa
          AND deposito           = @keys-deposito
          AND lote               = @keys-Lote
          AND CentroDestino      = @keys-CentroDestino
          AND DepositoDestino    = @keys-DepositoDestino
          AND dadosdohistorico   = @keys-dadosdohistorico
          AND PrmDepFecId        = @keys-PrmDepFecId
          AND EANType            = @keys-EANType
        INTO CORRESPONDING FIELDS OF TABLE @result.     "#EC CI_SEL_DEL

      IF sy-subrc NE 0.
        FREE result.
      ENDIF.
    ENDIF.

  ENDMETHOD.


  METHOD qtdeTransferida.

    DATA(lo_aux) = NEW  zclmm_aux_pend_ordem_de_frete(  ).

    DATA lt_entity  TYPE zclmm_aux_pend_ordem_de_frete=>ty_t_entity.
* ---------------------------------------------------------------------------
* Recupera dados das linhas selecionadas
* ---------------------------------------------------------------------------
    READ ENTITIES OF zi_mm_pendente_ordem_frete_app
         IN LOCAL MODE ENTITY ordemfrete
         ALL FIELDS WITH CORRESPONDING #( keys )
         RESULT DATA(lt_ordem_frete) FAILED failed.

    TRY.
        DATA(ls_keys) = keys[ 1 ].
      CATCH cx_root.
    ENDTRY.

    LOOP AT lt_ordem_frete REFERENCE INTO DATA(ls_ordem_frete).
      ls_ordem_frete->UsedStock        = ls_keys-%param-newusedstock.
      ls_ordem_frete->statushistorico  = zclmm_aux_pend_ordem_de_frete=>gc_status-em_processamento.
      ls_ordem_frete->useavailable     = abap_false.
    ENDLOOP.

* ---------------------------------------------------------------------------
* Salva os dados de emissão
* ---------------------------------------------------------------------------
    lo_aux->salvar_historico(
      EXPORTING
        it_entity = CORRESPONDING #( lt_ordem_frete )
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


  METHOD utilizarQtde.

    DATA(lo_aux) = NEW  zclmm_aux_pend_ordem_de_frete(  ).

    DATA lt_entity  TYPE zclmm_aux_pend_ordem_de_frete=>ty_t_entity.
* ---------------------------------------------------------------------------
* Recupera dados das linhas selecionadas
* ---------------------------------------------------------------------------
    READ ENTITIES OF zi_mm_pendente_ordem_frete_app
         IN LOCAL MODE ENTITY ordemfrete
         ALL FIELDS WITH CORRESPONDING #( keys )
         RESULT DATA(lt_ordem_frete) FAILED failed.

    TRY.
        DATA(ls_keys) = keys[ 1 ].
      CATCH cx_root.
    ENDTRY.


    lo_aux->mover_quantidade(
      EXPORTING
        it_entity = CORRESPONDING #( lt_ordem_frete )
        iv_checkbox = abap_true
      IMPORTING
        et_return = DATA(lt_return)
        et_entity = lt_entity
    ).

* ---------------------------------------------------------------------------
* Salva os dados de emissão
* ---------------------------------------------------------------------------
      lo_aux->salvar_historico(
        EXPORTING
          it_entity = CORRESPONDING #( lt_entity )
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

  METHOD criarnfe.

    DATA: lt_entity TYPE zclmm_aux_pend_ordem_de_frete=>ty_t_entity.

    lt_entity[] = VALUE #( FOR ls_keys IN keys ( NumeroOrdemDeFrete     = ls_keys-NumeroOrdemDeFrete
                                                 NumeroDaRemessa        = ls_keys-NumeroDaRemessa
                                                 Material               = ls_keys-Material
                                                 UmbOrigin              = ls_keys-UmbOrigin
                                                 UmbDestino             = ls_keys-UmbDestino
                                                 CentroRemessa          = ls_keys-CentroRemessa
                                                 Deposito               = ls_keys-Deposito
                                                 DadosDoHistorico       = ls_keys-DadosDoHistorico
                                                 Transportador          = ls_keys-%param-Transportador
                                                 Driver                 = ls_keys-%param-Driver
                                                 Equipment              = ls_keys-%param-Equipment
                                                 Shipping_conditions    = ls_keys-%param-shipping_conditions
                                                 Shipping_type          = ls_keys-%param-Shipping_type
                                                 Equipment_tow1         = ls_keys-%param-Equipment_tow1
                                                 Equipment_tow2         = ls_keys-%param-Equipment_tow2
                                                 Equipment_tow3         = ls_keys-%param-Equipment_tow3
                                                 Freight_mode           = ls_keys-%param-Freight_mode ) ).

* ---------------------------------------------------------------------------
* Criar NFe
* ---------------------------------------------------------------------------
    DATA(lo_events) = NEW zclmm_adm_emissao_nf_events( ).

    lo_events->create_documents_f12( EXPORTING it_pendente_cds = lt_entity
                                     IMPORTING et_return       = DATA(lt_return) ).

* ---------------------------------------------------------------------------
* Retornar mensagens
* ---------------------------------------------------------------------------
    DATA(lo_pendente) = NEW zclmm_aux_pend_ordem_de_frete( ).

    lo_pendente->build_reported( EXPORTING it_return   = lt_return
                                 IMPORTING es_reported = DATA(lt_reported) ).

    reported = CORRESPONDING #( DEEP lt_reported ).

  ENDMETHOD.


  METHOD delete.

    DATA(lo_aux) = NEW  zclmm_aux_pend_ordem_de_frete(  ).
    DATA lt_entity  TYPE zclmm_aux_pend_ordem_de_frete=>ty_t_entity.

* ---------------------------------------------------------------------------
* Recupera dados das linhas selecionadas
* ---------------------------------------------------------------------------
    READ ENTITIES OF zi_mm_pendente_ordem_frete_app
         IN LOCAL MODE ENTITY ordemfrete
         ALL FIELDS WITH CORRESPONDING #( entities )
         RESULT DATA(lt_ordem_frete) FAILED failed.

* ---------------------------------------------------------------------------
* Apagar os Dados
* ---------------------------------------------------------------------------
    lo_aux->apagar_historico(
      EXPORTING
        it_entity = CORRESPONDING #( lt_ordem_frete )
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


  METHOD get_features.

* ---------------------------------------------------------------------------
* Recupera dados das linhas selecionadas
* ---------------------------------------------------------------------------
    READ ENTITIES OF zi_mm_pendente_ordem_frete_app
         IN LOCAL MODE ENTITY ordemfrete
         ALL FIELDS WITH CORRESPONDING #( keys )
         RESULT DATA(lt_ordem_frete) FAILED failed.

* ---------------------------------------------------------------------------
* Atualiza permissões de cada linha
* ---------------------------------------------------------------------------
    result = VALUE #( FOR ls_ordem IN lt_ordem_frete

                    ( %tky                              = ls_ordem-%tky

                      %update                           = COND #( WHEN ls_ordem-statushistorico EQ zclmm_aux_pend_ordem_de_frete=>gc_status-inicial
                                                                    OR ls_ordem-statushistorico EQ zclmm_aux_pend_ordem_de_frete=>gc_status-em_processamento
                                                                    OR ls_ordem-statushistorico EQ zclmm_aux_pend_ordem_de_frete=>gc_status-incompleto
                                                          THEN if_abap_behv=>fc-o-enabled
                                                          ELSE if_abap_behv=>fc-o-disabled )

                      %delete                           = COND #( WHEN ls_ordem-statushistorico EQ zclmm_aux_pend_ordem_de_frete=>gc_status-em_processamento
                                                          THEN if_abap_behv=>fc-o-enabled
                                                          ELSE if_abap_behv=>fc-o-disabled )

                      %action-criarnfe                  = COND #( WHEN ls_ordem-statushistorico EQ zclmm_aux_pend_ordem_de_frete=>gc_status-em_processamento
                                                                    OR ls_ordem-statushistorico EQ zclmm_aux_pend_ordem_de_frete=>gc_status-incompleto
                                                          THEN if_abap_behv=>fc-o-enabled
                                                          ELSE if_abap_behv=>fc-o-disabled )

                      %action-qtdeTransferida          = COND #( WHEN ls_ordem-statushistorico EQ zclmm_aux_pend_ordem_de_frete=>gc_status-inicial
                                                                   OR ls_ordem-statushistorico EQ zclmm_aux_pend_ordem_de_frete=>gc_status-em_processamento
                                                          THEN if_abap_behv=>fc-o-enabled
                                                          ELSE if_abap_behv=>fc-o-disabled )

                      %action-utilizarQtde             = COND #( WHEN ls_ordem-statushistorico EQ zclmm_aux_pend_ordem_de_frete=>gc_status-inicial
                                                                   OR ls_ordem-statushistorico EQ zclmm_aux_pend_ordem_de_frete=>gc_status-em_processamento
                                                          THEN if_abap_behv=>fc-o-enabled
                                                          ELSE if_abap_behv=>fc-o-disabled )
                    ) ).
  ENDMETHOD.


  METHOD update.

    DATA(lo_aux) = NEW  zclmm_aux_pend_ordem_de_frete(  ).
    DATA lt_entity  TYPE zclmm_aux_pend_ordem_de_frete=>ty_t_entity.

* ---------------------------------------------------------------------------
* Apagar os Dados
* ---------------------------------------------------------------------------
    lo_aux->alterar_transferencia(
      EXPORTING
        it_entity = CORRESPONDING #( entities )
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

  METHOD get_authorizations.

    READ ENTITIES OF zi_mm_pendente_ordem_frete_app IN LOCAL MODE
        ENTITY OrdemFrete
        ALL FIELDS WITH CORRESPONDING #( keys )
        RESULT DATA(lt_data)
        FAILED failed.

    CHECK lt_data IS NOT INITIAL.

    DATA: lv_update TYPE if_abap_behv=>t_xflag,
          lv_delete TYPE if_abap_behv=>t_xflag,
          lv_create TYPE if_abap_behv=>t_xflag.

    LOOP AT lt_data ASSIGNING FIELD-SYMBOL(<fs_data>).

      IF requested_authorizations-%action-criarNFE EQ if_abap_behv=>mk-on.

        IF zclmm_auth_zmmwerks=>werks_create( <fs_data>-CentroRemessa ) = abap_true.
          lv_create = if_abap_behv=>auth-allowed.
        ELSE.
          lv_create = if_abap_behv=>auth-unauthorized.
        ENDIF.

      ENDIF.

      IF requested_authorizations-%update EQ if_abap_behv=>mk-on.

        IF zclmm_auth_zmmwerks=>werks_update( <fs_data>-CentroRemessa ) = abap_true.
          lv_update = if_abap_behv=>auth-allowed.
        ELSE.
          lv_update = if_abap_behv=>auth-unauthorized.
        ENDIF.

      ENDIF.

      IF requested_authorizations-%delete EQ if_abap_behv=>mk-on.

        IF zclmm_auth_zmmwerks=>werks_delete( <fs_data>-CentroRemessa ) = abap_true.
          lv_delete = if_abap_behv=>auth-allowed.
        ELSE.
          lv_delete = if_abap_behv=>auth-unauthorized.
        ENDIF.

      ENDIF.

      APPEND VALUE #( %tky             = <fs_data>-%tky
                      %update          = lv_update
                      %delete          = lv_delete
                      %action-criarnfe = lv_create )
             TO result.
    ENDLOOP.

  ENDMETHOD.

  METHOD fragmentCheckBox.

    DATA(lo_aux) = NEW  zclmm_aux_pend_ordem_de_frete(  ).

    DATA lt_entity  TYPE zclmm_aux_pend_ordem_de_frete=>ty_t_entity.
* ---------------------------------------------------------------------------
* Recupera dados das linhas selecionadas
* ---------------------------------------------------------------------------
    READ ENTITIES OF zi_mm_pendente_ordem_frete_app
         IN LOCAL MODE ENTITY ordemfrete
         ALL FIELDS WITH CORRESPONDING #( keys )
         RESULT DATA(lt_ordem_frete) FAILED failed.

    TRY.
        DATA(ls_keys) = keys[ 1 ].
      CATCH cx_root.
    ENDTRY.

    lo_aux->mover_quantidade(
      EXPORTING
        it_entity = CORRESPONDING #( lt_ordem_frete )
        iv_checkbox = ls_keys-%param-useavailablecheckbox
      IMPORTING
        et_return = DATA(lt_return)
        et_entity = lt_entity
    ).

* ---------------------------------------------------------------------------
* Salva os dados de emissão
* ---------------------------------------------------------------------------
      lo_aux->salvar_historico(
        EXPORTING
          it_entity = CORRESPONDING #( lt_entity )
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

  METHOD fragmentUsedStock.

    DATA(lo_aux) = NEW  zclmm_aux_pend_ordem_de_frete(  ).

    DATA lt_entity  TYPE zclmm_aux_pend_ordem_de_frete=>ty_t_entity.
* ---------------------------------------------------------------------------
* Recupera dados das linhas selecionadas
* ---------------------------------------------------------------------------
    READ ENTITIES OF zi_mm_pendente_ordem_frete_app
         IN LOCAL MODE ENTITY ordemfrete
         ALL FIELDS WITH CORRESPONDING #( keys )
         RESULT DATA(lt_ordem_frete) FAILED failed.

    TRY.
        DATA(ls_keys) = keys[ 1 ].
      CATCH cx_root.
    ENDTRY.

    LOOP AT lt_ordem_frete REFERENCE INTO DATA(ls_ordem_frete).
      ls_ordem_frete->UsedStock        = ls_keys-%param-newusedstock.
      ls_ordem_frete->statushistorico  = zclmm_aux_pend_ordem_de_frete=>gc_status-em_processamento.
      ls_ordem_frete->useavailable     = abap_false.
    ENDLOOP.

* ---------------------------------------------------------------------------
* Salva os dados de emissão
* ---------------------------------------------------------------------------
    lo_aux->salvar_historico(
      EXPORTING
        it_entity = CORRESPONDING #( lt_ordem_frete )
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

ENDCLASS.

CLASS lcl_zi_mm_pendente_ordem_frete DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS check_before_save REDEFINITION.

    METHODS finalize          REDEFINITION.

    METHODS save              REDEFINITION.

    METHODS adjust_numbers    REDEFINITION.

ENDCLASS.

CLASS lcl_zi_mm_pendente_ordem_frete IMPLEMENTATION.

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
