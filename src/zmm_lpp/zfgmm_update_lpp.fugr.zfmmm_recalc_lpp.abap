FUNCTION zfmmm_recalc_lpp.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(IV_DOCNUM) TYPE  J_1BDOCNUM OPTIONAL
*"     VALUE(IV_DOCNUMBER) TYPE  J_1BDOCNUM OPTIONAL
*"----------------------------------------------------------------------

  DO 20 TIMES. " Necessário aguardar o documento ser estornado, caso libere em uma das tentativas, possui uma condição de saída do LOOP
    SELECT SINGLE docnum,
                  cancel
      FROM j_1bnfdoc
     WHERE docnum = @iv_docnum
      INTO @DATA(ls_doc).

    IF sy-subrc      IS INITIAL
   AND ls_doc-cancel EQ abap_true.
      EXIT.
    ELSE.
      WAIT UP TO 1 SECONDS.
    ENDIF.
  ENDDO.

  SELECT SINGLE b~docref
    FROM j_1bnfdoc AS a
   INNER JOIN j_1blpp AS b ON a~docref = b~docref
*   WHERE a~docnum = @iv_docnumber
   WHERE a~docnum = @iv_docnum
    INTO @DATA(ls_result).

  IF sy-subrc IS INITIAL.
    NEW zclmm_transf_lpp( )->recalc_lpp_itens( iv_docnum = iv_docnum
                                               iv_update = abap_true ).
  ENDIF.

ENDFUNCTION.
