CLASS lhc_param DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS validarcentros FOR VALIDATE ON SAVE
      IMPORTING keys FOR param~validarcentros.

    METHODS get_authorizations FOR AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR Param RESULT result.

    METHODS authorityCreate FOR VALIDATE ON SAVE
      IMPORTING keys FOR Param~authorityCreate.

ENDCLASS.

CLASS lhc_param IMPLEMENTATION.

  METHOD validarcentros.

    READ ENTITY zi_mm_para_dep_fechado_app FROM VALUE #( FOR <root_key> IN keys ( %key-guid = <root_key>-%key-guid ) )
    RESULT DATA(lt_param).

    DATA(ls_param) = lt_param[ 1 ].

    IF ls_param IS NOT INITIAL.

      SELECT SINGLE client
             FROM ztmm_prm_dep_fec
             INTO @sy-mandt
             WHERE origin_plant             = @ls_param-originplant            AND
                   origin_storage_location  = @ls_param-originstoragelocation  AND
                   destiny_plant            = @ls_param-destinyplant           AND
                   destiny_storage_location = @ls_param-destinystoragelocation .

      IF  sy-subrc IS INITIAL.

        "" Não pode criar caso exista já a combinação.
        reported-param = VALUE #( (  %tky = ls_param-%tky
                                    %msg = new_message( id       = 'ZMM_PARAM_DP_FECHADO'
                                                        number   = '000'
                                                        severity = CONV #( 'E' )
                                                     )

                                ) ) .


      ENDIF.

    ENDIF.

  ENDMETHOD.

  METHOD authoritycreate.

    CONSTANTS lc_area TYPE string VALUE 'VALIDATE_CREATE'.

    READ ENTITIES OF zi_mm_para_dep_fechado_app IN LOCAL MODE
    ENTITY Param
    ALL FIELDS WITH CORRESPONDING #( keys )
    RESULT DATA(lt_data).

    LOOP AT lt_data ASSIGNING FIELD-SYMBOL(<fs_data>).

      IF zclmm_auth_zmmwerks=>werks_create( <fs_data>-OriginPlant ) EQ abap_false.

        APPEND VALUE #( %tky        = <fs_data>-%tky
                        %state_area = lc_area )
        TO reported-param.

        APPEND VALUE #( %tky = <fs_data>-%tky ) TO failed-param.

        APPEND VALUE #( %tky        = <fs_data>-%tky
                        %state_area = lc_area
                        %msg        = NEW zcxca_authority_check(
                                          severity = if_abap_behv_message=>severity-error
                                          textid   = zcxca_authority_check=>gc_create )
                        %element-OriginPlant = if_abap_behv=>mk-on )
          TO reported-param.

      ENDIF.

    ENDLOOP.

  ENDMETHOD.

  METHOD get_authorizations.

    READ ENTITIES OF zi_mm_para_dep_fechado_app IN LOCAL MODE
    ENTITY Param
    ALL FIELDS WITH CORRESPONDING #( keys )
    RESULT DATA(lt_data)
    FAILED failed.

    CHECK lt_data IS NOT INITIAL.

    DATA: lv_update TYPE if_abap_behv=>t_xflag,
          lv_delete TYPE if_abap_behv=>t_xflag.

    LOOP AT lt_data ASSIGNING FIELD-SYMBOL(<fs_data>).

       IF requested_authorizations-%update EQ if_abap_behv=>mk-on.

        IF zclmm_auth_zmmwerks=>werks_update( <fs_data>-OriginPlant ).
          lv_update = if_abap_behv=>auth-allowed.
        ELSE.
          lv_update = if_abap_behv=>auth-unauthorized.
        ENDIF.

      ENDIF.

      IF requested_authorizations-%delete EQ if_abap_behv=>mk-on.

        IF zclmm_auth_zmmwerks=>werks_delete( <fs_data>-OriginPlant ).
          lv_delete = if_abap_behv=>auth-allowed.
        ELSE.
          lv_delete = if_abap_behv=>auth-unauthorized.
        ENDIF.

      ENDIF.

    ENDLOOP.

  ENDMETHOD.

ENDCLASS.
