FUNCTION zfmmm_revers_contabiliz.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(I_BKDF) LIKE  BKDF STRUCTURE  BKDF
*"     VALUE(I_UF05A) LIKE  UF05A STRUCTURE  UF05A
*"     VALUE(I_XVBUP) LIKE  OFIWA-XVBUP DEFAULT 'X'
*"  TABLES
*"      T_AUSZ1 STRUCTURE  AUSZ1 OPTIONAL
*"      T_AUSZ2 STRUCTURE  AUSZ2 OPTIONAL
*"      T_AUSZ3 STRUCTURE  AUSZ_CLR OPTIONAL
*"      T_BKP1 STRUCTURE  BKP1
*"      T_BKPF STRUCTURE  BKPF
*"      T_BSEC STRUCTURE  BSEC
*"      T_BSED STRUCTURE  BSED
*"      T_BSEG STRUCTURE  BSEG
*"      T_BSET STRUCTURE  BSET
*"      T_BSEU STRUCTURE  BSEU
*"----------------------------------------------------------------------

  IF t_bkpf[] IS NOT INITIAL.

    DATA(ls_bkpk) = t_bkpf[ 1 ].

    IF ls_bkpk-stblg IS NOT INITIAL
   AND ls_bkpk-stjah IS NOT INITIAL.

      SELECT *
        FROM ztmm_mov_cntrl
       WHERE belnr    = @ls_bkpk-stblg
         AND bukrs_dc = @ls_bkpk-bukrs
         AND gjahr_dc = @ls_bkpk-stjah
        INTO @DATA(ls_mov_cntrl)
          UP TO 1 ROWS.
      ENDSELECT.

      IF sy-subrc IS INITIAL
     AND ls_mov_cntrl-etapa = '4'.
        CLEAR: ls_mov_cntrl-belnr,
               ls_mov_cntrl-bukrs_dc,
               ls_mov_cntrl-gjahr_dc.

        ls_mov_cntrl-status3   = 'E'.
        ls_mov_cntrl-belnr_est = ls_bkpk-belnr.
        ls_mov_cntrl-gjahr_est = ls_bkpk-gjahr.
        ls_mov_cntrl-bldat_est = ls_bkpk-bldat.
        ls_mov_cntrl-etapa     = '3'.

        MODIFY ztmm_mov_cntrl FROM ls_mov_cntrl.

      ENDIF.
    ENDIF.
  ENDIF.

ENDFUNCTION.
