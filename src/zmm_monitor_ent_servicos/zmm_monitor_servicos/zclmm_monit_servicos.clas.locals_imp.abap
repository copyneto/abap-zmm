CLASS lcl_item DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    METHODS get_features FOR FEATURES
      IMPORTING keys REQUEST requested_features FOR _Item RESULT result.

ENDCLASS.

CLASS lcl_item IMPLEMENTATION.

  METHOD get_features.
    READ ENTITIES OF zi_mm_monit_serv_header ENTITY _Header
    FIELDS ( miro )
    WITH CORRESPONDING #( keys )
    RESULT DATA(lt_document).

    DATA(lv_miro) = lt_document[ 1 ]-Miro.

    LOOP AT keys ASSIGNING FIELD-SYMBOL(<fs_key>).
      IF lv_miro IS INITIAL.
        result = VALUE #( BASE result ( empresa = <fs_key>-empresa
                                        filial  = <fs_key>-filial
                                        lifnr   = <fs_key>-lifnr
                                        nrnf    = <fs_key>-nrnf
                                        NrPedido = <fs_key>-NrPedido
                                        ItmPedido = <fs_key>-ItmPedido
                                        %features-%update       = if_abap_behv=>fc-o-enabled
                                    ) ).
      ELSE.
        result = VALUE #( BASE result ( empresa = <fs_key>-empresa
                                        filial  = <fs_key>-filial
                                        lifnr   = <fs_key>-lifnr
                                        nrnf    = <fs_key>-nrnf
                                        NrPedido = <fs_key>-NrPedido
                                        ItmPedido = <fs_key>-ItmPedido
                                        %features-%update = if_abap_behv=>fc-o-disabled
                                      ) ).
      ENDIF.
    ENDLOOP.
  ENDMETHOD.

ENDCLASS.

CLASS lcl_header DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    CONSTANTS: gc_msg_id TYPE sy-msgid VALUE 'ZMM_MONITOR_ENT_SERV',
               gc_sucess TYPE sy-msgty VALUE 'S',
               gc_msg_2  TYPE sy-msgno VALUE '002',
               gc_msg_3  TYPE sy-msgno VALUE '003'.

    METHODS simularfatura FOR MODIFY
      IMPORTING keys FOR ACTION _header~simularfatura.

    METHODS registrarfatura FOR MODIFY
      IMPORTING keys FOR ACTION _header~registrarfatura.

    METHODS estornarfatura FOR MODIFY
      IMPORTING keys FOR ACTION _header~estornarfatura.

    METHODS excluirfatura FOR MODIFY
      IMPORTING keys FOR ACTION _header~excluirfatura.
    METHODS get_features FOR FEATURES
      IMPORTING keys REQUEST requested_features FOR _header RESULT result.
    METHODS get_authorizations FOR AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR _header RESULT result.
ENDCLASS.

CLASS lcl_header IMPLEMENTATION.

  METHOD simularfatura.

    CHECK keys[] IS NOT INITIAL.

    DATA(lo_object) = NEW zclmm_lanc_servicos( ).
    DATA(ls_key) = keys[ 1 ].

    lo_object->simular_fatura(
      EXPORTING
        is_key    = CORRESPONDING #( ls_key )
      IMPORTING
        et_return = DATA(lt_return)
        et_accounting = DATA(lt_accounting)
    ).

    IF NOT line_exists( lt_return[ type = zclmm_lanc_servicos=>gc_error ] ).
      DELETE FROM ztmm_monit_simul."#EC CI_NOWHERE

      MODIFY ENTITIES OF zi_mm_monit_serv_header IN LOCAL MODE
      ENTITY _Header CREATE BY \_Simula
      FIELDS ( Empresa Filial Lifnr NrNf Linha Hkont Bschl Shkzg Waers Dmbtr Mwskz Qsskz Ktext )
      WITH VALUE #( (
         Empresa   = ls_key-Empresa
         Filial    = ls_key-Filial
         Lifnr     = ls_key-Lifnr
         NrNf      = ls_key-NrNf
         %target   = VALUE #( FOR ls_accounting IN lt_accounting (
             Empresa   = ls_key-Empresa
             Filial    = ls_key-Filial
             Lifnr     = ls_key-Lifnr
             NrNf      = ls_key-NrNf
             Linha     = ls_accounting-buzei
             Hkont     = ls_accounting-hkont
             Bschl     = ls_accounting-bschl
             Shkzg     = ls_accounting-shkzg
             Waers     = ls_accounting-h_waers
             Dmbtr     = ls_accounting-dmbtr
             Mwskz     = ls_accounting-mwskz
             Qsskz     = ls_accounting-qsskz
             Ktext     = ls_accounting-ktext
         ) )
     ) )
      REPORTED DATA(lt_reported_items).
    ENDIF.

    LOOP AT lt_return ASSIGNING FIELD-SYMBOL(<fs_return>).
      APPEND VALUE #( empresa = ls_key-empresa
                      filial  = ls_key-filial
                      lifnr   = ls_key-lifnr
                      nrnf    = ls_key-nrnf
                      %msg    =  new_message( id       = <fs_return>-id
                                              number   = <fs_return>-number
                                              severity = CONV #( <fs_return>-type )
                                              v1       = <fs_return>-message_v1
                                              v2       = <fs_return>-message_v2
                                              v3       = <fs_return>-message_v3
                                              v4       = <fs_return>-message_v4 ) ) TO reported-_header.
    ENDLOOP.

  ENDMETHOD.

  METHOD registrarfatura.

    CHECK keys[] IS NOT INITIAL.

    DATA(lo_object) = NEW zclmm_lanc_servicos( ).

    DATA(ls_keys) = keys[ 1 ].

    lo_object->registrar_fatura(
      EXPORTING
        is_key    = CORRESPONDING #( ls_keys )
      IMPORTING
        et_return = DATA(lt_return) ).

    LOOP AT lt_return ASSIGNING FIELD-SYMBOL(<fs_return>).
      APPEND VALUE #( %msg =  new_message( id       = <fs_return>-id
                                           number   = <fs_return>-number
                                           severity = CONV #( <fs_return>-type )
                                           v1       = <fs_return>-message_v1
                                           v2       = <fs_return>-message_v2
                                           v3       = <fs_return>-message_v3
                                           v4       = <fs_return>-message_v4 ) ) TO reported-_header.
    ENDLOOP.

  ENDMETHOD.

  METHOD estornarfatura.

    CHECK keys[] IS NOT INITIAL.

    DATA(lo_object) = NEW zclmm_lanc_servicos( ).

    DATA(ls_keys) = keys[ 1 ].

    lo_object->estornar_fatura(
      EXPORTING
        is_key    = CORRESPONDING #( ls_keys )
      IMPORTING
        et_return = DATA(lt_return) ).

    LOOP AT lt_return ASSIGNING FIELD-SYMBOL(<fs_return>).
      APPEND VALUE #( %msg =  new_message( id       = <fs_return>-id
                                           number   = <fs_return>-number
                                           severity = CONV #( <fs_return>-type )
                                           v1       = <fs_return>-message_v1
                                           v2       = <fs_return>-message_v2
                                           v3       = <fs_return>-message_v3
                                           v4       = <fs_return>-message_v4 ) ) TO reported-_header.
    ENDLOOP.

  ENDMETHOD.

  METHOD excluirfatura.

    CHECK keys[] IS NOT INITIAL.

    DATA(lo_object) = NEW zclmm_lanc_servicos( ).

    lo_object->excluir_fatura(
      EXPORTING
        it_key    =  CORRESPONDING #( keys )
      IMPORTING
        et_return = DATA(lt_return) ).

    LOOP AT lt_return ASSIGNING FIELD-SYMBOL(<fs_return>).
      APPEND VALUE #( %msg =  new_message( id       = <fs_return>-id
                                           number   = <fs_return>-number
                                           severity = CONV #( <fs_return>-type )
                                           v1       = <fs_return>-message_v1
                                           v2       = <fs_return>-message_v2
                                           v3       = <fs_return>-message_v3
                                           v4       = <fs_return>-message_v4 ) ) TO reported-_header.
    ENDLOOP.

  ENDMETHOD.

  METHOD get_features.
    READ ENTITIES OF zi_mm_monit_serv_header ENTITY _Header
    FIELDS ( miro )
    WITH CORRESPONDING #( keys )
    RESULT DATA(lt_document).

    SORT lt_document BY empresa
                        filial
                        lifnr
                        nrnf.

    LOOP AT lt_document ASSIGNING FIELD-SYMBOL(<fs_document>).

      IF <fs_document>-Miro IS INITIAL.
        result = VALUE #( BASE result ( empresa = <fs_document>-empresa
                                        filial  = <fs_document>-filial
                                        lifnr   = <fs_document>-lifnr
                                        nrnf    = <fs_document>-nrnf
                                        %action-registrarfatura = if_abap_behv=>fc-o-enabled
                                        %action-simularfatura   = if_abap_behv=>fc-o-enabled
                                        %action-excluirfatura   = if_abap_behv=>fc-o-enabled
                                        %features-%update       = if_abap_behv=>fc-o-enabled
                                        %action-estornarfatura  = if_abap_behv=>fc-o-disabled

                                    ) ).
      ELSE.
        result = VALUE #( BASE result ( empresa = <fs_document>-empresa
                                        filial  = <fs_document>-filial
                                        lifnr   = <fs_document>-lifnr
                                        nrnf    = <fs_document>-nrnf
                                        %action-registrarfatura = if_abap_behv=>fc-o-disabled
                                        %action-simularfatura   = if_abap_behv=>fc-o-disabled
                                        %action-excluirfatura   = if_abap_behv=>fc-o-disabled
                                        %features-%update       = if_abap_behv=>fc-o-disabled
                                        %action-estornarfatura  = if_abap_behv=>fc-o-enabled
                                      ) ).
      ENDIF.

    ENDLOOP.
  ENDMETHOD.

  METHOD get_authorizations.
    RETURN.
  ENDMETHOD.

ENDCLASS.
