CLASS lhc__LibPgtoGVAdi DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_authorizations FOR AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR _LibPgtoGVAdi RESULT result.

    METHODS limparAdi FOR MODIFY
      IMPORTING keys FOR ACTION _LibPgtoGVAdi~limparAdi.

    METHODS marcarAdi FOR MODIFY
      IMPORTING keys FOR ACTION _LibPgtoGVAdi~marcarAdi.

    METHODS get_features FOR FEATURES
      IMPORTING keys REQUEST requested_features FOR _LibPgtoGVAdi RESULT result.

ENDCLASS.

CLASS lhc__LibPgtoGVAdi IMPLEMENTATION.

  METHOD get_authorizations.
    RETURN.
  ENDMETHOD.

  METHOD limparAdi.

    READ ENTITIES OF ZI_MM_LIB_PGTO_APP IN LOCAL MODE
    ENTITY _LibPgtoGVAdi
    FIELDS ( Marcado ) WITH CORRESPONDING #( keys )
    RESULT DATA(lt_adi).

    LOOP AT lt_adi ASSIGNING FIELD-SYMBOL(<fs_adi>).

        DELETE FROM ztmm_pag_gv_adi    WHERE bukrs = <fs_adi>-Empresa
                                       AND ebeln   = <fs_adi>-NumDocumentoRef
                                       AND belnr   = <fs_adi>-NumDocumento
                                       AND buzei   = <fs_adi>-Item
                                       AND gjahr   = <fs_adi>-Ano.
    ENDLOOP.

    MODIFY ENTITIES OF ZI_MM_LIB_PGTO_APP IN LOCAL MODE ENTITY _LibPgtoGVAdi
    UPDATE FIELDS ( Marcado )
    WITH VALUE #( FOR ls_key IN keys ( %tky   = ls_key-%tky
                                    Marcado = space ) )
    FAILED failed
    REPORTED reported.

  ENDMETHOD.

  METHOD marcarAdi.

    DATA: ls_adi TYPE ztmm_pag_gv_adi,
          lv_timestamp TYPE timestampl.

    GET TIME STAMP FIELD lv_timestamp.

    READ ENTITIES OF ZI_MM_LIB_PGTO_APP
    ENTITY _LibPgtoGVAdi
    ALL FIELDS
    WITH CORRESPONDING #( keys )
    RESULT DATA(lt_adi)
    FAILED failed.

    LOOP AT lt_adi ASSIGNING FIELD-SYMBOL(<fs_adi>).

        MOVE-CORRESPONDING <fs_adi> TO ls_adi.
        ls_adi-bukrs = <fs_adi>-Empresa.
        ls_adi-ebeln = <fs_adi>-NumDocumentoRef.
        ls_adi-belnr = <fs_adi>-NumDocumento.
        ls_adi-buzei = <fs_adi>-Item.
        ls_adi-gjahr = <fs_adi>-Ano.
        ls_adi-marcado = 'X'.
        ls_adi-created_at      = lv_timestamp.
        ls_adi-created_by      = sy-uname.
        ls_adi-last_changed_at = lv_timestamp.
        ls_adi-last_changed_by = sy-uname.
        ls_adi-local_last_changed_at = lv_timestamp.
        MODIFY ztmm_pag_gv_adi FROM ls_adi.
    ENDLOOP.

    MODIFY ENTITIES OF ZI_MM_LIB_PGTO_APP IN LOCAL MODE ENTITY _LibPgtoGVAdi
    UPDATE FIELDS ( Marcado )
    WITH VALUE #( FOR ls_key IN keys ( %tky   = ls_key-%tky
                                    Marcado = abap_true ) )
    FAILED failed
    REPORTED reported.

  ENDMETHOD.

  METHOD get_features.

    READ ENTITIES OF ZI_MM_LIB_PGTO_APP IN LOCAL MODE
    ENTITY _LibPgtoGVAdi
    FIELDS ( Marcado ) WITH CORRESPONDING #( keys )
    RESULT DATA(lt_adi)
    FAILED failed.

    result = VALUE #( FOR ls_adiantamento IN lt_adi
                    ( %tky              = ls_adiantamento-%tky
                      %action-marcarAdi = COND #( WHEN ls_adiantamento-Marcado EQ space OR ls_adiantamento-Marcado IS INITIAL THEN if_abap_behv=>fc-o-enabled ELSE if_abap_behv=>fc-o-disabled  )
                      %action-limparAdi = COND #( WHEN ls_adiantamento-Marcado EQ abap_true THEN if_abap_behv=>fc-o-enabled ELSE if_abap_behv=>fc-o-disabled ) ) ).

  ENDMETHOD.

ENDCLASS.
