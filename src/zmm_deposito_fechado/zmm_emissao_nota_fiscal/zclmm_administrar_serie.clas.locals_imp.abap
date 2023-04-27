CLASS lcl_Serie DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_features FOR FEATURES
      IMPORTING keys REQUEST requested_features FOR Serie RESULT result.

    METHODS delete FOR MODIFY
      IMPORTING keys FOR DELETE Serie.

    METHODS update FOR MODIFY
      IMPORTING entities FOR UPDATE Serie.

    METHODS read FOR READ
      IMPORTING keys FOR READ Serie RESULT result.

    METHODS rba_Emissao FOR READ
      IMPORTING keys_rba FOR READ Serie\_Emissao FULL result_requested RESULT result LINK association_links.

ENDCLASS.

CLASS lcl_Serie IMPLEMENTATION.


  METHOD get_features.

* ---------------------------------------------------------------------------
* Recupera dados das linhas selecionadas
* ---------------------------------------------------------------------------
    READ ENTITIES OF zi_mm_administrar_emissao_nf IN LOCAL MODE ENTITY Emissao
      ALL FIELDS
      WITH CORRESPONDING #( keys )
      RESULT DATA(lt_emissao)
      FAILED failed.

    TRY.
        DATA(ls_emissao) = lt_emissao[ 1 ].
      CATCH cx_root.
    ENDTRY.

* ---------------------------------------------------------------------------
* Atualiza permissões de cada linha
* ---------------------------------------------------------------------------
    result = VALUE #( FOR ls_keys IN keys

                    ( %tky                              = ls_keys-%tky

                      %update                           = if_abap_behv=>fc-o-disabled

                      %delete                           = COND #( WHEN ls_emissao-Status EQ zclmm_adm_emissao_nf_events=>gc_status-inicial
                                                                    OR ls_emissao-Status EQ zclmm_adm_emissao_nf_events=>gc_status-em_processamento
                                                          THEN if_abap_behv=>fc-o-enabled
                                                          ELSE if_abap_behv=>fc-o-disabled )
                    ) ).

  ENDMETHOD.


  METHOD delete.

* ---------------------------------------------------------------------------
* Recupera dados das linhas selecionadas
* ---------------------------------------------------------------------------
    READ ENTITIES OF zi_mm_administrar_emissao_nf IN LOCAL MODE ENTITY Emissao
      ALL FIELDS
      WITH CORRESPONDING #( keys )
      RESULT DATA(lt_emissao_cds)
      FAILED failed.

    READ ENTITIES OF zi_mm_administrar_emissao_nf IN LOCAL MODE ENTITY Serie
      ALL FIELDS
      WITH CORRESPONDING #( keys )
      RESULT DATA(lt_serie_cds)
      FAILED failed.

* ---------------------------------------------------------------------------
* Elimina registros
* ---------------------------------------------------------------------------
    DATA(lo_events) = NEW zclmm_adm_emissao_nf_events(  ).

    lo_events->delete_series( EXPORTING it_emissao_cds = CORRESPONDING #( lt_emissao_cds )
                                        it_serie_cds   = CORRESPONDING #( lt_serie_cds )
                              IMPORTING et_return      = DATA(lt_return) ).

* ---------------------------------------------------------------------------
* Retornar mensagens
* ---------------------------------------------------------------------------
    lo_events->build_reported( EXPORTING it_return   = lt_return
                               IMPORTING es_reported = DATA(lt_reported) ).

    reported = CORRESPONDING #( DEEP lt_reported ).

  ENDMETHOD.

  METHOD update.
    RETURN.
  ENDMETHOD.

  METHOD read.

* ---------------------------------------------------------------------------
* Recupera os dados de série
* ---------------------------------------------------------------------------
    CHECK keys[] IS NOT INITIAL.

    IF NOT line_exists( keys[ SerialNo = space ] ).

      SELECT DISTINCT *
        FROM zi_mm_administrar_serie
        FOR ALL ENTRIES IN @keys
        WHERE Material              = @keys-Material
          AND OriginPlant           = @keys-OriginPlant
          AND OriginStorageLocation = @keys-OriginStorageLocation
          AND Batch                 = @keys-Batch
          AND OriginUnit            = @keys-OriginUnit
          AND Unit                  = @keys-Unit
          AND guid                  = @keys-Guid
          AND ProcessStep           = @keys-ProcessStep
          and PrmDepFecId           = @keys-PrmDepFecId
          AND SerialNo              = @keys-SerialNo
        INTO CORRESPONDING FIELDS OF TABLE @result.     "#EC CI_SEL_DEL

    ELSE.

      SELECT DISTINCT *
        FROM zi_mm_administrar_serie
        FOR ALL ENTRIES IN @keys
        WHERE Material              = @keys-Material
          AND OriginPlant           = @keys-OriginPlant
          AND OriginStorageLocation = @keys-OriginStorageLocation
          AND Batch                 = @keys-Batch
          AND OriginUnit            = @keys-OriginUnit
          AND Unit                  = @keys-Unit
          AND guid                  = @keys-Guid
          AND ProcessStep           = @keys-ProcessStep
          AND PrmDepFecId           = @keys-PrmDepFecId
        INTO CORRESPONDING FIELDS OF TABLE @result.     "#EC CI_SEL_DEL

    ENDIF.

    IF sy-subrc NE 0.
      FREE result.
    ENDIF.

  ENDMETHOD.

  METHOD rba_Emissao.

* ---------------------------------------------------------------------------
* Recupera os dados de Emissão
* ---------------------------------------------------------------------------
    IF keys_rba[] IS NOT INITIAL.

      SELECT *
        FROM zi_mm_administrar_emissao_nf
        FOR ALL ENTRIES IN @keys_rba
        WHERE Material              = @keys_rba-Material
          AND OriginPlant           = @keys_rba-OriginPlant
          AND OriginStorageLocation = @keys_rba-OriginStorageLocation
          AND Batch                 = @keys_rba-Batch
          AND OriginUnit            = @keys_rba-OriginUnit
          AND Unit                  = @keys_rba-Unit
          AND guid                  = @keys_rba-Guid
          AND ProcessStep           = @keys_rba-ProcessStep
          AND PrmDepFecId           = @keys_rba-PrmDepFecId
        INTO CORRESPONDING FIELDS OF TABLE @result.     "#EC CI_SEL_DEL

      IF sy-subrc NE 0.
        FREE result.
      ENDIF.
    ENDIF.

  ENDMETHOD.

ENDCLASS.
