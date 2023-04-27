CLASS lcl_catalogorfb DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.
    CONSTANTS gc_table TYPE tabname_auth VALUE 'ZTMM_CATALOGORFB'.

    METHODS validadatas FOR VALIDATE ON SAVE
      IMPORTING keys FOR catalogorfb~validadatas.

    METHODS authorityCreate FOR VALIDATE ON SAVE
      IMPORTING keys FOR CatalogoRFB~authorityCreate.

    METHODS get_authorizations FOR AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR CatalogoRFB RESULT result.

ENDCLASS.

CLASS lcl_catalogorfb IMPLEMENTATION.

  METHOD validadatas.

    READ ENTITIES OF zi_mm_catalogo_produtos_rfb
      ENTITY catalogorfb
        FIELDS ( datefrom dateto ) WITH CORRESPONDING #( keys )
      RESULT DATA(lt_catalogo_rfb)
      FAILED DATA(lt_failed).

    LOOP AT lt_catalogo_rfb ASSIGNING FIELD-SYMBOL(<fs_catalogo_rfb>).
      IF <fs_catalogo_rfb>-dateto LT <fs_catalogo_rfb>-datefrom.
        APPEND VALUE #( %tky = <fs_catalogo_rfb>-%tky ) TO failed-catalogorfb.

        APPEND VALUE #(
          %tky = <fs_catalogo_rfb>-%tky

          %msg =  new_message( id       = 'ZMM_RFB'
                               number   = '003'
                               severity = if_abap_behv_message=>severity-error )

          %element = VALUE #( datefrom = if_abap_behv=>mk-on
                              dateto   = if_abap_behv=>mk-on ) ) TO reported-catalogorfb.
      ENDIF.
    ENDLOOP.

  ENDMETHOD.


  METHOD authoritycreate.

    CONSTANTS lc_area TYPE string VALUE 'VALIDATE_CREATE'.

    READ ENTITIES OF zi_mm_catalogo_produtos_rfb IN LOCAL MODE
        ENTITY CatalogoRFB
        ALL FIELDS WITH CORRESPONDING #( keys )
        RESULT DATA(lt_data).

    LOOP AT lt_data ASSIGNING FIELD-SYMBOL(<fs_data>).

      IF zclmm_auth_zmmmtable=>create( gc_table ) = abap_false.

        APPEND VALUE #( %tky        = <fs_data>-%tky
                        %state_area = lc_area )
        TO reported-catalogorfb.

        APPEND VALUE #( %tky = <fs_data>-%tky ) TO failed-catalogorfb.

        APPEND VALUE #( %tky        = <fs_data>-%tky
                        %state_area = lc_area
                        %msg        = NEW zcxca_authority_check(
                                          severity = if_abap_behv_message=>severity-error
                                          textid   = zcxca_authority_check=>gc_create )
                        %element-material = if_abap_behv=>mk-on )
          TO reported-catalogorfb.
      ENDIF.

    ENDLOOP.

  ENDMETHOD.

  METHOD get_authorizations.
    READ ENTITIES OF zi_mm_catalogo_produtos_rfb IN LOCAL MODE
        ENTITY CatalogoRFB
        ALL FIELDS WITH CORRESPONDING #( keys )
        RESULT DATA(lt_data)
        FAILED failed.

    CHECK lt_data IS NOT INITIAL.

    DATA: lv_update TYPE if_abap_behv=>t_xflag,
          lv_delete TYPE if_abap_behv=>t_xflag.

    LOOP AT lt_data ASSIGNING FIELD-SYMBOL(<fs_data>).

      IF requested_authorizations-%update EQ if_abap_behv=>mk-on.

        IF zclmm_auth_zmmmtable=>update( gc_table ) = abap_true.
          lv_update = if_abap_behv=>auth-allowed.
        ELSE.
          lv_update = if_abap_behv=>auth-unauthorized.
        ENDIF.

      ENDIF.

      IF requested_authorizations-%delete EQ if_abap_behv=>mk-on.

        IF zclmm_auth_zmmmtable=>delete( gc_table ) = abap_true.
          lv_delete = if_abap_behv=>auth-allowed.
        ELSE.
          lv_delete = if_abap_behv=>auth-unauthorized.
        ENDIF.

      ENDIF.

      APPEND VALUE #( %tky          = <fs_data>-%tky
                      %update       = lv_update
                      %delete       = lv_delete )
             TO result.
    ENDLOOP.
  ENDMETHOD.

ENDCLASS.
