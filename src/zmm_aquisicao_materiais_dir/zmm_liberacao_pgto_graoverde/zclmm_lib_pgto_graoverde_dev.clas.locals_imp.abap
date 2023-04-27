CLASS lhc__LibPgtoGVDev DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_authorizations FOR AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR _LibPgtoGVDev RESULT result.

    METHODS limparDev FOR MODIFY
      IMPORTING keys FOR ACTION _LibPgtoGVDev~limparDev.

    METHODS marcarDev FOR MODIFY
      IMPORTING keys FOR ACTION _LibPgtoGVDev~marcarDev.

    METHODS get_features FOR FEATURES
      IMPORTING keys REQUEST requested_features FOR _LibPgtoGVDev RESULT result.

ENDCLASS.

CLASS lhc__LibPgtoGVDev IMPLEMENTATION.

  METHOD get_authorizations.
    RETURN.
  ENDMETHOD.

  METHOD limparDev.

    READ ENTITIES OF ZI_MM_LIB_PGTO_APP IN LOCAL MODE
    ENTITY _LibPgtoGVDev
    FIELDS ( Marcado ) WITH CORRESPONDING #( keys )
    RESULT DATA(lt_dev).

    LOOP AT lt_dev ASSIGNING FIELD-SYMBOL(<fs_dev>).

        DELETE FROM ztmm_pag_gv_dev    WHERE bukrs = <fs_dev>-Empresa
                                       AND ebeln   = <fs_dev>-NumDocumentoRef
                                       AND belnr   = <fs_dev>-NumDocumento
                                       AND buzei   = <fs_dev>-Item
                                       AND gjahr   = <fs_dev>-Ano.
    ENDLOOP.

    MODIFY ENTITIES OF ZI_MM_LIB_PGTO_APP IN LOCAL MODE ENTITY _LibPgtoGVDev
    UPDATE FIELDS ( Marcado )
    WITH VALUE #( FOR ls_key IN keys ( %tky   = ls_key-%tky
                                    Marcado = space ) )
    FAILED failed
    REPORTED reported.

  ENDMETHOD.

  METHOD marcarDev.

    DATA: ls_dev TYPE ztmm_pag_gv_dev,
          lv_timestamp TYPE timestampl.

    GET TIME STAMP FIELD lv_timestamp.

    READ ENTITIES OF ZI_MM_LIB_PGTO_APP
    ENTITY _LibPgtoGVDev
    ALL FIELDS
    WITH CORRESPONDING #( keys )
    RESULT DATA(lt_dev)
    FAILED failed.

    LOOP AT lt_dev ASSIGNING FIELD-SYMBOL(<fs_dev>).

        MOVE-CORRESPONDING <fs_dev> TO ls_dev.
        ls_dev-bukrs = <fs_dev>-Empresa.
        ls_dev-ebeln = <fs_dev>-NumDocumentoRef.
        ls_dev-belnr = <fs_dev>-NumDocumento.
        ls_dev-buzei = <fs_dev>-Item.
        ls_dev-gjahr = <fs_dev>-Ano.
        ls_dev-marcado = 'X'.
        ls_dev-created_at      = lv_timestamp.
        ls_dev-created_by      = sy-uname.
        ls_dev-last_changed_at = lv_timestamp.
        ls_dev-last_changed_by = sy-uname.
        ls_dev-local_last_changed_at = lv_timestamp.
        MODIFY ztmm_pag_gv_dev FROM ls_dev.
    ENDLOOP.

    MODIFY ENTITIES OF ZI_MM_LIB_PGTO_APP IN LOCAL MODE ENTITY _LibPgtoGVDev
    UPDATE FIELDS ( Marcado )
    WITH VALUE #( FOR ls_key IN keys ( %tky   = ls_key-%tky
                                    Marcado = abap_true ) )
    FAILED failed
    REPORTED reported.

  ENDMETHOD.

  METHOD get_features.

    READ ENTITIES OF ZI_MM_LIB_PGTO_APP IN LOCAL MODE
    ENTITY _LibPgtoGVDev
    FIELDS ( Marcado ) WITH CORRESPONDING #( keys )
    RESULT DATA(lt_dev)
    FAILED failed.

    result = VALUE #( FOR ls_devolucao IN lt_dev
                    ( %tky              = ls_devolucao-%tky
                      %action-marcarDev = COND #( WHEN ls_devolucao-Marcado EQ space OR ls_devolucao-Marcado IS INITIAL THEN if_abap_behv=>fc-o-enabled ELSE if_abap_behv=>fc-o-disabled  )
                      %action-limparDev = COND #( WHEN ls_devolucao-Marcado EQ abap_true THEN if_abap_behv=>fc-o-enabled ELSE if_abap_behv=>fc-o-disabled ) ) ).

  ENDMETHOD.

ENDCLASS.
