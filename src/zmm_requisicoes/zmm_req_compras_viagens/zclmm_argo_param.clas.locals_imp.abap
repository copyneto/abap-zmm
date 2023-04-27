CLASS lcl_argo DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS checkDate FOR VALIDATE ON SAVE
      IMPORTING keys FOR argo~checkDate.

    METHODS activateParam FOR MODIFY
      IMPORTING keys FOR ACTION argo~activateParam RESULT result.

    METHODS deactivateParam FOR MODIFY
      IMPORTING keys FOR ACTION argo~deactivateParam RESULT result.

    METHODS gelt_features FOR FEATURES
      IMPORTING keys REQUEST requested_features FOR argo RESULT result.

    METHODS authoritycreate FOR VALIDATE ON SAVE
      IMPORTING keys FOR argo~authoritycreate.

    METHODS get_authorizations FOR AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR argo RESULT result.


ENDCLASS.

CLASS lcl_argo IMPLEMENTATION.

  METHOD authorityCreate.

    CONSTANTS lc_area TYPE string VALUE 'VALIDATE_CREATE'.

    READ ENTITIES OF zi_mm_argo_param IN LOCAL MODE
        ENTITY argo
        ALL FIELDS WITH CORRESPONDING #( keys )
        RESULT DATA(lt_data).

    LOOP AT lt_data ASSIGNING FIELD-SYMBOL(<fs_data>).

      IF zclmm_auth_zmmwerks=>werks_create( <fs_data>-werks ) EQ abap_false.

        APPEND VALUE #( %tky        = <fs_data>-%tky
                        %state_area = lc_area )
        TO reported-argo.

        APPEND VALUE #( %tky = <fs_data>-%tky ) TO failed-argo.

        APPEND VALUE #( %tky        = <fs_data>-%tky
                        %state_area = lc_area
                        %msg        = NEW zcxca_authority_check(
                                          severity = if_abap_behv_message=>severity-error
                                          textid   = zcxca_authority_check=>gc_create )
                        %element-werks = if_abap_behv=>mk-on )
          TO reported-argo.
      ENDIF.

      IF zclmm_auth_zmmbukrs=>bukrs_create( <fs_data>-bukrs ) EQ abap_false.

        APPEND VALUE #( %tky        = <fs_data>-%tky
                        %state_area = lc_area )
        TO reported-argo.

        APPEND VALUE #( %tky = <fs_data>-%tky ) TO failed-argo.

        APPEND VALUE #( %tky        = <fs_data>-%tky
                        %state_area = lc_area
                        %msg        = NEW zcxca_authority_check(
                                          severity = if_abap_behv_message=>severity-error
                                          textid   = zcxca_authority_check=>gc_create )
                        %element-bukrs = if_abap_behv=>mk-on )
          TO reported-argo.
      ENDIF.

    ENDLOOP.

  ENDMETHOD.

  METHOD get_authorizations.

    READ ENTITIES OF zi_mm_argo_param IN LOCAL MODE
        ENTITY argo
        ALL FIELDS WITH CORRESPONDING #( keys )
        RESULT DATA(lt_data)
        FAILED failed.

    CHECK lt_data IS NOT INITIAL.

    DATA: lv_update TYPE if_abap_behv=>t_xflag,
          lv_delete TYPE if_abap_behv=>t_xflag.

    LOOP AT lt_data ASSIGNING FIELD-SYMBOL(<fs_data>).

      IF requested_authorizations-%update EQ if_abap_behv=>mk-on.

        IF zclmm_auth_zmmbukrs=>bukrs_update( <fs_data>-bukrs ) AND
           zclmm_auth_zmmwerks=>werks_update( <fs_data>-werks ).
          lv_update = if_abap_behv=>auth-allowed.
        ELSE.
          lv_update = if_abap_behv=>auth-unauthorized.
        ENDIF.

      ENDIF.

      APPEND VALUE #( %tky    = <fs_data>-%tky
                      %update = lv_update )
             TO result.

    ENDLOOP.

  ENDMETHOD.

  METHOD checkDate.

    READ ENTITIES OF zi_mm_argo_param IN LOCAL MODE
      ENTITY argo
        FIELDS ( begda ) WITH CORRESPONDING #( keys )
          RESULT DATA(lt_argo).

    LOOP AT lt_argo INTO DATA(ls_argo).            "#EC CI_LOOP_INTO_WA

      CHECK ls_argo-begda < sy-datum.

      APPEND VALUE #( %tky = ls_argo-%tky ) TO failed-argo.

      APPEND VALUE #( %tky = ls_argo-%tky
                      %msg = new_message( id = gc_msg_dateinvalid-id number = gc_msg_dateinvalid-number severity = if_abap_behv_message=>severity-error ) ) TO reported-argo.

    ENDLOOP.

  ENDMETHOD.

  METHOD activateParam.

    READ ENTITIES OF zi_mm_argo_param IN LOCAL MODE
    ENTITY argo
      FIELDS ( active ) WITH CORRESPONDING #( keys )
        RESULT DATA(lt_argo).

    MODIFY ENTITIES OF zi_mm_argo_param IN LOCAL MODE
      ENTITY argo
        UPDATE FIELDS ( active )
          WITH VALUE #( FOR ls_argo IN lt_argo
                      ( %tky   = ls_argo-%tky
                        active = abap_true ) )
    FAILED failed
    REPORTED reported.

    READ ENTITIES OF zi_mm_argo_param IN LOCAL MODE
      ENTITY argo
        FIELDS ( active ) WITH CORRESPONDING #( keys )
          RESULT lt_argo.

    result = VALUE #( FOR ls_argo IN lt_argo ( %tky = ls_argo-%tky %param = ls_argo ) ).

  ENDMETHOD.

  METHOD deactivateParam.

    READ ENTITIES OF zi_mm_argo_param IN LOCAL MODE
  ENTITY argo
    FIELDS ( active ) WITH CORRESPONDING #( keys )
      RESULT DATA(lt_argo).

    MODIFY ENTITIES OF zi_mm_argo_param IN LOCAL MODE
      ENTITY argo
        UPDATE FIELDS ( active )
          WITH VALUE #( FOR ls_argo IN lt_argo
                      ( %tky   = ls_argo-%tky
                        active = abap_false ) )
    FAILED failed
    REPORTED reported.

    READ ENTITIES OF zi_mm_argo_param IN LOCAL MODE
      ENTITY argo
        FIELDS ( active ) WITH CORRESPONDING #( keys )
          RESULT lt_argo.

    result = VALUE #( FOR ls_argo IN lt_argo ( %tky = ls_argo-%tky %param = ls_argo ) ).

  ENDMETHOD.

  METHOD gelt_features.

    READ ENTITIES OF zi_mm_argo_param IN LOCAL MODE
      ENTITY argo
        FIELDS ( active ) WITH CORRESPONDING #( keys )
          RESULT DATA(lt_argo).

    result = VALUE #( FOR ls_argo IN lt_argo
                         ( %tky = ls_argo-%tky
                           %action-deactivateParam =  COND #( WHEN ls_argo-active = abap_true THEN if_abap_behv=>fc-o-enabled ELSE if_abap_behv=>fc-o-disabled )
                           %action-activateParam =  COND #( WHEN ls_argo-active = abap_false THEN if_abap_behv=>fc-o-enabled ELSE if_abap_behv=>fc-o-disabled ) )
                      ).

  ENDMETHOD.

ENDCLASS.
