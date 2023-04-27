FUNCTION zfmmm_cancel_mat.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(IV_MBLNR) TYPE  MBLNR
*"     VALUE(IV_MJAHR) TYPE  MJAHR
*"  EXPORTING
*"     VALUE(ES_HEAD) TYPE  BAPI2017_GM_HEAD_RET
*"----------------------------------------------------------------------
  CONSTANTS gc_erro TYPE c VALUE 'E'.

  DATA: lt_return TYPE STANDARD TABLE OF bapiret2.

  CALL FUNCTION 'BAPI_GOODSMVT_CANCEL'
    EXPORTING
      materialdocument    = iv_mblnr
      matdocumentyear     = iv_mjahr
      goodsmvt_pstng_date = sy-datum
      goodsmvt_pr_uname   = sy-uname
    IMPORTING
      goodsmvt_headret    = es_head
    TABLES
      return              = lt_return.

  IF NOT line_exists( lt_return[ type = gc_erro ] ).

    CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
      EXPORTING
        wait = abap_true.

  ENDIF.


ENDFUNCTION.
