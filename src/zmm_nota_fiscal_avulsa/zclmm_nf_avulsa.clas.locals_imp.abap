CLASS lcl_NF DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS checkFieldLength FOR VALIDATE ON SAVE
      IMPORTING keys FOR _nf~checkFieldLength.

    METHODS authorityCreate FOR VALIDATE ON SAVE
      IMPORTING keys FOR _nf~authorityCreate.

    METHODS get_authorizations FOR AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR _nf RESULT result.

ENDCLASS.

CLASS lcl_NF IMPLEMENTATION.

  METHOD checkFieldLength.

    READ ENTITIES OF zi_mm_nf_avulsa IN LOCAL MODE
     ENTITY _nf
      FIELDS ( Stcd1 )
       WITH CORRESPONDING #( keys )
        RESULT DATA(lt_nota).

    LOOP AT lt_nota ASSIGNING FIELD-SYMBOL(<fs_nota>).

      CALL FUNCTION 'CONVERSION_EXIT_CGCBR_INPUT'
        EXPORTING
          input     = <fs_nota>-Stcd1
        IMPORTING
          output    = <fs_nota>-Stcd1
        EXCEPTIONS
          not_valid = 1
          OTHERS    = 2.
      IF sy-subrc <> 0.

        APPEND VALUE #( %tky = <fs_nota>-%tky ) TO failed-_nf.

        APPEND VALUE #( %tky = <fs_nota>-%tky
                        %msg = new_message(       id = gc_msg_stcd1_invalid-id
                                              number = gc_msg_stcd1_invalid-number
                                            severity = if_abap_behv_message=>severity-error
                                                  v1 = <fs_nota>-Stcd1 ) ) TO reported-_nf.

      ENDIF.

    ENDLOOP.

  ENDMETHOD.

  METHOD authoritycreate.

    CONSTANTS lc_area TYPE string VALUE 'VALIDATE_CREATE'.

    READ ENTITIES OF zi_mm_nf_avulsa IN LOCAL MODE
        ENTITY _nf
        ALL FIELDS WITH CORRESPONDING #( keys )
        RESULT DATA(lt_data).

    LOOP AT lt_data ASSIGNING FIELD-SYMBOL(<fs_data>).

      IF zclmm_auth_zmmmtable=>create( gc_table ) EQ abap_false.

        APPEND VALUE #( %tky        = <fs_data>-%tky
                        %state_area = lc_area )
        TO reported-_nf.

        APPEND VALUE #( %tky = <fs_data>-%tky ) TO failed-_nf.

        APPEND VALUE #( %tky        = <fs_data>-%tky
                        %state_area = lc_area
                        %msg        = NEW zcxca_authority_check(
                                          severity = if_abap_behv_message=>severity-error
                                          textid   = zcxca_authority_check=>gc_create ) )
          TO reported-_nf.
      ENDIF.

    ENDLOOP.

  ENDMETHOD.

  METHOD get_authorizations.

    READ ENTITIES OF zi_mm_nf_avulsa IN LOCAL MODE
          ENTITY _nf
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

ENDCLASS.
