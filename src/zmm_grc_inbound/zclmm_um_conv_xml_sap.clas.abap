CLASS zclmm_um_conv_xml_sap DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_badi_interface .
    INTERFACES if_j_1bnfe_in .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zclmm_um_conv_xml_sap IMPLEMENTATION.


  METHOD if_j_1bnfe_in~unit_conversion.

    INCLUDE zmmi_um_conv_xml_sap IF FOUND.

  ENDMETHOD.
  METHOD if_j_1bnfe_in~change_sloc_and_valtype.
    RETURN.
  ENDMETHOD.

  METHOD if_j_1bnfe_in~check_invoice.
    RETURN.
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

ENDCLASS.
