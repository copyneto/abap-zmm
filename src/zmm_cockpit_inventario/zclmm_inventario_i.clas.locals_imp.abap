CLASS lcl_item DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    METHODS message FOR MODIFY
      IMPORTING keys FOR ACTION _item~message RESULT result.

    METHODS get_features FOR FEATURES
      IMPORTING keys REQUEST requested_features FOR _item RESULT result.

    METHODS updatedata FOR DETERMINE ON SAVE
      IMPORTING keys FOR _item~updatedata.

    METHODS refresh FOR MODIFY
      IMPORTING keys FOR ACTION _item~refresh RESULT result.

    METHODS get_authorizations FOR AUTHORIZATION
      IMPORTING keys REQUEST requested_authorizations FOR _item RESULT result.

ENDCLASS.

CLASS lcl_item IMPLEMENTATION.

  METHOD message.

    IF lines( keys ) GT 0.
      SELECT documentid,
             seqnr,
             msgty,
             msgid,
             msgno,
             msgv1,
             msgv2,
             msgv3,
             msgv4,
             message
        FROM zi_mm_inventario_log
        FOR ALL ENTRIES IN @keys
        WHERE documentid = @keys-documentid
        INTO TABLE @DATA(lt_mensagens).
    ENDIF.

    LOOP AT lt_mensagens INTO DATA(ls_mensagens).  "#EC CI_LOOP_INTO_WA

      APPEND VALUE #( %tky-documentid = ls_mensagens-documentid ) TO failed-_item.

      APPEND VALUE #( %tky = VALUE #( documentid = ls_mensagens-documentid )
                      %msg =  new_message( id       = ls_mensagens-msgid
                                           number   = CONV #( ls_mensagens-msgno )
                                           severity = CONV #( ls_mensagens-msgty )
                                           v1       = ls_mensagens-msgv1
                                           v2       = ls_mensagens-msgv2
                                           v3       = ls_mensagens-msgv3
                                           v4       = ls_mensagens-msgv4 ) ) TO reported-_item.
    ENDLOOP.


  ENDMETHOD.

  METHOD get_features.


    DATA: lt_itens  TYPE STANDARD TABLE OF zi_mm_inventario_item,
          ls_header TYPE zi_mm_inventario_h.

* ---------------------------------------------------------------------------
* Verifica se documento foi liberado
* ---------------------------------------------------------------------------
    READ ENTITIES OF zi_mm_inventario_h IN LOCAL MODE ENTITY _header
    FIELDS ( documentid status )
    WITH CORRESPONDING #( keys )
    RESULT DATA(lt_header).

    IF NOT line_exists( lt_header[ status = gc_status-liberado ] ). "#EC CI_STDSEQ
      DATA(lv_refresh) = if_abap_behv=>fc-o-enabled.
    ELSE.
      lv_refresh       = if_abap_behv=>fc-o-disabled.
    ENDIF.

* ---------------------------------------------------------------------------
* Verifica se existe log
* ---------------------------------------------------------------------------
    SELECT COUNT(*)
      FROM zi_mm_inventario_log
      FOR ALL ENTRIES IN @keys
      WHERE documentid = @keys-documentid.      "#EC CI_FAE_NO_LINES_OK

    IF sy-subrc = 0.
      DATA(lv_message) = if_abap_behv=>fc-o-enabled.
    ELSE.
      lv_message       = if_abap_behv=>fc-o-disabled.
    ENDIF.

* ---------------------------------------------------------------------------
* Recupera itens selecionados
* ---------------------------------------------------------------------------
    READ ENTITIES OF zi_mm_inventario_h IN LOCAL MODE ENTITY _item
    ALL FIELDS WITH CORRESPONDING #( keys )
    RESULT DATA(lt_item).

* ---------------------------------------------------------------------------
* Habilita/desabilita botão de mensagens
* ---------------------------------------------------------------------------
    result = VALUE #( FOR ls_item IN lt_item
                      LET lv_storagelocation   =  COND #( WHEN ls_item-physicalinventorydocument IS INITIAL
                                                          THEN if_abap_behv=>fc-o-enabled
                                                          ELSE if_abap_behv=>fc-o-disabled  )
                          lv_batch             =  COND #( WHEN ls_item-physicalinventorydocument IS INITIAL
                                                          THEN if_abap_behv=>fc-o-enabled
                                                          ELSE if_abap_behv=>fc-o-disabled  )
                          lv_quantitycount     =  COND #( WHEN ls_item-status EQ gc_status_item-pendente
                                                          THEN if_abap_behv=>fc-o-enabled
                                                          ELSE if_abap_behv=>fc-o-disabled  )
                          lv_update            =  COND #( WHEN ls_item-physicalinventorydocument EQ space
                                                          THEN if_abap_behv=>fc-o-enabled
                                                          ELSE if_abap_behv=>fc-o-disabled  )
                          lv_delete            =  COND #( WHEN ls_item-physicalinventorydocument EQ space
                                                          THEN if_abap_behv=>fc-o-enabled
                                                          ELSE if_abap_behv=>fc-o-disabled  )
                      IN
                      ( %tky                    = ls_item-%tky
                        %update                 = lv_update
                        %delete                 = lv_delete
                        %action-message         = lv_message
                        %action-refresh         = lv_refresh
                        %field-storagelocation  = lv_storagelocation
                        %field-batch            = lv_batch
                        %field-quantitycount    = lv_quantitycount
                      ) ).

  ENDMETHOD.

  METHOD updatedata.

    DATA lt_itens TYPE STANDARD TABLE OF zi_mm_inventario_item.
    DATA ls_header TYPE zi_mm_inventario_h.

    READ ENTITIES OF zi_mm_inventario_h IN LOCAL MODE ENTITY _header
    ALL FIELDS WITH CORRESPONDING #( keys )
    RESULT DATA(lt_header).

    TRY.
        ls_header = CORRESPONDING #( lt_header[ 1 ] ).
      CATCH cx_root.
    ENDTRY.

    READ ENTITIES OF zi_mm_inventario_h IN LOCAL MODE ENTITY _item
    ALL FIELDS WITH CORRESPONDING #( keys )
    RESULT DATA(lt_item).

    MOVE-CORRESPONDING lt_item[] TO lt_itens[].

    TRY.
        DATA(lo_inventario) = NEW zclmm_inventario( ).
        lo_inventario->determination_update(
          EXPORTING
            is_cds_header = ls_header
          IMPORTING
            et_return     = DATA(lt_return)
          CHANGING
            ct_cds_item   = lt_itens ).

      CATCH cx_root.
    ENDTRY.

    MODIFY ENTITIES OF zi_mm_inventario_h IN LOCAL MODE
    ENTITY _item
    UPDATE SET FIELDS WITH VALUE #( FOR ls_itens IN lt_itens (
                              %key-documentid       = ls_itens-documentid
                              %key-documentitemid   = ls_itens-documentitemid
                              quantitystock         = ls_itens-quantitystock
                              quantitycurrent       = ls_itens-quantitycurrent
                              balance               = ls_itens-balance
                              balancecurrent        = ls_itens-balancecurrent
                              pricestock            = ls_itens-pricestock
                              pricecount            = ls_itens-pricecount
                              pricediff             = ls_itens-pricediff
                              weight                = ls_itens-weight
                              weightunit            = ls_itens-weightunit
                              accuracy              = ls_itens-accuracy ) )
                              FAILED   DATA(lt_failed)
                              REPORTED DATA(lt_reported).

    reported = CORRESPONDING #( DEEP lt_reported ).

    UPDATE ztmm_inventory_i FROM TABLE @( CORRESPONDING #( lt_itens ) ).

* ---------------------------------------------------------------------------
* Retornar mensagens
* ---------------------------------------------------------------------------
    LOOP AT lt_return INTO DATA(ls_return).

      APPEND VALUE #( "%tky        =
                      %msg        = new_message( id       = ls_return-id
                                                 number   = ls_return-number
                                                 v1       = ls_return-message_v1
                                                 v2       = ls_return-message_v2
                                                 v3       = ls_return-message_v3
                                                 v4       = ls_return-message_v4
                                                 severity = CONV #( ls_return-type ) )
                       )
        TO reported-_header.

    ENDLOOP.

  ENDMETHOD.

  METHOD refresh.

    DATA lt_itens TYPE STANDARD TABLE OF zi_mm_inventario_item.
    DATA ls_header TYPE zi_mm_inventario_h.

    READ ENTITIES OF zi_mm_inventario_h IN LOCAL MODE ENTITY _header
    ALL FIELDS WITH CORRESPONDING #( keys )
    RESULT DATA(lt_header).

    TRY.
        ls_header = CORRESPONDING #( lt_header[ 1 ] ).
      CATCH cx_root.
    ENDTRY.

    TRY.
        DATA(ls_key) = keys[ 1 ].
      CATCH cx_root.
    ENDTRY.

    READ ENTITIES OF zi_mm_inventario_h IN LOCAL MODE ENTITY _header BY \_itens
    ALL FIELDS WITH VALUE #( ( documentid = ls_key-documentid ) )
    RESULT DATA(lt_item).

    MOVE-CORRESPONDING lt_item[] TO lt_itens[].

    TRY.
        DATA(lo_inventario) = NEW zclmm_inventario( ).
        lo_inventario->determination_update(
          EXPORTING
            is_cds_header = ls_header
          IMPORTING
            et_return     = DATA(lt_return)
          CHANGING
            ct_cds_item   = lt_itens ).

      CATCH cx_root.
    ENDTRY.

    MODIFY ENTITIES OF zi_mm_inventario_h IN LOCAL MODE
    ENTITY _item
    UPDATE SET FIELDS WITH VALUE #( FOR ls_itens IN lt_itens (
                              %key-documentid       = ls_itens-documentid
                              %key-documentitemid   = ls_itens-documentitemid
                              quantitystock         = ls_itens-quantitystock
                              quantitycurrent       = ls_itens-quantitycurrent
                              balance               = ls_itens-balance
                              balancecurrent        = ls_itens-balancecurrent
                              pricestock            = ls_itens-pricestock
                              pricecount            = ls_itens-pricecount
                              pricediff             = ls_itens-pricediff
                              weight                = ls_itens-weight
                              weightunit            = ls_itens-weightunit
                              accuracy              = ls_itens-accuracy ) )
                              FAILED   DATA(lt_failed)
                              REPORTED DATA(lt_reported).

* ---------------------------------------------------------------------------
* Retornar mensagens
* ---------------------------------------------------------------------------
    LOOP AT lt_return INTO DATA(ls_return).

      APPEND VALUE #( "%tky        =
                      %msg        = new_message( id       = ls_return-id
                                                 number   = ls_return-number
                                                 v1       = ls_return-message_v1
                                                 v2       = ls_return-message_v2
                                                 v3       = ls_return-message_v3
                                                 v4       = ls_return-message_v4
                                                 severity = CONV #( ls_return-type ) )
                       )
        TO reported-_header.

    ENDLOOP.

    READ ENTITIES OF zi_mm_inventario_h IN LOCAL MODE
    ENTITY _header BY \_itens
    ALL FIELDS WITH VALUE #( ( documentid = ls_key-documentid ) )
    RESULT lt_item.

    result = VALUE #( FOR ls_item IN lt_item
                       ( %tky   = ls_item-%tky
                         %param = CORRESPONDING #( ls_item ) ) ).


  ENDMETHOD.


  METHOD get_authorizations.
      RETURN.

  ENDMETHOD.

ENDCLASS.

*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations
