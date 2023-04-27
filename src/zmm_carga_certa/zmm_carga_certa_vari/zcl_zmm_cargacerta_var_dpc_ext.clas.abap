class ZCL_ZMM_CARGACERTA_VAR_DPC_EXT definition
  public
  inheriting from ZCL_ZMM_CARGACERTA_VAR_DPC
  create public .

public section.
protected section.

  methods VARIANTE_DELETE_ENTITY
    redefinition .
private section.
ENDCLASS.



CLASS ZCL_ZMM_CARGACERTA_VAR_DPC_EXT IMPLEMENTATION.


  method VARIANTE_DELETE_ENTITY.
**TRY.
*CALL METHOD SUPER->VARIANTE_DELETE_ENTITY
*  EXPORTING
*    IV_ENTITY_NAME          =
*    IV_ENTITY_SET_NAME      =
*    IV_SOURCE_NAME          =
*    IT_KEY_TAB              =
**    io_tech_request_context =
*    IT_NAVIGATION_PATH      =
*    .
**  CATCH /iwbep/cx_mgw_busi_exception.
**  CATCH /iwbep/cx_mgw_tech_exception.
**ENDTRY.

       DATA: lt_keys   TYPE /IWBEP/T_MGW_TECH_PAIRS,
          ls_key    TYPE /IWBEP/S_MGW_TECH_PAIR,
          lv_report type ztplanlog_vari-report,
          lv_vari type ztplanlog_vari-vari,
          lv_field type ztplanlog_vari-field,
          lv_cont type ztplanlog_vari-cont.

    lt_keys = IO_TECH_REQUEST_CONTEXT->GET_KEYS( ).

    READ TABLE lt_keys with key name = 'REPORT' INTO ls_key.
    lv_report = ls_key-value.
    READ TABLE lt_keys with key name = 'VARI' INTO ls_key.
    lv_vari = ls_key-value.
    READ TABLE lt_keys with key name = 'CONT' INTO ls_key.
    lv_cont = ls_key-value.

    DELETE FROM ztplanlog_vari WHERE report = lv_report
    and vari = lv_Vari
    and cont = lv_Cont.
  endmethod.
ENDCLASS.
