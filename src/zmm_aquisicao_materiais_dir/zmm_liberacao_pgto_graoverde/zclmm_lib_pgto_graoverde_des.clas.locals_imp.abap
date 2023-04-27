CLASS lhc__LibPgtoGVDes DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_authorizations FOR AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR _LibPgtoGVDes RESULT result.

    METHODS limparDes FOR MODIFY
      IMPORTING keys FOR ACTION _LibPgtoGVDes~limparDes.

    METHODS marcarDes FOR MODIFY
      IMPORTING keys FOR ACTION _LibPgtoGVDes~marcarDes.

    METHODS get_features FOR FEATURES
      IMPORTING keys REQUEST requested_features FOR _LibPgtoGVDes RESULT result.

ENDCLASS.

CLASS lhc__LibPgtoGVDes IMPLEMENTATION.

  METHOD get_authorizations.
    RETURN.
  ENDMETHOD.

  METHOD limparDes.

    READ ENTITIES OF ZI_MM_LIB_PGTO_APP IN LOCAL MODE
    ENTITY _LibPgtoGVDes
    FIELDS ( Marcado ) WITH CORRESPONDING #( keys )
    RESULT DATA(lt_des).

    LOOP AT lt_des ASSIGNING FIELD-SYMBOL(<fs_des>).

        DELETE FROM ztmm_pag_gv_des    WHERE bukrs = <fs_des>-Empresa
                                       AND ebeln   = <fs_des>-NumDocumentoRef
                                       AND belnr   = <fs_des>-NumDocumento
                                       AND buzei   = <fs_des>-Item
                                       AND gjahr   = <fs_des>-Ano.
    ENDLOOP.

    MODIFY ENTITIES OF ZI_MM_LIB_PGTO_APP IN LOCAL MODE ENTITY _LibPgtoGVDes
    UPDATE FIELDS ( Marcado )
    WITH VALUE #( FOR ls_key IN keys ( %tky   = ls_key-%tky
                                    Marcado = space ) )
    FAILED failed
    REPORTED reported.

  ENDMETHOD.

  METHOD marcarDes.

    DATA: ls_des TYPE ztmm_pag_gv_des,
          lv_timestamp TYPE timestampl.

    GET TIME STAMP FIELD lv_timestamp.

    READ ENTITIES OF ZI_MM_LIB_PGTO_APP
    ENTITY _LibPgtoGVDes
    ALL FIELDS
    WITH CORRESPONDING #( keys )
    RESULT DATA(lt_des)
    FAILED failed.

    LOOP AT lt_des ASSIGNING FIELD-SYMBOL(<fs_des>).

        MOVE-CORRESPONDING <fs_des> TO ls_des.
        ls_des-bukrs = <fs_des>-Empresa.
        ls_des-ebeln = <fs_des>-NumDocumentoRef.
        ls_des-belnr = <fs_des>-NumDocumento.
        ls_des-buzei = <fs_des>-Item.
        ls_des-gjahr = <fs_des>-Ano.
        ls_des-marcado = 'X'.
        ls_des-created_at      = lv_timestamp.
        ls_des-created_by      = sy-uname.
        ls_des-last_changed_at = lv_timestamp.
        ls_des-last_changed_by = sy-uname.
        ls_des-local_last_changed_at = lv_timestamp.
        MODIFY ztmm_pag_gv_des FROM ls_des.
    ENDLOOP.

    MODIFY ENTITIES OF ZI_MM_LIB_PGTO_APP IN LOCAL MODE ENTITY _LibPgtoGVDes
    UPDATE FIELDS ( Marcado )
    WITH VALUE #( FOR ls_key IN keys ( %tky   = ls_key-%tky
                                    Marcado = abap_true ) )
    FAILED failed
    REPORTED reported.

  ENDMETHOD.

  METHOD get_features.

    READ ENTITIES OF ZI_MM_LIB_PGTO_APP IN LOCAL MODE
    ENTITY _LibPgtoGVDes
    FIELDS ( Marcado ) WITH CORRESPONDING #( keys )
    RESULT DATA(lt_des)
    FAILED failed.

    result = VALUE #( FOR ls_desconto IN lt_des
                    ( %tky              = ls_desconto-%tky
                      %action-marcarDes = COND #( WHEN ls_desconto-Marcado EQ space OR ls_desconto-Marcado IS INITIAL THEN if_abap_behv=>fc-o-enabled ELSE if_abap_behv=>fc-o-disabled  )
                      %action-limparDes = COND #( WHEN ls_desconto-Marcado EQ abap_true THEN if_abap_behv=>fc-o-enabled ELSE if_abap_behv=>fc-o-disabled ) ) ).

  ENDMETHOD.

ENDCLASS.
