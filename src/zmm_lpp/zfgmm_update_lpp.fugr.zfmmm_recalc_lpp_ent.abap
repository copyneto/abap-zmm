FUNCTION ZFMMM_RECALC_LPP_ENT.
*"----------------------------------------------------------------------
*"*"Módulo função atualização:
*"
*"*"Interface local:
*"  IMPORTING
*"     VALUE(IV_DOCNUM) TYPE  J_1BDOCNUM OPTIONAL
*"     VALUE(IV_DOCNUMBER) TYPE  J_1BDOCNUM OPTIONAL
*"     VALUE(IV_TCODE) TYPE  TCODE OPTIONAL
*"     VALUE(IT_MKPF) TYPE  TY_T_MKPF OPTIONAL
*"----------------------------------------------------------------------
  CONSTANTS gc_migo TYPE tcode VALUE 'MIGO'.

  WAIT UP TO 2 SECONDS.

  IF iv_tcode EQ gc_migo.

    DATA(ls_mkpf) = VALUE #( it_mkpf[ 1 ] OPTIONAL ).

    IF ls_mkpf IS NOT INITIAL.

      DATA(lv_key) = ls_mkpf-mblnr && ls_mkpf-mjahr.

      IF lv_key IS NOT INITIAL.

        SELECT SINGLE br_notafiscal FROM I_BR_NFItem
        WHERE br_nfsourcedocumentnumber = @lv_key
        INTO @DATA(lv_nf).

        IF lv_nf IS NOT INITIAL.

          NEW zclmm_transf_lpp( )->recalc_lpp( iv_docnum = lv_nf
                                               iv_update = abap_true ).

        ENDIF.

      ENDIF.

    ENDIF.

  ELSE.

    SELECT SINGLE b~docref
      FROM j_1bnfdoc AS a
      INNER JOIN j_1blpp AS b
      ON a~docref = b~docref
     WHERE a~docnum = @iv_docnumber
      INTO @DATA(ls_result).

    IF ls_result IS NOT INITIAL.

      NEW zclmm_transf_lpp( )->recalc_lpp( iv_docnum = iv_docnum
                                           iv_update = abap_true ).

    ENDIF.

  ENDIF.


ENDFUNCTION.
