CLASS lhc_movparam DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    CONSTANTS gc_table TYPE tabname_auth VALUE 'ZTMM_MOV_PARAM'.

    METHODS onsave FOR VALIDATE ON SAVE
      IMPORTING keys FOR movparam~onsave.
    METHODS get_authorizations FOR AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR MovParam RESULT result.
    METHODS authoritycreate FOR VALIDATE ON SAVE
      IMPORTING keys FOR MovParam~authoritycreate.

ENDCLASS.

CLASS lhc_movparam IMPLEMENTATION.

  METHOD onsave.

    READ ENTITIES OF zi_mm_mov_param IN LOCAL MODE
              ENTITY movparam
              FIELDS ( shipfrom direcao cfop matnr matkl taxlw1 taxlw2 taxlw5 taxlw4 taxsit )
              WITH CORRESPONDING #( keys )
              RESULT DATA(lt_movparam)
              FAILED DATA(ls_erros).

    LOOP AT lt_movparam ASSIGNING FIELD-SYMBOL(<fs_movparam>).

      IF <fs_movparam>-shipfrom  IS INITIAL.
        APPEND VALUE #( %tky = <fs_movparam>-%tky ) TO failed-movparam.

        APPEND VALUE #( %tky        = <fs_movparam>-%tky
                        %state_area = 'SHIPFROM'
                        %msg        = new_message( id       = 'ZMM_BENS_CONSUMO'
                                                   number   = '003'
                                                   severity = if_abap_behv_message=>severity-error )
                        %element-shipfrom = if_abap_behv=>mk-on ) TO reported-movparam.
      ENDIF.

      IF <fs_movparam>-direcao  IS INITIAL.
        APPEND VALUE #( %tky = <fs_movparam>-%tky ) TO failed-movparam.

        APPEND VALUE #( %tky        = <fs_movparam>-%tky
                        %state_area = 'DIRECAO'
                        %msg        = new_message( id       = 'ZMM_BENS_CONSUMO'
                                                   number   = '003'
                                                   severity = if_abap_behv_message=>severity-error )
                        %element-direcao = if_abap_behv=>mk-on ) TO reported-movparam.
      ENDIF.

      IF <fs_movparam>-cfop  IS INITIAL.
        APPEND VALUE #( %tky = <fs_movparam>-%tky ) TO failed-movparam.

        APPEND VALUE #( %tky        = <fs_movparam>-%tky
                        %state_area = 'CFOP'
                        %msg        = new_message( id       = 'ZMM_BENS_CONSUMO'
                                                   number   = '003'
                                                   severity = if_abap_behv_message=>severity-error )
                        %element-cfop = if_abap_behv=>mk-on ) TO reported-movparam.
      ENDIF.

      IF <fs_movparam>-matnr  IS INITIAL.
        APPEND VALUE #( %tky = <fs_movparam>-%tky ) TO failed-movparam.

        APPEND VALUE #( %tky        = <fs_movparam>-%tky
                        %state_area = 'MATNR'
                        %msg        = new_message( id       = 'ZMM_BENS_CONSUMO'
                                                   number   = '003'
                                                   severity = if_abap_behv_message=>severity-error )
                        %element-matnr = if_abap_behv=>mk-on ) TO reported-movparam.
      ENDIF.

      IF <fs_movparam>-matkl  IS INITIAL.
        APPEND VALUE #( %tky = <fs_movparam>-%tky ) TO failed-movparam.

        APPEND VALUE #( %tky        = <fs_movparam>-%tky
                        %state_area = 'MATKL'
                        %msg        = new_message( id       = 'ZMM_BENS_CONSUMO'
                                                   number   = '003'
                                                   severity = if_abap_behv_message=>severity-error )
                        %element-matkl = if_abap_behv=>mk-on ) TO reported-movparam.
      ENDIF.

      IF <fs_movparam>-taxlw1  IS INITIAL.
        APPEND VALUE #( %tky = <fs_movparam>-%tky ) TO failed-movparam.

        APPEND VALUE #( %tky        = <fs_movparam>-%tky
                        %state_area = 'TAXLW1'
                        %msg        = new_message( id       = 'ZMM_BENS_CONSUMO'
                                                   number   = '003'
                                                   severity = if_abap_behv_message=>severity-error )
                        %element-taxlw1 = if_abap_behv=>mk-on ) TO reported-movparam.
      ENDIF.

      IF <fs_movparam>-taxlw2  IS INITIAL.
        APPEND VALUE #( %tky = <fs_movparam>-%tky ) TO failed-movparam.

        APPEND VALUE #( %tky        = <fs_movparam>-%tky
                        %state_area = 'TAXLW2'
                        %msg        = new_message( id       = 'ZMM_BENS_CONSUMO'
                                                   number   = '003'
                                                   severity = if_abap_behv_message=>severity-error )
                        %element-taxlw2 = if_abap_behv=>mk-on ) TO reported-movparam.
      ENDIF.

      IF <fs_movparam>-taxlw5  IS INITIAL.
        APPEND VALUE #( %tky = <fs_movparam>-%tky ) TO failed-movparam.

        APPEND VALUE #( %tky        = <fs_movparam>-%tky
                        %state_area = 'TAXLW5'
                        %msg        = new_message( id       = 'ZMM_BENS_CONSUMO'
                                                   number   = '003'
                                                   severity = if_abap_behv_message=>severity-error )
                        %element-taxlw5 = if_abap_behv=>mk-on ) TO reported-movparam.
      ENDIF.

      IF <fs_movparam>-taxlw4  IS INITIAL.
        APPEND VALUE #( %tky = <fs_movparam>-%tky ) TO failed-movparam.

        APPEND VALUE #( %tky        = <fs_movparam>-%tky
                        %state_area = 'TAXLW4'
                        %msg        = new_message( id       = 'ZMM_BENS_CONSUMO'
                                                   number   = '003'
                                                   severity = if_abap_behv_message=>severity-error )
                        %element-taxlw4 = if_abap_behv=>mk-on ) TO reported-movparam.
      ENDIF.

      IF <fs_movparam>-taxsit  IS INITIAL.
        APPEND VALUE #( %tky = <fs_movparam>-%tky ) TO failed-movparam.

        APPEND VALUE #( %tky        = <fs_movparam>-%tky
                        %state_area = 'TAXSIT'
                        %msg        = new_message( id       = 'ZMM_BENS_CONSUMO'
                                                   number   = '003'
                                                   severity = if_abap_behv_message=>severity-error )
                        %element-taxsit = if_abap_behv=>mk-on ) TO reported-movparam.
      ENDIF.
    ENDLOOP.

  ENDMETHOD.

  METHOD get_authorizations.
    READ ENTITIES OF ZI_MM_MOV_PARAM IN LOCAL MODE
        ENTITY MovParam
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

  METHOD authorityCreate.
    CONSTANTS lc_area TYPE string VALUE 'VALIDATE_CREATE'.

    READ ENTITIES OF ZI_MM_MOV_PARAM IN LOCAL MODE
        ENTITY MovParam
        ALL FIELDS WITH CORRESPONDING #( keys )
        RESULT DATA(lt_data).

    LOOP AT lt_data ASSIGNING FIELD-SYMBOL(<fs_data>).

      IF zclmm_auth_zmmmtable=>create( gc_table ) = abap_false.

        APPEND VALUE #( %tky        = <fs_data>-%tky
                        %state_area = lc_area )
        TO reported-movparam.

        APPEND VALUE #( %tky = <fs_data>-%tky ) TO failed-movparam.

        APPEND VALUE #( %tky        = <fs_data>-%tky
                        %state_area = lc_area
                        %msg        = NEW zcxca_authority_check(
                                          severity = if_abap_behv_message=>severity-error
                                          textid   = zcxca_authority_check=>gc_create ) )
          TO reported-movparam.
      ENDIF.

    ENDLOOP.
  ENDMETHOD.

ENDCLASS.
