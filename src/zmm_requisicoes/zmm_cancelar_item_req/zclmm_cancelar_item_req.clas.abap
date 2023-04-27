"!<p><h2>Cancelar Itens da Requisição</h2></p>
"!<p><strong>Autor:</strong>Caio Mossmann</p>
"!<p><strong>Data</strong>22/09/2021</p>
CLASS zclmm_cancelar_item_req DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    TYPES: BEGIN OF ty_purchasereqnitem,
             PurchaseRequisition     TYPE C_PurchaseReqnItem-PurchaseRequisition,
             PurchaseRequisitionItem TYPE C_PurchaseReqnItem-PurchaseRequisitionItem,
           END OF ty_purchasereqnitem,

           tt_PurchaseReqnItem TYPE TABLE OF ty_purchasereqnitem.

    "! Execução geral da Classe
    "! @parameter rt_return | Retorno do processamento
    METHODS
      execute
        RETURNING VALUE(rt_return) TYPE bapiret2_t.

  PROTECTED SECTION.
  PRIVATE SECTION.

    CONSTANTS: gc_erro TYPE bapi_mtype VALUE 'E',
               gc_403  TYPE symsgno    VALUE 403,
               gc_06   TYPE symsgid    VALUE '06'.

    METHODS:
      "! Seleção dos dados nas tabelas
      "! @parameter et_item   | Tabela de Itens
      "! @parameter ev_text   | Mensagem
      "! @parameter et_return | Retorno do processamento
      select_data
        EXPORTING
          et_item   TYPE tt_purchasereqnitem
          ev_text   TYPE char50
          et_return TYPE bapiret2_t,

      "! Chama a Bapi BAPI_PR_CHANGE
      "! @parameter it_item   | Tabela de Itens
      "! @parameter iv_text   | Mensagem
      "! @parameter rt_return | Retorno do processamento
      call_bapi
        IMPORTING
                  it_item          TYPE tt_purchasereqnitem
                  iv_text          TYPE char50
        RETURNING VALUE(rt_return) TYPE bapiret2_t.
ENDCLASS.



CLASS zclmm_cancelar_item_req IMPLEMENTATION.

  METHOD execute.

    select_data(
      IMPORTING
        et_item   = DATA(lt_item)
        ev_text   = DATA(lv_text)
        et_return = rt_return ).

    IF rt_return IS NOT INITIAL.

      EXIT.

    ENDIF.

    rt_return = call_bapi(
      EXPORTING
        it_item = lt_item
        iv_text = lv_text ).

  ENDMETHOD.

  METHOD select_data.

    CONSTANTS: BEGIN OF lc_parametros,
                 modulo   TYPE ztca_param_mod-modulo VALUE 'MM',
                 chave1   TYPE ztca_param_par-chave1 VALUE 'ME',
                 chave2   TYPE ztca_param_par-chave2 VALUE 'CANCELITEM',
                 tpreq    TYPE ztca_param_par-chave3 VALUE 'TPREQ',
                 status   TYPE ztca_param_par-chave3 VALUE 'STATUS',
                 cancdias TYPE ztca_param_par-chave3 VALUE 'CANCDIAS',
                 release  TYPE ztca_param_par-chave3 VALUE 'RELEASE',
                 mensagem TYPE ztca_param_par-chave3 VALUE 'MENSAGEM',
               END OF lc_parametros.


    DATA: lr_tpreq    TYPE RANGE OF char4,
          lr_status   TYPE RANGE OF C_PurchaseReqnItem-PurReqnReleaseStatus,
          lr_cancdias TYPE RANGE OF numc2,
          lr_release  TYPE RANGE OF C_PurchaseReqnItem-ReleaseCode,
          lr_mensagem TYPE RANGE OF char50,
          lv_data     TYPE dats.

    DATA(lo_parametros) = NEW zclca_tabela_parametros( ).

    TRY.

        lo_parametros->m_get_range(
          EXPORTING
            iv_modulo = lc_parametros-modulo
            iv_chave1 = lc_parametros-chave1
            iv_chave2 = lc_parametros-chave2
            iv_chave3 = lc_parametros-tpreq
          IMPORTING
            et_range  = lr_tpreq
        ).

        lo_parametros->m_get_range(
          EXPORTING
            iv_modulo = lc_parametros-modulo
            iv_chave1 = lc_parametros-chave1
            iv_chave2 = lc_parametros-chave2
            iv_chave3 = lc_parametros-status
          IMPORTING
            et_range  = lr_status
        ).

        lo_parametros->m_get_range(
          EXPORTING
            iv_modulo = lc_parametros-modulo
            iv_chave1 = lc_parametros-chave1
            iv_chave2 = lc_parametros-chave2
            iv_chave3 = lc_parametros-cancdias
          IMPORTING
            et_range  = lr_cancdias
        ).

        lo_parametros->m_get_range(
          EXPORTING
            iv_modulo = lc_parametros-modulo
            iv_chave1 = lc_parametros-chave1
            iv_chave2 = lc_parametros-chave2
            iv_chave3 = lc_parametros-release
          IMPORTING
            et_range  = lr_release
        ).

        lo_parametros->m_get_range(
          EXPORTING
            iv_modulo = lc_parametros-modulo
            iv_chave1 = lc_parametros-chave1
            iv_chave2 = lc_parametros-chave2
            iv_chave3 = lc_parametros-mensagem
          IMPORTING
            et_range  = lr_mensagem
        ).

      CATCH zcxca_tabela_parametros INTO DATA(lo_catch).

        et_return = VALUE #( ( message = lo_catch->get_longtext( )
                               type    = if_abap_behv_message=>severity-error ) ).

        EXIT.

    ENDTRY.

    READ TABLE lr_mensagem ASSIGNING FIELD-SYMBOL(<fs_mensagem>) INDEX 1.
    IF sy-subrc IS INITIAL.

      ev_text = <fs_mensagem>-low.

    ENDIF.

    READ TABLE lr_cancdias ASSIGNING FIELD-SYMBOL(<fs_dias>) INDEX 1.
    IF sy-subrc IS INITIAL.

      lv_data = sy-datum - <fs_dias>-low.

    ENDIF.

    SELECT PurchaseRequisition,
           PurchaseRequisitionItem
      FROM C_PurchaseReqnItem
      INTO TABLE @et_item
      WHERE PurReqnReleaseStatus           IN @lr_status
      AND   PurchaseRequisitionReleaseDate LT @lv_data
      AND   ReleaseCode                    NOT IN @lr_release.

    IF sy-subrc IS NOT INITIAL.

      et_return = VALUE #( ( message = TEXT-e01
                             type    = if_abap_behv_message=>severity-error ) ).

    ENDIF.

  ENDMETHOD.

  METHOD call_bapi.

    DATA: lt_item       TYPE tt_purchasereqnitem,
          lt_return     TYPE STANDARD TABLE OF bapiret2,
          lt_pritem     TYPE STANDARD TABLE OF bapimereqitemimp,
          lt_pritemx    TYPE STANDARD TABLE OF bapimereqitemx,
          lt_pritemtext TYPE STANDARD TABLE OF bapimereqitemtext.

    DATA(lt_header) = it_item.

    DELETE ADJACENT DUPLICATES FROM lt_header COMPARING purchaserequisition.

    LOOP AT lt_header ASSIGNING FIELD-SYMBOL(<fs_header>).

      CLEAR: lt_item,
             lt_return,
             lt_pritem,
             lt_pritemx,
             lt_pritemtext.

      lt_item = it_item.

      DELETE lt_item WHERE purchaserequisition NE <fs_header>-purchaserequisition.

      lt_pritem = VALUE #( FOR ls_item IN lt_item
                              ( preq_item  = ls_item-purchaserequisitionitem
                                delete_ind = abap_true ) ).

      lt_pritemx = VALUE #( FOR ls_item IN lt_item
                            ( preq_item  = ls_item-purchaserequisitionitem
                              preq_itemx = abap_true
                              delete_ind = abap_true ) ).

      lt_pritemtext = VALUE #( FOR ls_item IN lt_item
                             ( preq_no   = ls_item-purchaserequisition
                               preq_item = ls_item-purchaserequisitionitem
                               text_form = 'B02'
                               text_line = iv_text ) ).

      CALL FUNCTION 'BAPI_PR_CHANGE'
        EXPORTING
          number     = <fs_header>-purchaserequisition
        TABLES
          return     = lt_return
          pritem     = lt_pritem
          pritemx    = lt_pritemx
          pritemtext = lt_pritemtext.

      IF NOT line_exists( lt_return[ type = gc_erro ] ).

        DELETE lt_return WHERE id     NE gc_06
                           AND number NE gc_403.

        CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'.
      ELSE.
        CALL FUNCTION 'BAPI_TRANSACTION_ROLLBACK'.
      ENDIF.

      APPEND LINES OF lt_return TO rt_return.

    ENDLOOP.

  ENDMETHOD.

ENDCLASS.
