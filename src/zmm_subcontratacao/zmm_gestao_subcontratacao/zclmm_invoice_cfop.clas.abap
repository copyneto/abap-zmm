class ZCLMM_INVOICE_CFOP definition
  public
  final
  create public .

public section.

  interfaces IF_BADI_INTERFACE .
  interfaces IF_J_1BNFE_IN .
protected section.
private section.
ENDCLASS.



CLASS ZCLMM_INVOICE_CFOP IMPLEMENTATION.


  METHOD if_j_1bnfe_in~change_sloc_and_valtype.
    RETURN.
  ENDMETHOD.


  METHOD if_j_1bnfe_in~check_invoice.

    DATA lv_access TYPE /xnfe/id.

    lv_access = |{ i_access_key-regio }| & |{ i_access_key-nfyear }| & |{ i_access_key-nfmonth }|
                & |{ i_access_key-stcd1 }| & |{ i_access_key-model }| & |{ i_access_key-serie }|
                 & |{ i_access_key-nfnum9 }| & |{ i_access_key-docnum9 }| & |{ i_access_key-cdv }| .

    DATA(lo_guid16) = zclmm_atualiza_cfop=>get_instance( ).
    lo_guid16->save_guid16( lv_access ).

  ENDMETHOD.


  METHOD if_j_1bnfe_in~inbound_deliv_change_header.
    RETURN.
  ENDMETHOD.


  METHOD if_j_1bnfe_in~inbound_deliv_delete_check.
    RETURN.
  ENDMETHOD.


  METHOD if_j_1bnfe_in~inbound_deliv_search.
    RETURN.
  ENDMETHOD.


  METHOD if_j_1bnfe_in~material_conversion.
    RETURN.
  ENDMETHOD.


  METHOD if_j_1bnfe_in~set_ekpo_buffer_refresh.
    RETURN.
  ENDMETHOD.


  METHOD if_j_1bnfe_in~unit_conversion.
    RETURN.
  ENDMETHOD.
ENDCLASS.
