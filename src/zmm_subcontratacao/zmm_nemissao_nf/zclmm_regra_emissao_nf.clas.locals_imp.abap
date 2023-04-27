CLASS lhc_Emissao DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    CONSTANTS gc_table TYPE tabname_auth VALUE 'ZTMM_EMISSA_NF'.

    METHODS authorityCreate FOR VALIDATE ON SAVE
      IMPORTING keys FOR Emissao~authorityCreate.

    METHODS get_authorizations FOR AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR Emissao RESULT result.

ENDCLASS.

CLASS lhc_Emissao IMPLEMENTATION.

  METHOD authorityCreate.

    CONSTANTS lc_area TYPE string VALUE 'VALIDATE_CREATE'.

    READ ENTITIES OF ZI_MM_REGRA_EMISSAO_NF IN LOCAL MODE
        ENTITY Emissao
        ALL FIELDS WITH CORRESPONDING #( keys )
        RESULT DATA(lt_data).

    LOOP AT lt_data ASSIGNING FIELD-SYMBOL(<fs_data>).

      IF zclmm_auth_zmmmtable=>create( gc_table ) EQ abap_false.

        APPEND VALUE #( %tky        = <fs_data>-%tky
                        %state_area = lc_area )
        TO reported-emissao.

        APPEND VALUE #( %tky = <fs_data>-%tky ) TO failed-emissao.

        APPEND VALUE #( %tky        = <fs_data>-%tky
                        %state_area = lc_area
                        %msg        = NEW zcxca_authority_check(
                                          severity = if_abap_behv_message=>severity-error
                                          textid   = zcxca_authority_check=>gc_create ) )
          TO reported-emissao.
      ENDIF.

    ENDLOOP.

  ENDMETHOD.

  METHOD get_authorizations.

     READ ENTITIES OF ZI_MM_REGRA_EMISSAO_NF IN LOCAL MODE
        ENTITY Emissao
        ALL FIELDS WITH CORRESPONDING #( keys )
        RESULT DATA(lt_data)
        FAILED failed.

    CHECK lt_data IS NOT INITIAL.

    DATA: lv_update TYPE if_abap_behv=>t_xflag,
          lv_delete TYPE if_abap_behv=>t_xflag.

    LOOP AT lt_data ASSIGNING FIELD-SYMBOL(<fs_data>).

      IF requested_authorizations-%delete EQ if_abap_behv=>mk-on.

        IF zclmm_auth_zmmmtable=>delete( gc_table ) = abap_true.
          lv_delete = if_abap_behv=>auth-allowed.
        ELSE.
          lv_delete = if_abap_behv=>auth-unauthorized.
        ENDIF.

      ENDIF.

      APPEND VALUE #( %tky    = <fs_data>-%tky
                      %delete = lv_delete )
             TO result.
    ENDLOOP.

  ENDMETHOD.

ENDCLASS.
