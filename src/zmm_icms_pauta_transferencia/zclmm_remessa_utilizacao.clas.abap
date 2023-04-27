class ZCLMM_REMESSA_UTILIZACAO definition
  public
  final
  create public .

public section.

  interfaces IF_BADI_INTERFACE .
  interfaces IF_EX_LE_SHP_TAB_CUST_ITEM .
protected section.
private section.
ENDCLASS.



CLASS ZCLMM_REMESSA_UTILIZACAO IMPLEMENTATION.


  method IF_EX_LE_SHP_TAB_CUST_ITEM~ACTIVATE_TAB_PAGE.

    ef_caption = 'Campos Personalizados'.
    ef_program = 'SAPLZFGMM_REMESSA_UTILIZACAO'.
    ef_dynpro  = '9001'.

  endmethod.


  method IF_EX_LE_SHP_TAB_CUST_ITEM~PASS_FCODE_TO_SUBSCREEN.
  endmethod.


  METHOD if_ex_le_shp_tab_cust_item~transfer_data_from_subscreen.
    CALL FUNCTION 'ZFMMM_GET_REMESSA_UTILIZACAO_V'
      EXPORTING
        iv_type = if_trtyp
      IMPORTING
        es_lips = cs_lips.

  ENDMETHOD.


  METHOD if_ex_le_shp_tab_cust_item~transfer_data_to_subscreen.
    CALL FUNCTION 'ZFMMM_SET_REMESSA_UTILIZACAO_V'
      EXPORTING
        is_lips = is_lips
        iv_type = if_trtyp.

  ENDMETHOD.
ENDCLASS.
