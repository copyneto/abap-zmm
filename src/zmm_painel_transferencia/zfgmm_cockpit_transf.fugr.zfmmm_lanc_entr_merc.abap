FUNCTION zfmmm_lanc_entr_merc.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(IS_GOODSMVT_HEADER) LIKE  BAPI2017_GM_HEAD_01 STRUCTURE
*"        BAPI2017_GM_HEAD_01
*"     VALUE(IV_GOODSMVT_CODE) LIKE  BAPI2017_GM_CODE STRUCTURE
*"        BAPI2017_GM_CODE
*"  EXPORTING
*"     VALUE(ES_GOODSMVT_HEADRET) LIKE  BAPI2017_GM_HEAD_RET STRUCTURE
*"        BAPI2017_GM_HEAD_RET
*"     VALUE(EV_MATERIALDOCUMENT) TYPE  BAPI2017_GM_HEAD_RET-MAT_DOC
*"     VALUE(EV_MATDOCUMENTYEAR) TYPE  BAPI2017_GM_HEAD_RET-DOC_YEAR
*"  TABLES
*"      IT_GOODSMVT_ITEM STRUCTURE  BAPI2017_GM_ITEM_CREATE
*"      ET_RETURN STRUCTURE  BAPIRET2
*"----------------------------------------------------------------------

  CALL FUNCTION 'BAPI_GOODSMVT_CREATE'
    EXPORTING
      goodsmvt_header  = is_goodsmvt_header
      goodsmvt_code    = iv_goodsmvt_code
    IMPORTING
      goodsmvt_headret = es_goodsmvt_headret
      materialdocument = ev_materialdocument
      matdocumentyear  = ev_matdocumentyear
    TABLES
      goodsmvt_item    = it_goodsmvt_item
      return           = et_return.

  SORT et_return BY type.

  READ TABLE et_return TRANSPORTING NO FIELDS
    WITH KEY type = 'E' BINARY SEARCH.
  IF sy-subrc NE 0.
    CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
      EXPORTING
        wait = abap_true.

    APPEND VALUE #( type = 'S' id = 'M7' number = '060' message_v1 = |{ ev_materialdocument }/{ ev_matdocumentyear }| ) TO et_return.
  ENDIF.

ENDFUNCTION.
