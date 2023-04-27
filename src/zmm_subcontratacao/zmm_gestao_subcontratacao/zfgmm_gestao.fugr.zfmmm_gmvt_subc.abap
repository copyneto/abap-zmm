FUNCTION zfmmm_gmvt_subc.
*"----------------------------------------------------------------------
*"*"Módulo função atualização:
*"
*"*"Interface local:
*"  IMPORTING
*"     VALUE(IS_MSEG) TYPE  MSEG OPTIONAL
*"     VALUE(IV_CHARG) TYPE  CHARG_D OPTIONAL
*"----------------------------------------------------------------------

  DATA: ls_gmvt_header TYPE          bapi2017_gm_head_01,
        ls_gmvt_code   TYPE          bapi2017_gm_code,
        lt_gmvt_item   TYPE TABLE OF bapi2017_gm_item_create,
        lt_gmvt_return TYPE TABLE OF bapiret2.

  ls_gmvt_header-pstng_date   = sy-datum.
  ls_gmvt_header-doc_date     = sy-datum.

  ls_gmvt_code-gm_code        = '03'.

  APPEND INITIAL LINE TO lt_gmvt_item ASSIGNING FIELD-SYMBOL(<fs_gmvt_item>).
  <fs_gmvt_item>-material     = is_mseg-matnr.
  <fs_gmvt_item>-plant        = is_mseg-werks.
  <fs_gmvt_item>-stge_loc     = is_mseg-lgort.
  <fs_gmvt_item>-batch        = iv_charg.
  <fs_gmvt_item>-move_type    = 'Z20'.
  <fs_gmvt_item>-entry_qnt    = is_mseg-erfmg.

  CALL FUNCTION 'BAPI_GOODSMVT_CREATE'
    EXPORTING
      goodsmvt_header = ls_gmvt_header
      goodsmvt_code   = ls_gmvt_code
    TABLES
      goodsmvt_item   = lt_gmvt_item
      return          = lt_gmvt_return.

  IF line_exists( lt_gmvt_return[ type = 'E' ] ).

  ELSE.

    CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
      EXPORTING
        wait = 'X'.

  ENDIF.

ENDFUNCTION.
