CLASS lcl_Item DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS update FOR MODIFY
      IMPORTING entities FOR UPDATE Item.

    METHODS read FOR READ
      IMPORTING keys FOR READ Item RESULT result.

    METHODS rba_Header FOR READ
      IMPORTING keys_rba FOR READ Item\_Header FULL result_requested RESULT result LINK association_links.

ENDCLASS.

CLASS lcl_Item IMPLEMENTATION.

  METHOD update.

    DATA: lt_emissao TYPE STANDARD TABLE OF zi_mm_administrar_emissao_nf.



* ---------------------------------------------------------------------------
* Recupera dados das linhas selecionadas
* ---------------------------------------------------------------------------
    READ ENTITIES OF zi_mm_admin_emissao_nf_cab IN LOCAL MODE ENTITY Item
      ALL FIELDS
      WITH CORRESPONDING #( entities )
      RESULT DATA(lt_result)
      FAILED failed.

* ---------------------------------------------------------------------------
* Recupera a chave e os novos dados informados
* ---------------------------------------------------------------------------
    lt_emissao[] = CORRESPONDING #( lt_result ).

    LOOP AT lt_emissao REFERENCE INTO DATA(ls_emissao).
      ls_emissao->UsedStock = ls_emissao->UsedStock_conve.
    ENDLOOP.

* ---------------------------------------------------------------------------
* Salva os dados de emissão
* ---------------------------------------------------------------------------
    DATA(lo_events) = NEW zclmm_adm_emissao_nf_events( ).

    lo_events->save_issue( EXPORTING it_emissao_cds = lt_emissao
                                     iv_checkbox    = abap_false
                           IMPORTING et_return      = DATA(lt_return) ).

* ---------------------------------------------------------------------------
* Retornar mensagens
* ---------------------------------------------------------------------------
    lo_events->build_reported( EXPORTING it_return   = lt_return
                               IMPORTING es_reported = DATA(lt_reported) ).

    reported = CORRESPONDING #( DEEP lt_reported ).

  ENDMETHOD.

  METHOD read.

* ---------------------------------------------------------------------------
* Recupera os dados de Emissão
* ---------------------------------------------------------------------------
    IF keys[] IS NOT INITIAL.

      SELECT *
        FROM zc_mm_admin_emissao_nf_itm
        FOR ALL ENTRIES IN @keys
        WHERE Status                = @keys-Status
          AND Material              = @keys-Material
          AND OriginPlant           = @keys-OriginPlant
          AND OriginStorageLocation = @keys-OriginStorageLocation
          AND Batch                 = @keys-Batch
          AND OriginUnit            = @keys-OriginUnit
          AND Unit                  = @keys-Unit
          AND guid                  = @keys-Guid
          AND ProcessStep           = @keys-ProcessStep
          AND PrmDepFecId           = @keys-PrmDepFecId
          AND EANType               = @keys-EANType
        INTO CORRESPONDING FIELDS OF TABLE @result.     "#EC CI_SEL_DEL

      IF sy-subrc NE 0.
        FREE result.
      ENDIF.
    ENDIF.

  ENDMETHOD.

  METHOD rba_Header.
    RETURN.
  ENDMETHOD.

ENDCLASS.
