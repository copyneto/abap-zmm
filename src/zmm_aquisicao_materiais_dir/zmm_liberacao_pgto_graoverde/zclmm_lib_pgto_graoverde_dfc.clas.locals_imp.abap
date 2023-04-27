CLASS lhc__LibPgtoGVDesFinCom DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_authorizations FOR AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR _LibPgtoGVDesFinCom RESULT result.

    METHODS limparDesFinCom FOR MODIFY
      IMPORTING keys FOR ACTION _LibPgtoGVDesFinCom~limparDesFinCom.

    METHODS marcarDesFinCom FOR MODIFY
      IMPORTING keys FOR ACTION _LibPgtoGVDesFinCom~marcarDesFinCom.

    METHODS get_features FOR FEATURES
      IMPORTING keys REQUEST requested_features FOR _LibPgtoGVDesFinCom RESULT result.

    METHODS setUser FOR DETERMINE ON MODIFY
      IMPORTING keys FOR _LibPgtoGVDesFinCom~setUser.

ENDCLASS.

CLASS lhc__LibPgtoGVDesFinCom IMPLEMENTATION.

  METHOD get_authorizations.
    RETURN.
  ENDMETHOD.

  METHOD limparDesFinCom.

    READ ENTITIES OF ZI_MM_LIB_PGTO_APP IN LOCAL MODE
    ENTITY _LibPgtoGVDesFinCom
    FIELDS ( Marcado ) WITH CORRESPONDING #( keys )
    RESULT DATA(lt_des_fin_com).

    LOOP AT lt_des_fin_com ASSIGNING FIELD-SYMBOL(<fs_des_fi_com>).

        DELETE FROM ztmm_pag_gv_dfc    WHERE guid = <fs_des_fi_com>-Guid
                                       AND bukrs   = <fs_des_fi_com>-Empresa
                                       AND ebeln   = <fs_des_fi_com>-NumDocumento
                                       AND gjahr   = <fs_des_fi_com>-Ano.
    ENDLOOP.

    MODIFY ENTITIES OF ZI_MM_LIB_PGTO_APP IN LOCAL MODE ENTITY _LibPgtoGVDesFinCom
    UPDATE FIELDS ( Marcado )
    WITH VALUE #( FOR ls_key IN keys ( %tky   = ls_key-%tky
                                    Marcado = space ) )
    FAILED failed
    REPORTED reported.

  ENDMETHOD.

  METHOD marcarDesFinCom.

    DATA: ls_des_fin_com TYPE ztmm_pag_gv_dfc,
          lv_timestamp TYPE timestampl.

    GET TIME STAMP FIELD lv_timestamp.

    READ ENTITIES OF ZI_MM_LIB_PGTO_APP
    ENTITY _LibPgtoGVDesFinCom
    ALL FIELDS
    WITH CORRESPONDING #( keys )
    RESULT DATA(lt_des_fin_com)
    FAILED failed.

    LOOP AT lt_des_fin_com ASSIGNING FIELD-SYMBOL(<fs_des_fin_com>).

        MOVE-CORRESPONDING <fs_des_fin_com> TO ls_des_fin_com.
        ls_des_fin_com-guid = <fs_des_fin_com>-Guid.
        ls_des_fin_com-bukrs = <fs_des_fin_com>-Empresa.
        ls_des_fin_com-ebeln = <fs_des_fin_com>-NumDocumento.
        ls_des_fin_com-gjahr = <fs_des_fin_com>-Ano.
        ls_des_fin_com-marcado         = 'X'.
        ls_des_fin_com-created_at      = lv_timestamp.
        ls_des_fin_com-created_by      = sy-uname.
        ls_des_fin_com-last_changed_at = lv_timestamp.
        ls_des_fin_com-last_changed_by = sy-uname.
        ls_des_fin_com-local_last_changed_at = lv_timestamp.
        MODIFY ztmm_pag_gv_dfc FROM ls_des_fin_com.
    ENDLOOP.

    MODIFY ENTITIES OF ZI_MM_LIB_PGTO_APP IN LOCAL MODE ENTITY _LibPgtoGVDesFinCom
    UPDATE FIELDS ( Marcado )
    WITH VALUE #( FOR ls_key IN keys ( %tky   = ls_key-%tky
                                    Marcado = abap_true ) )
    FAILED failed
    REPORTED reported.

  ENDMETHOD.

  METHOD get_features.

    READ ENTITIES OF ZI_MM_LIB_PGTO_APP IN LOCAL MODE
    ENTITY _LibPgtoGVDesFinCom
    FIELDS ( Marcado ) WITH CORRESPONDING #( keys )
    RESULT DATA(lt_des_fin_com)
    FAILED failed.

    result = VALUE #( FOR ls_desconto IN lt_des_fin_com
                    ( %tky              = ls_desconto-%tky
                      %action-marcarDesFinCom = COND #( WHEN ls_desconto-Marcado EQ space OR ls_desconto-Marcado IS INITIAL THEN if_abap_behv=>fc-o-enabled ELSE if_abap_behv=>fc-o-disabled  )
                      %action-limparDesFinCom = COND #( WHEN ls_desconto-Marcado EQ abap_true THEN if_abap_behv=>fc-o-enabled ELSE if_abap_behv=>fc-o-disabled ) ) ).

  ENDMETHOD.

  METHOD setUser.

*    READ ENTITIES OF zi_mm_lib_pgto_app
*        IN LOCAL MODE ENTITY _LibPgtoGVApp BY \_desComFin
*           ALL FIELDS
*           WITH CORRESPONDING #( keys )
*           RESULT DATA(lt_com).
*
*    MODIFY ENTITIES OF ZI_MM_LIB_PGTO_APP IN LOCAL MODE
*    ENTITY _LibPgtoGVDesFinCom
*       UPDATE
*         FIELDS ( UsuarioFin )
*         WITH VALUE #( FOR ls_com IN lt_com
*                         ( %tky   = ls_com-%tky
*                           UsuarioFin = sy-uname ) )
*    FAILED DATA(failed)
*    REPORTED DATA(update_reported).
*
*    reported = CORRESPONDING #( DEEP update_reported ).

    MODIFY ENTITIES OF zi_mm_lib_pgto_app IN LOCAL MODE
    ENTITY _LibPgtoGVDesFinCom
    UPDATE FIELDS ( UsuarioFin DataFin )
    WITH VALUE #( FOR key IN keys
                ( %tky   = key-%tky
                  UsuarioFin = sy-uname
                  datafin = sy-datum ) )
    FAILED DATA(lt_failed)
    REPORTED DATA(lt_update_reported).

    reported = CORRESPONDING #( DEEP lt_update_reported ).

  ENDMETHOD.

ENDCLASS.
