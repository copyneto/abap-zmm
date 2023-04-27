FUNCTION zfmmm_calculate_duo_date_miro.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(IV_BLINE_DATE) TYPE  BAPI_INCINV_CREATE_HEADER-BLINE_DATE
*"     VALUE(IV_PAYM_COND) TYPE  EKKO-ZTERM
*"  EXPORTING
*"     VALUE(EV_DUO_DATE) TYPE  INVFO-NETDT
*"----------------------------------------------------------------------
  DATA ls_T052 TYPE t052.
  DATA ls_faede TYPE faede.

  CONSTANTS:
    lc_credit TYPE faede-shkzg VALUE 'H',
    lc_koart  TYPE faede-koart VALUE 'K'.

  CALL FUNCTION 'FI_TERMS_OF_PAYMENT_PROPOSE'
    EXPORTING
      i_bldat         = iv_bline_date
      i_budat         = iv_bline_date
      i_zterm         = iv_paym_cond
    IMPORTING
      e_zbd1t         = ls_faede-zbd1t
      e_zbd2t         = ls_faede-zbd2t
      e_zbd3t         = ls_faede-zbd3t
      e_zfbdt         = ls_faede-zfbdt
    EXCEPTIONS
      terms_not_found = 1
      OTHERS          = 2.

  CHECK sy-subrc IS INITIAL.

  ls_faede-shkzg = lc_credit.
  ls_faede-koart = lc_koart.

  CALL FUNCTION 'DETERMINE_DUE_DATE'
    EXPORTING
      i_faede                    = ls_faede
    IMPORTING
      e_faede                    = ls_faede
    EXCEPTIONS
      account_type_not_supported = 1
      OTHERS                     = 2.

  IF sy-subrc IS INITIAL.
    ev_duo_date = ls_faede-netdt.
  ENDIF.
ENDFUNCTION.
