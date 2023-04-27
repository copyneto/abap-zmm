FUNCTION zfmmm_lm_goods_movement.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(IV_BITYPE) TYPE  CHAR1 DEFAULT 'E'
*"     VALUE(IV_WADAT_IST) LIKE  LIKP-WADAT_IST OPTIONAL
*"     VALUE(IV_FLAG_INBOUND) TYPE  CHAR1 DEFAULT SPACE
*"  EXPORTING
*"     VALUE(EV_SUCCESS_COUNT) TYPE  I
*"     VALUE(EV_ERROR_COUNT) TYPE  I
*"     VALUE(EV_SUBRC) TYPE  CHAR1
*"  TABLES
*"      CT_WORKTAB STRUCTURE  LIPOV
*"      ET_SUCCESS STRUCTURE  LIPOV
*"      ET_ERROR STRUCTURE  LIPOV
*"      ET_TVST STRUCTURE  TVST OPTIONAL
*"      ET_VBFS STRUCTURE  VBFS OPTIONAL
*"  EXCEPTIONS
*"      NO_PERMISSION
*"----------------------------------------------------------------------


  CALL FUNCTION 'WS_LM_GOODS_MOVEMENT'
    EXPORTING
      if_bitype        = iv_bitype
      if_wadat_ist     = iv_wadat_ist
      if_flag_inbound  = iv_flag_inbound
    IMPORTING
      ef_success_count = ev_success_count
      ef_error_count   = ev_error_count
    TABLES
      ct_worktab       = ct_worktab
      et_success       = et_success
      et_error         = et_error
      et_tvst          = et_tvst
      et_vbfs          = et_vbfs
    EXCEPTIONS
      no_permission    = 1
      OTHERS           = 2.

  ev_subrc = sy-subrc.

ENDFUNCTION.
