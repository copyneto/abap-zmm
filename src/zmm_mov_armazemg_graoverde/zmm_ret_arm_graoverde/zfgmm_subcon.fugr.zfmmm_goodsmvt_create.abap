FUNCTION zfmmm_goodsmvt_create.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(IS_GOODSMVT_HEADER) LIKE  BAPI2017_GM_HEAD_01 STRUCTURE
*"        BAPI2017_GM_HEAD_01
*"     VALUE(IS_GOODSMVT_CODE) LIKE  BAPI2017_GM_CODE STRUCTURE
*"        BAPI2017_GM_CODE
*"  EXPORTING
*"     VALUE(ES_MATERIALDOCUMENT) TYPE  BAPI2017_GM_HEAD_RET-MAT_DOC
*"     VALUE(ES_MATDOCUMENTYEAR) TYPE  BAPI2017_GM_HEAD_RET-DOC_YEAR
*"  TABLES
*"      GOODSMVT_ITEM STRUCTURE  BAPI2017_GM_ITEM_CREATE
*"      RETURN STRUCTURE  BAPIRET2
*"----------------------------------------------------------------------

  CALL FUNCTION 'BAPI_GOODSMVT_CREATE'
    EXPORTING
      goodsmvt_header  = is_goodsmvt_header
      goodsmvt_code    = is_goodsmvt_code
    IMPORTING
      materialdocument = es_materialdocument
      matdocumentyear  = es_matdocumentyear
    TABLES
      goodsmvt_item    = goodsmvt_item
      return           = return.

  IF es_materialdocument IS NOT INITIAL.
    CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
      EXPORTING
        wait = abap_true.
  ENDIF.

ENDFUNCTION.
