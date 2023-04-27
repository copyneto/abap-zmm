CLASS lhc_ZI_MM_OPERACAO DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    CONSTANTS gc_table TYPE tabname_auth VALUE 'ZTMM_OPERACAO'.

    METHODS convCfop FOR DETERMINE ON MODIFY
      IMPORTING keys FOR zi_mm_operacao~convCfop.
    METHODS conv_cfop
      IMPORTING
        iv_cfop        TYPE logbr_cfopcode
      RETURNING
        VALUE(rv_cfop) TYPE logbr_cfopcode.

    METHODS authorityCreate FOR VALIDATE ON SAVE
      IMPORTING keys FOR zi_mm_operacao~authorityCreate.

    METHODS get_authorizations FOR AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR zi_mm_operacao RESULT result.

ENDCLASS.

CLASS lhc_ZI_MM_OPERACAO IMPLEMENTATION.

  METHOD convCfop.

    READ ENTITIES OF zi_mm_operacao IN LOCAL MODE
        ENTITY zi_mm_operacao
        ALL FIELDS
        WITH CORRESPONDING #( keys )
        RESULT DATA(lt_oper).

    MODIFY ENTITIES OF zi_mm_operacao IN LOCAL MODE
    ENTITY zi_mm_operacao
    UPDATE SET FIELDS WITH VALUE #( FOR ls_oper IN lt_oper
                                    ( %key    = ls_oper-%key
                                      CfopInt = conv_cfop( ls_oper-cfop )  )
                                    ) REPORTED DATA(lt_reported).



  ENDMETHOD.


  METHOD conv_cfop.

    CALL FUNCTION 'CONVERSION_EXIT_CFOBR_INPUT'
      EXPORTING
        input  = iv_cfop
      IMPORTING
        output = rv_cfop.

  ENDMETHOD.

  METHOD authoritycreate.

    CONSTANTS lc_area TYPE string VALUE 'VALIDATE_CREATE'.

    READ ENTITIES OF zi_mm_operacao IN LOCAL MODE
        ENTITY zi_mm_operacao
        ALL FIELDS WITH CORRESPONDING #( keys )
        RESULT DATA(lt_data).

    LOOP AT lt_data ASSIGNING FIELD-SYMBOL(<fs_data>).

      IF zclmm_auth_zmmmtable=>create( gc_table ) EQ abap_false.

        APPEND VALUE #( %tky        = <fs_data>-%tky
                        %state_area = lc_area )
        TO reported-zi_mm_operacao.

        APPEND VALUE #( %tky = <fs_data>-%tky ) TO failed-zi_mm_operacao.

        APPEND VALUE #( %tky        = <fs_data>-%tky
                        %state_area = lc_area
                        %msg        = NEW zcxca_authority_check(
                                          severity = if_abap_behv_message=>severity-error
                                          textid   = zcxca_authority_check=>gc_create ) )
          TO reported-zi_mm_operacao.

      ENDIF.

    ENDLOOP.

  ENDMETHOD.

  METHOD get_authorizations.

    READ ENTITIES OF zi_mm_operacao IN LOCAL MODE
         ENTITY zi_mm_operacao
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

      APPEND VALUE #( %tky = <fs_data>-%tky
                      %update = lv_update
                      %delete = lv_delete )
             TO result.

    ENDLOOP.

  ENDMETHOD.

ENDCLASS.
