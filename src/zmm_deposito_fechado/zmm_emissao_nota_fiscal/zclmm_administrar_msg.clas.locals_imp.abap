CLASS lcl_mensagem DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS read FOR READ
      IMPORTING keys FOR READ mensagem RESULT result.

    METHODS rba_emissao FOR READ
      IMPORTING keys_rba FOR READ mensagem\_emissao FULL result_requested RESULT result LINK association_links.

ENDCLASS.

CLASS lcl_mensagem IMPLEMENTATION.

  METHOD read.
* ---------------------------------------------------------------------------
* Recupera os dados de série
* ---------------------------------------------------------------------------
    CHECK keys[] IS NOT INITIAL.

      SELECT *
       FROM zi_mm_administrar_msg
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
        INTO CORRESPONDING FIELDS OF TABLE @result.     "#EC CI_SEL_DEL
  ENDMETHOD.

  METHOD rba_emissao.
    return.
  ENDMETHOD.

ENDCLASS.
