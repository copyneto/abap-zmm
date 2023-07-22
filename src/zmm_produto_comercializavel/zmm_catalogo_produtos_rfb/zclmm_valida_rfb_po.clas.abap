"! <p class="shorttext synchronized">Classe para Validação de Produtos RFB na PO</p>
"! Autor: Jefferson Fujii
"! <br>Data: 09/08/2021
"!
CLASS zclmm_valida_rfb_po DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_badi_interface .
    INTERFACES if_ex_me_process_po_cust .
  PROTECTED SECTION.
  PRIVATE SECTION.

    CONSTANTS:
      "! <p class="shorttext synchronized">Cconstantes de Status</p>
      BEGIN OF gc_status,
        ativado    TYPE ze_status_rfb VALUE 'A',
        desativado TYPE ze_status_rfb VALUE 'D',
        rascunho   TYPE ze_status_rfb VALUE 'R',
      END OF gc_status,

      "! <p class="shorttext synchronized">Cconstantes de Mensagens</p>
      BEGIN OF gc_message,
        id      TYPE msgid VALUE 'ZMM_RFB',
        sucesso TYPE msgty VALUE 'S',
        erro    TYPE msgty VALUE 'E',
        n001    TYPE symsgno VALUE 001,
        n002    TYPE symsgno VALUE 002,
      END OF gc_message,

      "! <p class="shorttext synchronized">Cconstantes da tabela de Parâmetros</p>
      BEGIN OF gc_param,
        modulo  TYPE ztca_param_par-modulo VALUE 'MM',
        key1    TYPE ztca_param_par-chave1 VALUE 'CATALOGO_PRODUTO_RFB',
        key2    TYPE ztca_param_par-chave2 VALUE 'PEDIDO_COMPRAS',
        matorg  TYPE ztca_param_par-chave3 VALUE 'MATORG',
        ativado TYPE ztca_param_par-chave3 VALUE 'ATIVADO',
      END OF gc_param.


    "! <p class="shorttext synchronized">Método para seleção de Catálogos RFB</p>
    "! @parameter it_item | <p class="shorttext synchronized">Itens do Pedido</p>
    "! @parameter rt_rfb  | <p class="shorttext synchronized">Catálogo RFB</p>
    METHODS get_rfb IMPORTING it_item       TYPE tab_mepoitem
                    RETURNING VALUE(rt_rfb) TYPE zctgmm_catalogo_rfb.

    "! <p class="shorttext synchronized">Busca parâmetros</p>
    "! @parameter iv_key1  | <p class="shorttext synchronized">Parâmetro chave 1</p>
    "! @parameter iv_key2  | <p class="shorttext synchronized">Parâmetro chave 2</p>
    "! @parameter iv_key3  | <p class="shorttext synchronized">Parâmetro chave 3</p>
    "! @parameter et_range | <p class="shorttext synchronized">Parâmetro range</p>
    METHODS get_param IMPORTING iv_key1  TYPE ztca_param_par-chave1
                                iv_key2  TYPE ztca_param_par-chave2
                                iv_key3  TYPE ztca_param_par-chave3
                      EXPORTING et_range TYPE ANY TABLE.

ENDCLASS.



CLASS ZCLMM_VALIDA_RFB_PO IMPLEMENTATION.


  METHOD if_ex_me_process_po_cust~check.

    INCLUDE mm_messages_mac.

    DATA: lr_matorg   TYPE RANGE OF j_1bmatorg,
          lr_ativado  TYPE RANGE OF xfeld,
          lt_mepoitem TYPE tab_mepoitem.

    get_param( EXPORTING iv_key1  = gc_param-key1
                         iv_key2  = gc_param-key2
                         iv_key3  = gc_param-ativado
               IMPORTING et_range = lr_ativado ).

    IF abap_true NOT IN lr_ativado
    OR lr_ativado IS INITIAL.
      RETURN.
    ENDIF.

    get_param( EXPORTING iv_key1  = gc_param-key1
                         iv_key2  = gc_param-key2
                         iv_key3  = gc_param-matorg
               IMPORTING et_range = lr_matorg ).
    IF lr_matorg IS INITIAL.
      RETURN.
    ENDIF.

    DATA(ls_header) = im_header->get_data( ).
    DATA(lv_supplier) = |{ COND elifn( WHEN ls_header-lifnr IS NOT INITIAL THEN ls_header-lifnr ELSE ls_header-reswk ) ALPHA = OUT }|.
    DATA(lv_supplier_int) = |{ lv_supplier ALPHA = IN }|.

    DATA(lo_items) = im_header->get_items( ).
    LOOP AT lo_items ASSIGNING FIELD-SYMBOL(<fs_items>).
      DATA(ls_item) = <fs_items>-item->get_data( ).
      CHECK ls_item-j_1bmatorg IN lr_matorg.

      APPEND ls_item TO lt_mepoitem.
    ENDLOOP.

    DATA(lt_rfb) = get_rfb( lt_mepoitem ).

    LOOP AT lt_mepoitem INTO DATA(ls_mepoitem).
      READ TABLE lt_rfb INTO DATA(ls_rfb)
        WITH KEY material = ls_mepoitem-matnr
                 supplier = lv_supplier_int BINARY SEARCH.
      IF sy-subrc NE 0.
        READ TABLE lt_rfb INTO ls_rfb
          WITH KEY material = ls_mepoitem-matnr
                   supplier = space BINARY SEARCH.
      ENDIF.

      IF ls_rfb IS INITIAL.
*        message id &2 type &1 number &3 with &4 &5 &6 &7 into gl_dummy. "#EC MG_PAR_CNT
        mmpur_message_forced gc_message-erro gc_message-id gc_message-n001 ls_mepoitem-matnr space space space.
        ch_failed = abap_true.
      ENDIF.

      IF ls_rfb-supplier IS NOT INITIAL.
        DATA(lv_rfb_supplier) = |{ ls_rfb-supplier ALPHA = OUT }|.
        IF lv_rfb_supplier NE lv_supplier.
          mmpur_message_forced gc_message-erro gc_message-id gc_message-n002 ls_rfb-supplier ls_mepoitem-matnr space space.
          ch_failed = abap_true.
        ENDIF.
      ENDIF.

      FREE: ls_rfb.
    ENDLOOP.

  ENDMETHOD.


  METHOD if_ex_me_process_po_cust~close.
    RETURN.
  ENDMETHOD.


  METHOD if_ex_me_process_po_cust~fieldselection_header.
    RETURN.
  ENDMETHOD.


  METHOD if_ex_me_process_po_cust~fieldselection_header_refkeys.
    RETURN.
  ENDMETHOD.


  METHOD if_ex_me_process_po_cust~fieldselection_item.
    RETURN.
  ENDMETHOD.


  METHOD if_ex_me_process_po_cust~fieldselection_item_refkeys.
    RETURN.
  ENDMETHOD.


  METHOD if_ex_me_process_po_cust~initialize.
    RETURN.
  ENDMETHOD.


  METHOD if_ex_me_process_po_cust~open.
    RETURN.
  ENDMETHOD.


  METHOD if_ex_me_process_po_cust~post.
    RETURN.
  ENDMETHOD.


  METHOD if_ex_me_process_po_cust~process_account.
    RETURN.
  ENDMETHOD.


  METHOD if_ex_me_process_po_cust~process_header.
    RETURN.
  ENDMETHOD.


  METHOD if_ex_me_process_po_cust~process_item.
    RETURN.
  ENDMETHOD.


  METHOD if_ex_me_process_po_cust~process_schedule.
    RETURN.
  ENDMETHOD.


  METHOD get_rfb.

    IF it_item IS INITIAL.
      RETURN.
    ENDIF.

    SELECT idrfb,
           material,
           materialtype,
           supplier,
           status,
           datefrom,
           dateto
      FROM ztmm_catalogorfb
      INTO CORRESPONDING FIELDS OF TABLE @rt_rfb
      FOR ALL ENTRIES IN @it_item
      WHERE material EQ @it_item-matnr
        AND status   EQ @gc_status-ativado
        AND datefrom LE @sy-datum
        AND dateto   GE @sy-datum.
    SORT rt_rfb BY material supplier.

  ENDMETHOD.


  METHOD get_param.

    FREE et_range.

    DATA(lo_param) = zclca_tabela_parametros=>get_instance( ).          " INSERT - JWSILVA - 21.07.2023

    TRY.
        lo_param->m_get_range( EXPORTING iv_modulo = gc_param-modulo    " CHANGE - JWSILVA - 21.07.2023
                                         iv_chave1 = iv_key1
                                         iv_chave2 = iv_key2
                                         iv_chave3 = iv_key3
                               IMPORTING et_range  = et_range ).
      CATCH zcxca_tabela_parametros.
    ENDTRY.

  ENDMETHOD.
ENDCLASS.
