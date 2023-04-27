class ZCLMM_AMOSTRA_GRATIS definition
  public
  final
  create public .

public section.

  interfaces IF_BADI_INTERFACE .
  interfaces IF_EX_ME_PROCESS_PO_CUST .
protected section.
private section.
ENDCLASS.



CLASS ZCLMM_AMOSTRA_GRATIS IMPLEMENTATION.


  method IF_EX_ME_PROCESS_PO_CUST~CHECK.
  endmethod.


  method IF_EX_ME_PROCESS_PO_CUST~CLOSE.
  endmethod.


  method IF_EX_ME_PROCESS_PO_CUST~FIELDSELECTION_HEADER.
  endmethod.


  method IF_EX_ME_PROCESS_PO_CUST~FIELDSELECTION_HEADER_REFKEYS.
  endmethod.


  method IF_EX_ME_PROCESS_PO_CUST~FIELDSELECTION_ITEM.
  endmethod.


  method IF_EX_ME_PROCESS_PO_CUST~FIELDSELECTION_ITEM_REFKEYS.
  endmethod.


  method IF_EX_ME_PROCESS_PO_CUST~INITIALIZE.
  endmethod.


  method IF_EX_ME_PROCESS_PO_CUST~OPEN.
  endmethod.


  METHOD IF_EX_ME_PROCESS_PO_CUST~POST.

    DATA lt_items TYPE purchase_order_items.
    DATA ls_item TYPE mepoitem.

    "Recupera referência dos itens da PO
    lt_items = im_header->get_items( ).

    LOOP AT lt_items INTO DATA(lr_item). "#EC CI_LOOP_INTO_WA
      "Recupera referência do Item
      ls_item = lr_item-item->get_data( ).

      "MEPOITEM-UMSON for diferente de branco
      CHECK ls_item-umson IS NOT INITIAL.
      "limpar o campo MEPOITEM-BSTAE
      CLEAR ls_item-bstae.

      lr_item-item->set_data( im_data = ls_item ).

    ENDLOOP.

  ENDMETHOD.


  method IF_EX_ME_PROCESS_PO_CUST~PROCESS_ACCOUNT.
  endmethod.


  method IF_EX_ME_PROCESS_PO_CUST~PROCESS_HEADER.
  endmethod.


  method IF_EX_ME_PROCESS_PO_CUST~PROCESS_ITEM.
  endmethod.


  method IF_EX_ME_PROCESS_PO_CUST~PROCESS_SCHEDULE.
  endmethod.
ENDCLASS.
