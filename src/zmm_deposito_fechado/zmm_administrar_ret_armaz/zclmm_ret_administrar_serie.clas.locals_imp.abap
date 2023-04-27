CLASS lcl_retserie DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS rba_emissao FOR READ
      IMPORTING keys_rba FOR READ retserie\_emissao FULL result_requested RESULT result LINK association_links.

   METHODS get_features FOR FEATURES
      IMPORTING keys REQUEST requested_features FOR RetSerie RESULT result.

    METHODS delete FOR MODIFY
      IMPORTING keys FOR DELETE RetSerie.

    METHODS update FOR MODIFY
      IMPORTING entities FOR UPDATE RetSerie.

    METHODS read FOR READ
      IMPORTING keys FOR READ RetSerie RESULT result.

ENDCLASS.

CLASS lcl_retserie IMPLEMENTATION.

  METHOD delete.

* ---------------------------------------------------------------------------
* Recupera dados das linhas selecionadas
* ---------------------------------------------------------------------------
    READ ENTITIES OF zi_mm_ret_armazenagem_app IN LOCAL MODE ENTITY RetArmazenagem
      ALL FIELDS
      WITH CORRESPONDING #( keys )
      RESULT DATA(lt_emissao_cds)
      FAILED failed.

    READ ENTITIES OF zi_mm_ret_armazenagem_app IN LOCAL MODE ENTITY RetSerie
      ALL FIELDS
      WITH CORRESPONDING #( keys )
      RESULT DATA(lt_serie_cds)
      FAILED failed.

* ---------------------------------------------------------------------------
* Elimina registros
* ---------------------------------------------------------------------------
    DATA(lo_events) = NEW zclmm_adm_emissao_nf_events(  ).

    lo_events->delete_series_retorno( EXPORTING it_ret_serie_cds   = CORRESPONDING #( lt_serie_cds )
                                         IMPORTING et_return      = DATA(lt_return) ).

* ---------------------------------------------------------------------------
* Retornar mensagens
* ---------------------------------------------------------------------------
    lo_events->build_reported( EXPORTING it_return   = lt_return
                               IMPORTING es_reported = DATA(lt_reported) ).

    reported = CORRESPONDING #( DEEP lt_reported ).

  ENDMETHOD.

  METHOD get_features.

* ---------------------------------------------------------------------------
* Recupera dados das linhas selecionadas
* ---------------------------------------------------------------------------
    READ ENTITIES OF zi_mm_ret_armazenagem_app IN LOCAL MODE ENTITY RetArmazenagem
      ALL FIELDS
      WITH CORRESPONDING #( keys )
      RESULT DATA(lt_Armazenagem)
      FAILED failed.

    TRY.
        DATA(ls_Armazenagem) = lt_Armazenagem[ 1 ].
      CATCH cx_root.
    ENDTRY.

* ---------------------------------------------------------------------------
* Atualiza permissões de cada linha
* ---------------------------------------------------------------------------
    result = VALUE #( FOR ls_keys IN keys

                    ( %tky                              = ls_keys-%tky

                      %update                           = if_abap_behv=>fc-o-disabled

                      %delete                           = COND #( WHEN ls_Armazenagem-Status EQ zclmm_adm_emissao_nf_events=>gc_status-inicial
                                                                    OR ls_Armazenagem-Status EQ zclmm_adm_emissao_nf_events=>gc_status-em_processamento
                                                          THEN if_abap_behv=>fc-o-enabled
                                                          ELSE if_abap_behv=>fc-o-disabled )
                    ) ).

  ENDMETHOD.

  METHOD read.

* ---------------------------------------------------------------------------
* Recupera os dados de série
* ---------------------------------------------------------------------------
    CHECK keys[] IS NOT INITIAL.

    IF NOT line_exists( keys[ SerialNo = space ] ).

      SELECT DISTINCT *
        FROM zi_mm_ret_armazenagem_serie
        FOR ALL ENTRIES IN @keys
        WHERE UmbDestino      = @keys-UmbDestino
          and UmbOrigin       = @keys-UmbOrigin
   and NumeroOrdemDeFrete     = @keys-NumeroOrdemDeFrete
  and NumeroDaRemessa         = @keys-NumeroDaRemessa
  and Material                = @keys-Material
  and UmbOrigin               = @keys-UmbOrigin
  and UmbDestino              = @keys-UmbDestino
  and CentroOrigem            = @keys-CentroOrigem
  and DepositoOrigem          = @keys-DepositoOrigem
  and CentroDestino           = @keys-CentroDestino
  and DepositoDestino         = @keys-DepositoDestino
  and Lote                    = @keys-Lote
  and SerialNo                = @keys-SerialNo
        INTO CORRESPONDING FIELDS OF TABLE @result.     "#EC CI_SEL_DEL

    ELSE.

      SELECT DISTINCT *
        FROM zi_mm_ret_armazenagem_serie
        FOR ALL ENTRIES IN @keys
        WHERE UmbDestino      = @keys-UmbDestino
          and UmbOrigin       = @keys-UmbOrigin
   and NumeroOrdemDeFrete     = @keys-NumeroOrdemDeFrete
  and NumeroDaRemessa         = @keys-NumeroDaRemessa
  and Material                = @keys-Material
  and UmbOrigin               = @keys-UmbOrigin
  and UmbDestino              = @keys-UmbDestino
  and CentroOrigem            = @keys-CentroOrigem
  and DepositoOrigem          = @keys-DepositoOrigem
  and CentroDestino           = @keys-CentroDestino
  and DepositoDestino         = @keys-DepositoDestino
  and Lote                    = @keys-Lote
        INTO CORRESPONDING FIELDS OF TABLE @result.     "#EC CI_SEL_DEL

    ENDIF.

    IF sy-subrc NE 0.
      FREE result.
    ENDIF.

  ENDMETHOD.

  METHOD rba_emissao.

* ---------------------------------------------------------------------------
* Recupera os dados de Emissão
* ---------------------------------------------------------------------------
    IF keys_rba[] IS NOT INITIAL.

      SELECT *
        FROM zi_mm_ret_armazenagem_serie
        FOR ALL ENTRIES IN @keys_rba
        WHERE UmbDestino      = @keys_rba-UmbDestino
          and UmbOrigin       = @keys_rba-UmbOrigin
   and NumeroOrdemDeFrete     = @keys_rba-NumeroOrdemDeFrete
  and NumeroDaRemessa         = @keys_rba-NumeroDaRemessa
  and Material                = @keys_rba-Material
  and UmbOrigin               = @keys_rba-UmbOrigin
  and UmbDestino              = @keys_rba-UmbDestino
  and CentroOrigem            = @keys_rba-CentroOrigem
  and DepositoOrigem          = @keys_rba-DepositoOrigem
  and CentroDestino           = @keys_rba-CentroDestino
  and DepositoDestino         = @keys_rba-DepositoDestino
  and Lote                    = @keys_rba-Lote
        INTO CORRESPONDING FIELDS OF TABLE @result.     "#EC CI_SEL_DEL

      IF sy-subrc NE 0.
        FREE result.
      ENDIF.
    ENDIF.
  ENDMETHOD.

  METHOD update.
    RETURN.
  ENDMETHOD.
ENDCLASS.
