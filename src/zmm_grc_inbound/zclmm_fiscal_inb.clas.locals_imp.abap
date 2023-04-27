CLASS lcl_fiscalinb DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS authoritycreate FOR VALIDATE ON SAVE
      IMPORTING keys FOR _fiscalinb~authoritycreate.

    METHODS validatematerial FOR VALIDATE ON SAVE
      IMPORTING keys FOR _fiscalinb~validatematerial.

    METHODS get_features FOR FEATURES
      IMPORTING keys REQUEST requested_features FOR _FiscalInb RESULT result.

    METHODS get_authorizations FOR AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR _fiscalinb RESULT result.

ENDCLASS.

CLASS lcl_fiscalinb IMPLEMENTATION.

  METHOD authoritycreate.

    CONSTANTS lc_area TYPE string VALUE 'VALIDATE_CREATE'.

    READ ENTITIES OF zi_mm_fiscal_inb IN LOCAL MODE
        ENTITY _fiscalinb
        ALL FIELDS WITH CORRESPONDING #( keys )
        RESULT DATA(lt_data).

    LOOP AT lt_data ASSIGNING FIELD-SYMBOL(<fs_data>).

      IF zclmm_auth_zmmmtable=>create( gc_table ) EQ abap_false.

        APPEND VALUE #( %tky        = <fs_data>-%tky
                        %state_area = lc_area )
        TO reported-_fiscalinb.

        APPEND VALUE #( %tky = <fs_data>-%tky ) TO failed-_fiscalinb.

        APPEND VALUE #( %tky        = <fs_data>-%tky
                        %state_area = lc_area
                        %msg        = NEW zcxca_authority_check(
                                          severity = if_abap_behv_message=>severity-error
                                          textid   = zcxca_authority_check=>gc_create ) )
          TO reported-_fiscalinb.
      ENDIF.

    ENDLOOP.

  ENDMETHOD.

  METHOD get_authorizations.

    READ ENTITIES OF zi_mm_fiscal_inb IN LOCAL MODE
    ENTITY _fiscalinb
    ALL FIELDS WITH CORRESPONDING #( keys )
    RESULT DATA(lt_data)
    FAILED failed.

    CHECK lt_data IS NOT INITIAL.

    DATA: lv_update TYPE if_abap_behv=>t_xflag,
          lv_delete TYPE if_abap_behv=>t_xflag.

    LOOP AT lt_data ASSIGNING FIELD-SYMBOL(<fs_data>).

      IF requested_authorizations-%update EQ if_abap_behv=>mk-on.

        IF zclmm_auth_zmmmtable=>update( gc_table ).
          lv_update = if_abap_behv=>auth-allowed.
        ELSE.
          lv_update = if_abap_behv=>auth-unauthorized.
        ENDIF.

      ENDIF.

      IF requested_authorizations-%delete EQ if_abap_behv=>mk-on.

        IF zclmm_auth_zmmmtable=>delete( gc_table ).
          lv_delete = if_abap_behv=>auth-allowed.
        ELSE.
          lv_delete = if_abap_behv=>auth-unauthorized.
        ENDIF.

      ENDIF.

      APPEND VALUE #( %tky = <fs_data>-%tky %update = lv_update %delete = lv_delete ) TO result.

    ENDLOOP.

  ENDMETHOD.

  METHOD validatematerial.

    READ ENTITIES OF zi_mm_fiscal_inb IN LOCAL MODE
        ENTITY _fiscalinb
        ALL FIELDS WITH CORRESPONDING #( keys )
        RESULT DATA(lt_data).

    CHECK lt_data[] IS NOT INITIAL.

    DATA(ls_data) = lt_data[ 1 ].

    IF ls_data-matnr IS NOT INITIAL AND ls_data-lifnr IS INITIAL.


      APPEND VALUE #( %tky        = ls_data-%tky
                      %msg        = new_message(  id       = 'ZMM'
                                                  number   = '009'
                                                  severity = if_abap_behv_message=>severity-error ) )

        TO reported-_fiscalinb.

    ENDIF.

    IF ls_data-UmIn IS INITIAL.
      APPEND VALUE #( %tky        = ls_data-%tky
                      %msg        = new_message(  id       = 'ZMM'
                                                  number   = '010'
                                                  severity = if_abap_behv_message=>severity-error ) )

        TO reported-_fiscalinb.
    ENDIF.

    IF ls_data-UmOut IS INITIAL.
      APPEND VALUE #( %tky        = ls_data-%tky
                      %msg        = new_message(  id       = 'ZMM'
                                                  number   = '011'
                                                  severity = if_abap_behv_message=>severity-error ) )

        TO reported-_fiscalinb.
    ENDIF.

  ENDMETHOD.

  METHOD get_features.

    READ ENTITIES OF ZI_MM_FISCAL_INB IN LOCAL MODE
      ENTITY _FiscalInb
      FIELDS ( Lifnr matnr )
      WITH CORRESPONDING #( keys )
      RESULT DATA(lt_monitor)
      FAILED failed.

  ENDMETHOD.

ENDCLASS.
