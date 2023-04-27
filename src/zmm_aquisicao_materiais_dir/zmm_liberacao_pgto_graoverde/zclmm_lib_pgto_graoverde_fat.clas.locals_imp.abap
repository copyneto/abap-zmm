CLASS lhc__LibPgtoGVFat DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_authorizations FOR AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR _LibPgtoGVFat RESULT result.

    METHODS limparFat FOR MODIFY
      IMPORTING keys FOR ACTION _LibPgtoGVFat~limparFat.

    METHODS marcarFat FOR MODIFY
      IMPORTING keys FOR ACTION _LibPgtoGVFat~marcarFat.

    METHODS get_features FOR FEATURES
      IMPORTING keys REQUEST requested_features FOR _LibPgtoGVFat RESULT result.

ENDCLASS.

CLASS lhc__LibPgtoGVFat IMPLEMENTATION.

  METHOD get_authorizations.
    RETURN.
  ENDMETHOD.

  METHOD limparFat.

    READ ENTITIES OF ZI_MM_LIB_PGTO_APP IN LOCAL MODE
    ENTITY _LibPgtoGVFat
    FIELDS ( Marcado ) WITH CORRESPONDING #( keys )
    RESULT DATA(lt_fat).

    LOOP AT lt_fat ASSIGNING FIELD-SYMBOL(<fs_fat>).

        DELETE FROM ztmm_pag_gv_fat    WHERE bukrs = <fs_fat>-Empresa
                                       AND ebeln   = <fs_fat>-NumDocumentoRef
                                       AND belnr   = <fs_fat>-NumDocumento
                                       AND buzei   = <fs_fat>-Item
                                       AND gjahr   = <fs_fat>-Ano.
    ENDLOOP.

    MODIFY ENTITIES OF ZI_MM_LIB_PGTO_APP IN LOCAL MODE
    ENTITY _LibPgtoGVFat
    UPDATE FIELDS ( Marcado )
    WITH VALUE #( FOR ls_key IN keys ( %tky   = ls_key-%tky
                                    Marcado = space ) )
    FAILED failed
    REPORTED reported.

    READ TABLE lt_fat ASSIGNING FIELD-SYMBOL(<fs_fat_calc>) INDEX 1.
    IF <fs_fat_calc> IS NOT ASSIGNED.
      RETURN.
    ENDIF.

    SELECT SINGLE *
    FROM ZI_MM_LIB_PGTO_TOT
    WHERE Empresa       = @<fs_fat_calc>-Empresa
    AND   Ano           = @<fs_fat_calc>-Ano
    AND   NumDocumento  = @<fs_fat_calc>-NumDocumentoRef
    INTO @DATA(ls_total).

    CHECK sy-subrc IS INITIAL.

    MODIFY ENTITIES OF ZI_MM_LIB_PGTO_APP IN LOCAL MODE
    ENTITY _LibPgtoGVApp
    UPDATE FIELDS ( VlMontanteFatura VlTotal )
    WITH VALUE #( ( %tky          = <fs_fat_calc>-%tky
                    Empresa       = <fs_fat_calc>-Empresa
                    Ano           = <fs_fat_calc>-Ano
                    NumDocumento  = <fs_fat_calc>-NumDocumentoRef
                    VlMontanteFatura = ls_total-VlMontanteFatura
                    VlTotal = ls_total-VlTotal ) )
    FAILED DATA(lt_failed_asso).

  ENDMETHOD.

  METHOD marcarFat.

    DATA: ls_fat TYPE ztmm_pag_gv_fat,
          lv_timestamp TYPE timestampl.

    DATA: lt_return TYPE bapiret2_tab.

    GET TIME STAMP FIELD lv_timestamp.

    READ ENTITIES OF ZI_MM_LIB_PGTO_APP
    ENTITY _LibPgtoGVFat
    ALL FIELDS
    WITH CORRESPONDING #( keys )
    RESULT DATA(lt_fat)
    FAILED failed.

    LOOP AT lt_fat ASSIGNING FIELD-SYMBOL(<fs_fat>).

*        SELECT SINGLE docnum
*        FROM j_1bnfdoc
*        WHERE bukrs = @<fs_fat>-Empresa
*        AND belnr = @<fs_fat>-NumDocumento
*        AND gjahr = @<fs_fat>-Ano
*        INTO @DATA(lv_docnum_fat).

        SELECT SINGLE docnum_com
        FROM ztmm_pag_gv_desc
        WHERE bukrs = @<fs_fat>-Empresa
        AND ebeln = @<fs_fat>-NumDocumentoRef
        AND docnum_fin is initial
        INTO @DATA(lv_docnum_com).

        IF lv_docnum_com IS INITIAL.
            lt_return[] = VALUE #( BASE lt_return ( type = 'E' id = 'ZMM_LIB_PGTO_GV' number = '014' ) ).
        ELSE.
            MOVE-CORRESPONDING <fs_fat> TO ls_fat.
            ls_fat-bukrs = <fs_fat>-Empresa.
            ls_fat-ebeln = <fs_fat>-NumDocumentoRef.
            ls_fat-belnr = <fs_fat>-NumDocumento.
            ls_fat-buzei = <fs_fat>-Item.
            ls_fat-gjahr = <fs_fat>-Ano.
            ls_fat-marcado = 'X'.
            ls_fat-created_at      = lv_timestamp.
            ls_fat-created_by      = sy-uname.
            ls_fat-last_changed_at = lv_timestamp.
            ls_fat-last_changed_by = sy-uname.
            ls_fat-local_last_changed_at = lv_timestamp.
            MODIFY ztmm_pag_gv_fat FROM ls_fat.
        ENDIF.
    ENDLOOP.

    IF lt_return[] IS INITIAL.
        MODIFY ENTITIES OF ZI_MM_LIB_PGTO_APP IN LOCAL MODE ENTITY _LibPgtoGVFat
        UPDATE FIELDS ( Marcado )
        WITH VALUE #( FOR ls_key IN keys ( %tky   = ls_key-%tky
                                        Marcado = abap_true ) )
        FAILED failed
        REPORTED reported.

    ENDIF.
    reported-_libpgtogvapp = VALUE #( FOR ls_return IN lt_return (
                        %tky = COND #( WHEN lt_fat[] IS NOT INITIAL THEN lt_fat[ 1 ]-%tky )
                        %msg = new_message( id       = ls_return-id
                                            number   = ls_return-number
                                            v1       = ls_return-message_v1
                                            v2       = ls_return-message_v2
                                            v3       = ls_return-message_v3
                                            v4       = ls_return-message_v4
                                            severity = CONV #( ls_return-type ) ) ) ).
**********************************************************************
*   Utilizei SideEffects no VS Code.. não precisou atualizar no backend
*    READ TABLE lt_fat ASSIGNING FIELD-SYMBOL(<fs_fat_calc>) INDEX 1.
*    IF <fs_fat_calc> IS NOT ASSIGNED.
*      RETURN.
*    ENDIF.
*
*    SELECT SINGLE *
*    FROM ZI_MM_LIB_PGTO_TOT
*    WHERE Empresa       = @<fs_fat_calc>-Empresa
*    AND   Ano           = @<fs_fat_calc>-Ano
*    AND   NumDocumento  = @<fs_fat_calc>-NumDocumentoRef
*    INTO @DATA(ls_total).
*
*    CHECK sy-subrc IS INITIAL.
*
*    MODIFY ENTITIES OF ZI_MM_LIB_PGTO_APP IN LOCAL MODE
*    ENTITY _LibPgtoGVApp
*    UPDATE FIELDS ( VlMontanteFatura VlTotal )
*    WITH VALUE #( ( %tky          = <fs_fat_calc>-%tky
*                    Empresa       = <fs_fat_calc>-Empresa
*                    Ano           = <fs_fat_calc>-Ano
*                    NumDocumento  = <fs_fat_calc>-NumDocumentoRef
*                    VlMontanteFatura = ls_total-VlMontanteFatura
*                    VlTotal = ls_total-VlTotal ) )
*    FAILED DATA(lt_failed_asso).


  ENDMETHOD.

  METHOD get_features.


    READ ENTITIES OF ZI_MM_LIB_PGTO_APP IN LOCAL MODE
    ENTITY _LibPgtoGVFat
    FIELDS ( Marcado ) WITH CORRESPONDING #( keys )
    RESULT DATA(lt_fat)
    FAILED failed.

    result = VALUE #( FOR ls_fatura IN lt_fat
                    ( %tky              = ls_fatura-%tky
                      %action-marcarFat = COND #( WHEN ls_fatura-Marcado EQ space OR ls_fatura-Marcado IS INITIAL THEN if_abap_behv=>fc-o-enabled ELSE if_abap_behv=>fc-o-disabled  )
                      %action-limparFat = COND #( WHEN ls_fatura-Marcado EQ abap_true THEN if_abap_behv=>fc-o-enabled ELSE if_abap_behv=>fc-o-disabled ) ) ).

  ENDMETHOD.

ENDCLASS.
