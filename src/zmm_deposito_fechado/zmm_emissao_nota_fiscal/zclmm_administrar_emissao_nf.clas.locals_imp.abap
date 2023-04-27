CLASS lcl_emissao DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_features FOR FEATURES
      IMPORTING keys REQUEST requested_features FOR emissao RESULT result.

    METHODS read FOR READ
      IMPORTING keys FOR READ emissao RESULT result.

    METHODS update FOR MODIFY
      IMPORTING entities FOR UPDATE emissao.

    METHODS delete FOR MODIFY
      IMPORTING entities FOR DELETE emissao.

    METHODS lock FOR LOCK
      IMPORTING keys FOR LOCK emissao.

*    METHODS criarnfe FOR MODIFY
*      IMPORTING keys FOR ACTION emissao~criarnfe.

    METHODS utilizarqtde FOR MODIFY
      IMPORTING keys FOR ACTION emissao~utilizarqtde.

    METHODS rba_serie FOR READ
      IMPORTING keys_rba FOR READ emissao\_serie FULL result_requested RESULT result LINK association_links.

    METHODS rba_mensagem FOR READ
      IMPORTING keys_rba FOR READ emissao\_mensagem FULL result_requested RESULT result LINK association_links.

    METHODS adicionarserie FOR MODIFY
      IMPORTING keys FOR ACTION emissao~adicionarserie.

    METHODS qtdetransferida FOR MODIFY
      IMPORTING keys FOR ACTION emissao~qtdetransferida.

    METHODS get_authorizations FOR AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR emissao RESULT result.

    METHODS fragmentcheckbox FOR MODIFY
      IMPORTING keys FOR ACTION emissao~fragmentcheckbox.

    METHODS fragmentusedstock FOR MODIFY
      IMPORTING keys FOR ACTION emissao~fragmentusedstock.

    METHODS criaremessa FOR MODIFY
      IMPORTING keys FOR ACTION emissao~criaremessa.

    METHODS criaremesimb FOR MODIFY
      IMPORTING keys FOR ACTION emissao~criaremesimb.

    METHODS criaorderfrete FOR MODIFY
      IMPORTING keys FOR ACTION emissao~criaorderfrete.

    METHODS continuarprocesso FOR MODIFY
      IMPORTING keys FOR ACTION emissao~continuar.

    METHODS validarnotarejeitada
      IMPORTING
        is_administrar_emissao_nf TYPE zi_mm_administrar_emissao_nf
      RETURNING
        VALUE(rv_retorno)         TYPE abap_bool.
ENDCLASS.

CLASS lcl_emissao IMPLEMENTATION.


  METHOD get_features.

* ---------------------------------------------------------------------------
* Recupera dados das linhas selecionadas
* ---------------------------------------------------------------------------
    READ ENTITIES OF zi_mm_administrar_emissao_nf IN LOCAL MODE ENTITY emissao
      ALL FIELDS
      WITH CORRESPONDING #( keys )
      RESULT DATA(lt_emissao)
      FAILED failed.

* ---------------------------------------------------------------------------
* Atualiza permissões de cada linha
* ---------------------------------------------------------------------------
    result = VALUE #( FOR ls_emissao IN lt_emissao

                    ( %tky                              = ls_emissao-%tky

                      %update                           = COND #( WHEN ls_emissao-status EQ zclmm_adm_emissao_nf_events=>gc_status-inicial
                                                                    OR ls_emissao-status EQ zclmm_adm_emissao_nf_events=>gc_status-em_processamento
                                                                    OR ls_emissao-status EQ zclmm_adm_emissao_nf_events=>gc_status-ordem_frete_job
                                                                    OR ls_emissao-status EQ zclmm_adm_emissao_nf_events=>gc_status-ordem_frete
                                                                    OR ls_emissao-status EQ zclmm_adm_emissao_nf_events=>gc_status-saida_nota
                                                          THEN if_abap_behv=>fc-o-enabled
                                                          ELSE if_abap_behv=>fc-o-disabled )

                      %delete                           = COND #( WHEN ls_emissao-status EQ zclmm_adm_emissao_nf_events=>gc_status-em_processamento
                                                                    OR ( ls_emissao-status EQ zclmm_adm_emissao_nf_events=>gc_status-nota_rejeita AND validarnotarejeitada( CORRESPONDING #( ls_emissao ) ) )
                                                          THEN if_abap_behv=>fc-o-enabled
                                                          ELSE if_abap_behv=>fc-o-disabled )

*                      %action-criarNfe                  = COND #( WHEN ls_emissao-Status EQ zclmm_adm_emissao_nf_events=>gc_status-em_processamento
*                                                                    OR ls_emissao-Status EQ zclmm_adm_emissao_nf_events=>gc_status-incompleto
*                                                          THEN if_abap_behv=>fc-o-enabled
*                                                          ELSE if_abap_behv=>fc-o-disabled )

                      %action-criaremessa               = COND #( WHEN ls_emissao-status EQ zclmm_adm_emissao_nf_events=>gc_status-em_processamento
                                                                    OR ls_emissao-status EQ zclmm_adm_emissao_nf_events=>gc_status-incompleto
                                                          THEN if_abap_behv=>fc-o-enabled
                                                          ELSE if_abap_behv=>fc-o-disabled )

                      %action-criaremesimb              = COND #( WHEN ls_emissao-status EQ zclmm_adm_emissao_nf_events=>gc_status-em_processamento
                                                                    OR ls_emissao-status EQ zclmm_adm_emissao_nf_events=>gc_status-incompleto
                                                          THEN if_abap_behv=>fc-o-enabled
                                                          ELSE if_abap_behv=>fc-o-disabled )

                      %action-criaorderfrete            = COND #( WHEN ls_emissao-status EQ zclmm_adm_emissao_nf_events=>gc_status-ordem_frete
                                                          THEN if_abap_behv=>fc-o-enabled
                                                          ELSE if_abap_behv=>fc-o-disabled )

                      %action-utilizarqtde              = COND #( WHEN ls_emissao-status EQ zclmm_adm_emissao_nf_events=>gc_status-inicial
                                                                    OR ls_emissao-status EQ zclmm_adm_emissao_nf_events=>gc_status-em_processamento
                                                          THEN if_abap_behv=>fc-o-enabled
                                                          ELSE if_abap_behv=>fc-o-disabled )

                      %action-qtdetransferida           = COND #( WHEN ls_emissao-status EQ zclmm_adm_emissao_nf_events=>gc_status-inicial
                                                                    OR ls_emissao-status EQ zclmm_adm_emissao_nf_events=>gc_status-em_processamento
                                                          THEN if_abap_behv=>fc-o-enabled
                                                          ELSE if_abap_behv=>fc-o-disabled )

                      %action-adicionarserie            = if_abap_behv=>fc-o-disabled


                      %action-continuar              = COND #( WHEN ( ls_emissao-status EQ zclmm_adm_emissao_nf_events=>gc_status-incompleto OR
                                                                      ls_emissao-status EQ zclmm_adm_emissao_nf_events=>gc_status-nota_rejeita )
                                                          THEN if_abap_behv=>fc-o-enabled
                                                          ELSE if_abap_behv=>fc-o-disabled )

                    ) ).

  ENDMETHOD.

  METHOD validarnotarejeitada.
    SELECT COUNT(*) FROM ekpo WHERE ebeln = @is_administrar_emissao_nf-purchaseorder AND loekz <> ''.
    IF sy-subrc = 0.
      SELECT COUNT(*) FROM j_1bnfdoc WHERE docnum = @is_administrar_emissao_nf-outbr_notafiscal AND cancel <> ''.
      IF sy-subrc = 0.
        rv_retorno =  abap_true.
        RETURN.
      ENDIF.
    ENDIF.
  ENDMETHOD.

  METHOD read.

* ---------------------------------------------------------------------------
* Recupera os dados de Emissão
* ---------------------------------------------------------------------------
    IF keys[] IS NOT INITIAL.

      SELECT *
        FROM zi_mm_administrar_emissao_nf
        FOR ALL ENTRIES IN @keys
        WHERE material              = @keys-material
          AND originplant           = @keys-originplant
          AND originstoragelocation = @keys-originstoragelocation
          AND batch                 = @keys-batch
          AND originunit            = @keys-originunit
          AND unit                  = @keys-unit
          AND guid                  = @keys-guid
          AND processstep           = @keys-processstep
          AND prmdepfecid           = @keys-prmdepfecid
          AND eantype               = @keys-eantype
          AND destinyplant = @keys-destinyplant
          AND destinystoragelocation = @keys-destinystoragelocation
        INTO CORRESPONDING FIELDS OF TABLE @result.     "#EC CI_SEL_DEL

      IF sy-subrc NE 0.
        FREE result.
      ENDIF.
    ENDIF.

  ENDMETHOD.


  METHOD update.

* ---------------------------------------------------------------------------
* Recupera dados das linhas selecionadas
* ---------------------------------------------------------------------------
    READ ENTITIES OF zi_mm_administrar_emissao_nf IN LOCAL MODE ENTITY emissao
      ALL FIELDS
      WITH CORRESPONDING #( entities )
      RESULT DATA(lt_emissao)
      FAILED failed.

    DATA(ls_entities) = entities[ 1 ].

* ---------------------------------------------------------------------------
* Transafere os dados modificados
* ---------------------------------------------------------------------------
    LOOP AT lt_emissao REFERENCE INTO DATA(ls_emissao).

      " Quando houver alteração manual, ignorar Checkbox
      ls_emissao->useavailable        = COND #( WHEN ls_entities-%control-usedstock NE if_abap_behv=>fc-o-enabled
                                        THEN abap_false
                                        WHEN ls_entities-%control-useavailable EQ if_abap_behv=>fc-o-enabled
                                        THEN ls_emissao->useavailable
                                        ELSE ls_entities-useavailable ).

      ls_emissao->usedstock           = COND #( WHEN ls_entities-%control-usedstock EQ if_abap_behv=>fc-o-enabled
                                        THEN ls_emissao->usedstock
                                        ELSE ls_entities-usedstock ).
      ls_emissao->carrier             = COND #( WHEN ls_entities-%control-carrier EQ if_abap_behv=>fc-o-enabled
                                        THEN ls_emissao->carrier
                                        ELSE ls_entities-carrier ).
      ls_emissao->driver              = COND #( WHEN ls_entities-%control-driver EQ if_abap_behv=>fc-o-enabled
                                        THEN ls_emissao->driver
                                        ELSE ls_entities-driver ).
      ls_emissao->equipment           = COND #( WHEN ls_entities-%control-equipment EQ if_abap_behv=>fc-o-enabled
                                        THEN ls_emissao->equipment
                                        ELSE ls_entities-equipment ).
      ls_emissao->shippingconditions  = COND #( WHEN ls_entities-%control-shippingconditions EQ if_abap_behv=>fc-o-enabled
                                        THEN ls_emissao->shippingconditions
                                        ELSE ls_entities-shippingconditions ).
      ls_emissao->shippingtype        = COND #( WHEN ls_entities-%control-shippingtype EQ if_abap_behv=>fc-o-enabled
                                        THEN ls_emissao->shippingtype
                                        ELSE ls_entities-shippingtype ).
      ls_emissao->equipmenttow1       = COND #( WHEN ls_entities-%control-equipmenttow1 EQ if_abap_behv=>fc-o-enabled
                                        THEN ls_emissao->equipmenttow1
                                        ELSE ls_entities-equipmenttow1 ).
      ls_emissao->equipmenttow2       = COND #( WHEN ls_entities-%control-equipmenttow2 EQ if_abap_behv=>fc-o-enabled
                                        THEN ls_emissao->equipmenttow2
                                        ELSE ls_entities-equipmenttow2 ).
      ls_emissao->equipmenttow3       = COND #( WHEN ls_entities-%control-equipmenttow3 EQ if_abap_behv=>fc-o-enabled
                                        THEN ls_emissao->equipmenttow3
                                        ELSE ls_entities-equipmenttow3 ).
      ls_emissao->freightmode         = COND #( WHEN ls_entities-%control-freightmode EQ if_abap_behv=>fc-o-enabled
                                        THEN ls_emissao->freightmode
                                        ELSE ls_entities-freightmode ).
      ls_emissao->batch               = COND #( WHEN ls_entities-%control-batch EQ if_abap_behv=>fc-o-enabled
                                        THEN ls_emissao->batch
                                        ELSE ls_entities-batch ).

    ENDLOOP.


    DATA(lt_return) = NEW zclmm_atualiza_remessa( )->executar( CORRESPONDING #( lt_emissao ) ).

* ---------------------------------------------------------------------------
* Salva os dados de emissão
* ---------------------------------------------------------------------------
    DATA(lo_events) = NEW zclmm_adm_emissao_nf_events( ).
    IF NOT line_exists( lt_return[ type = 'E' ] ).

      IF NOT line_exists( lt_emissao[ outbounddelivery = '' ] ).
        SELECT * "#EC CI_ALL_FIELDS_NEEDED
          FROM zi_mm_administrar_emissao_nf
          FOR ALL ENTRIES IN @lt_emissao
          WHERE outbounddelivery = @lt_emissao-outbounddelivery
          INTO TABLE @DATA(lt_adm_emissao).             "#EC CI_SEL_DEL #EC CI_ALL_FIELDS_NEEDED #EC CI_FAE_LINES_ENSURED
        LOOP AT lt_adm_emissao ASSIGNING FIELD-SYMBOL(<fs_adm_emissao>).
          <fs_adm_emissao>-carrier            = ls_emissao->carrier.
          <fs_adm_emissao>-driver             = ls_emissao->driver.
          <fs_adm_emissao>-equipment          = ls_emissao->equipment.
          <fs_adm_emissao>-shippingconditions = ls_emissao->shippingconditions.
          <fs_adm_emissao>-shippingtype       = ls_emissao->shippingtype.
          <fs_adm_emissao>-equipmenttow1      = ls_emissao->equipmenttow1.
          <fs_adm_emissao>-equipmenttow2      = ls_emissao->equipmenttow2.
          <fs_adm_emissao>-equipmenttow3      = ls_emissao->equipmenttow3.
          <fs_adm_emissao>-freightmode        = ls_emissao->freightmode.
        ENDLOOP.
        lt_emissao =  CORRESPONDING #( lt_adm_emissao ).
      ENDIF.
      lo_events->save_issue( EXPORTING it_emissao_cds = CORRESPONDING #( lt_emissao )
                                       iv_nao_muda_status = abap_true
                             IMPORTING et_return      = lt_return ).
    ELSE.
      NEW zclmm_adm_emissao_nf_events( )->format_return( CHANGING ct_return = lt_return ).
    ENDIF.
* ---------------------------------------------------------------------------
* Retornar mensagens
* ---------------------------------------------------------------------------
    lo_events->build_reported( EXPORTING it_return   = lt_return
                               IMPORTING es_reported = DATA(lt_reported) ).

    reported = CORRESPONDING #( DEEP lt_reported ).

  ENDMETHOD.


  METHOD delete.

* ---------------------------------------------------------------------------
* Recupera dados das linhas selecionadas
* ---------------------------------------------------------------------------
    READ ENTITIES OF zi_mm_administrar_emissao_nf IN LOCAL MODE ENTITY emissao
      ALL FIELDS
      WITH CORRESPONDING #( entities )
      RESULT DATA(lt_emissao)
      FAILED failed.

    READ ENTITIES OF zi_mm_administrar_emissao_nf IN LOCAL MODE ENTITY serie
      ALL FIELDS
      WITH CORRESPONDING #( entities )
      RESULT DATA(lt_serie)
      FAILED failed.

* ---------------------------------------------------------------------------
* Elimina registros
* ---------------------------------------------------------------------------
    DATA(lo_events) = NEW zclmm_adm_emissao_nf_events(  ).

    lo_events->delete_issue( EXPORTING it_emissao_cds = CORRESPONDING #( lt_emissao )
                                       it_serie_cds   = CORRESPONDING #( lt_serie )
                             IMPORTING et_return      = DATA(lt_return) ).

* ---------------------------------------------------------------------------
* Retornar mensagens
* ---------------------------------------------------------------------------
    lo_events->build_reported( EXPORTING it_return   = lt_return
                               IMPORTING es_reported = DATA(lt_reported) ).

    reported = CORRESPONDING #( DEEP lt_reported ).

  ENDMETHOD.


  METHOD lock.
    RETURN.
  ENDMETHOD.


*  METHOD criarNfe.
*
*    DATA: lt_emissao_cds TYPE STANDARD TABLE OF zi_mm_administrar_emissao_nf.
*
*
*    select SINGLE low
*    from ztca_param_val
*    where modulo = 'MM'
*    and chave1 = 'LIMITADOR_ITENS'
*    AND CHAVE2 = 'QTDE_ITENS_NF'
*    AND chave3 IS INITIAL
*    INTO @DATA(lv_limitador_itens).
*
*
*    lt_emissao_cds[] = VALUE #( FOR ls_keys IN keys ( Material              = ls_keys-Material
*                                                      OriginPlant           = ls_keys-OriginPlant
*                                                      OriginStorageLocation = ls_keys-OriginStorageLocation
*                                                      OriginUnit            = ls_keys-OriginUnit
*                                                      Unit                  = ls_keys-Unit
*                                                      Guid                  = ls_keys-Guid
*                                                      Batch                 = ls_keys-Batch
*                                                      ProcessStep           = ls_keys-ProcessStep
*                                                      PrmDepFecId           = ls_keys-PrmDepFecId
*                                                      EANType               = ls_keys-EANType
*                                                      NewCarrier            = ls_keys-%param-NewCarrier
*                                                      NewDriver             = ls_keys-%param-NewDriver
*                                                      NewEquipment          = ls_keys-%param-NewEquipment
*                                                      NewShippingConditions = ls_keys-%param-NewShippingConditions
*                                                      NewShippingType       = ls_keys-%param-NewShippingType
*                                                      NewEquipmentTow1      = ls_keys-%param-NewEquipmentTow1
*                                                      NewEquipmentTow2      = ls_keys-%param-NewEquipmentTow2
*                                                      NewEquipmentTow3      = ls_keys-%param-NewEquipmentTow3
*                                                      NewFreightMode        = ls_keys-%param-NewFreightMode ) ).
*
** ---------------------------------------------------------------------------
** Cria NFe
** ---------------------------------------------------------------------------
*    DATA(lo_events) = NEW zclmm_adm_emissao_nf_events( ).
*
*
*    if lv_limitador_itens is not INITIAL.
*    if lines( keys ) > lv_limitador_itens.
*    data(lt_return) = value bapiret2_t( ( type = 'E' id = 'ZMM_DEPOSITO_FECHADO' number = '041' message_v1 = lv_limitador_itens ) ).
*
*    lo_events->build_reported( EXPORTING it_return   = lt_return
*                               IMPORTING es_reported = DATA(lt_reported) ).
*
*    reported = CORRESPONDING #( DEEP lt_reported ).
*
*    return.
*    ENDIF.
*    ENDIF.
*
*
*
*    lo_events->create_documents_f02( EXPORTING it_emissao_cds = lt_emissao_cds[]
*                                     IMPORTING et_return      = lt_return ).
*
** ---------------------------------------------------------------------------
** Retornar mensagens
** ---------------------------------------------------------------------------
*    lo_events->build_reported( EXPORTING it_return   = lt_return
*                               IMPORTING es_reported = lt_reported ).
*
*    reported = CORRESPONDING #( DEEP lt_reported ).
*
*  ENDMETHOD.


  METHOD utilizarqtde.

    DATA: lt_emissao_new TYPE STANDARD TABLE OF zi_mm_administrar_emissao_nf.

* ---------------------------------------------------------------------------
* Recupera a chave e os novos dados informados
* ---------------------------------------------------------------------------
    lt_emissao_new[] = VALUE #( FOR ls_keys IN keys ( material                = ls_keys-material
                                                      originplant             = ls_keys-originplant
                                                      originstoragelocation   = ls_keys-originstoragelocation
                                                      originunit              = ls_keys-originunit
                                                      batch                   = ls_keys-batch
                                                      unit                    = ls_keys-unit
                                                      guid                    = ls_keys-guid
                                                      prmdepfecid             = ls_keys-prmdepfecid
                                                      processstep             = ls_keys-processstep
                                                      eantype                 = ls_keys-eantype
                                                      useavailable            = abap_true ) ).

* ---------------------------------------------------------------------------
* Salva os dados de emissão
* ---------------------------------------------------------------------------
    DATA(lo_events) = NEW zclmm_adm_emissao_nf_events( ).

    lo_events->save_issue( EXPORTING it_emissao_cds = lt_emissao_new
                                     iv_checkbox    = abap_true
                           IMPORTING et_return      = DATA(lt_return) ).

* ---------------------------------------------------------------------------
* Retornar mensagens
* ---------------------------------------------------------------------------
    lo_events->build_reported( EXPORTING it_return   = lt_return
                               IMPORTING es_reported = DATA(lt_reported) ).

    reported = CORRESPONDING #( DEEP lt_reported ).

  ENDMETHOD.


  METHOD qtdetransferida.

    DATA: lt_emissao_new TYPE STANDARD TABLE OF zi_mm_administrar_emissao_nf.

* ---------------------------------------------------------------------------
* Recupera a chave e os novos dados informados
* ---------------------------------------------------------------------------
    lt_emissao_new[] = VALUE #( FOR ls_keys IN keys ( material                = ls_keys-material
                                                      originplant             = ls_keys-originplant
                                                      originstoragelocation   = ls_keys-originstoragelocation
                                                      originunit              = ls_keys-originunit
                                                      unit                    = ls_keys-unit
                                                      guid                    = ls_keys-guid
                                                      batch                   = ls_keys-batch
                                                      prmdepfecid             = ls_keys-prmdepfecid
                                                      processstep             = ls_keys-processstep
                                                      eantype                 = COND #( WHEN ls_keys-eantype IS INITIAL THEN '00' ELSE ls_keys-eantype )
                                                      usedstock               = ls_keys-%param-newusedstock
                                                      useavailable            = abap_false ) ).

* ---------------------------------------------------------------------------
* Salva os dados de emissão
* ---------------------------------------------------------------------------
    DATA(lo_events) = NEW zclmm_adm_emissao_nf_events( ).

    lo_events->save_issue( EXPORTING it_emissao_cds = lt_emissao_new
                                     iv_checkbox    = abap_false
                           IMPORTING et_return      = DATA(lt_return) ).

* ---------------------------------------------------------------------------
* Retornar mensagens
* ---------------------------------------------------------------------------
    lo_events->build_reported( EXPORTING it_return   = lt_return
                               IMPORTING es_reported = DATA(lt_reported) ).

    reported = CORRESPONDING #( DEEP lt_reported ).


  ENDMETHOD.


  METHOD adicionarserie.

    DATA: lt_serie_cds TYPE STANDARD TABLE OF zi_mm_administrar_serie,
          lt_serialno  TYPE STANDARD TABLE OF zi_mm_administrar_serie-serialno.

* ---------------------------------------------------------------------------
* Recupera dados das linhas selecionadas
* ---------------------------------------------------------------------------
    LOOP AT keys REFERENCE INTO DATA(ls_keys).

      DATA(ls_serie_cds) = VALUE zi_mm_administrar_serie(
                           material               = ls_keys->material
                           originplant            = ls_keys->originplant
                           originstoragelocation  = ls_keys->originstoragelocation
                           originunit             = ls_keys->originunit
                           batch                  = ls_keys->batch
                           unit                   = ls_keys->unit
                           guid                   = ls_keys->guid
                           processstep            = ls_keys->processstep
                           prmdepfecid            = ls_keys->prmdepfecid
                           DestinyPlant           = ls_keys->DestinyPlant
                           DestinyStorageLocation = ls_keys->DestinyStorageLocation
                           eantype                = ls_keys->eantype ).

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

    lo_events->save_series( EXPORTING it_serie_cds = lt_serie_cds
                            IMPORTING et_return    = DATA(lt_return) ).

* ---------------------------------------------------------------------------
* Retornar mensagens
* ---------------------------------------------------------------------------
    lo_events->build_reported( EXPORTING it_return   = lt_return
                               IMPORTING es_reported = DATA(lt_reported) ).

    reported = CORRESPONDING #( DEEP lt_reported ).

  ENDMETHOD.


  METHOD rba_serie.
    RETURN.
  ENDMETHOD.

  METHOD get_authorizations.

    READ ENTITIES OF zi_mm_administrar_emissao_nf IN LOCAL MODE
        ENTITY emissao
        ALL FIELDS WITH CORRESPONDING #( keys )
        RESULT DATA(lt_data)
        FAILED failed.

    CHECK lt_data IS NOT INITIAL.

    DATA: lv_update TYPE if_abap_behv=>t_xflag,
          lv_delete TYPE if_abap_behv=>t_xflag.

    LOOP AT lt_data ASSIGNING FIELD-SYMBOL(<fs_data>).

      IF requested_authorizations-%update EQ if_abap_behv=>mk-on.

        IF zclmm_auth_zmmwerks=>werks_update( <fs_data>-originplant ) = abap_true.
          lv_update = if_abap_behv=>auth-allowed.
        ELSE.
          lv_update = if_abap_behv=>auth-unauthorized.
        ENDIF.

      ENDIF.

      IF requested_authorizations-%delete EQ if_abap_behv=>mk-on.

        IF zclmm_auth_zmmwerks=>werks_delete( <fs_data>-originplant ) = abap_true.
          lv_delete = if_abap_behv=>auth-allowed.
        ELSE.
          lv_delete = if_abap_behv=>auth-unauthorized.
        ENDIF.

      ENDIF.

      APPEND VALUE #( %tky          = <fs_data>-%tky
                      %update       = lv_update
                      %delete       = lv_delete )
             TO result.
    ENDLOOP.

  ENDMETHOD.


  METHOD fragmentcheckbox.

    DATA: lt_emissao TYPE STANDARD TABLE OF zi_mm_administrar_emissao_nf.

* ---------------------------------------------------------------------------
* Recupera a chave e os novos dados informados
* ---------------------------------------------------------------------------
    lt_emissao[] = VALUE #( FOR ls_keys IN keys ( material                = ls_keys-material
                                                  originplant             = ls_keys-originplant
                                                  originstoragelocation   = ls_keys-originstoragelocation
                                                  batch                   = ls_keys-batch
                                                  originunit              = ls_keys-originunit
                                                  unit                    = ls_keys-unit
                                                  guid                    = ls_keys-guid
                                                  prmdepfecid             = ls_keys-prmdepfecid
                                                  processstep             = ls_keys-processstep
                                                  eantype                 = ls_keys-eantype
                                                  useavailable            = ls_keys-%param-useavailablecheckbox ) ).

* ---------------------------------------------------------------------------
* Salva os dados de emissão
* ---------------------------------------------------------------------------
    DATA(lo_events) = NEW zclmm_adm_emissao_nf_events( ).

    lo_events->save_issue( EXPORTING it_emissao_cds = lt_emissao
                                     iv_checkbox    = abap_true
                           IMPORTING et_return      = DATA(lt_return) ).

* ---------------------------------------------------------------------------
* Retornar mensagens
* ---------------------------------------------------------------------------
    lo_events->build_reported( EXPORTING it_return   = lt_return
                               IMPORTING es_reported = DATA(lt_reported) ).

    reported = CORRESPONDING #( DEEP lt_reported ).

  ENDMETHOD.


  METHOD fragmentusedstock.

    DATA: lt_emissao TYPE STANDARD TABLE OF zi_mm_administrar_emissao_nf.

* ---------------------------------------------------------------------------
* Recupera a chave e os novos dados informados
* ---------------------------------------------------------------------------
    lt_emissao[] = VALUE #( FOR ls_keys IN keys ( material                = ls_keys-material
                                                  originplant             = ls_keys-originplant
                                                  originstoragelocation   = ls_keys-originstoragelocation
                                                  batch                   = ls_keys-batch
                                                  originunit              = ls_keys-originunit
                                                  unit                    = ls_keys-unit
                                                  guid                    = ls_keys-guid
                                                  prmdepfecid             = ls_keys-prmdepfecid
                                                  processstep             = ls_keys-processstep
                                                  eantype                 = ls_keys-eantype
                                                  usedstock               = ls_keys-%param-newusedstock ) ).

* ---------------------------------------------------------------------------
* Salva os dados de emissão
* ---------------------------------------------------------------------------
    DATA(lo_events) = NEW zclmm_adm_emissao_nf_events( ).

    lo_events->save_issue( EXPORTING it_emissao_cds = lt_emissao
                           IMPORTING et_return      = DATA(lt_return) ).

* ---------------------------------------------------------------------------
* Retornar mensagens
* ---------------------------------------------------------------------------
    lo_events->build_reported( EXPORTING it_return   = lt_return
                               IMPORTING es_reported = DATA(lt_reported) ).

    reported = CORRESPONDING #( DEEP lt_reported ).



  ENDMETHOD.

  METHOD criaremessa.

    DATA: lt_emissao_cds TYPE STANDARD TABLE OF zi_mm_administrar_emissao_nf.


    SELECT SINGLE low
    FROM ztca_param_val
    WHERE modulo = 'MM'
    AND chave1 = 'LIMITADOR_ITENS'
    AND chave2 = 'QTDE_ITENS_NF'
    AND chave3 IS INITIAL
    INTO @DATA(lv_limitador_itens).


    LOOP AT keys ASSIGNING FIELD-SYMBOL(<fs_key>).

      IF <fs_key>-%param-newcarrier IS INITIAL.

        APPEND VALUE #( %tky                = <fs_key>-%tky ) TO failed-emissao.

        APPEND VALUE #( %tky                = <fs_key>-%tky
                        %msg                = new_message(  id       = 'ZMM_DEPOSITO_FECHADO'
                                                            number   = '042' " Document cannot be extended into the past
                                                            severity = if_abap_behv_message=>severity-error )
                        %element-newcarrier = if_abap_behv=>mk-on ) TO reported-emissao.

        DATA(lv_error) = abap_true.
      ENDIF.

    ENDLOOP.

    CHECK lv_error = abap_false.


    lt_emissao_cds[] = VALUE #( FOR ls_keys IN keys ( material              = ls_keys-material
                                                      originplant           = ls_keys-originplant
                                                      originstoragelocation = ls_keys-originstoragelocation
                                                      originunit            = ls_keys-originunit
                                                      unit                  = ls_keys-unit
                                                      guid                  = ls_keys-guid
                                                      batch                 = ls_keys-batch
                                                      processstep           = ls_keys-processstep
                                                      prmdepfecid           = ls_keys-prmdepfecid
                                                      eantype               = ls_keys-eantype
                                                      newcarrier            = ls_keys-%param-newcarrier
                                                      newdriver             = ls_keys-%param-newdriver
                                                      newequipment          = ls_keys-%param-newequipment
                                                      newshippingconditions = ls_keys-%param-newshippingconditions
                                                      newshippingtype       = ls_keys-%param-newshippingtype
                                                      newequipmenttow1      = ls_keys-%param-newequipmenttow1
                                                      newequipmenttow2      = ls_keys-%param-newequipmenttow2
                                                      newequipmenttow3      = ls_keys-%param-newequipmenttow3
                                                      newfreightmode        = ls_keys-%param-newfreightmode ) ).

* ---------------------------------------------------------------------------
* Cria NFe
* ---------------------------------------------------------------------------
    DATA(lo_events) = NEW zclmm_adm_emissao_nf_events( ).


    IF lv_limitador_itens IS NOT INITIAL.
      IF lines( keys ) > lv_limitador_itens.
        DATA(lt_return) = VALUE bapiret2_t( ( type = 'E' id = 'ZMM_DEPOSITO_FECHADO' number = '041' message_v1 = lv_limitador_itens ) ).

        lo_events->build_reported( EXPORTING it_return   = lt_return
                                   IMPORTING es_reported = DATA(lt_reported) ).

        reported = CORRESPONDING #( DEEP lt_reported ).

        RETURN.
      ENDIF.
    ENDIF.

    lo_events->create_documents_f02( EXPORTING it_emissao_cds = lt_emissao_cds[]
                                     IMPORTING et_return      = lt_return ).
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
    lo_events->build_reported( EXPORTING it_return   = lt_return
                               IMPORTING es_reported = lt_reported ).

    reported = CORRESPONDING #( DEEP lt_reported ).

  ENDMETHOD.

  METHOD criaremesimb.

    DATA: lt_emissao_cds TYPE STANDARD TABLE OF zi_mm_administrar_emissao_nf.


    SELECT SINGLE low
    FROM ztca_param_val
    WHERE modulo = 'MM'
    AND chave1 = 'LIMITADOR_ITENS'
    AND chave2 = 'QTDE_ITENS_NF'
    AND chave3 IS INITIAL
    INTO @DATA(lv_limitador_itens).


    lt_emissao_cds[] = VALUE #( FOR ls_keys IN keys ( material              = ls_keys-material
                                                      originplant           = ls_keys-originplant
                                                      originstoragelocation = ls_keys-originstoragelocation
                                                      originunit            = ls_keys-originunit
                                                      unit                  = ls_keys-unit
                                                      guid                  = ls_keys-guid
                                                      batch                 = ls_keys-batch
                                                      processstep           = ls_keys-processstep
                                                      prmdepfecid           = ls_keys-prmdepfecid
                                                      eantype               = ls_keys-eantype ) ).

* ---------------------------------------------------------------------------
* Cria NFe
* ---------------------------------------------------------------------------
    DATA(lo_events) = NEW zclmm_adm_emissao_nf_events( ).


    IF lv_limitador_itens IS NOT INITIAL.
      IF lines( keys ) > lv_limitador_itens.
        DATA(lt_return) = VALUE bapiret2_t( ( type = 'E' id = 'ZMM_DEPOSITO_FECHADO' number = '041' message_v1 = lv_limitador_itens ) ).

        lo_events->build_reported( EXPORTING it_return   = lt_return
                                   IMPORTING es_reported = DATA(lt_reported) ).

        reported = CORRESPONDING #( DEEP lt_reported ).

        RETURN.
      ENDIF.
    ENDIF.



    lo_events->create_documents_f02( EXPORTING it_emissao_cds = lt_emissao_cds[]
                                     IMPORTING et_return      = lt_return ).

* ---------------------------------------------------------------------------
* Retornar mensagens
* ---------------------------------------------------------------------------
    lo_events->build_reported( EXPORTING it_return   = lt_return
                               IMPORTING es_reported = lt_reported ).

    reported = CORRESPONDING #( DEEP lt_reported ).

  ENDMETHOD.

  METHOD criaorderfrete.
    DATA: lt_emissao_cds TYPE STANDARD TABLE OF zi_mm_administrar_emissao_nf.

    DATA(lo_events) = NEW zclmm_adm_emissao_nf_events( ).

    lt_emissao_cds[] = VALUE #( FOR ls_keys IN keys ( material              = ls_keys-material
                                                      originplant           = ls_keys-originplant
                                                      originstoragelocation = ls_keys-originstoragelocation
                                                      originunit            = ls_keys-originunit
                                                      unit                  = ls_keys-unit
                                                      guid                  = ls_keys-guid
                                                      batch                 = ls_keys-batch
                                                      processstep           = ls_keys-processstep
                                                      prmdepfecid           = ls_keys-prmdepfecid ) ).


    lo_events->create_ordem_frete( EXPORTING it_emissao_cds = lt_emissao_cds[]
                                     IMPORTING et_return      = DATA(lt_return) ).

* ---------------------------------------------------------------------------
* Retornar mensagens
* ---------------------------------------------------------------------------
    lo_events->build_reported( EXPORTING it_return   = lt_return
                               IMPORTING es_reported = DATA(lt_reported) ).

    reported = CORRESPONDING #( DEEP lt_reported ).

  ENDMETHOD.

  METHOD continuarprocesso.
    DATA: lt_emissao_cds TYPE STANDARD TABLE OF zi_mm_administrar_emissao_nf.

    DATA(lo_events) = NEW zclmm_adm_emissao_nf_events( ).

    lt_emissao_cds[] = VALUE #( FOR ls_keys IN keys ( material              = ls_keys-material
                                                      originplant           = ls_keys-originplant
                                                      originstoragelocation = ls_keys-originstoragelocation
                                                      originunit            = ls_keys-originunit
                                                      unit                  = ls_keys-unit
                                                      guid                  = ls_keys-guid
                                                      batch                 = ls_keys-batch
                                                      processstep           = ls_keys-processstep
                                                      prmdepfecid           = ls_keys-prmdepfecid ) ).

    lo_events->retry_process( EXPORTING it_emissao_cds = lt_emissao_cds[]
                                    IMPORTING et_return      = DATA(lt_return) ).

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

CLASS lcl_zi_mm_administrar_emissao_ DEFINITION INHERITING FROM cl_abap_behavior_saver.
  PROTECTED SECTION.

    METHODS check_before_save REDEFINITION.

    METHODS finalize          REDEFINITION.

    METHODS save              REDEFINITION.

ENDCLASS.

CLASS lcl_zi_mm_administrar_emissao_ IMPLEMENTATION.

  METHOD check_before_save.
    RETURN.
  ENDMETHOD.

  METHOD finalize.
    RETURN.
  ENDMETHOD.

  METHOD save.
    RETURN.
  ENDMETHOD.

ENDCLASS.
