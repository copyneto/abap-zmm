class ZCLMM_PO_BENNER definition
  public
  final
  create public .

public section.

  interfaces IF_BADI_INTERFACE .
  interfaces IF_EX_ME_BAPI_PO_CREATE_02 .
protected section.
private section.
ENDCLASS.



CLASS ZCLMM_PO_BENNER IMPLEMENTATION.


  METHOD if_ex_me_bapi_po_create_02~extensionin.
    RETURN.
  ENDMETHOD.


  METHOD if_ex_me_bapi_po_create_02~extensionout.
    RETURN.
  ENDMETHOD.


  METHOD if_ex_me_bapi_po_create_02~inbound.
    RETURN.
  ENDMETHOD.


  METHOD if_ex_me_bapi_po_create_02~map2e_extensionout.
    RETURN.
  ENDMETHOD.


  METHOD if_ex_me_bapi_po_create_02~map2i_extensionin.
    RETURN.
  ENDMETHOD.


  METHOD if_ex_me_bapi_po_create_02~outbound.
    RETURN.
  ENDMETHOD.


  METHOD if_ex_me_bapi_po_create_02~partners_on_item_active.
    RETURN.
  ENDMETHOD.


  METHOD if_ex_me_bapi_po_create_02~text_output.

    DATA: lv_btext TYPE char1,
          lv_id    TYPE char7.

    lv_id    = 'ZBENNER'.
    lv_btext = abap_true.

    " Impor da classe ZCLMM_ARGO_PEDIDO_COMPRA~CALL_BAPI
    IMPORT lv_btext TO lv_btext FROM MEMORY ID lv_id.

    IF sy-subrc IS INITIAL
    AND lv_btext IS NOT INITIAL.
      ch_no_header_text = abap_true.
      ch_no_item_text   = abap_true.
    ENDIF.

  ENDMETHOD.


  METHOD if_ex_me_bapi_po_create_02~toggle_order_unit.
    RETURN.
  ENDMETHOD.
ENDCLASS.
