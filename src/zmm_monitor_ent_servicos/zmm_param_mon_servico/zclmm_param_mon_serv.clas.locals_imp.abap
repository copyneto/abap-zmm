CLASS lcl_param_monit DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

*    METHODS setctgnota FOR DETERMINE ON SAVE
*      IMPORTING keys FOR param_monit~setctgnota.

    METHODS get_authorizations FOR AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR Param_monit RESULT result.

    METHODS authorityCreate FOR VALIDATE ON SAVE
      IMPORTING keys FOR Param_monit~authorityCreate.

ENDCLASS.

CLASS lcl_param_monit IMPLEMENTATION.

*  METHOD setctgnota.
*
*    CONSTANTS: lc_modulo TYPE ztca_param_val-modulo VALUE 'MM',
*               lc_chave1 TYPE ztca_param_val-chave1 VALUE 'MONITOR_SERVICOS',
*               lc_chave2 TYPE ztca_param_val-chave2 VALUE 'PARAM_MONITOR',
*               lc_chave3 TYPE ztca_param_val-chave3 VALUE 'CTG_NOTA',
*               lc_sign   TYPE char1                 VALUE 'I',
*               lc_opt    TYPE char2                 VALUE 'EQ'.
*
*    SELECT SINGLE low
*      FROM ztca_param_val
*     WHERE modulo = @lc_modulo
*       AND chave1 = @lc_chave1
*       AND chave2 = @lc_chave2
*       AND chave3 = @lc_chave3
*       AND sign   = @lc_sign
*       AND opt    = @lc_opt
*       INTO @DATA(lv_ctgnota).
*
*    IF sy-subrc IS INITIAL.
*
*      MODIFY ENTITIES OF zi_mm_param_mon_serv IN LOCAL MODE
*        ENTITY param_monit
*           UPDATE
*             FIELDS ( j1bnftype )
*             WITH VALUE #( FOR ls_key IN keys
*                             ( %tky   = ls_key-%tky
*                               j1bnftype = lv_ctgnota ) )
*        FAILED DATA(lt_failed)
*        REPORTED DATA(lt_update_reported).
*
*      reported = CORRESPONDING #( DEEP lt_update_reported ).
*
*    ENDIF.
*
*  ENDMETHOD.

  METHOD get_authorizations.

    READ ENTITIES OF zi_mm_param_mon_serv IN LOCAL MODE
        ENTITY Param_monit
        ALL FIELDS WITH CORRESPONDING #( keys )
        RESULT DATA(lt_data)
        FAILED failed.

    CHECK lt_data IS NOT INITIAL.

    DATA: lv_update TYPE if_abap_behv=>t_xflag,
          lv_delete TYPE if_abap_behv=>t_xflag.

    LOOP AT lt_data ASSIGNING FIELD-SYMBOL(<fs_data>).

      IF requested_authorizations-%update EQ if_abap_behv=>mk-on.

        IF zclmm_auth_zmmwerks=>werks_update( <fs_data>-Werks ).
          lv_update = if_abap_behv=>auth-allowed.
        ELSE.
          lv_update = if_abap_behv=>auth-unauthorized.
        ENDIF.

      ENDIF.

      IF requested_authorizations-%delete EQ if_abap_behv=>mk-on.

        IF zclmm_auth_zmmwerks=>werks_delete( <fs_data>-Werks ).
          lv_delete = if_abap_behv=>auth-allowed.
        ELSE.
          lv_delete = if_abap_behv=>auth-unauthorized.
        ENDIF.

      ENDIF.

      APPEND VALUE #( %tky = <fs_data>-%tky
                      %update = lv_update
                      %delete = lv_delete )
             TO result.

    ENDLOOP.

  ENDMETHOD.

  METHOD authorityCreate.

    CONSTANTS lc_area TYPE string VALUE 'VALIDATE_CREATE'.

    READ ENTITIES OF zi_mm_param_mon_serv IN LOCAL MODE
        ENTITY Param_monit
        ALL FIELDS WITH CORRESPONDING #( keys )
        RESULT DATA(lt_data).

    LOOP AT lt_data ASSIGNING FIELD-SYMBOL(<fs_data>).

      IF zclmm_auth_zmmwerks=>werks_create( <fs_data>-Werks ) EQ abap_false.

        APPEND VALUE #( %tky        = <fs_data>-%tky
                        %state_area = lc_area )
        TO reported-param_monit.

        APPEND VALUE #( %tky = <fs_data>-%tky ) TO failed-param_monit.

        APPEND VALUE #( %tky        = <fs_data>-%tky
                        %state_area = lc_area
                        %msg        = NEW zcxca_authority_check(
                                          severity = if_abap_behv_message=>severity-error
                                          textid   = zcxca_authority_check=>gc_create )
                        %element-Werks = if_abap_behv=>mk-on )
          TO reported-param_monit.
      ENDIF.

    ENDLOOP.

  ENDMETHOD.

ENDCLASS.

*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations
