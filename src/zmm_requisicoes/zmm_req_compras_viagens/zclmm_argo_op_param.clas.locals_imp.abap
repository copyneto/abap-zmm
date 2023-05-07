CLASS lcl_oper DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS checkdate FOR VALIDATE ON SAVE
      IMPORTING keys FOR oper~checkdate.

    METHODS activateoper FOR MODIFY
      IMPORTING keys FOR ACTION oper~activateoper RESULT result.

    METHODS deactivateoper FOR MODIFY
      IMPORTING keys FOR ACTION oper~deactivateoper RESULT result.

    METHODS authoritycreate FOR VALIDATE ON SAVE
      IMPORTING keys FOR oper~authoritycreate.

    METHODS get_features FOR FEATURES
      IMPORTING keys REQUEST requested_features FOR oper RESULT result.

    METHODS get_authorizations FOR AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR oper RESULT result.

ENDCLASS.

CLASS lcl_oper IMPLEMENTATION.

  METHOD checkdate.

    READ ENTITIES OF zi_mm_argo_op_param IN LOCAL MODE
        ENTITY oper
          FIELDS ( begda ) WITH CORRESPONDING #( keys )
            RESULT DATA(lt_argo).

    LOOP AT lt_argo INTO DATA(ls_argo).            "#EC CI_LOOP_INTO_WA

      CHECK ls_argo-begda < sy-datum.

      APPEND VALUE #( %tky = ls_argo-%tky ) TO failed-oper.

      APPEND VALUE #( %tky = ls_argo-%tky
                      %msg = new_message( id = gc_msg_dateinvalid-id number = gc_msg_dateinvalid-number severity = if_abap_behv_message=>severity-error ) ) TO reported-oper.

    ENDLOOP.

  ENDMETHOD.

  METHOD activateoper.

    READ ENTITIES OF zi_mm_argo_op_param IN LOCAL MODE
    ENTITY oper
      FIELDS ( active ) WITH CORRESPONDING #( keys )
        RESULT DATA(lt_argo).

    MODIFY ENTITIES OF zi_mm_argo_op_param IN LOCAL MODE
      ENTITY oper
        UPDATE FIELDS ( active )
          WITH VALUE #( FOR ls_argo IN lt_argo
                      ( %tky   = ls_argo-%tky
                        active = abap_true ) )
    FAILED failed
    REPORTED reported.

    READ ENTITIES OF zi_mm_argo_op_param IN LOCAL MODE
      ENTITY oper
        FIELDS ( active ) WITH CORRESPONDING #( keys )
          RESULT lt_argo.

    result = VALUE #( FOR ls_argo IN lt_argo ( %tky = ls_argo-%tky %param = ls_argo ) ).

  ENDMETHOD.

  METHOD deactivateoper.

    READ ENTITIES OF zi_mm_argo_op_param IN LOCAL MODE
      ENTITY oper
        FIELDS ( active ) WITH CORRESPONDING #( keys )
          RESULT DATA(lt_argo).

    MODIFY ENTITIES OF zi_mm_argo_op_param IN LOCAL MODE
      ENTITY oper
        UPDATE FIELDS ( active )
          WITH VALUE #( FOR ls_argo IN lt_argo
                      ( %tky   = ls_argo-%tky
                        active = abap_false ) )
    FAILED failed
    REPORTED reported.

    READ ENTITIES OF zi_mm_argo_op_param IN LOCAL MODE
      ENTITY oper
        FIELDS ( active ) WITH CORRESPONDING #( keys )
          RESULT lt_argo.

    result = VALUE #( FOR ls_argo IN lt_argo ( %tky = ls_argo-%tky %param = ls_argo ) ).

  ENDMETHOD.

  METHOD get_features.

    READ ENTITIES OF zi_mm_argo_op_param IN LOCAL MODE
        ENTITY oper
          FIELDS ( active ) WITH CORRESPONDING #( keys )
            RESULT DATA(lt_argo).

    result = VALUE #( FOR ls_argo IN lt_argo
                         ( %tky = ls_argo-%tky
                           %action-deactivateoper =  COND #( WHEN ls_argo-active = abap_true
                                                               THEN if_abap_behv=>fc-o-enabled
                                                             ELSE if_abap_behv=>fc-o-disabled )
                           %action-activateoper =  COND #( WHEN ls_argo-active = abap_false
                                                            AND ls_argo-begda >= sy-datum
                                                             THEN if_abap_behv=>fc-o-enabled
                                                           ELSE if_abap_behv=>fc-o-disabled ) )
                      ).

  ENDMETHOD.

  METHOD get_authorizations.

    RETURN.

*    READ ENTITIES OF zi_mm_argo_op_param IN LOCAL MODE
*        ENTITY Oper
*        ALL FIELDS WITH CORRESPONDING #( keys )
*        RESULT DATA(lt_data)
*        FAILED failed.
*
*    CHECK lt_data IS NOT INITIAL.
*
*    DATA: lv_update TYPE if_abap_behv=>t_xflag,
*          lv_delete TYPE if_abap_behv=>t_xflag.
*
*    LOOP AT lt_data ASSIGNING FIELD-SYMBOL(<fs_data>).
*
*      IF requested_authorizations-%update EQ if_abap_behv=>mk-on.
*
*        IF zclmm_auth_zmmmtable=>update( gc_table ).
*          lv_update = if_abap_behv=>auth-allowed.
*        ELSE.
*          lv_update = if_abap_behv=>auth-unauthorized.
*        ENDIF.
*
*      ENDIF.
*
*      APPEND VALUE #( %tky = <fs_data>-%tky %update = lv_update ) TO result.
*
*    ENDLOOP.

  ENDMETHOD.

  METHOD authoritycreate.

    CONSTANTS lc_area TYPE string VALUE 'VALIDATE_CREATE'.

    READ ENTITIES OF zi_mm_argo_op_param IN LOCAL MODE
        ENTITY oper
        ALL FIELDS WITH CORRESPONDING #( keys )
        RESULT DATA(lt_data).

    LOOP AT lt_data ASSIGNING FIELD-SYMBOL(<fs_data>).

      IF zclmm_auth_zmmmtable=>create( gc_table ) EQ abap_false.

        APPEND VALUE #( %tky        = <fs_data>-%tky
                        %state_area = lc_area )
        TO reported-oper.

        APPEND VALUE #( %tky = <fs_data>-%tky ) TO failed-oper.

        APPEND VALUE #( %tky        = <fs_data>-%tky
                        %state_area = lc_area
                        %msg        = NEW zcxca_authority_check(
                                          severity = if_abap_behv_message=>severity-error
                                          textid   = zcxca_authority_check=>gc_create ) )
          TO reported-oper.
      ENDIF.

    ENDLOOP.

  ENDMETHOD.

ENDCLASS.
