FUNCTION zfmmm_gn_delivery_create.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(IS_VBSK_I) TYPE  VBSK OPTIONAL
*"     VALUE(IV_NO_COMMIT) TYPE  RVSEL-XFELD DEFAULT ' '
*"     VALUE(IV_VBLS_POS_RUECK) TYPE  RVSEL-XFELD DEFAULT ' '
*"     VALUE(IV_IF_NO_DEQUE) TYPE  XFELD DEFAULT SPACE
*"     VALUE(IV_IF_NO_PARTNER_DIALOG) TYPE  XFELD DEFAULT 'X'
*"     VALUE(IT_XKOMDLGN) TYPE  SHP_KOMDLGN_T OPTIONAL
*"     VALUE(IT_XVBLS) TYPE  VBLS_T OPTIONAL
*"     VALUE(IT_GN_PARTNER) TYPE  PARTNER_GN_T OPTIONAL
*"     VALUE(IV_TXSDC) TYPE  J_1BTXSDC_ OPTIONAL
*"  EXPORTING
*"     VALUE(ET_XVBFS) TYPE  VBFS_T
*"     VALUE(ET_LIPS) TYPE  TAB_LIPS
*"----------------------------------------------------------------------

  CONSTANTS: lc_error TYPE sy-msgty VALUE 'E'.

  gv_txsdc =  iv_txsdc.


  if gv_txsdc is not INITIAL.
     select OUT_MWSKZ up to 1 rows
       from J_1BT007
       into @data(lv_OUT_MWSKZ)
       where SD_MWSKZ = @gv_txsdc.
     ENDSELECT.

     CHECK sy-subrc = 0.

     select SINGLE J_1BTAXLW1
      from T007A
      into gv_J_1BTAXLW1
      where KALSM = 'TAXBRA'
        and MWSKZ = lv_OUT_MWSKZ.
  endif.

  CALL FUNCTION 'GN_DELIVERY_CREATE'
    EXPORTING
      vbsk_i               = is_vbsk_i
      no_commit            = iv_no_commit
      vbls_pos_rueck       = iv_vbls_pos_rueck
      if_no_deque          = iv_if_no_deque
      if_no_partner_dialog = iv_if_no_partner_dialog
    TABLES
      xkomdlgn             = it_xkomdlgn
      xvbfs                = et_xvbfs
      xvbls                = it_xvbls
      xxlips               = et_lips
      it_gn_partner        = it_gn_partner.

  SORT et_xvbfs BY msgty.

  READ TABLE et_xvbfs ASSIGNING FIELD-SYMBOL(<fs_xvbfs>)
                                    WITH KEY msgty = lc_error
                                    BINARY SEARCH.
  IF sy-subrc IS NOT INITIAL.

    CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
      EXPORTING
        wait = abap_true.

  ENDIF.

ENDFUNCTION.
