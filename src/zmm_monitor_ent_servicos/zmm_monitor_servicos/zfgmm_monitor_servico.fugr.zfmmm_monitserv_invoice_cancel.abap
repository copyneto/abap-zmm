FUNCTION zfmmm_monitserv_invoice_cancel.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(IV_INVOICEDOCNUMBER) TYPE  BAPI_INCINV_FLD-INV_DOC_NO
*"     VALUE(IV_FISCALYEAR) TYPE  BAPI_INCINV_FLD-FISC_YEAR
*"     VALUE(IV_REASONREVERSAL) TYPE  BAPI_INCINV_FLD-REASON_REV
*"     VALUE(IV_POSTINGDATE) TYPE  BAPI_INCINV_FLD-PSTNG_DATE OPTIONAL
*"  EXPORTING
*"     VALUE(EV_INVOICEDOCNUMBER_REVERSAL) TYPE
*"        BAPI_INCINV_FLD-INV_DOC_NO
*"     VALUE(EV_FISCALYEAR_REVERSAL) TYPE  BAPI_INCINV_FLD-FISC_YEAR
*"     VALUE(ET_RETURN) TYPE  BAPIRET2_T
*"----------------------------------------------------------------------
  DATA lt_return TYPE STANDARD TABLE OF bapiret2.

  CALL FUNCTION 'BAPI_INCOMINGINVOICE_CANCEL'
    EXPORTING
      invoicedocnumber          = iv_invoicedocnumber
      fiscalyear                = iv_fiscalyear
      reasonreversal            = iv_reasonreversal
      postingdate               = iv_postingdate
    IMPORTING
      invoicedocnumber_reversal = ev_invoicedocnumber_reversal
      fiscalyear_reversal       = ev_fiscalyear_reversal
    TABLES
      return                    = lt_return.

  et_return = CORRESPONDING #( lt_return ).

  IF NOT line_exists( lt_return[ type = zclmm_lanc_servicos=>gc_error ] ).
    CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'.
  ENDIF.

ENDFUNCTION.
