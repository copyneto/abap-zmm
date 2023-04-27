CLASS lcl_header DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.
    METHODS cancelar FOR MODIFY
      IMPORTING keys FOR ACTION _header~cancelar RESULT result.

    METHODS get_features FOR FEATURES
      IMPORTING keys REQUEST requested_features FOR _header RESULT result.

    METHODS liberar FOR MODIFY
      IMPORTING keys FOR ACTION _header~liberar RESULT result.

    METHODS get_authorizations FOR AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR _header RESULT result.
ENDCLASS.

CLASS lcl_header IMPLEMENTATION.

  METHOD get_features.

* ---------------------------------------------------------------------------
* Recupera status
* ---------------------------------------------------------------------------
    READ ENTITIES OF zi_mm_inventario_h IN LOCAL MODE ENTITY _header
    FIELDS ( documentid status )
    WITH CORRESPONDING #( keys )
    RESULT DATA(lt_header).

* ---------------------------------------------------------------------------
* Atualiza permissões de cada linha
* ---------------------------------------------------------------------------
    result = VALUE #( FOR ls_header IN lt_header
                      LET lv_update   =  COND #( WHEN ls_header-status = gc_status-criado
                                                   OR ls_header-status = gc_status-incompleto
                                                 THEN if_abap_behv=>fc-o-enabled
                                                 ELSE if_abap_behv=>fc-o-disabled  )
                          lv_delete   =  COND #( WHEN ls_header-status = gc_status-criado
                                                 THEN if_abap_behv=>fc-o-enabled
                                                 ELSE if_abap_behv=>fc-o-disabled  )
                          lv_cancelar =  COND #( WHEN ls_header-status = gc_status-criado
                                                   OR ls_header-status = gc_status-incompleto
                                                 THEN if_abap_behv=>fc-o-enabled
                                                 ELSE if_abap_behv=>fc-o-disabled  )
                          lv_liberar  =  COND #( WHEN ls_header-status = gc_status-criado
                                                   OR ls_header-status = gc_status-incompleto
                                                 THEN if_abap_behv=>fc-o-enabled
                                                 ELSE if_abap_behv=>fc-o-disabled  )
                          lv_refresh  =  COND #( WHEN ls_header-status = gc_status-criado
                                                   OR ls_header-status = gc_status-incompleto
                                                 THEN if_abap_behv=>fc-o-enabled
                                                 ELSE if_abap_behv=>fc-o-disabled  )
                      IN
                      ( %tky             = ls_header-%tky
                        %update          = lv_update
                        %delete          = lv_delete
                        %action-cancelar = lv_cancelar
                        %action-liberar  = lv_liberar
                      ) ).

  ENDMETHOD.

  METHOD cancelar.

* ---------------------------------------------------------------------------
* Atualizar botão de cancelar
* ---------------------------------------------------------------------------
    MODIFY ENTITIES OF zi_mm_inventario_h IN LOCAL MODE ENTITY _header
        UPDATE FIELDS ( status )
        WITH VALUE #( FOR ls_keys IN keys ( %key      = ls_keys-%key
                                            status    = gc_status-cancelado ) ).

    READ ENTITIES OF zi_mm_inventario_h IN LOCAL MODE ENTITY _header
        FIELDS ( status )
        WITH CORRESPONDING #( keys )
        RESULT DATA(lt_result).

    result = VALUE #( FOR ls_result IN lt_result
                      ( %tky   = ls_result-%tky
                        %param = ls_result ) ).

  ENDMETHOD.

  METHOD liberar.

    DATA: lt_return_all TYPE bapiret2_t.

    DATA(lo_inventario) = NEW zclmm_inventario( ).

* ---------------------------------------------------------------------------
* Chama processo de liber
* ---------------------------------------------------------------------------
    LOOP AT keys INTO DATA(ls_keys).               "#EC CI_LOOP_INTO_WA

      lo_inventario->release( EXPORTING iv_documentid = ls_keys-documentid
                              IMPORTING et_return     = DATA(lt_return) ).

      lt_return_all[] = VALUE #( BASE lt_return_all FOR ls_return IN lt_return ( ls_return ) ).
    ENDLOOP.

* ---------------------------------------------------------------------------
* Retornar mensagens
* ---------------------------------------------------------------------------
    LOOP AT lt_return_all INTO DATA(ls_return_all).

      APPEND VALUE #( "%tky        =
                      %msg        = new_message( id       = ls_return_all-id
                                                 number   = ls_return_all-number
                                                 v1       = ls_return_all-message_v1
                                                 v2       = ls_return_all-message_v2
                                                 v3       = ls_return_all-message_v3
                                                 v4       = ls_return_all-message_v4
                                                 severity = CONV #( ls_return_all-type ) )
                       )
        TO reported-_header.

    ENDLOOP.

* ---------------------------------------------------------------------------
* Atualizar status
* ---------------------------------------------------------------------------
    READ ENTITIES OF zi_mm_inventario_h IN LOCAL MODE ENTITY _header
        FIELDS ( status )
        WITH CORRESPONDING #( keys )
        RESULT DATA(lt_result).

    result = VALUE #( FOR ls_result IN lt_result
                      ( %tky   = ls_result-%tky
                        %param = ls_result ) ).

  ENDMETHOD.

  METHOD get_authorizations.

    READ ENTITIES OF zi_mm_inventario_h IN LOCAL MODE
        ENTITY _Header
        ALL FIELDS WITH CORRESPONDING #( keys )
        RESULT DATA(lt_data)
        FAILED failed.

    CHECK lt_data IS NOT INITIAL.

    DATA: lv_update TYPE if_abap_behv=>t_xflag,
          lv_delete TYPE if_abap_behv=>t_xflag.

    LOOP AT lt_data ASSIGNING FIELD-SYMBOL(<fs_data>).

      IF requested_authorizations-%update EQ if_abap_behv=>mk-on.

        IF zclmm_auth_zmmwerks=>werks_update( <fs_data>-Plant ) = abap_true.
          lv_update = if_abap_behv=>auth-allowed.
        ELSE.
          lv_update = if_abap_behv=>auth-unauthorized.
        ENDIF.

      ENDIF.

      IF requested_authorizations-%delete EQ if_abap_behv=>mk-on.

        IF zclmm_auth_zmmwerks=>werks_delete( <fs_data>-Plant ) = abap_true.
          lv_delete = if_abap_behv=>auth-allowed.
        ELSE.
          lv_delete = if_abap_behv=>auth-unauthorized.
        ENDIF.

      ENDIF.

      APPEND VALUE #( %tky          = <fs_data>-%tky
                      %update       = lv_update
                      %delete       = lv_delete
                      %assoc-_itens = lv_update )
             TO result.
    ENDLOOP.

  ENDMETHOD.

ENDCLASS.

*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations
