CLASS lcl_zi_mm_reservas_pendentes_a DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS delete FOR MODIFY
      IMPORTING keys FOR DELETE reservas.

    METHODS update FOR MODIFY
      IMPORTING entities FOR UPDATE reservas.

    METHODS read FOR READ
      IMPORTING keys FOR READ reservas RESULT result.

    METHODS get_features FOR FEATURES
      IMPORTING keys REQUEST requested_features FOR reservas RESULT result.

    METHODS lock FOR LOCK
      IMPORTING keys FOR LOCK reservas.

    METHODS criarnfe FOR MODIFY
      IMPORTING keys FOR ACTION reservas~criarnfe.

    METHODS utilizarQtde FOR MODIFY
      IMPORTING keys FOR ACTION reservas~utilizarQtde.

    METHODS qtdetransferida FOR MODIFY
      IMPORTING keys FOR ACTION reservas~qtdetransferida.

    METHODS get_authorizations FOR AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR Reservas RESULT result.

    METHODS fragmentcheckbox FOR MODIFY
      IMPORTING keys FOR ACTION reservas~fragmentcheckbox.

    METHODS fragmentusedstock FOR MODIFY
      IMPORTING keys FOR ACTION reservas~fragmentusedstock.

ENDCLASS.

CLASS lcl_zi_mm_reservas_pendentes_a IMPLEMENTATION.

  METHOD lock.
    RETURN.
  ENDMETHOD.


  METHOD delete.

    DATA(lo_aux) = NEW  zclmm_reservas_pendentes(  ).
    DATA lt_entity  TYPE zclmm_reservas_pendentes=>ty_t_entity.

* ---------------------------------------------------------------------------
* Recupera dados das linhas selecionadas
* ---------------------------------------------------------------------------
    READ ENTITIES OF zi_mm_reservas_pendentes_app
         IN LOCAL MODE ENTITY reservas
         ALL FIELDS WITH CORRESPONDING #( keys )
         RESULT DATA(lt_reservas) FAILED failed.

* ---------------------------------------------------------------------------
* Apagar os Dados
* ---------------------------------------------------------------------------
    lo_aux->apagar_historico(
      EXPORTING
        it_entity = CORRESPONDING #( lt_reservas )
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

    DATA(lo_aux) = NEW  zclmm_reservas_pendentes(  ).
    DATA lt_entity  TYPE zclmm_reservas_pendentes=>ty_t_entity.

* ---------------------------------------------------------------------------
* Recupera dados das linhas selecionadas
* ---------------------------------------------------------------------------
    READ ENTITIES OF zi_mm_reservas_pendentes_app
         IN LOCAL MODE ENTITY reservas ALL FIELDS WITH CORRESPONDING #( entities )
         RESULT DATA(lt_reservas) FAILED failed.

    LOOP AT lt_reservas ASSIGNING FIELD-SYMBOL(<fs_reservas>).
      <fs_reservas>-UsedStock = entities[ %key-reservation = <fs_reservas>-%key-reservation ]-UsedStock.
    ENDLOOP.

* ---------------------------------------------------------------------------
* Apagar os Dados
* ---------------------------------------------------------------------------
    lo_aux->alterar_transferencia(
      EXPORTING
        it_entity = CORRESPONDING #( lt_reservas )
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


  METHOD read.

* ---------------------------------------------------------------------------
* Recupera os dados de Emissão
* ---------------------------------------------------------------------------
    IF keys[] IS NOT INITIAL.

      SELECT *
        FROM zi_mm_reservas_pendentes_app
        FOR ALL ENTRIES IN @keys
        WHERE Reservation      = @keys-reservation
          AND PrmDepFec        = @keys-PrmDepFec
          AND EANType          = @keys-EANType
          AND DadosDoHistorico = @keys-DadosDoHistorico
        INTO CORRESPONDING FIELDS OF TABLE @result.     "#EC CI_SEL_DEL

      IF sy-subrc NE 0.
        FREE result.
      ENDIF.
    ENDIF.
  ENDMETHOD.


  METHOD get_features.

* ---------------------------------------------------------------------------
* Recupera dados das linhas selecionadas
* ---------------------------------------------------------------------------
    READ ENTITIES OF zi_mm_reservas_pendentes_app
         IN LOCAL MODE ENTITY reservas ALL FIELDS WITH CORRESPONDING #( keys )
         RESULT DATA(lt_reservas) FAILED failed.

* ---------------------------------------------------------------------------
* Atualiza permissões de cada linha
* ---------------------------------------------------------------------------
    result = VALUE #( FOR ls_reservas IN lt_reservas

                    ( %tky                              = ls_reservas-%tky

                      %update                           = COND #( WHEN ls_reservas-statushistorico EQ zclmm_reservas_pendentes=>gc_status-inicial
                                                                    OR ls_reservas-statushistorico EQ zclmm_reservas_pendentes=>gc_status-em_processamento
                                                                    OR ls_reservas-statushistorico EQ zclmm_reservas_pendentes=>gc_status-incompleto
                                                          THEN if_abap_behv=>fc-o-enabled
                                                          ELSE if_abap_behv=>fc-o-disabled )

                      %delete                           = COND #( WHEN ls_reservas-statushistorico EQ zclmm_reservas_pendentes=>gc_status-em_processamento
                                                          THEN if_abap_behv=>fc-o-enabled
                                                          ELSE if_abap_behv=>fc-o-disabled )

                      %action-criarnfe                  = COND #( WHEN ls_reservas-statushistorico EQ zclmm_reservas_pendentes=>gc_status-em_processamento
                                                                    OR ls_reservas-statushistorico EQ zclmm_reservas_pendentes=>gc_status-incompleto
                                                          THEN if_abap_behv=>fc-o-enabled
                                                          ELSE if_abap_behv=>fc-o-disabled )

                      %action-utilizarQtde             = COND #( WHEN ls_reservas-statushistorico EQ zclmm_reservas_pendentes=>gc_status-inicial
                                                                   OR ls_reservas-statushistorico EQ zclmm_reservas_pendentes=>gc_status-em_processamento
                                                          THEN if_abap_behv=>fc-o-enabled
                                                          ELSE if_abap_behv=>fc-o-disabled )

                      %action-qtdeTransferida          = COND #( WHEN ls_reservas-statushistorico EQ zclmm_reservas_pendentes=>gc_status-inicial
                                                                   OR ls_reservas-statushistorico EQ zclmm_reservas_pendentes=>gc_status-em_processamento
                                                          THEN if_abap_behv=>fc-o-enabled
                                                          ELSE if_abap_behv=>fc-o-disabled )


                    ) ).


  ENDMETHOD.


  METHOD utilizarQtde.

    DATA(lo_aux) = NEW  zclmm_reservas_pendentes(  ).
    DATA lt_entity  TYPE zclmm_reservas_pendentes=>ty_t_entity.
* ---------------------------------------------------------------------------
* Recupera dados das linhas selecionadas
* ---------------------------------------------------------------------------
    READ ENTITIES OF zi_mm_reservas_pendentes_app
         IN LOCAL MODE ENTITY reservas
         ALL FIELDS WITH CORRESPONDING #( keys )
         RESULT DATA(lt_reservas) FAILED failed.

    lo_aux->mover_quantidade(
      EXPORTING
        it_entity = CORRESPONDING #( lt_reservas )
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


  METHOD qtdeTransferida.

    DATA(lo_aux) = NEW  zclmm_reservas_pendentes(  ).
    DATA lt_entity  TYPE zclmm_reservas_pendentes=>ty_t_entity.
* ---------------------------------------------------------------------------
* Recupera dados das linhas selecionadas
* ---------------------------------------------------------------------------
    READ ENTITIES OF zi_mm_reservas_pendentes_app
         IN LOCAL MODE ENTITY reservas
         ALL FIELDS WITH CORRESPONDING #( keys )
         RESULT DATA(lt_reservas) FAILED failed.

    TRY.
        DATA(ls_keys) = keys[ 1 ].
      CATCH cx_root.
    ENDTRY.

    LOOP AT lt_reservas REFERENCE INTO DATA(ls_reservas).
      ls_reservas->UsedStock        = ls_keys-%param-newusedstock.
      ls_reservas->statushistorico  = zclmm_reservas_pendentes=>gc_status-em_processamento.
      ls_reservas->useavailable     = abap_false.
    ENDLOOP.

* ---------------------------------------------------------------------------
* Salva os dados de emissão
* ---------------------------------------------------------------------------
    lo_aux->salvar_historico(
      EXPORTING
        it_entity = CORRESPONDING #( lt_reservas )
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


  METHOD criarNFE.

    DATA: lt_entity TYPE zclmm_reservas_pendentes=>ty_t_entity.

    lt_entity[] = VALUE #( FOR ls_keys IN keys ( Reservation            = ls_keys-Reservation
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

    lo_events->create_documents_f13( EXPORTING it_reserva_cds = lt_entity
                                     IMPORTING et_return      = DATA(lt_return) ).

* ---------------------------------------------------------------------------
* Retornar mensagens
* ---------------------------------------------------------------------------
    DATA(lo_reserva) = NEW zclmm_reservas_pendentes( ).

    lo_reserva->build_reported( EXPORTING it_return   = lt_return
                                IMPORTING es_reported = DATA(lt_reported) ).

    reported = CORRESPONDING #( DEEP lt_reported ).

  ENDMETHOD.

  METHOD get_authorizations.

    READ ENTITIES OF zi_mm_reservas_pendentes_app IN LOCAL MODE
        ENTITY Reservas
        ALL FIELDS WITH CORRESPONDING #( keys )
        RESULT DATA(lt_data)
        FAILED failed.

    CHECK lt_data IS NOT INITIAL.

    DATA: lv_update TYPE if_abap_behv=>t_xflag,
          lv_delete TYPE if_abap_behv=>t_xflag.

    LOOP AT lt_data ASSIGNING FIELD-SYMBOL(<fs_data>).

      IF requested_authorizations-%update EQ if_abap_behv=>mk-on.

        IF zclmm_auth_zmmwerks=>werks_update( <fs_data>-Plant ).
          lv_update = if_abap_behv=>auth-allowed.
        ELSE.
          lv_update = if_abap_behv=>auth-unauthorized.
        ENDIF.

      ENDIF.


      IF requested_authorizations-%delete EQ if_abap_behv=>mk-on.

        IF zclmm_auth_zmmwerks=>werks_delete( <fs_data>-Plant ).
          lv_delete = if_abap_behv=>auth-allowed.
        ELSE.
          lv_delete = if_abap_behv=>auth-unauthorized.
        ENDIF.

      ENDIF.

      APPEND VALUE #( %tky = <fs_data>-%tky %update = lv_update %delete = lv_delete ) TO result.

    ENDLOOP.

  ENDMETHOD.

  METHOD fragmentCheckBox.

    DATA(lo_aux) = NEW  zclmm_reservas_pendentes(  ).
    DATA lt_entity  TYPE zclmm_reservas_pendentes=>ty_t_entity.
* ---------------------------------------------------------------------------
* Recupera dados das linhas selecionadas
* ---------------------------------------------------------------------------
    READ ENTITIES OF zi_mm_reservas_pendentes_app
         IN LOCAL MODE ENTITY reservas
         ALL FIELDS WITH CORRESPONDING #( keys )
         RESULT DATA(lt_reservas) FAILED failed.

    TRY.
        DATA(ls_keys) = keys[ 1 ].
      CATCH cx_root.
    ENDTRY.

    lo_aux->mover_quantidade(
      EXPORTING
        it_entity = CORRESPONDING #( lt_reservas )
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

  METHOD fragmentUsedStock.

    DATA(lo_aux) = NEW  zclmm_reservas_pendentes(  ).
    DATA lt_entity  TYPE zclmm_reservas_pendentes=>ty_t_entity.
* ---------------------------------------------------------------------------
* Recupera dados das linhas selecionadas
* ---------------------------------------------------------------------------
    READ ENTITIES OF zi_mm_reservas_pendentes_app
         IN LOCAL MODE ENTITY reservas
         ALL FIELDS WITH CORRESPONDING #( keys )
         RESULT DATA(lt_reservas) FAILED failed.

    TRY.
        DATA(ls_keys) = keys[ 1 ].
      CATCH cx_root.
    ENDTRY.

    LOOP AT lt_reservas REFERENCE INTO DATA(ls_reservas).
      ls_reservas->UsedStock        = ls_keys-%param-newusedstock.
      ls_reservas->statushistorico  = zclmm_reservas_pendentes=>gc_status-em_processamento.
      ls_reservas->useavailable     = abap_false.
    ENDLOOP.

* ---------------------------------------------------------------------------
* Salva os dados de emissão
* ---------------------------------------------------------------------------
    lo_aux->salvar_historico(
      EXPORTING
        it_entity = CORRESPONDING #( lt_reservas )
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

CLASS lcl_zi_mm_reservas_pendentes_b DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS check_before_save REDEFINITION.

    METHODS finalize          REDEFINITION.

    METHODS save              REDEFINITION.

    METHODS adjust_numbers REDEFINITION.

ENDCLASS.

CLASS lcl_zi_mm_reservas_pendentes_b IMPLEMENTATION.

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
